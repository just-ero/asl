state("TUNIC") {}
state("Secret Legend") {}

startup
{
	vars.Log = (Action<object>)(output => print("[TUNIC] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"TUNIC uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | TUNIC",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}

	vars.StartTime = 0f;
	vars.TempInts = new Dictionary<string, int>();
	vars.TempFloats = new Dictionary<string, float>();
	vars.TempStrings = new Dictionary<string, string>();
}

onStart
{
	var igt = current.IGT;
	vars.StartTime = igt < 1f ? 0f : igt;

	vars.TempInts.Clear();
	vars.TempFloats.Clear();
	vars.TempStrings.Clear();
}

onSplit
{}

onReset
{}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		helper.Offsets = new[] { 0x30, 0x1C, 0x120 };

		var srd = helper.GetClass("Assembly-CSharp", "SpeedrunData");

		vars.Unity.Make<float>(srd.Static, srd["inGameTime"]).Name = "inGameTime";
		vars.Unity.Make<bool>(srd.Static, srd["timerRunning"]).Name = "timerRunning";
		vars.Unity.Make<int>(srd.Static, srd["lastLoadedSceneIndex"]).Name = "lastLoadedSceneIndex";
		vars.Unity.Make<bool>(srd.Static, srd["gameComplete"]).Name = "gameComplete";

		#region Save File
		var sf = helper.GetClass("Assembly-CSharp", "SaveFile");

		vars.Unity.Make<int>(sf.Static, sf["intStore"], 0x20).Name = "ints";
		vars.Unity.Make<int>(sf.Static, sf["floatStore"], 0x20).Name = "floats";
		vars.Unity.Make<int>(sf.Static, sf["stringStore"], 0x20).Name = "strings";

		vars.UpdateDicts = (Action)(() =>
		{
			for (int i = 0; i < vars.Unity["ints"].Current; ++i)
			{
				var key = new DeepPointer(sf.Static + sf["intStore"], 0x18, 0x28 + 0x18 * i, 0x14).DerefString(game, 128);
				var value = new DeepPointer(sf.Static + sf["intStore"], 0x18, 0x30 + 0x18 * i).Deref<int>(game);

				int temp;
				if (vars.TempInts.TryGetValue(key, out temp))
				{
					if (temp != value) vars.Log("Int item changed: " + key + " | " + temp + " -> " + value);
				}
				else
				{
					vars.Log("Int item added: " + key + " | " + value);
				}

				vars.TempInts[key] = value;
			}

			for (int i = 0; i < vars.Unity["floats"].Current; ++i)
			{
				var key = new DeepPointer(sf.Static + sf["floatStore"], 0x18, 0x28 + 0x18 * i, 0x14).DerefString(game, 128);
				var value = new DeepPointer(sf.Static + sf["floatStore"], 0x18, 0x30 + 0x18 * i).Deref<float>(game);

				if (key == "playtime") continue;

				float temp;
				if (vars.TempFloats.TryGetValue(key, out temp))
				{
					if (temp != value) vars.Log("Float item changed: " + key + " | " + temp + " -> " + value);
				}
				else
				{
					vars.Log("Float item added: " + key + " | " + value);
				}

				vars.TempFloats[key] = value;
			}

			for (int i = 0; i < vars.Unity["strings"].Current; ++i)
			{
				var key = new DeepPointer(sf.Static + sf["stringStore"], 0x18, 0x28 + 0x18 * i, 0x14).DerefString(game, 128);
				var value = new DeepPointer(sf.Static + sf["stringStore"], 0x18, 0x30 + 0x18 * i, 0x14).DerefString(game, 128);

				string temp;
				if (vars.TempStrings.TryGetValue(key, out temp))
				{
					if (temp != value) vars.Log("String item changed: " + key + " | " + temp + " -> " + value);
				}
				else
				{
					vars.Log("String item added: " + key + " | " + value);
				}

				vars.TempStrings[key] = value;
			}
		});
		#endregion

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.IGT = vars.Unity["inGameTime"].Current;
	current.TimerRunning = vars.Unity["timerRunning"].Current;
	current.Scene = vars.Unity.Scenes.Active.Index;
	current.GameComplete = vars.Unity["gameComplete"].Current;

	current.Scene = vars.Unity.Scenes.Active.Index;
	if (current.Scene <= 0)
		current.Scene = old.Scene;

	if (old.Scene != current.Scene)
		vars.Log("Scene changed: " + old.Scene + " -> " + current.Scene);
}

start
{
	return !old.TimerRunning && current.TimerRunning;
}

split
{
	vars.UpdateDicts();
	return !old.GameComplete && current.GameComplete;
}

reset
{
	// return old.Scene != 2 && current.Scene == 2;
}

gameTime
{
	if (current.TimerRunning)
		return TimeSpan.FromSeconds(current.IGT - vars.StartTime);
}

isLoading
{
	return true;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}