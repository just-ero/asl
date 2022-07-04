state("Here Comes Niko!") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Here Comes Niko!] " + output));

	#region Helper Setup
	var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
	var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
	vars.Helper = Activator.CreateInstance(type, timer, settings, this);
	#endregion

	dynamic[,] _settings =
	{
		{ "Home", "h_Coins", "Coins", false },
			{ "h_Coins", "1_Fetch", "Low Frog: take lunch box to High Frog", false },

		{ "Home", "h_Letters", "Letters", false },
			{ "h_Letters", "1_letter12", "on the rocks near the crane", false },

		{ "Home", "1_End", "Enter train to leave Home", true },


		{ "Hairball City", "hc_Coins", "Coins", false },
			{ "hc_Coins", "2_main", "Gunther: talk to Gunther", false },
			{ "hc_Coins", "2_volley", "Travis: BIG VOLLEY", false },
			{ "hc_Coins", "2_Dustan", "Dustan: get to the top of the lighthouse", false },
			{ "hc_Coins", "2_flowerPuzzle", "Little Gabi: plant flowers in each of the plant beds", false },
			{ "hc_Coins", "2_fishing", "Fischer: catch all 5 fish", false },
			{ "hc_Coins", "2_bug", "Blessley: collect 30 butterflies", false },
			{ "hc_Coins", "hc_Coins+", "Requires Contact List", false },
				{ "hc_Coins+", "2_arcadeBone", "Arcade Machine: get 5 dog bones", false },
				{ "hc_Coins+", "2_arcade", "Arcade Machine: get the coin", false },
				{ "hc_Coins+", "2_hamsterball", "Moomy: collect 10 sunflower seeds", false },
				{ "hc_Coins+", "2_carrynojump", "Serschel/Louist: bring Louist back to Serschel", false },
				{ "hc_Coins+", "2_gamerQuest", "Game Kid: jump from the skyscraper into the water without touching ground", false },
				{ "hc_Coins+", "2_graffiti", "Nina: paint 5 symbols on the ground", false },
				{ "hc_Coins+", "2_cassetteCoin", "Mitch: trade 5 cassettes for a coin", false },
				{ "hc_Coins+", "2_cassetteCoin2", "Mai: trade 5 cassettes for a coin", false },

		{ "Hairball City", "hc_Cassettes", "Cassettes", false },
			{ "hc_Cassettes", "2_casHairballCity0", "on the rock near the whiteboard", false },
			{ "hc_Cassettes", "2_casHairballCity4", "on the palm tree", false },
			{ "hc_Cassettes", "2_casHairballCity5", "in the dark tunnel", false },
			{ "hc_Cassettes", "2_casHairballCity2", "above the big red umbrellas near the scarecrow frog", false },
			{ "hc_Cassettes", "2_casHairballCity3", "above the door of the lighthouse", false },
			{ "hc_Cassettes", "2_casHairballCity7", "at the back side of the lighthouse", false },
			{ "hc_Cassettes", "2_casHairballCity8", "under the ramp", false },
			{ "hc_Cassettes", "2_casHairballCity6", "inside of a breakable box", false },
			{ "hc_Cassettes", "2_casHairballCity1", "on the crown of the frog statue", false },
			{ "hc_Cassettes", "2_casHairballCity9", "in the sky above the frog statue", false },

		{ "Hairball City", "hc_Letters", "Letters", false },
			{ "hc_Letters", "2_letter1", "in the tree near the scarecrow frog", false },
			{ "hc_Letters", "2_letter7", "on the other side of the train", false },

		{ "Hairball City", "2_End", "Enter train to leave Hairball City", true },


		{ "Turbine Town", "tt_Coins", "Coins", false },
			{ "tt_Coins", "3_main", "Pelly: get the wind turbine working", false },
			{ "tt_Coins", "3_volley", "Trixie: AIR VOLLEY", false },
			{ "tt_Coins", "3_Dustan", "Dustan: get to the top of the turbine", false },
			{ "tt_Coins", "3_flowerPuzzle", "Little Gabi: plant flowers in each of the plant beds", false },
			{ "tt_Coins", "3_fishing", "Fischer: catch all 5 fish", false },
			{ "tt_Coins", "3_bug", "Blessley: collect 30 butterflies", false },
			{ "tt_Coins", "tt_Coins+", "Requires Contact List", false },
				{ "tt_Coins+", "3_arcadeBone", "Arcade Machine: get 5 dog bones", false },
				{ "tt_Coins+", "3_arcade", "Arcade Machine: get the coin", false },
				{ "tt_Coins+", "3_carrynojump", "Serschel/Louist: bring Louist back to Serschel", false },
				{ "tt_Coins+", "3_cassetteCoin", "Mitch: trade 5 cassettes for a coin", false },
				{ "tt_Coins+", "3_cassetteCoin2", "Mai: trade 5 cassettes for a coin", false },

		{ "Turbine Town", "tt_Cassettes", "Cassettes", false },
			{ "tt_Cassettes", "3_Cassette (2)", "on top of the first set of shipping containers", false },
			{ "tt_Cassettes", "3_Cassette (5)", "inside the container with a button in front of it", false },
			{ "tt_Cassettes", "3_Cassette (4)", "inside the container with a fan blowing outwards", false },
			{ "tt_Cassettes", "3_Cassette (3)", "behind Blessley's backdrop", false },
			{ "tt_Cassettes", "3_Cassette (6)", "in the bushes on around the turbine", false },
			{ "tt_Cassettes", "3_Cassette", "in the partially sunken container", false },
			{ "tt_Cassettes", "3_Cassette (1)", "on a cube shaped rock around the back of the flower beds", false },
			{ "tt_Cassettes", "3_Cassette (7)", "on a pile of cube rocks near the AIR VOLLEY arena", false },

		{ "Turbine Town", "tt_Letters", "Letters", false },
			{ "tt_Letters", "3_letter8", "in the tree above the partially sunken container", false },
			{ "tt_Letters", "3_letter2", "at the back side of the rock where you meet the Wind God", false },

		{ "Turbine Town", "tt_Keys", "Keys", false },
			{ "tt_Keys", "3_containerKey", "inside the container with the breakable blocks", false },
			{ "tt_Keys", "3_parasolKey", "on the stone pillar at the back side of the turbine", false },

		{ "Turbine Town", "tt_Misc", "Miscellaneous", false },
			{ "tt_Misc", "3_TurbineLock", "unlock turbine ladder", false },

		{ "Turbine Town", "3_End", "Enter train to leave Turbine Town", true },


		{ "Salmon Creek Forest", "scf_Coins", "Coins", false },
			{ "scf_Coins", "4_main", "Stijn: talk to Melissa and bring them to the plateau", false },
			{ "scf_Coins", "4_volley", "Trixie: SPORTVIVAL VOLLEY", false },
			{ "scf_Coins", "4_Dustan", "Dustan: get to the top of the mountain", false },
			{ "scf_Coins", "4_flowerPuzzle", "Little Gabi: plant flowers in each of the plant beds", false },
			{ "scf_Coins", "4_fishing", "Fischer: catch all 5 fish", false },
			{ "scf_Coins", "4_bug", "Blessley: collect 30 dragonflies", false },
			{ "scf_Coins", "4_arcadeBone", "Arcade Machine: get 5 dog bones", false },
			{ "scf_Coins", "4_hamsterball", "Moomy: collect 10 sunflower seeds", false },
			{ "scf_Coins", "4_graffiti", "Nina: paint 5 symbols on the ground", false },
			{ "scf_Coins", "4_cassetteCoin", "Mitch: trade 5 cassettes for a coin", false },
			{ "scf_Coins", "4_cassetteCoin2", "Mai: trade 5 cassettes for a coin", false },
			{ "scf_Coins", "4_tree", "Treeman: dive into the Treeman until a coin falls", false },
			{ "scf_Coins", "4_behindWaterfall", "Secret of the Forest: jump through a waterfall and go to the end of the area", false },
			{ "scf_Coins", "scf_Coins+", "Requires Contact List", false },
				{ "scf_Coins+", "4_arcade", "Arcade Machine: get the coin", false },
				{ "scf_Coins+", "4_carrynojump", "Serschel/Louist: bring Louist back to Serschel", false },
				{ "scf_Coins+", "4_gamerQuest", "Game Kid: jump from the skyscraper into the water without touching ground", false },

		{ "Salmon Creek Forest", "scf_Cassettes", "Cassettes", false },
			{ "scf_Cassettes", "4_Cassette", "on a large rock behind the train", false },
			{ "scf_Cassettes", "4_Cassette (9)", "on a leaning tree a little past Treeman", false },
			{ "scf_Cassettes", "4_Cassette (10)", "in the camp", false },
			{ "scf_Cassettes", "4_Cassette (8)", "at the back side of the camp, on a grassy outcropping", false },
			{ "scf_Cassettes", "4_Cassette (3)", "at the back side of the camp, on a stone outcropping", false },
			{ "scf_Cassettes", "4_Cassette (1)", "on the bridge leading to one of the flower beds", false },
			{ "scf_Cassettes", "4_Cassette (6)", "on a platform at the top of a tree near Nina and Melissa", false },
			{ "scf_Cassettes", "4_Cassette (2)", "on the roof of the tree house", false },
			{ "scf_Cassettes", "4_Cassette (7)", "on a rock just near the flower bed past Stijn's home", false },
			{ "scf_Cassettes", "4_Cassette (4)", "to the right of the higher waterfall in the secret area", false },
			{ "scf_Cassettes", "4_Cassette (5)", "in a breakable box in the secret area", false },

		{ "Salmon Creek Forest", "scf_Letters", "Letters", false },
			{ "scf_Letters", "4_letter9", "behind a bush in the cave", false },
			{ "scf_Letters", "4_letter3", "on the left at the end of the secret area", false },

		{ "Salmon Creek Forest", "scf_Keys", "Keys", false },
			{ "scf_Keys", "4_2Key", "in the first pond", false },
			{ "scf_Keys", "4_3Key", "in the small bush behind the frog statue", false },
			{ "scf_Keys", "4_1Key", "on a rock by the sunken skyscraper", false },

		{ "Salmon Creek Forest", "scf_Misc", "Miscellaneous", false },
			{ "scf_Misc", "4_lock2", "unlock the cave", false },

		{ "Salmon Creek Forest", "4_End", "Enter train to leave Salmon Creek Forest", true },


		{ "Public Pool", "pp_Coins", "Coins", false },
			{ "pp_Coins", "5_main", "Frogtective: solve the crime", false },
			{ "pp_Coins", "5_fishing", "Fischer: catch all 5 fish", false },
			{ "pp_Coins", "5_arcadeBone", "Arcade Machine: get 5 dog bones", false },
			{ "pp_Coins", "5_arcade", "Arcade Machine: get the coin", false },
			{ "pp_Coins", "5_cassetteCoin2", "Mai: trade 5 cassettes for a coin", false },
			{ "pp_Coins", "5_2D", "Far Away Island: complete the 2D section", false },
			{ "pp_Coins", "pp_Coins+", "Requires Contact List", false },
				{ "pp_Coins+", "5_volley", "Trixie: WATER VOLLEY", false },
				{ "pp_Coins+", "5_flowerPuzzle", "Little Gabi: plant flowers in each of the plant beds", false },
				{ "pp_Coins+", "5_bug", "Blessley: collect 30 cicadas", false },
				{ "pp_Coins+", "5_cassetteCoin", "Mitch: trade 5 cassettes for a coin", false },

		{ "Public Pool", "pp_Cassettes", "Cassettes", false },
			{ "pp_Cassettes", "5_Cassette (4)", "in the pool with the lily pads", false },
			{ "pp_Cassettes", "5_Cassette (5)", "in the corner of the deep pool", false },
			{ "pp_Cassettes", "5_Cassette (1)", "at the end of the mid-height diving board", false },
			{ "pp_Cassettes", "5_Cassette (9)", "in front of the highest level diving board", false },
			{ "pp_Cassettes", "5_Cassette (2)", "in a bush behind Blessley's backdrop", false },
			{ "pp_Cassettes", "5_Cassette (3)", "at the line of donuts behind Blessley's backdrop", false },
			{ "pp_Cassettes", "5_Cassette (8)", "in a breakable box in the kiddie pool", false },
			{ "pp_Cassettes", "5_Cassette", "on top of the green frog statue", false },
			{ "pp_Cassettes", "5_Cassette (6)", "in the ring of donuts behind the green frog statue", false },
			{ "pp_Cassettes", "5_Cassette (7)", "in a palm tree near the guinea pigs", false },

		{ "Public Pool", "pp_Letters", "Letters", false },
				{ "pp_Letters", "5_letter10", "on the far left of the 2D section", false },
				{ "pp_Letters", "5_letter4", "on the far right of the 2D section", false },

		{ "Public Pool", "pp_Keys", "Keys", false },
			{ "pp_Keys", "5_testKey", "on the island with the fan covered by a breakable box", false },

		{ "Public Pool", "pp_Misc", "Miscellaneous", false },
			{ "pp_Misc", "5_lock1", "unlock the second Arcade Machine", false },

		{ "Public Pool", "5_End", "Enter train to leave Public Pool", true },


		{ "The Bathhouse" ,"tb_Coins", "Coins", false },
			{ "tb_Coins", "6_main", "Poppy: check on Paul and then find Skippy", false },
			{ "tb_Coins", "6_volley", "Travis: LONG VOLLEY", false },
			{ "tb_Coins", "6_Dustan", "Dustan: get to the top of the main bathhouse", false },
			{ "tb_Coins", "6_hamsterball", "Moomy: collect 10 sunflower seeds", false },
			{ "tb_Coins", "6_carrynojump", "Serschel/Louist: bring Louist back to Serschel", false },
			{ "tb_Coins", "6_gamerQuest", "Game Kid: get from the marked lamp to the marked hot tub without touching snow", false },
			{ "tb_Coins", "6_graffiti", "Nina: paint 5 symbols on the ground", false },
			{ "tb_Coins", "6_cassetteCoin", "Mitch: trade 5 cassettes for a coin", false },
			{ "tb_Coins", "6_cassetteCoin2", "Mai: trade 5 cassettes for a coin", false },
			{ "tb_Coins", "tb_Coins+", "Requires Contact List", false },
				{ "tb_Coins+", "6_flowerPuzzle", "Little Gabi: plant flowers in each of the plant beds", false },
				{ "tb_Coins+", "6_fishing", "Fischer: catch all 5 fish", false },
				{ "tb_Coins+", "6_bug", "Blessley: collect 30 cicadas", false },
				{ "tb_Coins+", "6_arcadeBone", "Arcade Machine: get 5 dog bones", false },
				{ "tb_Coins+", "6_arcade", "Arcade Machine: get the coin", false },

		{ "The Bathhouse" ,"tb_Cassettes", "Cassettes", false },
			{ "tb_Cassettes" ,"6_Cassette", "behind the golden frog statue", false },
			{ "tb_Cassettes" ,"6_Cassette (8)", "along a pipe below the entrace to the main bathhouse", false },
			{ "tb_Cassettes" ,"6_Cassette (4)", "on top of a lamp to the left of the main bathhouse", false },
			{ "tb_Cassettes" ,"6_Cassette (6)", "behind a waterfall to the right of the main bathhouse", false },
			{ "tb_Cassettes" ,"6_Cassette (9)", "in the secret frog hideout", false },
			{ "tb_Cassettes" ,"6_Cassette (1)", "on a rock off the ledge where Masked Kid stands", false },
			{ "tb_Cassettes" ,"6_Cassette (2)", "under the sunken tower", false },
			{ "tb_Cassettes" ,"6_Cassette (3)", "on top of the giant frog statue", false },
			{ "tb_Cassettes" ,"6_Cassette (7)", "above a tree near the giant frog statue", false },
			{ "tb_Cassettes" ,"6_Cassette (5)", "behind Blessley's backdrop", false },

		{ "The Bathhouse" ,"tb_Letters", "Letters", false },
			{ "tb_Letters" ,"6_letter11", "near the axolotl family", false },
			{ "tb_Letters" ,"6_letter5", "on the other side of the wall where Game Kid is standing", false },

		{ "The Bathhouse" ,"tb_Keys", "Keys", false },
			{ "tb_Keys" ,"6_underfloorKey", "under the floor of the main bathhouse", false },
			{ "tb_Keys" ,"6_inpuzzleKey", "in a breakable box on the bottom level of one of the bathhouses", false },
			{ "tb_Keys" ,"6_ontoriiKey", "on top of one of the red torii gates leading to Paul", false },

		{ "The Bathhouse" ,"tb_Miscellaneous", "Miscellaneous", false },
			{ "tb_Miscellaneous" ,"6_mahjonglock", "unlock the frog hideout", false },

		{ "The Bathhouse", "6_End", "Enter train to leave The Bathhouse", true },


		{ "Tadpole HQ", "thq_Coins", "Coins", false },
			{ "thq_Coins", "7_main", "King Frog: listen to King Frog", false },
			{ "thq_Coins", "7_volley", "Travis: HUGE VOLLEY", false },
			{ "thq_Coins", "7_flowerPuzzle", "Little Gabi: plant flowers in each of the plant beds", false },
			{ "thq_Coins", "7_fishing", "Fischer: catch all 5 fish", false },
			{ "thq_Coins", "7_bug", "Blessley: collect 30 cicadas", false },
			{ "thq_Coins", "7_arcadeBone", "Arcade Machine: get 5 dog bones", false },
			{ "thq_Coins", "7_arcade", "Arcade Machine: get the coin", false },
			{ "thq_Coins", "7_carrynojump", "Serschel/Louist: bring Louist back to Serschel", false },
			{ "thq_Coins", "7_cassetteCoin", "Mitch: trade 5 cassettes for a coin", false },
			{ "thq_Coins", "7_cassetteCoin2", "Mai: trade 5 cassettes for a coin", false },

		{ "Tadpole HQ", "thq_Cassettes", "Cassettes", false },
			{ "thq_Cassettes", "7_Cassette (2)", "in a bush behind the bench with the contact list", false },
			{ "thq_Cassettes", "7_Cassette (4)", "in a tree near the first pond (soda can to shoot into it)", false },
			{ "thq_Cassettes", "7_Cassette (5)", "on top of the golden frog statue", false },
			{ "thq_Cassettes", "7_Cassette (6)", "in a breakable box behind the first buildings to the right", false },
			{ "thq_Cassettes", "7_Cassette (9)", "in the wall jump area of the largest building", false },
			{ "thq_Cassettes", "7_Cassette (3)", "around the corner of the broken soda can", false },
			{ "thq_Cassettes", "7_Cassette (7)", "on some rocks past Fischer", false },
			{ "thq_Cassettes", "7_Cassette (8)", "under the giant red umbrella near Blessley", false },
			{ "thq_Cassettes", "7_Cassette", "in the cross section between the buildings with the flower beds", false },
			{ "thq_Cassettes", "7_Cassette (1)", "at the back side of the second-level building with the flower beds", false },

		{ "Tadpole HQ", "thq_Letters", "Letters", false },
			{ "thq_Letters", "7_letter6", "on the second highest ledge leading to pepper", false },

		{ "Tadpole HQ", "thq_Misc", "Miscellaneous", false },
			{ "thq_Misc", "7_lock1", "unlock the second Arcade Machine", false },

		{ "Tadpole HQ", "7_End", "Enter train to leave Tadpole HQ", true }
	};

	settings.Add("Home");
	settings.Add("Hairball City");
	settings.Add("Turbine Town");
	settings.Add("Salmon Creek Forest");
	settings.Add("Public Pool");
	settings.Add("The Bathhouse");
	settings.Add("Tadpole HQ");

	vars.Helper.Settings.CreateCustom(_settings, 4, 1, 3, 2);

	vars.CompletedFlags = new List<string>();
	vars.FlagNames = new[] { "coinFlags", "cassetteFlags", "fishFlags", "letterFlags", "miscFlags" };

	vars.Helper.AlertLoadless("Here Comes Niko!");
}

onStart
{
	vars.CompletedFlags.Clear();
	vars.EndGame = false;
	vars.Helper["onStartGame"].Write(false);
}

init
{
	vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
	{
		// SpeedRunData
		var srd = mono.GetClass("Assembly-CSharp", "SpeedRunData");

		vars.Helper["currentLevel"] = srd.Make<int>("currentLevel");
		vars.Helper["onEndingScreen"] = srd.Make<bool>("onEndingScreen");
		vars.Helper["isLoading"] = srd.Make<bool>("isLoading");
		vars.Helper["onStartGame"] = srd.Make<bool>("onStartGame");
		vars.Helper["onLevelStart"] = srd.Make<bool>("onLevelStart");

		// WorldSaveData
		var wsd = mono.GetClass("Assembly-CSharp", "scrWorldSaveDataContainer");

		vars.Helper["coinFlags"] = wsd.MakeList<IntPtr>("instance", "coinFlags");
		vars.Helper["cassetteFlags"] = wsd.MakeList<IntPtr>("instance", "cassetteFlags");
		vars.Helper["fishFlags"] = wsd.MakeList<IntPtr>("instance", "fishFlags");
		vars.Helper["letterFlags"] = wsd.MakeList<IntPtr>("instance", "letterFlags");
		vars.Helper["miscFlags"] = wsd.MakeList<IntPtr>("instance", "miscFlags");

		return true;
	});

	vars.Helper.Load();
}

update
{
	if (!vars.Helper.Update())
		return false;

	current.Level = vars.Helper["currentLevel"].Current;
	current.OnEnding = vars.Helper["onEndingScreen"].Current;
	current.Loading = vars.Helper["isLoading"].Current;
	current.GameStart = vars.Helper["onStartGame"].Current;
	current.LevelStart = vars.Helper["onLevelStart"].Current;

	current.Counts = new[]
	{
		vars.Helper["coinFlags"].Current.Count,
		vars.Helper["cassetteFlags"].Current.Count,
		vars.Helper["fishFlags"].Current.Count,
		vars.Helper["letterFlags"].Current.Count,
		vars.Helper["miscFlags"].Current.Count
	};
}

start
{
	return !old.GameStart && current.GameStart ||
	       !old.LevelStart && current.LevelStart;
}

split
{
	if (old.Level != current.Level && current.Level != 1)
		return settings[old.Level + "_End"];

	if (!old.OnEnding && current.OnEnding)
		return true;

	for (int i = 0; i < current.Counts.Length; ++i)
	{
		if (current.Counts[i] != old.Counts[i] + 1)
			continue;

		var addr = vars.Unity[vars.FlagNames[i]].Current[current.Counts[i] - 1];
		var newFlag = current.Level + "_" + vars.Helper.ReadString();

		if (!vars.CompletedFlags.Contains(newFlag))
		{
			vars.CompletedFlags.Add(newFlag);
			return settings[newFlag];
		}
	}
}

reset
{
	return !old.GameStart && current.GameStart;
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