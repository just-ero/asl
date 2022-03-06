state("How Fish is Made") {}

startup
{
	vars.Log = (Action<object>)(output => print("[How Fish is Made] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.TimerModel = new TimerModel { CurrentState = timer };
}

onStart
{
	vars.HasSplitForEnd = false;
	vars.Ragdolls = 0;
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		Thread.Sleep(3000);

		var mmm = helper.GetClass("Assembly-CSharp", "MainMenuManager");
		if (mmm.Static == IntPtr.Zero) return false;

		var gm = helper.GetClass("Assembly-CSharp", "GameManager");
		var dr = helper.GetClass("Assembly-CSharp", "DialogRenderer");
		var pfc = helper.GetClass("Assembly-CSharp", "PlayerFishController");

		vars.Unity.Make<bool>(mmm.Static, mmm["instance"], mmm["start"]).Name = "onMainMenu";
		vars.Unity.Make<bool>(mmm.Static, mmm["instance"], mmm["manager"], gm["endCutsceneConvoRenderer"], dr["dialogRunning"]).Name = "endDialogRunning";
		vars.Unity.Make<bool>(mmm.Static, mmm["instance"], mmm["manager"], gm["player"], pfc["isRagdoll"]).Name = "isRagdoll";

		return true;
	});

	vars.Unity.Load(game);
	vars.HasSplitForEnd = false;
	vars.Ragdolls = 0;
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.UpdateAll(game);

	current.OnMainMenu = vars.Unity["onMainMenu"].Current;
	current.EndDialogRunning = vars.Unity["endDialogRunning"].Current;
	current.IsRagdoll = vars.Unity["isRagdoll"].Current;
}

start
{
	return old.OnMainMenu && !current.OnMainMenu;
}

split
{
	return old.IsRagdoll && !current.IsRagdoll ||
	       !old.EndDialogRunning && current.EndDialogRunning;
}

reset
{
	return false;
}

exit
{
	if (settings.ResetEnabled && timer.CurrentPhase != TimerPhase.Ended)
		vars.TimerModel.Reset();

	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}