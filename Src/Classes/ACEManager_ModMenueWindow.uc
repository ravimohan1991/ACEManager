/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACE_Manager.
// For clientside modmenue
//=============================================================================
class ACEManager_ModMenueWindow extends UWindowDialogClientWindow;

var UWindowPageControl Pages;
var UWindowSmallButton  ACEM_AdminLoginButton;
var UWindowPageControlPage ACEBan;
var UWindowPageControlPage UPCSS;

function WriteText(canvas C, string text, int q)
{
     local float W, H;

     TextSize(C, text, W, H);
     ClipText(C, 10, q, text, false);
}


function Created()
{
      Super.Created();
      Saveconfig();

      Pages = UWindowPageControl(CreateWindow(class'UWindowPageControl', 0, 25, 550, 500));
      Pages.SetMultiLine(True);
      Pages.AddPage("Configure ACE ", class'ACEM_ConfigACE');
      UPCSS = Pages.AddPage("ACE SShot ", class'ACEM_SShot');
      //Pages.AddPage("ACEBan", class'ACEM_BanManager');
      Pages.AddPage("About", class'ACEM_About');

}



