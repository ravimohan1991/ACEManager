/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_PlayerInfoListItem
//
//- Ripped from BDB's mapvote mutator
//- For player info list of current or banned players
//=============================================================================

class ACEM_PlayerInfoListItem expands UWindowListBoxItem;

var string PlayerName, PlayerIP, PlayerHWID, PlayerMACHash, PlayerRealIP,
  PlayerUTVersion, PlayerOSString, UTCommandLine, CPUIdentifer, CPUMeasuredSpeed
  ,CPUReportedSpeed, NICName, UTDCMacHash, ACEMD5, PlayerBanReason,IpInfo;
var bool bTunnel, bWine;

function int Compare(UWindowList T, UWindowList B)
{
     if(Caps(ACEM_BannedPlayerListItem(T).PlayerName) < Caps(ACEM_BannedPlayerListItem(B).PlayerName))
          return -1;
     return 1;
}



defaultproperties
{
}
