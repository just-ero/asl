state("pico_park_2") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    settings.Add("worlds", true, "Split when finishing a stage:");

    string[] worldNames =
    {
        "Hello, Pico Park 2",
        "Distance",
        "Formation",
        "Danger Park",
        "Time Limit",
        "Shoot 'em Up",
        "Stop and Go",
        "Mini Games",
        "Top Down View",
        "Skills or Devices",
        "Parkful Dodger",
        "Go! Go! Go!",
        "Special Park",
        "Handy Gadgets",
        "Last Park"
    };

    for (int i = 0, world = 1; i < worldNames.Length; i++, world++)
    {
        settings.Add("w" + world, true, world + ". " + worldNames[i], "worlds");

        for (int stage = 1; stage <= 4; stage++)
            settings.Add(world + "-" + stage, true, world + "-" + stage, "w" + world);
    }

    settings.Add("misc", false, "Miscellaneous:");
        settings.Add("reset2", false, "Reset when retrying level", "misc");
        settings.Add("reset3", false, "Reset when returning to stage select", "misc");
        settings.Add("reset6", false, "Reset when returning to lobby", "misc");
        settings.Add("reset4", false, "Reset when returning to main menu", "misc");
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var ssm = mono["Game.StageSceneManager", 3];

        vars.Helper["Phase"] = ssm.Make<int>("instance", "m_Phase");
        vars.Helper["GameMode"] = ssm.Make<int>("instance", "m_GameMode");
        vars.Helper["World"] = ssm.Make<int>("instance", "m_StageParentNo");
        vars.Helper["Stage"] = ssm.Make<int>("instance", "m_StageChildNo");
        vars.Helper["Result"] = ssm.Make<byte>("instance", "m_StageResult");

        return true;
    });
}

update
{
    return current.GameMode == 0  // World
        || current.GameMode == 3; // Black
}

start
{
    return old.Phase != 3 && current.Phase == 3; // Func
}

split
{
    return old.Result == 0     // None
        && current.Result == 1 // Clear
        && settings[current.World + "-" + current.Stage];
}

reset
{
    return old.Result == 0 && current.Result != 0 // None
        && settings["reset" + current.Result];
}

isLoading
{
    return current.Phase == 0  // Prepare
        || current.Phase == 1  // Prepare2
        || current.Phase == 2  // Prepare3
        || current.Phase == 5  // StageDisposeWait
        || current.Phase == 6  // QuantumFinalize
        || current.Phase == 7  // QuantumFinalizeWait
        || current.Phase == 8; // ChangeScene
}

/*
 * enum GameMode {
 *   World,
 *   Battle,
 *   Endless,
 *   Black,
 *   Custom
 * }
 *
 * enum Phase {
 *   Prepare,
 *   Prepare2,
 *   Prepare3,
 *   Func,
 *   Finish,
 *   StageDisposeWait,
 *   QuantumFinalize,
 *   QuantumFinalizeWait,
 *   ChangeScene,
 *   End
 * }
 *
 * enum QStageResult {
 *   None,
 *   Clear,
 *   Retry,
 *   ToStageSelect,
 *   ToMainMenu,
 *   ToTitle,
 *   ToLobby
 * }
 */
