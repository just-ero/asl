state("Grappler!") {}

startup
{
	vars.Log = (Action<object>)(output => print("[Grapple] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;
	vars.TotalTime = 0f;

	settings.Add("ilReset", false, "Reset timer when restarting a level");
}

onStart
{
	vars.TotalTime = 0f;
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var gpm = helper.GetClass("Assembly-CSharp", "GameplayManager");

		vars.Unity.Make<bool>(gpm.Static, gpm["instance"], gpm["shouldIncrement"]).Name = "shouldIncrement";
		vars.Unity.Make<bool>(gpm.Static, gpm["instance"], gpm["reset"]).Name = "reset";
		vars.Unity.Make<bool>(gpm.Static, gpm["instance"], gpm["firstJump"]).Name = "firstJump";
		vars.Unity.Make<float>(gpm.Static, gpm["instance"], gpm["timeElapsed"]).Name = "timeElapsed";

		return true;
	});

	vars.Unity.Load(game, tryLoadTimeout: 1000);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.Scene = vars.Unity.Scenes.Loading[0].Index;
	current.ShouldIncrement = vars.Unity["shouldIncrement"].Current;
	current.Reset = vars.Unity["reset"].Current;
	current.FirstJump = vars.Unity["firstJump"].Current;
	current.Time = vars.Unity["timeElapsed"].Current;

	if (old.Scene != current.Scene)
		vars.Log(old.Scene + " -> " + current.Scene);
}

start
{
	return !old.FirstJump && current.FirstJump;
}

split
{
	return old.Scene < current.Scene && current.Scene > 0;
}

reset
{
	return old.Scene != 0 && current.Scene == 0 ||
	       (!old.Reset && current.Reset || old.FirstJump && !current.FirstJump) && (settings["ilReset"] ? true : current.Scene == 1);
}

gameTime
{
	if (old.FirstJump && !current.FirstJump)
		vars.TotalTime += old.Time;

	return TimeSpan.FromSeconds(vars.TotalTime + current.Time);
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