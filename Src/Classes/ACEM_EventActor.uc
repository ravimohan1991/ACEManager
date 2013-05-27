/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_EventActor
//
//- Monitors the events of ACE and acts accordingly
//- On PlayerJoin asks the Manager to check Bans
//- Automatically ban cheaters( needs lots of testing )  -> TODO
//- Taken from ACE itself!!
//=============================================================================

class ACEM_EventActor extends IACEEventHandler config (ACEManager);

var() config bool bAllowEveryOnetoSnap;
var() config string CountryFlagsPackage, ACEPass;
var() config int CheckBanType;
var() config bool bDebug;
var ACEM_Mut Mut;
var string Version;

function PostBeginPlay()
{
     Saveconfig();
     SetTimer(1.0, true);

}

/*
*******************************************************************************
*
*   Timer ~ Wait for main actor to spawn, then register
*
*******************************************************************************
*/
function Timer()
{
     local IACEActor A;

     Super.Timer();

     if (ConfigActor == none)
     {
        foreach Level.AllActors(class'IACEActor', A)
        {
            A.RegisterEventHandler(self);
            ConfigActor = A;
            break;
        }
     }

     if(Mut != none )
     {
      Mut.CheckBanType = CheckBanType;
      Mut.bDebug = bDebug;
      Mut.bAllowEveryOnetoSnap = bAllowEveryOnetoSnap;
      Mut.CountryFlagsPackage = CountryFlagsPackage;
      Mut.ACEPass = ACEPass;
     }
}

/*
*******************************************************************************
*
*   EventCatcher ~ Main event catcher function
*
*******************************************************************************
*/

function EventCatcher(name EventType, IACECheck Check, string EventData)
{
     switch(EventType)
     {
      case 'PlayerJoin':
            Mut.PlayerACELogin( Check );
            break;
     }
}


defaultproperties
{
    bAllowEveryOnetoSnap=True
    CountryFlagsPackage="CountryFlags2"
    CheckBanType=2
    bDebug=True
    version="v1.5"
}
