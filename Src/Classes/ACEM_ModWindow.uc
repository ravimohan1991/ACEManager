/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEManager ModMenu
//=============================================================================
class ACEM_ModWindow extends UWindowFramedWindow;

var string Version;

function Created()
{
     Super.Created();
     SetSizePos();
}

function ResolutionChanged(float W, float H)
{
     Super.ResolutionChanged(W, H);
     SetSizePos();
}

function SetSizePos()
{
     SetSize(550, 500);
     WinLeft = Int((Root.WinWidth - WinWidth) / 2);
     WinTop = Int((Root.WinHeight - WinHeight) / 2);
}

function BeginPlay()
{
     Super.BeginPlay();
     WindowTitle = "ACE_Manager("$Version$") -by The_Cowboy";
     ClientClass = class'ACEManager_ModMenueWindow';
     //ClientClass = class'ACE_InfoWindow';
     bSizable = False;
}


defaultproperties
{
    version="v1.5"
}
