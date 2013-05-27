//=============================================================================
// ACEM_PlayerInfoListBox
//
//- Ripped from BDB's mapvote mutator
//- For printing player info on a window
//- Colouring ( Done )
//=============================================================================


class ACEM_PlayerInfoListBox extends UWindowListBox;

var string CountryFlagsPackage;
var texture FlagTex;

static final function string SelElem(string Str, int Elem)
{
	local int pos;
	while(Elem-->1)
		Str=Mid(Str, InStr(Str,":")+1);
	pos=InStr(Str, ":");
	if(pos != -1)
    	Str=Left(Str, pos);
    return Str;
}

function Paint(Canvas C, float MouseX, float MouseY)
{
     C.DrawColor.r = 255;
     C.DrawColor.g = 255;
     C.DrawColor.b = 255;
     DrawStretchedTexture(C, 0, 0,WinWidth, WinHeight, Texture'UWindow.WhiteTexture');
     Super.Paint(C,MouseX,MouseY);
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
     local string CountryPrefix;

     if(ACEM_PlayerInfoListItem(Item).bSelected)
     {
          C.DrawColor.r = 0;
          C.DrawColor.g = 0;
          C.DrawColor.b = 128;
          DrawStretchedTexture(C, X, Y, W, H-1, Texture'UWindow.WhiteTexture');
          C.DrawColor.r = 255;
          C.DrawColor.g = 255;
          C.DrawColor.b = 255;
     }
     else
     {
          C.DrawColor.r = 255;
          C.DrawColor.g = 255;
          C.DrawColor.b = 255;
          DrawStretchedTexture(C, X, Y, W, H-1, Texture'UWindow.WhiteTexture');
     }


     C.Font = Root.Fonts[F_Large];
     C.DrawColor.r = 81;
     C.DrawColor.g = 17;
     C.DrawColor.b = 17;
     C.bCenter = true;
     ClipText(C,X+2, Y+25,ACEM_PlayerInfoListItem(Item).PlayerName);
     C.Font = Root.Fonts[F_Bold];

     C.bCenter = false;
     C.DrawColor.r = 0;
     C.DrawColor.g = 0;
     C.DrawColor.b = 0;

     ClipText(C, X+2, Y+70,"IP/Host:");
     ClipText(C, X+2, Y+130,"Software Info:");
     ClipText(C, X+2, Y+190,"Hardware Info:");
     ClipText(C, X+2, Y+265,"Hashes:");

     C.DrawColor.r = 0;
     C.DrawColor.g = 0;
     C.DrawColor.b = 139;
     C.Font = Root.Fonts[F_Normal];

     //ClipText(C, X+2, Y+40,"Player Name..............:");
     ClipText(C, X+2, Y+85,"Player IP...................:");
     ClipText(C, X+190, Y+85,"Country.............:");
     ClipText(C, X+2, Y+100,"Host..........................:");
     ClipText(C, X+2, Y+145,"Operating System......:");
     ClipText(C, X+2, Y+160,"UT Version................:");
     ClipText(C, X+2, Y+205,"CPUIdentifer.............:");
     ClipText(C, X+2, Y+220,"CPUSpeed................:");
     ClipText(C, X+2, Y+235,"NICName..................:");
     ClipText(C, X+2, Y+280,"HWID.......................:");
     ClipText(C, X+2, Y+295,"MAC Hash.................:");
     ClipText(C, X+2, Y+310,"UTDCMacHash..........:");
     ClipText(C, X+2, Y+325,"ACEMD5...................:");
     ClipText(C, X+190, Y+160,"UTCommandLine.:");

     C.DrawColor.r = 165;
     C.DrawColor.g = 42;
     C.DrawColor.b = 42;

     //ClipText(C, X+105, Y+40,ACEM_PlayerInfoListItem(Item).PlayerName);
     if( ACEM_PlayerInfoListItem(Item).PlayerRealIP != "" )
      ClipText(C, X+105, Y+85,ACEM_PlayerInfoListItem(Item).PlayerRealIP);
     else
      ClipText(C, X+105, Y+85,ACEM_PlayerInfoListItem(Item).PlayerIP);
     ClipText(C, X+275, Y+85,"       "$SelElem(ACEM_PlayerInfoListItem(Item).IpInfo, 3));
         C.DrawColor.r = 255;
         C.DrawColor.g = 255;
         C.DrawColor.b = 255;
     CountryPrefix = SelElem(ACEM_PlayerInfoListItem(Item).IpInfo, 5);
     FlagTex = texture(DynamicLoadObject(CountryFlagsPackage$"."$CountryPrefix, class'Texture'));
     C.bNoSmooth = False;
     C.DrawIcon(FlagTex, 1.0);

     C.DrawColor.r = 165;
     C.DrawColor.g = 42;
     C.DrawColor.b = 42;

     ClipText(C, X+105, Y+100,SelElem(ACEM_PlayerInfoListItem(Item).IpInfo, 2));
     if( ACEM_PlayerInfoListItem(Item).bWine )
      ClipText(C, X+105, Y+145,"Linux( HWID for this client will not be calculated )");
     else
      ClipText(C, X+105, Y+145,ACEM_PlayerInfoListItem(Item).PlayerOSString);
     ClipText(C, X+105, Y+160,ACEM_PlayerInfoListItem(Item).PlayerUTVersion);
     ClipText(C, X+275, Y+160,ACEM_PlayerInfoListItem(Item).UTCommandLine);
     ClipText(C, X+105, Y+205,ACEM_PlayerInfoListItem(Item).CPUIdentifer);
     ClipText(C, X+105, Y+220,"Measured:"@ACEM_PlayerInfoListItem(Item).CPUMeasuredSpeed@"Mhz / Reported:"@ACEM_PlayerInfoListItem(Item).CPUReportedSpeed@"Mhz");
     ClipText(C, X+105, Y+235,ACEM_PlayerInfoListItem(Item).NICName);
     ClipText(C, X+105, Y+280,ACEM_PlayerInfoListItem(Item).PlayerHWID);
     ClipText(C, X+105, Y+295,ACEM_PlayerInfoListItem(Item).PlayerMACHash);
     ClipText(C, X+105, Y+310,ACEM_PlayerInfoListItem(Item).UTDCMacHash);
     ClipText(C, X+105, Y+325,ACEM_PlayerInfoListItem(Item).ACEMD5);
}


/*   ClipText(C, X+2, Y+40,"Player Name..............:");
     ClipText(C, X+105, Y+40,ACEM_PlayerInfoListItem(Item).PlayerName);

     ClipText(C, X+2, Y+70,"IP/HOST:");
     ClipText(C, X+2, Y+85,"Player IP...................:");

     ClipText(C, X+105, Y+85,ACEM_PlayerInfoListItem(Item).PlayerIP);
     ClipText(C, X+190, Y+85,"Country.............:");
     ClipText(C, X+275, Y+85,"       "$SelElem(ACEM_PlayerInfoListItem(Item).IpInfo, 3));

     C.DrawColor.r = 255;
     C.DrawColor.g = 255;
     C.DrawColor.b = 255;
     CountryPrefix = SelElem(ACEM_PlayerInfoListItem(Item).IpInfo, 5);
     FlagTex = texture(DynamicLoadObject(CountryFlagsPackage$"."$CountryPrefix, class'Texture'));
     C.bNoSmooth = False;
     C.DrawIcon(FlagTex, 1.0);

     C.DrawColor.r = 128;
     C.DrawColor.g = 0;
     C.DrawColor.b = 0;
     ClipText(C, X+2, Y+100,"Host..........................:");
     ClipText(C, X+105, Y+100,SelElem(ACEM_PlayerInfoListItem(Item).IpInfo, 2));

     ClipText(C, X+2, Y+130,"Software Info:");
     ClipText(C, X+2, Y+145,"Operating System......:");
     if( ACEM_PlayerInfoListItem(Item).bWine )
      ClipText(C, X+105, Y+145,"Linux");
     else
      ClipText(C, X+105, Y+145,ACEM_PlayerInfoListItem(Item).PlayerOSString);
     ClipText(C, X+2, Y+160,"UT Version................:");
     ClipText(C, X+105, Y+160,ACEM_PlayerInfoListItem(Item).PlayerUTVersion);
     ClipText(C, X+190, Y+160,"UTCommandLine.:");
     ClipText(C, X+275, Y+160,ACEM_PlayerInfoListItem(Item).UTCommandLine);

     ClipText(C, X+2, Y+190,"Hardware Info:");
     ClipText(C, X+2, Y+205,"CPUIdentifer.............:");
     ClipText(C, X+105, Y+205,ACEM_PlayerInfoListItem(Item).CPUIdentifer);
     ClipText(C, X+2, Y+220,"CPUSpeed................:");
     ClipText(C, X+105, Y+220,"Measured:"@ACEM_PlayerInfoListItem(Item).CPUMeasuredSpeed@"Mhz / Reported:"@ACEM_PlayerInfoListItem(Item).CPUReportedSpeed@"Mhz");
     ClipText(C, X+2, Y+235,"NICName..................:");
     ClipText(C, X+105, Y+235,ACEM_PlayerInfoListItem(Item).NICName);

     ClipText(C, X+2, Y+265,"Hashes:");
     ClipText(C, X+2, Y+280,"HWID.......................:");
     ClipText(C, X+105, Y+280,ACEM_PlayerInfoListItem(Item).PlayerHWID);
     ClipText(C, X+2, Y+295,"MAC Hash.................:");
     ClipText(C, X+105, Y+295,ACEM_PlayerInfoListItem(Item).PlayerMACHash);
     ClipText(C, X+2, Y+310,"UTDCMacHash..........:");
     ClipText(C, X+105, Y+310,ACEM_PlayerInfoListItem(Item).UTDCMacHash);
     ClipText(C, X+2, Y+325,"ACEMD5...................:");
     ClipText(C, X+105, Y+325,ACEM_PlayerInfoListItem(Item).ACEMD5);
*/
/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2010-2011 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
defaultproperties
{
    ItemHeight=13.00
    ListClass=Class'ACEM_PlayerInfoListItem'
}
