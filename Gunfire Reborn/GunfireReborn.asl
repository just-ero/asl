state("Gunfire Reborn") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Gunfire Reborn";

    settings.Add("area-1", true, "Split after completing a stage in Longling Tomb:");
        settings.Add("1-1->1-2", true, "Stage 1", "area-1");
        settings.Add("1-2->1-3", true, "Stage 2", "area-1");
        settings.Add("1-3->1-4", true, "Stage 3", "area-1");
        settings.Add("1-4->1-5", true, "Stage 4", "area-1");
        settings.Add("1-5->2-0", true, "Boss", "area-1");
    settings.Add("area-2", true, "Split after completing a stage in Anxi Tomb:");
        settings.Add("2-0->2-1", false, "Entrance", "area-2");
        settings.Add("2-1->2-2", true, "Stage 1", "area-2");
        settings.Add("2-2->2-3", true, "Stage 2", "area-2");
        settings.Add("2-3->2-4", true, "Stage 3", "area-2");
        settings.Add("2-4->3-0", true, "Boss", "area-2");
    settings.Add("area-3", true, "Split after completing a stage in Duo Fjord:");
        settings.Add("3-0->3-1", false, "Entrance", "area-3");
        settings.Add("3-1->3-2", true, "Stage 1", "area-3");
        settings.Add("3-2->3-3", true, "Stage 2", "area-3");
        settings.Add("3-3->3-4", true, "Stage 3", "area-3");
        settings.Add("3-4->4-0", true, "Boss", "area-3");
    settings.Add("area-4", true, "Split after completing a stage in Hyperborean:");
        settings.Add("4-0->4-1", false, "Entrance", "area-4");
        settings.Add("4-1->4-2", true, "Stage 1", "area-4");
        settings.Add("4-2->4-3", true, "Stage 2", "area-4");
        settings.Add("4-3->5-0", true, "Boss", "area-4");

    vars.Helper.AlertGameTime();
}

init
{
    vars.Helper.ModuleLoadTimeout = 5000;

    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var wc = mono["WarCache"];
        var wli = mono["WarLevelInfo"];

        vars.Helper["EndType"] = wc.Make<int>("ReportData");
        vars.Helper["Level"] = wc.Make<byte>("LevelInfo", wli["CurLevel"]);
        vars.Helper["Layer"] = wc.Make<byte>("LevelInfo", wli["CurLayer"]);

        var gsm = mono["GameSceneManager"];
        var gu = mono["GameUtility"];

        vars.Helper["IsInWar"] = gsm.Make<bool>("isInWar");
        vars.Helper["Frame"] = gu.Make<int>("ClientChallengeFrame");

        return true;
    });
}

update
{
    if (old.EndType == 0 && current.EndType == 2)
        vars.Helper.Timer.Pause();
}

start
{
    return current.Layer == 1 && current.Level == 1 && old.Frame == 0 && current.Frame > 0;
}

split
{
    if (old.EndType == 0 && current.EndType == 3)
    {
        byte layer = current.Layer, level = current.Level;
        string setting = string.Format("{0}-{1}->{2}-{3}", layer, level, layer, level + 1);

        return settings[setting];
    }

    if (old.Level != current.Level)
    {
        string setting = string.Format("{0}-{1}->{2}-{3}", old.Layer, old.Level, current.Layer, current.Level);

        return settings[setting];
    }
}

reset
{
    return old.EndType == 0 && current.EndType == 1
        || old.Layer != 0 && current.Layer == 0;
}

gameTime
{
    if (current.EndType == 0)
        return TimeSpan.FromMilliseconds(current.Frame * 20);
}

isLoading
{
    return true;
}

exit
{
    timer.IsGameTimePaused = true;
}
