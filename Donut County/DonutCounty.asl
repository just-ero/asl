state("DonutCounty") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Donut County] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.CompletedSplits = new HashSet<int>();

	dynamic[,] _settings =
	{
		{ "splits", "mira", "Mira's House", true },
			{ "mira", "0", "Goose on a Scooter", false },
			{ "mira", "1", "BK talking to Mira", true },

		{ "splits", "2", "Potter's Rock", true },
		{ "splits", "3", "Ranger Station", true },
		{ "splits", "4", "Riverbed", true },
		{ "splits", "5", "Campground", true },
		{ "splits", "6", "Hopper Springs", true },
		{ "splits", "7", "Joshua Tree", true },
		{ "splits", "8", "Beach Lot C", true },
		{ "splits", "9", "Gecko Park", true },
		{ "splits", "10", "Chicken Barn", true },
		{ "splits", "11", "Honey Nut Forest", true },
		{ "splits", "12", "Cat Soup", true },
		{ "splits", "13", "Donut Shop", true },
		{ "splits", "14", "Abandoned House", true },
		{ "splits", "15", "Raccoon Lagoon", true },
		{ "splits", "16", "The 405", true },
		{ "splits", "17", "Above Donut County", false },
		{ "splits", "18", "Raccoon HQ Exterior", false },
		{ "splits", "20", "Biology Lab", true },
		{ "splits", "22", "Anthropology Lab", true },
		{ "splits", "24", "Trash King's Office", false }
	};

	settings.Add("splits", true, "Split after completing levels:");

	for (int i = 0; i < _settings.GetLength(0); ++i)
	{
		string parent = _settings[i, 0];
		string id     = _settings[i, 1];
		string desc   = _settings[i, 2];
		bool   state  = _settings[i, 3];

		settings.Add(id, state, desc, parent);
	}
}

onStart
{
	vars.CompletedSplits.Clear();
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var rm = helper.GetClass("Assembly-CSharp", "RM");
		var sm = helper.GetClass("Assembly-CSharp", "SceneManager");
		var ls = helper.GetClass("Assembly-CSharp", "LevelSettings");
		var d = helper.GetClass("Assembly-CSharp", "OS1Delivery");
		var t = helper.GetClass("Assembly-CSharp", "Tornado");

		vars.Unity.MakeString(rm.Static, rm["sceneManager"], sm["nextLevel"]).Name = "nextLevel";
		vars.Unity.Make<bool>(rm.Static, rm["sceneManager"], sm["loading"]).Name = "loading";
		vars.Unity.Make<bool>(rm.Static, rm["sceneManager"], sm["_isLoadingScene"]).Name = "loadingScene";
		vars.Unity.Make<int>(rm.Static, rm["levelSettings"], ls["deliveryData"], d["index"]).Name = "levelIndex";
		vars.Unity.Make<int>(rm.Static, rm["tornado"], t["_numDestructables"]).Name = "tornadoDestructables";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.Scene = vars.Unity["nextLevel"].Current;
	current.Loading = vars.Unity["loading"].Current;
	current.LoadingScene = vars.Unity["loadingScene"].Current;
	current.LevelIndex = vars.Unity["levelIndex"].Current;
	current.TornadoDestructables = vars.Unity["tornadoDestructables"].Current;
}

start
{
	return old.Scene != current.Scene &&
	       old.Scene == "titlescreen" &&
	       current.Scene != "scn_credits";
}

split
{
	if (old.LevelIndex != current.LevelIndex && !vars.CompletedSplits.Contains(old.LevelIndex))
	{
		vars.CompletedSplits.Add(old.LevelIndex);
		return settings[old.LevelIndex.ToString()];
	}

	return old.TornadoDestructables == 3 && current.TornadoDestructables == 4;
}

isLoading
{
	return current.Loading || current.LoadingScene;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}