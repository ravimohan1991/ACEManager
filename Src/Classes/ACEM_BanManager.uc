/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_BanManager
//
//- This is a page for managing bans
//- Bans by sending mutate command ( stores banned players in ini ) -> Done
//- Kicks by sending mutate command                                 -> Done
//- Shows ACE information of Current and Banned players             -> Done
//- Add button sound                                                -> Done
//- Improving GUI                                                   -> TODO
//=============================================================================
class ACEM_BanManager extends UWindowPageWindow ;

var UWindowLabelControl LabelCurrPlayer;
var UWindowLabelControl CurrPlayerInfo;
var UWindowLabelControl LabelBannedPlayer;
var UWindowLabelControl BannedPlayerInfo;
var UWindowSmallButton ButtonKickPlayer;
var UWindowSmallButton ButtonBanPlayer;
var UWindowSmallButton ButtonUnBanPlayer;
var UWindowSmallButton ButtonShowInfo;
var UWindowSmallButton ButtonShowBanInfo;
var UWindowSmallButton ButtonManualBan;
var ACEM_PlayerFrameCW CurrPlayerFrame;
var ACEM_PlayerListBox CurrPlayerList;
var ACEM_PlayerFrameCW PlayerinfoFrame;
var ACEM_PlayerinfoListBox PlayerinfoList;
var ACEM_PlayerFrameCW BannedPlayerFrame;
var ACEM_BannedPlayerListBox BannedPlayerList;
var ACEM_PlayerFrameCW BannedPlayerinfoFrame;
var ACEM_BannedPlayerInfoListBox BannedPlayerInfoList;

function Created()
{
     Super.Created();

     LabelCurrPlayer = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 30,10,120,20));
	 LabelCurrPlayer.SetText("Current players:");
	 CurrPlayerFrame = ACEM_PlayerFrameCW(CreateWindow(class'ACEM_PlayerFrameCW', 20,20,230,300));
	 CurrPlayerList = ACEM_PlayerListBox(CreateWindow(class'ACEM_PlayerListBox',0, 0,300, 300));
	 CurrPlayerFrame.Frame.SetFrame(CurrPlayerList);
	 ButtonKickPlayer = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 70, 350, 120, 35));
	 ButtonKickPlayer.SetText("Kick");
	 ButtonKickPlayer.DownSound= sound'UnrealShare.BeltSnd';
     ButtonBanPlayer = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 70, 370, 120, 35));
	 ButtonBanPlayer.SetText("Ban");
	 ButtonBanPlayer.DownSound = sound'UnrealShare.BeltSnd';
	 ButtonShowInfo = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 70, 390, 120, 35));
	 ButtonShowInfo.DownSound = sound'UnrealShare.BeltSnd';
     ButtonShowInfo.SetText("ShowInfo");


     LabelBannedPlayer = UWindowLabelControl(CreateControl(class'UWindowLabelControl',330,10,120,20));
	 LabelBannedPlayer.SetText("Banned players:");
	 BannedPlayerFrame = ACEM_PlayerFrameCW(CreateWindow(class'ACEM_PlayerFrameCW', 290,20,230,300));
	 BannedPlayerList = ACEM_BannedPlayerListBox(CreateControl(class'ACEM_BannedPlayerListBox',290,20,230,300));
     BannedPlayerFrame.Frame.SetFrame(BannedPlayerList);
     //BannedPlayerList.Items.Clear();
	 ButtonUnBanPlayer = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 340,350 , 120, 35));
	 ButtonUnBanPlayer.SetText("UnBan");
	 ButtonUnbanPlayer.DownSound = sound'UnrealShare.BeltSnd';
     ButtonShowBanInfo = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 340, 370, 120, 35));
	 ButtonShowBanInfo.DownSound = sound'UnrealShare.BeltSnd';
     ButtonShowBanInfo.SetText("ShowInfo");

     ButtonManualBan = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 340,390 , 120, 35));
     ButtonManualBan.SetText(" Manual Ban ");
     ButtonManualBan.DownSound = sound'UnrealShare.BeltSnd';
}

function Notify(UWindowDialogControl C, byte E)
{
	 local string s;
	 local ACEM_List I;
	 local ACEM_BannedPlayerListItem J;
	 local int ID;

	 switch(E)
     {
		case DE_Click:
			switch(C)
            {
		     case ButtonKickPlayer:
                  for (I = ACEM_List(CurrPlayerList.Items.Next); I != None; I = ACEM_List(I.Next))
		          {
		           if (I.bSelected)
                    {
                     ID = I.ID;
                     GetPlayerOwner().ConsoleCommand("mutate acem kickid"@ID);
                     CurrPlayerList.bChanged = true;
                    }
                  }
                  return;
             case ButtonBanPlayer:
                  for (I = ACEM_List(CurrPlayerList.Items.Next); I != None; I = ACEM_List(I.Next))
		           {
		            if (I.bSelected)
                     {
                      ID = I.ID;
                      GetPlayerOwner().ConsoleCommand("mutate acem banid"@ID);
                      CurrPlayerList.bChanged = true;
                     }
                   }
		           return;
             case ButtonUnBanPlayer:
                  for (J = ACEM_BannedPlayerListItem(BannedPlayerList.Items.Next); J != None; J = ACEM_BannedPlayerListItem(J.Next))
		           {
		            if (J.bSelected)
                     {
                      ID = J.PlayerID;
                      GetPlayerOwner().ConsoleCommand("mutate acem unbanid"@ID);
                     }
                    }
		           return;
	         case ButtonShowBanInfo:
                  for (J = ACEM_BannedPlayerListItem(BannedPlayerList.Items.Next); J != None; J = ACEM_BannedPlayerListItem(J.Next))
		           {
		            if (J.bSelected)
                     {
                      ID = J.PlayerID;
                      GetPlayerOwner().ConsoleCommand("mutate acem showbaninfoid"@ID);
                     }
                    }
		           return;
             case ButtonShowInfo:
                  for (I = ACEM_List(CurrPlayerList.Items.Next); I != None; I = ACEM_List(I.Next))
		           {
		            if (I.bSelected)
                     {
                      ID = I.ID;
                      GetPlayerOwner().ConsoleCommand("mutate acem showcurrinfoid"@ID);
                     }
                    }
		           return;

              case ButtonManualBan:
                       GetPlayerOwner().ConsoleCommand("mutate acem manualban");
                    return;
            }
             break;
     }
     Super.Notify(C,E);
}


defaultproperties
{
}
