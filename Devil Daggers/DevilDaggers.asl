state("dd")
{
	float Timer : 0x227BE0, 0x34;
	int   State : 0x227BE0, 0xF4;
}

startup
{
	vars.TimerModel = new TimerModel { CurrentState = timer };

	vars.WAVES = new[]
	{
		003, 014, 019, 024, 039, 049, 064, 079,
		094, 109, 114, 119, 134, 144, 154, 164,
		174, 184, 189, 194, 199, 229, 239, 244,
		259, 274, 289, 304, 330, 350, 365, 370,
		375, 397, 400, 406, 412, 417, 418, 419,
		424, 427, 430, 440, 441, 442, 447, 449,
		451, 456, 459, 462, 467, 472, 473, 474,
		484, 485, 486, 491, 492, 497, 502, 507
	};
}

update
{
	if (old.State == 3 && current.State == 4)
		vars.TimerModel.Pause();
}

start
{
	return old.State != 3 && current.State == 3;
}

split
{
	return ((int[])vars.WAVES).Any(waveTime => old.Timer < waveTime && current.Timer >= waveTime);
}

reset
{
	return old.State != current.State && current.State != 4;
}

gameTime
{
	return TimeSpan.FromSeconds(current.Timer);
}

isLoading
{
	return true;
}