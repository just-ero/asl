# LiveSplit Auto Splitters *(by Ero)*
## <a id="pookie"/>How do I activate an auto splitter?

All of my auto splitters are available through LiveSplit's [`LiveSplit.AutoSplitters.xml`](https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/LiveSplit.AutoSplitters.xml).
To activate them, simply follow these steps:
* open any split file
* right-click LiveSplit and choose "Edit Splits..."
* set the game name to your desired game
* click the "Activate" button below

Then check and edit the settings to your liking.
Don't forget to set your timing method to "Game Time" for auto splitters with load removal.

## There is an issue with an auto splitter I'm using!
Please first refer to these common problems to try and troubleshoot the issue yourself:  
<br/>

> The auto splitter does not remove loads / sync to the in-game time!

Please make sure your *Current Timing Method* is set to *Game Time* within LiveSplit. It could be that your *Timer* component (in your *Layout*) is set to *Real Time* as well.  
<br/>

> The auto splitter doesn't load at all! No settings are showing up and Start/Split/Reset are grayed out.

This can happen if you're on a LiveSplit version before 1.8.18. This version introduced `onStart`, `onSplit`, and `onReset` actions, which can't be loaded on earlier versions.  
<br/>

> The auto splitter cannot be activated from the splits editor!

This occasionally happens and does not have a fix. Attempt launching LiveSplit as administrator. If the issue persists, the bug is on LiveSplit's side.  
<br/>
[pookie](#pookie)

Your issue isn't listed? Please [create an issue here on GitHub](https://github.com/just-ero/asl/issues/new/choose).  
Want to try and help me out with the fixes? Set up [Trace Spy](https://gist.github.com/just-ero/1e3b784fa63059f04f8dd2810dfa8f13) and add any error messages you see to the GitHub issue!

## Commission Information
I take commissions for creating auto splitters. I am especially proficient in ***Unity*** and ***Unreal Engine*** games, with a decent hint of ***GameMaker Studio***. Auto splitters I make on those engines will never use strange work-arounds and always be solid.

