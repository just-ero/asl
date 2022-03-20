state("TUNIC") {}
state("Secret Legend") {}

startup
{
	vars.Log = (Action<object>)(output => print("[TUNIC] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"TUNIC uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | TUNIC",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

onStart
{}

onSplit
{}

onReset
{}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		helper.Offsets = new[] { 0x18, 0x20, 0x120 };

		var srd = helper.GetClass("Assembly-CSharp", "SpeedrunData");

		vars.Unity.Make<float>(srd.Static, srd["inGameTime"]).Name = "inGameTime";
		vars.Unity.Make<bool>(srd.Static, srd["timerRunning"]).Name = "timerRunning";
		vars.Unity.Make<int>(srd.Static, srd["lastLoadedSceneIndex"]).Name = "lastLoadedSceneIndex";
		vars.Unity.Make<bool>(srd.Static, srd["gameComplete"]).Name = "gameComplete";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.IGT = vars.Unity["inGameTime"].Current;
	current.TimerRunning = vars.Unity["timerRunning"].Current;
	current.Scene = vars.Unity.Scenes.Active.Index;
	current.GameComplete = vars.Unity["gameComplete"].Current;

	if (old.Scene != current.Scene)
		vars.Log(old.Scene + " -> " + current.Scene);
}

start
{
	return !old.TimerRunning && current.TimerRunning;
}

split
{
	return !old.GameComplete && current.GameComplete;
}

reset
{
	return old.Scene != 2 && current.Scene == 2;
}

gameTime
{
	return TimeSpan.FromSeconds(vars.Unity["inGameTime"].Current);
}

isLoading
{
	return true;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}