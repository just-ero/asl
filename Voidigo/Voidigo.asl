state("Voidigo") {}

startup
{
	settings.Add("wrldSplits", true, "Split after leaving an area:");
		settings.Add("Antlantis", true, "Antlantis", "wrldSplits");
		settings.Add("Porko Land", true, "Porko Land", "wrldSplits");
		settings.Add("The Void", true, "The Void", "wrldSplits");
		settings.Add("Antivoid", false, "Antivoid", "wrldSplits");

	settings.Add("bossSplit", true, "Split when a boss becomes corrupted");
	settings.Add("beaconSplit", false, "Split when activating a beacon");

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var result = MessageBox.Show(
			"Voidigo uses in-game time.\nWould you like to switch to it?",
			"Voidigo Autosplitter",
			MessageBoxButtons.YesNo);

		if (result == DialogResult.Yes) timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

init
{
	Stopwatch SigTimeout = new Stopwatch();
	ProcessModuleWow64Safe Module = modules.FirstOrDefault(x => x.ModuleName.Equals("voidigo_livesplit.dll"));
	SignatureScanner ModuleScanner = new SignatureScanner(game, Module.BaseAddress, Module.ModuleMemorySize);

	SigScanTarget MagicStringSig = new SigScanTarget("40 40 56 6F 69 64 69 67 6F 2D 6C 69 76 65 73 70 6C 69 74 40 40");
	IntPtr MagicStringAddr = IntPtr.Zero;

	vars.SigFound = false;
	SigTimeout.Start();
	while (!vars.SigFound)
	{
		MagicStringAddr = ModuleScanner.Scan(MagicStringSig);
		vars.SigFound = MagicStringAddr != IntPtr.Zero;
		if (SigTimeout.ElapsedMilliseconds >= 1000) break;
	}
	SigTimeout.Reset();

	if (vars.SigFound)
	{
		//print("Found MagicString: 0x" + MagicStringAddr.ToString("X"));

		vars.RUNTIME               = MagicStringAddr + 0x20 + 0x100 * 0;
		vars.ALL_BOSSES_CORRUPTED  = MagicStringAddr + 0x20 + 0x100 * 1;
		vars.WORLD                 = MagicStringAddr + 0x20 + 0x100 * 2;
		vars.BEACONS_ACTIVATED     = MagicStringAddr + 0x20 + 0x100 * 3;
		vars.COMPLETED_RUN         = MagicStringAddr + 0x20 + 0x100 * 4;
	}
	else
	{
		MessageBox.Show(
			"Signature scan timed out!",
			"Voidigo Autosplitter",
			MessageBoxButtons.OK, MessageBoxIcon.Error
		);
	}

	timer.IsGameTimePaused = false;
}

update
{
	if (!vars.SigFound) return false;

	float f;
	int i;
	bool b;
	string s = game.ReadString((IntPtr)vars.WORLD, 256);

	current.World = String.IsNullOrEmpty(s) ? "None" : s;

	current.IGT = Single.TryParse(game.ReadString((IntPtr)vars.RUNTIME, 256), out f) ? f : 69f;

	Boolean.TryParse(game.ReadString((IntPtr)vars.ALL_BOSSES_CORRUPTED, 256), out b);
	current.CorruptedBosses = b;

	Int32.TryParse(game.ReadString((IntPtr)vars.BEACONS_ACTIVATED, 256), out i);
	current.Beacons = i;

	Boolean.TryParse(game.ReadString((IntPtr)vars.COMPLETED_RUN, 256), out b);
	current.Finished = b;
}

start
{
	return old.IGT > current.IGT && current.World != "None" && current.World != "Camp";
}

split
{
	if (old.World != current.World && old.World != "The Void")
		return settings[old.World];

	if (!old.CorruptedBosses && current.CorruptedBosses)
		return settings["bossSplit"];

	if (old.Beacons < current.Beacons)
		return settings["beaconSplit"];

	return !old.Finished && current.Finished && settings["The Void"];
}

reset
{
	return old.IGT > current.IGT || old.World != current.World && (current.World == "Camp" || String.IsNullOrEmpty(current.World));
}

gameTime
{
	if (new[]{"None", "Camp"}.All(x => x != current.World))
		return TimeSpan.FromSeconds(current.IGT);
}

isLoading
{
	return true;
}

exit
{
	timer.IsGameTimePaused = true;
}