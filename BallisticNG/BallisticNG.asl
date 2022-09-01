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
		var player = mono.GetClass("NgData.Player");
		vars.Helper["State"] = player.Make<int>("State");

		var ships = mono.GetClass("NgData.Ships");
		var sr = mono.GetClass("ShipController");
		vars.Helper["Lap"] = ships.Make<int>("Loaded", 0x10, 0x20, sr["CurrentLap"]);

		var gmr = mono.GetClass("GamemodeRegistry");
		var gm = mono.GetClass("Gamemode");
		vars.Helper["Mode"] = gmr.MakeString("CurrentGamemode", gm["Name"]);

		return true;
	});

	vars.Helper.Load();
}

update
{
	if (!vars.Helper.Update() || vars.Helper["Mode"].Current != "Race")
		return false;

	vars.Helper.MapWatchersToCurrent(current);

	current.SceneCount = vars.Helper.Scenes.Count;
}

start
{
	return old.State == 1 && current.State == 2;
}

split
{
	return old.State == 2 && current.State == 3
	       || settings["laps"] && old.Lap < current.Lap && current.Lap > 1;
}

reset
{}

isLoading
{
	return current.SceneCount > 1 || current.State != 2;
}

exit
{
	vars.Helper.Dispose();
}

shutdown
{
	vars.Helper.Dispose();
}
