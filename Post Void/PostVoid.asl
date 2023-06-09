state("Post Void")
{
	// double InGameScore : 0x128AE8, 0x50, 0x21C, 0x318, 0x0;
	// double HitsTaken   : 0x4B2780, 0x2C, 0x10, 0x18, 0x40;
	// double Headshots   : 0x4B2780, 0x2C, 0x10, 0x18, 0x60;
	// double Shots       : 0x4B2780, 0x2C, 0x10, 0x18, 0x70;
	// double Hits        : 0x4B2780, 0x2C, 0x10, 0x18, 0x80;
	// double Kills       : 0x4B2780, 0x2C, 0x10, 0x18, 0xA0;
	double IGTLevel    : 0x813390, 0x48, 0x10, 0x690, 0x30;
	double IGTFull     : 0x813390, 0x48, 0x10, 0x220, 0x1B0;
	double LevelID     : 0x813390, 0x48, 0x10, 0x220, 0x1D0;
}

startup
{
	vars.FinalLevel = false;
	vars.TimerModel = new TimerModel { CurrentState = timer };

	settings.Add("lvlSplits", true, "Choose which level(s) to split on:");
		settings.Add("99to0", true, "After the Tutorial", "lvlSplits");
		settings.Add("0to1", true, "After Level 1", "lvlSplits");
		settings.Add("1to2", true, "After Level 2", "lvlSplits");
		settings.Add("2to3", true, "After Level 3", "lvlSplits");
		settings.Add("3to4", true, "After Level 4", "lvlSplits");
		settings.Add("4to5", true, "After Level 5", "lvlSplits");
		settings.Add("5to6", true, "After Level 6", "lvlSplits");
		settings.Add("6to7", true, "After Level 7", "lvlSplits");
		settings.Add("7to8", true, "After Level 8", "lvlSplits");
		settings.Add("8to9", true, "After Level 9", "lvlSplits");
		settings.Add("9to10", true, "After Level 10", "lvlSplits");
		settings.Add("finalSplit", true, "After Level 11", "lvlSplits");
}

onStart
{
	vars.FinalLevel = false;
}

start
{
	return old.IGTFull == 0 && current.IGTFull > 0;
}

split
{
	if (current.LevelID == 10 && old.IGTLevel == 0 && current.IGTLevel > 0)
		vars.FinalLevel = true;

	return old.LevelID != current.LevelID && settings[old.LevelID + "to" + current.LevelID] ||
	       vars.FinalLevel && old.IGTLevel > 0 && current.IGTLevel == 0 && settings["finalSplit"];
}

reset
{
	return old.LevelID != 99 && current.IGTFull == 0 && old.IGTFull > 0;
}

gameTime
{
	if (current.IGTFull != 0)
		return TimeSpan.FromSeconds(current.IGTFull);
}

isLoading
{
	return true;
}

exit
{
	if (timer.CurrentPhase != TimerPhase.Ended)
		vars.TimerModel.Reset();
}
