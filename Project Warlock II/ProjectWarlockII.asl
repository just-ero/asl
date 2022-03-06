state("Project Warlock 2 Demo") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Project Warlock II] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");

	settings.Add("keys", false, "Split when collecting a key");
}

onStart
{
	vars.TimeBetweenDeaths = TimeSpan.Zero
}

init
{
	vars.TimeBetweenDeaths = TimeSpan.Zero;

	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var pm = helper.GetClass("Assembly-CSharp", "PlayerManager");
		var gsm = helper.GetClass("Assembly-CSharp", "GamestateManager");
		var tc = helper.GetClass("Assembly-CSharp", "GamestateManager");
		var pum = helper.GetClass("Assembly-CSharp", "PickupManager");

		vars.Unity.Make<bool>(pm.Static, pm["instance"], pm["gamestateManager"], gsm["demoEnd"]).Name = "demoEnd";
		vars.Unity.Make<int>(pm.Static, pm["instance"], pm["gamestateManager"], gsm["gamestate"]).Name = "gamestate";
		vars.Unity.Make<float>(pm.Static, pm["instance"], pm["gamestateManager"], gsm["timeManager"], tc["seconds"]).Name = "seconds";
		vars.Unity.Make<int>(pm.Static, pm["instance"], pm["gamestateManager"], gsm["timeManager"], tc["minutes"]).Name = "minutes";
		vars.Unity.Make<int>(pm.Static, pm["instance"], pm["gamestateManager"], gsm["timeManager"], tc["hours"]).Name = "hours";
		vars.Unity.Make<bool>(pm.Static, pm["instance"], pm["gamestateManager"], gsm["timeManager"], tc["started"]).Name = "started";
		vars.Unity.MakeArray<bool>(pm.Static, pm["instance"], pm["pickupManager"], pum["pickedUpKeys"]).Name = "keys";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.DemoEnd = vars.Unity["demoEnd"].Current;
	current.GameState = vars.Unity["gamestate"].Current;
	current.Started = vars.Unity["started"].Current;
	current.Keys = new bool[] { vars.Unity["keys"][0], vars.Unity["keys"][1], vars.Unity["keys"][2] };
	current.GameTime = new TimeSpan(vars.Unity["hours"].Current, vars.Unity["minutes"].Current, vars.Unity["seconds"].Current);
}

start
{
	return old.GameState == 3 && current.GameState == 1;
}

split
{
	if (!old.DemoEnd && current.DemoEnd)
		return true;

	if (!settings["keys"])
		return;

	for (int i = 0; i < 3; ++i)
	{
		if (!old.Keys[i] && current.Keys[i])
			return true;
	}
}

reset
{
	return old.GameState != 5 && current.GameState == 5;
}

gameTime
{
	if (old.GameTime > current.GameTime)
		vars.TimeBetweenDeaths += old.GameTime - current.GameTime;

	if (current.Started)
		return current.GameTime + vars.TimeBetweenDeaths;
}

isLoading
{
	return true;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}