/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_BannedPlayerListBox
//
//- Ripped from BDB's mapvote mutator
//- For banned player list
//=============================================================================

class ACEM_BannedPlayerListItem expands UWindowListBoxItem;

var string PlayerName;
var int PlayerID;

function int Compare(UWindowList T, UWindowList B)
{
     if(Caps(ACEM_BannedPlayerListItem(T).PlayerName) < Caps(ACEM_BannedPlayerListItem(B).PlayerName))
          return -1;
     return 1;
}


defaultproperties
{
}
