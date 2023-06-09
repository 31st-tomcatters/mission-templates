-- *****************************************************************************
--                     **                 OnDemand AFACs                      **
--                     *********************************************************
function triggerOnDemandReaper(type, askedLaserCode, askedDuration, askedFL, askedSpeed, askedAnchorCoord)
    local ReaperGroup = nil
    if (OnDemandReapersConfig) then
        for index, OnDemandReaper in ipairs(OnDemandReapersConfig) do
            if ((OnDemandReaper.type == type) and (OnDemandReaper.enable)) then
                debug_msg(string.format('OnDemandUAV : Found type %s UAV : %s Group!', type, OnDemandReaper.groupName))
                if (askedSpeed and askedSpeed > 0) then
                    OnDemandReaper.speed = askedSpeed
                end
                if (askedFL and askedFL > 0) then
                    OnDemandReaper.altitude = askedFL * 100
                end
                if (askedLaserCode and askedLaserCode > 0) then
                    OnDemandReaper.laserCode = askedLaserCode
                end
                if ( askedDuration == nil or askedDuration == 0 ) then
                    askedDuration = 120
                end
                local set_group_reaper = SET_GROUP:New()
                                                  :FilterActive()
                                                  :FilterPrefixes(OnDemandReaper.groupName)
                                                  :FilterCategories("plane")
                                                  :FilterOnce()
                local aliveReapersGroupList = set_group_reaper:GetSetObjects()

                local is_reaper_spawned = false
                debug_msg(string.format('OnDemandUAV : Looking for a Group corresponding to template %s', string.format("%s-%s", OnDemandReaper.groupName, OnDemandReaper.type)))
                for index, current_group in ipairs(aliveReapersGroupList) do
                    if (
                            (not(is_reaper_spawned)) and
                                    (string.find(
                                            current_group.GroupName,
                                            string.format("%s-%s", OnDemandReaper.groupName, OnDemandReaper.type),
                                            1,
                                            true
                                    ) ~= nil)
                    ) then
                        debug_msg(string.format('OnDemandUAV Found %s corresponding to template %s', current_group.GroupName, string.format("%s-%s", OnDemandReaper.groupName, OnDemandReaper.type)))
                        is_reaper_spawned = true
                        ReaperGroup = current_group
                    end
                end

                local RTBAirbase = nil
                local ReaperRoute = {}
                if (OnDemandReaper.baseUnit) then
                    RTBAirbase = AIRBASE:FindByName(OnDemandReaper.baseUnit)
                else
                    RTBAirbase = askedAnchorCoord:GetClosestAirbase2(Airbase.Category.AIRDROME, OnDemandReaper.benefit_coalition)
                end
                if (is_reaper_spawned) then
                    debug_msg(string.format('OnDemandUAV already in air : rerouting %s', OnDemandReaper.groupName))
                    ReaperGroup:ClearTasks()
                    table.insert(
                            ReaperRoute,
                            askedAnchorCoord
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandReaper.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandReaper.speed),
                                    {
                                        --{
                                        --    id = 'Tanker',
                                        --    params = {
                                        --    }
                                        --},
                                        {
                                            id = 'ControlledTask',
                                            params = {
                                                task =
                                                {
                                                    id = 'Orbit',
                                                    params = {
                                                        pattern = AI.Task.OrbitPattern.CIRCLE,
                                                        speed = UTILS.KnotsToMps(OnDemandReaper.speed),
                                                        altitude = UTILS.FeetToMeters(OnDemandReaper.altitude)
                                                    }
                                                },
                                                stopCondition = {
                                                    duration = askedDuration * 60
                                                }
                                            },
                                        },
                                    },
                                    "Orbit Start"
                            )
                    )
                    table.insert(
                            ReaperRoute,
                            RTBAirbase
                                    :GetCoordinate()
                                    :WaypointAirLanding(
                                    UTILS.KnotsToKmph(OnDemandReaper.speed),
                                    RTBAirbase
                            )
                    )
                else
                    debug_msg(string.format('OnDemandUAV Spawning %s', OnDemandReaper.groupName))
                    local SpawnReaper = SPAWN:NewWithAlias(
                            OnDemandReaper.groupName,
                            string.format("%s-%s", OnDemandReaper.groupName, OnDemandReaper.type)
                    )
                    if (OnDemandReaper.freq) then
                        SpawnReaper:InitRadioFrequency(OnDemandReaper.freq)
                        SpawnReaper:InitRadioModulation("AM")
                    end
                    if (OnDemandReaper.modex) then
                        SpawnReaper:InitModex(OnDemandReaper.modex)
                    end
                    if (OnDemandReaper.baseUnit) then
                        ReaperGroup = SpawnReaper:SpawnAtAirbase(
                                AIRBASE:FindByName(OnDemandReaper.baseUnit),
                                SPAWN.Takeoff.Hot,
                                nil,
                                OnDemandReaper.terminalType
                        )
                        table.insert(ReaperRoute,
                                AIRBASE
                                        :FindByName(OnDemandReaper.baseUnit)
                                        :GetCoordinate()
                                        :WaypointAirTakeOffParkingHot()
                        )
                    else
                        ReaperGroup = SpawnReaper:SpawnFromCoordinate(
                                askedAnchorCoord
                                        :GetRandomCoordinateInRadius(
                                        UTILS.NMToMeters(5),
                                        UTILS.NMToMeters(2)
                                )
                                        :SetAltitude(
                                        UTILS.FeetToMeters(OnDemandReaper.altitude)
                                )
                        )
                    end
                    ReaperGroup.customconfig = OnDemandReaper
                    ReaperGroup.spawnAbsTime = timer.getAbsTime()
                    ReaperGroup.missionmaxduration = askedDuration
                    table.insert(ReaperRoute,
                            askedAnchorCoord
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandReaper.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandReaper.speed),
                                    {
                                        --{
                                        --    id = 'Tanker',
                                        --    params = {
                                        --    }
                                        --},
                                        {
                                            id = 'ControlledTask',
                                            params = {
                                                task =
                                                {
                                                    id = 'Orbit',
                                                    params = {
                                                        pattern = AI.Task.OrbitPattern.CIRCLE,
                                                        speed = UTILS.KnotsToMps(OnDemandReaper.speed),
                                                        altitude = UTILS.FeetToMeters(OnDemandReaper.altitude)
                                                    }
                                                },
                                                stopCondition = {
                                                    duration = askedDuration * 60
                                                }
                                            },
                                        },
                                    },
                                    "Orbit Start"
                            )
                    )
                    table.insert(ReaperRoute,
                            RTBAirbase
                                    :GetCoordinate()
                                    :WaypointAirLanding(
                                    UTILS.KnotsToKmph(OnDemandReaper.speed),
                                    RTBAirbase,
                                    {},
                                    'RTB'
                            )
                    )
                end
                ReaperGroup:Route(ReaperRoute)
                ReaperGroup:CommandEPLRS(true, 4)
                if (OnDemandReaper.tacan) then
                    ReaperGroup.beacon=BEACON:New(ReaperGroup:GetUnit(1))
                    ReaperGroup.beacon:ActivateTACAN(OnDemandReaper.tacan.channel, "Y", OnDemandReaper.tacan.morse, true)
                end
                if (OnDemandReaper.callsign) then
                    ReaperGroup:CommandSetCallsign(OnDemandReaper.callsign.name, OnDemandReaper.callsign.number, 2)
                end
                if OnDemandReaper.escortgroupname then
                    ReaperGroup.escortSpawnObject = SPAWN:NewWithAlias(OnDemandReaper.escortgroupname,'escort-'.. OnDemandReaper.groupName)
                                                         :InitRepeatOnEngineShutDown()
                                                         :InitSkill("Excellent")
                                                         :OnSpawnGroup(function(SpawnGroup)
                        taskGroupEscort({ ReaperGroup, SpawnGroup})
                    end)
                    ReaperGroup.escortGroupObject = spawnRecoveryTankerEscort(ReaperGroup.escortSpawnObject, OnDemandReaper)
                    if OnDemandReaper.missionmaxduration then
                        ReaperGroup.escortGroupObject:ScheduleOnce(OnDemandReaper.missionmaxduration*60,
                                function(SpawnGroup, airBaseName)
                                    --trigger.action.outText('RTB schedule trigger Reaper-escort group : '..(SpawnGroup.GroupName)..' airbase'..(airBaseName)..'...', 45)
                                    SpawnGroup:RouteRTB(AIRBASE:FindByName(airBaseName))
                                end,
                                ReaperGroup.escortGroupObject,
                                OnDemandReaper.baseUnit
                        )
                        --trigger.action.outText('UAV-escort configured to RTB in  : '..(OnDemandReaper.missionmaxduration)..' minutes max...', 45)
                    end
                end
                if (map_marker[ReaperGroup:GetName()]) then
                    COORDINATE:RemoveMark(map_marker[ReaperGroup:GetName()])
                end
                if(OnDemandReaper.tacan) then
                    map_marker[ReaperGroup:GetName()] = askedAnchorCoord:MarkToCoalition(
                            string.format(
                                    'OnDemandUAV %s - TCN %i\nLaserCode %i\nFL %i at %i knots\nFreq %.2f MHz\nOn station for %i minutes.',
                                    OnDemandReaper.type,
                                    OnDemandReaper.tacan.channel,
                                    OnDemandReaper.laserCode,
                                    UTILS.Round(OnDemandReaper.altitude / 100 , 0),
                                    OnDemandReaper.speed,
                                    OnDemandReaper.freq,
                                    askedDuration
                            ),
                            OnDemandReaper.benefit_coalition,
                            true,
                            'OnDemand Reaper %s is Activated'
                    )
                else
                    map_marker[ReaperGroup:GetName()] = askedAnchorCoord:MarkToCoalition(
                            string.format(
                                    'OnDemandUAV %s\nLaserCode %i\nFL %i at %i knots\nFreq %.2f MHz\nOn station for %i minutes.',
                                    OnDemandReaper.type,
                                    OnDemandReaper.laserCode,
                                    UTILS.Round(OnDemandReaper.altitude / 100 , 0),
                                    OnDemandReaper.speed,
                                    OnDemandReaper.freq,
                                    askedDuration
                            ),
                            OnDemandReaper.benefit_coalition,
                            true,
                            'OnDemand Reaper %s is Activated'
                    )
                end
                local reaperInfraIndex = 0
                for infra_index, reaper_object in ipairs(ReapersInfraArray) do
                    if (reaper_object.customconfig.type == OnDemandReaper.type) then
                        debug_msg(string.format("OnDemandUAV : Found infra %s for UAV %s", reaper_object.customconfig.type, ReaperGroup:GetName()))
                        reaperInfraIndex = infra_index
                    end
                end
                if (reaperInfraIndex > 0) then
                    local currentDesignateObject = nil
                    if (not(is_reaper_spawned)) then
                        local setGroupReaper = SET_GROUP:New()
                                                        :FilterPrefixes(ReaperGroup:GetName())
                                                        :FilterOnce()
                        local detectionReaper = DETECTION_AREAS:New(setGroupReaper, UTILS.NMToMeters(5))
                        debug_msg(string.format("OnDemandUAV : Detection Areas created for SET_GROUP %s with %d members", ReapersInfraArray[reaperInfraIndex].customconfig.groupName, setGroupReaper:Count()))
                        local reaperCommandCenter = COMMANDCENTER:New( ReapersInfraArray[reaperInfraIndex].HQGroup, OnDemandReaper.hq_template_name )
                        debug_msg(string.format("OnDemandUAV : Command Center %s created and operating", reaperCommandCenter:GetName()))
                        reaperCommandCenter.FlashStatus=DEBUG_DETECT_MSG and false
                        if (OnDemandReaper.benefit_coalition == coalition.side.BLUE) then
                            currentDesignateObject = DESIGNATE:New( reaperCommandCenter, detectionReaper, SET_GROUP:New():FilterCoalitions("blue"):FilterStart())
                        else
                            currentDesignateObject = DESIGNATE:New( reaperCommandCenter, detectionReaper, SET_GROUP:New():FilterCoalitions("red"):FilterStart())
                        end
                    end
                    currentDesignateObject:SetDesignateName(OnDemandReaper.type)
                    currentDesignateObject:SetLaserCodes( OnDemandReaper.laserCode )
                    currentDesignateObject:SetThreatLevelPrioritization(true)
                    currentDesignateObject:SetAutoLase(true)
                    currentDesignateObject:SetFlashStatusMenu( DEBUG_DETECT_MSG and false)
                    function currentDesignateObject:OnAfterDetect(From, Event, To)
                        local DetectedItems = self.Detection:GetDetectedItems()
                        debug_msg(string.format("OnDemandUAV : OnAfterDetect"))
                        if self.Detection:GetDetectedItemsCount() > 0 then
                            local DetectedItem = DetectedItems[1]
                            if self.RecceSet:GetFirst():GetUnit(1):IsLasing() then
                                debug_msg(string.format("OnDemandUAV : %s Spoting %s Unit", self.RecceSet:GetFirst():GetName(), self.RecceSet:GetFirst():GetUnit(1):GetSpot().TargetName))
                                --Spot.createInfraRed(self.RecceSet:GetFirst():GetUnit(1):GetDCSObject(), {x = 0, y = 1, z = 0}, UNIT:FindByName(self.RecceSet:GetFirst():GetUnit(1):GetSpot().TargetName):GetPointVec3():AddY(1):GetVec3())
                            end
                        end
                    end
                    ReapersInfraArray[reaperInfraIndex].Designate = currentDesignateObject
                end
                ReaperGroup:HandleEvent(EVENTS.Land)
                ReaperGroup:HandleEvent(EVENTS.Crash)
                ReaperGroup:HandleEvent(EVENTS.Dead)
                function ReaperGroup:OnEventLand(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                    if self.customconfig.escortgroupname then
                        env.info('UAV RTB: '..self.GroupName..'...')
                        if self.escortGroupObject:IsAirborne(false) == true then
                            env.info('escort RTB : '.. self.escortGroupObject.GroupName..' UAV : '..self.GroupName..'...')
                            self.escortGroupObject:RouteRTB()
                        else
                            --self.escortGroupObject:Destroy(nil, 5)
                        end
                    end
                end
                function ReaperGroup:OnEventCrash(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                    if self.customconfig.escortgroupname then
                        env.info('UAV RTB: '..self.GroupName..'...')
                        if self.escortGroupObject:IsAirborne(false) == true then
                            env.info('escort RTB : '.. self.escortGroupObject.GroupName..' UAV : '..self.GroupName..'...')
                            self.escortGroupObject:RouteRTB()
                        else
                            --self.escortGroupObject:Destroy(nil, 5)
                        end
                    end
                end
                function ReaperGroup:OnEventDead(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                    if self.customconfig.escortgroupname then
                        env.info('UAV RTB: '..self.GroupName..'...')
                        if self.escortGroupObject:IsAirborne(false) == true then
                            env.info('escort RTB : '.. self.escortGroupObject.GroupName..' UAV : '..self.GroupName..'...')
                            self.escortGroupObject:RouteRTB()
                        else
                            --self.escortGroupObject:Destroy(nil, 5)
                        end
                    end
                end
            end
        end
    end
    return ReaperGroup;
end

--local RestrToCoal = nil
reapersOnDemandArray = {}
local ReaperMarkHandler = {}
local CmdSymbol = "-"

function ReaperMarkHandler:onEvent(event)

    if event.id == 25 then
        --trigger.action.outText(" ", 0, true)
    elseif (event.id == 27 and string.find(event.text, CmdSymbol)) then
        --if (event.coalition == RestrToCoal or RestrToCoal == nil) then
        local full = nil
        local remString = nil
        local cmd = nil
        local param1 = nil
        local param1Start = nil
        local param2 = nil
        local param2Start = nil
        local param3 = nil
        local param3Start = nil
        local param4 = nil
        local param4Start = nil
        local param5 = nil
        local param5Start = nil
        local param6 = nil
        local param6Start = nil
        local mcoord = COORDINATE:New(event.pos.x, event.pos.y, event.pos.z)
        local mvec3 = event.pos

        full = string.sub(event.text, 2)

        if (string.find(full, CmdSymbol)) then
            param1Start = string.find(full, CmdSymbol)
            cmd = string.sub(full, 0, param1Start-1)
            remString = string.sub(full, param1Start+1)
            if (string.find(remString, CmdSymbol)) then
                param2Start = string.find(remString, CmdSymbol)
                param1 = string.sub(remString, 0, param2Start-1)
                remString = string.sub(remString, param2Start+1)
                if string.find(remString, CmdSymbol) then
                    param3Start = string.find(remString, CmdSymbol)
                    param2 = string.sub(remString, 0, param3Start-1)
                    remString = string.sub(remString, param3Start+1)
                    if string.find(remString, CmdSymbol) then
                        param4Start = string.find(remString, CmdSymbol)
                        param3 = string.sub(remString, 0, param4Start-1)
                        remString = string.sub(remString, param4Start+1)
                        if string.find(remString, CmdSymbol) then
                            param5Start = string.find(remString, CmdSymbol)
                            param4 = string.sub(remString, 0, param5Start-1)
                            remString = string.sub(remString, param5Start+1)
                            if string.find(remString, CmdSymbol) then
                                param6Start = string.find(remString, CmdSymbol)
                                param5 = string.sub(remString, 0, param6Start-1)
                                param6 = string.sub(remString, param6Start+1)
                            else
                                param5 = remString
                            end
                        else
                            param4 = remString
                        end
                    else
                        param3 = remString
                    end
                else
                    param2 = remString
                end
            else
                param1 = remString
            end
        else
            cmd = full
        end
        if DEBUG_MSG == true then
            trigger.action.outText("Full Text = " .. full, 10)
            trigger.action.outText("Command = " .. cmd, 10)
            if param1 ~= nil then trigger.action.outText("type = " .. param1, 10) end
            if param2 ~= nil then trigger.action.outText("LaserCode = " .. param2, 10) end
            if param3 ~= nil then trigger.action.outText("Duration = " .. param3, 10) end
            if param4 ~= nil then trigger.action.outText("FlightLevel = " .. param4, 10) end
            if param5 ~= nil then trigger.action.outText("Speed = " .. param5, 10) end
        end

        if string.find(cmd, "uav") then
            if DEBUG_MSG == true then
                trigger.action.outText("DEBUG: On UAV Started!", 10)
            end
            reapersOnDemandArray[#reapersOnDemandArray+1] = triggerOnDemandReaper(
                    param1,
                    tonumber(param2),
                    tonumber(param3),
                    tonumber(param4),
                    tonumber(param5),
                    mcoord
            )
        end
        --end
    end

end

world.addEventHandler(ReaperMarkHandler)

function SpawnReaperHQDelay(param)
    --parameters :
    --           1 : parent Radio Menu
    --           2 : reaper Object
    --           3 : delay in s before HQ spawns
    --           4 : function calling me (No Idea why we need that)
    --           5 : boolean for sound warning play
    --           6 : boolean for message warning
    local reaperObject = param[2]
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
    if ( sound_warning ) then
        sound2Bip:ToAll()
    end
    if ( message_warning ) then
        MESSAGE:NewType(string.format("Warning, Uav HQ Units %s will spawn in %d sec", reaperObject.customconfig.type, delay), MESSAGE.Type.Update):ToAll()
    end
    TIMER:New(SpawnReaperHQ, param):Start(delay)
end

function SpawnReaperHQ(param)
    --parameters :
    --           1 : parent Radio Menu
    --           2 : reaper Object

    local radioCommandReaper = param[1]
    local reaperObject = param[2]
    local reaperName = reaperObject.customconfig.type
    local reaperHQName = reaperObject.customconfig.hq_template_name

    debug_msg(string.format("OnDemandUAV : Reaper %s - HQ %s", reaperName, reaperHQName))
    if (GROUP:FindByName(reaperHQName) ~= nil) then
        reaperObject.HQSpawn = SPAWN:New(reaperHQName)
        debug_msg(string.format("SPAWN %s", reaperHQName))
        reaperObject.HQGroup = reaperObject.HQSpawn:Spawn()
    else
        debug_msg(string.format("GROUP to spawn %s not found in mission", reaperHQName))
    end
    MESSAGE:NewType(string.format("HQ group %s for %s UAV in place", reaperHQName, reaperName), MESSAGE.Type.Information)
           :ToCoalition(reaperObject.customconfig.benefit_coalition)
    --local coordinate = reaperObject.HQGroup:GetCoordinate()
    --map_marker[reaperObject.HQGroup:GetName()] = coordinate:MarkToCoalition(string.format("Reaper %s : HQ=%s", reaperName, reaperObject.HQGroup:GetName()), reaperObject.customconfig.benefit_coalition)
end

-- *****************************************************************************
--                     **                     AFACS Infra                     **
--                     *********************************************************

ReapersInfraArray = {}
local compteur = 0
--mainRadioMenuForReapersBlue =  MENU_COALITION:New( coalition.side.BLUE , "AFACs", MenuCoalitionBlue )
--mainRadioMenuForReapersRed =  MENU_COALITION:New( coalition.side.RED , "AFACs", MenuCoalitionRed )
for index, reapersconfig in ipairs(OnDemandReapersConfig) do
    if reapersconfig.enable == true then
        compteur = compteur + 1
        debug_msg(string.format("OnDemandUAV : %s creation HQ : %s", reapersconfig.type, reapersconfig.hq_template_name))
        ReapersInfraArray[compteur] = {
            customconfig = reapersconfig,
            ReaperRootMenu = {},
            HQGroup = {},
            HQSpawn = {},
            Designate = {}
        }
        if (reapersconfig.benefit_coalition == coalition.side.BLUE) then
            --ReapersInfraArray[compteur].ReaperRootMenu = MENU_COALITION:New( coalition.side.BLUE, reapersconfig.type , mainRadioMenuForReapersBlue)
        else
            --ReapersInfraArray[compteur].ReaperRootMenu = MENU_COALITION:New( coalition.side.RED, reapersconfig.type , mainRadioMenuForReapersRed)
        end
        SpawnReaperHQ({ ReapersInfraArray[compteur].ReaperRootMenu, ReapersInfraArray[compteur]})
    end
end

if compteur == 0 then
    --mainRadioMenuForReapersBlue:Remove()
    --mainRadioMenuForReapersRed:Remove()
end
