state("Warhammer3")
{
	bool Loading : 0x4264BB4;
}

startup
{
	vars.Log = (Action<object>)(output => print("[Warhammer 3] " + output));

	vars.Targets = new SigScanTarget[]
	{
		new SigScanTarget(6, "48 83 EC 28 80 3D ???????? 00 74 ?? E8") // Loading
	};

	foreach (var target in (SigScanTarget[])(vars.Targets))
		target.OnFound = (p, _, addr) => addr + 0x5 + p.ReadValue<int>(addr);
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

		vars.Loading = new MemoryWatcher<bool>(addresses[0]);

		vars.AddressesFound = true;
		vars.Log("Task finished.");
	});
}

update
{
	if (!vars.AddressesFound) return false;

	vars.Loading.Update(game);
}

isLoading
{
	return vars.Loading.Current;
}

exit
{
	vars.CancelSource.Cancel();
}

shutdown
{
	vars.CancelSource.Cancel();
}