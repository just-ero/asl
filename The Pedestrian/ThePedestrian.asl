// BAD!

state("ThePed_Win_64")
{
	float Speed: "UnityPlayer.dll", 0x144FBD8, 0x8, 0xA8, 0x28, 0x9C;
}

startup
{
	settings.Add("splits", true, "Splitting upon transitioning");
		settings.Add("111", true, "with the Elevator to the Subway (code 111)", "splits");
		settings.Add("199", false, "with the Train to Downtown (code 199)", "splits");
		settings.Add("748", false, "with the Train to University (code 748)", "splits");
		settings.Add("274", false, "with the Train to Innercity (code 274)", "splits");
		settings.Add("772", true, "with the Train to pre-Rooftops (code 772)", "splits");
		settings.Add("399", false, "with the Elevator to the Rooftops (code 399)", "splits");
		settings.Add("444", true, "with the Elevator to the final Level (code 444)", "splits");
		settings.Add("184", true, "into the Apartments", "splits");
}

init
{
	string logPath = Environment.GetEnvironmentVariable("appdata") + @"\..\LocalLow\Skookum Arts\The Pedestrian\output_log.txt";
	try {
		FileStream fs = new FileStream(logPath, FileMode.Open, FileAccess.Write, FileShare.ReadWrite);
		fs.SetLength(0);
		fs.Close();
	} catch {
		print("Can't open Ped log");
	}
	vars.Line = String.Empty;
	vars.Reader = new StreamReader(new FileStream(logPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
	vars.FinalSplit = false;
}

update
{
	if (vars.Reader == null) return false;
	vars.Line = vars.Reader.ReadLine();
}

start
{
	return old.Speed == 0 && current.Speed != 0;
}

split
{
	if (String.IsNullOrEmpty(vars.Line)) return;

	if (vars.Line.StartsWith("Load Area "))
	{
		string AreaNumber = vars.Line.Split(' ')[2];
		//print("got " + AreaNumber);
		return (settings[AreaNumber]);
	}

	if (vars.Line.StartsWith("Machine Button!"))
		vars.FinalSplit = true;

	if (vars.Line.StartsWith("Audio trigger: Apartment_Music_Progress") && vars.FinalSplit)
	{
		vars.FinalSplit = false;
		return true;
	}
}

exit
{
	vars.Reader = null;
}