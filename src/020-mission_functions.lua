-- *****************************************************************************
-- *                           Mission functions                               *
-- *****************************************************************************


--
-- Generic Spawn object functions
--
env.info('JTFF-SHAREDLIB: shared library loading...')

DEBUG_MSG = false
DEBUG_SQ_MSG = false
DEBUG_DETECT_MSG = false

spawnStandardDelay = 15

sead = SEAD:New({})
map_marker = {}

AAMAxRange = {
    MAX_RANGE = 0,
    NEZ_RANGE = 1,
    HALF_WAY_RMAX_NEZ = 2,
    TARGET_THREAT_EST = 3,
    RANDOM_RANGE = 4,
}


function debug_msg(message)
    if DEBUG_MSG then
        env.info(string.format("[DEBUG] %s", message))
    end
end

function debug_detection_msg(message)
    if DEBUG_DETECT_MSG then
        env.info(string.format("[DETECTION] %s", message))
    end
end

function debug_squeduler_msg(message)
    if DEBUG_SQ_MSG then
        env.info(string.format("[DEBUG SQ] %s", message))
    end
end

function switchGroupImmortalStatus(group)
    status = not BASE:GetState(group, "isImmortal")
    debug_msg(string.format("switch group %s to immortal status %s", group:GetName(), tostring(status)))
    group:SetCommandImmortal(status)
    BASE:SetState(group, "isImmortal", status)
    MESSAGE:NewType("Immortal status of your group : " .. tostring(status) , MESSAGE.Type.Update):ToGroup(group)
end

function switchGroupAirbossSubtitlesStatus(group)
    for index, airbossObject in ipairs(AIRBOSSArray) do
        for playerindex, player in ipairs(group:GetPlayerUnits()) do
            airbossObject:_SubtitlesOnOff(player:Name())
        end
    end
end

function give_bra_of_air_group(param)
    local target_group = param[1]
    local client_group = param[2]
    local settings = param[3]
    local coordinate_target = target_group:GetCoordinate()
    local coordinate_client = client_group:GetCoordinate()
    return string.format ("%s, %s",
            coordinate_target:ToStringBRA(coordinate_client, settings),
            coordinate_target:ToStringAspect(coordinate_client)
    )
end

function give_heading_speed(param)
    local target_group = param[1]
    local settings = param[2]
    local heading_target = target_group:GetHeading()
    local speed_target = target_group:GetVelocityKNOTS()
    if (settings:IsMetric()) then
        speed_target = target_group:GetVelocityKMH()
        return string.format (
                "Heading : %.0f, Speed : %.0f km/h",
                heading_target,
                speed_target
        )
    end
    return string.format (
            "Heading : %.0f, Speed : %.0f kt",
            heading_target,
            speed_target
    )
end

function tankerStatusMessage(tanker, PlayerUnit, PlayerGroup)
    local client = CLIENT:Find(PlayerUnit:GetDCSObject())
    local setting =  _DATABASE:GetPlayerSettings(client:GetPlayerName())

    local tankerrefuelsystemName = "BOOM"
    if playerrefuelsystem == 0 then
        tankerrefuelsystemName = "PROBE"
    end
    local braa_message = give_bra_of_air_group({tanker:GetGroup(), PlayerGroup, setting})
    local aspect_message = give_heading_speed({tanker:GetGroup(), setting})
    local fuelState = string.format("%s Lbs", tanker:GetTemplateFuel() * 2.205)
    if setting:IsMetric() then
        fuelState = string.format("%s Kg", tanker:GetTemplateFuel())
    end

    local timeInTheAir = 0
    local timeLeftInTheAir = 0
    local timeLeftString = "Time left : "
    local groupName = tanker:GetName()
    for index, value in pairs(tankersArray) do
        debug_msg(string.format("%s spawned at %i", value.tanker.GroupName, value.spawnAbsTime))
        if (string.find(groupName, value.tanker.GroupName, 1, true) ~= nil) then
            timeInTheAir = timer.getAbsTime() - value.spawnAbsTime
            timeLeftInTheAir = value.customconfig.missionmaxduration * 60 - timeInTheAir
            if (UTILS.SecondsToClock(timeLeftInTheAir, true) ~= nil) then
                timeLeftString = timeLeftString .. UTILS.SecondsToClock(timeLeftInTheAir, true)
            end
            debug_msg(string.format("%s found in %s, time in the air : %i sec, time left %i sec",
                    value.tanker.GroupName, groupName, timeInTheAir, timeLeftInTheAir))
        else
            debug_msg(string.format("%s not found in %s", value.tanker.GroupName, groupName))
        end
    end

    for index, value in pairs(tankersOnDemandArray) do
        if( value ~= nil) then
            debug_msg(string.format("%s spawned in tankersOnDemandArray", value:GetName()))
            if (string.find(groupName, value:GetName(), 1, true) ~= nil) then
                timeInTheAir = timer.getAbsTime() - value.spawnAbsTime
                timeLeftInTheAir = value.missionmaxduration * 60 - timeInTheAir
                if (UTILS.SecondsToClock(timeLeftInTheAir, true) ~= nil) then
                    timeLeftString = timeLeftString .. UTILS.SecondsToClock(timeLeftInTheAir, true)
                end
                debug_msg(string.format("%s found in %s, time in the air : %i sec, time left %i sec",
                        value:GetName(), groupName, timeInTheAir, timeLeftInTheAir))
            else
                debug_msg(string.format("%s not found in %s", value:GetName(), groupName))
            end
        end
    end

    local message = string.format("%s %s [%s]\nFuel State %s (%.2f)\n%s\n%s\n%s", tanker:GetName(),
            tanker:GetTypeName(), tankerrefuelsystemName, fuelState, tanker:GetFuel() * 100, aspect_message, braa_message,
            timeLeftString)
    MESSAGE:NewType(message, MESSAGE.Type.Overview):ToGroup(PlayerGroup)
end

function findNearestTanker(PlayerUnit, PlayerGroup, Radius)

    Radius=UTILS.NMToMeters(Radius or 50)

    local isrefuelable, playerrefuelsystem=PlayerUnit:IsRefuelable()
    if isrefuelable then
        local coord=PlayerUnit:GetCoordinate()
        local units=coord:ScanUnits(Radius)
        local coalition=PlayerUnit:GetCoalition()

        local dmin = math.huge
        local tanker = nil --Wrapper.Unit#UNIT
        for _,_unit in pairs(units.Set) do
            local unit = _unit --Wrapper.Unit#UNIT
            local istanker, tankerrefuelsystem=unit:IsTanker()
            if istanker and
                    playerrefuelsystem == tankerrefuelsystem and
                    coalition == unit:GetCoalition() and
                    unit:IsAlive() then

                -- Distance.
                local d = unit:GetCoordinate():Get2DDistance(coord)
                if d < dmin then
                    d = dmin
                    tanker=unit
                end
            end
        end

        tankerStatusMessage(tanker, PlayerUnit, PlayerGroup)
    end
    return nil
end

function findAllTanker(PlayerUnit, PlayerGroup, Radius)

    Radius=UTILS.NMToMeters(Radius or 50)

    local isrefuelable, playerrefuelsystem=PlayerUnit:IsRefuelable()
    if isrefuelable then

        local coord = PlayerUnit:GetCoordinate()
        local units = coord:ScanUnits(Radius)
        local coalition = PlayerUnit:GetCoalition()

        local tanker = nil --Wrapper.Unit#UNIT
        for _,_unit in pairs(units.Set) do
            local unit=_unit --Wrapper.Unit#UNIT
            local istanker, tankerrefuelsystem=unit:IsTanker()
            if istanker and
                    playerrefuelsystem == tankerrefuelsystem and
                    coalition == unit:GetCoalition() and
                    unit:IsAlive() then
                tanker=unit
                tankerStatusMessage(tanker, PlayerUnit, PlayerGroup)
            end
        end
    end
    return nil
end

function NearestTankerInfo(param)
    findNearestTanker(
            param[1],
            param[2],
            200
    )
end

function AllTankersInfo(param)
    findAllTanker(param[1],param[2], 200)
end

function taskTankerEscort(param)
    local recoveryTankerObject = param[1]
    local EscortGroup = param[2]
    EscortGroup:OptionAlarmStateRed()
    EscortGroup:OptionROEReturnFire()
    --EscortGroup:TraceOn()
    EscortGroup:OptionRTBAmmo(true)
    EscortGroup:OptionRTBBingoFuel(true)
    local randomCoord = EscortGroup
            :GetCoordinate()
            :GetRandomCoordinateInRadius( UTILS.NMToMeters(20), UTILS.NMToMeters(15) )
    randomCoord.y = UTILS.FeetToMeters(15000)
    --randomCoord:MarkToAll('rejointe '..EscortGroup.GroupName)
    EscortGroup:Route(
            {
                randomCoord:WaypointAirTurningPoint(
                        COORDINATE.WaypointAltType.BARO,
                        500,
                        {},
                        'rejoin'
                ),
                randomCoord:GetRandomCoordinateInRadius( UTILS.NMToMeters(20), UTILS.NMToMeters(15) ):WaypointAirTurningPoint(
                        COORDINATE.WaypointAltType.BARO,
                        500,
                        {
                            EscortGroup:TaskEscort(
                                    GROUP:FindByName(recoveryTankerObject.tanker.GroupName),
                                    POINT_VEC3:New(0, 10, 150):GetVec3(),
                                    20,
                                    UTILS.NMToMeters(40),
                                    { 'Air' }
                            )
                        },
                        'escort-start'
                )
            }
    )
    env.info('Escort group spawned : '.. EscortGroup.GroupName..'. Escorting '..recoveryTankerObject.tanker.GroupName)
end

function taskGroupEscort(param)
    local GroupToEscortObject = param[1]
    local EscortingGroup = param[2]
    EscortingGroup:OptionAlarmStateRed()
    EscortingGroup:OptionROEReturnFire()
    --EscortGroup:TraceOn()
    EscortingGroup:OptionRTBAmmo(true)
    EscortingGroup:OptionRTBBingoFuel(true)
    local randomCoord = EscortingGroup
            :GetCoordinate()
            :GetRandomCoordinateInRadius( UTILS.NMToMeters(20), UTILS.NMToMeters(15) )
    randomCoord.y = UTILS.FeetToMeters(15000)
    --randomCoord:MarkToAll('rejointe '..EscortGroup.GroupName)
    EscortingGroup:Route(
            {
                randomCoord:WaypointAirTurningPoint(
                        COORDINATE.WaypointAltType.BARO,
                        500,
                        {},
                        'rejoin'
                ),
                randomCoord:GetRandomCoordinateInRadius( UTILS.NMToMeters(20), UTILS.NMToMeters(15) ):WaypointAirTurningPoint(
                        COORDINATE.WaypointAltType.BARO,
                        500,
                        {
                            EscortingGroup:TaskEscort(
                                    GROUP:FindByName(GroupToEscortObject.GroupName),
                                    POINT_VEC3:New(0, 10, 150):GetVec3(),
                                    20,
                                    UTILS.NMToMeters(40),
                                    { 'Air' }
                            )
                        },
                        'escort-start'
                )
            }
    )
    env.info('Escort group spawned : '.. EscortingGroup.GroupName..'. Escorting '.. GroupToEscortObject.GroupName)
end

function spawnRecoveryTankerEscort(escortSpawnObject,customconfig)
    if (customconfig.airspawn) then
        return escortSpawnObject
                :SpawnFromCoordinate(UNIT:FindByName(customconfig.baseUnit):GetCoordinate():SetAltitude(UTILS.FeetToMeters(customconfig.altitude)))
    else
        return escortSpawnObject
                :SpawnAtAirbase(AIRBASE:FindByName(customconfig.baseUnit),SPAWN.Takeoff.Cold, customconfig.altitude)
    end
end

function LeaveRecovery(objAirboss)
    local shipID = UNIT:FindByName(objAirboss.carrier:Name()):GetDCSObject():getID()
end

function resetRecoveryTanker(recoveryTankerObject)
    recoveryTankerObject:SetRespawnOnOff(true)
    recoveryTankerObject.tanker:Destroy()
    recoveryTankerObject:SetRespawnOnOff(recoveryTankerObject.customconfig.autorespawn)
    if recoveryTankerObject.customconfig.escortgroupname then
        recoveryTankerObject.escortGroupObject:Destroy()
        --recoveryTankerObject.escortGroupObject = spawnRecoveryTankerEscort(recoveryTankerObject.escortSpawnObject,recoveryTankerObject.customconfig)
    end
end

function fctKillSpawnObject(objSpawn)
    local GroupPlane, Index = objSpawn:GetFirstAliveGroup()
    while GroupPlane ~= nil do
        -- Do actions with the GroupPlane object.
        GroupPlane:Destroy(true)
        GroupPlane, Index = objSpawn:GetNextAliveGroup( Index )
    end
end

function getMaxThreatUnit(setUnits)
    local setUnitsSorted = SET_UNIT:New()
    setUnits:ForEachUnitPerThreatLevel(10, 0, function(unit)
        setUnitsSorted:AddUnit(unit)
    end)
    debug_msg(string.format("Max priority unit : %s", setUnitsSorted:GetFirst():GetName()))
    return setUnitsSorted:GetFirst()
end

function destroyGroup(group_name)
    local set_group_alive = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
    set_group_alive:ForEachGroupAlive(
            function(group_alive)
                debug_msg(string.format("Group %s just removed", group_alive:GetName()))
                if (map_marker[group_alive:GetName()]) then
                    COORDINATE:RemoveMark(map_marker[group_alive:GetName()])
                end
                group_alive:Destroy()
            end )
end

function destroyStatic(staticToDelete, subRangeName, index)
    if (staticToDelete.name ~= nil) then
        local staticNameToDelete = string.format("%s", staticToDelete.name)
        if (subRangeName ~= nil and index ~= nil) then
            staticNameToDelete = string.format("%s_%s_%i", subRangeName, staticToDelete.name, index)
        end
        local staticUnitToDelete = STATIC:FindByName(staticNameToDelete, false)
        if (staticUnitToDelete ~= nil) then
            debug_msg(string.format("Delete static %s", staticUnitToDelete:GetDCSObject():getName()))
            staticUnitToDelete:Destroy()
        end
    elseif (staticToDelete.type ~= nil and staticToDelete.category ~= nil and index ~= nil) then
        local staticNameToDelete = string.format("%s_%s_%i", subRangeName, staticToDelete.type, index)
        local staticUnitToDelete = STATIC:FindByName(staticNameToDelete, false)
        if (staticUnitToDelete ~= nil) then
            debug_msg(string.format("Delete Static %s", staticUnitToDelete:GetDCSObject():getName()))
            staticUnitToDelete:Destroy()
        end
    else
        debug_msg(string.format("Static to delete has no name or type!"))
    end
end

function destroyStatics(staticsToDelete, subRangeName)
    for index, staticToDelete in ipairs(staticsToDelete) do
        destroyStatic(staticToDelete, subRangeName, index)
    end
end

function deleteSubRangeUnits(param)
    --parameters :
    --           1 : groups to be destroyed
    --           2 : Root range config Object
    --           3 : sub (or subsub) Range Config Object
    --           4 : sub (or subsub) Radio Menu
    --           5 : mute switch
    local groupsToSpawn = param[1]
    local rangeConfig = param[2]
    local subRangeConfig = param[3]
    local radioCommandSubRange = param[4]
    local blnMute = param[5]
    for i = 1, #groupsToSpawn do
        destroyGroup(groupsToSpawn[i])
    end

    local subRangeName = subRangeConfig.name
    local staticsToDelete = subRangeConfig.staticsToSpawn
    if (staticsToDelete ~= nil)then
        destroyStatics(staticsToDelete, subRangeName)
    else
        debug_msg(string.format("No static in %s", subRangeName))
    end

    MESSAGE:NewType(string.format("Remove the site : %s-%s", rangeConfig.name, subRangeConfig.name),
            MESSAGE.Type.Information):ToBlue()
    if (not(blnMute)) then
        sound2Bip:ToAll()
    end
    if radioCommandSubRange then
        radioCommandSubRange:RemoveSubMenus()
        addSubRangeRadioMenus(radioCommandSubRange, rangeConfig, subRangeConfig)
    end
end

function deleteWholeRangeUnits(param)
    local rangeConfig = param[1]
    local rangeCoalitionMenu = param[2]
    rangeCoalitionMenu:RemoveSubMenus()
    if (rangeConfig.subRange ~= nil ) then
        sound2Bip:ToAll()
        MESSAGE:NewType(string.format("Removing the whole site : %s", rangeConfig.name),
                MESSAGE.Type.Information):ToCoalition(rangeConfig.benefit_coalition)
        for subIndex, subRangeConfig in ipairs(rangeConfig.subRange) do
            local radioMenuSubRange = MENU_COALITION:New(rangeConfig.benefit_coalition, subRangeConfig.name, rangeCoalitionMenu)
            if (subRangeConfig.subsubRange ~= nil) then
                for subsubIndex, subsubRangeConfig in ipairs(subRangeConfig.subsubRange) do
                    local radioMenuSubSubRange     = MENU_COALITION:New(rangeConfig.benefit_coalition, subsubRangeConfig.name, radioMenuSubRange)
                    deleteSubRangeUnits({
                        subsubRangeConfig.groupsToSpawn,
                        rangeConfig,
                        subsubRangeConfig,
                        nil,
                        true
                    })
                    addSubRangeRadioMenus(radioMenuSubSubRange, rangeConfig, subsubRangeConfig)
                end
            else
                deleteSubRangeUnits({
                    subRangeConfig.groupsToSpawn,
                    rangeConfig,
                    subRangeConfig,
                    nil,
                    true
                })
                addSubRangeRadioMenus(radioMenuSubRange, rangeConfig, subRangeConfig)
            end
        end
    end
    AddWholeRangeCoalitionCommandMenus(rangeCoalitionMenu, rangeConfig)
end

function setROE(param)
    local groupsToSpawn = param[1]
    local ROEvalue = param[2]
    for groupIndex = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[groupIndex])
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("SET ROE of group %s at %i", group_alive:GetName(), ROEvalue))
            if (ROEvalue ~= ENUMS.ROE.WeaponHold) then
                group_alive:SetAIOn()
            end
            group_alive:OptionROE(ROEvalue)
        end)
    end
end

function setAlarmState(param)
    local groupsToSpawn = param[1]
    local AlarmStateValue = param[2]
    for groupIndex = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[groupIndex])
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            group_alive:SetAIOn()
            if AlarmStateValue == ENUMS.AlarmState.Auto then
                debug_msg(string.format("SET Alarm State of group %s at AUTO", group_alive:GetName()))
                group_alive:OptionAlarmStateAuto()
            elseif AlarmStateValue == ENUMS.AlarmState.Green then
                debug_msg(string.format("SET Alarm State of group %s at Green", group_alive:GetName()))
                group_alive:OptionAlarmStateGreen()
            elseif AlarmStateValue == ENUMS.AlarmState.Red then
                debug_msg(string.format("SET Alarm State of group %s at Red", group_alive:GetName()))
                group_alive:OptionAlarmStateRed()
            end
        end)
    end
end

function setEngageAirWeapons(param)
    local groupsToSpawn = param[1]
    local value = param[2]
    for groupIndex = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[groupIndex])
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("SET Engage Air Weapons of group %s at %s", group_alive:GetName(), tostring(value)))
            if (value) then
                group_alive:SetAIOn()
            end
            group_alive:SetOption(AI.Option.Ground.id.ENGAGE_AIR_WEAPONS, value)
        end)
    end
end

function smokeOnSubRange(param)
    local groupsToSpawn = param[1]
    local displayToCoalition = param[2]
    for groupIndex = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[groupIndex])
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("Smoke on group %s", group_alive:GetName()))
            local list_units = group_alive:GetUnits()
            local set_units_red = SET_UNIT:New()
            local set_units_blue = SET_UNIT:New()
            for index = 1, #list_units do
                local unit_tmp = list_units[index]
                if (unit_tmp:IsAlive() and unit_tmp:GetCoalition() == coalition.side.RED) then
                    set_units_red:AddUnit(unit_tmp)
                end
            end
            if (set_units_red:CountAlive() > 0) then
                local unit_red_to_smoke = getMaxThreatUnit(set_units_red)
                if (unit_red_to_smoke) then
                    unit_red_to_smoke:SmokeRed()
                    MESSAGE:NewType(string.format("[%s] Red smoke on : %s", group_alive:GetName(),
                            unit_red_to_smoke:GetTypeName()), MESSAGE.Type.Overview):ToCoalition(displayToCoalition)
                end
            elseif (set_units_blue:CountAlive() > 0) then
                local unit_blue_to_smoke = getMaxThreatUnit(set_units_blue)
                if (unit_blue_to_smoke) then
                    unit_blue_to_smoke:SmokeBlue()
                    MESSAGE:NewType(string.format("[%s] Blue smoke on : %s", group_alive:GetName(),
                            unit_blue_to_smoke:GetTypeName()), MESSAGE.Type.Overview):ToCoalition(displayToCoalition)
                end
            end
        end)
    end
end

function giveToClientGroupCoordinates(param)
    local groupsToSpawn = param[1]
    for i = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[i])
        debug_msg(string.format("Coordinates of all groups with name prefix %s", group_name))
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        Set_CLIENT:ForEachClient(function(client)
            if (client:IsActive()) then
                debug_msg(string.format("For Client %s ", client:GetName()))
                local coordinate_txt = ""
                dcs_groups:ForEachGroupAlive(function(group_alive)
                    debug_msg(string.format("Coordinates of the group %s", group_alive:GetName()))
                    local coordinate = group_alive:GetCoordinate()
                    local setting = _DATABASE:GetPlayerSettings(client:GetPlayerName())
                    local coordinate_string = ""
                    if (setting:IsA2G_LL_DDM()) then
                        coordinate_string = coordinate:ToStringLLDDM(setting)
                        debug_msg(string.format("%s IsA2G_LL_DDM", client:GetName()))
                    elseif (setting:IsA2G_MGRS()) then
                        coordinate_string = coordinate:ToStringMGRS(setting)
                        debug_msg(string.format("%s IsA2G_MGRS", client:GetName()))
                    elseif (setting:IsA2G_LL_DMS()) then
                        coordinate_string = coordinate:ToStringLLDMS(setting)
                        debug_msg(string.format("%s IsA2G_LL_DMS", client:GetName()))
                    elseif (setting:IsA2G_BR()) then
                        coordinate_string = coordinate:ToStringBR(client:GetCoordinate(), setting)
                        debug_msg(string.format("%s IsA2G_BR", client:GetName()))
                    end
                    debug_msg(string.format("coordinate_txt [%s] : %s", group_alive:GetName(), coordinate_string))
                    coordinate_txt = string.format("%s[%s] : %s\n", coordinate_txt, group_alive:GetName(),
                            coordinate_string)
                end)
                debug_msg(string.format("Message to Client %s : %s", client:GetName(), coordinate_txt))
                MESSAGE:NewType(coordinate_txt, MESSAGE.Type.Detailed):ToClient(client)
            end
        end)
    end
end

function giveListOfGroupsAliveInRange(param)
    local groupsToSpawn = param[1]
    local rangeConfig = param[2]
    local subRangeConfig = param[3]
    debug_msg(string.format("List of groups in range %s-%s", rangeConfig.name, subRangeConfig.name))
    local message = string.format("Targets groups in Range %s-%s :", rangeConfig.name, subRangeConfig.name)
    for i = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[i])
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("group %s", group_alive:GetName()))
            message = string.format("%s %s | ", message, group_alive:GetName());
        end)
    end
    Set_CLIENT:ForEachClient(function(client)
        if (client:IsActive()) then
            MESSAGE:NewType(message, MESSAGE.Type.Information):ToClient(client)
        end
    end)
end

function giveListOfUnitsAliveInGroup(param)
    local groupsToSpawn = param[1]
    local side = param[2]
    local number_to_display = param[3]
    for i = 1, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[i])
        debug_msg(string.format("List of units of all groups with name prefix %s", group_name))
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("List of units of the group %s", group_alive:GetName()))
            local info_unit_header = string.format("Units list of the group [%s]:", group_name)
            Set_CLIENT:ForEachClient(function(client)
                if (client:IsActive()) then
                    MESSAGE:NewType(info_unit_header, MESSAGE.Type.Overview):ToClient(client)
                end
            end)
            local list_units = group_alive:GetUnits()
            local set_units = SET_UNIT:New()
            for index = 1, #list_units do
                local unit_tmp = list_units[index]
                if (unit_tmp:IsAlive() and unit_tmp:GetCoalition() ~= side) then
                    set_units:AddUnit(unit_tmp)
                    debug_msg(string.format("Type : %s", unit_tmp:GetTypeName()))
                end
            end
            local increment = 0;
            set_units:ForEachUnitPerThreatLevel(10, 0, function(unit_tmp)
                if (increment < number_to_display) then
                    local unit_life_pourcentage = (unit_tmp:GetLife() / (unit_tmp:GetLife0() + 1)) * 100
                    local unit_coordinate = unit_tmp:GetCoordinate()
                    local unit_altitude_m = unit_tmp:GetAltitude()
                    local unit_coordinate_for_client = ""
                    local unit_altitude_for_client = 0
                    local unit_altitude_for_client_unit = ""
                    Set_CLIENT:ForEachClient(function(client)
                        if (client:IsActive()) then
                            local setting = _DATABASE:GetPlayerSettings(client:GetPlayerName())
                            unit_coordinate_for_client = ""
                            if (setting:IsA2G_LL_DDM()) then
                                unit_coordinate_for_client = unit_coordinate:ToStringLLDDM(setting)
                            elseif (setting:IsA2G_MGRS()) then
                                unit_coordinate_for_client = unit_coordinate:ToStringMGRS(setting)
                            elseif (setting:IsA2G_LL_DMS()) then
                                unit_coordinate_for_client = unit_coordinate:ToStringLLDMS(setting)
                            elseif (setting:IsA2G_BR()) then
                                unit_coordinate_for_client = unit_coordinate:ToStringBR(client:GetCoordinate(), setting)
                            end
                            if (setting:IsImperial()) then
                                unit_altitude_for_client = UTILS.MetersToFeet(unit_altitude_m)
                                unit_altitude_for_client_unit = "ft"
                            elseif (setting:IsMetric()) then
                                unit_altitude_for_client = unit_altitude_m
                                unit_altitude_for_client_unit = "m"
                            end
                            local info_unit_tmp = string.format("[%i] %s (%i", unit_tmp:GetThreatLevel(),
                                    unit_tmp:GetTypeName(), unit_life_pourcentage) .. '%),\t' .. unit_coordinate_for_client ..
                                    string.format("\tAlt: %.0f%s", unit_altitude_for_client,
                                            unit_altitude_for_client_unit)
                            MESSAGE:NewType(info_unit_tmp, MESSAGE.Type.Overview):ToClient(client)
                        end
                    end)
                    increment = increment + 1;
                end
            end)
        end)
    end
end

function markGroupOnMap(param)
    local groupsToSpawn = param[1]
    local side = param[2]
    for i = 2, #groupsToSpawn do
        local group_name = string.format("%s", groupsToSpawn[i])
        debug_msg(string.format("Mark on map all groups with name prefix %s", group_name))
        local dcs_groups = SET_GROUP:New():FilterPrefixes(group_name):FilterOnce()
        dcs_groups:ForEachGroupAlive(function(group_alive)
            debug_msg(string.format("Mark on map the group %s", group_alive:GetName()))
            local coordinate = group_alive:GetCoordinate()
            map_marker[group_alive:GetName()] = coordinate:MarkToCoalition(group_alive:GetName(), side)
        end)
    end
end

function SpawnRangesDelay(param)
    --parameters :
    --           1 : parent Radio Menu
    --           2 : Root range config Object
    --           3 : subRange config Object
    --           4 : delay in s before sub (or subsub) range spawn
    --           5 : function calling me (No Idea why we need that)
    --           6 : boolean for sound warning play
    --           7 : boolean for message warning
    local rangeConfig = param[2]
    local subRangeConfig = param[3]
    local delay = param[4] or spawnStandardDelay
    local myfunc = param[5]
    local sound_warning = true
    if (type(param[6]) ~= nil) then
        sound_warning = param[6]
    end
    local message_warning = true
    if (type(param[7]) ~= nil) then
        message_warning = param[7]
    end
    if ( sound_warning ) then
        sound2Bip:ToAll()
    end
    if ( message_warning ) then
        MESSAGE:NewType(string.format("Warning, Range Units %s(%s) will spawn in %d sec", rangeConfig.name, subRangeConfig.name, delay), MESSAGE.Type.Update):ToAll()
    end
    TIMER:New(SpawnRanges, param):Start(delay)
end

function SpawnWholeRangesDelay(param)
    --parameters :
    --           1 : parent Radio Menu
    --           2 : Root range config Object
    --           3 : delay in s before sub (or subsub) range spawn
    --           4 : function calling me (No Idea why we need that)
    --           5 : boolean for sound warning play
    --           6 : boolean for message warning
    local parentRangeMenu = param[1]
    local rangeConfig = param[2]
    local delay = param[3] or spawnStandardDelay
    local myfunc = param[4]
    local sound_warning = true
    if (type(param[5]) ~= nil) then
        sound_warning = param[5]
    end
    local message_warning = true
    if (type(param[6]) ~= nil) then
        message_warning = param[6]
    end
    parentRangeMenu:RemoveSubMenus()
    if (rangeConfig.subRange) then
        sound2Bip:ToAll()
        for subIndex, subRangeConfig in ipairs(rangeConfig.subRange) do
            local radioMenuSubRange     = MENU_COALITION:New(
                    rangeConfig.benefit_coalition,
                    subRangeConfig.name,
                    parentRangeMenu
            )
            if (subRangeConfig.subsubRange) then
                for subsubIndex, subsubRangeConfig in ipairs(subRangeConfig.subsubRange) do
                    local radioMenuSubSubRange     = MENU_COALITION:New(
                            rangeConfig.benefit_coalition,
                            subsubRangeConfig.name,
                            radioMenuSubRange
                    )
                    SpawnRangesDelay(
                            {
                                radioMenuSubSubRange,
                                rangeConfig,
                                subsubRangeConfig,
                                delay,
                                myfunc,
                                sound_warning,
                                message_warning
                            }
                    )
                end
            else
                SpawnRangesDelay(
                        {
                            radioMenuSubRange,
                            rangeConfig,
                            subRangeConfig,
                            delay,
                            myfunc,
                            sound_warning,
                            message_warning
                        }
                )
            end
        end
        local CommandZoneDetroy = MENU_COALITION_COMMAND:New(
                rangeConfig.benefit_coalition,
                "Delete whole Range",
                parentRangeMenu,
                deleteWholeRangeUnits,
                {
                    rangeConfig,
                    parentRangeMenu
                }
        )
    end
end

function SpawnRanges(param)
    --parameters :
    --           1 : parent Radio Menu
    --           2 : Root range config Object
    --           3 : subRange config Object

    local radioCommandSubRange = param[1]
    local rangeConfig = param[2]
    local rangeName = rangeConfig.name
    local subRangeConfig = param[3]
    local subRangeName = subRangeConfig.name
    local groupsToSpawn = subRangeConfig.groupsToSpawn
    local staticsToSpawn = subRangeConfig.staticsToSpawn
    local holdFire = subRangeConfig.holdFire
    local engageAirWeapons = subRangeConfig.engageAirWeapons
    local activateAI = subRangeConfig.AI
    local redAlert = subRangeConfig.redAlert

    debug_msg(string.format("SpawnRanges : Range %s - Targets %s", rangeName, subRangeName))
    if (staticsToSpawn ~= nil)then
        for index, staticToSpawn in ipairs(staticsToSpawn) do
            local spawnStatic = nil
            if (staticToSpawn.name ~= nil) then
                local staticNameToSpawn = string.format("%s", staticToSpawn.name)
                spawnStatic = SPAWNSTATIC:NewFromStatic(staticNameToSpawn)
                if (staticToSpawn.coalition ~= nil) then
                    if (staticToSpawn.coalition == coalition.side.BLUE) then
                        spawnStatic = SPAWNSTATIC:NewFromStatic(staticNameToSpawn, country.id.CJTF_BLUE)
                    elseif (staticToSpawn.coalition == coalition.side.RED) then
                        spawnStatic = SPAWNSTATIC:NewFromStatic(staticNameToSpawn, country.id.CJTF_RED)
                    else
                        spawnStatic = SPAWNSTATIC:NewFromStatic(staticNameToSpawn, country.id.UN_PEACEKEEPERS)
                    end
                end
                local x = staticToSpawn.x
                local y = staticToSpawn.y
                local heading = staticToSpawn.heading
                local name = string.format("%s_%s_%i", subRangeName, staticNameToSpawn,index)
                local static = spawnStatic:SpawnFromPointVec2( POINT_VEC2:New( x, y ), heading, name )
                debug_msg(string.format("Static to spawn %s at %i,%i -> %s", static:GetDCSObject():getTypeName(), x, y, static:GetDCSObject():getName()))
            elseif (staticToSpawn.type ~= nil and staticToSpawn.category ~= nil) then
                local staticTypeToSpawn = string.format("%s", staticToSpawn.type)
                local staticCategoryToSpawn = string.format("%s", staticToSpawn.category)
                spawnStatic = SPAWNSTATIC:NewFromType(staticTypeToSpawn, staticCategoryToSpawn)
                if (staticToSpawn.coalition ~= nil) then
                    if (staticToSpawn.coalition == coalition.side.BLUE) then
                        spawnStatic = SPAWNSTATIC:NewFromType(staticTypeToSpawn, staticCategoryToSpawn, country.id.CJTF_BLUE)
                    elseif (staticToSpawn.coalition == coalition.side.RED) then
                        spawnStatic = SPAWNSTATIC:NewFromType(staticTypeToSpawn, staticCategoryToSpawn, country.id.CJTF_RED)
                    else
                        spawnStatic = SPAWNSTATIC:NewFromType(staticTypeToSpawn, staticCategoryToSpawn, country.id.UN_PEACEKEEPERS)
                    end
                end
                local x = staticToSpawn.x
                local y = staticToSpawn.y
                local heading = staticToSpawn.heading
                local name = string.format("%s_%s_%i", subRangeName, staticTypeToSpawn, index)
                local static = spawnStatic:SpawnFromPointVec2( POINT_VEC2:New( x, y ), heading, name )
                debug_msg(string.format("Static type to spawn %s at %i,%i -> %s", static:GetDCSObject():getTypeName(), x, y, static:GetDCSObject():getName()))
            else
                debug_msg(string.format("Static to spawn has no name or type!"))
            end
        end
    else
        debug_msg(string.format("No static in %s", subRangeName))
    end

    for i = 1, #groupsToSpawn do
        local groupNameToSpawn = string.format("%s", groupsToSpawn[i])
        if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
            local spawnGroup = SPAWN:New(groupNameToSpawn)
            debug_msg(string.format("SPAWN %s", groupNameToSpawn))
            local groupSpawning
            if (subRangeConfig.spawnZone) then
                groupSpawning = spawnGroup:SpawnInZone(ZONE:New(subRangeConfig.spawnZone),true)
            else
                groupSpawning = spawnGroup:Spawn()
            end
            if (holdFire) then
                groupSpawning:OptionROEHoldFire()
            else
                groupSpawning:OptionROEOpenFire()
            end
            if (engageAirWeapons) then
                groupSpawning:SetOption(AI.Option.Ground.id.ENGAGE_AIR_WEAPONS, true)
            end
            if (activateAI == true or activateAI == false) then
                groupSpawning:SetAIOnOff(activateAI)
            end
            if (redAlert == true or redAlert == false) then
                if (redAlert == true) then
                    groupSpawning:OptionAlarmStateRed()
                else
                    groupSpawning:OptionAlarmStateGreen()
                end
            else
                groupSpawning:OptionAlarmStateAuto()
            end
            if (string.find(groupNameToSpawn, "SAM") ~= nil) then
                sead:UpdateSet(groupNameToSpawn)
                debug_msg(string.format("SEAD for %s", groupNameToSpawn))
            end
        else
            debug_msg(string.format("GROUP to spawn %s not found in mission", groupNameToSpawn))
        end
    end

    radioCommandSubRange:RemoveSubMenus()
    local CommandZoneDetroy = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Delete", radioCommandSubRange,
            deleteSubRangeUnits, {groupsToSpawn, rangeConfig, subRangeConfig, radioCommandSubRange, true})
    local ROE = MENU_COALITION:New(rangeConfig.benefit_coalition, "ROE", radioCommandSubRange)
    local ROEOpenFire = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Open Fire", ROE, setROE,
            {groupsToSpawn, ENUMS.ROE.OpenFire})
    local ROEReturnFire = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Return Fire", ROE, setROE,
            {groupsToSpawn, ENUMS.ROE.ReturnFire})
    local ROEHoldFire = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Hold Fire", ROE, setROE,
            {groupsToSpawn, ENUMS.ROE.WeaponHold})
    local AlarmState = MENU_COALITION:New(rangeConfig.benefit_coalition, "Alarm State", radioCommandSubRange)
    local AlarmStateAuto = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Auto", AlarmState, setAlarmState,
            {groupsToSpawn, ENUMS.AlarmState.Auto})
    local AlarmStateGreen = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Green", AlarmState, setAlarmState,
            {groupsToSpawn, ENUMS.AlarmState.Green})
    local AlarmStateRed = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Red", AlarmState, setAlarmState,
            {groupsToSpawn, ENUMS.AlarmState.Red})
    local Engage_Air_Weapons = MENU_COALITION:New(rangeConfig.benefit_coalition, "Engage Air Weapons", radioCommandSubRange)
    local Engage_Air_Weapons_True = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "True", Engage_Air_Weapons, setEngageAirWeapons,
            {groupsToSpawn, true})
    local Engage_Air_Weapons_False = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "False", Engage_Air_Weapons, setEngageAirWeapons,
            {groupsToSpawn, false})
    local CommandZoneFumigene = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Smoke", radioCommandSubRange,
            smokeOnSubRange, {groupsToSpawn, rangeConfig.benefit_coalition})
    local CommandZoneCoord = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "Coordinates",
            radioCommandSubRange, giveToClientGroupCoordinates, {groupsToSpawn})
    local CommandZoneListGroup = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "List Groups",
            radioCommandSubRange, giveListOfGroupsAliveInRange, {groupsToSpawn, rangeConfig, subRangeConfig})
    local CommandZoneList = MENU_COALITION_COMMAND:New(rangeConfig.benefit_coalition, "List Units",
            radioCommandSubRange, giveListOfUnitsAliveInGroup, {groupsToSpawn, rangeConfig.benefit_coalition, 5})
    MESSAGE:NewType(string.format("Units in range %s(%s) in place", rangeName, subRangeName), MESSAGE.Type.Information)
           :ToCoalition(rangeConfig.benefit_coalition)
    markGroupOnMap({groupsToSpawn, rangeConfig.benefit_coalition})
end

function SpawnFacRangesDelay(param)
    local facRangeConfig = param[2]
    local facSubRangeConfig = param[3]
    local delay = param[4] or 10
    MESSAGE:NewType(string.format("Warning, FAC in range %s(%s) will spawn in %d sec", facRangeConfig.name, facSubRangeConfig.name, delay), MESSAGE.Type.Update):ToBlue()
    TIMER:New(SpawnFacRanges, param):Start(delay)
end

function SpawnFacRanges(param)
    local radioCommandSubRange = param[1]
    local facRangeConfig = param[2]
    local facRangeName = facRangeConfig.name
    local facSubRangeConfig = param[3]
    local facSubRangeName = facSubRangeConfig.name
    local groupsToSpawn = facSubRangeConfig.groupsToSpawn
    local staticsToSpawn = facSubRangeConfig.staticsToSpawn

    debug_msg(string.format("SpawnFacRanges : %s-%s", facRangeName, facSubRangeName))
    for i = 1, #groupsToSpawn do
        local groupNameToSpawn = string.format("%s", groupsToSpawn[i])
        if (GROUP:FindByName(groupNameToSpawn) ~= nil) then
            local spawnGroup = SPAWN:New(groupNameToSpawn)
            debug_msg(string.format("SPAWN %s", groupNameToSpawn))
            local groupSpawning
            if (facSubRangeConfig.spawnZone) then
                groupSpawning = spawnGroup:SpawnInZone(ZONE:New(facSubRangeConfig.spawnZone),true)
            else
                groupSpawning = spawnGroup:Spawn()
            end
            groupSpawning:SetCommandInvisible(true)
        else
            debug_msg(string.format("GROUP to spawn %s not found in mission", groupNameToSpawn))
        end
    end

    radioCommandSubRange:RemoveSubMenus()
    local CommandZoneDetroy = MENU_COALITION_COMMAND:New(facRangeConfig.benefit_coalition, "Delete", radioCommandSubRange,
            deleteSubRangeUnits, { groupsToSpawn, facRangeConfig, facSubRangeConfig, radioCommandSubRange, true})
    local CommandZoneFumigene = MENU_COALITION_COMMAND:New(facRangeConfig.benefit_coalition, "Smoke", radioCommandSubRange,
            smokeOnSubRange, { groupsToSpawn, facRangeConfig.benefit_coalition})
    local CommandZoneCoord = MENU_COALITION_COMMAND:New(facRangeConfig.benefit_coalition, "Coordinates",
            radioCommandSubRange, giveToClientGroupCoordinates, {groupsToSpawn})
    local CommandZoneListGroup = MENU_COALITION_COMMAND:New(facRangeConfig.benefit_coalition, "List Groups",
            radioCommandSubRange, giveListOfGroupsAliveInRange, { groupsToSpawn, facRangeConfig, facSubRangeConfig })
    local CommandZoneList = MENU_COALITION_COMMAND:New(facRangeConfig.benefit_coalition, "List Units",
            radioCommandSubRange, giveListOfUnitsAliveInGroup, { groupsToSpawn, facRangeConfig.benefit_coalition, 5})
    MESSAGE:NewType(string.format("FAC in range %s(%s) in place", facRangeName, facSubRangeName), MESSAGE.Type.Information)
           :ToBlue()
    markGroupOnMap({ groupsToSpawn, facRangeConfig.benefit_coalition})
end

function addSubRangeRadioMenus(radioCommandSubRange, rangeConfig, subRangeConfig)
    local RadioCommandAdd = MENU_COALITION_COMMAND:New(
            rangeConfig.benefit_coalition,
            "Spawn",
            radioCommandSubRange,
            SpawnRangesDelay,
            {
                radioCommandSubRange,
                rangeConfig,
                subRangeConfig,
                spawnStandardDelay,
                addSubRangeRadioMenus
            }
    )
end

function AddWholeRangeCoalitionCommandMenus(radioCommandRange, rangeConfig)
    local AddWholeRangeCommand = MENU_COALITION_COMMAND:New(
            rangeConfig.benefit_coalition,
            "Spawn Whole Range",
            radioCommandRange,
            SpawnWholeRangesDelay,
            {
                radioCommandRange,
                rangeConfig,
                spawnStandardDelay,
                AddWholeRangeCoalitionCommandMenus
            }
    )
    local DeleteWholeRangeCommand = MENU_COALITION_COMMAND:New(
            rangeConfig.benefit_coalition,
            "Delete whole Range",
            radioCommandRange,
            deleteWholeRangeUnits,
            {
                rangeConfig,
                radioCommandRange
            }
    )
    return {AddWholeRangeCommand, DeleteWholeRangeCommand}
end

function AddFacFunction(radioCommandSubRange, facRangeConfig, facSubRangeConfig)
    local RadioCommandAdd = MENU_COALITION_COMMAND:New(
            facRangeConfig.benefit_coalition,
            "Spawn",
            radioCommandSubRange,
            SpawnFacRangesDelay,
            {
                radioCommandSubRange,
                facRangeConfig,
                facSubRangeConfig,
                spawnStandardDelay,
                AddFacFunction
            }
    )
end

function GetTableLng(tbl)
    local getN = 0
    for n in pairs(tbl) do
        getN = getN + 1
    end
    return getN
end

function findJTFFSoundModulePath()
    -- **** Do not forget to inject a trailing slash ****
    --TODO: try to detect if JTFF-Missions-Sound Mod is present or not
    local userprofilepath = os.getenv("userprofile"):gsub("\\", "/")
    local savedgamespath = userprofilepath .. '/Saved Games'
    local dcsfoldername = 'DCS.openbeta'
    return savedgamespath .. '/' .. dcsfoldername .. '/Sounds/JTFF-Missions/'
end

function getSoundFilesPrefix()
    local strPrefix
    if (use_jtff_sound_mod) then
        strPrefix = findJTFFSoundModulePath()
    else
        strPrefix = ""
    end
    return strPrefix
end


soundFilesPrefix = getSoundFilesPrefix()


env.info('JTFF-SHAREDLIB: shared library loaded succesfully')
