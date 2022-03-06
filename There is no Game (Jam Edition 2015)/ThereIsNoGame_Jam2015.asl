state("Ting_Jam")
{
	string128 TriggerEvent : "GameAssembly.dll", 0xC94A38, 0xB88, 0x78, 0x1C, 0xC;
	float DialogueLength   : "GameAssembly.dll", 0xC6A9CC, 0x5C, 0x0, 0x30;
	int TreeState          : "GameAssembly.dll", 0xCC1C7C, 0x5C, 0x0, 0x1C, 0x90, 0x54, 0x10;
	int BrickInstance      : "UnityPlayer.dll",  0x1253A80, 0x10, 0x8, 0x18, 0x78, 0x4C, 0x2C, 0xC, 0x14;
	short BrickScore       : "UnityPlayer.dll",  0x1253A80, 0x10, 0x8, 0x18, 0x78, 0x4C, 0x2C, 0xC, 0x14, 0x1C;
}

startup
{
	settings.Add("Splits");
	settings.CurrentDefaultParent = "Splits";

	settings.Add("Mute the developer for the 3rd time", false);
	settings.Add("THERE IS A");
		settings.Add("TREE", false, "TREE", "THERE IS A");
		settings.Add("GOAT", false, "GOAT", "THERE IS A");
		settings.Add("GAME", true, "GAME", "THERE IS A");
	settings.Add("Reach 3000 points in BreakOut (glitches)");
	settings.Add("Grow tree all the way");
	settings.Add("Trade the squirrel a nut for the key", false);
	settings.Add("Free the goat", false);
	settings.Add("Choose Yes or No at the end");

	vars.SplitDialogues = new Dictionary<float, string>
	{
		{ 2.208752632f, "Mute the developer for the 3rd time" },
		{ 2.779047489f, "Free the goat" },
		{ 1.221632719f, "Trade the squirrel a nut for the key" }
	};

	vars.DoneWords = new List<string>();
}

onStart
{
	vars.DoneWords.Clear();
}

init
{
	var sB = new StringBuilder();
	vars.UpdateWord = (Func<string>)(() =>
	{
		sB.Clear();
		for (int i = 0; i < 4; ++i)
		{
			string slot = new DeepPointer("GameAssembly.dll", 0xC94A38, 0xBB8, 0x1C, 0x10 + 0x4 * i, 0xC).DerefString(game, 1);
			sB.Append(slot ?? "");
		}

		return sB.ToString();
	});

	current.Word = vars.UpdateWord();
}

update
{
	current.Word = vars.UpdateWord();
	current.TriggerEvent = current.TriggerEvent ?? old.TriggerEvent;
}

start
{
	if (old.TriggerEvent != current.TriggerEvent)
	{
		return current.TriggerEvent.StartsWith("EVT_OnFlag");
	}
}

split
{
	if (old.BrickScore == 2900 && current.BrickScore == 3000)
		return settings["Reach 3000 points in BreakOut (glitches)"];

	if (old.TreeState == 2 && current.TreeState == 3)
		return settings["Grow tree all the way"];

	if (old.TriggerEvent != current.TriggerEvent && current.TriggerEvent.StartsWith("EVT_Click"))
		return settings["Choose Yes or No at the end"];

	if (old.DialogueLength != current.DialogueLength)
	{
		if (!vars.SplitDialogues.ContainsKey(current.DialogueLength)) return;

		string setting = vars.SplitDialogues[current.DialogueLength];
		return settings[setting];
	}

	if (old.Word != current.Word)
	{
		if (!settings.ContainsKey(current.Word) || vars.DoneWords.Contains(current.Word)) return;
		vars.DoneWords.Add(current.Word);
		return settings[current.Word];
	}
}

reset
{
	return old.TriggerEvent != current.TriggerEvent && current.TriggerEvent.StartsWith("EVT_OnFlag") ||
	       old.BrickInstance != current.BrickInstance;
}