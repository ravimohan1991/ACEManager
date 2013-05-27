/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_InfoWindowFrame
//
//- Makes framed window ( looks better and becomes movable )
//=============================================================================

class ACEM_InfoWindowFrame extends UWindowFramedWindow;

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
     SetSize(440, 470);
     WinLeft = Int((Root.WinWidth - WinWidth) / 2);
     WinTop = Int((Root.WinHeight - WinHeight) / 2);
}

function BeginPlay()
{
     Super.BeginPlay();
     WindowTitle = "Player's ACE Info";
     ClientClass = class'ACE_InfoWindow';
     bSizable = False;
}


defaultproperties
{
}
