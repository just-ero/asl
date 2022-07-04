state("DonutCounty") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Donut County] " + output));

	#region Helper Setup
	var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
	var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
	vars.Helper = Activator.CreateInstance(type, timer, settings, this);
	vars.Helper.LoadSceneManager = true;
	#endregion

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

	vars.Helper.Settings.CreateCustom(_settings, 4, 1, 3, 2);
	vars.Helper.AlertGameTime("Donut County");

	vars.CompletedSplits = new HashSet<int>();
}

onStart
{
	vars.CompletedSplits.Clear();
}

init
{
	vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
	{
		var rm = mono.GetClass("RM");
		var sm = mono.GetClass("SceneManager");
		var ls = mono.GetClass("LevelSettings");
		var d = mono.GetClass("OS1Delivery");
		var t = mono.GetClass("Tornado");

		vars.Helper["nextLevel"] = rm.MakeString("sceneManager", "nextLevel");
		vars.Helper["loading"] = rm.Make<bool>("sceneManager", "loading");
		vars.Helper["loadingScene"] = rm.Make<bool>("sceneManager", "_isLoadingScene");
		vars.Helper["levelIndex"] = rm.Make<int>("levelSettings", "deliveryData", "index");
		vars.Helper["tornadoDestructables"] = rm.Make<int>("tornado", "_numDestructables");

		return true;
	});

	vars.Helper.Load(game);
}

update
{
	if (!vars.Helper.Update())
		return false;

	current.Scene = vars.Helper["nextLevel"].Current;
	current.Loading = vars.Helper["loading"].Current;
	current.LoadingScene = vars.Helper["loadingScene"].Current;
	current.LevelIndex = vars.Helper["levelIndex"].Current;
	current.TornadoDestructables = vars.Helper["tornadoDestructables"].Current;
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
	vars.Helper.Dispose();
}

shutdown
{
	vars.Helper.Dispose();
}
