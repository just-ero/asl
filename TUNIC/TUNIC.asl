state("TUNIC") {}
state("Secret Legend") {}

startup
{
	vars.Log = (Action<object>)(output => print("[TUNIC] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;

	string[,] _settings =
	{
		{ null, "Key Items", "Key Items" },
			{ "Key Items", "inventory quantity Wand : 1",                                          "Wand" },
			{ "Key Items", "inventory quantity Techbow : 1",                                       "Techbow" },
			{ "Key Items", "inventory quantity Sword : 1",                                         "Sword" },
			{ "Key Items", "inventory quantity Hyperdash : 1",                                     "Hyperdash" },
			{ "Key Items", "inventory quantity SlowmoItem : 1",                                    "SlowmoItem" },
			{ "Key Items", "inventory quantity Shield : 1",                                        "Shield" },
			{ "Key Items", "inventory quantity Lantern : 1",                                       "Lantern" },
			{ "Key Items", "inventory quantity Stick : 1",                                         "Stick" },
			{ "Key Items", "inventory quantity Mask : 1",                                          "Mask" },
			{ "Key Items", "inventory quantity Shotgun : 1",                                       "Shotgun" },
			{ "Key Items", "inventory quantity Stundagger : 1",                                    "Stundagger" },
			{ "Key Items", "inventory quantity Hexagon Green : 1",                                 "Hexagon Green" },
			{ "Key Items", "inventory quantity Hexagon Red : 1",                                   "Hexagon Red" },
			{ "Key Items", "inventory quantity Hexagon Blue : 1",                                  "Hexagon Blue" },

			{ "Key Items", "inventory quantity Upgrade Offering - Attack - Tooth : 1",             "Upgrade Offering - Attack - Tooth" },
			{ "Key Items", "inventory quantity Upgrade Offering - DamageResist - Effigy : 1",      "Upgrade Offering - DamageResist - Effigy" },
			{ "Key Items", "inventory quantity Upgrade Offering - PotionEfficiency Swig - As : 1", "Upgrade Offering - PotionEfficiency Swig - As" },
			{ "Key Items", "inventory quantity Upgrade Offering - Stamina SP - Feather : 1",       "Upgrade Offering - Stamina SP - Feather" },
			{ "Key Items", "inventory quantity Upgrade Offering - Magic MP - Mushroom : 1",        "Upgrade Offering - Magic MP - Mushroom" },
			{ "Key Items", "inventory quantity Relic - Hero Pendant SP : 1",                       "Relic - Hero Pendant SP" },
			{ "Key Items", "inventory quantity Relic - Hero Crown : 1",                            "Relic - Hero Crown" },
			{ "Key Items", "inventory quantity Relic - Hero Pendant MP : 1",                       "Relic - Hero Pendant MP" },
			{ "Key Items", "inventory quantity Relic - Hero Sword : 1",                            "Relic - Hero Sword" },
			{ "Key Items", "inventory quantity Relic - Hero Pendant HP : 1",                       "Relic - Hero Pendant HP" },
			{ "Key Items", "inventory quantity Relic - Hero Water : 1",                            "Relic - Hero Water" },

		{ null, "Major Events", "Major Events" },
			{ "Major Events", "Rung Bell 1 (East) : 1",                   "Rung Bell 1 (East)" },
			{ "Major Events", "Rung Bell 2 (West) : 1",                   "Rung Bell 2 (West)" },
			{ "Major Events", "SV_Fortress Arena_Spidertank Is Dead : 1", "SV_Fortress Arena_Spidertank Is Dead" },
			{ "Major Events", "Librarian Dead Forever : 1",               "Librarian Dead Forever" },
			{ "Major Events", "SV_ScavengerBossesDead : 1",               "SV_ScavengerBossesDead" },
			{ "Major Events", "Has Been Betrayed : 1",                    "Has Been Betrayed" },
			{ "Major Events", "Has Died To God : 1",                      "Has Died To God" },
			{ "Major Events", "Placed Hexagon 1 Red : 1",                 "Placed Hexagon 1 Red" },
			{ "Major Events", "Placed Hexagon 2 Green : 1",               "Placed Hexagon 2 Green" },
			{ "Major Events", "Placed Hexagon 3 Blue : 1",                "Placed Hexagon 3 Blue" },
			{ "Major Events", "Placed Hexagons ALL : 1",                  "Placed Hexagons ALL" },

		{ null, "Trinkets", "Trinkets" },
			{ "Trinkets", "inventory quantity Trinket - MP Flasks : 1",              "Trinket - MP Flasks" },
			{ "Trinkets", "inventory quantity Trinket - Glass Cannon : 1",           "Trinket - Glass Cannon" },
			{ "Trinkets", "inventory quantity Trinket - BTSR : 1",                   "Trinket - BTSR" },
			{ "Trinkets", "inventory quantity Trinket - Heartdrops : 1",             "Trinket - Heartdrops" },
			{ "Trinkets", "inventory quantity Trinket - Bloodstain Plus : 1",        "Trinket - Bloodstain Plus" },
			{ "Trinkets", "inventory quantity Trinket - RTSR : 1",                   "Trinket - RTSR" },
			{ "Trinkets", "inventory quantity Trinket - Attack Up Defense Down : 1", "Trinket - Attack Up Defense Down" },
			{ "Trinkets", "inventory quantity Trinket - Block Plus : 1",             "Trinket - Block Plus" },
			{ "Trinkets", "inventory quantity Trinket - Bloodstain MP : 1",          "Trinket - Bloodstain MP" },
			{ "Trinkets", "inventory quantity Trinket - Fast Icedagger : 1",         "Trinket - Fast Icedagger" },
			{ "Trinkets", "inventory quantity Trinket - Stamina Recharge : 1",       "Trinket - Stamina Recharge" },
			{ "Trinkets", "inventory quantity Trinket - Sneaky : 1",                 "Trinket - Sneaky" },
			{ "Trinkets", "inventory quantity Trinket - Walk Speed Plus : 1",        "Trinket - Walk Speed Plus" },
			{ "Trinkets", "inventory quantity Trinket - Parry Window : 1",           "Trinket - Parry Window" },
			{ "Trinkets", "inventory quantity Trinket - IFrames : 1",                "Trinket - IFrames" },

		{ null, "Fairies", "Fairies" },
			{ "Fairies", "SV_Fairy_16_Fountain_Revealed : 1", "SV_Fairy_16_Fountain_Revealed" },
			{ "Fairies", "SV_Fairy_3_Overworld_Moss_Revealed : 1", "SV_Fairy_3_Overworld_Moss_Revealed" },
			{ "Fairies", "SV_Fairy_3_Overworld_Moss_Opened : 1", "SV_Fairy_3_Overworld_Moss_Opened" },
			{ "Fairies", "SV_Fairy_4_Caustics_Revealed : 1", "SV_Fairy_4_Caustics_Revealed" },
			{ "Fairies", "SV_Fairy_4_Caustics_Opened : 1", "SV_Fairy_4_Caustics_Opened" },
			{ "Fairies", "SV_Fairy_15_Maze_Revealed : 1", "SV_Fairy_15_Maze_Revealed" },
			{ "Fairies", "SV_Fairy_15_Maze_Opened : 1", "SV_Fairy_15_Maze_Opened" },
			{ "Fairies", "SV_Fairy_2_Overworld_Flowers_Lower_Revealed : 1", "SV_Fairy_2_Overworld_Flowers_Lower_Revealed" },
			{ "Fairies", "SV_Fairy_2_Overworld_Flowers_Lower_Opened : 1", "SV_Fairy_2_Overworld_Flowers_Lower_Opened" },
			{ "Fairies", "SV_Fairy_10_3DPillar_Revealed : 1", "SV_Fairy_10_3DPillar_Revealed" },
			{ "Fairies", "SV_Fairy_10_3DPillar_Opened : 1", "SV_Fairy_10_3DPillar_Opened" },
			{ "Fairies", "SV_Fairy_18_GardenCourtyard_Revealed : 1", "SV_Fairy_18_GardenCourtyard_Revealed" },
			{ "Fairies", "SV_Fairy_18_GardenCourtyard_Opened : 1", "SV_Fairy_18_GardenCourtyard_Opened" },
			{ "Fairies", "SV_Fairy_17_GardenTree_Revealed : 1", "SV_Fairy_17_GardenTree_Revealed" },
			{ "Fairies", "SV_Fairy_17_GardenTree_Opened : 1", "SV_Fairy_17_GardenTree_Opened" },
			{ "Fairies", "SV_Fairy_16_Fountain_Opened : 1", "SV_Fairy_16_Fountain_Opened" },
			{ "Fairies", "SV_Fairy_14_Cube_Revealed : 1", "SV_Fairy_14_Cube_Revealed" },
			{ "Fairies", "SV_Fairy_14_Cube_Opened : 1", "SV_Fairy_14_Cube_Opened" },
			{ "Fairies", "SV_Fairy_12_House_Revealed : 1", "SV_Fairy_12_House_Revealed" },
			{ "Fairies", "SV_Fairy_12_House_Opened : 1", "SV_Fairy_12_House_Opened" },
			{ "Fairies", "SV_Fairy_9_Library_Rug_Revealed : 1", "SV_Fairy_9_Library_Rug_Revealed" },
			{ "Fairies", "SV_Fairy_9_Library_Rug_Opened : 1", "SV_Fairy_9_Library_Rug_Opened" },
			{ "Fairies", "SV_Fairy_20_ForestMonolith_Revealed : 1", "SV_Fairy_20_ForestMonolith_Revealed" },
			{ "Fairies", "SV_Fairy_20_ForestMonolith_Opened : 1", "SV_Fairy_20_ForestMonolith_Opened" },
			{ "Fairies", "SV_Fairy_8_Dancer_Revealed : 1", "SV_Fairy_8_Dancer_Revealed" },
			{ "Fairies", "SV_Fairy_8_Dancer_Opened : 1", "SV_Fairy_8_Dancer_Opened" },
			{ "Fairies", "SV_Fairy_11_WeatherVane_Revealed : 1", "SV_Fairy_11_WeatherVane_Revealed" },
			{ "Fairies", "SV_Fairy_11_WeatherVane_Opened : 1", "SV_Fairy_11_WeatherVane_Opened" },
			{ "Fairies", "SV_Fairy_1_Overworld_Flowers_Upper_Revealed : 1", "SV_Fairy_1_Overworld_Flowers_Upper_Revealed" },
			{ "Fairies", "SV_Fairy_13_Patrol_Revealed : 1", "SV_Fairy_13_Patrol_Revealed" },
			{ "Fairies", "SV_Fairy_13_Patrol_Opened : 1", "SV_Fairy_13_Patrol_Opened" },
			{ "Fairies", "SV_Fairy_1_Overworld_Flowers_Upper_Opened : 1", "SV_Fairy_1_Overworld_Flowers_Upper_Opened" },
			{ "Fairies", "SV_Fairy_19_FortressCandles_Revealed : 1", "SV_Fairy_19_FortressCandles_Revealed" },
			{ "Fairies", "SV_Fairy_19_FortressCandles_Opened : 1", "SV_Fairy_19_FortressCandles_Opened" },
			{ "Fairies", "SV_Fairy_7_Quarry_Revealed : 1", "SV_Fairy_7_Quarry_Revealed" },
			{ "Fairies", "SV_Fairy_7_Quarry_Opened : 1", "SV_Fairy_7_Quarry_Opened" },
			{ "Fairies", "SV_Fairy_6_Temple_Revealed : 1", "SV_Fairy_6_Temple_Revealed" },
			{ "Fairies", "SV_Fairy_6_Temple_Opened : 1", "SV_Fairy_6_Temple_Opened" },
			{ "Fairies", "SV_Fairy_00_Enough Fairies Found : 1", "SV_Fairy_00_Enough Fairies Found" },
			{ "Fairies", "SV_Fairy_5_Waterfall_Revealed : 1", "SV_Fairy_5_Waterfall_Revealed" },
			{ "Fairies", "SV_Fairy_5_Waterfall_Opened : 1", "SV_Fairy_5_Waterfall_Opened" },
			{ "Fairies", "SV_Fairy_00_All Fairies Found : 1", "SV_Fairy_00_All Fairies Found" },

		{ null, "Obelisks", "Obelisks" },
			{ "Obelisks", "fuseClosed 1305 : 1", "fuseClosed 1305" },
			{ "Obelisks", "fuseClosed 1101 : 1", "fuseClosed 1101" },
			{ "Obelisks", "fuseClosed 1262 : 1", "fuseClosed 1262" },
			{ "Obelisks", "fuseClosed 952 : 1", "fuseClosed 952" },
			{ "Obelisks", "fuseClosed 949 : 1", "fuseClosed 949" },
			{ "Obelisks", "fuseClosed 950 : 1", "fuseClosed 950" },
			{ "Obelisks", "fuseClosed 951 : 1", "fuseClosed 951" },
			{ "Obelisks", "fuseClosed 1055 : 1", "fuseClosed 1055" },
			{ "Obelisks", "fuseClosed 1014 : 1", "fuseClosed 1014" },

		{ null, "Golden Trophies", "Golden Trophies" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_9 : 1", "GoldenTrophy_9" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_2 : 1", "GoldenTrophy_2" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_4 : 1", "GoldenTrophy_4" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_8 : 1", "GoldenTrophy_8" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_3 : 1", "GoldenTrophy_3" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_10 : 1", "GoldenTrophy_10" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_12 : 1", "GoldenTrophy_12" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_6 : 1", "GoldenTrophy_6" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_5 : 1", "GoldenTrophy_5" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_11 : 1", "GoldenTrophy_11" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_7 : 1", "GoldenTrophy_7" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_1 : 1", "GoldenTrophy_1" },

		{ null, "Pages", "Pages" },
			{ "Pages", "unlocked page 8 : 1", "unlocked page 8" },
			{ "Pages", "unlocked page 24 : 1", "unlocked page 24" },
			{ "Pages", "unlocked page 23 : 1", "unlocked page 23" },
			{ "Pages", "unlocked page 4 : 1", "unlocked page 4" },
			{ "Pages", "unlocked page 16 : 1", "unlocked page 16" },
			{ "Pages", "unlocked page 13 : 1", "unlocked page 13" },
			{ "Pages", "unlocked page 21 : 1", "unlocked page 21" },
			{ "Pages", "unlocked page 22 : 1", "unlocked page 22" },
			{ "Pages", "unlocked page 26 : 1", "unlocked page 26" },
			{ "Pages", "unlocked page 2 : 1", "unlocked page 2" },
			{ "Pages", "unlocked page 9 : 1", "unlocked page 9" },
			{ "Pages", "unlocked page 17 : 1", "unlocked page 17" },
			{ "Pages", "unlocked page 15 : 1", "unlocked page 15" },
			{ "Pages", "unlocked page 20 : 1", "unlocked page 20" },
			{ "Pages", "unlocked page 25 : 1", "unlocked page 25" },
			{ "Pages", "unlocked page 19 : 1", "unlocked page 19" },
			{ "Pages", "unlocked page 1 : 1", "unlocked page 1" },
			{ "Pages", "unlocked page 7 : 1", "unlocked page 7" },
			{ "Pages", "unlocked page 6 : 1", "unlocked page 6" },
			{ "Pages", "unlocked page 14 : 1", "unlocked page 14" },
			{ "Pages", "unlocked page 11 : 1", "unlocked page 11" },
			{ "Pages", "unlocked page 3 : 1", "unlocked page 3" },
			{ "Pages", "unlocked page 18 : 1", "unlocked page 18" },
			{ "Pages", "unlocked page 10 : 1", "unlocked page 10" },
			{ "Pages", "unlocked page 0 : 1", "unlocked page 0" },
			{ "Pages", "unlocked page 12 : 1", "unlocked page 12" },
			{ "Pages", "unlocked page 27 : 1", "unlocked page 27" },
			{ "Pages", "unlocked page 5 : 1", "unlocked page 5" },

		// { null, "", "" },
		// 	{ "", "", "" },
	};

	for (int i = 0; i < _settings.GetLength(0); i++)
	{
		var parent = _settings[i, 0];
		var id     = _settings[i, 1];
		var desc   = _settings[i, 2];

		settings.Add(id, parent == null, desc, parent);
	}

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"TUNIC uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | TUNIC",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}

	vars.StartTime = 0f;
	vars.CompletedEvents = new List<string>();
}

onStart
{
	var igt = current.IGT;
	vars.StartTime = igt < 1f ? 0f : igt;
	vars.CompletedEvents.Clear();
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var srd = helper.GetClass("Assembly-CSharp", "SpeedrunData");

		vars.Unity.Make<float>(srd.Static, srd["inGameTime"]).Name = "inGameTime";
		vars.Unity.Make<bool>(srd.Static, srd["timerRunning"]).Name = "timerRunning";
		vars.Unity.Make<int>(srd.Static, srd["lastLoadedSceneIndex"]).Name = "lastLoadedSceneIndex";
		vars.Unity.Make<bool>(srd.Static, srd["gameComplete"]).Name = "gameComplete";
		vars.Unity.MakeString(srd.Static, srd["LastEvent"]).Name = "lastEvent";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.IGT = vars.Unity["inGameTime"].Current;
	current.GameComplete = vars.Unity["gameComplete"].Current;
	current.Event = vars.Unity["lastEvent"].Current;

	if (current.Event.StartsWith("playtime"))
		current.Event = old.Event;

	current.Scene = vars.Unity.Scenes.Active.Index;
	if (current.Scene <= 0 || current.Scene == 80)
		current.Scene = old.Scene;

	if (old.Scene != current.Scene)
		vars.Log("Scene changed: " + old.Scene + " -> " + current.Scene);
}

start
{
	return old.IGT == 0f && current.IGT > 0f;
}

split
{
	if (old.Event != current.Event && !vars.CompletedEvents.Contains(current.Event))
	{
		vars.Log(current.Event);

		vars.CompletedEvents.Add(current.Event);
		return settings[current.Event];
	}

	return !old.GameComplete && current.GameComplete;
}

reset
{
	return old.IGT > 0f && current.IGT == 0f;
}

gameTime
{
	return TimeSpan.FromSeconds(current.IGT - vars.StartTime);
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