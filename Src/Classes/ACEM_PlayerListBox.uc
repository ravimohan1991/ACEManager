/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_PlayerListBox
//
//- Loads currentplayerlist from GameReplication of Owner
//- Reload when player leaves, kicked, banned             -> Done
//=============================================================================

class ACEM_PlayerListBox extends UWindowListBox;

var bool bChanged;
var float Time;

function Created()
{
     ListClass = class'ACEM_List';

     Super.Created();
	 LoadList();
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	 local GameReplicationInfo L;
	 local int TeamNumber;
	 L = GetPlayerOwner().GameReplicationInfo;

	 if(ACEM_List(Item).bSelected)
	 {
		C.DrawColor.r = 0;
		C.DrawColor.g = 0;
		C.DrawColor.b = 128;
		DrawStretchedTexture(C, X, Y, W, H-1, Texture'WhiteTexture');
		C.DrawColor.r = 255;
		C.DrawColor.g = 255;
		C.DrawColor.b = 255;
	 }
	 else
	 {
		if (L.bTeamGame)
		{
			TeamNumber = ACEM_List(Item).Team;
			switch(TeamNumber)
			{
			case 0: //Red
				C.DrawColor.r = 255;
				C.DrawColor.g = 0;
				C.DrawColor.b = 0;
				break;
			case 1: //Blue
				C.DrawColor.r = 0;
				C.DrawColor.g = 0;
				C.DrawColor.b = 255;
				break;
			case 2: //Green
				C.DrawColor.r = 25;
				C.DrawColor.g = 180;
				C.DrawColor.b = 25;
				break;
			case 3: //Gold
				C.DrawColor.r = 195;
				C.DrawColor.g = 200;
				C.DrawColor.b = 20;
				break;
			default:
				C.DrawColor.r = 0;
				C.DrawColor.g = 0;
				C.DrawColor.b = 0;
				break;
			}
		}
		else
		{
			C.DrawColor.r = 0;
			C.DrawColor.g = 0;
			C.DrawColor.b = 0;
		}
     }
	 C.Font = Root.Fonts[F_Normal];
	 ClipText(C, X+2, Y, ACEM_List(Item).Name);
}

function LoadList()
{
     local ACEM_List Players;
	 local GameReplicationInfo L;
	 local int i;

	 Items.Clear();

	 L = GetPlayerOwner().GameReplicationInfo;
	 if (L != None)
	 {
	  for (i=0; i<32; i++)
	   if (L.PRIArray[i] != None)
	   {
	    if ( !L.PRIArray[i].bIsSpectator && !L.PRIArray[i].bIsABot )
	    {
	     Players = ACEM_List(Items.Append(class'ACEM_List'));
	     Players.ID = L.PRIArray[i].PlayerID;
         Players.Name = L.PRIArray[i].PlayerID@")"@L.PRIArray[i].PlayerName;
	     Players.Team = L.PRIArray[i].Team;
	    }
	   }
	  }
}

function Tick(float DeltaTime)
{
     if (bChanged)
	 {
		Time += DeltaTime;
		if (Time > 1)
		{
			Items.Clear();
			LoadList();
			Time = 0;
			bChanged = false;
		}
	  }
}


defaultproperties
{
}
