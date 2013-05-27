/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_Login
//
//- Spawned by the ACEM_Mut(both on Server and on Client) when the player joins.
//- Aim-to provide an interface for Server-Client communication(for ACEManager).
//- Work-collects the information from client and sends to the server by
//       calling a function.Also gets information from server relevent to
//       particular client.
//       Also comes handy in opening console of the client.
//- Since this class allows function calls from client's machine to server,
//  extra precaution is taken to ensure fair usage.
//=============================================================================

class ACEM_Login extends Info config( User );

/*
*******************************************************************************
*   Client variables
*******************************************************************************
*/
// Structure of player's info.Stored in ini
struct PlayerData
{
 var string HWID, MACHash, UTDCHash;
};
var() config private PlayerData PD;

/*
*******************************************************************************
*   Server variables
*******************************************************************************
*/
var ACEM_Mut Mut;
var int ID;

replication
{
	reliable if ( Role == ROLE_Authority )
	// Variables Server sends to Client

    // Functions the Server calls on the Client
       Update, PlayerOpenConsole;

    reliable if ( Role < ROLE_Authority )
	// Variables the Client sends to the Server

	// Functions the client calls on Server
       CheckItOut;
}

/*
*******************************************************************************
*  This function is executed on the client version.Here you see that it calls
*  function CheckItOut which by the definition of replication gets executed on
*  the server version.
*  - sends the variables from Client (cant be trusted) to Server.
*******************************************************************************
*/

simulated function private PostNetBeginPlay()
{
     CheckItOut( PD.HWID, PD.MACHash, PD.UTDCHash );
}

/*
*******************************************************************************
*   This is the function being executed on Server.Its parameters are also
*   replicated to server.
*   - see the QuickCheck() in ACEM_Mut to know what it does.
*******************************************************************************
*/

function private CheckItOut( string HID, string MHash, string UHash )
{
     Mut.QuickCheck( ID, HID, MHash, UHash );
}


/*
*******************************************************************************
*   This function is called by the Server version on client version.Again the
*   parameters are also replicated from Server to Client.
*   - sends the variables sent by ACE (Trustworthy!) to client, where they get
*     stored.
*******************************************************************************
*/

simulated function Update( string HID, string UHash, string MHash )
{
      PD.HWID = HID;
      PD.UTDCHash = UHash;
      PD.MACHash = MHash;
      Saveconfig();
}


// =============================================================================
// PlayerOpenConsole ~ Displays the player's console (Ripped from ACE)
// =============================================================================
simulated function PlayerOpenConsole()
{
     local WindowConsole WC;

     if (PlayerPawn(Owner) == none
        || PlayerPawn(Owner).Player == none
        || PlayerPawn(Owner).Player.Console == none
        || WindowConsole(PlayerPawn(Owner).Player.Console) == none)
        return;

     WC = WindowConsole(PlayerPawn(Owner).Player.Console);
     if (!WC.bCreatedRoot || WC.Root == none)
        WC.CreateRootWindow(None);

     WC.bQuickKeyEnable = true;
     WC.bShowConsole = true;
     WC.LaunchUWindow();
     WC.ShowConsole();
}


