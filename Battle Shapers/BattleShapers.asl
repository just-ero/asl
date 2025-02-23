state("BattleShapers") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Battle Shapers";
    vars.Helper.AlertGameTime();

    settings.Add("floor-split", false, "Split when completing a floor");
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var rt = mono["ProtoRogue", "RunTimer", 2];
        vars.Helper["RunTime"] = mono.Make<float>(rt, "_instance", "RunTime");

        var pm = mono["ProtoRogue", "PersistenceManager", 2];
        vars.Helper["RunEndedReason"] = mono.Make<int>(pm, "_instance", "_saveData", "lastRunEndedReason");
        vars.Helper["InRun"] = mono.Make<bool>(pm, "_instance", "_saveData", "hasStartedRun");

        var lm = mono["ProtoRogue", "LvlManager", 2];
        vars.Helper["Floor"] = mono.Make<int>(lm, "_instance", "towerCurrentLevelIndex");

        return true;
    });
}

start
{
    return !old.InRun && current.InRun;
}

split
{
    return old.RunEndedReason != 1 && current.RunEndedReason == 1
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
