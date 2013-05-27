/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_Actor
//
//- This actor gets spawned on the server
//- Adds the ACEManager mutator
//=============================================================================

class ACEM_Actor extends Actor ;

function PostBeginPlay()
{
    super.PostBeginPlay();

    Level.Game.BaseMutator.AddMutator(Level.Spawn(class'ACEM_Mut'));
}


defaultproperties
{
    bHidden=True
}
