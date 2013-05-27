/*
+-----------------------------------------------------------------------------+
| ACEManager   (c)- 2012-2014 The_Cowboy                                      |
+-----------------------------------------------------------------------------+
*/
//=============================================================================
// ACEM_About
//
//- Shows info about the Author( me :P ) and the mod.
//=============================================================================

class ACEM_About extends UWindowPageWindow ;

#exec texture IMPORT NAME=acelogo FILE=Textures\acelogo.pcx GROUP="ACEM" MIPS=Off
#exec texture IMPORT NAME=author1 FILE=Textures\author1.pcx GROUP="ACEM" MIPS=Off
#exec texture IMPORT NAME=author2 FILE=Textures\author2.pcx GROUP="ACEM" MIPS=Off

function Created()
{
     local UWindowCreditsControl C;

     Super.Created();
     C = UWindowCreditsControl(CreateWindow(class'UWindowCreditsControl', 20, 20, 500, 400));
	 C.Register(Self);
	 //C.Notify(C.DE_Created);
     C.AddLineImage( Texture'acelogo' );
     C.AddPadding(2);
     C.AddLineText("Anti Cheat Engine for Unreal Tournament 99");
     C.AddPadding(5);
     C.AddLineText("ACEManager for ACE");
     C.AddPadding(10);
     //C.AddLineImage(texture'author2',60,60);
     C.AddLineText("Coder:");
     C.AddPadding(4);
     C.AddLineText("The_Cowboy");
     C.AddPadding(15);
     C.AddLineText("Beta Testers:");
     C.AddPadding(4);
     C.AddLineText("D_@_NOOB");
     C.AddLineText("LetyLove");
     C.AddLineText("back4more");
     C.AddPadding(15);
     C.AddLineText("Special thanks to");
     C.AddPadding(4);
     C.AddLineText("D_@_NOOB");
     C.AddLineText("Anthrax");
     C.AddLineText("Bruce Bickar aka BDB");
     C.AddLineText("Mongo and DrSin");
     C.AddLineText("[os]sphx");
     C.AddLineText("Dean Harmon (for WOT Greal)");
     C.AddPadding(20);
     C.AddLineUrl("http://www.unrealadmin.org/forums/showthread.php?t=30023",,"Forum");
     C.AddLineText("Please visit the forum for suggestions and feedbacks");
     C.AddPadding(20);
     C.AddLineUrl("http://utgl.unrealadmin.org/ace/",,);
     C.AddLineText("for information regarding Anti Cheat Engine");
}




