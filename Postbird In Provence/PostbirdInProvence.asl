state("PostbirdInProvence")
{
	int      Managers : "GameAssembly.dll", 0x203BA50, 0xB8, 0x0, 0x28, 0x30, 0x18;
	string64 Dialogue : "GameAssembly.dll", 0x203BA50, 0xB8, 0x0, 0x28, 0x60, 0x30, 0x10, 0x30, 0x50, 0x10, 0x14;
	int      Node     : "GameAssembly.dll", 0x203BA50, 0xB8, 0x0, 0x28, 0x60, 0x30, 0x10, 0x30, 0x50, 0x18;
	uint     Day      : "GameAssembly.dll", 0x203BA50, 0xB8, 0x0, 0x28, 0xA8;
}

startup
{
	vars.Dbg = (Action<dynamic>) ((output) => print("[Postbird ASL] " + output));

	dynamic[,] _settings =
	{
		{ null, "Split when finishing the day", true },
		{ null, "Community manager", true },
			{ "Community manager", "Enchanté Henri", false },
			{ "Community manager", "Enchanté Daphné", false },
			{ "Community manager", "Enchanté Charline", false },
			{ "Community manager", "Enchanté Charles", false },
			{ "Community manager", "Enchanté Charlie", false },
			{ "Community manager", "Enchanté Rosette", false },
			{ "Community manager", "Enchanté Louis", false },
			{ "Community manager", "Enchanté Jean", false },
			{ "Community manager", "Enchanté Léon", false },

		{ null, "Tourist", true },
			{ "Tourist", "The viewpoint", false },
			{ "Tourist", "The island", false },
			{ "Tourist", "The marina", false },
			{ "Tourist", "The picnic area", false },
			{ "Tourist", "The main plaza", false },

		{ null, "Fear of silence", true },
			{ "Fear of silence", "Montélimace FM", false },

		{ null, "Philatelist", true },
			{ "Philatelist", "Only 9 left!", false },

		{ null, "Honk honk", true },
		{ null, "E.T.", true },
		{ null, "Crazy driving", true },
		{ null, "Use splash!", true },
		{ null, "Ohlala", true },
		{ null, "Inspector Marcel", true },
		{ null, "Run like the wind", true },
		{ null, "Handyman", true },
		{ null, "Professional basketball player", true },
		{ null, "The green thumb", true },
		{ null, "The new champ", true },
		{ null, "Postbird in Provence", true }
	};

	for (int i = 0; i < _settings.GetLength(0); ++i)
	{
		string parent = _settings[i, 0];
		string id     = _settings[i, 1];
		bool   state  = _settings[i, 2];

		settings.Add(id, state, id, parent);
	}
}

onStart
{
	vars.UpdateAchievements();
}

init
{
	string[] achvNames =
	{
		"Enchanté Henri",
		"Enchanté Daphné",
		"Enchanté Charline",
		"Enchanté Charles",
		"Enchanté Charlie",
		"Enchanté Rosette",
		"Enchanté Louis",
		"Enchanté Jean",
		"Enchanté Léon",
		"The viewpoint",
		"The island",
		"The marina",
		"The picnic area",
		"The main plaza",
		"Community manager",
		"Tourist",
		"Fear of silence",
		"Montélimace FM",
		"Philatelist",
		"Only 9 left!",
		"Honk honk",
		"E.T.",
		"Crazy driving",
		"Use splash!",
		"Ohlala",
		"Inspector Marcel",
		"Run like the wind",
		"Handyman",
		"Professional basketball player",
		"The green thumb",
		"The new champ",
		"Postbird in Provence"
	};

	vars.Achievements = new MemoryWatcherList();
	vars.UpdateAchievements = (Action)(() =>
	{
		vars.Achievements = new MemoryWatcherList();

		for (int i = 0; i < 32; ++i)
		{
			var ptr = new DeepPointer("GameAssembly.dll", 0x203BA50, 0xB8, 0x0, 0x28, 0x80, 0x20, 0x20 + 0x8 * i, 0x70).Deref<IntPtr>(game);
			vars.Achievements.Add(new MemoryWatcher<bool>(ptr + 0x10) { Name = achvNames[i] });
		}
	});
}

start
{
	return old.Node == 4 && current.Node > 4 && current.Dialogue == "Player.Dialogue.IntroCinematic";
}

split
{
	vars.Achievements.UpdateAll(game);

	foreach (MemoryWatcher<bool> watcher in vars.Achievements)
	{
		if (!watcher.Old && watcher.Current && settings[watcher.Name])
			return true;
	}

	return old.Day < current.Day && settings["Split when finishing the day"] ||
	       old.Dialogue == "Player.Dialogue.EndGameCutScene" && string.IsNullOrEmpty(current.Dialogue);
}

reset
{
	return old.Managers != 2 && current.Managers == 2;
}