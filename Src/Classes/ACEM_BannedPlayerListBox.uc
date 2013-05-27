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

class ACEM_BannedPlayerListBox extends UWindowListBox;

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
     if(ACEM_BannedPlayerListItem(Item).bSelected)
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
          C.DrawColor.r = 0;
          C.DrawColor.g = 0;
          C.DrawColor.b = 0;
     }

     C.Font = Root.Fonts[F_Normal];

     ClipText(C, X+2, Y, ACEM_BannedPlayerListItem(Item).PlayerName);
}
/*
function Refresh()
{
     Items.Clear();
}
*/
function KeyDown( int Key, float X, float Y )
{
     local int i;
     local UWindowListBoxItem ItemPointer;
     local PlayerPawn P;

     P = GetPlayerOwner();

     if(Key == P.EInputKey.IK_MouseWheelDown || Key == P.EInputKey.IK_Down)
     {
      if(SelectedItem != None && SelectedItem.Next != None)
      {
        SetSelectedItem(UWindowListBoxItem(SelectedItem.Next));
        MakeSelectedVisible();
      }
     }

     if(Key == P.EInputKey.IK_MouseWheelUp || Key == P.EInputKey.IK_Up)
     {
      if(SelectedItem != None && SelectedItem.Prev != None && SelectedItem.Sentinel != SelectedItem.Prev)
      {
        SetSelectedItem(UWindowListBoxItem(SelectedItem.Prev));
        MakeSelectedVisible();
      }
     }

     if(Key == P.EInputKey.IK_PageDown)
     {
      if(SelectedItem != None)
      {
        ItemPointer = SelectedItem;
        for(i=0;i<7;i++)
        {
           if(ItemPointer.Next == None)
              return;
           ItemPointer = UWindowListBoxItem(ItemPointer.Next);
        }
        SetSelectedItem(ItemPointer);
        MakeSelectedVisible();
      }
     }

     if(Key == P.EInputKey.IK_PageUp)
     {
      if(SelectedItem != None)
      {
        ItemPointer = SelectedItem;
        for(i=0;i<7;i++)
        {
           if(ItemPointer.Prev == None || ItemPointer.Prev == SelectedItem.Sentinel)
              return;
           ItemPointer = UWindowListBoxItem(ItemPointer.Prev);
        }
        SetSelectedItem(ItemPointer);
        MakeSelectedVisible();
      }
     }
     ParentWindow.KeyDown(Key,X,Y);
}



defaultproperties
{
    ItemHeight=13.00
    ListClass=class'ACEM_BannedPlayerListItem'
}
