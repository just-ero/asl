state("EtG") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Enter the Gungeon";

    settings.Add("lvl-exit", true, "Split on level exit");
    settings.Add("boss-enter", false, "Split on boss intro");
    settings.Add("boss-exit", false, "Split on boss defeat");
    settings.Add("run-end", true, "Split on run completion");

    vars.Helper.AlertGameTime();

    vars.GetValueOrDefault = (Func<Dictionary<int, float>, int, float>)((dict, key) =>
    {
        float value;
        return dict.TryGetValue(key, out value) ? value : 0f;
    });
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["Level"] = mono.Make<int>("GameManager", "mr_manager", "nextLevelIndex");
        vars.Helper["Paused"] = mono.Make<bool>("GameManager", "mr_manager", "m_paused");
        vars.Helper["Credits"] = mono.Make<bool>("TimeTubeCreditsController", "IsTimeTubing");

        vars.Helper["BossIntroRunning"] = mono.Make<bool>("GameManager", "IsBossIntro");
        vars.Helper["BossOutroRunning"] = mono.Make<bool>("BossKillCam", "BossDeathCamRunning");

        var sessionStats = mono.Make<IntPtr>("GameStatsManager", "m_instance", "m_sessionStats", "stats");
        var savedSessionStats = mono.Make<IntPtr>("GameStatsManager", "m_instance", "m_savedSessionStats", "stats");

        vars.GetSessionStats = (Func<Dictionary<int, float>>)(() =>
        {
            sessionStats.Update(game);
            savedSessionStats.Update(game);

            var stats = new Dictionary<int, float>();

            var count = vars.Helper.Read<int>(sessionStats.Current + 0x38);
            var keys = vars.Helper.ReadArray<int>(sessionStats.Current + 0x20);
            var values = vars.Helper.ReadArray<float>(sessionStats.Current + 0x28);

            for (var i = 0; i < count; i++)
            {
                var key = keys[i];
                stats[key] = values[i];
            }

            var sCount = vars.Helper.Read<int>(savedSessionStats.Current + 0x38);
            var sKeys = vars.Helper.ReadArray<int>(savedSessionStats.Current + 0x20);
            var sValues = vars.Helper.ReadArray<float>(savedSessionStats.Current + 0x28);

            for (var i = 0; i < sCount; i++)
            {
                var key = sKeys[i];

                float value;
                stats[key] = stats.TryGetValue(key, out value)
                    ? value + sValues[i]
                    : sValues[i];
            }

            return stats;
        });

        return true;
    });
}

update
{
    if (current.Paused)
        return false;

    var stats = vars.GetSessionStats();
    current.Igt = vars.GetValueOrDefault(stats, 23); // TrackedStats.TIME_PLAYED
}

start
{
    return old.Igt < 0.01f && current.Igt >= 0.01f;
}

split
{
    return settings["lvl-exit"] && old.Level < current.Level && current.Level > 2
        || settings["boss-enter"] && !old.BossIntroRunning && current.BossIntroRunning
        || settings["boss-exit"] && old.BossOutroRunning && !current.BossOutroRunning
        || settings["run-end"] && old.Credits && !current.Credits;
}

reset
{
    return old.Igt > 0.01f && current.Igt <= 0.01f;
}

gameTime
{
    return TimeSpan.FromSeconds(current.Igt);
}

isLoading
{
    return true;
}

exit
{
    vars.Helper.Timer.Reset();
}
