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
  current.Item = null;
  current.Friend = null;

  vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
  {
    var srd = mono["SpeedrunData"];
    if (srd.Static == IntPtr.Zero)
      return false;

    vars.Helper["State"] = srd.Make<int>("state");
    vars.Helper["IGT"] = srd.Make<double>("inGameTime");


    // handling collectibles
    var list = mono["mscorlib", "List_1"];

    var unlockableCounts = new Dictionary<string, dynamic>
    {
      { "Item", srd.Make<int>("unlockedItems", list["_size"]) },
      { "Friend", srd.Make<int>("unlockedFriends", list["_size"]) }
    };

    vars.GetMostRecent = (Func<string, string>)(type =>
    {
      unlockableCounts[type].Update(game);

      int lastItemOffset = vars.Helper.PtrSize * (unlockableCounts[type].Current + 3);
      return vars.Helper.ReadString(srd.Static + srd["unlocked" + type + "s"], list["_items"], lastItemOffset);
    });

    return true;
  });
}

update
{
  current.Item = vars.GetMostRecent("Item");
  current.Friend = vars.GetMostRecent("Friend");

  if (old.Item != current.Item)
    vars.Log("New item: " + current.Item);

  if (old.Friend != current.Friend)
    vars.Log("New friend: " + current.Friend);
}

start
{
  return old.State == 0 && current.State == 1;
}

split
{
  return old.State == 1 && current.State == 2
         || old.Item != current.Item && settings[current.Item]
         || old.Friend != current.Friend && settings[current.Friend];
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
