state("Sonic the Hedgehog") {}

startup
{
  Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
  vars.Helper.GameName = "Sonic Project '06";
  vars.Helper.LoadSceneManager = true;

  vars.Helper.AlertLoadless();
}

onStart
{
  timer.IsGameTimePaused = true;
}

init
{
  current.State = -1;
  current.CheckPoint = "None";

  vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
  {
    var gm = mono["GameManager", 1];

    vars.Helper["state"] = mono.Make<int>(gm, "_instance", "GameState");
    vars.Helper["level"] = mono.MakeString(gm, "_instance", "LoadingTo");

    // var pd = mono.GetClass("PlayerData");
    // var cpd = mono.GetClass("CheckpointData");

    // vars.Helper["cp"] = gm.MakeString("_instance", gm["_PlayerData"] + pd["checkpoint"], cpd["SavePoint"]);

    return true;
  });
}

update
{
  current.State = vars.Helper["state"].Current;
  current.Level = vars.Helper["level"].Current;
  // current.CheckPoint = vars.Helper["cp"].Current ?? old.CheckPoint;
}

start
{
  return old.State == 0 && current.State == 1;
}

split
{
  return old.State == 2 && current.State == 5
    /* || old.CheckPoint != current.CheckPoint && settings[current.CheckPoint] */;
}

reset
{}

isLoading
{
  return current.State == 0 || current.State == 1 || current.State == 3;
}

/*
public enum State
{
  Menu,
  Loading,
  Playing,
  Hub,
  Paused,
  Result,
}
*/
