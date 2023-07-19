state("Shady Knight Demo") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

    vars.TotalTime = 0f;

    vars.MissionStates = new ExpandoObject();
        vars.MissionStates.Intro = 0;
        vars.MissionStates.InProcess = 1;
        vars.MissionStates.Complete = 2;
}

onStart
{
    vars.TotalTime = 0f;
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["MissionState"] = mono.Make<int>("Game", "mission", "state");
        vars.Helper["MissionTime"] = mono.Make<float>("Game", "mission", "rawResults", "time");

        return true;
    });
}

start
{
    return old.MissionState == vars.MissionStates.Intro && current.MissionState == vars.MissionStates.InProcess;
}

split
{
    return old.MissionState == vars.MissionStates.InProcess && current.MissionState == vars.MissionStates.Complete;
}

reset
{
    return old.MissionState != vars.MissionStates.Intro && current.MissionState == vars.MissionStates.Intro;
}

gameTime
{
    return TimeSpan.FromSeconds(current.MissionTime);
}

isLoading
{
    return true;
}
