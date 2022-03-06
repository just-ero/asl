state("AWC") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Assemble with Care] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		// LevelFlowService
		var service = helper.GetClass("com.unity-common.core", "Service`1");
		var lfs = helper.GetClass("Assembly-CSharp", "LevelFlowService", 1);
		var lc = helper.GetClass("Assembly-CSharp", "LevelConfig");

		vars.Unity.Make<int>(lfs.Static, service["_instance"], lfs["_state"]).Name = "levelState";

		// GameStart
		var gs = helper.GetClass("Assembly-CSharp", "GameStart");

		vars.Unity.Make<bool>(gs.Static, gs["forceReloadGame"]).Name = "reloadGame";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.State = vars.Unity["levelState"].Current;
	current.Scene = vars.Unity.Scenes.Loading[0].Index;
	current.Reload = vars.Unity["reloadGame"].Current;
}

start
{
	return !old.Reload && current.Reload;
}

split
{
	switch ((int)(old.Scene))
	{
		case 2:  return current.Scene == 1;
		case 18: return old.State == 5 && current.State == 8;
		default: return old.State == 4 && current.State == 5;
	}
}

reset
{
	return !old.Reload && current.Reload;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}