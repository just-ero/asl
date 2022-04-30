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
			{ "Key Items", "inventory quantity Wand : 1",                                          "Magic Orb" },
			{ "Key Items", "inventory quantity Techbow : 1",                                       "Fire Wand" },
			{ "Key Items", "inventory quantity Sword : 1",                                         "Sword" },
			{ "Key Items", "inventory quantity Hyperdash : 1",                                     "Hyperdash" },
			{ "Key Items", "inventory quantity SlowmoItem : 1",                                    "Hourglass" },
			{ "Key Items", "inventory quantity Shield : 1",                                        "Shield" },
			{ "Key Items", "inventory quantity Lantern : 1",                                       "Lantern" },
			{ "Key Items", "inventory quantity Stick : 1",                                         "Stick" },
			{ "Key Items", "inventory quantity Mask : 1",                                          "Mask" },
			{ "Key Items", "inventory quantity Shotgun : 1",                                       "Gun" },
			{ "Key Items", "inventory quantity Stundagger : 1",                                    "Ice Dagger" },
			{ "Key Items", "inventory quantity Hexagon Green : 1",                                 "Hexagon Green" },
			{ "Key Items", "inventory quantity Hexagon Red : 1",                                   "Hexagon Red" },
			{ "Key Items", "inventory quantity Hexagon Blue : 1",                                  "Hexagon Blue" },
			// Hero Relics - I'm honestly not sure which is which for Water/Crown/Sword
			{ "Key Items", "inventory quantity Relic - Hero Sword : 1",                            "Hero Relic Attack" },
			{ "Key Items", "inventory quantity Relic - Hero Crown : 1",                            "Hero Relic Defense" },
			{ "Key Items", "inventory quantity Relic - Hero Water : 1",                            "Hero Relic Potion" },
			{ "Key Items", "inventory quantity Relic - Hero Pendant HP : 1",                       "Hero Relic HP" },
			{ "Key Items", "inventory quantity Relic - Hero Pendant SP : 1",                       "Hero Relic SP" },
			{ "Key Items", "inventory quantity Relic - Hero Pendant MP : 1",                       "Hero Relic MP" },

		{ null, "Major Events", "Major Events" },
			{ "Major Events", "Rung Bell 1 (East) : 1",                   "Rung Bell 1 (East)" },
			{ "Major Events", "Rung Bell 2 (West) : 1",                   "Rung Bell 2 (West)" },
			{ "Major Events", "SV_Fortress Arena_Spidertank Is Dead : 1", "Killed Siege Engine" },
			{ "Major Events", "Librarian Dead Forever : 1",               "Killed Librarian" },
			{ "Major Events", "SV_ScavengerBossesDead : 1",               "Killed Boss Scavenger" },
			{ "Major Events", "Has Died To God : 1",                      "Died to Heir" },
			{ "Major Events", "Placed Hexagon 1 Red : 1",                 "Placed Hexagon 1 Red" },
			{ "Major Events", "Placed Hexagon 2 Green : 1",               "Placed Hexagon 2 Green" },
			{ "Major Events", "Placed Hexagon 3 Blue : 1",                "Placed Hexagon 3 Blue" },
			{ "Major Events", "Placed Hexagons ALL : 1",                  "Placed Hexagons ALL" },

		{ null, "Cards", "Cards" },
			{ "Cards", "inventory quantity Trinket - MP Flasks : 1",              "Inverted Ash" },
			{ "Cards", "inventory quantity Trinket - Glass Cannon : 1",           "Glass Cannon" },
			{ "Cards", "inventory quantity Trinket - BTSR : 1",                   "Cyan Peril Ring" },
			{ "Cards", "inventory quantity Trinket - Heartdrops : 1",             "Lucky Cup" },
			{ "Cards", "inventory quantity Trinket - Bloodstain Plus : 1",        "Louder Echo" },
			{ "Cards", "inventory quantity Trinket - RTSR : 1",                   "Orange Peril Ring" },
			{ "Cards", "inventory quantity Trinket - Attack Up Defense Down : 1", "Tincture" },
			{ "Cards", "inventory quantity Trinket - Block Plus : 1",             "Bracer" },
			{ "Cards", "inventory quantity Trinket - Bloodstain MP : 1",          "Magic Echo" },
			{ "Cards", "inventory quantity Trinket - Fast Icedagger : 1",         "Dagger Strap" },
			{ "Cards", "inventory quantity Trinket - Stamina Recharge : 1",       "Perfume" },
			{ "Cards", "inventory quantity Trinket - Sneaky : 1",                 "Muffling Bell" },
			{ "Cards", "inventory quantity Trinket - Walk Speed Plus : 1",        "Anklet" },
			{ "Cards", "inventory quantity Trinket - Parry Window : 1",           "Aura's Gem" },
			{ "Cards", "inventory quantity Trinket - IFrames : 1",                "Bone" },

		{ null, "Fairies", "Fairies" },
			{ "Fairies", "SV_Fairy_1_Overworld_Flowers_Upper_Opened : 1", "1 - Flowers 1 (Upper)" },
			{ "Fairies", "SV_Fairy_2_Overworld_Flowers_Lower_Opened : 1", "2 - Flowers 2 (Lower)" },
			{ "Fairies", "SV_Fairy_3_Overworld_Moss_Opened : 1",          "3 - Moss" },
			{ "Fairies", "SV_Fairy_4_Caustics_Opened : 1",                "4 - Casting Light" },
			{ "Fairies", "SV_Fairy_5_Waterfall_Opened : 1",               "5 - Secret Gathering Place" },
			{ "Fairies", "SV_Fairy_6_Temple_Opened : 1",                  "6 - Sealed Temple" },
			{ "Fairies", "SV_Fairy_7_Quarry_Opened : 1",                  "7 - Quarry" },
			{ "Fairies", "SV_Fairy_8_Dancer_Opened : 1",                  "8 - East Forest (Dancer)" },
			{ "Fairies", "SV_Fairy_9_Library_Rug_Opened : 1",             "9 - The Great Library" },
			{ "Fairies", "SV_Fairy_10_3DPillar_Opened : 1",               "10 - Maze (Column)" },
			{ "Fairies", "SV_Fairy_11_WeatherVane_Opened : 1",            "11 - Vane" },
			{ "Fairies", "SV_Fairy_12_House_Opened : 1",                  "12 - House" },
			{ "Fairies", "SV_Fairy_13_Patrol_Opened : 1",                 "13 - Patrol" },
			{ "Fairies", "SV_Fairy_14_Cube_Opened : 1",                   "14 - Cube" },
			{ "Fairies", "SV_Fairy_15_Maze_Opened : 1",                   "15 - Maze (Invisible)" },
			{ "Fairies", "SV_Fairy_16_Fountain_Opened : 1",               "16 - Fountain" },
			{ "Fairies", "SV_Fairy_17_GardenTree_Opened : 1",             "17 - West Garden (Tree)" },
			{ "Fairies", "SV_Fairy_18_GardenCourtyard_Opened : 1",        "18 - West Garden (Courtyard)" },
			{ "Fairies", "SV_Fairy_19_FortressCandles_Opened : 1",        "19 - Fortress of the Eastern Vault" },
			{ "Fairies", "SV_Fairy_20_ForestMonolith_Opened : 1",         "20 - East Forest (Obelisk)" },
			{ "Fairies", "SV_Fairy_00_Enough Fairies Found : 1",          "Found 10 fairies" },
			{ "Fairies", "SV_Fairy_00_All Fairies Found : 1",             "Found 20 fairies" },

		{ null, "Golden Trophies", "Golden Trophies" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_1 : 1", "1 - Mr Mayor" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_2 : 1", "2 - A Secret Legend" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_3 : 1", "3 - Sacred Geometry" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_4 : 1", "4 - Vintage" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_5 : 1", "5 - Just Some Pals" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_6 : 1", "6 - Regal Weasel" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_7 : 1", "7 - Sprinng Falls" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_8 : 1", "8 - Power Up" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_9 : 1", "9 - Back to Work" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_10 : 1", "10 - Phonomath" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_11 : 1", "11 - Dusty" },
			{ "Golden Trophies", "inventory quantity GoldenTrophy_12 : 1", "12 - Forever Friend" },

		{ null, "Pages", "Pages" },
			{ "Pages", "unlocked page 0 : 1", "Page 0-1" },
			{ "Pages", "unlocked page 1 : 1", "Page 2-3" },
			{ "Pages", "unlocked page 2 : 1", "Page 4-5" },
			{ "Pages", "unlocked page 3 : 1", "Page 6-7" },
			{ "Pages", "unlocked page 4 : 1", "Page 8-9" },
			{ "Pages", "unlocked page 5 : 1", "Page 10-11" },
			{ "Pages", "unlocked page 6 : 1", "Page 12-13" },
			{ "Pages", "unlocked page 7 : 1", "Page 14-15" },
			{ "Pages", "unlocked page 8 : 1", "Page 16-17" },
			{ "Pages", "unlocked page 9 : 1", "Page 18-19" },
			{ "Pages", "unlocked page 10 : 1", "Page 20-21" },
			{ "Pages", "unlocked page 11 : 1", "Page 22-23" },
			{ "Pages", "unlocked page 12 : 1", "Page 24-25" },
			{ "Pages", "unlocked page 13 : 1", "Page 26-27" },
			{ "Pages", "unlocked page 14 : 1", "Page 28-29" },
			{ "Pages", "unlocked page 15 : 1", "Page 30-31" },
			{ "Pages", "unlocked page 16 : 1", "Page 32-33" },
			{ "Pages", "unlocked page 17 : 1", "Page 34-35" },
			{ "Pages", "unlocked page 18 : 1", "Page 36-37" },
			{ "Pages", "unlocked page 19 : 1", "Page 38-39" },
			{ "Pages", "unlocked page 20 : 1", "Page 40-41" },
			{ "Pages", "unlocked page 21 : 1", "Page 42-43" },
			{ "Pages", "unlocked page 22 : 1", "Page 44-45" },
			{ "Pages", "unlocked page 23 : 1", "Page 46-47" },
			{ "Pages", "unlocked page 24 : 1", "Page 48-49" },
			{ "Pages", "unlocked page 25 : 1", "Page 50-51" },
			{ "Pages", "unlocked page 26 : 1", "Page 52-53" },
			{ "Pages", "unlocked page 27 : 1", "Page 54-55" },

		{ null, "Areas", "Areas" },
			{ "Areas", "scEvery", "Split every single time the selected areas are visited" },
			{ "Areas", "scOnce", "Split only the first time the selected areas are visited"},

			{ "Areas", "scGeneral", "General Areas" },
				{ "scGeneral", "sc24", "Overworld" },
				{ "scGeneral", "sc38", "Teleport Area" },
				{ "scGeneral", "sc23", "Temple" },
				{ "scGeneral", "sc25", "Shield Area" },
				{ "scGeneral", "sc26", "Well" },
				{ "scGeneral", "sc63", "Dark Tomb" },

			{ "Areas", "scMountain", "Mountain" },
				{ "scMountain", "sc08", "Mountain" },
				{ "scMountain", "sc09", "Mountain Top" },

			{ "Areas", "scEast", "East" },
				{ "scEast", "sc52", "East Forest" },
				{ "scEast", "sc11", "East Forest Sword" },
				{ "scEast", "sc54", "East Forest Guardhouse" },
				{ "scEast", "sc10", "East Forest Boss Room" },
				{ "scEast", "sc35", "East Beltower" },

			{ "Areas", "scWest", "West" },
				{ "scWest", "sc30", "West Garden" },

			{ "Areas", "sc31", "Atoll" },

			{ "Areas", "scFrog", "Frog Cave" },
				{ "scFrog", "sc32", "Way to Frog Cave" },
				{ "scFrog", "sc51", "Frog Cave" },

			{ "Areas", "scFortress", "Fortress" },
				{ "scFortress", "sc12", "Fortress" },
				{ "scFortress", "sc14", "Fortress Courtyard" },
				{ "scFortress", "sc13", "Fortress Basement" },
				{ "scFortress", "sc15", "Siege Arena" },

			{ "Areas", "scLibrary", "Library" },
				{ "scLibrary", "sc33", "Library Exterior" },
				{ "scLibrary", "sc18", "Library Hall" },
				{ "scLibrary", "sc19", "Library Rotunda" },
				{ "scLibrary", "sc17", "Library Lab" },
				{ "scLibrary", "sc27", "Librarian Arena" },

			{ "Areas", "scQuarry", "Quarry" },
				{ "scQuarry", "sc22", "Way to Quarry" },
				{ "scQuarry", "sc59", "Quarry" },
				{ "scQuarry", "sc21", "Monastery" },

			{ "Areas", "scZiggurat", "Ziggurat" },
				{ "scZiggurat", "sc44", "Ziggurat Entrance" },
				{ "scZiggurat", "sc42", "Ziggurat" },
				{ "scZiggurat", "sc41", "Ziggurat Transition" },
				{ "scZiggurat", "sc43", "Ziggurat 2" },

			{ "Areas", "scSwamp", "Swamp" },
				{ "scSwamp", "sc58", "Swamp" },
				{ "scSwamp", "sc68", "Cathedral" },
				{ "scSwamp", "sc60", "Gauntlet Arena" },

			{ "Areas", "sc62", "Heir Arena" },

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
	vars.CanStart = false;
	vars.CompletedSplits = new HashSet<string>();
}

onStart
{
	var igt = current.IGT;
	vars.StartTime = igt < 1f ? 0f : igt;
	vars.CanStart = false;
	vars.CompletedSplits.Clear();
}

init
{
	current.Event = "";
	current.Scene = -1;

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
	if (!vars.Unity.Loaded)
		return false;

	vars.Unity.Update();

	current.TimerRunning = vars.Unity["timerRunning"].Current;
	current.IGT = vars.Unity["inGameTime"].Current;
	current.GameComplete = vars.Unity["gameComplete"].Current;

	var evnt = vars.Unity["lastEvent"].Current ?? "";
	if (!evnt.StartsWith("playtime") && !evnt.StartsWith("permanentlyDead"))
		current.Event = evnt;


	var scId = vars.Unity.Scenes.Active.Index;
	if (scId > 0 && scId != 80)
		current.Scene = scId;
}

start
{
	if (old.Scene == 2 && current.Scene == 24)
		vars.CanStart = true;

	return vars.CanStart && !old.TimerRunning && current.TimerRunning;
}

split
{
	if (old.Scene != current.Scene)
	{
		vars.Log("Scene changed: " + old.Scene + " -> " + current.Scene);

		var cS = "sc" + current.Scene;
		if (settings["scOnce"] && !vars.CompletedSplits.Contains(cS) || settings["scEvery"])
		{
			vars.CompletedSplits.Add(cS);

			if (settings.ContainsKey(cS) && settings[cS])
				return true;
		}
	}

	var cE = current.Event;
	if (old.Event != cE && !vars.CompletedSplits.Contains(cE))
	{
		vars.Log(cE);
		vars.CompletedSplits.Add(cE);

		if (settings.ContainsKey(cE) && settings[cE])
			return true;
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