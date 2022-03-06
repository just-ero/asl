// Bad.

state("TheFinalStation")
{
	int QueuedScenes  : 0x10479D8, 0xC;
	int ActiveSceneID : 0x10479D8, 0x14, 0x0, 0x74;
}

startup
{
	vars.Dbg = (Action<dynamic>) ((output) => print("[The Final Station ASL] " + output));

	settings.Add("52", false, "Intro");

	for (int i = 1, j = 1; i <= 51; ++i)
	{
		string id = i + (i > 46 ? "Pos" : string.Empty);
		bool state = i % 2 == 1 || i > 46;
		settings.Add(id, state, state ? "Level " + j : "Train Ride " + j);

		if (!state || i > 46) ++j;
	}

	vars.Positions = new Dictionary<int, float>
	{
		{ 47, 421.9f },
		{ 48, 411.1f },
		{ 49, 235.1f },
		{ 50, 537.2f },
		{ 51, 308.1f }
	};

	vars.TimerStart = (EventHandler) ((s, e) => timer.Run.Offset = TimeSpan.Zero);
	timer.OnStart += vars.TimerStart;

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var result = MessageBox.Show(
			"Removing loads from The Final Station requires comparing against Game Time.\nWould you like to switch to it?",
			"The Final Station Autosplitter",
			MessageBoxButtons.YesNo);

		if (result == DialogResult.Yes) timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

init
{
	vars.TokenSource = new CancellationTokenSource();
	vars.MonoThread = new Thread(() =>
	{
		var gameManager = IntPtr.Zero;
		while (!vars.TokenSource.Token.IsCancellationRequested)
		{
			var mods = game.ModulesWow64Safe();
			if (mods.FirstOrDefault(m => m.ModuleName == "mono.dll") == null)
			{
				Thread.Sleep(2000);
				continue;
			}

			gameManager = (IntPtr)new DeepPointer("mono.dll", 0x1F63A4, 0x8, 0x4, 0x8, 0x8, 0x8, 0x4, 0x2B4, 0x194, 0xA4, 0x4, 0xC).Deref<int>(game);
			if (gameManager != IntPtr.Zero) break;

			Thread.Sleep(5000);
		}

		vars.PlayerX = new MemoryWatcher<float>(new DeepPointer(gameManager + 0x4, 0x10, 0x8, 0x5C, 0x2C));
		vars.State = new MemoryWatcher<int>(new DeepPointer(gameManager, 0x18));
	});

	vars.MonoThread.Start();
}

update
{
	if (vars.MonoThread.IsAlive) return;
	vars.PlayerX.Update(game);
	vars.State.Update(game);

	vars.Dbg(vars.State.Current);
}

start
{
	if (old.ActiveSceneID == 0 && current.ActiveSceneID == 52)
	{
		timer.Run.Offset = TimeSpan.FromSeconds(4.534);
		return true;
	}
}

split
{
	if (vars.Positions.ContainsKey(current.ActiveSceneID))
	{
		float x = vars.Positions[current.ActiveSceneID];
		return vars.PlayerX.Old < x && vars.PlayerX.Current >= x;
	}
	else
	{
		return old.ActiveSceneID != current.ActiveSceneID &&
		       settings[old.ActiveSceneID + "-" + current.ActiveSceneID];
	}
}

reset
{
	return old.ActiveSceneID != 0 && current.ActiveSceneID == 0;
}

isLoading
{
	return current.QueuedScenes > 1 || vars.State.Current == 1;
}

exit
{
	vars.TokenSource.Cancel();
}

shutdown
{
	timer.OnStart -= vars.TimerStart;
	vars.TokenSource.Cancel();
}