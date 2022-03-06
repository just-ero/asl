state("Maid of Sker") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Maid of Sker] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;

	string[,] _settings =
	{
		{ "scenes",         "MOS_LVL_ForestIntro",       "Forest Intro" },
		{ "scenes",         "MOS_LVL_GroundFloor",       "Ground Floor" },
		{ "scenes",         "MOS_LVL_Basement",          "Basement" },
		{ "scenes",         "MOS_LVL_ForestDark",        "Forest Dark" },
		{ "scenes",         "MOS_LVL_Garden",            "Garden" },
		{ "scenes",         "MOS_LVL_FirstFloor",        "First Floor" },
		{ "scenes",         "MOS_LVL_SecondFloor",       "Second Floor" },
		{ "scenes",         "MOS_LVL_ForestDark_End",    "Forst Dark (End)" },
		{ "musicSheets",    "Music Sheet - 04",          "Music Sheet: Thomas Evans" },
		{ "musicSheets",    "Music Sheet - 03",          "Music Sheet: Henry Hughes" },
		{ "musicSheets",    "Music Sheet - 02",          "Music Sheet: Matilda Norton" },
		{ "musicSheets",    "Music Sheet - 01",          "Music Sheet: Arthur Morris" },
		{ "musicCylinders", "Music Cylinder - Cerebrus", "Music Cylinder - Cerebrus" },
		{ "musicCylinders", "Music Cylinder - Hero",     "Music Cylinder - Hero" },
		{ "musicCylinders", "Music Cylinder - Siren",    "Music Cylinder - Siren" },
		{ "musicCylinders", "Music Cylinder - Medusa",   "Music Cylinder - Medusa" },
		{ "keys",           "Music Key",                 "Music Key" },
		{ "keys",           "Key",                       "Crown Key" },
		{ "misc",           "Phonic Modulator",          "Phonic Modulator" }
	};

	settings.Add("items", false, "Split when collecting an item:");
		settings.Add("musicSheets", false, "Music Sheets", "items");
		settings.Add("musicCylinders", false, "Music Cylinders", "items");
		settings.Add("keys", false, "Keys", "items");
		settings.Add("misc", false, "Other items", "items");
	settings.Add("scenes", false, "Split after finishing an area:");

	for (int i = 0; i < _settings.GetLength(0); ++i)
	{
		string parent = _settings[i, 0];
		string id     = _settings[i, 1];
		string desc   = _settings[i, 2];

		settings.Add(id, false, desc, parent);
	}

	vars.CollectedItems = new HashSet<string>();

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"Removing loads from Maid of Sker requires comparing against Game Time.\nWould you like to switch to it?",
			"LiveSplit | Maid of Sker",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

onStart
{
	vars.CollectedItems.Clear();
	vars.CutsceneNum = 0;
}

init
{
	current.CutsceneNum = 0;

	const int PTR_SIZE = 0x8;
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var str = helper.GetClass("mscorlib", "String");

		// LevelManager
		var lm = helper.GetClass("Assembly-CSharp", "WI_LevelManager", 1);

		vars.Unity.Make<bool>(lm.Static, PTR_SIZE * 2, lm["_IsLoading"]).Name = "loading";

		// PlayerController
		var pc = helper.GetClass("Assembly-CSharp", "WI_PlayerController_UFPS");
		var abl = helper.GetClass("Opsive.UltimateCharacterController", "Ability");

		vars.Unity.Make<int>(pc.Static, pc["_Instance"], pc["CutsceneAbility"], abl["m_StartTime"]).Name = "csStartTime";

		// Inventory
		var invM = helper.GetClass("Assembly-CSharp", "WI_InventoryManager");
		var invS = helper.GetClass("Assembly-CSharp", "WI_InventorySlot");
		var invI = helper.GetClass("Assembly-CSharp", "WI_InventoryItem");

		var invSize = new MemoryWatcher<int>(new DeepPointer(invM.Static + invM["Instance"], invM["Inventory"], PTR_SIZE * 3));

		current.Item = "No item!";
		vars.UpdateInventory = (Action)(() =>
		{
			if (invSize.Update(game) && invSize.Current != 0)
			{
				IntPtr itemNameAddr;
				new DeepPointer(
					invM.Static + invM["Instance"], invM["Inventory"],
					PTR_SIZE * 2, PTR_SIZE * 4 + PTR_SIZE * (invSize.Current - 1),
					invS["Item"], invI["Name"], 0x0).DerefOffsets(game, out itemNameAddr);

				var newItem = game.ReadString(itemNameAddr + (int)str["m_firstChar"], game.ReadValue<int>(itemNameAddr + (int)str["m_stringLength"]) * 2);
				if (!string.IsNullOrEmpty(newItem))
					current.Item = newItem;
			}
		});

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();
	vars.UpdateInventory();

	current.Scene = vars.Unity.Scenes.Loading[0].Name;
	current.CutsceneStartTime = vars.Unity["csStartTime"].Current;
	current.Loading = vars.Unity["loading"].Current;

	if (current.Scene == "MOS_LVL_GroundFloor" && old.CutsceneStartTime == -1 && current.CutsceneStartTime > 0)
		current.CutsceneNum++;
}

start
{
	return old.Item != current.Item && current.Item == "Music Sheet - 04";
}

split
{
	if (old.Item != current.Item && !vars.CollectedItems.Contains(current.Item))
	{
		vars.CollectedItems.Add(current.Item);
		return settings[current.Item];
	}

	return old.Scene != current.Scene && settings[old.Scene] ||
	       old.CutsceneNum != 3 && current.CutsceneNum == 3;
}

reset
{
	return old.Scene != current.Scene && current.Scene == "MOS_LVL_Frontend";
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