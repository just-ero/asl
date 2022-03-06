state("Alba") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Alba] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");

	string[,] _settings =
	{
		{ "Main Quests", "QT_GetCameraGrandad", "Take Granddad's phone (Prologue)" },
		{ "Main Quests", "QG_Explore_with_Ines", "Explore with Ines" },
			{ "QG_Explore_with_Ines", "QT_Follow_Ines_to_the_Paella_in_the_resturant", "Follow Ines to the Paella in the restaurant" },
			{ "QG_Explore_with_Ines", "QT_Follow_Ines_to_the_Ancient_Ruins", "Follow Ines to the Ancient Ruins" },
		{ "Main Quests", "QG_Dolphin_Rescue", "Dolphin Rescue" },
			{ "QG_Dolphin_Rescue", "QT_Investigate_the_stranded_dolphin", "Investigate the stranded dolphin" },
			{ "QG_Dolphin_Rescue", "QT_Find_people_to_help_save_the_dolphin", "Find people to help save the dolphin" },
			{ "QG_Dolphin_Rescue", "QT_Return_the_dolphin_to_the_sea", "Return the dolphin to the sea" },
		{ "Main Quests", "QT_Scan_Sparrow", "Scan the Sparrow" },
		{ "Main Quests", "QT_Find_the_Mayor_at_the_Nature_Reserve", "Find the Mayor at the Nature Reserve" },
		{ "Main Quests", "QG_Nature_Reserve", "Nature Reserve" },
			{ "QG_Nature_Reserve", "QT_Explore_the_Nature_Reserve", "Explore the Nature Reserve" },
			{ "QG_Nature_Reserve", "QT_Take_a_photo_of_the_Shoveler", "Take a photo of the Shoveler" },
			{ "QG_Nature_Reserve", "QT_Talk_to_the_Carpenter_in_town", "Talk to the Carpenter in town" },
			{ "QG_Nature_Reserve", "QT_Fix_the_bridge_in_the_Nature_Reserve", "Fix the bridge in the Nature Reserve" },
			{ "QG_Nature_Reserve", "QT_Scan_a_Grey_Heron_in_the_Nature_Reserve", "Scan a Grey Heron in the Nature Reserve" },
			{ "QG_Nature_Reserve", "QT_Put_Heron_photo_on_sign_in_Nature_Reserve", "Put Heron photo on sign in Nature Reserve" },
			{ "QG_Nature_Reserve", "QT_Clean_up_the_Nature_Reserve", "Clean up the Nature Reserve" },
			{ "QG_Nature_Reserve", "QT_Fix_Carpenter_Birdbox", "Fix Carpenter Birdbox" },
		{ "Main Quests", "QG_Mysterious_Goo", "Mysterious Goo" },
			{ "QG_Mysterious_Goo", "QT_Follow_the_trail_of_green_goo", "Follow the trail of green goo" },
			{ "QG_Mysterious_Goo", "QT_Ask_the_vet_in_town_for_help", "Ask the vet in town for help" },
			{ "QG_Mysterious_Goo", "QT_Meet_the_vet_at_the_sick_squirrel", "Meet the vet at the sick squirrel" },
			{ "QG_Mysterious_Goo", "QT_Find_and_heal_sick_animals_nearby", "Find and heal sick animals nearby" },
			{ "QG_Mysterious_Goo", "QT_Talk_to_the_Vet_in_town", "Talk to the Vet in town on the next day" },
			{ "QG_Mysterious_Goo", "QT_Follow_the_trail_of_sick_animals", "Follow the trail of sick animals" },
			{ "QG_Mysterious_Goo", "QT_Find_the_farm_the_pesticides_came_from", "Find the farm the pesticides came from" },
			{ "QG_Mysterious_Goo", "QT_Heal_the_farmers_sick_cat", "Heal the farmer's sick cat" },
		{ "Main Quests", "QG_Castle", "Castle" },
			{ "QG_Castle", "QT_Meet_Grandpa_at_the_Castle", "Meet Grandpa at the Castle" },
			{ "QG_Castle", "QT_Fix_the_wooden_stairs_in_the_Castle", "Fix the wooden stairs in the Castle" },
			{ "QG_Castle", "QT_Scan_the_Eagle_from_the_Castle_walls", "Scan the Eagle from the Castle walls" },
		{ "Main Quests", "QG_The_Lynx", "The Lynx" },
			{ "QG_The_Lynx", "QT_Meet_Ines_at_the_Chicken_Farm", "Meet Ines at the Chicken Farm" },
			{ "QG_The_Lynx", "QT_Find_where_the_Lynx_went", "Find where the Lynx went" },
			{ "QG_The_Lynx", "QT_Follow_the_Lynxs_trail_near_the_Farm", "Follow the Lynxs trail near the Farm" },
			{ "QG_The_Lynx", "QT_Talk_to_Ines_outside_the_Lynxs_den", "Talk to Ines outside the Lynxs den" },
			{ "QG_The_Lynx", "QT_Repair_the_Chicken_Farm_Fence", "Repair the Chicken Farm Fence" },
			{ "QG_The_Lynx", "QT_Scan_the_Fox", "Scan the Fox" },
		{ "Main Quests", "QG_ReturnToDolphinIsland", "Return to La Roqueta (Dolphin)" },
			{ "QG_ReturnToDolphinIsland", "QT_ClaraDolphinBoat", "Get on the boat" },
			{ "QG_ReturnToDolphinIsland", "QT_ClaraDolphin", "Take a photo of the dolphin" },
		{ "Main Quests", "QG_Cleanup_North_Beach", "Clean up North Beach" },
			{ "QG_Cleanup_North_Beach", "QT_IllegalDump_Meet_Juanito", "Meet Juanito" },
			{ "QG_Cleanup_North_Beach", "QT_IllegalDump_Heal_the_Animals", "Heal the Animals" },
			{ "QG_Cleanup_North_Beach", "QT_IllegalDump_Clean_the_Rubbish", "Clean the Rubbish" },
		{ "Main Quests", "QT_Talk_to_the_Mayor_in_town", "Talk to the Mayor in town" },
		{ "Main Quests", "QG_Mayor_Investigation", "Mayor Investigation" },
			{ "QG_Mayor_Investigation", "QT_Follow_Ines_to_find_the_Mayor", "Follow Ines to find the Mayor" },
			{ "QG_Mayor_Investigation", "QT_Scan_the_Mayor_1", "Scan the Mayor 1" },
			{ "QG_Mayor_Investigation", "QT_Scan_the_Mayor_2", "Scan the Mayor 2" },
			{ "QG_Mayor_Investigation", "QT_Scan_the_Mayor_3", "Scan the Mayor 3" },
			{ "QG_Mayor_Investigation", "QT_Scan_the_Mayor_4", "Scan the Mayor 4" },
			{ "QG_Mayor_Investigation", "QT_Use_the_Scanner_to_see_whats_in_the_briefcase", "Use the Scanner to see whats in the briefcase" },
		{ "Main Quests", "QT_Scan_the_Lynx", "Scan the Lynx" },
		{ "Main Quests", "QG_Summer_Festival", "Summer Festival" },
			{ "QG_Summer_Festival", "QT_Summer_Festival_Enjoy", "Summer Festival Enjoy" },
			{ "QG_Summer_Festival", "QT_Summer_Festival", "Summer Festival" },

		{ "Side Quests", "QG_Nature_Reserve_SQ", "Nature Reserve" },
			{ "QG_Nature_Reserve_SQ", "QT_Fix_up_the_old_Nature_Reserve", "Fix up the old Nature Reserve" },
			{ "QG_Nature_Reserve_SQ", "QT_Replace_damaged_photos_on_signs_in_Nature_Reserve", "Replace damaged photos on signs in Nature Reserve" },
		{ "Side Quests", "QG_Animals_Discovered", "Animals Discovered" },
			{ "QG_Animals_Discovered", "QT_ScanAnimals1", "Scan 5 Animals" },
			{ "QG_Animals_Discovered", "QT_ScanAnimals2", "Scan 12 Animals" },
			{ "QG_Animals_Discovered", "QT_ScanAnimals3", "Scan 20 Animals" },
			{ "QG_Animals_Discovered", "QT_ScanAnimals4", "Scan 30 Animals" },
			{ "QG_Animals_Discovered", "QT_ScanAnimals5", "Scan 40 Animals" },
			{ "QG_Animals_Discovered", "QT_ScanAnimals6", "Scan 50 Animals" },
			{ "QG_Animals_Discovered", "QT_ScanAnimals7", "Scan 61 Animals" },
		{ "Side Quests", "QG_Animal_SIgn", "Photo Signs" },
			{ "QG_Animal_SIgn", "QT_RiceFields_WildlifeSIgn", "Rice Fields" },
			{ "QG_Animal_SIgn", "QT_Forest_WildlifeSIgn", "Forest" },
			{ "QG_Animal_SIgn", "QT_Castle_WildlifeSign", "Castle" },
			{ "QG_Animal_SIgn", "QT_Terraces_WildlifeSIgn", "Terraces" },
			{ "QG_Animals_Discovered", "QT_All_Animals_Photographed", "All Animals Photographed" },
		{ "Side Quests", "QG_WildlifeRescue", "Wildlife Rescue" },
			{ "QG_WildlifeRescue", "QT_Heal_birds_covered_in_oil_on_East_Beach", "Heal birds covered in oil on East Beach" },
			{ "QG_WildlifeRescue", "QT_Help_animals_caught_in_trash_on_Mountain", "Help animals caught in trash on Mountain" },
		{ "Side Quests", "QG_Cleanup_Island", "Clean up Island" },
			{ "QG_Cleanup_Island", "QT_Recycle_Encounters", "Pick up Rubbish" },
			{ "QG_Cleanup_Island", "QT_Recycle_Encounter_TownBeach", "Town Beach" },
			{ "QG_Cleanup_Island", "QT_Recycle_Encounter_TownPromenade", "Town Promenade" },
			{ "QG_Cleanup_Island", "QT_Recycle_Encounter_MarshBeach", "Marsh Beach" },
			{ "QG_Cleanup_Island", "QT_Recycle_Encounter_Woods", "Woods" },
			{ "QG_Cleanup_Island", "QT_Recycle_Encounter_Mountain", "Mountain" },
			{ "QG_Cleanup_Island", "QT_Recycle_Encounter_DolphinIsland", "La Roqueta" },
		{ "Side Quests", "QG_Clara_Animal_Seeking", "Clara Animal Seeking" },
			{ "QG_Clara_Animal_Seeking", "QT_Take_a_photo_of_the_Sparrowhawks_near_town", "Take a photo of the Sparrowhawks near town" },
			{ "QG_Clara_Animal_Seeking", "QT_ClaraHoopoe", "Take a photo of a Hoopoe" },
			{ "QG_Clara_Animal_Seeking", "QT_ClaraGlossyIbis", "Take a photo of a Glossy Ibis" },
		{ "Side Quests", "QT_Finish_fixing_Castle", "Finish fixing Castle" },
		{ "Side Quests", "QT_Scan_the_Owl", "Scan the Owl at the construction site" },
		{ "Side Quests", "QT_TellPepeLolaHasFreeIceCream", "Tell Pepe Lola has free Ice Cream" },
		{ "Side Quests", "QG_Marina_and_Socks", "Marina and Socks" },
			{ "QG_Marina_and_Socks", "QT_Find_lost_dog", "Find lost dog" },
			{ "QG_Marina_and_Socks", "QT_Return_lost_dog_to_owner", "Return lost dog to owner" }
	};

	settings.Add("dayEnd", true, "Split when the next day starts");
		settings.SetToolTip("dayEnd", "This splits when the player is able to\nperform the first input on the next day.");
	settings.Add("Main Quests");
	settings.Add("Side Quests");

	for (int i = 0; i < _settings.GetLength(0); ++i)
	{
		string parent = _settings[i, 0];
		string id     = _settings[i, 1];
		string desc   = _settings[i, 2];

		settings.Add(id, false, desc, parent);
	}
}

init
{
	const int PTR_SIZE = 0x8;

	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var list = helper.GetClass("mscorlib", "List`1");
		var str = helper.GetClass("mscorlib", "String");

		var service = helper.GetClass("com.unity-common.core", "Service`1");
		var sm = helper.GetClass("Assembly-CSharp", "StageManager", 1);

		vars.Unity.Make<int>(sm.Static, service["_instance"], sm["activeStage"]).Name = "activeStage";
		vars.Unity.Make<float>(sm.Static, service["_instance"], sm["_time"]).Name = "time";

		/*******************************************************************/
		var singleton = helper.GetClass("Assembly-CSharp", "Singleton`1");
		var qgm = helper.GetClass("Assembly-CSharp", "QuestGoalsManager", 1);
		var qgc = helper.GetClass("Assembly-CSharp", "QuestGoalsContainer");

		var qg = helper.GetClass("Assembly-CSharp", "QuestGoal");
		var qt = helper.GetClass("Assembly-CSharp", "QuestTask");

		var quests = vars.Unity.MakeList<IntPtr>(qgm.Static, singleton["_instance"], qgm["_container"], qgc["quests"]);

		vars.TaskValue = new MemoryWatcherList();
		vars.RequiredValue = new Dictionary<string, int>();

		for (int questId = 0; questId < quests.Count; ++questId)
		{
			var tasks = vars.Unity.MakeList<IntPtr>(quests[questId], qg["_tasks"]);

			for (int taskId = 0; taskId < tasks.Count; ++taskId)
			{
				IntPtr task = tasks[taskId];
				var name = new DeepPointer(task + qt["displayName"], str["m_firstChar"]).DerefString(game, 128);
				var max = game.ReadValue<int>(task + (int)(qt["maxValue"]));

				vars.RequiredValue[name] = max;
				vars.TaskValue.Add(new MemoryWatcher<float>(new DeepPointer(
					qgm.Static + singleton["_instance"], qgm["_container"], qgc["quests"], list["_items"],
					PTR_SIZE * 4 + PTR_SIZE * questId, qg["_tasks"], list["_items"],
					PTR_SIZE * 4 + PTR_SIZE * taskId, qt["currentValue"]))
					{ Name = name });
			}
		}

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.IGT = vars.Unity["time"].Current;
	current.Stage = vars.Unity["activeStage"].Current;
}

start
{
	return old.IGT == 0.0 && current.IGT > 0.0;
}

split
{
	vars.TaskValue.UpdateAll(game);
	foreach (var task in vars.TaskValue)
	{
		if (!task.Changed || !settings[task.Name])
			continue;

		return (int)(Math.Floor(task.Current)) == vars.RequiredValue[task.Name];
	}

	return current.Stage == old.Stage + 1 && settings["dayEnd"];
}

reset
{
	return old.IGT > 0.0 && current.IGT == 0.0;
}

gameTime
{
	return TimeSpan.FromSeconds(current.IGT);
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