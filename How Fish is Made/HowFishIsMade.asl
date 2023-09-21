state("How Fish is Made") {}

startup
{
  Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
}

onStart
{
  vars.HasSplitForEnd = false;
  vars.Ragdolls = 0;
}

init
{
  vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
  {
    vars.Helper["OnMainMenu"] = mono.Make<bool>("MainMenuManager", "instance", "start");
    vars.Helper["EndDialogRunning"] = mono.Make<bool>("MainMenuManager", "instance", "manager", "endCutsceneConvoRenderer", "dialogRunning");
    vars.Helper["IsRagdoll"] = mono.Make<bool>("MainMenuManager", "instance", "manager", "player", "isRagdoll");

    return true;
  });

  vars.HasSplitForEnd = false;
  vars.Ragdolls = 0;
}

start
{
  return old.OnMainMenu && !current.OnMainMenu;
}

split
{
  return old.IsRagdoll && !current.IsRagdoll
    || !old.EndDialogRunning && current.EndDialogRunning;
}

reset
{
  return false;
}

exit
{
  if (settings.ResetEnabled && timer.CurrentPhase != TimerPhase.Ended)
    vars.Helper.Timer.Reset();
}
