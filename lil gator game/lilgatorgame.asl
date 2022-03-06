state("Lil Gator Game") {}

startup
{
	vars.Log = (Action<object>) ((output) => print("[lil gator game ASL] " + output));

	settings.Add("QP_Act1_Jill", true, "Finish Jill's Quest");
	settings.Add("QP_Act1_Martin", true, "Finish Martin's Quest");
	settings.Add("QP_Act1_Avery", true, "Finish Avery's Quest");

	vars.TimerStart = (EventHandler) ((s, e) =>
	{
		foreach (var quest in current.Quests)
			quest.Value = false;
	});

	timer.OnStart += vars.TimerStart;
}

init
{
	vars.CancelSource = new CancellationTokenSource();
	vars.MonoThread = new Thread(() =>
	{
		vars.Log("Starting mono thread.");

		int class_count = 0;
		IntPtr class_cache = IntPtr.Zero, scMgr = IntPtr.Zero;
		ProcessModuleWow64Safe uPlayer = null;
		var scMgrTrg = new SigScanTarget(3, "48 8B 1D ???????? 0F 57 C0") { OnFound = (p, s, ptr) => ptr + 0x4 + p.ReadValue<int>(ptr) };

		var token = vars.CancelSource.Token;
		while (!token.IsCancellationRequested)
		{
			var mods = game.ModulesWow64Safe();
			uPlayer = mods.FirstOrDefault(m => m.ModuleName == "UnityPlayer.dll");
			if (uPlayer != null && mods.FirstOrDefault(m => m.ModuleName == "mono-2.0-bdwgc.dll") != null)
				break;

			vars.Log("Modules not found.");
			Thread.Sleep(2000);
		}

		while (!token.IsCancellationRequested)
		{
			var scanner = new SignatureScanner(game, uPlayer.BaseAddress, uPlayer.ModuleMemorySize);

			if ((scMgr = scanner.Scan(scMgrTrg)) != IntPtr.Zero)
			{
				vars.Log("Found 'SceneManager' at 0x" + scMgr.ToString("X"));
				break;
			}

			vars.Log("SceneManager not found.");
			Thread.Sleep(2000);
		}

		while (!token.IsCancellationRequested)
		{
			int size = new DeepPointer("mono-2.0-bdwgc.dll", 0x49A0C8, 0x18).Deref<int>(game);
			var table = new DeepPointer("mono-2.0-bdwgc.dll", 0x49A0C8, 0x10, 0x8 * (int)(0xFA381AED % size)).Deref<IntPtr>(game);

			for (; table != IntPtr.Zero; table = game.ReadPointer(table + 0x10))
			{
				if (new DeepPointer(table, 0x0).DerefString(game, 32) != "Assembly-CSharp") continue;

				class_count = new DeepPointer(table + 0x8, 0x4D8).Deref<int>(game);
				class_cache = new DeepPointer(table + 0x8, 0x4E0).Deref<IntPtr>(game);
			}

			if (class_cache != IntPtr.Zero)
				break;

			vars.Log("Assembly-CSharp not found.");
			Thread.Sleep(2000);
		}

		var mono = new Dictionary<string, IntPtr>
		{
			{ "QuestProfile", IntPtr.Zero },
			{ "DialogueManager", IntPtr.Zero }
		};

		while (!token.IsCancellationRequested)
		{
			bool allFound = false;

			for (int i = 0; i < class_count; ++i)
			{
				var klass = game.ReadPointer(class_cache + 0x8 * i);
				for (; klass != IntPtr.Zero; klass = game.ReadPointer(klass + 0x108))
				{
					string class_name = new DeepPointer(klass + 0x48, 0x0).DerefString(game, 32);
					if (!mono.ContainsKey(class_name)) continue;

					mono[class_name] = new DeepPointer(klass + 0xD0, 0x8, 0x60).Deref<IntPtr>(game);
					vars.Log("Found '" + class_name + "' at 0x" + mono[class_name].ToString("X") + ".");

					if (allFound = mono.Values.All(ptr => ptr != IntPtr.Zero))
						break;
				}

				if (allFound)
					break;
			}

			if (allFound)
			{
				vars.Mono = mono;
				vars.Watchers = new MemoryWatcherList
				{
					new MemoryWatcher<int>(new DeepPointer(scMgr, 0x50, 0x0, 0x98)) { Name = "SceneIndex" },
					new MemoryWatcher<int>(new DeepPointer(mono["QuestProfile"], 0x18)) { Name = "QuestCount" },
					new StringWatcher(new DeepPointer(mono["DialogueManager"], 0x18, 0x30, 0x14), 512) { Name = "Dialogue" },
					new MemoryWatcher<bool>(new DeepPointer(mono["DialogueManager"], 0xBC)) { Name = "InDialogue" }
				};

				break;
			}

			vars.Log("Not all classes found.");
			Thread.Sleep(5000);
		}

		vars.Log("Exiting mono thread.");
	});

	vars.MonoThread.Start();
	current.Quests = new Dictionary<string, bool>
	{
		{ "QP_Act1_Jill", false },
		{ "QP_Act1_Martin", false },
		{ "QP_Act1_Avery", false },
		{ "QP_Act1_Friends", false }
	};
}

update
{
	if (vars.MonoThread.IsAlive) return false;

	vars.Watchers.UpdateAll(game);

	current.SceneIndex = vars.Watchers["SceneIndex"].Current;
	current.Dialogue = vars.Watchers["Dialogue"].Current;
	current.InDialogue = vars.Watchers["InDialogue"].Current;
}

start
{
	return old.SceneIndex == 1 && current.SceneIndex == -1;
}

split
{
	var questSplit = false;
	var count = vars.Watchers["QuestCount"].Current;
	for (int i = 4; i > 0; --i)
	{
		var ptr = new DeepPointer((IntPtr)vars.Mono["QuestProfile"], 0x10, 0x20 + 0x8 * (count - i)).Deref<IntPtr>(game);
		string id = new DeepPointer(ptr + 0x18, 0x14).DerefString(game, 32);
		bool state = game.ReadValue<bool>(ptr + 0x41);

		if (!old.Quests[id] && state)
			questSplit = true;

		current.Quests[id] = state;
	}

	return questSplit || old.InDialogue && !current.InDialogue && current.Dialogue == "but i can't :) because this is a demo" + Environment.NewLine + ":)";
}

reset
{
	return old.SceneIndex == -1 && current.SceneIndex == 0;
}

exit
{
	vars.CancelSource.Cancel();
}

shutdown
{
	timer.OnStart -= vars.TimerStart;
	vars.CancelSource.Cancel();
}