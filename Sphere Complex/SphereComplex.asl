// Bad! Love UE4 though. :)

state("SphereComplex-Win64-Shipping")
{
	float LevelTime : 0x2526B80, 0x30, 0x410, 0x480, 0x16C;
	float EndTime   : 0x2526B80, 0x30, 0x410, 0x480, 0x1D4;
	string128 Map   : 0x2512910, 0x678, 0x16;
}

start
{
	return old.LevelTime == 0f && current.LevelTime > 0f;
}

split
{
	return old.EndTime == 0f && current.EndTime > 0f;
}

reset
{
	return (current.Map == "SP_BEGINNER_01" || current.Map == "SP_BEGINNER0" || current.Map == "SP_ADVANCED_01") &&
	       old.LevelTime == 0f && current.LevelTime > 0f;
}