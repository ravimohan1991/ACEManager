/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_PlayerFrameCW
//
//- Creats frame for window showing players
//=============================================================================

class ACEM_PlayerFrameCW extends UMenuDialogClientWindow;

var UWindowControlFrame Frame;


function Created()
{
     Frame = UWindowControlFrame(CreateWindow(class'UWindowControlFrame', 0, 0, WinWidth, WinHeight));
     Super.Created();
}

function BeforePaint(Canvas C, float X, float Y)
{
	 Super.BeforePaint(C, X, Y);

	 Frame.WinLeft = 0;
	 Frame.WinTop = 0;
	 Frame.SetSize(WinWidth, WinHeight);
}



defaultproperties
{
}
