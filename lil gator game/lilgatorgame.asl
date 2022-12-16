state("lil gator game") {}

startup
{
  Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
  vars.Helper.GameName = "lil gator game";

//   vars.CompletedSplits = new HashSet<string>();

  vars.Helper.AlertLoadless();
}

onStart
{
//   vars.CompletedSplits.Clear();
}

init
{
  vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
  {
    vars.Helper["State"] = mono.Make<int>("Game", "g", "state");
    vars.Helper["CreditsPlaying"] = mono.Make<bool>("OverriddenMusic", "isOverridden");
    vars.Helper["VolumeMultiplier"] = mono.Make<float>("FadeGameVolume", "volumeMultiplier");

    // var boolsKeys = mono.MakeList<IntPtr>("GameData", "instance", "gameSaveData", "bools", 0x50);
    // var boolsVals = mono.MakeList<bool>("GameData", "instance", "gameSaveData", "bools", 0x58);

    // vars.GetBools = (Func<Dictionary<string, bool>>)(() =>
    // {
    //   boolsKeys.Update(game);
    //   boolsVals.Update(game);

    //   var bools = new Dictionary<string, bool>(boolsKeys.Current.Count);

    //   for (int i = 0; i < boolsKeys.Current.Count; i++)
    //   {
    //     var key = vars.Helper.ReadString(false, boolsKeys.Current[i]);
    //     bools[key] = boolsVals.Current[i];
    //   }

    //   return bools;
    // });

    // var intsKeys = mono.MakeList<IntPtr>("GameData", "instance", "gameSaveData", "ints", 0x50);
    // var intsVals = mono.MakeList<int>("GameData", "instance", "gameSaveData", "ints", 0x58);

    // vars.GetInts = (Func<Dictionary<string, int>>)(() =>
    // {
    //   intsKeys.Update(game);
    //   intsVals.Update(game);

    //   var ints = new Dictionary<string, int>(intsKeys.Current.Count);

    //   for (int i = 0; i < intsKeys.Current.Count; i++)
    //   {
    //     var key = vars.Helper.ReadString(false, intsKeys.Current[i]);
    //     ints[key] = intsVals.Current[i];
    //   }

    //   return ints;
    // });

    return true;
  });
}

start
{
  return old.State == 2 && current.State == 0;
}

split
{
//   foreach (var kvp in vars.GetBools())
//   {
//     var key = kvp.Key;

//     if (settings.ContainsKey(key)
//         && settings[key]
//         && kvp.Value
//         && vars.CompletedSplits.Add(key))
//     {
//       return true;
//     }
//   }

//   foreach (var kvp in vars.GetInts())
//   {
//     var key = kvp.Key + "-" + kvp.Value;

//     if (settings.ContainsKey(key)
//         && settings[key]
//         && vars.CompletedSplits.Add(key))
//     {
//       return true;
//     }
//   }

  return !old.CreditsPlaying && current.CreditsPlaying;
}

reset
{
  return old.State == 2 && current.State == 0;
}

isLoading
{
  return current.VolumeMultiplier < 1f;
}
