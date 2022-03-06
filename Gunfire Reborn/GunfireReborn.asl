state("Gunfire Reborn") {}

startup
{
	vars.Log = (Action<object>)((output) => print("[Gunfire Reborn] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.TimerModel = new TimerModel { CurrentState = timer };

	vars.Stages = new List<Tuple<string, int, bool>>
	{
		Tuple.Create("Longling Tomb", 5, false),
		Tuple.Create("Anxi Tomb", 4, false),
		Tuple.Create("Duo Fjord", 4, true),
		Tuple.Create("Hyperborean", 3, true)
	};

	var count = vars.Stages.Count;
	for (int stage = 1; stage <= count; ++stage)
	{
		var name = vars.Stages[stage - 1].Item1;
		var levels = vars.Stages[stage - 1].Item2;

		settings.Add("layer" + stage, true, "Split after completing a stage in " + name + ":");

		for (int level = 0; level <= levels; ++level)
		{
			if (level == 0 && stage != 0)
				settings.Add(string.Format("{0}-0to{0}-1", stage), false, name + " Entrance", "layer" + stage);
			else if (level > 0 && level < levels)
				settings.Add(string.Format("{0}-{1}to{0}-{2}", stage, level, level + 1), true, "Stage " + level, "layer" + stage);
			else if (level == levels)
				settings.Add(string.Format("{0}-{1}to{2}-0", stage, level, stage + 1), true, name + " Boss", "layer" + stage);
		}
	}

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"Gunfire Reborn uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | Gunfire Reborn",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var wc = helper.GetClass("Assembly-CSharp", "WarCache");
		var wli = helper.GetClass("Assembly-CSharp", "WarLevelInfo");
		var gsm = helper.GetClass("Assembly-CSharp", "GameSceneManager");
		var gu = helper.GetClass("Assembly-CSharp", "GameUtility");
		var fw = helper.GetClass("Assembly-CSharp", "netwarreward_GS2CRewardFinishWarClass");

		vars.Unity.Make<int>(wc.Static, fw["Type"] - wc["ReportData"]).Name = "EndType";
		vars.Unity.Make<byte>(wc.Static, wc["LevelInfo"], wli["CurLevel"]).Name = "Level";
		vars.Unity.Make<byte>(wc.Static, wc["LevelInfo"], wli["CurLayer"]).Name = "Layer";
		vars.Unity.Make<bool>(gsm.Static, gsm["isInWar"]).Name = "InWar";
		vars.Unity.Make<int>(gu.Static, gu["ClientChallengeFrame"]).Name = "Time";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();
	current.EndType = vars.Unity["EndType"].Current;
	current.Level = vars.Unity["Level"].Current;
	current.Layer = vars.Unity["Layer"].Current;
	current.IsInWar = vars.Unity["InWar"].Current;
	current.HalfTime = vars.Unity["Time"].Current;

	if (old.EndType == 0 && current.EndType == 2)
		vars.TimerModel.Pause();
}

start
{
	return current.Layer == 1 && current.Level == 1 && old.HalfTime == 0 && current.HalfTime > 0;
}

split
{
	if (old.EndType == 0 && current.EndType == 3)
	{
		var layer = current.Layer;
		var stageInfo = vars.Stages[layer - 1];
		if (stageInfo.Item3)
			return settings[string.Format("{0}-{1}to{2}-0", layer, current.Level, layer + 1)];
	}

	if (old.Level != current.Level)
		return settings[string.Format("{0}-{1}to{2}-{3}", old.Layer, old.Level, current.Layer, current.Level)];
}

reset
{
	return old.EndType == 0 && current.EndType == 1 || old.Layer != 0 && current.Layer == 0;
}

gameTime
{
	if (current.EndType == 0)
		return TimeSpan.FromMilliseconds(current.HalfTime * 20);
}

isLoading
{
	return true;
}

exit
{
	timer.IsGameTimePaused = true;
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}