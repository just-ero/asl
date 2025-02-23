state("BattleShapers") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Battle Shapers";
    vars.Helper.AlertGameTime();

    settings.Add("boss-split", false, "Split after defeating a boss");
    settings.Add("floor-split", false, "Split after completing a floor");
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var rt = mono["ProtoRogue", "RunTimer", 2];
        vars.Helper["RunTime"] = mono.Make<float>(rt, "_instance", "RunTime");

        var pm = mono["ProtoRogue", "PersistenceManager", 2];
        vars.Helper["InRun"] = mono.Make<bool>(pm, "_instance", "_saveData", "hasStartedRun");

        var lm = mono["ProtoRogue", "LvlManager", 2];
        vars.Helper["Floor"] = mono.Make<int>(lm, "_instance", "towerCurrentLevelIndex");

        var sm = mono["ProtoRogue", "StageManager", 1];
        vars.Helper["DefeatedFinalBoss"] = mono.Make<bool>(sm, "_instance", "HasCompletedB90");

        var pb = mono["ProtoRogue", "PlayerBrain", 2];
        vars.Helper["DefeatedCurrentBoss"] = mono.Make<bool>(pm, "_instance", "_currentBossRoom", "IsBossDefeated");

        return true;
    });
}

start
{
    return !old.InRun && current.InRun;
}

split
{
    return !old.DefeatedFinalBoss && current.DefeatedFinalBoss
        || settings["boss-split"] && !old.DefeatedCurrentBoss && current.DefeatedCurrentBoss
        || settings["floor-split"] && old.Floor < current.Floor;
}

reset
{
    return old.InRun && !current.InRun;
}

gameTime
{
    return TimeSpan.FromSeconds(current.RunTime);
}

isLoading
{
    return true;
}
