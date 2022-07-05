state("Sonic the Hedgehog") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Sonic the Hedgehog] " + output));

	#region Helper Setup
	var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
	var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
	vars.Helper = Activator.CreateInstance(type, timer, /* settings, */ this);
	vars.Helper.LoadSceneManager = true;
	vars.Helper.GameName = "Sonic Project '06";
	vars.Helper.IO.StartFileLogger("SonicProject06.log");
	#endregion

	vars.Helper.AlertLoadless(vars.Helper.GameName);

	vars.PrevOffset = timer.Run.Offset;
}

onStart
{
	timer.IsGameTimePaused = true;
	timer.Run.Offset = vars.PrevOffset;
}

onSplit
{}

onReset
{}

init
{
	current.State = -1;
	current.CheckPoint = "None";

	vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
	{
		var gm = mono.GetClass("GameManager", 1);

		vars.Helper["state"] = gm.Make<int>("_instance", "GameState");
		vars.Helper["level"] = gm.MakeString("_instance", "LoadingTo");

		var pd = mono.GetClass("PlayerData");
		var cpd = mono.GetClass("CheckpointData");

		vars.Helper["cp"] = gm.MakeString("_instance", gm["_PlayerData"] + pd["checkpoint"], cpd["SavePoint"]);

		return true;
	});

	vars.Helper.Load();
}

update
{
	if (!vars.Helper.Update())
		return false;

	current.State = vars.Helper["state"].Current;
	current.Level = vars.Helper["level"].Current;
	current.CheckPoint = vars.Helper["cp"].Current ?? old.CheckPoint;

	if (old.CheckPoint != current.CheckPoint)
	{
		vars.Helper.IO.Log("Level: " + current.Level + " | Checkpoint: " + current.CheckPoint);
	}
}

start
{
	if (old.State == 0 && current.State == 1)
	{
		vars.PrevOffset = timer.Run.Offset;
		timer.Run.Offset = TimeSpan.FromSeconds(2.53);
		return true;
	}
}

split
{
	return old.State == 2 && current.State == 5
	    || old.CheckPoint != current.CheckPoint && settings[current.CheckPoint];
}

reset
{}

isLoading
{
	return current.State == 1;
}

exit
{
	vars.Helper.Dispose();
}

shutdown
{
	vars.Helper.Dispose();
}
