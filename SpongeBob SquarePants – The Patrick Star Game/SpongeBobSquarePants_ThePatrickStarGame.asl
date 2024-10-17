state("Patrick") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.Settings.CreateFromXml("Components/SpongeBobSquarePants_ThePatrickStarGame.Settings.xml");
    vars.Helper.StartFileLogger("SpongeBobSquarePants_ThePatrickStarGame.log", 16384);

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

        var dbo = mono["DatabaseObject"];
        var tso = mono["Texto_SO"];
        var tl = mono["TextoLine"];

        var fm = mono["FeatsManager"];
        if (fm.Static == IntPtr.Zero)
            return false;

        var fso = mono["Feat_SO"];

        vars.GetCompletedFeats = (Func<List<string>>)(() =>
        {
            var feats = new List<string>();

            var count = vars.Helper.Read<int>(fm.Static + fm["instance"], fm["completedFeats"], 0x40);
            for (int i = 0; i < count; i++)
            {
                var feat = vars.Helper.Deref(fm.Static + fm["instance"], fm["completedFeats"], 0x18, 0x20 + (0x18 * i) + 0x8);

                if (vars.Helper.Read<bool>(feat + 0x8))
                {
                    var id = vars.Helper.ReadString(feat + 0x0, dbo["id"]);
                    var desc = vars.Helper.ReadString(feat + 0x0, fso["description"], tso["lines"], 0x10, 0x20, tl["text"]);

                    feats.Add(id + " (\"" + desc + "\")");
                }
            }

            return feats;
        });

        var mm = mono["PHL_MissionManager"];
        if (mm.Static == IntPtr.Zero)
            return false;

        var mle = mono["MissionLogEntry"];
        var mtle = mono["MissionTaskLogEntry"];

        var mtso = mono["PHL_MissionTask_SO"];

        vars.GetCompletedTasks = (Func<List<string>>)(() =>
        {
            var tasks = new List<string>();

            foreach (var mission in vars.Helper.ReadList<IntPtr>(mm.Static + mm["instance"], mm["missionLog"]))
            {
                foreach (var task in vars.Helper.ReadList<IntPtr>(mission + mle["tasks"]))
                {
                    if (vars.Helper.Read<bool>(task + mtle["completed"]))
                    {
                        var id = vars.Helper.ReadString(task + mtle["missionTaskSO"], dbo["id"]);
                        var desc = vars.Helper.ReadString(task + mtle["missionTaskSO"], mtso["taskTexto"], tso["lines"], 0x10, 0x20, tl["text"]);

                        tasks.Add(id + " (\"" + desc + "\")");
                    }
                }
            }

            return tasks;
        });

        var com = mono["CollectableObjectManager"];
        if (com.Static == IntPtr.Zero)
            return false;

        vars.GetCollectedObjects = (Func<List<string>>)(() =>
        {
            var objects = new List<string>();

            var count = vars.Helper.Read<int>(com.Static + com["instance"], com["collectedObjects"], 0x40);
            for (int i = 0; i < count; i++)
            {
                var objGroup = vars.Helper.Deref(com.Static + com["instance"], com["collectedObjects"], 0x18, 0x20 + (0x18 * i) + 0x8);

                foreach (var obj in vars.Helper.ReadList<IntPtr>(objGroup + 0x8))
                {
                    var id = vars.Helper.ReadString(obj + dbo["id"]);
                    objects.Add(id);
                }
            }

            return objects;
        });

        return true;
    });

    current.Feats = new List<string>();
    current.Tasks = new List<string>();
    current.Objects = new List<string>();
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
    current.Objects = vars.GetCollectedObjects();

    for (int i = old.Feats.Count; i < current.Feats.Count; i++)
    {
        vars.Log("[FEAT] " + current.Feats[i]);

        if (settings[current.Feats[i]])
            vars.PendingSplits++;
    }

    for (int i = old.Tasks.Count; i < current.Tasks.Count; i++)
    {
        vars.Log("[TASK] " + current.Tasks[i]);

        if (settings[current.Tasks[i]])
            vars.PendingSplits++;
    }

    for (int i = old.Objects.Count; i < current.Objects.Count; i++)
    {
        vars.Log("[OBJ ] " + current.Objects[i]);

        if (settings[current.Objects[i]])
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
