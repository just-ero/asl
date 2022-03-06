state("Just Shake It")
{
	bool IsEnding  : "UnityPlayer.dll", 0x19B5F90, 0xB48, 0x720, 0xF48, 0x18, 0x48;
	int Checkpoint : "UnityPlayer.dll", 0x19B5F90, 0xB48, 0x720, 0xF48, 0x40, 0x28;
	float ms       : "UnityPlayer.dll", 0x19B5F90, 0xB48, 0x720, 0xF48, 0x48, 0x28;
	int min        : "UnityPlayer.dll", 0x19B5F90, 0xB48, 0x720, 0xF48, 0x48, 0x2C;
	int s          : "UnityPlayer.dll", 0x19B5F90, 0xB48, 0x720, 0xF48, 0x48, 0x30;
	bool IsStart   : "UnityPlayer.dll", 0x19B5F90, 0xB48, 0x720, 0xF48, 0x48, 0x34;
}

startup
{
	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"Just Shake It uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | Just Shake It",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

start
{
	return !old.IsStart && current.IsStart;
}

split
{
	return old.Checkpoint != current.Checkpoint && current.Checkpoint > 1 || !old.IsEnding && current.IsEnding;
}

reset
{
	return old.IsStart != current.IsStart;
}

gameTime
{
	return TimeSpan.FromSeconds(current.min * 60 + current.s + current.ms);
}

isLoading
{
	return true;
}