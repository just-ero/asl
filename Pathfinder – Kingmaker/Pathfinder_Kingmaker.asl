state("Kingmaker") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Pathfinder: Kingmaker] " + output));

	var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
	var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
	vars.Helper = Activator.CreateInstance(type, timer, this);

	vars.Helper.AlertLoadless("Pathfinder: Kingmaker");
}

init
{
	vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
	{
		var lp = mono.GetClass("Kingmaker.EntitySystem.Persistence.LoadingProcess");
		vars.Helper["Loading"] = lp.Make<bool>("s_Instance", "m_LoadingScreen");

		return true;
	});

	vars.Helper.Load();
}

update
{
	if (!vars.Helper.Update())
		return false;

	vars.Helper.MapWatchersToCurrent(current);
}

isLoading
{
	return current.Loading;
}

exit
{
	vars.Helper.Dispose();
}

shutdown
{
	vars.Helper.Dispose();
}
