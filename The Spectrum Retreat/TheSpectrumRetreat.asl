// Dogshit.

state("Spectrum")
{
	int Screen : "mono.dll", 0x01F50AC, 0xA80, 0x20, 0x24;
	int Mouse  : "UnityPlayer.dll", 0x0FD789C, 0x38, 0x20, 0x8, 0x44;
	int Level  : "UnityPlayer.dll", 0x0FD8D74, 0x54, 0x1E0, 0x22C, 0x3A0;
}

startup
{
	settings.Add("day1splits", true, "Day 1 splits:");
		settings.Add("day1time8", false, "Leave Room", "day1splits");
		settings.Add("day1time12", true, "Enter Code", "day1splits");
		settings.Add("day1and47to39", true, "Finishing 1_01", "day1splits");
		settings.Add("day1and39to26", true, "Finishing 1_02", "day1splits");
		settings.Add("day1and26to46", true, "Finishing 1_03", "day1splits");
		settings.Add("day1and46to135", true, "Finishing 1_04", "day1splits");
		settings.Add("day1and135to113", true, "Arrive back at Hotel (finishing 1_05)", "day1splits");

	settings.Add("day2splits", true, "Day 2 splits:");
		settings.Add("day2time7", false, "Wake Up", "day2splits");
		settings.Add("day2time8", false, "Leave Room", "day2splits");
		settings.Add("day2time9", false, "Finish Breakfast", "day2splits");
		settings.Add("day2time10", false, "Exit Elevator to Floor 2", "day2splits");
		settings.Add("day2time13", true, "Enter Code", "day2splits");
		settings.Add("day2and46to51", true, "Finishing 2_01", "day2splits");
		settings.Add("day2and51to59", true, "Finishing 2_02", "day2splits");
		settings.Add("day2and59to54", true, "Finishing 2_03", "day2splits");
		settings.Add("day2and54to46", true, "Finishing 2_04", "day2splits");
		settings.Add("day2and9to30", true, "Finishing 2_05", "day2splits");
		settings.Add("day2and30to26", true, "Finishing 2_06", "day2splits");
		settings.Add("day2and26to64", true, "Finishing 2_07", "day2splits");
		settings.Add("day2and64to53", true, "Finishing 2_08", "day2splits");
		settings.Add("day2and53to60", true, "Finishing 2_09", "day2splits");
		settings.Add("day2and18to8", true, "Arrive back at Hotel (finishing 2_10)", "day2splits");
		settings.Add("day2and8to113", false, "Taking Elevator to Floor 1", "day2splits");

	settings.Add("day3splits", true, "Day 3 splits:");
		settings.Add("day3time7", false, "Wake Up", "day3splits");
		settings.Add("day3time8", false, "Leave Room", "day3splits");
		settings.Add("day3time9", false, "Finish Breakfast", "day3splits");
		settings.Add("day3time10", false, "Exit Elevator to Floor 3", "day3splits");
		settings.Add("day3time13", true, "Enter Code", "day3splits");
		settings.Add("day3and31to50", true, "Finishing 3_01", "day3splits");
		settings.Add("day3and50to30", true, "Finishing 3_02", "day3splits");
		settings.Add("day3and30to31", false, "Finishing 3_03 (no skip)", "day3splits");
		settings.Add("day3and30to65", true, "Finishing 3_03 (with skip)", "day3splits");
		settings.Add("day3and31to65", true, "Finishing 3_04", "day3splits");
		settings.Add("day3and65to58", true, "Finishing 3_05", "day3splits");
		settings.Add("day3and58to36", true, "Finishing 3_06", "day3splits");
		settings.Add("day3and36to64", true, "Finishing 3_07", "day3splits");
		settings.Add("day3and64to60", false, "Finishing 3_08 (no skip)", "day3splits");
		settings.Add("day3and64to10", true, "Finishing 3_08 (with skip)", "day3splits");
		settings.Add("day3and60to10", true, "Arrive back at Hotel (finishing 3_09)", "day3splits");
		settings.Add("day3and10to113", false, "Taking Elevator to Floor 1", "day3splits");

	settings.Add("day4splits", true, "Day 4 splits:");
		settings.Add("day4time7", false, "Wake Up", "day4splits");
		settings.Add("day4time8", false, "Leave Room", "day4splits");
		settings.Add("day4time9", false, "Finish Breakfast", "day4splits");
		settings.Add("day4time10", false, "Exit Elevator to Floor 4", "day4splits");
		settings.Add("day4time14", true, "Enter Code", "day4splits");
		settings.Add("day4and80to41", true, "Finishing 4_01", "day4splits");
		settings.Add("day4and41to60", true, "Finishing 4_02", "day4splits");
		settings.Add("day4and60to44", false, "Finishing 4_03", "day4splits");
		settings.Add("day4and44to41", true, "Finishing 4_04", "day4splits");
		settings.Add("day4and41to46", true, "Finishing 4_05", "day4splits");
		settings.Add("day4and46to66", true, "Finishing 4_06", "day4splits");
		settings.Add("day4and66to65", true, "Finishing 4_07", "day4splits");
		settings.Add("day4and65to10", true, "Arrive back at Hotel (finishing 4_08)", "day4splits");
		settings.Add("day4and10to113", false, "Taking Elevator to Floor 1", "day4splits");

	settings.Add("day5splits", true, "Day 5 splits:");
		settings.Add("day5time7", false, "Wake Up", "day5splits");
		settings.Add("day5time8", false, "Leave Room", "day5splits");
		settings.Add("day5time9", false, "Finish Breakfast", "day5splits");
		settings.Add("day5time10", false, "Exit Elevator to Floor 5", "day5splits");
		settings.Add("day5time13", true, "Enter Code", "day5splits");
		settings.Add("day5and160to8", true, "Arrive back at Hotel (finishing 5_01)", "day5splits");
		settings.Add("day5and8to113", false, "Taking Elevator to Floor 1", "day5splits");

	settings.Add("day6splits", false, "Day 6 splits:");
		settings.Add("day6time7", false, "Wake Up", "day6splits");
		settings.Add("day6time9", false, "Leave Room", "day6splits");
		settings.Add("day6time10", false, "Exit Elevator to Roof", "day6splits");
}

init
{
	string logPath = Environment.GetEnvironmentVariable("appdata")+"\\..\\LocalLow\\Ripstone\\The Spectrum Retreat\\output_log.txt";
	vars.Line = String.Empty;
	vars.Reader = new StreamReader(new FileStream(logPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));

	vars.Time = String.Empty;
	vars.Day = "1";
	vars.Date = String.Empty;
	vars.RoofHelp = 0;
	vars.LastRealLevel = 0;
	vars.StoreNewLevel = 0;

	vars.Reader.BaseStream.Seek(0, SeekOrigin.End);
}

update {
	if (vars.Reader == null) return false;
	vars.Line = vars.Reader.ReadLine();

	if (old.Level != current.Level && current.Level != 0)
	{
		vars.LastRealLevel = vars.StoreNewLevel;
		vars.StoreNewLevel = current.Level;
		print(">>>>> storeNewLevel changed to " + vars.StoreNewLevel + " and lastRealLevel changed to " + vars.LastRealLevel);
	}

	if (!String.IsNullOrEmpty(vars.Line) && vars.Line.StartsWith("Time advanced to "))
	{
		vars.Time = vars.Line.Split(' ')[3];
		vars.Day  = vars.Line.Split(' ')[6];
		vars.Date = "day" + vars.Day.ToString() + "time" + vars.Time.ToString();
	}
}

start
{
	if (current.Screen != 14 && old.Screen == 14)
	{
		vars.RoofHelp = 0;
		return true;
	}
}

split
{
	if (String.IsNullOrEmpty(vars.Line)) return;

	if (vars.Date == "day6time10" && old.Mouse == 257 && current.Mouse == 0)
	{
		++vars.RoofHelp;
		return vars.RoofHelp == 2;
	}

	if (old.Level != current.Level && vars.LastRealLevel != vars.StoreNewLevel && settings["day" + vars.Day + "and" + vars.LastRealLevel + "to" + vars.StoreNewLevel])
	{
		vars.LastRealLevel = vars.StoreNewLevel;
		return true;
	}

	return vars.Line.StartsWith("Time advanced to ") && settings[vars.Date];
}

reset
{
	return current.Screen == 14 && old.Screen == 18;
}

exit
{
	vars.Reader = null;
}