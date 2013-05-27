/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEManager_MainWindow
//
//- The main class that gets spawned through WRI
//- Contains various pages
//  => SShot
//  => BanManager
//  => About
//  => ACE settings of client( function viewsettings in IACECheck ) -> TODO
//    ==> Include ACE File definition version in the page ( Check IACEActor )
//  => Configuring ACE settings by GUI ( for admin only )-> TODO
//    ==> Adding option to setdemostatus for all players
//    ==> Adding option to scale crosshair for all players
//- Adminlogin in this window -> Done
//=============================================================================
class ACEManager_MainWindow extends UWindowDialogClientWindow;


var UWindowEditControl ACEM_AdminPassword;
var UWindowSmallButton  ACEM_AdminLoginButton;
var UWindowPageControl Pages;
var ACEM_BanManager ACEBan;
var ACEM_SShot ACEShot;
var UWindowComboControl DefVer;
var string FileDefVer;
//var UWindowPageControlPage UPCSS,AS;
var bool bBanAdmin;

function Created()
{
     local UWindowPageControlPage PageControl;

     Super.Created();

     if( !(AdminCheck() || bBanAdmin) )
     {
      ACEM_AdminLoginButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 150.0,2.0,40.0,35.0));
      ACEM_AdminLoginButton.SetText("Login");

      ACEM_AdminPassword = UWindowEditControl(CreateControl(Class'UWindowEditControl',10.0,2.0,130.0,35.0));
	  ACEM_AdminPassword.SetText("ACE Pass");
	  ACEM_AdminPassword.SetValue("");
	  ACEM_AdminPassword.SetFont(F_Normal);
	 //CrosshairScale.SetNumericOnly(True);
	  ACEM_AdminPassword.SetMaxLength(50);
	  ACEM_AdminPassword.SetDelayedNotify(True);
     }

     Pages = UWindowPageControl(CreateWindow(class'UWindowPageControl', 0, 25, 550, 500));
     Pages.SetMultiLine(True);

     Pages.AddPage("Configure ACE ", class'ACEM_ConfigACE');
     PageControl = Pages.AddPage("ACE SShot ", class'ACEM_SShot' );
     ACEShot = ACEM_SShot( PageControl.Page );

     if( AdminCheck() || bBanAdmin )
     {
      PageControl = Pages.AddPage("ACEBan", class'ACEM_BanManager');
      ACEBan = ACEM_BanManager(PageControl.Page);
     }
     Pages.AddPage("About ", class'ACEM_About');

}

function WriteText(canvas C, string text, int q)
{
     local float W, H;

     TextSize(C, text, W, H);
     if( (AdminCheck() || bBanAdmin) )
      ClipText(C, 10, q, text, false);
     else
      ClipText(C, 310, q, text, false);
}


function Paint(Canvas C, float X, float Y)
{
     local string text;

     Super.Paint(C,X,Y);

     C.Font = Root.Fonts[F_Normal];
     text = "Definition Version = "$FileDefVer;
     c.drawcolor.R=0;
     c.drawcolor.G=0;
     c.drawcolor.B=0;

     WriteText(C, text, 6);

}

function AddBannedPlayerInfo(String PlayerName, int ID)
{
     local ACEM_BannedPlayerListItem I;
     I = ACEM_BannedPlayerListItem(ACEBan.BannedPlayerList.Items.Append(class'ACEM_BannedPlayerListItem'));
     I.PlayerName = ID@")"@PlayerName;
     I.PlayerID = ID;
}


function Notify(UWindowDialogControl C, byte E)
{
	 local int i;

	 switch(E)
     {
      case DE_Click:
			switch(C)
            {
			  case ACEM_AdminLoginButton:
                   GetPlayerOwner().ConsoleCommand("mutate acem adminlogin"@ACEM_AdminPassword.GetValue());
                   return;
            }
			break;
     }
	 Super.Notify(C,E);
}

function bool AdminCheck(optional bool Warn)
{
	local Pawn aPawn;

	if (GetPlayerOwner() != None && (GetPlayerOwner().bAdmin || GetPlayerOwner().PlayerReplicationInfo.bAdmin)) {
		return True;
	} else {
		if (Warn) {
			MessageBox("ACEManager","You are not logged as admin!",MB_OK,MR_NONE);
		}
		return False;
	}
}


/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2010-2011 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/

