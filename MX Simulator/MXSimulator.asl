state("mx")
{
	int PlayerID         : 0x26F234;
	int PlayersInRace    : 0x323220;

	int FirstLapCPs      : 0x320D4C;
	int NormalLapCPs     : 0x320D50;

	//double TickRate      : 0x162B90;
	int RaceTicks        : 0x322300;
	//int ServerStartTicks : 0x43248A0;

	string512 TrackName  : 0x31ED10, 0x0;
}

startup
{
	vars.TimerModel = new TimerModel { CurrentState = timer };

	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{
		var mbox = MessageBox.Show(
			"MX Simulator uses in-game time.\nWould you like to switch to it?",
			"LiveSplit | MX Simulator",
			MessageBoxButtons.YesNo);

		if (mbox == DialogResult.Yes)
			timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
}

onStart
{
	vars.ValidLap = true;
}

init
{
	#region Initializing Variables
	current.CPs = 0;
	current.IDinRace = 0;
	vars.StartTicks = 0;

	vars.CPsChanged = false;
	vars.OnFinalSplit = false;
	vars.OnFirstCP = false;
	vars.ValidLap = true;
	vars.ShowMsg = false;

	vars.IDPtr = IntPtr.Zero;
	vars.CPPtr = IntPtr.Zero;
	#endregion

	#region Custom Functions
	// Whenever the player's position changes in a race (ghost in time trials counts too), the checkpoint memory address needs to be updated.
	vars.UpdatePtrs = (Action)(() =>
	{
		if (current.PlayersInRace > 0)
		{
			for (int i = 0; i < current.PlayersInRace; ++i)
			{
				if (game.ReadValue<int>((IntPtr)(vars.IDPtr = 0x322AA0 + 0xC * i)) == current.PlayerID)
				{
					vars.CPPtr = 0x322AA4 + 0xC * i;
					break;
				}
			}
		}
	});

	// A message box to pop up when the current number of splits or track name doesn't line up with the currently loaded track.
	vars.TrackMsg = (Action)(() =>
	{
		var mbox = DialogResult.None;

		if (!string.IsNullOrEmpty(current.TrackName) && (current.NormalLapCPs > 0 && timer.Run.Count != current.NormalLapCPs || timer.Run.CategoryName != current.TrackName)) {
			mbox = MessageBox.Show(
				"Current splits configuration:\n" + "\"" + timer.Run.CategoryName + "\" with " + timer.Run.Count + " segments\n\n" +
				"Required configuration:\n" + "\"" + current.TrackName + "\" with " + current.NormalLapCPs + " segments\n\n" +
				"Do you want to save your splits now and generate new ones for this track?",
				"MX Simulator Auto Splitter",
				MessageBoxButtons.YesNo,
				MessageBoxIcon.Information
			);
		}

		if (mbox == DialogResult.Yes)
		{
			timer.Form.ContextMenuStrip.Items["saveSplitsAsMenuItem"].PerformClick();

			int currAmtSplits = timer.Run.Count;

			for (int gateNo = 1; gateNo <= current.NormalLapCPs; ++gateNo)
				timer.Run.Add(new Segment("Gate " + gateNo));

			for (int splitNo = 1; splitNo <= currAmtSplits; ++splitNo)
				timer.Run.RemoveAt(0);

			timer.Run.GameName = "MX Simulator";
			timer.Run.CategoryName = current.TrackName;
		}
	});

	// Using this instead of Thread.Sleep() so as to not block the thread.
	vars.Wait = (Action<int>)(time => System.Threading.Tasks.Task.Run(async () => await System.Threading.Tasks.Task.Delay(time)).Wait());
	#endregion

	vars.UpdatePtrs();
	vars.TrackMsg();
}

update
{
	if ((IntPtr)vars.IDPtr == IntPtr.Zero || (IntPtr)vars.CPPtr == IntPtr.Zero)
	{
		vars.UpdatePtrs();
		return false;
	}

	#region Variable Updating
	// Updating several variables according to our needs.

	current.CPs = game.ReadValue<int>((IntPtr)vars.CPPtr);
	current.IDinRace = game.ReadValue<int>((IntPtr)vars.IDPtr);

	vars.CPsChanged = old.PlayerID == current.IDinRace && old.CPs != current.CPs || old.PlayerID != current.IDinRace && old.CPs == current.CPs;
	vars.OnFinalSplit = timer.CurrentSplitIndex == timer.Run.Count - 1;
	vars.OnFirstCP = (current.CPs - current.FirstLapCPs) % current.NormalLapCPs == 0;

	if (current.IDinRace != current.PlayerID) vars.UpdatePtrs();
	#endregion


	#region Splits Message
	// When the track the user is on changes, a messagebox will appear prompting them to save the splits and create new ones for this track.

	if (old.FirstLapCPs != old.FirstLapCPs ||
	    old.NormalLapCPs != current.NormalLapCPs ||
	    old.TrackName != current.TrackName && !string.IsNullOrEmpty(current.TrackName))
	{
		vars.ShowMsg = true;
	}

	if (vars.ShowMsg && current.RaceTicks > 0)
	{
		vars.ShowMsg = false;
		vars.MsgShownForTrack = current.TrackName;
		vars.TrackMsg();
	}
	#endregion


	#region Reset Handling
	// To accomodate for TimerPhase.Ended, we need to do this outside of the reset {} block.

	if (settings.ResetEnabled)
	{
		if (old.RaceTicks > current.RaceTicks ||
		    current.IDinRace != current.PlayerID ||
		    vars.CPsChanged && vars.OnFirstCP && (!vars.OnFinalSplit || !vars.ValidLap) && timer.CurrentSplitIndex > 0)
		{
			vars.Wait(500);
			vars.UpdatePtrs();
			vars.TimerModel.Reset();
		}

		if (timer.CurrentPhase == TimerPhase.Ended && old.PlayerID == current.IDinRace && old.CPs < current.CPs)
		{
			vars.TimerModel.Reset();
			vars.TimerModel.Start();

			vars.Wait(20);
		}
	}
	#endregion
}

start
{
	if (old.CPs != current.CPs && current.CPs == current.FirstLapCPs ||
	    current.CPs - current.FirstLapCPs > 0 && vars.OnFirstCP)
	{
		vars.StartTicks = current.RaceTicks;
		return true;
	}
}

split
{
	if (vars.CPsChanged)
	{
		if (old.PlayersInRace < current.PlayersInRace) return false;
		int expectedCP = old.CPs + 1, actualCP = current.CPs;

		if (expectedCP < actualCP)
		{
			vars.ValidLap = false;
			for (int i = expectedCP; i < actualCP; ++i)
				vars.TimerModel.SkipSplit();
		}

		if (vars.OnFirstCP)
		{
			vars.StartTicks = current.RaceTicks;
			if (!vars.OnFinalSplit || !vars.ValidLap) return false;
		}

		return true;
	}
}

reset
{
	return false;
}

gameTime
{
	return TimeSpan.FromSeconds((current.RaceTicks - vars.StartTicks) * 0.0078125);
}

isLoading
{
	return true;
}

exit
{
	vars.TimerModel.Reset();
}