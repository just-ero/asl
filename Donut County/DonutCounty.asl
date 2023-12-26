state("DonutCounty") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.GameName = "Donut County";
	vars.Helper.LoadSceneManager = true;

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
	vars.Helper.AlertLoadless();

	vars.CompletedSplits = new HashSet<int>();
}

onStart
{
	vars.CompletedSplits.Clear();
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		Thread.Sleep(3000);

		vars.Helper["Scene"] = mono.MakeString("RM", "sceneManager", "nextLevel");
		vars.Helper["Loading"] = mono.Make<bool>("RM", "sceneManager", "loading");
		vars.Helper["LoadingScene"] = mono.Make<bool>("RM", "sceneManager", "_isLoadingScene");
		vars.Helper["LevelIndex"] = mono.Make<int>("RM", "levelSettings", "deliveryData", "index");
		vars.Helper["TornadoDestructables"] = mono.Make<int>("RM", "tornado", "_numDestructables");

		return true;
	});
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
