/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_WRI
//
//- The child class of WRI responsible for popping of ACEManager_MainWindow
//- The banned playerlist is replicated here
//=============================================================================

class ACEM_WRI expands WRI;

var string BannedPlayerName[200];
var ACEM_Mut Mut;
var string DefFileVer;
var bool bAllowEveryOnetoSnap, bBanAdmin;
var string CountryFlagsPackage;
var ACEM_BanManager ACEBan;

replication
{
     // Variables the server should send to the client.
     reliable if( Role==ROLE_Authority )
     BannedPlayerName,bAllowEveryOnetoSnap,DefFileVer,CountryFlagsPackage,bBanAdmin;

     //function server calls on client
     reliable if( Role==ROLE_Authority )
     UpdateCurrPlayers,UpdateBannedPlayers;
}

simulated function bool SetupWindow ()
{
     settimer(1,false);
     class'ACEManager_MainWindow'.default.FileDefVer = DefFileVer;
     class'ACEM_SShot'.default.bAllowEveryOnetoSnap = bAllowEveryOnetoSnap;
     class'ACEM_SShot'.default.bBanAdmin = bBanAdmin;
     class'ACEM_PlayerInfoListBox'.default.CountryFlagsPackage = CountryFlagsPackage;
     class'ACEManager_MainWindow'.default.bBanAdmin = bBanAdmin;
     Super.SetupWindow();
}

simulated function UpdateCurrPlayers()
{
     local UWindowWindow MyWindow;

     MyWindow = UWindowFramedWindow(TheWindow).ClientArea;

     if( MyWindow == none )
      return;

     ACEManager_MainWindow(MyWindow).ACEShot.CurrPlayerList.bChanged = true;
     ACEBan = ACEManager_MainWindow(MyWindow).ACEBan;
     if( ACEBan != none )
      ACEBan.CurrPlayerList.bChanged = true;
}

simulated function UpdateBannedPlayers()
{
    settimer(1,false);
}

simulated function timer()
{
     local int i;
     local UWindowWindow MyWindow;

     MyWindow = UWindowFramedWindow(TheWindow).ClientArea;

     if( MyWindow == none )
      return;

     ACEManager_MainWindow(MyWindow).ACEBan.BannedPlayerList.Items.Clear();
     for(i=0; i<200; i++)
     {
      if( BannedPlayerName[i] != "" )
       ACEManager_MainWindow(MyWindow).AddBannedPlayerInfo( BannedPlayerName[i], i);
     }
}


defaultproperties
{
    WindowClass=Class'ACEM_Window'
    WinLeft=50
    WinTop=30
    WinWidth=550
    WinHeight=500
}
