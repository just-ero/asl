state("Cuphead") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Cuphead] " + output));

	var bytes = File.ReadAllBytes(@"Components\LiveSplit.ASLHelper.bin");
	var type = Assembly.Load(bytes).GetType("ASLHelper.Unity");
	vars.Helper = Activator.CreateInstance(type, timer, this);

	vars.Splits = new Dictionary<string, string>();

	settings.Add("splits", true, "Splits:");

	var xml = System.Xml.Linq.XDocument.Load(@"Components\Cuphead.Splits.xml");
	foreach (var split in xml.Element("Splits").Elements("Split"))
	{
		string id = split.Attribute("ID").Value, name = split.Attribute("Name").Value;
		string tt = split.Attribute("ToolTip").Value, splitType = split.Attribute("Type").Value;

		settings.Add(id, false, name, "splits");
		settings.SetToolTip(id, tt);

		vars.Splits[id] = splitType;
	}

	vars.Helper.AlertLoadless("Cuphead");

	vars.CompletedSplits = new List<string>();
}

onStart
{
	timer.IsGameTimePaused = true;
	vars.CompletedSplits.Clear();
}

onSplit
{
	// Set final split's time to accurate in-game time when player is doing IL attempts.
	// This (like `reset`) assumes the runner only has 1 split.
	// DevilSquirrel's code. /shrug
	if (timer.CurrentPhase != TimerPhase.Ended || timer.Run.Count != 1)
		return;

	var time = timer.Run[0].SplitTime;
	timer.Run[0].SplitTime = new Time(time.RealTime, TimeSpan.FromSeconds(current.Time));
}

onReset
{}

init
{
	int PTR_SIZE = game.Is64Bit() ? 0x8 : 0x4;

	current.SaveSlot = IntPtr.Zero;

	vars.Helper.TryOnLoad = (Func<dynamic, bool>)(mono =>
	{
		#region PlayerData
		var pd = mono.GetClass("PlayerData");

		vars.Helper["inGame"] = pd.Make<bool>("inGame");
		vars.Helper["saveSlotIndex"] = pd.Make<int>("_CurrentSaveFileIndex");
		vars.Helper["saveFiles"] = pd.MakeArray<IntPtr>("_saveFiles");

		vars.GetCurrentSave = (Func<IntPtr>)(() =>
		{
			var slot = vars.Helper["saveSlotIndex"].Current;
			return vars.Helper["saveFiles"].Current[slot];
		});

		// Level Completion
		var pldm = mono.GetClass("PlayerLevelDataManager");
		var pldo = mono.GetClass("PlayerLevelDataObject");

		vars.GetAllLevelsData = (Func<List<dynamic>>)(() =>
		{
			var levels = vars.Helper.ReadList<IntPtr>(current.SaveSlot + pd["levelDataManager"], pldm["levelObjects"]);
			var ret = new List<dynamic>();

			foreach (var level in levels)
			{
				var id = vars.Helper.Read<int>(level + pldo["levelID"]);
				var completed = vars.Helper.Read<bool>(level + pldo["completed"]);
				var grade = vars.Helper.Read<int>(level + pldo["grade"]);
				var difficulty = vars.Helper.Read<int>(level + pldo["difficultyBeaten"]);

				ret.Add(new
				{
					ID = id,
					Completed = completed,
					Grade = grade,
					Difficulty = difficulty
				});
			}

			return ret;
		});

		vars.IsLevelCompleted = (Func<int, int, int, bool>)((levelId, targetDifficulty, targetGrade) =>
		{
			foreach (var level in vars.GetAllLevelsData())
			{
				if (level.ID == levelId)
				{
					return level.Completed && level.Grade >= targetGrade && level.Difficulty >= targetDifficulty;
				}
			}

			return false;
		});

		vars.IsInOverworld = (Func<bool>)(() => 
		{
			return current.Scene == "scene_map_world_1"
			       || current.Scene == "scene_map_world_2"
			       || current.Scene == "scene_map_world_3"
			       || current.Scene == "scene_map_world_4"
			       || current.Scene == "scene_map_world_DLC";
		});
		#endregion // PlayerData

		#region Level
		var lvl = mono.GetClass("Level");

		// vars.Helper["lvl2"] = lvl.Make<int>("Current", "CurrentLevel");
		// vars.Helper["lvl"] = lvl.Make<int>("PreviousLevel");
		vars.Helper["lvlTime"] = lvl.Make<float>("Current", "LevelTime");
		vars.Helper["lvlDifficulty"] = lvl.Make<int>("Current", "mode");
		vars.Helper["lvlEnding"] = lvl.Make<bool>("Current", "Ending");
		vars.Helper["lvlWon"] = lvl.Make<bool>("Won");
		#endregion // Level

		#region SceneLoader
		var sl = mono.GetClass("SceneLoader");

		vars.Helper["sceneName"] = sl.MakeString("SceneName");
		vars.Helper["lvl"] = sl.Make<int>("CurrentLevel");
		vars.Helper["doneLoading"] = sl.Make<bool>("_instance", "doneLoadingSceneAsync");
		#endregion // SceneLoader

		var x = mono.GetClass("PlayerStatsManager");

		return true;
	});

	vars.Helper.Load();
}

update
{
	if (!vars.Helper.Update())
		return false;

	current.SaveSlot = vars.GetCurrentSave();

	current.Loading = !vars.Helper["doneLoading"].Current;
	current.Scene = vars.Helper["sceneName"].Current;

	current.InGame = vars.Helper["inGame"].Current;
	current.InOverworld = vars.IsInOverworld();

	current.Level = vars.Helper["lvl"].Current;
	current.Time = vars.Helper["lvlTime"].Current;
	current.Difficulty = vars.Helper["lvlDifficulty"].Current;
	current.IsEnding = vars.Helper["lvlEnding"].Current;
	current.HasWon = vars.Helper["lvlWon"].Current;

	if (current.Scene == "scene_win")
	{
		current.Scene = old.Scene;
	}

	// auto-reset after results screen
	if (settings.ResetEnabled && settings["ilEnter"] && settings["ilEnd"] && timer.CurrentPhase == TimerPhase.Ended
	    && timer.Run.Count == 1 && (current.Time == 0f || current.InOverworld))
	{
		vars.Log("Resetting because of IL End | Time: " + current.Time + " | IsOverworld: " + current.InOverworld);
		vars.Helper.Timer.Reset();
	}

	// vars.Log("Level:      " +      current.Level);
	// vars.Log("InGame:     " +     current.InGame);
	// vars.Log("Time:       " +       current.Time);
	// vars.Log("Difficulty: " + current.Difficulty);
	// vars.Log("IsEnding:   " +   current.IsEnding);
	// vars.Log("HasWon:     " +     current.HasWon);
	// vars.Log("Loading:    " +    current.Loading);
	// vars.Log("Scene:      " +      current.Scene);
	// vars.Log("---------------------------------");
}

start
{
	// ilEnter should also start the timer
	if (settings["ilEnter"] && old.Time == 0f && current.Time > 0f)
	{
		vars.Log("Starting because of IL Enter | Time: " + old.Time + " -> " + current.Time);
		return true;
	}

	return current.Scene == "scene_cutscene_intro" && current.InGame && current.Loading;
}

split
{
	foreach (var split in vars.Splits)
	{
		string id = split.Key, type = split.Value;

		if (!settings[id] || vars.CompletedSplits.Contains(id))
			continue;

		switch (type)
		{
			case "SCENE_ENTER":
			{
				if (old.Scene != id && current.Scene == id)
				{
					vars.Log("SCENE_ENTER | " + id);

					vars.CompletedSplits.Add(id);
					return true;
				}

				continue;
			}

			case "SCENE_LEAVE":
			{
				if (old.Scene == id && current.Scene != id)
				{
					vars.Log("SCENE_LEAVE | " + id);

					vars.CompletedSplits.Add(id);
					return true;
				}

				continue;
			}

			case "LEVEL_COMPLETE":
			{
				if (current.Scene == id && vars.IsLevelCompleted(current.Level, -1, -1))
				{
					vars.Log("LEVEL_COMPLETE | " + id);

					vars.CompletedSplits.Add(id);
					return true;
				}

				continue;
			}

			case "ENDING":
			{
				var scene = id.Substring(0, id.Length - 2);
				var diff = int.Parse(id[id.Length - 1].ToString());
				if (!old.IsEnding && current.IsEnding && current.Scene == scene && current.Difficulty == diff)
				{
					vars.Log("ENDING | " + id);

					vars.CompletedSplits.Add(id);
					return true;
				}

				continue;
			}
		}

		// case "CUSTOM"
		switch (id)
		{
			case "ilEnter":
			{
				if (old.Time == 0f && current.Time > 0f)
				{
					vars.Log("Splitting due to IL Enter | Time: " + old.Time + " -> " + current.Time);
					return true;
				}

				continue;
			}

			case "ilEnd":
			{
				if (current.Time > 0f && current.HasWon)
				{
					vars.Log("Splitting due to IL End | Time: " + current.Time + " | HasWon: " + current.HasWon);
					return true;
				}

				continue;
			}
		}
	}
}

reset
{
	// Reset only when the runner is doing IL attempts.
	// Kind of a big assumption, don't you think? Runners can do full game runs with only 1 split, too.
	// DevilSquirrel's code. /shrug
	if (timer.Run.Count == 1 && current.Loading && current.Time == 0f)
	{
		vars.Log("Resetting due to reset {} | Time: " + current.Time + " | Loading: " + current.Loading);
		return true;
	}
}

gameTime
{
	if (settings["ilEnd"] && settings["ilEnter"] && timer.Run.Count == 1)
	{
		return TimeSpan.FromSeconds(current.Time);
	}
}

isLoading
{
	return current.Loading;
}

exit
{
	vars.Helper.Dispose();
}

shutdown
{
	vars.Helper.Dispose();
}
