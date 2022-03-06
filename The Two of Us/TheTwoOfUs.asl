state("The Two of Us") {}

startup
{
	vars.Log = (Action<object>)(output => print("[The Two of Us] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;

	vars.StartTime = 0f;
}

onStart
{
	vars.StartTime = current.IGT;
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var asd = helper.GetClass("Assembly-CSharp", "AutoSplitterData");

		vars.Unity.Make<float>(asd.Static, asd["inGameTime"]).Name = "inGameTime";
		vars.Unity.Make<int>(asd.Static, asd["levelID"]).Name = "levelID";
		// vars.Unity.Make<int>(asd.Static, asd["runState"]).Name = "runState";

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded) return false;

	vars.Unity.Update();

	current.IGT = vars.Unity["inGameTime"].Current;
	current.Level = vars.Unity["levelID"].Current;
	// current.State = vars.Unity["runState"].Current; // currently unusable
	current.Scene = vars.Unity.Scenes.Active.Index;
}

start
{
	// return old.State == 0 && current.State == 1;
	return old.Scene == 0 && (current.Scene == 1 || current.Scene == 10);
}

split
{
	return old.Level < current.Level;
}

reset
{
	// return old.State == 1 && current.State == 0;
}

gameTime
{
	return TimeSpan.FromSeconds(current.IGT - vars.StartTime);
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