/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_Mut
//
//- Spawned by the ACEM_Actor
//- Checks Bans
//  => Check by HWID     - Done
//  => Check by MAC Hash - Done ( Testing needed - Done )
//  => Update the ban entries - Done( Testing needed )
//  => Iptocountry -Done( Testing needed )
//- Create Bans
//  => Store all the info of Check in ini - Done ( Some more info- Done )
//  => Unban by GUI - Done
//- Showing Info of Curr and Banned players in GUI -Done(Testing Needed - Done)
//- Displaying the actions of the admin -TODO
//- AnyShot -Done
//- Update playerlist -( ban list done ) unbanlist Done
//- Automatic banning cheaters -TODO ( Anthrax said it cant be done )
//- Improving GUI- Done
//- Quick Check- Done ( me no more replication noob yay! )
//=============================================================================

class ACEM_Mut extends Mutator config(ACEManager_BanList);

/*
*******************************************************************************
*   Structure of banned players.Stored in ini
*******************************************************************************
*/
struct BannedPlayerInfo
{
  var string PlayerName, PlayerIP, PlayerHWID, PlayerMACHash, PlayerUTDCHash, PlayerRealIP,
  PlayerUTVersion, PlayerOSString, PlayerBanReason,  UTCommandLine, CPUIdentifer, CPUMeasuredSpeed
  ,CPUReportedSpeed, NICName, ACEMD5, IpInfo;
  var bool IsOccupied, bTunnel, bWine;
};
var() config BannedPlayerInfo BPI[300];

/*
*******************************************************************************
*   Server variables
*******************************************************************************
*/

//Structure of current players' IPData
struct IPData
{
   var bool bCantFindData, bIsPlayer;
   var string IPInfo;
};
//Structure of Admin Info
struct AdminType
{
   var bool bACEAdmin, bNexgenBanOperator;
};
var IPData IPD[100];
var AdminType AT[100];
var string Version;
var string ACEPass;
var int CurrentID;
var bool bDebug;
var int CheckBanType;
var ACEM_EventActor ACEMA;
var Actor IpToCountry;
var bool bAllowEveryOnetoSnap, bNexgenRunning, bIsTimerRunning;
var string CountryFlagsPackage;

function PostBeginPlay()
{
     local string ServerActors,ServerPackages;
     local bool bIpToCountryEnabled;

     ServerActors = caps(consoleCommand("get Engine.GameEngine ServerActors"));
     ServerPackages = caps(consoleCommand("get Engine.GameEngine ServerPackages"));

     if( InStr(Caps( ServerActors ), "ACEACTOR")==-1 || InStr(Caps( ServerPackages ), "IACEV")==-1 )
	 {
	  Log("[ACEM"$Version$"]:-- Ace is not installed in this server.",'ACEManager');
	  Log("[ACEM"$Version$"]:-- ACEManager will now destroy itself!!",'ACEManager');
      //Destroy(); not a good idea to destroy like this
	  return;
	 }
     else
     {
      ACEMA = Level.Game.Spawn( class'ACEM_EventActor' );
      ACEMA.Mut = self;
     }
     SaveConfig();// Create ini if not present

     ACEMA.ACEPadLog("","-","+",80,true);
     ACEMA.ACEPadLog("ACEManager"@Version," ","|",80,true);
     ACEMA.ACEPadLog("(c) The_Cowboy","","|",80,true);
     ACEMA.ACEPadLog("","-","+",80,true);
     ACEMA.ACEPadLog("++ Detected Anti Cheat Engine "$ACEMA.ACEVersion," ","|",80);

     if(BindIpToCountry())
     {
      ACEMA.ACEPadLog("++ IpToCountry bounded successfully."," ","|",80);
      SetTimer( 0.5, true );
      bIsTimerRunning = true;
      bIpToCountryEnabled = true;
     }
     else
     {
      ACEMA.ACEPadLog("-- Failed to bind IpToCountry."," ","|",80);
      ACEMA.ACEPadLog("-- ACEManager will not support IpToCountry features!!"," ","|",80);
      bIpToCountryEnabled = false;
     }
     if( bIpToCountryEnabled )
     {
      if( !(InStr(ServerPackages, caps(ACEMA.CountryFlagsPackage))>0) )
       ACEMA.ACEPadLog("-- CountryFlagsPackage ["$ACEMA.CountryFlagsPackage$"] is not added in ServerPackages."," ","|",80);
      else
       ACEMA.ACEPadLog("++ CountryFlagsPackage is "$ACEMA.CountryFlagsPackage$".utx ."," ","|",80);
     }
     ACEMA.ACEPadLog("++ Check ban type is "$ACEMA.CheckBanType$"."," ","|",80);
     if( (InStr(ServerActors, "NEXGENACTOR")>0) )
     {
      ACEMA.ACEPadLog("++ Nexgen is running.ACEManager will now support Nexgen Ban operators."," ","|",80);
      bNexgenRunning = true;
     }
     else
      bNexgenRunning = false;

     ACEMA.ACEPadLog("","-","+",80,true);
     super.PostBeginPlay();
}

/*
*******************************************************************************
*  As players keep coming bIsplayer is set to true
*  and then this Timer will resolve their IPData
*******************************************************************************
*/

function Timer()
{
     local int i;
     local string data;
     local IACECheck Check;
     local bool bShouldTimerRun;

     bShouldTimerRun = false;
     for(i = 0;i < 100;i++)
     {
      if( IPD[i].bIsPlayer )
       if( !IPD[i].bCantFindData )
        if( IPD[i].IPInfo == "")
        {
         bShouldTimerRun = true;
         Check = FindCheckByID( i );
         if( Check.RealIP == "" )
          data = GetIpInfo( Check.PlayerIP );
         else
          data = GetIpInfo( Check.RealIP );
         if(bDebug)
          Log("[ACEM"$Version$"]:Inside timer.Player ip is "$Check.PlayerIP );
         if(data == "!Disabled") /* after this return, iptocountry won't resolve anything anyway */
          IPD[i].bCantFindData = true;
         else if(Left(data, 1) != "!") /* good response */
           {
           IPD[i].IPInfo = data;  /* store in our array */
           if(bDebug)
           Log("[ACEM"$Version$"]:IpData found "$data );
           }
         }
      }
      if(bDebug)
      Log("[ACEM"$Version$"] Timer running" );
      if( !bShouldTimerRun )
      {
       SetTimer(0.0,false);   // switch off the timer because all the ID's have been resolved :D
       bIsTimerRunning = false;
      }
}


/*
*******************************************************************************
*  Tracks Player Join.
*  Its a really a cute method.I mean without using SpawnNotify() and all.
*  (courtesy Anthrax)
*******************************************************************************
*/

function Tick( float DeltaTime )
{
    local Pawn P;

    while ( Level.Game.CurrentID > CurrentID )
    {
        for ( P = Level.PawnList; P != None; P = P.NextPawn )
        {
            if ( P.IsA('PlayerPawn') && P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.PlayerID == CurrentID )
            {
                SpawnLogin( P );
                break;
            }
        }
        CurrentID++;
    }
}


/*
*******************************************************************************
*  for iptocountry support.
*  (courtesy Rush)
*******************************************************************************
*/

function bool BindIpToCountry()
{
	 local Actor A;

     foreach AllActors(class'Actor', A, 'IpToCountry')
	 {
      IpToCountry=A;
      return true;
     }
     return false;
}

function string GetIpInfo(string IP)
{
	 if(IpToCountry != None)
		return IpToCountry.GetItemName(IP);
}


/*
*******************************************************************************
*  - spawns ACEM_Login instance.
*  - stores self refrence and ID of the player.
*******************************************************************************
*/

function SpawnLogin( Pawn P )
{
     local int i;
     local ACEM_Login AL;

     i = P.PlayerReplicationInfo.PlayerID;
     AL = Spawn( class'ACEM_Login', P );
     if( AL != none )
     {
      AL.Mut = self;
      AL.ID = i;
      if(bdebug)
       Log("[ACEM"$Version$"]:["$P.PlayerReplicationInfo.PlayerName$"]: Success! Spawned ACEM_Login for the Pawn");
     }
     else
      Log("[ACEM"$Version$"]:["$P.PlayerReplicationInfo.PlayerName$"]: Couldnt spawn ACEM_Login for the Pawn");
}


/*
*******************************************************************************
*    So the server version of ACEM_Login has requested to perform ban scan with
*    the given parameters through checkitout() function.The parameters have been
*    replicated from client and are, thus, not to be trusted completely.
*******************************************************************************
*/

function QuickCheck( int ID, string HWID, string MACHash, string UTDCHash )
{
     local Pawn P;
     local int i;
     local string PlayerName;

     P = FindPawnByID( ID );
     PlayerName = P.PlayerReplicationInfo.PlayerName;
     Log("[ACEM"$Version$"]:["$PlayerName$"]: Initiating Quick Check by method-"@ACEMA.CheckBanType$"...");

     if( HWID == "" && MACHash == "" && UTDCHash == "" )
     {
      Log("[ACEM"$Version$"]:["$PlayerName$"]: Server received no ACEM Data for this player");
      return;
     }

     switch( ACEMA.CheckBanType )
      {
          case 0:
          for(i=0;i<300;i++)
          {
           if( BPI[i].IsOccupied )
            {
             if( HWID == BPI[i].PlayerHWID )
              Kick( ID, i, true );
            }
          }
          break;

          case 1:
          for(i=0;i<300;i++)
          {
           if( BPI[i].IsOccupied )
            {
             if( HWID == BPI[i].PlayerHWID || MACHash == BPI[i].PlayerMACHash )
              Kick( ID, i, true );
            }
          }
          break;

          case 2:
          for(i=0;i<300;i++)
          {
           if( BPI[i].IsOccupied )
           {
            if( HWID == BPI[i].PlayerHWID || MACHash == BPI[i].PlayerMACHash || UTDCHash == BPI[i].PlayerUTDCHash )
             Kick( ID, i, true );
           }
          }
          break;

          case 3:
          for(i=0;i<300;i++)
          {
           if( BPI[i].IsOccupied )
           {
            if( HWID == BPI[i].PlayerHWID || UTDCHash == BPI[i].PlayerUTDCHash )
            Kick( ID, i, true );
           }
          }
          break;

          case 4:
          for(i=0;i<300;i++)
          {
           if( BPI[i].IsOccupied )
           {
            if( MACHash == BPI[i].PlayerMACHash || UTDCHash == BPI[i].PlayerUTDCHash )
            Kick( ID, i, true );
           }
          }
          break;
     }
     Log("[ACEM"$Version$"]:["$PlayerName$"]: Quick check looks OK.Waiting for ACE to spawn its actors...");
}


/*
*******************************************************************************
*    - Called when
*            - a banned player enters the server and QuickCheck recognises it
*            - banned player recognised by routine check
*            - admin is pissed off at someone
*    - Kicks are no more dependent on ACE.
*******************************************************************************
*/

function Kick( int ID, optional int BanID, optional bool bQuickKick, optional bool bKickOnly )
{
     local Pawn P;
     local string PlayerName;
     local ACEM_Login A;

     P = FindPawnByID( ID );
     PlayerName = P.PlayerReplicationInfo.PlayerName;

     foreach AllActors(class'ACEM_Login', A)
      if( A.ID == ID )
       break;

     if( A == none && bDebug )
       Log("[ACEM"$Version$"]:["$PlayerName$"]: ACEM_Login instance doesnt exist for the player");


     if( bKickOnly )
     {
      Log("[ACEM"$Version$"]["$PlayerName$"]: Player has been kicked ");
      P.ClientMessage("[ACEM"$Version$"] : +-------------------------------------------------------+");
      P.ClientMessage("[ACEM"$Version$"] : |You have been kicked by the Admin.");
      P.ClientMessage("[ACEM"$Version$"] : +-------------------------------------------------------+");
     }
     else
     {
      P.ClientMessage("[ACEM"$Version$"] : +------------------------------------------------+");
	  P.ClientMessage("[ACEM"$Version$"] : |You have been banned from this server.");
	  P.ClientMessage("[ACEM"$Version$"] : |Your ban ID is ["$BanID$"].");
	  P.ClientMessage("[ACEM"$Version$"] : |Contact the Admin.");
	  P.ClientMessage("[ACEM"$Version$"] : |Email - "$Level.Game.GameReplicationInfo.AdminEmail);
      P.ClientMessage("[ACEM"$Version$"] : +------------------------------------------------+");
     }

     A.PlayerOpenConsole();
     A.Destroy();
     P.Destroy();

     if( bQuickKick )
     {
      Log("[ACEM"$Version$"]:["$PlayerName$"]: Quick check found player in Banned Players Database!!");
      Log("[ACEM"$Version$"]:["$PlayerName$"]: Player has been denied access to the server.");
     }
     else if( bKickOnly)
     {
      Log("[ACEM"$Version$"]:["$PlayerName$"]: Player kicked by the Admin.");
     }
     else
     {
      Log("[ACEM"$Version$"]:["$PlayerName$"]: Player found in Banned Players Database.");
      Log("[ACEM"$Version$"]:["$PlayerName$"]: Player has been denied access to the server.");
     }
}

/*
*******************************************************************************
*     -Called when ACE classes have been successfully spawned
*     -Adds Players to IP resolving array
*     -Finds nexgen Interface and updates players info in ACEMWRI
*
*     Example for FindNexgenClientByID
*     local NexgenClient NC;
*
*     NC = FindNexgenClientByID( Check.PlayerID );
*     if( NC != none )
*     Log("[ACEM"$Version$"]: Found NexgenClient "$NC.playerID );
*******************************************************************************
*/

function PlayerACELogin( IACECheck Check )
{
     local NexgenClient NC;
     local ACEM_WRI A;

     IPD[Check.PlayerID].bIsPlayer = true; //newly joined player is logged here so that his/her IPInfo is resolved
     if(bDebug)
     Log("[ACEM"$Version$"]:"$ Check.PlayerName $" has been added to IpToCountry Player ID list" );

     if( !bIsTimerRunning )    // no use if timer is already running
     {
      SetTimer( 0.5, true );  // lets resolve their IP
      bIsTimerRunning = true;
     }

     if( bNexgenRunning )
     {
      NC = FindNexgenClientByID( Check.PlayerID );
      if( NC != none )
       if( NC.hasRight( NC.R_BanOperator ) )
        {
         AT[ Check.PlayerID ].bNexgenBanOperator = true ;
         if(bDebug)
         Log("[ACEM"$Version$"]:"$ Check.PlayerName $" is NexGen Ban operator" );
        }
     }

     UpdateEntries( Check.PlayerID, Check.xxGetToken(Check.HWHash, ":", 1), Check.UTDCMacHash, Check.MACHash );

     if( !CheckForBan( Check ) );
      UpdateCurrPlayers();
}


function UpdateEntries( int PlayerID, string HWID, string UTDCHash, string MACHash )
{
      local ACEM_Login A;

      foreach AllActors(class'ACEM_Login', A)
       if( A.ID == PlayerID )
        break;

      if( A == none )
      {
       if(bdebug)
       Log("[ACEM"$Version$"]:["$FindPawnByID(PlayerID).PlayerReplicationInfo.PlayerName$"]: ACEM_Login instance doesnt exist for the player");
       return;
      }
      A.Update( HWID, UTDCHash, MACHash );
}


/*
*******************************************************************************
*  $PARAM Check -   The ACE class spawned for player
*                   ( Contains info obtained by ACE )
*                   MatchType (TODO)
*                             0 when only HWID is matched
*                             1 when only ACEMachash is matched
*                             2 when only UTDCMachash is matched
*                             3 when HWID or ACEMachash are matched
*                             4 when HWID or UTDCMachash are matched
*                             5 when UTDCMachash or ACEMachash are matched
*                             6 when HWID or UTDCMachash or UTDCMachash are
*                                matched
*
*******************************************************************************
*/

function bool CheckForBan( IACECheck Check )
{
     local int i;//,MatchType;

     Log("[ACEM"$Version$"]:["$Check.PlayerName$"]: Checking Bans by method-"@ACEMA.CheckBanType);
     switch( ACEMA.CheckBanType )
      {
          case 0:
          for(i=0;i<300;i++)
          {
           if( BPI[i].IsOccupied )
            {
             if( Check.xxGetToken(Check.HWHash, ":", 1) == BPI[i].PlayerHWID )
              {
              UpdateBan( Check , i );
              Kick( Check.PlayerID, i );
              return true;
              }
            }
          }
          break;

          case 1:
          for(i=0;i<300;i++)
          {
           if( BPI[i].IsOccupied )
            {
             if( Check.xxGetToken(Check.HWHash, ":", 1) == BPI[i].PlayerHWID || Check.MACHash == BPI[i].PlayerMACHash )
             {
             UpdateBan( Check , i );
             Kick( Check.PlayerID, i );
             return true;
             }
            }
          }
          break;

          case 2:
          for(i=0;i<300;i++)
          {
           if( BPI[i].IsOccupied )
           {
            if( Check.xxGetToken(Check.HWHash, ":", 1) == BPI[i].PlayerHWID || Check.MACHash == BPI[i].PlayerMACHash || Check.UTDCMacHash == BPI[i].PlayerUTDCHash )
            {
            UpdateBan( Check , i );
            Kick( Check.PlayerID, i );
            return true;
            }
           }
          }
          break;

          case 3:
          for(i=0;i<300;i++)
          {
           if( BPI[i].IsOccupied )
           {
            if( Check.xxGetToken(Check.HWHash, ":", 1) == BPI[i].PlayerHWID || Check.UTDCMacHash == BPI[i].PlayerUTDCHash )
            {
             UpdateBan( Check , i );
             Kick( Check.PlayerID, i );
             return true;
            }
           }
          }
          break;

          case 4:
          for(i=0;i<300;i++)
          {
           if( BPI[i].IsOccupied )
           {
            if( Check.MACHash == BPI[i].PlayerMACHash || Check.UTDCMacHash == BPI[i].PlayerUTDCHash )
            {
            UpdateBan( Check , i );
            Kick( Check.PlayerID, i );
            return true;
            }
           }
          }
          break;
     }

     Log("[ACEM"$Version$"]:["$Check.PlayerName$"]: ALL CLEAR.");
     return false;
}
/*
function ProcessBan( IACECheck Check, int i )
{
     Check.PlayerMessage("+-----------------------------------------------------+");
     Check.PlayerMessage("|xxxxxxxx ACCESS DENIED!! xxxxxxxx ");
     Check.PlayerMessage("|You have been banned from this server.");
     Check.PlayerMessage("|Your ban ID is ["$i$"].");
     Check.PlayerMessage("|Contact the Admin.");
     Check.PlayerMessage("|Email - "$Level.Game.GameReplicationInfo.AdminEmail);
     Check.PlayerMessage("|(This ban is generated by ACEManager "$Version$".)");
     Check.PlayerMessage("+-----------------------------------------------------+");
     Log("[ACEM"$Version$"]:["$Check.PlayerName$"]: Player found in Banned Players Database.");
     Log("[ACEM"$Version$"]:["$Check.PlayerName$"]: Player has been denied access to the server.");
     Check.PlayerKick( true );
}
*/
function UpdateBan( IACECheck Check ,int i )
{
     BPI[i].bTunnel         = Check.bTunnel;
     BPI[i].bWine           = Check.bWine;
     if( BPI[i].bWine )
      BPI[i].PlayerHWID      ="N/A";
     else
      BPI[i].PlayerHWID      = Check.xxGetToken(Check.HWHash, ":", 1);
     BPI[i].PlayerMACHash   = Check.MACHash ;
     BPI[i].PlayerUTDCHash  = Check.UTDCMacHash;
     BPI[i].PlayerIP        = Check.PlayerIP;
     BPI[i].PlayerName      = Check.PlayerName;
     BPI[i].PlayerOSString  = Check.OSString;
     if( BPI[i].bTunnel )
      BPI[i].PlayerRealIP    = Check.RealIP;
     else
      BPI[i].PlayerRealIP    = "";
     BPI[i].CPUIdentifer     = Check.CPUIdentifier;
     BPI[i].CPUMeasuredSpeed = Check.CPUMeasuredSpeed;
     BPI[i].CPUReportedSpeed = Check.CPUReportedSpeed;
     BPI[i].NICName          = Check.NICName;
    // BPI[i].IpInfo           = IPD[Check.PlayerID].IPInfo; Hopefullyy he/she wont change the country :P

     SaveConfig();
}

/*
*******************************************************************************
*
*   The GUI buttons send mutate commands which are intercepted by this
*   function
*
*******************************************************************************
*/

function Mutate(string MutateString, PlayerPawn Sender)
{
     local int PlayerID, SenderID;
     local ACEM_WRI A;
     local IACECheck Check;
     local int i;

     if( left(Caps(MutateString),3) == "ACE" )
	 {
        if(Mid(Caps(MutateString),4,6) == "MANAGE")
        {
         if(bDebug)
          Log("[ACEM"$Version$"]:["$Sender.PlayerReplicationInfo.PlayerName$"]: Mutate ACE Manage command intercepted" );
         OpenACEMGUI( Sender );
        }
     }

     SenderID = Sender.PlayerReplicationInfo.PlayerID;

     if( left(Caps(MutateString),4) == "ACEM" )
     {
        if( bAllowEveryOnetoSnap || AT[SenderID].bNexgenBanOperator || AT[SenderID].bACEAdmin )
        {
         if(Mid(Caps(MutateString),5,5) == "SSHOT")
          {
           if(bDebug)
            Log("[ACEM"$Version$"]:["$Sender.PlayerReplicationInfo.PlayerName$"]: Mutate ACEM ANYSHOT command for player ID "$PlayerID$" intercepted" );
           PlayerID = int(Mid((MutateString),11));
           FindCheckByID( PlayerID ).CreateScreenshot( Sender );
          }
        }

        if( ( Sender.bAdmin || AT[SenderID].bNexgenBanOperator || AT[SenderID].bACEAdmin ) )
        {
          if(Mid(Caps(MutateString),5,5) == "BANID")
          {
           if(bDebug)
            Log("[ACEM"$Version$"]:["$Sender.PlayerReplicationInfo.PlayerName$"]: Mutate ACEM BANID command for player ID "$PlayerID$" intercepted" );
           PlayerID = int(Mid((MutateString),11));
           Check = FindCheckByID( PlayerID );
           Banplayer( Check );
           UpdateBanList();
           UpdateCurrPlayers();
          }

         if(Mid(Caps(MutateString),5,7) == "UNBANID")
          {
           if(bDebug)
            Log("[ACEM"$Version$"]:["$Sender.PlayerReplicationInfo.PlayerName$"]: Mutate ACEM UNBANIID command for player ID "$PlayerID$" intercepted" );
           PlayerID = int(Mid((MutateString),13));
           UnbanPlayer( PlayerID );
           UpdateBanList();
          }

         if(Mid(Caps(MutateString),5,6) == "KICKID")
          {
           if(bDebug)
            Log("[ACEM"$Version$"]:["$Sender.PlayerReplicationInfo.PlayerName$"]: Mutate ACEM KICKID command for player ID "$PlayerID$" intercepted" );
           PlayerID = int(Mid((MutateString),12));
           Kick( PlayerID,,,true );
           UpdateCurrPlayers();
          }

         if(Mid(Caps(MutateString),5,13) == "SHOWBANINFOID")
          {
           if(bDebug)
            Log("[ACEM"$Version$"]:["$Sender.PlayerReplicationInfo.PlayerName$"]: Mutate ACEM SHOWBANINFOID command for player ID "$PlayerID$" intercepted" );
           PlayerID = int(Mid((MutateString),19));
           ShowBanInfo(  Sender, PlayerID );
          }

          if(Mid(Caps(MutateString),5,14) == "SHOWCURRINFOID")
          {
           if(bDebug)
            Log("[ACEM"$Version$"]:["$Sender.PlayerReplicationInfo.PlayerName$"]: Mutate ACEM SHOWCURRINFO command for player ID "$PlayerID$" intercepted" );
           PlayerID = int(Mid((MutateString),20));
           ShowCurrInfo( PlayerID, Sender );
          }

          if(Mid(Caps(MutateString),5,9) == "MANUALBAN")
           {
            ManualBan( Sender );
           }
        }

        if(Mid(Caps(MutateString),5,10) == "ADMINLOGIN")
        {
         if( (Mid((MutateString),16)) == ACEPass && ACEPass != "" )
         {
          AT[ SenderID ].bACEAdmin = true;
          Sender.ClientMessage(" You have successfully logged in as ACEManager admin ");

          foreach AllActors(class'ACEM_WRI',A) // check all existing WRIs
          {
           if(Sender == A.Owner)
            break;            // got ya :D
          }

          if( A != none )
          {
           A.CloseWindow();  // ok we have made you the admin, now we have to tell your computer.So close the original window and reload new one
           A.DestroyWRI();
           OpenACEMGUI( Sender );
          }
         }
         else
          Sender.ClientMessage(" Wrong password ");
        }
     }

     if ( NextMutator != None )
		NextMutator.Mutate(MutateString, Sender);
}

/*
*******************************************************************************
*
*  These function are called on client which have opened ACEManager console and
*  updates the player's list.
*
*******************************************************************************
*/

function UpdateBanList()
{
     local ACEM_WRI A;
     local int i;

     foreach AllActors(class'ACEM_WRI',A) // check all existing WRIs
     {
      for(i=0;i<200;i++)
      {
       if( BPI[i].IsOccupied )
        A.BannedPlayerName[i] = BPI[i].PlayerName;
       else
        A.BannedPlayerName[i] = "";
      }
      A.UpdateBannedPlayers();
     }
     if(bDebug)
     Log("[ACEM"$Version$"]:Ban List Updated" );
}

function UpdateCurrPlayers()
{
     local ACEM_WRI A;

     foreach AllActors(class'ACEM_WRI',A) // check all existing WRIs
      A.UpdateCurrPlayers();
}


function ManualBan( PlayerPawn Sender )
{
}


/*
*******************************************************************************
*
*   Opens ACEManager Graphical User Interface for the sender
*   Responsible for ACEM_MainWindow
*   Sends Banned player info by replication through class ACEM_WRI
*
*******************************************************************************
*/

function OpenACEMGUI( PlayerPawn Sender )
{
     local ACEM_WRI A,AMWRI;
     local IACEActor IA;
     local int i,SenderID;
     local string DefFileVer;

     foreach AllActors(class'ACEM_WRI',A) // check all existing WRIs
     {
      if(Sender == A.Owner)
         return;            // dont open if already open
     }

     AMWRI = Spawn(class'ACEM_WRI',Sender,,Sender.Location);

     if(AMWRI==None)
     {
      Log("[ACEM"$Version$"] PostLogin :: Fail:: Could not spawn WRI");
      return;
     }

     if(bDebug)
     Log("[ACEM"$Version$"]:["$Sender.PlayerReplicationInfo.PlayerName$"]: Successfully spawned class ACEM_WRI" );

     AMWRI.Mut = self;

     foreach AllActors(class'IACEActor',IA)
     {
      DefFileVer = IA.GetDefinitionFileVersion();
      break;
     }

     AMWRI.DefFileVer = DefFileVer;
     AMWRI.bAllowEveryOnetoSnap = bAllowEveryOnetoSnap;
     AMWRI.CountryFlagsPackage = CountryFlagsPackage;

     SenderID = Sender.PlayerReplicationInfo.PlayerID;
     if( AT[SenderID].bNexgenBanOperator || AT[SenderID].bACEAdmin )
      AMWRI.bBanAdmin = true;

     if( AT[SenderID].bNexgenBanOperator || AT[SenderID].bACEAdmin || Sender.bAdmin )
     {
      for(i=0;i<200;i++)
      {
       if( BPI[i].IsOccupied )
       {
        AMWRI.BannedPlayerName[i] = BPI[i].PlayerName;
       }
      }
     }
     if(bDebug)
     Log("[ACEM"$Version$"]:["$Sender.PlayerReplicationInfo.PlayerName$"]: Player's Info sent.Function OpenACEMGUI()" );

}

/*
*******************************************************************************
*
*   ShowCurrInfo
*   Pops a new window with ACE information of the player
*
*******************************************************************************
*/

function ShowCurrInfo( int PlayerID, PlayerPawn Sender )
{
     local ACEM_InfoWRI AMInfoWRI;
     local IACECheck A;

     AMInfoWRI = Spawn(class'ACEM_InfoWRI',Sender,,Sender.Location);

     if(AMInfoWRI==None)
     {
      Log("[ACEM"$Version$"] PostLogin :: Fail:: Could not spawn WRI");
      return;
     }

     A = FindCheckByID( PlayerID );
     if( A == none )
     {
      if(bDebug)
      Log("[ACEM"$Version$"]:["$Sender.PlayerReplicationInfo.PlayerName$"]:ACE actors not spawned for this player yet " );
      return;
     }

     if(bDebug)
     Log("[ACEM"$Version$"]:["$A.PlayerName$"]: Successfully spawned class ACEM_InfoWRI for this player's current info" );

     AMInfoWRI.Mut = self;
     AMInfoWRI.PAI.PlayerName      = A.PlayerName;
     AMInfoWRI.PAI.bTunnel         = A.bTunnel;
     AMInfoWRI.PAI.bWine           = A.bWine;
     if( A.bWine )
      AMInfoWRI.PAI.PlayerHWID     ="N/A";
     else
     AMInfoWRI.PAI.PlayerHWID      = A.xxGetToken(A.HWHash, ":", 1);
     AMInfoWRI.PAI.PlayerMACHash   = A.MACHash ;
     AMInfoWRI.PAI.PlayerIP        = A.PlayerIP;
     AMInfoWRI.PAI.PlayerOSString  = A.OSString;
     AMInfoWRI.PAI.PlayerRealIP    = A.RealIP;
     AMInfoWRI.PAI.PlayerUTVersion = A.UTVersion;
     if( A.UTCommandLine != "" )
      AMInfoWRI.PAI.UTCommandLine   = A.UTCommandLine;
     else
      AMInfoWRI.PAI.UTCommandLine   = "<NONE>";
     AMInfoWRI.PAI.CPUIdentifer    = A.CPUIdentifier;
     AMInfoWRI.PAI.CPUMeasuredSpeed= A.CPUMeasuredSpeed;
     AMInfoWRI.PAI.CPUReportedSpeed= A.CPUReportedSpeed;
     AMInfoWRI.PAI.NICName         = A.NICName;
     AMInfoWRI.PAI.UTDCMacHash     = A.UTDCMacHash;
     AMInfoWRI.PAI.ACEMD5          = A.ACEMD5;
     if( IPD[A.PlayerID].IPInfo == "" )
      AMInfoWRI.PAI.IpInfo          = "Resolving... ";
     else
      AMInfoWRI.PAI.IpInfo          = IPD[A.PlayerID].IPInfo;

}

function ShowBanInfo( PlayerPawn Sender, int PlayerID )
{
     local ACEM_InfoWRI AMInfoWRI;

     AMInfoWRI = Spawn(class'ACEM_InfoWRI',Sender,,Sender.Location);

     if(AMInfoWRI==None)
     {
      Log("[ACEM"$Version$"] PostLogin :: Fail:: Could not spawn WRI");
      return;
     }

     AMInfoWRI.Mut = self;

     if(bDebug)
     Log("[ACEM"$Version$"]:["$BPI[PlayerID].PlayerName$"]: Successfully spawned class ACEM_InfoWRI for this player's banned info" );

     AMInfoWRI.PAI.PlayerName      = BPI[PlayerId].PlayerName;
     AMInfoWRI.PAI.bTunnel         = BPI[PlayerId].bTunnel;
     AMInfoWRI.PAI.bWine           = BPI[PlayerId].bWine;
     if( BPI[PlayerId].bWine )
      AMInfoWRI.PAI.PlayerHWID     = "N/A";
     else
     AMInfoWRI.PAI.PlayerHWID      = BPI[PlayerId].PlayerHWID;
     AMInfoWRI.PAI.PlayerMACHash   = BPI[PlayerId].PlayerMACHash ;
     AMInfoWRI.PAI.PlayerIP        = BPI[PlayerId].PlayerIP;
     AMInfoWRI.PAI.PlayerOSString  = BPI[PlayerId].PlayerOSString;
     if( BPI[PlayerId].bTunnel )
      AMInfoWRI.PAI.PlayerRealIP   = BPI[PlayerId].PlayerRealIP;
     else
      AMInfoWRI.PAI.PlayerRealIP   = "";
     AMInfoWRI.PAI.PlayerUTVersion = BPI[PlayerId].PlayerUTVersion;
     if( BPI[PlayerId].UTCommandLine != "" )
      AMInfoWRI.PAI.UTCommandLine  = BPI[PlayerId].UTCommandLine;
     else
      AMInfoWRI.PAI.UTCommandLine  = "<NONE>";
     AMInfoWRI.PAI.CPUIdentifer    = BPI[PlayerId].CPUIdentifer;
     AMInfoWRI.PAI.CPUMeasuredSpeed= BPI[PlayerId].CPUMeasuredSpeed;
     AMInfoWRI.PAI.CPUReportedSpeed= BPI[PlayerId].CPUReportedSpeed;
     AMInfoWRI.PAI.NICName         = BPI[PlayerId].NICName;
     AMInfoWRI.PAI.UTDCMacHash     = BPI[PlayerId].PlayerUTDCHash;
     AMInfoWRI.PAI.ACEMD5          = BPI[PlayerId].ACEMD5;
     AMInfoWRI.PAI.IpInfo          = BPI[PlayerId].IpInfo;

}

function BanPlayer( IACECheck Check, optional string PlayerBanReason )
{
     local int i;
     local ACEM_WRI A;

     for(i = 0;i < 300;i++)
     if( !BPI[i].IsOccupied )
     {
         BPI[i].bTunnel         = Check.bTunnel;
         BPI[i].bWine           = Check.bWine;
        if( BPI[i].bWine )
         BPI[i].PlayerHWID      ="N/A";
        else
         BPI[i].PlayerHWID      = Check.xxGetToken(Check.HWHash, ":", 1);
         BPI[i].PlayerMACHash   = Check.MACHash ;
         BPI[i].PlayerUTDCHash  = Check.UTDCMacHash;
         BPI[i].PlayerIP        = Check.PlayerIP;
         BPI[i].PlayerName      = Check.PlayerName;
         BPI[i].PlayerOSString  = Check.OSString;
         BPI[i].PlayerRealIP    = Check.RealIP;
         BPI[i].CPUIdentifer     = Check.CPUIdentifier;
         BPI[i].CPUMeasuredSpeed = Check.CPUMeasuredSpeed;
         BPI[i].CPUReportedSpeed = Check.CPUReportedSpeed;
         BPI[i].NICName          = Check.NICName;
         BPI[i].PlayerUTVersion  = Check.UTVersion;
         BPI[i].UTCommandLine    = Check.UTCommandLine;
         BPI[i].IsOccupied       = true;
         BPI[i].ACEMD5           = Check.ACEMD5;
         BPI[i].IpInfo           = IPD[Check.PlayerID].IPInfo;

         Log("[ACEM"$Version$"]"$Check.PlayerName$" has been banned ");
         SaveConfig();
         Kick( Check.PlayerID, i );
         break;
     }

}

function UnbanPlayer( int i )
{
     CleanMess(i);
}

function CleanMess( int i )
{
      Log("[ACEM"$Version$"] : "$BPI[i].PlayerName$" has been unbanned ");
      BPI[i].bTunnel = false ;
      BPI[i].bWine = false;
      BPI[i].PlayerMACHash = "";
      BPI[i].PlayerUTDCHash="";
      BPI[i].PlayerHWID = "";
      BPI[i].CPUIdentifer = "";
      BPI[i].CPUMeasuredSpeed = "";
      BPI[i].CPUReportedSpeed = "";
      BPI[i].NICName = "";
      BPI[i].PlayerIP = "";
      BPI[i].PlayerName = "";
      BPI[i].PlayerOSString = "";
      BPI[i].PlayerRealIP = "";
      BPI[i].IsOccupied = false;
      BPI[i].PlayerUTVersion = "";
      BPI[i].IpInfo="";
      SaveConfig();
}
/*
function ProcessKick( int ID )
{
     local IACECheck A;

     A = FindCheckByID( ID );

     if( A != none )
     {
      Log("[ACEM"$Version$"]["$A.PlayerName$"]: Player has been kicked ");
      A.PlayerMessage("+-------------------------------------------------------+");
      A.PlayerMessage("|You have been kicked by the Admin.");
      A.PlayerMessage("+-------------------------------------------------------+");
      A.PlayerKick( true );
     }
}
*/
/*
*******************************************************************************
*
*   $PARAM ID - Player ID of the player currently playing on the server
*   returns   - IACECheck object -> When finds the IACECheck.ID = PlayerID
*               None  -> When ID is not found
*
*******************************************************************************
*/

function IACECheck FindCheckByID( int ID )
{
     local IACECheck A;

     foreach AllActors(class'IACECheck',A)
     {
      if( ID == A.PlayerID)
       {
        return A;
       }
     }
     Log("[ACEM"$Version$"] Couldnot find IACECheck for ID "$ID);
     return none;
}


/*
*******************************************************************************
*
*   $PARAM ID - Player ID of the player currently playing on the server
*   returns   - Object Pawn
*               None  -> When ID is not found
*
*******************************************************************************
*/

function Pawn FindPawnByID( int ID )
{
     local Pawn A;

     for( A = Level.PawnList; A != none; A = A.nextPawn )
     {
      if( A.PlayerReplicationInfo.PlayerID == ID )
       return A;
     }
     Log("[ACEM"$Version$"] Couldnot find Pawn for ID "$ID);
     return none;
}


/*
*******************************************************************************
*
*   $PARAM ID - Player ID of the player currently playing on the server
*   returns   - NexgenClient object -> When finds the ID == NC.player.PlayerRepl
*                                                          icationInfo.PlayerID
*               None  -> When ID is not found
*
*******************************************************************************
*/

function NexgenClient FindNexgenClientByID( int ID )
{
     local NexgenClient NC;
     local NexgenClientController NCC;

     foreach AllActors(class'NexgenClientController',NCC)
      break;

     if( NCC != none )
     {
      for ( NC = NCC.control.clientList; NC != none; NC = NC.nextClient)
       if( ID == NC.player.PlayerReplicationInfo.PlayerID )
        return NC;
     }
     else
     Log("[ACEM"$Version$"] Nexgen is not installed in this server");

     Log("[ACEM"$Version$"] Couldnot find NextClient for ID "$ID);
     return none;
}



defaultproperties
{
    version="v1.5"
}
