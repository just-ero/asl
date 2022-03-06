state("Strobophagia") {}

startup
{
	vars.Log = (Action<object>)((output) => print("[Strobophagia] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");

	dynamic[,] _settings =
	{
		{ "SPLITS", "stage-Beginning", "FOOLS' BEACH.", false },
		{ "SPLITS", "flag-21", "VOLUME.", false },
		{ "SPLITS", "stage-EnteredCult", "I AM WILLING.", false },
		{ "SPLITS", "stage-Initiation", "INITIATE.", false },
		{ "SPLITS", "stage-HumanLabyrinth", "DA3DALUS.", false },
		{ "SPLITS", "stage-RitesStarted", "SAMADHI.", true },
		{ "SPLITS", "flag-24", "NAX-05", false },
		{ "SPLITS", "flag-1", "GNOSIS.", true },
		{ "SPLITS", "flag-4", "Liber::MASS", false },
		{ "SPLITS", "flag-3", "SIGIL", true },
		{ "SPLITS", "flag-22", "SERVITOR", true },
		{ "SPLITS", "stage-Cave", "CAVE", false }
	};

	settings.Add("SPLITS");

	for (int i = 0; i < _settings.GetLength(0); ++i)
	{
		string parent = _settings[i, 0];
		string id     = _settings[i, 1];
		string desc   = _settings[i, 2];
		bool   state  = _settings[i, 3];

		settings.Add(id, state, desc, parent);
	}

	vars.DoneFlags = new List<int>();
}

onStart
{
	vars.DoneFlags.Clear();
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		// var list = helper.GetClass("mscorlib", "List`1");

		// CustomSceneManager
		var csm = helper.GetClass("Assembly-CSharp", "CustomSceneManager");
		var hs = helper.GetClass("Assembly-CSharp", "HubStageSO");

		vars.Unity.Make<bool>(csm.Static, csm["Instance"], csm["scenesLoading"]).Name = "scenesLoading";
		vars.Unity.MakeString(csm.Static, csm["Instance"], csm["activeStage"], hs["myName"]).Name = "stage";

		// ProgressTracker
		var pt = helper.GetClass("Assembly-CSharp", "ProgressTracker", 1);
		var pd = helper.GetClass("Assembly-CSharp", "ProgressData");

		vars.Unity.MakeList<int>(pt.Static, 0x10, pt["progressData"], pd["flags"]).Name = "flags";
		vars.Unity["flags"].Offsets = new[] { 0x18, 0x10 };

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.Loading = vars.Unity["scenesLoading"].Current;
	current.Stage = vars.Unity["stage"].Current;
	current.Flags = vars.Unity["flags"].Current;
}

start
{
	return old.Stage == "Main" && current.Stage != "Main";
}

split
{
	if (old.Stage != current.Stage)
		return settings["stage-" + current.Stage];

	if (!old.Loading && current.Loading)
		return current.Stage == "Exit";

	if (old.Flags.Count != current.Flags.Count) return;

	foreach (var flag in current.Flags)
	{
		if (vars.DoneFlags.Contains(flag))
			continue;

		vars.DoneFlags.Add(flag);
		if (settings["flag-" + flag])
			return true;
	}
}

reset
{
	return old.Stage != "Main" && current.Stage == "Main";
}

isLoading
{
	return current.Loading;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}