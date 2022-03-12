state("RERUN") {}

startup
{
	vars.Log = (Action<object>)(output => print("[RE:RUN] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;

	vars.TotalTime = 0f;
}

onStart
{
	vars.TotalTime = 0f;
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var _timer = helper.GetClass("Assembly-CSharp", "Timer");
		var asd = helper.GetClass("Assembly-CSharp", "AutoSplitterData");

		vars.Unity.Make<float>(_timer.Static, _timer["Instance"], _timer["timer"]).Name = "inGameTime";
		vars.Unity.Make<int>(asd.Static, asd["levelID"]).Name = "levelID";
		vars.Unity.Make<int>(asd.Static, asd["levelBeaten"]).Name = "levelBeaten";

		vars.LevelBeatenAddr = asd.Static + asd["levelBeaten"];

		return true;
	});

	vars.Unity.Load(game, 1000);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.Scene = vars.Unity.Scenes.Active.Index;

	current.IGT = vars.Unity["inGameTime"].Current;
	current.Level = vars.Unity["levelID"].Current;
	current.LevelBeaten = vars.Unity["levelBeaten"].Current == 1;

	if (!old.LevelBeaten && current.LevelBeaten)
		game.WriteValue<int>((IntPtr)(vars.LevelBeatenAddr), 0);
}

start
{
	switch ((int)(old.Scene))
	{
		case 0: return old.Scene > 0;
		case 1: return old.IGT > current.IGT;
	}
}

split
{
	return !old.LevelBeaten && current.LevelBeaten;
}

reset
{
	switch ((int)(current.Scene))
	{
		case 0: return old.Scene > 0;
		case 1: return old.IGT > current.IGT;
	}
}

gameTime
{
	if (!old.LevelBeaten && current.LevelBeaten)
		vars.TotalTime += current.IGT;

	return TimeSpan.FromSeconds(vars.TotalTime + current.IGT);
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