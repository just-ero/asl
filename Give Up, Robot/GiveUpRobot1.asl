state("GiveUpRobot")
{
	int TotalCount   : "Adobe AIR.dll", 0x1393398, 0x4, 0x24, 0xA8, 0x18, 0x534, 0x10, 0x18, 0x20;
	int PartialCount : "Adobe AIR.dll", 0x1393364, 0x80, 0xB4, 0x6D8, 0x64, 0x10, 0x78, 0x64;
	int Level        : "Adobe AIR.dll", 0x1393364, 0x80, 0xB4, 0x6D8, 0x64, 0x10, 0x78, 0x6C;
}

state("flashplayer_32_sa", "Normal Flash Player")
{
	int TotalCount   : 0xD1DD48, 0x8BC, 0x8, 0x68, 0xC, 0x8, 0x14, 0x69C, 0x10, 0x18, 0x20;
	int PartialCount : 0xD1DD48, 0x8BC, 0x8, 0x68, 0xC, 0x8, 0x14, 0x2D8, 0x10, 0x78, 0x64;
	int Level        : 0xD1DD48, 0x8BC, 0x8, 0x68, 0xC, 0x8, 0x14, 0x2D8, 0x10, 0x78, 0x6C;
}

state("flashplayer_32_sa_debug", "Debug Flash Player")
{
	int TotalCount   : 0xDA07D8, 0xC, 0x818, 0x8, 0x24, 0xC8, 0x18, 0x69C, 0x10, 0x18, 0x20;
	int PartialCount : 0xDA07D8, 0xC, 0x818, 0x8, 0x24, 0xC8, 0x18, 0x2D8, 0x10, 0x78, 0x64;
	int Level        : 0xDA07D8, 0xC, 0x818, 0x8, 0x24, 0xC8, 0x18, 0x2D8, 0x10, 0x78, 0x6C;
}

startup
{
	vars.ResetStopwatch = new Stopwatch();

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"Give Up, Robot uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | Give Up, Robot",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

start
{
	return current.Level == 1 && old.PartialCount == 0 && current.PartialCount > 0;
}

split
{
	return current.Level == old.Level + 1 ||
	       old.Level != current.Level && old.Level % 10 == 0 && old.Level != 80;
}

reset
{
	if (old.Level != 0 && current.Level == 0)
		vars.ResetStopwatch.Restart();

	if (vars.ResetStopwatch.Elapsed.TotalSeconds >= 0.1f)
	{
		vars.ResetStopwatch.Reset();
		return true;
	}
}

gameTime
{
	return current.Level == 80
	       ? TimeSpan.FromSeconds(current.TotalCount / 60f)
	       : TimeSpan.FromSeconds((current.TotalCount + current.PartialCount) / 60f);
}

isLoading
{
	return true;
}