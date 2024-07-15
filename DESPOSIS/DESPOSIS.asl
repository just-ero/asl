state("DESPOSIS-Win64-Shipping") {}

startup
{
    const int LevelCount = 6;

    for (int i = 1; i <= LevelCount; i++)
    {
        settings.Add("lv-" + i, true, "Split after completing level " + i);
    }
}

init
{
    var scn = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);
    var trg = new SigScanTarget(7, "A8 01 75 ?? 48 C7 05") { OnFound = (p, _, addr) => addr + 0x8 + p.ReadValue<int>(addr) };

    var gEngine = scn.Scan(trg);
    if (gEngine == IntPtr.Zero)
    {
        throw new Exception("Failed to find GEngine.");
    }

    print("GEngine: " + gEngine.ToString("X"));

    // GEngine.GameInstance.CurrentLevel
    vars.CurrentLevelPtr = new DeepPointer(gEngine, 0x1058, 0x1DC);

    // GEngine.GameInstance.IsLoading
    vars.IsLoadingPtr = new DeepPointer(gEngine, 0x1058, 0x1E0);

    // GEngine.GameInstance.GameCompleted
    vars.GameCompletedPtr = new DeepPointer(gEngine, 0x1058, 0x1E1);
}

update
{
    current.Level = vars.CurrentLevelPtr.Deref<int>(game);
    current.IsLoading = vars.IsLoadingPtr.Deref<bool>(game);
    current.GameCompleted = vars.GameCompletedPtr.Deref<bool>(game);
}

start
{
    return old.Level == 0 && current.Level == 1;
}

split
{
    return old.Level < current.Level && settings["lv-" + old.Level]
        || !old.GameCompleted && current.GameCompleted;
}

reset
{
    return old.Level != 0 && current.Level == 0;
}

isLoading
{
    return current.IsLoading;
}
