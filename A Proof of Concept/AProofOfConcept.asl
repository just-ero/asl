state("A Proof of Concept 1.1")
{
	int LevelID : 0x6C2DB8;
	// int Time : 0x6C2DE0;
}

state("Concept - v2.6")
{
	int LevelID : 0x6FFF60;
}

startup
{
	string[,] _settings =
	{
		{ "libSplits", "0 -> 1", "Enter Vault/Museum from Library" },
		{ "libSplits", "0 -> 2", "Enter Main Frame from Library" },
		{ "libSplits", "0 -> 6", "Enter Power Plant from Library" },
		{ "libSplits", "0 -> 8", "Enter Gravitational Management from Library (2.0+)" },
		{ "libSplits", "0 -> 11", "Enter SA * RC from Library (2.0+)" },
		{ "libSplits", "0 -> 7", "Enter Woods from Library" },
		{ "libSplits", "0 -> 4", "Enter Great Door from Library" },

		{ "libBackSplits", "1 -> 0", "Leave Museum/Vault to Library" },
		{ "libBackSplits", "2 -> 0", "Leave Main Frame to Library" },
		{ "libBackSplits", "5 -> 0", "Leave Back Door level to Library" },
		{ "libBackSplits", "6 -> 0", "Leave Power Plant to Library" },
		{ "libBackSplits", "9 -> 0", "Leave Centrifuge to Library (2.0+)" },
		{ "libBackSplits", "12 -> 0", "Leave Event Horizon to Library (2.0+)" },
		{ "libBackSplits", "14 -> 0", "Leave Continuum to Library (2.0+)" },
		{ "libBackSplits", "7 -> 0", "Leave Woods to Library" },

		{ "inLevelSplits", "4 -> 3", "Enter Archive from Big Orb Room" },
		{ "inLevelSplits", "mainFrame", "Splits in Main Frame:" },
			{ "mainFrame", "2 -> 3", "Enter second half of Main Frame" },
			{ "mainFrame", "3 -> 4", "Enter Back Door Corridor from Main Frame" },
			{ "mainFrame", "4 -> 5", "Enter Back Door level from Corridor" },
		{ "inLevelSplits", "centrifuge", "Splits in Centrifuge (2.0+):" },
			{ "centrifuge", "8 -> 9", "Enter Centrifuge from Gravitational Management" },
			{ "centrifuge", "9 -> 10", "Enter Warp Machine from Centrifuge" },
		{ "inLevelSplits", "eventHorizon", "Splits in Event Horizon (2.0+):" },
			{ "eventHorizon", "11 -> 12", "Enter Event Horizon from SA * RC" },
			{ "eventHorizon", "11 -> 13", "Enter Professor's lab from SA * RC" },
			{ "eventHorizon", "13 -> 14", "Enter Continuum from lab" }
	};

	settings.Add("libSplits", false, "Split when going into a level:");
	settings.Add("libBackSplits", false, "Split when finishing a level:");
	settings.Add("inLevelSplits", false, "Split within a level:");

	for (int i = 0; i < _settings.GetLength(0); ++i)
	{
		string parent = _settings[i, 0];
		string id     = _settings[i, 1];
		string desc   = _settings[i, 2];

		settings.Add(id, false, desc, _settings);
	}

	vars.PrevOffset = timer.Run.Offset;
}

onStart
{
	timer.Run.Offset = vars.PrevOffset;
}

init
{
	switch (game.ProcessName)
	{
		case "A Proof of Concept 1.1":
			vars.LevelIDByIndex = new List<int> { 12, 5, 6, 7, 9, 10, 11, 14 };
			break;
		case "Concept - v2.6":
			vars.LevelIDByIndex = new List<int>
			{
				21, // Library
				12, // Museum
				13, // Main Frame
				15, // Main Frame 2 / Archive
				17, // Back Door 0.5 / Great Door
				18, // Back Door
				19, // Power Plant
				23, // Woods
				14, // Gravitational Management
				31, // Centrifuge
				 4, // Warp Machine
				 3, // SA * RC
				20, // Event Horizon
				 5, // Professor's lab
				10  // Continuum
			};
			break;
	}
}

start
{
	if (old.LevelID == current.LevelID)
		return;

	switch (game.ProcessName)
	{
		case "A Proof of Concept 1.1" :
			var start = old.LevelID == 1 && current.LevelID == 4;
			break;
		case "Concept - v2.6" :
			var start = old.LevelID == 2 && current.LevelID == 11;
			break;
	}

	if (start)
	{
		vars.PrevOffset = timer.Run.Offset;
		timer.Run.Offset = TimeSpan.FromSeconds(20f / 3f);
		return true;
	}
}

split
{
	if (old.LevelID == current.LevelID)
		return;

	int oldIndex = vars.LevelIDByIndex.IndexOf(old.LevelID);
	int currIndex = vars.LevelIDByIndex.IndexOf(current.LevelID);
	return settings[oldIndex + " -> " + currIndex];
}

reset
{
	if (old.LevelID == current.LevelID)
		return;

	switch (game.ProcessName)
	{
		case "A Proof of Concept 1.1" :
			return old.LevelID != 0 && old.LevelID != 4 && current.LevelID == 0;
		case "Concept - v2.6"         :
			return current.LevelID == 2;
	}
}