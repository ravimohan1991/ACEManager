/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_Window
//
//- Makes framed window ( looks better and becomes movable )
//=============================================================================

class ACEM_Window extends UWindowFramedWindow;

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
     ClientClass = class'ACEManager_MainWindow';
     bSizable = False;
}

defaultproperties
{
    version="v1.5"
}
