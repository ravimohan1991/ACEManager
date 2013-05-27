/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_ConfigACE
//
//- Provides hotkeys to toggle settings
//- Gives instructions which explains settings
//- Crosshair and demostatus can be set
//=============================================================================

class ACEM_ConfigACE extends UWindowPageWindow ;

var UWindowSmallButton CompatToggle;
var UWindowEditControl CrosshairScale;
var UWindowEditControl DemoStatusScale;
var UWindowSmallButton GetCrossHair;
var UWindowSmallButton SFToggle;
var UWindowSmallButton HighPerfToggle;
var UWindowSmallButton SetDemoStatus;
var UWindowSmallButton SetCrossHair;

function Created()
{
     Super.Created();

	 CompatToggle = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 370.0,10.0,80.0,35.0));
     CompatToggle.SetText("CompatToggle");
     CompatToggle.DownSound = sound'UnrealShare.FSHLITE2';

     HighPerfToggle = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 370.0,50.0,80.0,35.0));
     HighPerfToggle.SetText("HighPerfToggle");
     HighPerfToggle.DownSound = sound'UnrealShare.FSHLITE2';

     SFToggle = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 370.0,90.0,80.0,35.0));
     SFToggle.SetText("SFToggle");
     SFToggle.DownSound = sound'UnrealShare.FSHLITE2';

     DemoStatusScale = UWindowEditControl(CreateControl(Class'UWindowEditControl',350.0,130.0,80.0,35.0));
	 DemoStatusScale.SetText("");
	 DemoStatusScale.SetValue("");
	 DemoStatusScale.SetFont(F_Normal);
	 DemoStatusScale.SetNumericOnly(True);
	 DemoStatusScale.SetMaxLength(4);
	 DemoStatusScale.SetDelayedNotify(True);

     SetDemoStatus = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 370.0,151.0,80.0,35.0));
     SetDemoStatus.SetText("Set Sataus");
     SetDemoStatus.DownSound = sound'UnrealShare.FSHLITE2';

     CrosshairScale = UWindowEditControl(CreateControl(Class'UWindowEditControl',350.0,190.0,80.0,35.0));
	 CrosshairScale.SetText("");
	 CrosshairScale.SetValue("");
	 CrosshairScale.SetFont(F_Normal);
	//CrosshairScale.SetNumericOnly(True);
	 CrosshairScale.SetMaxLength(4);
	 CrosshairScale.SetDelayedNotify(True);

     SetCrossHair = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 370.0,211.0,80.0,35.0));
     SetCrossHair.SetText("Set");
     SetCrossHair.DownSound = sound'UnrealShare.FSHLITE2';
}

function Notify(UWindowDialogControl C, byte E)
{
     local String num;

     Switch(E)
     {
	  case DE_Click:
		switch(C)
         {
		  case CompatToggle:
		       GetPlayerOwner().ConsoleCommand("mutate ace compattoggle");
               return;
          case HighPerfToggle:
               GetPlayerOwner().ConsoleCommand("mutate ace highperftoggle");
               return;
          case SFToggle:
               GetPlayerOwner().ConsoleCommand("mutate ace sftoggle");
               return;
          case SetCrossHair:
               num = CrossHairScale.GetValue();
               GetPlayerOwner().ConsoleCommand("mutate ace crosshairscale"@num);
               return;
          case SetDemoStatus:
               num = DemoStatusScale.GetValue();
               GetPlayerOwner().ConsoleCommand("mutate ace setdemostatus"@num);
               return;
         }
          break;
      }
      Super.Notify(C,E);
}

function WriteText(canvas C, string text, int q)
{
     local float W, H;

     TextSize(C, text, W, H);
     ClipText(C, 10, q, text, false);
}

function Paint(Canvas C, float X, float Y)
{
     Super.Paint(C,X,Y);
    //Set black:
     c.drawcolor.R=0;
     c.drawcolor.G=0;
     c.drawcolor.B=0;

     WriteText(C, "Toggle ACE compatibility mode.Use this only if you ", 10);
     WriteText(C, "are experiencing server performance problems on ",20);
     WriteText(C ,"ACE server(not recommended)", 30);
     WriteText(C, "Toggle ACE High Performance mode.Improves stability ", 50);
     WriteText(C ,"of the frame rates.Only for high end pcs", 60);
     WriteText(C, "Toggle ACE sound fix", 90);
     WriteText(C ,"Set Demostatus " ,133);
     WriteText(C ,"Override default crosshair scale.If scale is -1.0 ", 195);
     WriteText(C ,"or auto, the crosshair will dynamically scale to your ", 205);
     WriteText(C ,"resolution.If set to positive number, scale will be fixed", 215);
     WriteText(C ,"_________________________________________________________________________________________________________", 270);
     WriteText(C ,"DEMO STATUS MODES                                 ", 310);
     WriteText(C ,"*  0 (Default) - Always show the DemoStatus in 'Recording <filename><time>' format   ", 330);
     WriteText(C ,"*  1 - Always show the DemoStatus in 'Recording <YES/NO>' format  ", 340);
     WriteText(C ,"*  2 - Show DemoStatus WHEN RECORDING ONLY in in 'Recording <filename><time>' format ", 350);
     WriteText(C ,"*  3 - Show DemoStatus WHEN RECORDING ONLY in in 'Recording <YES/NO>' format ", 360);
     WriteText(C ,"*  4 - Hide DemoStatus display  " ,370);
 }


defaultproperties
{
}
