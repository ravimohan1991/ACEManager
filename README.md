ACEManager
==========

> [v1.5](#version-15)

ACEManager is an add-on for Unreal Tournament 99 to manage Anti Cheat Engine. Besides providing GUI for configuring various client side settings
and taking ACE snapshots, ACEManager provides powerful interface to ban players using HwID and other hashes.
Through this tool, one can see, all the information obtained by ACE, in-game. Like the true country ( of players behind
proxy ), Operating System, UT version, HwID's and other related information.



REQUIREMENTS
==================================================================================================

Minimum
-------------
* UnrealTournament G.O.T.Y v436
* Working installation of ACEv08g/h

Recommended
-------------------
* UnrealTournament G.O.T.Y v451
* Working installation of ACEv08g/h
* Working installation of IpToCountry (any version)

ACEManager can also import Nexgen_Ban_Operators. For this feature you should have a working installation of
Nexgen(version).

Note: Different versions of Nexgen require different versions of ACEManager.
Again Note: I have coded ACEManager such that it strictly depends on the particular version of Nexgen and ACE. If
you have some homemade versions of any of these, you might want to refer Coding and Compiling section. If you dont
use nexgen on your server, then just compile ACEManager using any nexgen( version ).u file and make sure that this
file is present in your system directory.



INSTALLATION
==================================================================================================

Assumption - I assume that you have compiled my code and have ACEManager(version).u/.int files. Refer Coding and
Compiling section (in ReadMe.pdf) if you have not compiled it yet.

Server Install:
---------------

* Move ACEManager(version).u/.int contents to your System folder.
* Open UnrealTournament.ini
* Scroll to [Engine.GameEngine] section. Be sure to add ACEManager ServerActor before ACE ServerActor.
 Also make sure that it is added after IpToCountry and Nexgen ServerActors. So you should have something
 like this
 
        [Engine.GameEngine]
        ServerActors=ipToCountry.LinkActor
        ServerActors=Nexgen(version).NexgenActor
        ServerPackages=ACEManager(version)
        ServerActors=ACEManager(version).ACEM_Actor
        ServerActors=NPLoader_v16b.NPLActor
        ServerActors=ACEv08g_S.ACEActor
        ServerActors=ACEv08g_EH.ACEEventActor


Client Install
---------------

* Move ACEManager(version).u and ACEManager(version).int to your System folder.




USAGE
========

Server install:
------------------

If it is installed in server then -:

Open the ACEManager GUI in-game, by typing "mutate ace manage".
You can use the following features of ACEManager through that GUI.

* Configure ACE

Available to all players. Basically does mutate blah blah for client-side settings.
Working of each button has been explained in GUI.


* SShot

The most admirable part of the Manager, available to all players, is this page. There is no need to
know the ID of players and no need to remember those long commands. ACE snap of the players is just a click away!


* Ban Manager

The most attractive and useful feature of ACEManager. This page can be accessed by the admins only, where they
can manage bans. ACEManager identifies 3 kind of admins

a)Root Admin (of the server)
b)Nexgen_Ban_Oprator (you know who)
c)ACEManager Admin (the guy knowing the ACEPass) - The right of ACEManager Admin is to manage bans and
take snaps only.


Client install:
-----------------

Open GUI in-game through the mod menu.
Advantage??

If you join a server which doesn't have ACEManager. You can still use Configure ACE and SShot (if you know the
password) facility with this install.

Note : ACEManager, when opened through mod-menu, will not show Ban page.




CONFIGURING ACEManager
==================================================================================================

Following variables can be found in ACEManager.ini

CheckBanType:
--------------
* 0 = only HwID check
* 1 = HwID+ACEMacHash check
* 2 = HwID+ACEMacHash+UTDCMacHash check


bAllowAnyonetoSnap:
--------------------
If set true, everyone is allowed to take snap. If set to false only admin (see the definition in
Ban Manager section) and players knowing password of ACE can take snap.

ACEPass:
---------
Set it to some word if you want to appoint someone as ACEManager Admin.
Note:This password is a variable of ACEManager and is used by ACEManager only.

bDebug:
--------
set it true so that it can log the events of ACEManager
(As a beta tester, you should always set it true)

CountryFlagsPackage:
----------------------
The package for CountryFlags you want to display.
If you are a ServerAdmin then you can jump directly to FAQ section. Don't forget to see the ChangeLog file.





THANKS
==================================================================================================

* D aka Diwakar for his optimistic and encouraging attitude towards the project.
* Bruce Bickar aka BDB for mapvote.
* Mongo and DrSin for WRI code.
* [os]sphx ( his mod, Admin Tool, was of great help for designing UWindows ).
* Anthrax for ACE.
* back4more aka bfm for "exhaustive" beta testing and feedback.
* LetyLove for beta testing and maintaining the code for different versions of Nexgen :)
* All the Admins who use this add-on and give me the feedback.
 


CHANGELOG
==========

### Version 1.5 (Source Code release)
- **ADDED**: Enabled ACE Adminlogin.
- **ADDED**: Scrolling credits.
- **ADDED**: Quick Check. Banned players *can* be kicked before ACE actors are spawned.
- **ADDED**: ACEManager now generates it's own kicks. Kick function no longer calls ACE functions.
- **IMPROVED**: Proper (realtime) replication of banned players' list.
- **IMPROVED**: Updation of ban entries in the Uwindow.

### Version 1.4 (Public)
- **ADDED**: Importing Nexgen Ban Operators.
- **IMPROVED**: Little tweaks and adjustments which I dont remember.

### Version 1.3 (Public Beta)
- **FIXED**: Showing ACE info of banned players.Earlier it used to show only for first player in the banned list.
        ( Mistake was I.Next. It should have been J.Next )
- **FIXED**: PlayerRealIP and PlayerIP interchanging issue.
 
### Version 1.2 (Private)
- **FIXED**: Some accessed none warnings at the start of map.
- **FIXED**: ACEManager menue not opening in some systems[Testing needed].
- **ADDED**: About page.
- **ADDED**: More ACE info is now displayed/stored for current/banned players.
- **ADDED**: bAllowAnyonetoSnap- Utility which allows any player to take snap (if admin is ok with it).
- **IMPROVED**: ACEInfo is now displayed in readable and desired format.
- **MODIFICATION**: ACE info is now shown in different colours.

### Version 1.1 (Private)

- **ADDED**: Banning system
      * Kicking the player using ACE function.
      * Showing ACE info of the current players.
      * Making whole banning/unbanning procedure GUI based.
      * CheckBanType - ACEManage can check bans by 3 methods.
