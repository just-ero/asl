state("pp2") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Paw Patrol 2] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var st = helper.GetClass("Assembly-CSharp", "Singletons");
		var ls = helper.GetClass("Assembly-CSharp", "LoadSceneMgr");

		vars.Unity.Make<float>(st.Static, st["_singletons"], st["loadSceneMgr"], ls["_progress"]).Name = "loadProgress";
		vars.Unity.Make<bool>(st.Static, st["_singletons"], st["loadSceneMgr"], ls["_loadingScreen"]).Name = "loadingScreen";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();
}

isLoading
{
	return vars.Unity["loadProgress"].Current != 1f || vars.Unity["loadingScreen"].Current;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}