state("Grapple") {} // Steam version
state("Grappler!") {} // itch.io verison

startup
{
  Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
  vars.Helper.LoadSceneManager = true;
}

init
{
  vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
  {
    Thread.Sleep(1000);

    if (game.ProcessName == "Grappler!")
    {
      var gpm = mono["GameplayManager"];
      var pm = mono["PlayerMovement"];

      vars.Helper["Time"] = gpm.Make<float>("instance", "timeElapsed");
      vars.Helper["PlayerActive"] = pm.Make<bool>("Instance", "isActive");
    }
    else
    {
      var lm = mono["LevelManager"];
      var pm = mono["PlayerMovement"];

      vars.Helper["Time"] = lm.Make<float>("singleton", "TimeElapsed");
      vars.Helper["State"] = pm.Make<int>("currentState");
    }

    return true;
  });
}

update
{
  current.Scene = vars.Helper.Scenes.Loaded[0].Index;

  current.LevelComplete =
    game.ProcessName == "Grappler!"
    ? !current.PlayerActive
    : current.State == 5;
}

start
{
  return old.Time == 0f && current.Time > 0f;
}

split
{
  return !old.LevelComplete && current.LevelComplete;
}

reset
{
  return old.Scene != 0 && current.Scene == 0;
}
