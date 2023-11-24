-- *****************************************************************************
--                     **                     Awacs                           **
--                     *********************************************************
AwacsArray = {}
compteur = 0
MenuCoalitionAwacsBlue = MENU_COALITION:New(coalition.side.BLUE, "Awacs", MenuCoalitionBlue)
MenuCoalitionAwacsRed = MENU_COALITION:New(coalition.side.RED, "Awacs", MenuCoalitionRed)
for index, awacsconfig in ipairs(AwacsConfig) do
    if awacsconfig.enable == true then
        compteur = compteur + 1
        env.info('creation AWACS : '.. awacsconfig.groupName..'...')
        local objAwacs = RECOVERYTANKER:New(UNIT:FindByName(awacsconfig.patternUnit), awacsconfig.groupName)
                                       :SetAWACS(true, true)
                                       :SetRespawnOnOff(awacsconfig.autorespawn)
                                       :SetLowFuelThreshold(awacsconfig.fuelwarninglevel)
                                       :SetAltitude(awacsconfig.altitude)
                                       :SetSpeed(awacsconfig.speed)
                                       :SetHomeBase(AIRBASE:FindByName(awacsconfig.baseUnit),awacsconfig.terminalType)
                                       :SetCallsign(awacsconfig.callsign.name, awacsconfig.callsign.number)
                                       :SetRecoveryAirboss(awacsconfig.airboss_recovery)
                                       :SetRadio(awacsconfig.freq)
                                       :SetModex(awacsconfig.modex)
                                       :SetRacetrackDistances(awacsconfig.racetrack.front, awacsconfig.racetrack.back)
        if (awacsconfig.airspawn) then
            objAwacs:SetTakeoffAir()
        else
            objAwacs:SetTakeoffCold()

        end
        if (awacsconfig.tacan) then
            objAwacs:SetTACAN(awacsconfig.tacan.channel , awacsconfig.tacan.morse)
        end
        objAwacs.customconfig = awacsconfig
        function objAwacs:OnAfterStart(from, event, to)
            env.info('popup AWACS : '..self.tanker.GroupName)
            if self.customconfig.escortgroupname then
                self.escortSpawnObject = SPAWN:NewWithAlias(self.customconfig.escortgroupname,'escort-'.. self.customconfig.groupName)
                                              :InitRepeatOnEngineShutDown()
                                              :InitSkill("Excellent")
                                              :OnSpawnGroup(function(SpawnGroup)
                    taskTankerEscort({self, SpawnGroup})
                end)
                self.escortGroupObject = spawnRecoveryTankerEscort(self.escortSpawnObject,self.customconfig)
                if self.customconfig.missionmaxduration then
                    self.escortGroupObject:ScheduleOnce(self.customconfig.missionmaxduration*60,
                            function(SpawnGroup, airBaseName)
                                --trigger.action.outText('RTB schedule trigger Tanker-escort group : '..(SpawnGroup.GroupName)..' airbase'..(airBaseName)..'...', 45)
                                SpawnGroup:RouteRTB(AIRBASE:FindByName(airBaseName))
                            end,
                            self.escortGroupObject,
                            self.customconfig.baseUnit
                    )
                    --trigger.action.outText('Tanker-escort configured to RTB in  : '..(self.customconfig.missionmaxduration)..' minutes max...', 45)
                end
            end
            if self.customconfig.missionmaxduration then
                (self.tanker):ScheduleOnce(self.customconfig.missionmaxduration*60,
                        function(tankerObject, airBaseName)
                            --trigger.action.outText('RTB schedule trigger AWACS group : '..(tankerObject.tanker.GroupName)..' airbase'..(tankerObject.customconfig.baseUnit)..'...', 45)
                            tankerObject:RTB(AIRBASE:FindByName(tankerObject.customconfig.baseUnit))
                        end,
                        self
                )
                --trigger.action.outText('AWACS configured to RTB in  : '..(self.customconfig.missionmaxduration)..' minutes max...', 45)
            end
            if (self.customconfig.benefit_coalition == coalition.side.RED) then
                self.menureset = MENU_COALITION_COMMAND:New(
                        coalition.side.RED,
                        "Reset AWACS "..self.customconfig.callsign.alias..'-'..self.customconfig.callsign.number..'-1',
                        MenuCoalitionAwacsRed,
                        resetRecoveryTanker,
                        self
                )
            else
                self.menureset = MENU_COALITION_COMMAND:New(
                        coalition.side.BLUE,
                        "Reset AWACS "..self.customconfig.callsign.alias..'-'..self.customconfig.callsign.number..'-1',
                        MenuCoalitionAwacsBlue,
                        resetRecoveryTanker,
                        self
                )
            end
        end
        function objAwacs:OnAfterRTB(from, event, to, airbase)
            if self.customconfig.escortgroupname then
                env.info('Tanker RTB: '..self.tanker.GroupName..'...')
                if self.escortGroupObject:IsAirborne(false) == true then
                    env.info('escort RTB : '.. self.escortGroupObject.GroupName..' Tanker : '..self.tanker.GroupName..'...')
                    self.escortGroupObject:RouteRTB(airbase)
                else
                    --self.escortGroupObject:Destroy(nil, 5)
                end
            end
        end
        function objAwacs:OnEventKill(event)
            if self.customconfig.escortgroupname then
                env.info(event.target' Killed !! Sending escort Home')
                self.escortGroupObject:RouteRTB(AIRBASE:FindByName(self.customconfig.baseUnit))
            end
        end
        function objAwacs:OnAfterStatus(from, event, to)
            if ((self.customconfig.escortgroupname) and (self.escortGroupObject)) then
                if not(GROUP:FindByName(self.escortGroupObject.GroupName)) then
                    env.info('Respawning escort Group '..self.escortGroupObject.GroupName)
                    self.escortGroupObject = self.escortSpawnObject
                                                 :SpawnAtAirbase(AIRBASE:FindByName(self.customconfig.baseUnit),SPAWN.Takeoff.Cold, self.customconfig.altitude)
                end
            end
        end
        AwacsArray[compteur] = objAwacs
        AwacsArray[compteur]:Start()
    end
end

if compteur == 0 and #OnDemandAwacsConfig ==0 then
    MenuCoalitionAwacsBlue:Remove()
    MenuCoalitionAwacsRed:Remove()
end

-- *****************************************************************************
--                     **                OnDemand Awacs                       **
--                     *********************************************************
function triggerOnDemandAwacs(type, askedDuration, askedFL, askedSpeed, askedAnchorCoord, askedOrbitHeading, askedOrbitLeg)
    local AwacsGroup = nil
    if (OnDemandAwacsConfig) then
        for index, OnDemandAwacs in ipairs(OnDemandAwacsConfig) do
            if ((OnDemandAwacs.type == type) and (OnDemandAwacs.enable)) then
                debug_msg(string.format('OnDemandAwacs : Found type %s Awacs : %s Group!', type, OnDemandAwacs.groupName))
                if (askedSpeed and askedSpeed > 0) then
                    OnDemandAwacs.speed = askedSpeed
                end
                if (askedFL and askedFL > 0) then
                    OnDemandAwacs.altitude = askedFL * 100
                end
                if ( askedDuration == nil or askedDuration == 0 ) then
                    askedDuration = 480
                end
                if (askedOrbitHeading) then
                    if (askedOrbitLeg and askedOrbitLeg > 10) then
                        --heading et Leg demandés
                        OnDemandAwacs.orbit = {
                            heading = askedOrbitHeading % 360,
                            length = askedOrbitLeg,
                        }
                    else
                        --heading demandé et leg non demandé
                        if (OnDemandAwacs.orbit ) then
                            if (not(OnDemandAwacs.orbit.length)) then
                                OnDemandAwacs.orbit = {
                                    heading = askedOrbitHeading % 360,
                                    length = 30,
                                }
                            else
                                OnDemandAwacs.orbit = {
                                    heading = askedOrbitHeading % 360,
                                    length = math.max(5, OnDemandAwacs.orbit.length),
                                }
                            end
                        else
                            OnDemandAwacs.orbit = {
                                heading = askedOrbitHeading % 360,
                                length = 30,
                            }
                        end
                    end
                else
                    --pas de heading demandé
                    if (OnDemandAwacs.orbit ) then
                        if (not(OnDemandAwacs.orbit.heading)) then
                            OnDemandAwacs.orbit.heading = 90
                        end
                        if (not(OnDemandAwacs.orbit.length)) then
                            OnDemandAwacs.orbit.length = 30
                        else
                            OnDemandAwacs.orbit.length = math.max(5, OnDemandAwacs.orbit.length)
                        end
                    else
                        OnDemandAwacs.orbit = {
                            heading = 90,
                            length = 30,
                        }
                    end
                end
                local set_group_awacs = SET_GROUP:New()
                                                 :FilterActive()
                                                 :FilterPrefixes(OnDemandAwacs.groupName)
                                                 :FilterCategories("plane")
                                                 :FilterOnce()
                local aliveAwacsGroupList = set_group_awacs:GetSetObjects()

                local is_awacs_spawned = false
                debug_msg(string.format('OnDemandAwacs : Looking for a Group corresponding to template %s', string.format("%s-%s", OnDemandAwacs.groupName, OnDemandAwacs.type)))
                for index, current_group in ipairs(aliveAwacsGroupList) do
                    if (
                            (not(is_awacs_spawned)) and
                                    (string.find(
                                            current_group.GroupName,
                                            string.format("%s-%s", OnDemandAwacs.groupName, OnDemandAwacs.type),
                                            1,
                                            true
                                    ) ~= nil)
                    ) then
                        debug_msg(string.format('OnDemandAwacs Found %s corresponding to template %s', current_group.GroupName, string.format("%s-%s", OnDemandAwacs.groupName, OnDemandAwacs.type)))
                        is_awacs_spawned = true
                        AwacsGroup = current_group
                    end
                end

                local RTBAirbase = nil
                local AwacsRoute = {}
                if (OnDemandAwacs.baseUnit) then
                    RTBAirbase = AIRBASE:FindByName(OnDemandAwacs.baseUnit)
                else
                    RTBAirbase = askedAnchorCoord:GetClosestAirbase2(Airbase.Category.AIRDROME, OnDemandAwacs.benefit_coalition)
                end
                if (is_awacs_spawned) then
                    debug_msg(string.format('OnDemandAwacs already in air : rerouting %s', OnDemandAwacs.groupName))
                    AwacsGroup:ClearTasks()
                    table.insert(
                            AwacsRoute,
                            askedAnchorCoord
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandAwacs.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandAwacs.speed),
                                    {
                                        {
                                            id = 'AWACS',
                                            params = {
                                            }
                                        },
                                        {
                                            id = 'ControlledTask',
                                            params = {
                                                task =
                                                {
                                                    id = 'Orbit',
                                                    params = {
                                                        pattern = AI.Task.OrbitPattern.RACE_TRACK,
                                                        speed = UTILS.KnotsToMps(OnDemandAwacs.speed),
                                                        altitude = UTILS.FeetToMeters(OnDemandAwacs.altitude)
                                                    }
                                                },
                                                stopCondition = {
                                                    duration = askedDuration * 60
                                                }
                                            },
                                        },
                                    },
                                    "Awacs Start"
                            )
                    )
                    table.insert(
                            AwacsRoute,
                            askedAnchorCoord
                                    :Translate(UTILS.NMToMeters(OnDemandAwacs.orbit.length), OnDemandAwacs.orbit.heading, true, false)
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandAwacs.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandAwacs.speed),
                                    {
                                        {
                                            id = 'AWACS',
                                            params = {
                                            }
                                        },
                                    },
                                    "Orbit End"
                            )
                    )
                    table.insert(
                            AwacsRoute,
                            RTBAirbase
                                    :GetCoordinate()
                                    :WaypointAirLanding(
                                    UTILS.KnotsToKmph(OnDemandAwacs.speed),
                                    RTBAirbase
                            )
                    )
                else
                    debug_msg(string.format('OnDemandAwacs Spawning %s', OnDemandAwacs.groupName))
                    local SpawnAwacs = SPAWN:NewWithAlias(
                            OnDemandAwacs.groupName,
                            string.format("%s-%s", OnDemandAwacs.groupName, OnDemandAwacs.type)
                    )
                    if (OnDemandAwacs.freq) then
                        SpawnAwacs:InitRadioFrequency(OnDemandAwacs.freq)
                        SpawnAwacs:InitRadioModulation("AM")
                    end
                    if (OnDemandAwacs.modex) then
                        SpawnAwacs:InitModex(OnDemandAwacs.modex)
                    end
                    if (OnDemandAwacs.baseUnit) then
                        AwacsGroup = SpawnAwacs:SpawnAtAirbase(
                                AIRBASE:FindByName(OnDemandAwacs.baseUnit),
                                SPAWN.Takeoff.Hot,
                                nil,
                                OnDemandAwacs.terminalType
                        )
                        table.insert(AwacsRoute,
                                AIRBASE
                                        :FindByName(OnDemandAwacs.baseUnit)
                                        :GetCoordinate()
                                        :WaypointAirTakeOffParkingHot()
                        )
                    else
                        AwacsGroup = SpawnAwacs:SpawnFromCoordinate(
                                askedAnchorCoord
                                        :GetRandomCoordinateInRadius(
                                        UTILS.NMToMeters(30),
                                        UTILS.NMToMeters(20)
                                )
                                        :SetAltitude(
                                        UTILS.FeetToMeters(OnDemandAwacs.altitude)
                                )
                        )
                    end
                    AwacsGroup.customconfig = OnDemandAwacs
                    AwacsGroup.spawnAbsTime = timer.getAbsTime()
                    AwacsGroup.missionmaxduration = askedDuration
                    table.insert(AwacsRoute,
                            askedAnchorCoord
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandAwacs.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandAwacs.speed),
                                    {
                                        {
                                            id = 'AWACS',
                                            params = {
                                            }
                                        },
                                        {
                                            id = 'ControlledTask',
                                            params = {
                                                task =
                                                {
                                                    id = 'Orbit',
                                                    params = {
                                                        pattern = AI.Task.OrbitPattern.RACE_TRACK,
                                                        speed = UTILS.KnotsToMps(OnDemandAwacs.speed),
                                                        altitude = UTILS.FeetToMeters(OnDemandAwacs.altitude)
                                                    }
                                                },
                                                stopCondition = {
                                                    duration = askedDuration * 60
                                                }
                                            },
                                        },
                                    },
                                    "Awacs Start"
                            )
                    )
                    table.insert(AwacsRoute,
                            askedAnchorCoord
                                    :Translate(UTILS.NMToMeters(OnDemandAwacs.orbit.length), OnDemandAwacs.orbit.heading, true, false)
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandAwacs.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandAwacs.speed),
                                    {
                                        {
                                            id = 'AWACS',
                                            params = {
                                            }
                                        }
                                    },
                                    "Orbit End"
                            )
                    )
                    table.insert(AwacsRoute,
                            RTBAirbase
                                    :GetCoordinate()
                                    :WaypointAirLanding(
                                    UTILS.KnotsToKmph(OnDemandAwacs.speed),
                                    RTBAirbase,
                                    {},
                                    'RTB'
                            )
                    )
                end
                AwacsGroup:Route(AwacsRoute)
                AwacsGroup:CommandEPLRS(true, 4)
                if (OnDemandAwacs.tacan) then
                    AwacsGroup.beacon=BEACON:New(AwacsGroup:GetUnit(1))
                    AwacsGroup.beacon:ActivateTACAN(OnDemandAwacs.tacan.channel, "Y", OnDemandAwacs.tacan.morse, true)
                end
                if (OnDemandAwacs.callsign) then
                    AwacsGroup:CommandSetCallsign(OnDemandAwacs.callsign.name, OnDemandAwacs.callsign.number, 2)
                end
                if OnDemandAwacs.escortgroupname then
                    AwacsGroup.escortSpawnObject = SPAWN:NewWithAlias(OnDemandAwacs.escortgroupname,'escort-'.. OnDemandAwacs.groupName)
                                                  :InitRepeatOnEngineShutDown()
                                                  :InitSkill("Excellent")
                                                  :OnSpawnGroup(function(SpawnGroup)
                        taskGroupEscort({AwacsGroup, SpawnGroup})
                    end)
                    AwacsGroup.escortGroupObject = spawnRecoveryTankerEscort(AwacsGroup.escortSpawnObject,OnDemandAwacs)
                    if OnDemandAwacs.missionmaxduration then
                        AwacsGroup.escortGroupObject:ScheduleOnce(OnDemandAwacs.missionmaxduration*60,
                                function(SpawnGroup, airBaseName)
                                    --trigger.action.outText('RTB schedule trigger Tanker-escort group : '..(SpawnGroup.GroupName)..' airbase'..(airBaseName)..'...', 45)
                                    SpawnGroup:RouteRTB(AIRBASE:FindByName(airBaseName))
                                end,
                                AwacsGroup.escortGroupObject,
                                OnDemandAwacs.baseUnit
                        )
                        --trigger.action.outText('Tanker-escort configured to RTB in  : '..(OnDemandAwacs.missionmaxduration)..' minutes max...', 45)
                    end
                end
                if (map_marker[AwacsGroup:GetName()]) then
                    COORDINATE:RemoveMark(map_marker[AwacsGroup:GetName()])
                end
                if (OnDemandAwacs.tacan) then
                    map_marker[AwacsGroup:GetName()] = askedAnchorCoord:MarkToCoalition(
                            string.format(
                                    'OnDemand Awacs %s - TCN %i\nFL %i at %i knots\nFreq %.2f MHz\nOn station for %i minutes\nRacetrack : %i ° for %i nm',
                                    OnDemandAwacs.type,
                                    OnDemandAwacs.tacan.channel,
                                    UTILS.Round(OnDemandAwacs.altitude / 100 , 0),
                                    OnDemandAwacs.speed,
                                    OnDemandAwacs.freq,
                                    askedDuration,
                                    OnDemandAwacs.orbit.heading,
                                    OnDemandAwacs.orbit.length
                            ),
                            OnDemandAwacs.benefit_coalition,
                            true,
                            'OnDemand Awacs %s is Activated'
                    )
                else
                    map_marker[AwacsGroup:GetName()] = askedAnchorCoord:MarkToCoalition(
                            string.format(
                                    'OnDemand Awacs %s\nFL %i at %i knots\nFreq %.2f MHz\nOn station for %i minutes\nRacetrack : %i ° for %i nm',
                                    OnDemandAwacs.type,
                                    UTILS.Round(OnDemandAwacs.altitude / 100 , 0),
                                    OnDemandAwacs.speed,
                                    OnDemandAwacs.freq,
                                    askedDuration,
                                    OnDemandAwacs.orbit.heading,
                                    OnDemandAwacs.orbit.length
                            ),
                            OnDemandAwacs.benefit_coalition,
                            true,
                            'OnDemand Awacs %s is Activated'
                    )
                end
                AwacsGroup:HandleEvent(EVENTS.Land)
                AwacsGroup:HandleEvent(EVENTS.Crash)
                AwacsGroup:HandleEvent(EVENTS.Dead)
                function AwacsGroup:OnEventLand(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                    if self.custommconfig.escortgroupname then
                        env.info('AWACS RTB: '..self.GroupName..'...')
                        if self.escortGroupObject:IsAirborne(false) == true then
                            env.info('escort RTB : '.. self.escortGroupObject.GroupName..' AWACS : '..self.GroupName..'...')
                            self.escortGroupObject:RouteRTB()
                        else
                            --self.escortGroupObject:Destroy(nil, 5)
                        end
                    end
                end
                function AwacsGroup:OnEventCrash(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                    if self.custommconfig.escortgroupname then
                        env.info('AWACS RTB: '..self.GroupName..'...')
                        if self.escortGroupObject:IsAirborne(false) == true then
                            env.info('escort RTB : '.. self.escortGroupObject.GroupName..' AWACS : '..self.GroupName..'...')
                            self.escortGroupObject:RouteRTB()
                        else
                            --self.escortGroupObject:Destroy(nil, 5)
                        end
                    end
                end
                function AwacsGroup:OnEventDead(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                    if self.custommconfig.escortgroupname then
                        env.info('AWACS RTB: '..self.GroupName..'...')
                        if self.escortGroupObject:IsAirborne(false) == true then
                            env.info('escort RTB : '.. self.escortGroupObject.GroupName..' AWACS : '..self.GroupName..'...')
                            self.escortGroupObject:RouteRTB()
                        else
                            --self.escortGroupObject:Destroy(nil, 5)
                        end
                    end
                end
            end
        end
    end
    return AwacsGroup;
end

--local RestrToCoal = nil
awacsOnDemandArray = {}
local AwacsMarkHandler = {}


function AwacsMarkHandler:onEvent(event)
    local awacsCmdSymbol = "-"

    if event.id == 25 then
        --trigger.action.outText(" ", 0, true)
    elseif (event.id == 27 and string.find(event.text, awacsCmdSymbol)) then
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

        if (string.find(full, awacsCmdSymbol)) then
            param1Start = string.find(full, awacsCmdSymbol)
            cmd = string.sub(full, 0, param1Start-1)
            remString = string.sub(full, param1Start+1)
            if (string.find(remString, awacsCmdSymbol)) then
                param2Start = string.find(remString, awacsCmdSymbol)
                param1 = string.sub(remString, 0, param2Start-1)
                remString = string.sub(remString, param2Start+1)
                if string.find(remString, awacsCmdSymbol) then
                    param3Start = string.find(remString, awacsCmdSymbol)
                    param2 = string.sub(remString, 0, param3Start-1)
                    remString = string.sub(remString, param3Start+1)
                    if string.find(remString, awacsCmdSymbol) then
                        param4Start = string.find(remString, awacsCmdSymbol)
                        param3 = string.sub(remString, 0, param4Start-1)
                        remString = string.sub(remString, param4Start+1)

                        if string.find(remString, awacsCmdSymbol) then
                            param5Start = string.find(remString, awacsCmdSymbol)
                            param4 = string.sub(remString, 0, param5Start-1)
                            remString = string.sub(remString, param5Start+1)

                            if string.find(remString, awacsCmdSymbol) then
                                param6Start = string.find(remString, awacsCmdSymbol)
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
            if param2 ~= nil then trigger.action.outText("Duration = " .. param2, 10) end
            if param3 ~= nil then trigger.action.outText("FlightLevel = " .. param3, 10) end
            if param4 ~= nil then trigger.action.outText("Speed = " .. param4, 10) end
            if param5 ~= nil then trigger.action.outText("OrbitHeading = " .. param5, 10) end
            if param6 ~= nil then trigger.action.outText("OrbitLeg = " .. param6, 10) end
        end

        if string.find(cmd, "awacs") then
            if DEBUG_MSG == true then
                trigger.action.outText("DEBUG: On Demand Awacs Started!", 10)
            end
            awacsOnDemandArray[#awacsOnDemandArray+1] = triggerOnDemandAwacs(
                    param1,
                    tonumber(param2),
                    tonumber(param3),
                    tonumber(param4),
                    mcoord,
                    tonumber(param5),
                    tonumber(param6)
            )
        end
        --end
    end

end

world.addEventHandler(AwacsMarkHandler)
