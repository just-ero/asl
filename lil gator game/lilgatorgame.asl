state("lil gator game") {}

startup
{
  Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
  vars.Helper.GameName = "lil gator game";
  vars.Helper.Settings.CreateFromXml("Components/lilgatorgame.Settings.xml");
  vars.Helper.AlertGameTime();
}

init
{
  current.Flashback = false;
  current.Item = null;
  current.Friend = null;

  vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
  {
    var srd = mono["SpeedrunData"];
    if (srd.Static == IntPtr.Zero)
      return false;

    vars.Helper["State"] = srd.Make<int>("state");
    vars.Helper["IGT"] = srd.Make<double>("inGameTime");

    vars.Helper["TutorialEnd"] = srd.Make<bool>("tutorialEnd_LastInput");
    vars.Helper["JillQuest"] = srd.Make<bool>("jillQuestComplete");
    vars.Helper["MartinQuest"] = srd.Make<bool>("martinQuestComplete");
    vars.Helper["AveryQuest"] = srd.Make<bool>("averyQuestComplete");
    vars.Helper["Town"] = srd.Make<bool>("showTownToSis");
    vars.Helper["Credits"] = srd.Make<bool>("credits");
    vars.Helper["Home"] = srd.Make<bool>("thanksForPlaying");

    vars.Helper["ObjectStates"] = mono.Make<IntPtr>("GameData", "instance", "gameSaveData", "objectStates");

    // handling collectibles
    var list = mono["mscorlib", "List_1"];

    var itemPtr = srd.Make<int>("unlockedItems", list["_size"]);
    vars.GetMostRecentItem = (Func<string>)(() =>
    {
      itemPtr.Update(game);
      return vars.Helper.ReadString(srd.Static + srd["unlockedItems"], list["_items"], (itemPtr.Current + 3) * 0x8);
    });

    var friendPtr = srd.Make<int>("unlockedFriends", list["_size"]);
    vars.GetMostRecentFriend = (Func<string>)(() =>
    {
      friendPtr.Update(game);
      return vars.Helper.ReadString(srd.Static + srd["unlockedFriends"], list["_items"], (friendPtr.Current + 3) * 0x8);
    });

    return true;
  });
}

update
{
  current.Item = vars.GetMostRecentItem();
  current.Friend = vars.GetMostRecentFriend();
}

start
{
  return old.State == 0 && current.State == 1;
}

split
{
  if (settings["flashback"])
  {
    var count = current.ObjectStates + (vars.Helper.PtrSize * 3);
    if (vars.Helper.Read<int>(count) >= 965)
    {
      var finalObj = current.ObjectStates + (vars.Helper.PtrSize * 4) + 965;
      current.Flashback = vars.Helper.Read<bool>(finalObj);

      if (!old.Flashback && current.Flashback)
        return true;
    }
  }

  return old.Item != current.Item && settings[current.Item] || old.Friend != current.Friend && settings[current.Friend]
         || !old.TutorialEnd && current.TutorialEnd && settings["tutorialEnd"]
         || !old.JillQuest && current.JillQuest && settings["jillQuest"]
         || !old.MartinQuest && current.MartinQuest && settings["martinQuest"]
         || !old.AveryQuest && current.AveryQuest && settings["averyQuest"]
         || !old.Town && current.Town && settings["showTown"]
         || !old.Credits && current.Credits && settings["credits"]
         || !old.Home && current.Home && settings["goHome"];
}

reset
{
  return old.State != 0 && current.State == 0;
}

gameTime
{
  return TimeSpan.FromSeconds(current.IGT);
}

isLoading
{
  return true;
}
