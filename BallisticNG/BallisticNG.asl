state("BallisticNG") {}

startup
{
	vars.Log = (Action<object>)(output => print("[BallisticNG] " + output));

	#region Helper Setup
	var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
	var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
	vars.Helper = Activator.CreateInstance(type, timer, this);
	vars.Helper.LoadSceneManager = true;
	#endregion

	settings.Add("laps", false, "Split on each Race's Laps");
}

init
{
	vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
	{
		var race = mono.GetClass("GameData.Race");
		var ships = mono.GetClass("Ships");
		var sr = mono.GetClass("ShipRefs");

		vars.Helper["countdownFinished"] = race.Make<bool>("HasCountdownFinished");
		vars.Helper["finished"] = ships.Make<bool>("LoadedShips", 0x10, 0x20, sr["FinishedEvent"]);
		vars.Helper["lap"] = ships.Make<int>("LoadedShips", 0x10, 0x20, sr["CurrentLap"]);

		var gmr = mono.GetClass("GamemodeRegistry");
		var gm = mono.GetClass("Gamemode");

		vars.Helper["mode"] = gmr.MakeString("CurrentGamemode", gm["Name"]);

		return true;
	});

	vars.Helper.Load();
}

update
{
	if (!vars.Helper.Update() || vars.Helper["mode"].Current != "Race" || vars.Helper.Scenes.Active.Index == 3)
		return false;

	current.CountdownFinished = vars.Helper["countdownFinished"].Current;
	current.EventFinished = vars.Helper["finished"].Current;
	current.Lap = vars.Helper["lap"].Current;

	current.SceneCount = vars.Helper.Scenes.Count;
}

start
{
	return !old.CountdownFinished && current.CountdownFinished;
}

split
{
	if (old.SceneCount == 1 && current.SceneCount > 1)
	{
		vars.Helper["countdownFinished"].Write(false);
	}

	if (current.EventFinished)
	{
		return !old.EventFinished;
	}
	else
	{
		return settings["laps"] && old.Lap < current.Lap && current.Lap > 1;
	}
}

reset
{}

isLoading
{
	return current.SceneCount > 1 || !current.CountdownFinished || current.EventFinished;
}

exit
{
	vars.Helper.Dispose();
}

shutdown
{
	vars.Helper.Dispose();
}
