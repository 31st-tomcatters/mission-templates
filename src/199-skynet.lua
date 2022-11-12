-- *****************************************************************************
--                     **                     Skynet Groups                   **
--                     *********************************************************

function SpawnIADSDelayed(param)
    local parentMenu = param[1]
    local iadsConfig = param[2]
    local IADSObjectIndex = param[3]
    local delay = param[4] or 10
    local difficulty = param[5] or "easy"
    MESSAGE:NewType(string.format("Warning, IADS [%s] Units %s will spawn in %d sec", difficulty, iadsConfig.name, delay), MESSAGE.Type.Update):ToAll()
    TIMER:New(SpawnIADSUnits, param):Start(delay)
end

function attachSAMSiteToSkynet(site, samGroupName, IADSObjectIndex, connectionNode)
    if type(site) == "string" then
        IADSArray[IADSObjectIndex].IADSObject:addSAMSite(samGroupName)
        IADSArray[IADSObjectIndex].IADSObject:getSAMSiteByGroupName(samGroupName):addConnectionNode(StaticObject.getByName(connectionNode))
    elseif type(site) == "table" then
        IADSArray[IADSObjectIndex].IADSObject:addSAMSite(samGroupName)
        local skynetSam = IADSArray[IADSObjectIndex].IADSObject:getSAMSiteByGroupName(samGroupName)
        skynetSam:addConnectionNode(StaticObject.getByName(connectionNode))
        if (type(site.actAsEW) == "boolean") then
            debug_msg(string.format("IADS - actAsEW %s", tostring(site.actAsEW)))
            skynetSam:setActAsEW(site.actAsEW)
        end
        if (type(site.harmDetectionChance) == "number") then
            debug_msg(string.format("IADS - HARM detection chance : %i", site.harmDetectionChance))
            skynetSam:setHARMDetectionChance(site.harmDetectionChance)
        end
        if (type(site.goLiveRangePercent) == "number") then
            debug_msg(string.format("IADS - Go Live Range : %i perc", site.goLiveRangePercent))
            skynetSam
                    :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
                    :setGoLiveRangeInPercent(site.goLiveRangePercent)
        else
            skynetSam
                    :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
        end
    end
end

function attachPdSiteToSkynet(site, pdGroupName, samGroupName, IADSObjectIndex, connectionNode)
    local skynetSam = IADSArray[IADSObjectIndex].IADSObject:getSAMSiteByGroupName(samGroupName)
    if (type(site.pointDefenses) == "string") then
        IADSArray[IADSObjectIndex].IADSObject:addSAMSite(pdGroupName)
        local skynetPdSam = IADSArray[IADSObjectIndex].IADSObject:getSAMSiteByGroupName(pdGroupName)
        skynetPdSam:addConnectionNode(StaticObject.getByName(connectionNode))
        if (type(site.pdactAsEw) == "boolean") then
            debug_msg(string.format("IADS - actAsEW %s", tostring(site.pdactAsEw)))
            skynetPdSam:setActAsEW(site.pdactAsEw)
        end
        if (type(site.pdharmDetectionChance) == "number") then
            debug_msg(string.format("IADS - HARM detection chance : %i", site.pdharmDetectionChance))
            skynetPdSam:setHARMDetectionChance(site.pdharmDetectionChance)
        end
        if (type(site.pdgoLiveRangePercent) == "number") then
            debug_msg(string.format("IADS - Go Live Range : %i perc", site.pdgoLiveRangePercent))
            skynetPdSam
                    :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
                    :setGoLiveRangeInPercent(site.pdgoLiveRangePercent)
        else
            skynetPdSam
                    :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
        end
        debug_msg(string.format("IADS - Point Defense Sam Group %s Defending SAM %s", pdGroupName, samGroupName))
        skynetSam:addPointDefence(skynetPdSam)
    elseif (type(site.pointDefenses) == "table") then
        IADSArray[IADSObjectIndex].IADSObject:addSAMSite(pdGroupName)
        local skynetPdSam = IADSArray[IADSObjectIndex].IADSObject:getSAMSiteByGroupName(pdGroupName)
        skynetPdSam:addConnectionNode(StaticObject.getByName(connectionNode))
        if (type(site.pdactAsEw) == "boolean") then
            debug_msg(string.format("IADS - actAsEW %s", tostring(site.pdactAsEw)))
            skynetPdSam:setActAsEW(site.pdactAsEw)
        end
        if (type(site.pdharmDetectionChance) == "number") then
            debug_msg(string.format("IADS - HARM detection chance : %i", site.pdharmDetectionChance))
            skynetPdSam:setHARMDetectionChance(site.pdharmDetectionChance)
        end
        if (type(site.pdgoLiveRangePercent) == "number") then
            debug_msg(string.format("IADS - Go Live Range : %i perc", site.pdgoLiveRangePercent))
            skynetPdSam
                    :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
                    :setGoLiveRangeInPercent(site.pdgoLiveRangePercent)
        else
            skynetPdSam
                    :setEngagementZone(SkynetIADSAbstractRadarElement.GO_LIVE_WHEN_IN_SEARCH_RANGE)
        end
        debug_msg(string.format("IADS - Point Defense Sam Group %s Defending SAM %s", pdGroupName, samGroupName))
        skynetSam:addPointDefence(skynetPdSam)
    end
end

function SpawnIADSUnits(param)
    local parentMenu = param[1]
    local iadsConfig = param[2]
    local IADSObjectIndex = param[3]
    local delay = param[4]
    local difficulty = param[5]
    local iadsName = iadsConfig.name
    local nodesConfig = iadsConfig.nodes
    local difficultyArray = {"easy","medium","hard","extreme"}
    local somethingAlreadySpawned = false
    for indexdiff, currentdifficulty in ipairs(difficultyArray) do
        somethingAlreadySpawned = somethingAlreadySpawned or IADSArray[IADSObjectIndex].spawned[currentdifficulty]
    end

    for nodeIndex, nodeConfig in ipairs(nodesConfig) do
        local ewrList = nodeConfig.ewrs
        local siteList = nodeConfig.sites[difficulty]
        for ewrIndex, ewrGroup in ipairs(ewrList) do
            if (not(somethingAlreadySpawned)) then
                local groupNameToSpawn = string.format("%s", ewrGroup)
                if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
                    local spawnGroup = SPAWN:New(groupNameToSpawn)
                    debug_msg(string.format("IADS - SPAWN EWR : %s", groupNameToSpawn))
                    local groupSpawning = spawnGroup:Spawn():OptionAlarmStateRed()
                else
                    debug_msg(string.format("IADS - EWR GROUP to spawn %s not found in mission", groupNameToSpawn))
                end
            end
        end
        local samGroupsSpawned = {}
        for siteIndex, site in ipairs(siteList) do
            if (type(site) == "string") then
                local groupNameToSpawn = string.format("%s", site)
                if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
                    local spawnGroup = SPAWN:New(groupNameToSpawn)
                    debug_msg(string.format("IADS - SPAWN SAM : %s", groupNameToSpawn))
                    samGroupsSpawned[siteIndex] = spawnGroup:Spawn():OptionAlarmStateRed()
                    --if (IADSArray[IADSObjectIndex].IADSNetworkRunning) then
                    --    attachSAMSiteToSkynet(site, samGroupsSpawned[siteIndex]:GetName(), IADSObjectIndex, nodeConfig.connection)
                    --end
                else
                    debug_msg(string.format("IADS - SAM GROUP to spawn %s not found in mission", groupNameToSpawn))
                end
            elseif (type(site) == "table") then
                debug_msg(string.format("IADS - SAM in config file is table"))
                local groupNameToSpawn = string.format("%s", site.sam)
                if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
                    local spawnGroup = SPAWN:New(groupNameToSpawn)
                    debug_msg(string.format("IADS - SPAWN SAM : %s", groupNameToSpawn))
                    samGroupsSpawned[siteIndex] = spawnGroup:Spawn():OptionAlarmStateRed()
                    --if (IADSArray[IADSObjectIndex].IADSNetworkRunning) then
                    --    attachSAMSiteToSkynet(site, samGroupsSpawned[siteIndex]:GetName(), IADSObjectIndex, nodeConfig.connection)
                    --end
                else
                    debug_msg(string.format("IADS - SAM GROUP to spawn %s not found in mission", groupNameToSpawn))
                end
                if (type(site.pointDefenses) == "string") then
                    local pdGroupNameToSpawn = string.format("%s", site.pointDefenses)
                    if (GROUP:FindByName(pdGroupNameToSpawn) ~= nil) then
                        local spawnGroup = SPAWN:New(pdGroupNameToSpawn)
                        debug_msg(string.format("IADS - SPAWN SAM-PointDefense : %s", pdGroupNameToSpawn))
                        local pdSamGroupsSpawned = spawnGroup:Spawn():OptionAlarmStateRed()
                        --if (IADSArray[IADSObjectIndex].IADSNetworkRunning) then
                        --    attachPdSiteToSkynet(site, pdSamGroupsSpawned:GetName(), samGroupsSpawned[siteIndex]:GetName(), IADSObjectIndex, nodeConfig.connection)
                        --end
                    else
                        debug_msg(string.format("IADS - SAM-PointDefense GROUP to spawn %s not found in mission", pdGroupNameToSpawn))
                    end
                elseif (type(site.pointDefenses) == "table") then
                    local pdSamGroupsSpawned = {}
                    for pdindex, pdSamGroup in ipairs(site.pointDefenses) do
                        local pdGroupNameToSpawn = string.format("%s", pdSamGroup)
                        if (GROUP:FindByName(pdGroupNameToSpawn) ~= nil) then
                            local spawnGroup = SPAWN:New(pdGroupNameToSpawn)
                            debug_msg(string.format("IADS - SPAWN SAM-PointDefense : %s", pdGroupNameToSpawn))
                            pdSamGroupsSpawned[pdindex] = spawnGroup:Spawn():OptionAlarmStateRed()
                            --if (IADSArray[IADSObjectIndex].IADSNetworkRunning) then
                            --    attachPdSiteToSkynet(site, pdSamGroupsSpawned[pdindex]:GetName(), samGroupsSpawned[siteIndex]:GetName(), IADSObjectIndex, nodeConfig.connection)
                            --end
                        else
                            debug_msg(string.format("IADS - SAM-PointDefense GROUP to spawn %s not found in mission", pdGroupNameToSpawn))
                        end
                    end
                end
            end
        end
    end
    IADSArray[IADSObjectIndex].spawned[difficulty] = true
    if (IADSArray[IADSObjectIndex].IADSNetworkRunning) then
        local showStatusOption = IADSArray[IADSObjectIndex].IADSObject:getDebugSettings().IADSStatus
        local showContactsOption = IADSArray[IADSObjectIndex].IADSObject:getDebugSettings().contacts
        deactivateSkynet(
                {iadsConfig, IADSObjectIndex,parentMenu}
        )
        activateSkynet(
                {iadsConfig, IADSObjectIndex,parentMenu}
        )
        skynetUpdateDisplay({ IADSObjectIndex,'contacts',showContactsOption })
        skynetUpdateDisplay({ IADSObjectIndex,'IADSStatus',showStatusOption })
    end
    debug_msg(string.format("IADS - Spawn IADS : %s-[%s] DONE", iadsName, difficulty))
    manageIADSNetworkMenu(parentMenu,iadsConfig,IADSObjectIndex)
    MESSAGE:NewType(string.format("IADS - IADS Units %s-[%s] in place", iadsName, difficulty), MESSAGE.Type.Information):ToCoalition(iadsConfig.benefit_coalition)
end

function deleteIADSNetwork(param)
    local iadsConfig = param[1]
    local IADSObjectIndex = param[2]
    local networkRootMenu = param[3]
    local iadsName = iadsConfig.name
    local nodesConfig = iadsConfig.nodes
    local skynetIADSObject = IADSArray[IADSObjectIndex].IADSObject
    local difficultyArray = {"easy","medium","hard","extreme"}

    if (skynetIADSObject ~= nil) then
        deactivateSkynet({ iadsConfig, IADSObjectIndex, networkRootMenu })
    end
    for index, difficulty in ipairs(difficultyArray) do
        param[4] = difficulty
        deleteIADSUnits(param)
    end
    IADSArray[IADSObjectIndex].IADSNetworkRunning = false
    MESSAGE:NewType(string.format("IADS - Remove IADS : %s", iadsName), MESSAGE.Type.Information):ToCoalition(iadsConfig.benefit_coalition)
    manageIADSNetworkMenu(networkRootMenu, iadsConfig, IADSObjectIndex)
end

function deactivateSkynet(param)
    local iadsConfig = param[1]
    local IADSObjectIndex = param[2]
    local parentMenu = param[3]

    IADSArray[IADSObjectIndex].IADSObject:deactivate()
    IADSArray[IADSObjectIndex].IADSNetworkRunning = false

    manageIADSNetworkMenu(parentMenu, iadsConfig, IADSObjectIndex)
    MESSAGE:NewType(string.format("IADS - Skynet of %s is desactivated", iadsConfig.name), MESSAGE.Type.Information):ToCoalition(iadsConfig.benefit_coalition)
end

function skynetUpdateDisplay(param)
    local IADSObjectIndex = param[1]
    local option =  param[2]
    local value =   param[3]

    IADSArray[IADSObjectIndex].IADSObject.updateDisplay({
        option =  option,
        self = IADSArray[IADSObjectIndex].IADSObject,
        value = value
    })
end

function activateGCI(param)
    local iadsConfig = param[1]
    local IADSObjectIndex = param[2]
    local parentMenu = param[3]
    debug_msg(string.format("IADS - GCI activation for %s", iadsConfig.name))

    DetectionSetGroup = SET_GROUP:New()
    IADSArray[IADSObjectIndex].IADSObject:addMooseSetGroup(DetectionSetGroup)
    Detection = DETECTION_AREAS:New( DetectionSetGroup, 30000 )
    A2ADispatcher = AI_A2A_DISPATCHER:New( Detection )
    A2ADispatcher:SetEngageRadius() -- 100000 is the default value.
    A2ADispatcher:SetGciRadius(100000)
    CCCPBorderZone = ZONE_POLYGON:New( iadsConfig.gci_border , GROUP:FindByName( iadsConfig.gci_border ) )
    A2ADispatcher:SetBorderZone( CCCPBorderZone )

    A2ADispatcher:SetDefaultTakeoffFromRunway()
    A2ADispatcher:SetDefaultLandingAtRunway()

    for index, gci_group in ipairs(iadsConfig.gci) do
        gci_group_name = string.format("GCI_%s", gci_group.airport)
        debug_msg(string.format("IADS - GCI - Group %s", gci_group_name))
        A2ADispatcher:SetSquadron( gci_group_name,    gci_group.airport, gci_group.templatePrefixes, gci_group.numberOfAircraftAvailable )
        A2ADispatcher:SetSquadronGci( gci_group_name, 1000, 3000 )
    end
end

function activateSkynet(param)
    local iadsConfig = param[1]
    local IADSObjectIndex = param[2]
    local parentMenu = param[3]
    local difficultyArray = {"easy","medium","hard","extreme"}
    debug_msg(string.format("IADS - Skynet activation for %s", iadsConfig.name))
    -- create an instance of the IADS
    IADSArray[IADSObjectIndex].IADSObject = SkynetIADS:create(iadsConfig.name)

    ---debug settings remove from here on if you do not wan't any output on what the IADS is doing by default
    local iadsDebug = IADSArray[IADSObjectIndex].IADSObject:getDebugSettings()
    iadsDebug.IADSStatus = DEBUG_MSG
    iadsDebug.radarWentDark = DEBUG_MSG
    iadsDebug.contacts = DEBUG_MSG
    iadsDebug.radarWentLive = DEBUG_MSG
    iadsDebug.noWorkingCommmandCenter = DEBUG_MSG
    iadsDebug.ewRadarNoConnection = DEBUG_MSG
    iadsDebug.samNoConnection = DEBUG_MSG
    iadsDebug.jammerProbability = DEBUG_MSG
    iadsDebug.addedEWRadar = DEBUG_MSG
    iadsDebug.hasNoPower = DEBUG_MSG
    iadsDebug.harmDefence = DEBUG_MSG
    iadsDebug.samSiteStatusEnvOutput = DEBUG_MSG
    iadsDebug.earlyWarningRadarStatusEnvOutput = DEBUG_MSG
    iadsDebug.commandCenterStatusEnvOutput = DEBUG_MSG
    ---end remove debug ---

    -- add a command center:
    for index, headQuarter in ipairs(iadsConfig.headQuarter) do
        local commandCenter = StaticObject.getByName(headQuarter)
        IADSArray[IADSObjectIndex].IADSObject:addCommandCenter(commandCenter)
    end

    for index, node in ipairs(iadsConfig.nodes) do
        debug_msg(string.format("IADS - Connection Node %s", node.connection))
        local connectionNode = StaticObject.getByName(node.connection)
        for index, ewr in ipairs(node.ewrs) do
            if (ewr ~= nil and connectionNode ~= nil) then
                debug_msg(string.format("IADS - EWR Unit name in config file : %s", ewr))
                local set_ewr_units = SET_UNIT:New():FilterPrefixes(ewr):FilterOnce()
                set_ewr_units:ForEachUnit(function(ewr_alive)
                    if ewr_alive:IsAlive() then
                        debug_msg(string.format("IADS - Alive EWR Unit name found %s", ewr_alive:Name()))
                        IADSArray[IADSObjectIndex].IADSObject:addEarlyWarningRadar(ewr_alive:Name())
                        IADSArray[IADSObjectIndex].IADSObject:getEarlyWarningRadarByUnitName(ewr_alive:Name()):addConnectionNode(connectionNode)
                    end
                end)
            end
        end
        for indexdiff, difficulty in ipairs(difficultyArray) do
            if IADSArray[IADSObjectIndex].spawned[difficulty] then
                for siteIndex, site in ipairs(node.sites[difficulty]) do
                    if (site ~= nil and connectionNode ~= nil) then
                        if (type(site) == "string") then
                            debug_msg(string.format("IADS - Sam Group name in config file :  %s", site))
                            local set_group_alive = SET_GROUP:New():FilterPrefixes(site):FilterOnce()
                            set_group_alive:ForEachGroupAlive(function(group_alive)
                                debug_msg(string.format("IADS - Alive Sam Group found %s", group_alive:GetName()))
                                attachSAMSiteToSkynet(site, group_alive:GetName(), IADSObjectIndex, node.connection)
                            end)
                        elseif (type(site) == "table") then
                            debug_msg(string.format("IADS - Sam Group name in config file :  %s", site.sam))
                            local set_group_alive = SET_GROUP:New():FilterPrefixes(site.sam):FilterOnce()
                            set_group_alive:ForEachGroupAlive(function(samGroupAlive)
                                debug_msg(string.format("IADS - Alive Sam Group found %s", samGroupAlive:GetName()))
                                attachSAMSiteToSkynet(site, samGroupAlive:GetName(), IADSObjectIndex, node.connection)
                                if (type(site.pointDefenses) == "string") then
                                    local set_pdgroup_alive = SET_GROUP:New():FilterPrefixes(site.pointDefenses):FilterOnce()
                                    set_pdgroup_alive:ForEachGroupAlive(function(pdGroupAlive)
                                        debug_msg(string.format("IADS - Alive Point Defense Sam Group found %s", pdGroupAlive:GetName()))
                                        attachPdSiteToSkynet(site,pdGroupAlive:GetName(), samGroupAlive:GetName(), IADSObjectIndex, node.connection)
                                    end)
                                elseif (type(site.pointDefenses) == "table") then
                                    for pdIndex, pdSamGroupName in ipairs(site.pointDefenses) do
                                        debug_msg(string.format("IADS - Point Defense Sam Group name in config file :  %s", pdSamGroupName))
                                        local set_pdgroup_alive = SET_GROUP:New():FilterPrefixes(pdSamGroupName):FilterOnce()
                                        set_pdgroup_alive:ForEachGroupAlive(function(pdGroupAlive)
                                            debug_msg(string.format("IADS - Alive Point Defense Sam Group found %s", pdGroupAlive:GetName()))
                                            attachPdSiteToSkynet(site,pdGroupAlive:GetName(), samGroupAlive:GetName(), IADSObjectIndex, node.connection)
                                        end)
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
    end

    -- activate the radio menu to toggle IADS Status output
    --if (iadsConfig.radioMenu) then
    --    debug_msg(string.format("IADS - Add radio menu %s", iadsConfig.name))
    --    IADSArray[IADSObjectIndex].IADSObject:addRadioMenu()
    --end

    -- activate the IADS
    IADSArray[IADSObjectIndex].IADSObject:activate()
    IADSArray[IADSObjectIndex].IADSNetworkRunning = true

    manageIADSNetworkMenu(parentMenu, iadsConfig, IADSObjectIndex)
    MESSAGE:NewType(string.format("Skynet of %s activate in 60 secondes", iadsConfig.name), MESSAGE.Type.Information):ToCoalition(iadsConfig.benefit_coalition)
end

function deleteIADSUnits(param)
    local iadsConfig = param[1]
    local IADSObjectIndex = param[2]
    local parentMenu = param[3]
    local difficulty = param[4]
    local iadsName = iadsConfig.name
    local nodesConfig = iadsConfig.nodes
    local difficultyArray = {"easy","medium","hard","extreme"}
    local difficultiesAlreadySpawned = 0
    for indexdiff, currentdifficulty in ipairs(difficultyArray) do
        if (IADSArray[IADSObjectIndex].spawned[currentdifficulty]) then
            difficultiesAlreadySpawned = difficultiesAlreadySpawned + 1
        end
    end

    for index, nodeConfig in ipairs(nodesConfig) do
        local ewrList = nodeConfig.ewrs
        if (difficultiesAlreadySpawned <= 1) then
            for index, ewrGroup in ipairs(ewrList) do
                local groupNameToDelete = string.format("%s", ewrGroup)
                destroyGroup(groupNameToDelete)
            end
        end
        local sitesList = nodeConfig.sites[difficulty]
        for siteindex, site in ipairs(sitesList) do
            if (type(site) == "string") then
                local groupNameToDelete = string.format("%s", site)
                destroyGroup(groupNameToDelete)
            elseif (type(site) == "table") then
                local groupNameToDelete = string.format("%s", site.sam)
                destroyGroup(groupNameToDelete)
            end
            if (type(site.pointDefenses) == "string") then
                local groupNameToDelete = string.format("%s", site.pointDefenses)
                destroyGroup(groupNameToDelete)
            elseif (type(site.pointDefenses) == "table") then
                for pdIndex, pdSamGroupName in ipairs(site.pointDefenses) do
                    local groupNameToDelete = string.format("%s", pdSamGroupName)
                    destroyGroup(groupNameToDelete)
                end
            end
        end
    end
    IADSArray[IADSObjectIndex].spawned[difficulty] = false
    if (IADSArray[IADSObjectIndex].IADSNetworkRunning) then
        local showStatusOption = IADSArray[IADSObjectIndex].IADSObject:getDebugSettings().IADSStatus
        local showContactsOption = IADSArray[IADSObjectIndex].IADSObject:getDebugSettings().contacts
        deactivateSkynet(
                {iadsConfig, IADSObjectIndex,parentMenu}
        )
        activateSkynet(
                {iadsConfig, IADSObjectIndex,parentMenu}
        )
        skynetUpdateDisplay({ IADSObjectIndex,'contacts',showContactsOption })
        skynetUpdateDisplay({ IADSObjectIndex,'IADSStatus',showStatusOption })
    end
    manageIADSNetworkMenu(parentMenu,iadsConfig,IADSObjectIndex)
end

function manageIADSNetworkMenu(networkRootMenu, iadsconfig, IADSObjectIndex)
    local difficultyArray = {"easy","medium","hard","extreme"}
    local anyDifficultySpawned = false
    local skynetIADSObject = IADSArray[IADSObjectIndex].IADSObject
    for index, difficulty in ipairs(difficultyArray) do
        anyDifficultySpawned = anyDifficultySpawned or IADSArray[IADSObjectIndex].spawned[difficulty]
    end
    networkRootMenu:RemoveSubMenus()
    if (anyDifficultySpawned) then
        --Il y a au moins 1 groupe de difficulté spawné : on affiche les menus skynet Ad-Hoc
        local CommandIADSDetroy = MENU_MISSION_COMMAND:New(
                "[Whole IADS Network] Delete",
                networkRootMenu,
                deleteIADSNetwork,
                { iadsconfig, IADSObjectIndex, networkRootMenu }
        )
        if (IADSArray[IADSObjectIndex].IADSNetworkRunning) then
            --Le reseau tourne déjà, on affiche le menu de desactivation du reseau et les menus de troubleshooting
            local CommandIADSShowStatus = MENU_MISSION_COMMAND:New(
                    "Show IADS Status",
                    networkRootMenu,
                    skynetUpdateDisplay,
                    { IADSObjectIndex, 'IADSStatus', true }
            )
            local CommandIADSHideStatus = MENU_MISSION_COMMAND:New(
                    "Hide IADS Status",
                    networkRootMenu,
                    skynetUpdateDisplay,
                    { IADSObjectIndex, 'IADSStatus', false }
            )
            local CommandIADSShowContacts = MENU_MISSION_COMMAND:New(
                    "Show contacts",
                    networkRootMenu,
                    skynetUpdateDisplay,
                    { IADSObjectIndex, 'contacts', true }
            )
            local CommandIADSHideContacts = MENU_MISSION_COMMAND:New(
                    "Hide contacts",
                    networkRootMenu,
                    skynetUpdateDisplay,
                    { IADSObjectIndex, 'contacts', false }
            )
            local CommandIADSDisable = MENU_MISSION_COMMAND:New(
                    "Disable Skynet",
                    networkRootMenu,
                    deactivateSkynet,
                    { iadsconfig, IADSObjectIndex, networkRootMenu }
            )
            --TODO: A tweaker pour que les objets skynets seront basés sur la coalition et non sur la mission globale
            if (type(iadsconfig.gci) == "table") then
                local CommandGCIActivate = MENU_MISSION_COMMAND:New(
                        "GCI Activation",
                        networkRootMenu,
                        activateGCI,
                        { iadsconfig, IADSObjectIndex, networkRootMenu }
                )
            end
        else
            --On affiche le menu d activation skynet
            local CommandIADSActivate = MENU_MISSION_COMMAND:New("Skynet Activation",
                    networkRootMenu, activateSkynet, { iadsconfig, IADSObjectIndex, networkRootMenu })
        end
    end
    for index, difficulty in ipairs(difficultyArray) do
        if IADSArray[IADSObjectIndex].spawned[difficulty] then
            local CommandIADSDetroyEasy = MENU_MISSION_COMMAND:New(
                    "[" .. difficulty .. "] Delete",
                    networkRootMenu,
                    deleteIADSUnits,
                    { iadsconfig, IADSObjectIndex, networkRootMenu, difficulty }
            )
        else
            local isThereSomethingToSpawn = false
            for indexnodes, nodeconfig in ipairs(iadsconfig.nodes) do
                local tbl_json_txt = net.lua2json(nodeconfig.sites[difficulty])
                --debug_msg(string.format('IADS: network=%s node=%s difficulty=%s sites config=%s', iadsconfig.name, nodeconfig.connection, difficulty, tbl_json_txt))
                local difficultySiteNumberToSpawn = 0
                for indexsite, siteconfig in ipairs(nodeconfig.sites[difficulty]) do
                    difficultySiteNumberToSpawn = indexsite
                    if indexsite >= 1 then
                        isThereSomethingToSpawn = true
                    end
                end
                debug_msg(string.format('IADS - network=%s node=%s difficulty=%s sites number=%d', iadsconfig.name, nodeconfig.connection, difficulty, difficultySiteNumberToSpawn))
            end
            if isThereSomethingToSpawn then
                local RadioCommandAddDifficulty = MENU_MISSION_COMMAND:New(
                        "[" .. difficulty .. "] Spawn",
                        networkRootMenu,
                        SpawnIADSDelayed,
                        { networkRootMenu, iadsconfig, IADSObjectIndex, spawnStandardDelay, difficulty}
                )
            end
        end
    end
end

function addExtraSamTypeDB()
    samTypesDB['FPS-117'] = {
        ['type'] = 'ewr',
        ['searchRadar'] = {
            ['FPS-117'] = {
                ['name'] = {
                    ['NATO'] = 'Seek Igloo',
                },
            },
        },
        ['harm_detection_chance'] = 60
    }
    samTypesDB['FPS-117 Dome'] = {
        ['type'] = 'ewr',
        ['searchRadar'] = {
            ['FPS-117 Dome'] = {
                ['name'] = {
                    ['NATO'] = 'Seek Igloo',
                },
            },
        },
        ['harm_detection_chance'] = 60
    }
    samTypesDB['EWR P-37 BAR LOCK'] = {
        ['type'] = 'ewr',
        ['searchRadar'] = {
            ['EWR P-37 BAR LOCK'] = {
                ['name'] = {
                    ['NATO'] = 'Bar lock',
                },
            },
        },

        ['harm_detection_chance'] = 60
    }
    samTypesDB['EWR 55G6U NEBO-U'] = {
        ['type'] = 'ewr',
        ['searchRadar'] = {
            ['EWR 55G6U NEBO-U'] = {
                ['name'] = {
                    ['NATO'] = 'Nebo-U',
                },
            },
        },

        ['harm_detection_chance'] = 65
    }
    samTypesDB['EWR 1L119 Nebo-SVU'] = {
        ['type'] = 'ewr',
        ['searchRadar'] = {
            ['EWR 1L119 Nebo-SVU'] = {
                ['name'] = {
                    ['NATO'] = 'Nebo-SVU',
                },
            },
        },

        ['harm_detection_chance'] = 75
    }
    samTypesDB['EWR Generic radar tower'] = {
        ['type'] = 'ewr',
        ['searchRadar'] = {
            ['EWR Generic radar tower'] = {
                ['name'] = {
                    ['NATO'] = 'EWR Generic radar tower',
                },
            },
        },
        ['harm_detection_chance'] = 60
    }

end

IADSArray = {}
compteur = 0
mainRadioMenuForSkynet =  MENU_MISSION:New("Skynet-IADS", nil )
addExtraSamTypeDB()
for index, skynetconfig in ipairs(SkynetConfig) do
    if ( skynetconfig.enable ) then
        compteur = compteur + 1
        env.info('Ajout menu radio pour IADS Skynet : '.. skynetconfig.name..'...')
        IADSArray[compteur] = {
            customconfig = skynetconfig,
            IADSObject = nil,
            spawned = {
                easy = false,
                medium = false,
                hard = false,
                extreme = false,
            },
            IADSNetworkRunning = false,
            radioMenuForSkynet = MENU_MISSION:New(skynetconfig.name , mainRadioMenuForSkynet)
        }
        manageIADSNetworkMenu(IADSArray[compteur].radioMenuForSkynet, skynetconfig, compteur)
    end
end
