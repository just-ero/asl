state("yapp")
{
	int Location          : "mono.dll", 0x263110, 0xA0, 0x20, 0x30;
	// int xPos              : "mono.dll", 0x263110, 0xA0, 0x20, 0x38;
	// int yPos              : "mono.dll", 0x263110, 0xA0, 0x20, 0x3C;
	// string1800 dataString : "mono.dll", 0x263110, 0xA0, 0x28, 0x14;
}

startup
{
	for (int wrld = 1; wrld <= 7; ++wrld)
	{
		string parent = "World " + wrld + " Splits:";
		settings.Add(parent);

		for (int lvl = 1; lvl <= 8; ++lvl)
			settings.Add("w" + wrld + "l" + lvl, true, lvl == 8 ? "Castle" : "Level " + lvl, parent);
	}
}

init
{
	vars.SolvedWatchers = new MemoryWatcherList();

	for (int wrld = 1; wrld <= 7; ++wrld)
		for (int lvl = 1; lvl <= 8; ++lvl)
			vars.SolvedWatchers.Add(new MemoryWatcher<bool>(new DeepPointer("mono.dll", 0x263110, 0xA0, 0x20, 0x10, 0x20 + 10 * wrld + lvl)) {Name = "w" + wrld + "l" + lvl});
}

start
{
	return old.Location == 1 && current.Location == 2;
}

split
{
	vars.SolvedWatchers.UpdateAll(game);

	foreach (var watcher in vars.SolvedWatchers)
		if (watcher.Changed && watcher.Current)
			return settings[watcher.Name];
}

reset
{
	return old.Location == 2 && current.Location == 1;
}