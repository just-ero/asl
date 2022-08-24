state("Warhammer3") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Warhammer 3] " + output));

	vars.Targets = new SigScanTarget[]
	{
		new SigScanTarget(6, "48 83 EC 28 80 3D ???????? 00 74 ?? E8"), // Loading
		new SigScanTarget(3, "44 38 25 ???????? 0F 84 ???????? FF 15"), // IsPlayersTurn
		new SigScanTarget(8, "40 53 48 83 EC 50 8B 05 ???????? 85 C0") // HasTradeOffer
	};

	foreach (var target in (SigScanTarget[])(vars.Targets))
		target.OnFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);


}

init
{
	vars.AddressesFound = false;

	vars.CancelSource = new CancellationTokenSource();
	System.Threading.Tasks.Task.Run(async () =>
	{
		vars.Log("Task start.");

		ProcessModuleWow64Safe mainModule;
		module_get: try { mainModule = game.MainModuleWow64Safe(); } catch { goto module_get; }

		var addresses = new IntPtr[vars.Targets.Length];
		var scanner = new SignatureScanner(game, mainModule.BaseAddress, mainModule.ModuleMemorySize);
		while (true)
		{
			for (int i = 0; i < vars.Targets.Length; ++i)
			{
				if (addresses[i] == IntPtr.Zero && (addresses[i] = scanner.Scan(vars.Targets[i])) != IntPtr.Zero)
					vars.Log("Found target " + i + " at 0x" + addresses[i].ToString("X") + ".");
			}

			if (addresses.All(a => a != IntPtr.Zero))
			{
				vars.Log("All addresses found.");
				break;
			}

			vars.Log("Not all targets resolved, retrying...");
			await System.Threading.Tasks.Task.Delay(3000, vars.CancelSource.Token);
		}

		vars.Watchers = new MemoryWatcherList
		{
			new MemoryWatcher<bool>(addresses[0] + 0x1) { Name = "Loading" },
			new MemoryWatcher<bool>(addresses[1]) { Name = "IsPlayersTurn" },
			new MemoryWatcher<bool>(addresses[2]) { Name = "HasTradeOffer" }
		};

		vars.AddressesFound = true;
		vars.Log("Task finished.");
	});
}

update
{
	if (!vars.AddressesFound) return false;

	vars.Watchers.UpdateAll(game);
}

isLoading
{
	return vars.Watchers["Loading"].Current ||
	       !vars.Watchers["IsPlayersTurn"].Current && !vars.Watchers["HasTradeOffer"].Current;
}

exit
{
	vars.CancelSource.Cancel();
}

shutdown
{
	vars.CancelSource.Cancel();
}