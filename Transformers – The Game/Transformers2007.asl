state ("Transformers")
{
	int State    : 0x2FB208; // Player state. 1 = can move and is on foot, 0 = cannot move or is driving.
	int Level    : 0x2FB284; // Current level ID. Starts at 0 for level 1.
	int Chapter  : 0x313630; // Current mission ID. Starts at 0, changes the instant a mission is entered.
	int Saving   : 0x314454; // Changes from 0 to 3 when the 'Autosaving' screen comes up.
	float IGT    : 0x2FB5B8; // In-game time.
	// int progress : 0x282ADC0;
}

startup
{
	settings.Add("autobots", true, "Autobots");
		settings.Add("lvl0Splits", true, "The Suburbs", "autobots");
			settings.Add("lvl0c0", true, "Chapter 1 - Uninvited Guests", "lvl0Splits");
			settings.Add("lvl0c1", true, "Chapter 2 - Guardian Angel", "lvl0Splits");
			settings.Add("lvl0c2", true, "Chapter 3 - Protect and Serve", "lvl0Splits");
			settings.Add("lvl0c3", true, "Chapter 4 - Air Traffic Control", "lvl0Splits");

		settings.Add("lvl1Splits", true, "More Than Meets The Eye", "autobots");
			settings.Add("lvl1c0", true, "Chapter 1 - Obstruction of Justice", "lvl1Splits");
			settings.Add("lvl1c1", true, "Chapter 2 - A Friend in Need", "lvl1Splits");
			settings.Add("lvl1c2", true, "Chapter 3 - Flight of the Bumblebee", "lvl1Splits");
			settings.Add("lvl1c3", true, "Chapter 4 - Heavy Weapon", "lvl1Splits");

		settings.Add("lvl2Splits", true, "Inside Hoover Dam", "autobots");
			settings.Add("lvl2c0", true, "Chapter 1 - Breakout!", "lvl2Splits");
			settings.Add("lvl2c1", true, "Chapter 2 - Tunnel Vision", "lvl2Splits");
			settings.Add("lvl2c2", true, "Chapter 3 - Power Drain", "lvl2Splits");
			settings.Add("lvl2c3", true, "Chapter 4 - Waking Giant", "lvl2Splits");

		settings.Add("lvl4Splits", true, "The Last Stand");
			settings.Add("lvl4c0", true, "Chapter 1 - Exterminator", "lvl4Splits");
			settings.Add("lvl4c1", true, "Chapter 2 - Unfriendly Skies", "lvl4Splits");
			settings.Add("lvl4c2", true, "Chapter 3 - For the Fallen", "lvl4Splits");
			settings.Add("lvl4c3", true, "Chapter 4 - Keep Away", "lvl4Splits");


	settings.Add("decepticons", true, "Decepticons");
		settings.Add("lvl6Splits", true, "SOCCENT Military Base", "decepticons");
			settings.Add("lvl6c0", true, "Chapter 1 - Sand Storm", "lvl6Splits");
			settings.Add("lvl6c1", true, "Chapter 2 - Communication Breakdown", "lvl6Splits");
			settings.Add("lvl6c2", true, "Chapter 3 - Seek and Destroy", "lvl6Splits");
			settings.Add("lvl6c3", true, "Chapter 4 - Fire in the Sky", "lvl6Splits");

		settings.Add("lvl7Splits", true, "The Hunt for Sam Witwicky", "decepticons");
			settings.Add("lvl7c0", true, "Chapter 1 - Rough Justice", "lvl7Splits");
			settings.Add("lvl7c1", true, "Chapter 2 - Race for Frenzy", "lvl7Splits");
			settings.Add("lvl7c2", true, "Chapter 3 - Pursuit", "lvl7Splits");
			settings.Add("lvl7c3", true, "Chapter 4 - Plight of the Bumblebee", "lvl7Splits");

		settings.Add("lvl8Splits", true, "A Gathering Force", "decepticons");
			settings.Add("lvl8c0", true, "Chapter 1 - Clearing the Air", "lvl8Splits");
			settings.Add("lvl8c1", true, "Chapter 2 - Sinister Savior", "lvl8Splits");
			settings.Add("lvl8c2", true, "Chapter 3 - Fireworks", "lvl8Splits");
			settings.Add("lvl8c3", true, "Chapter 4 - Warpath", "lvl8Splits");

		settings.Add("lvl10Splits", true, "City of the Machines", "decepticons");
			settings.Add("lvl10c0", true, "Chapter 1 - Nowhere to Run", "lvl10Splits");
			settings.Add("lvl10c1", true, "Chapter 2 - Energon Overload", "lvl10Splits");
			settings.Add("lvl10c2", true, "Chapter 3 - The Mighty will Fall", "lvl10Splits");
			settings.Add("lvl10c3", true, "Chapter 4 - Devestation", "lvl10Splits");

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"Removing loads from Transformers: The Game requires comparing against Game Time.\nWould you like to switch to it?",
			"LiveSplit | Transformers: The Game",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

start
{
	return old.State == 0 && current.State == 1 && current.IGT > 7.5 && current.IGT < 8.5;
}

split
{
	return old.Saving == 0 && current.Saving == 1 && settings["lvl" + current.Level + "c" + current.Chapter];
}

isLoading
{
	return old.IGT == current.IGT;
}