state("Patrick") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.StartFileLogger("logs/SpongeBobSquarePants_ThePatrickStarGame.log");

    // Game sets the applicationState to 3 (Game) ~0.91 seconds before removing the loading UI.
    vars.TargetOffset = TimeSpan.FromSeconds(-0.91);
    vars.PreviousOffset = TimeSpan.Zero;

    vars.PendingSplits = 0;
}

onStart
{
    timer.Run.Offset = vars.PreviousOffset;
    vars.PendingSplits = 0;
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        mono.Images.Clear();

        vars.Helper["GameState"] = mono.Make<int>("ApplicationManager", "instance", "applicationState");
        vars.Helper["CameraPosition"] = mono.Make<Vector3f>("CameraManager", "cameraPosition3D");

        var sm = mono["SavingManager"];
        var sf = mono["SaveFile_Game"];
        var miss = mono["SaveableMission"];
        var task = mono["SaveableMissionTask"];

        // SavingManager needs to be initialized.
        if (sm.Static == IntPtr.Zero)
            return false;

        // Complicated logic to get completed feats from a `List<string>`.
        vars.GetCompletedFeats = (Func<List<string>>)(() =>
        {
            var feats = new List<string>();
            foreach (var feat in vars.Helper.ReadList<IntPtr>(sm.Static + sm["instance"], sm["gameFile"], sf["feats"]))
            {
                var length = vars.Helper.Read<int>(feat + 0x10); // String._stringLength
                feats.Add(vars.Helper.ReadString(length * sizeof(char), ReadStringType.UTF16, feat + 0x14)); // String._firstChar
            }

            return feats;
        });

        // Complicated logic to get completed tasks from a `List<SaveableMission>`.
        // Each `SaveableMission` contains a `SaveableMissionTask[]`.
        // We only care about the `SaveableMissionTask` IDs that are completed.
        vars.GetCompletedTasks = (Func<List<string>>)(() =>
        {
            var tasks = new List<string>();

            // `SaveableMission` is a struct, so we need to iterate the list manually.
            var mLength = vars.Helper.Read<int>(sm.Static + sm["instance"], sm["gameFile"], sf["missions"], 0x18); // List<T>._size
            for (int i = 0; i < mLength; i++)
            {
                var m = vars.Helper.Deref(sm.Static + sm["instance"], sm["gameFile"], sf["missions"], 0x10, 0x20 + (i * 0x10)); // List<T>._items[i]

                // `SaveableMissionTask` is a struct, so we need to iterate the array manually.
                var tLength = vars.Helper.Read<int>(m + miss["tasks"], 0x18); // Array.Length
                for (int j = 0; j < tLength; j++)
                {
                    var t = vars.Helper.Deref(m + miss["tasks"], 0x20 + (j * 0x10)); // Array[j]

                    if (!vars.Helper.Read<bool>(t + task["completed"]))
                        continue;

                    var tNameLength = vars.Helper.Read<int>(t + task["id"], 0x10); // String._stringLength
                    var tName = vars.Helper.ReadString(tNameLength * sizeof(char), ReadStringType.UTF16, t + task["id"], 0x14); // String._firstChar

                    tasks.Add(tName);
                }
            }

            return tasks;
        });

        return true;
    });

    current.Feats = new List<string>();
    current.Tasks = new List<string>();
}

start
{
    if (old.GameState == 2 && current.GameState == 3)
    {
        vars.PreviousOffset = timer.Run.Offset;
        timer.Run.Offset = vars.TargetOffset;

        return true;
    }
}

split
{
    current.Feats = vars.GetCompletedFeats();
    current.Tasks = vars.GetCompletedTasks();

    for (int i = old.Feats.Count; i < current.Feats.Count; i++)
    {
        vars.Log("Completed feat: " + current.Feats[i]);

        if (settings[current.Feats[i]])
            vars.PendingSplits++;
    }

    for (int i = old.Tasks.Count; i < current.Tasks.Count; i++)
    {
        vars.Log("Completed task: " + current.Tasks[i]);

        if (settings[current.Tasks[i]])
            vars.PendingSplits++;
    }

    if (vars.PendingSplits > 0)
    {
        vars.PendingSplits--;
        return true;
    }

    // Check if camera is on final cutscene position.
    // Observation for future maintainers: if this results in false positive (very rare if not impossible since the position is oob and semi-precise)
    // Fix for this would be to check for current mission Step inside EventManager, the final cutscene event state is 4.
    return current.CameraPosition.X > -75f && current.CameraPosition.X < -73f
        && current.CameraPosition.Y >  76f && current.CameraPosition.Y <  78f
        && current.CameraPosition.Z > -65f && current.CameraPosition.Z < -63f;
}

/*
 * enum ApplicationState {
 *   Boot,
 *   OnLogo,
 *   OnMainMenu,
 *   InGame
 * }
 */
