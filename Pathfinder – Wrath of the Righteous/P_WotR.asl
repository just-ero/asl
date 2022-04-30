state("Wrath") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Pathfinder: Wrath of the Righteous] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var lp = helper.GetClass("Assembly-CSharp", "Kingmaker.EntitySystem.Persistence.LoadingProcess");

		vars.Unity.Make<IntPtr>(lp.Static, lp["s_Instance"], lp["m_LoadingScreen"]).Name = "loadingScreenPtr";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.Loading = vars.Unity["loadingScreenPtr"].Current != IntPtr.Zero;
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