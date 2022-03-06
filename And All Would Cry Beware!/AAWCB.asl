// Disclaimer: This is a very bad autosplitter in terms of execution.
// * Use of random pointers (can break) whose values I don't know.
// * Bunch of work-arounds due to that.

state("AndAllWouldCryBeware")
{
	int Scene    : "UnityPlayer.dll", 0x10B88A4, 0x18, 0x0, 0x70;    // SceneManager.Loading[0].Index
	int Entities : "UnityPlayer.dll", 0x106F6A0, 0x144, 0x84, 0x210; // ?
}

startup
{
	dynamic[,] _settings =
	{
		{ null, "areas", "Split when entering an area:", true },
			{ "areas", "5 -> 2", "Wayfarer Offices", true },
			{ "areas", "2 -> 3", "Mysterious Alien World", true },
			{ "areas", "3 -> 4", "Rebekah's Lab", false },
			{ "areas", "4 -> 10", "A Fresh Start", true },

		{ null, "events", "Split when doing certain events:", false },
			{ "events", "7-6", "Pick up Pistol", false },
			{ "events", "6-5", "Pick up Green Key", false },
			{ "events", "5-4", "Destroy Elevator", false },
			{ "events", "4-3", "Defeat Security Mech", false },
			{ "events", "MAW", "Defeat any boss in the Mysterious Alien World or collect Fire Orb", false },
			{ "events", "4 -> 11", "Defeat Transformed Rebekah", false }
	};

	for (int i = 0; i < _settings.GetLength(0); ++i)
	{
		string parent = _settings[i, 0];
		string id     = _settings[i, 1];
		string desc   = _settings[i, 2];
		bool   state  = _settings[i, 3];

		settings.Add(id, state, desc, parent);
	}
}

update
{
	if (current.Scene == 7 || current.Scene == 8) // don't care about loading screen scenes
		current.Scene = old.Scene;
}

start
{
	return old.Scene == 1 && current.Scene == 5;
}

split
{
	if (current.Entities == old.Entities - 1)
	{
		switch ((int)(current.Scene))
		{
			case 2: return settings[old.Entities + "-" + current.Entities];
			case 3: return settings["MAW"];
		}
	}

	if (old.Scene != current.Scene)
	{
		return settings[old.Scene + " -> " + current.Scene] ||
		       old.Scene == 10 && current.Scene == 9 ||
		       old.Scene == 11 && current.Scene == 9;
	}
}

reset
{
	return old.Scene != 0 && current.Scene == 0;
}