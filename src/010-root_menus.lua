-- *****************************************************************************
--                     **                    Root Menus                       **
--                     *********************************************************
MenuCoalitionBlue = MENU_COALITION:New(coalition.side.BLUE, "My Coalition resources")
MenuCoalitionRed = MENU_COALITION:New(coalition.side.RED, "My Coalition resources")

use_jtff_sound_mod = false


sound2Bip = USERSOUND:New( "Misc/2_Bips.ogg" )
sound1Bip = USERSOUND:New( "Misc/Bip.ogg" )

sound1Bip:ToAll()
