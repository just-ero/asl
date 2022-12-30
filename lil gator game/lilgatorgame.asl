state("lil gator game") {}

startup
{
  Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
  vars.Helper.GameName = "lil gator game";
  vars.Helper.Settings.CreateFromXml("Components/lilgatorgame.Settings.xml");

  vars.CompletedBools = new HashSet<int>();
  vars.CompletedInts = new HashSet<int>();

  vars.IgnoredKeys = new HashSet<string>
  {
    "CraftingMaterials", "PrologueCameraRotation",
    "CameraRotation" , "PlayerRotation" , "PlayerPosition_X" , "PlayerPosition_Y" , "PlayerPosition_Z",
    "CameraFBRotation" , "PlayerFBRotation" , "PlayerFBPosition_X" , "PlayerFBPosition_Y" , "PlayerFBPosition_Z"
  };

  vars.Helper.AlertRealTime();
}

onStart
{
  vars.CompletedBools.Clear();
  vars.CompletedInts.Clear();
}

init
{
  vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
  {
    vars.Helper["Playing"] = mono.Make<bool>("GameData", "instance", "save");

    var dict = mono["mscorlib", "Dictionary_2"];

    vars.Helper["BoolsCount"] = mono.Make<int>("GameData", "instance", "gameSaveData", "bools", dict["count"]);
    vars.Helper["BoolsEntries"] = mono.Make<IntPtr>("GameData", "instance", "gameSaveData", "bools", dict["entries"]);

    vars.Helper["IntsCount"] = mono.Make<int>("GameData", "instance", "gameSaveData", "ints", dict["count"]);
    vars.Helper["IntsEntries"] = mono.Make<IntPtr>("GameData", "instance", "gameSaveData", "ints", dict["entries"]);

    vars.Helper["ObjectStates"] = mono.Make<IntPtr>("GameData", "instance", "gameSaveData", "objectStates");

    return true;
  });
}

update
{
  if (settings["any%End"])
  {
    var ps = vars.Helper.PtrSize;
    var addr = current.ObjectStates + (ps * 4) + 965;
    current.AnyPercentComplete = vars.Helper.Read<bool>(addr);
  }
}

start
{
  return !old.Playing && current.Playing;
}

split
{
  var ps = vars.Helper.PtrSize;

  for (int i = 0; i < current.BoolsCount; i++)
  {
    if (vars.CompletedBools.Contains(i)) continue;

    var addr = current.BoolsEntries + (ps * 4) + (ps * 3 * i);
    var value = vars.Helper.Read<bool>(addr + (ps * 2));

    if (!value) continue;

    vars.CompletedBools.Add(i);

    var key = "b" + vars.Helper.ReadString(addr + (ps * 1));

    if (settings.ContainsKey(key) && settings[key])
    {
      return true;
    }
  }

  for (int i = 0; i < current.IntsCount; i++)
  {
    if (vars.CompletedInts.Contains(i)) continue;

    var addr = current.IntsEntries + (ps * 4) + (ps * 3 * i);
    var value = vars.Helper.Read<int>(addr + (ps * 2));

    if (value <= 0) continue;

    var key = vars.Helper.ReadString(addr + (ps * 1));
    if (vars.IgnoredKeys.Contains(key)) continue;

    key = "i" + key + "-" + value;
    if (settings.ContainsKey(key) && settings[key])
    {
      vars.CompletedInts.Add(i);
      return true;
    }
  }

  if (settings["any%End"])
  {
    var addr = current.ObjectStates + (ps * 4) + 965;
    current.AnyPercentComplete = vars.Helper.Read<bool>(addr);

    return !old.AnyPercentComplete && current.AnyPercentComplete;
  }
}

reset
{
  return old.Playing && !current.Playing;
}
