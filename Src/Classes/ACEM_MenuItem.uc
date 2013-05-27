/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_MenuItem
//
//- For spawning ACEManager_MainWindow on the client ( not from the server )
//- Adjust according to client ( not admin ) needs - TODO
//=============================================================================

class ACEM_MenuItem extends UMenuModMenuItem;

var string Version;

function Setup()
{
     MenuCaption = "ACEManager"@Version;
     MenuHelp = "ACEManager"@Version@"- Tool to administer Anti Cheat Engine";
     SaveConfig();
     StaticSaveConfig();
}

function Execute()
{
     MenuItem.Owner.Root.CreateWindow(class'ACEM_ModWindow',50,50,50,50);
}


defaultproperties
{
    version="v1.5"
}
