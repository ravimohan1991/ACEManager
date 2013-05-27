/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_InfoWRI
//
//- The child class of WRI responsible for popping of ACEManager_MainWindow
//- The ACE info is replicated here
//=============================================================================

class ACEM_InfoWRI expands WRI;

struct PlayerACEInfo
{
  var string PlayerName, PlayerIP, PlayerHWID, PlayerMACHash, UTDCMacHash, PlayerRealIP,
  PlayerUTVersion, PlayerOSString, PlayerBanReason,  UTCommandLine, CPUIdentifer, CPUMeasuredSpeed
  ,CPUReportedSpeed, NICName, ACEMD5, IpInfo;
  var bool IsOccupied, bTunnel, bWine;
};
var PlayerACEInfo PAI;
var ACEM_Mut Mut;

replication
{
   // Variables the server should send to the client.
     reliable if( Role==ROLE_Authority )
     PAI;

}

simulated function bool SetupWindow ()
{
     settimer(1,false);
     Super.SetupWindow();
}


simulated function timer()
{

    local ACEM_PlayerInfoListItem I;
    local UWindowList Item;

     I = ACEM_PlayerInfoListItem(ACE_InfoWindow(TheWindow.FirstChildWindow).PlayerinfoList.Items.Append(class'ACEM_PlayerInfoListItem'));
     I.PlayerName       = PAI.PlayerName;
     I.PlayerIP         = PAI.PlayerIP;
     I.PlayerUTVersion  = PAI.PlayerUTVersion;
     I.PlayerOSString   = PAI.PlayerOSString;
     I.bWine            = PAI.bWine;
     I.PlayerMACHash    = PAI.PlayerMACHash;
     I.PlayerHWID       = PAI.PlayerHWID;
     I.bTunnel          = PAI.bTunnel;
     if( PAI.PlayerRealIP != "" )
      I.PlayerRealIP     = PAI.PlayerRealIP;
     else
      I.PlayerRealIP     = PAI.PlayerIP;
     I.UTCommandLine    = PAI.UTCommandLine;
     I.UTDCMacHash      = PAI.UTDCMacHash;
     I.ACEMD5           = PAI.ACEMD5;
     I.CPUIdentifer     = PAI.CPUIdentifer;
     I.CPUMeasuredSpeed = PAI.CPUMeasuredSpeed;
     I.CPUReportedSpeed = PAI.CPUReportedSpeed;
     I.NICName          = PAI.NICName;
     I.IpInfo           = PAI.IpInfo;

}



/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2010-2011 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
defaultproperties
{
    WindowClass=Class'ACEM_InfoWindowFrame'
    WinLeft=50
    WinTop=30
    WinWidth=550
    WinHeight=500
}
