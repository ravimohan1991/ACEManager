/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACE_InfoWindow
//
//- New window to display ACE info
//=============================================================================

class ACE_InfoWindow extends UWindowDialogClientWindow ;

var UWindowLabelControl LabelPlayerInfo;
var ACEM_PlayerFrameCW PlayerinfoFrame;
var ACEM_PlayerinfoListBox PlayerinfoList;

function Created()
{
     Super.Created();

     LabelPlayerInfo = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 30,10,120,20));
	 LabelPlayerInfo.SetText("Player Info:");
	 PlayerinfoFrame = ACEM_PlayerFrameCW(CreateWindow(class'ACEM_PlayerFrameCW', 20,20,400,400));
	 PlayerinfoList = ACEM_PlayerinfoListBox(CreateWindow(class'ACEM_PlayerinfoListBox',20,20,400,400));
	 PlayerinfoFrame.Frame.SetFrame(PlayerinfoList);
     PlayerinfoList.Items.Clear();


}


defaultproperties
{
}
