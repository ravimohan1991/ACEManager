/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_SShot
//
//- Page to create SnapShot of certain player by the admin
//- Provision to enable SShot by any player - DONE
//- Multiple shot command by multiple selection of players - TODO
//=============================================================================

class ACEM_SShot extends UWindowPageWindow ;

var UWindowLabelControl LabelCurrPlayer;
var UWindowSmallButton ButtonSShotPlayer;
var ACEM_PlayerFrameCW CurrPlayerFrame;
var ACEM_PlayerListBox CurrPlayerList;
var UWindowEditControl ACEM_AdminPassword;
var bool bAllowEveryOnetoSnap;
var bool bBanAdmin;

function Created()
{
     Super.Created();

     LabelCurrPlayer = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 30,10,120,20));
	 LabelCurrPlayer.SetText("Current players:");
	 CurrPlayerFrame = ACEM_PlayerFrameCW(CreateWindow(class'ACEM_PlayerFrameCW', 20,20,500,300));
	 CurrPlayerList = ACEM_PlayerListBox(CreateWindow(class'ACEM_PlayerListBox',0, 0,300, 300));
	 CurrPlayerFrame.Frame.SetFrame(CurrPlayerList);
	 ButtonSShotPlayer = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 120, 380, 280, 35));
     ButtonSShotPlayer.SetText("Take SnapShot !");
     ButtonSShotPlayer.DownSound = sound'UnrealShare.FSHLITE2';

     if( !bAllowEveryOnetoSnap && !bBanAdmin)
     {
      ACEM_AdminPassword = UWindowEditControl(CreateControl(class'UWindowEditControl',160,330,140,35));
      ACEM_AdminPassword.SetText("ACE Pass:");
	  ACEM_AdminPassword.SetHelpText("Enter the Anti Cheat Engine password to create SShot!");
      ACEM_AdminPassword.SetFont(F_Normal);
	  ACEM_AdminPassword.SetNumericOnly(False);
	  ACEM_AdminPassword.SetMaxLength(40);
	 }
}

function Notify(UWindowDialogControl C, byte E)
{
	 local ACEM_List I;
     local int ID;
     local string Pass;

     switch(E)
     {
       case DE_Click:
			switch(C)
            {
             case ButtonSShotPlayer:
                  if( !bAllowEveryOnetoSnap && !bBanAdmin )
                  {
                   for (I = ACEM_List(CurrPlayerList.Items.Next); I != None; I = ACEM_List(I.Next))
		           {
		            if (I.bSelected)
                    {
                     ID = I.ID;
                     pass = ACEM_AdminPassword.GetValue();
                     GetPlayerOwner().ConsoleCommand("mutate ace sshot"@ID@pass);
                    }
                   }
                  }
                  else
                  {
                   for (I = ACEM_List(CurrPlayerList.Items.Next); I != None; I = ACEM_List(I.Next))
		           {
		            if (I.bSelected)
                    {
                     ID = I.ID;
                     GetPlayerOwner().ConsoleCommand("mutate acem sshot"@ID);
                    }
                   }
                  }
              return;
            }
            break;
     }
     Super.Notify(C,E);
}


defaultproperties
{
}
