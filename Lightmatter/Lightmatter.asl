state("LightmatterSub") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Lightmatter] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");

	settings.Add("ilTime", false, "Individual Level timer behavior (hover for info)");
	settings.SetToolTip("ilTime", "Restarts the timer when pressing \'RETRY\'\nSyncs to in-game time (set LiveSplit comparison to \'Game Time\')");

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"Lightmatter uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | Lightmatter",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		// Player_Manager
		var pm = helper.GetClass("Assembly-CSharp", "Player_Manager");
		var pc = helper.GetClass("Assembly-CSharp", "Player_Common");
		var lrm = helper.GetClass("Assembly-CSharp", "Loading_RootManager");

		vars.Unity.Make<float>(pm.Static, pm["Instance"], pm["Common"], pc["LevelSpecificMovementMultiplier"]).Name = "moveSpeed";
		vars.Unity.Make<int>(pm.Static, pm["Instance"], pm["LoadingRootManager"], lrm["CurrentLevelIndex"]).Name = "level";


		// EventLogManager
		var elm = helper.GetClass("Assembly-CSharp", "EventLogManager");

		vars.Unity.Make<int>(elm.Static, elm["TimeInlevel"]).Name = "levelTime";
		vars.Unity.Make<int>(elm.Static, elm["TotalTimeInGame"]).Name = "gameTime";
		vars.Unity.Make<int>(elm.Static, elm["TotalButtonPushCount"]).Name = "pushCount";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.MoveSpeed = vars.Unity["moveSpeed"].Current;
	current.Level = vars.Unity["level"].Current;
	current.LevelTime = vars.Unity["levelTime"].Current;
	current.GameTime = vars.Unity["gameTime"].Current;
	current.PushCount = vars.Unity["pushCount"].Current;
}

start
{
	if (settings["ilTime"])
	{
		return old.LevelTime > current.LevelTime && old.Level == current.Level;
	}
	else
	{
		return old.GameTime == 0f && current.GameTime > 0f && current.Level == 0;
	}
}

split
{
	bool transitionedLevel = current.Level == old.Level + 1 && current.Level <= 37;

	if (settings["ilTime"])
	{
		return old.LevelTime > current.LevelTime && transitionedLevel;
	}
	else
	{
		bool pressedInFinalRoom = current.PushCount == old.PushCount + 1 && current.MoveSpeed == 0.3f && current.Level == 37;

		return transitionedLevel || pressedInFinalRoom;
	}
}

reset
{
	bool returnToLvl1 = old.Level != 0 && current.Level == 0;
	bool returnToMenu = current.Level == 0 && old.GameTime > 0f && current.GameTime == 0f;
	bool timeResetSameLevel = old.LevelTime > current.LevelTime && old.Level == current.Level;

	return returnToLvl1 || returnToMenu || timeResetSameLevel && settings["ilTime"];
}

gameTime
{
	if (settings["ilTime"])
	{
		if (current.LevelTime >= 0.01f)
			return TimeSpan.FromSeconds(current.LevelTime);
	}
	else
	{
		if (current.GameTime >= 0.01f)
			return TimeSpan.FromSeconds(current.GameTime);
	}
}

isLoading
{
	return true;
}

exit
{
	vars.CancelSource.Cancel();
}

shutdown
{
	vars.CancelSource.Cancel();
}