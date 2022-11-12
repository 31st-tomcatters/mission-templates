-- *****************************************************************************
--                     **                    Set_Client                       **
--                     *********************************************************
Set_CLIENT = SET_CLIENT:New():FilterOnce()
Set_CLIENT:HandleEvent(EVENTS.Refueling)
Set_CLIENT:HandleEvent(EVENTS.RefuelingStop)
Set_CLIENT:HandleEvent(EVENTS.PlayerEnterAircraft)
function Set_CLIENT:OnEventPlayerEnterAircraft(EventData)
    if (EventData.IniGroup) then
        local clientSetting = SETTINGS:Set( EventData.IniPlayerName)
        clientSetting:SetImperial()
        clientSetting:SetA2G_MGRS()
        clientSetting:SetMenutextShort(true)
        debug_msg(string.format("Add Tanker Menu for group [%s], player name [%s]",EventData.IniGroupName , EventData.IniPlayerName))
        if type(InterceptArray) == 'table' then
            for index, objIntercept in ipairs(InterceptArray) do
                if (objIntercept.menus[EventData.IniUnit:GetCoalition()]) then
                    MENU_GROUP_COMMAND:New( EventData.IniGroup, "High Aspect", objIntercept.menus[EventData.IniUnit:GetCoalition()], StartInterceptTraining, {EventData.IniUnit:GetName(),index,-20,20} )
                    MENU_GROUP_COMMAND:New( EventData.IniGroup, "Medium Aspect Left", objIntercept.menus[EventData.IniUnit:GetCoalition()], StartInterceptTraining, {EventData.IniUnit:GetName(),index,20,50} )
                    MENU_GROUP_COMMAND:New( EventData.IniGroup, "Medium Aspect Right", objIntercept.menus[EventData.IniUnit:GetCoalition()], StartInterceptTraining, {EventData.IniUnit:GetName(),index,-50,-20} )
                    MENU_GROUP_COMMAND:New( EventData.IniGroup, "Low Aspect Left", objIntercept.menus[EventData.IniUnit:GetCoalition()], StartInterceptTraining, {EventData.IniUnit:GetName(),index,50,80} )
                    MENU_GROUP_COMMAND:New( EventData.IniGroup, "Low Aspect Right", objIntercept.menus[EventData.IniUnit:GetCoalition()], StartInterceptTraining, {EventData.IniUnit:GetName(),index,-80,-50} )
                end
            end
        end
        if EventData.IniUnit:GetCoalition() == coalition.side.BLUE then
            MENU_GROUP_COMMAND:New( EventData.IniGroup, "Nearest Tanker Info", MenuCoalitionTankerBlue, NearestTankerInfo, { EventData.IniUnit, EventData.IniGroup}  )
            MENU_GROUP_COMMAND:New( EventData.IniGroup, "All Tankers Info", MenuCoalitionTankerBlue, AllTankersInfo, {EventData.IniUnit,EventData.IniGroup} )
        else
            MENU_GROUP_COMMAND:New( EventData.IniGroup, "Nearest Tanker Info", MenuCoalitionTankerRed, NearestTankerInfo, { EventData.IniUnit, EventData.IniGroup}  )
            MENU_GROUP_COMMAND:New( EventData.IniGroup, "All Tankers Info", MenuCoalitionTankerRed, AllTankersInfo, {EventData.IniUnit,EventData.IniGroup} )
        end
        local GroupMenu = MENU_GROUP:New( EventData.IniGroup, "My settings" )
        debug_msg(string.format("Add Immortal Menu for group [%s], player name [%s]",EventData.IniGroupName , EventData.IniPlayerName))
        BASE:SetState( EventData.IniGroup, "isImmortal", false )
        MENU_GROUP_COMMAND:New( EventData.IniGroup, "Switch immortal status", GroupMenu, switchGroupImmortalStatus, EventData.IniGroup )
        --if #AIRBOSSArray > 0 then
        --    MENU_GROUP_COMMAND:New( EventData.IniGroup, "Switch Airboss subtitles", GroupMenu, switchGroupAirbossSubtitlesStatus, EventData.IniGroup )
        --end
    end
end
function Set_CLIENT:OnEventRefueling(EventData)
    if (EventData.IniGroup) then
        local client = CLIENT:Find(EventData.IniDCSUnit)
        local clientFuel = EventData.IniUnit:GetTemplateFuel()
        debug_msg(string.format("[%s] Start to refuel at the tanker %[s], current fuel : %.0f Kg",EventData.IniPlayerName , EventData.TgtUnitName, clientFuel))
        BASE:SetState( client, "Fuel", clientFuel )
    end
end
function Set_CLIENT:OnEventRefuelingStop(EventData)
    if (EventData.IniGroup) then
        local client = CLIENT:Find(EventData.IniDCSUnit)
        local clientFuelTaken = EventData.IniUnit:GetTemplateFuel() - BASE:GetState(client,"Fuel")
        debug_msg(string.format("[%s] Stop to refuel at the tanker %[s], taken %.0f Kg",EventData.IniPlayerName , EventData.TgtUnitName, clientFuelTaken))
    end
end

Set_CLIENT_Bleu = SET_CLIENT:New():FilterCoalitions(coalition.side.BLUE):FilterOnce()
debug_msg(string.format("Nbre Blue Client : %i", Set_CLIENT_Bleu:Count()))
Set_CLIENT_Red = SET_CLIENT:New():FilterCoalitions(coalition.side.RED):FilterOnce()
debug_msg(string.format("Nbre Red Client : %i", Set_CLIENT_Red:Count()))
