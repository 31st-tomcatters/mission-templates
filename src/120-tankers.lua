-- *****************************************************************************
--                     **                     Tankers                         **
--                     *********************************************************
tankersArray = {}
compteur = 0
MenuCoalitionTankerBlue = MENU_COALITION:New(coalition.side.BLUE, "Tankers", MenuCoalitionBlue)
MenuCoalitionTankerRed = MENU_COALITION:New(coalition.side.RED, "Tankers", MenuCoalitionRed)
for index, tankerconfig in ipairs(TankersConfig) do
    if tankerconfig.enable == true then
        compteur = compteur + 1
        env.info('creation Tanker : '.. tankerconfig.groupName..'...')
        local objTanker = RECOVERYTANKER:New(UNIT:FindByName(tankerconfig.patternUnit), tankerconfig.groupName)
                                        :SetTakeoffCold()
                                        :SetRespawnOnOff(tankerconfig.autorespawn)
                                        :SetLowFuelThreshold(tankerconfig.fuelwarninglevel)
                                        :SetAltitude(tankerconfig.altitude)
                                        :SetSpeed(tankerconfig.speed)
                                        :SetHomeBase(AIRBASE:FindByName(tankerconfig.baseUnit),tankerconfig.terminalType)
                                        :SetCallsign(tankerconfig.callsign.name, tankerconfig.callsign.number)
                                        :SetRecoveryAirboss(tankerconfig.airboss_recovery)
                                        :SetRadio(tankerconfig.freq)
                                        :SetModex(tankerconfig.modex)
                                        :SetTACAN(tankerconfig.tacan.channel, tankerconfig.tacan.morse, tankerconfig.tacan.band)
                                        :SetRacetrackDistances(tankerconfig.racetrack.front, tankerconfig.racetrack.back)
        objTanker.customconfig = tankerconfig
        function objTanker:OnAfterStart(from, event, to)
            --self:SetTACAN(self.customconfig.tacan.channel, self.customconfig.tacan.morse, self.customconfig.tacan.band )
            self.spawnAbsTime = timer.getAbsTime()
            env.info('popup Tanker : '..self.tanker.GroupName..' at : '..self.spawnAbsTime)
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
                            --trigger.action.outText('RTB schedule trigger Tanker group : '..(tankerObject.tanker.GroupName)..' airbase'..(tankerObject.customconfig.baseUnit)..'...', 45)
                            tankerObject:RTB(AIRBASE:FindByName(tankerObject.customconfig.baseUnit))
                        end,
                        self
                )
                --trigger.action.outText('Tanker configured to RTB in  : '..(self.customconfig.missionmaxduration)..' minutes max...', 45)
            end
            if (self.customconfig.benefit_coalition == coalition.side.RED) then
                self.menureset = MENU_COALITION_COMMAND:New(
                        coalition.side.RED,
                        "Reset Tanker "..self.customconfig.callsign.alias..'-'..self.customconfig.callsign.number..'-1',
                        MenuCoalitionTankerRed,
                        resetRecoveryTanker,
                        self
                )
            else
                self.menureset = MENU_COALITION_COMMAND:New(
                        coalition.side.BLUE,
                        "Reset Tanker "..self.customconfig.callsign.alias..'-'..self.customconfig.callsign.number..'-1',
                        MenuCoalitionTankerBlue,
                        resetRecoveryTanker,
                        self
                )
            end
        end
        function objTanker:OnAfterRTB(from, event, to, airbase)
            if self.customconfig.escortgroupname then
                env.info('Tanker RTB: '..self.tanker.GroupName..'...')
                if self.escortGroupObject:IsAirborne(false) == true then
                    env.info('escort RTB : '.. self.escortGroupObject.GroupName..' Tanker : '..self.tanker.GroupName..'...')
                    self.escortGroupObject:RouteRTB(airbase)
                else
                    --self.escortGroupObject:Destroy(nil, 5)
                end
            end
            --trigger.action.outText('Tanker is RTB : '..(self.customconfig.groupName)..'...', 45)
        end
        function objTanker:OnEventKill(event)
            if self.customconfig.escortgroupname then
                env.info(event.target' Killed !! Sending escort Home')
                self.escortGroupObject:RouteRTB(AIRBASE:FindByName(self.customconfig.baseUnit))
            end
        end
        function objTanker:OnAfterStatus(from, event, to)
            self.tanker:OptionRestrictBurner(true)
            if ((self.customconfig.escortgroupname) and (self.escortGroupObject)) then
                if not(GROUP:FindByName(self.escortGroupObject.GroupName)) then
                    env.info('Respawning escort Group '..self.escortGroupObject.GroupName)
                    self.escortGroupObject = self.escortSpawnObject
                                                 :SpawnAtAirbase(AIRBASE:FindByName(self.customconfig.baseUnit),SPAWN.Takeoff.Cold, self.customconfig.altitude)
                end
            end
        end
        tankersArray[compteur] = objTanker
        tankersArray[compteur]:Start()
    end
end

-- *****************************************************************************
--                     **                OnDemand Tankers                     **
--                     *********************************************************
function triggerOnDemandTanker(type, askedDuration, askedFL, askedSpeed, askedAnchorCoord, askedOrbitHeading, askedOrbitLeg)
    local TankerGroup = nil
    if (OnDemandTankersConfig) then
        for index, OnDemandTanker in ipairs(OnDemandTankersConfig) do
            if ((OnDemandTanker.type == type) and (OnDemandTanker.enable)) then
                debug_msg(string.format('OnDemandTanker : Found type %s Tanker : %s Group!', type, OnDemandTanker.groupName))
                if (askedSpeed and askedSpeed > 0) then
                    OnDemandTanker.speed = askedSpeed
                end
                if (askedFL and askedFL > 0) then
                    OnDemandTanker.altitude = askedFL * 100
                end
                if ( askedDuration == nil or askedDuration == 0 ) then
                    askedDuration = 480
                end
                if (askedOrbitHeading) then
                    if (askedOrbitLeg and askedOrbitLeg > 10) then
                        --heading et Leg demandés
                        OnDemandTanker.orbit = {
                            heading = askedOrbitHeading % 360,
                            length = askedOrbitLeg,
                        }
                    else
                        --heading demandé et leg non demandé
                        if (OnDemandTanker.orbit ) then
                            if (not(OnDemandTanker.orbit.length)) then
                                OnDemandTanker.orbit = {
                                    heading = askedOrbitHeading % 360,
                                    length = 30,
                                }
                            else
                                OnDemandTanker.orbit = {
                                    heading = askedOrbitHeading % 360,
                                    length = math.max(10, OnDemandTanker.orbit.length),
                                }
                            end
                        else
                            OnDemandTanker.orbit = {
                                heading = askedOrbitHeading % 360,
                                length = 30,
                            }
                        end
                    end
                else
                    --pas de heading demandé
                    if (OnDemandTanker.orbit ) then
                        if (not(OnDemandTanker.orbit.heading)) then
                            OnDemandTanker.orbit.heading = 90
                        end
                        if (not(OnDemandTanker.orbit.length)) then
                            OnDemandTanker.orbit.length = 30
                        else
                            OnDemandTanker.orbit.length = math.max(10, OnDemandTanker.orbit.length)
                        end
                    else
                        OnDemandTanker.orbit = {
                            heading = 90,
                            length = 30,
                        }
                    end
                end
                local set_group_tanker = SET_GROUP:New()
                        :FilterActive()
                        :FilterPrefixes(OnDemandTanker.groupName)
                        :FilterCategories("plane")
                        :FilterOnce()
                local aliveTankersGroupList = set_group_tanker:GetSetObjects()

                local is_tanker_spawned = false
                debug_msg(string.format('OnDemandTanker : Looking for a Group corresponding to template %s', string.format("%s-%s", OnDemandTanker.groupName, OnDemandTanker.type)))
                for index, current_group in ipairs(aliveTankersGroupList) do
                    if (
                            (not(is_tanker_spawned)) and
                                    (string.find(
                                            current_group.GroupName,
                                            string.format("%s-%s",OnDemandTanker.groupName, OnDemandTanker.type),
                                            1,
                                            true
                                    ) ~= nil)
                    ) then
                        debug_msg(string.format('OnDemandTanker Found %s corresponding to template %s', current_group.GroupName, string.format("%s-%s", OnDemandTanker.groupName, OnDemandTanker.type)))
                        is_tanker_spawned = true
                        TankerGroup = current_group
                    end
                end

                local RTBAirbase = nil
                local TankerRoute = {}
                if (OnDemandTanker.baseUnit) then
                    RTBAirbase = AIRBASE:FindByName(OnDemandTanker.baseUnit)
                else
                    RTBAirbase = askedAnchorCoord:GetClosestAirbase2(Airbase.Category.AIRDROME, OnDemandTanker.benefit_coalition)
                end
                if (is_tanker_spawned) then
                    debug_msg(string.format('OnDemandTanker already in air : rerouting %s', OnDemandTanker.groupName))
                    TankerGroup:ClearTasks()
                    table.insert(
                            TankerRoute,
                            askedAnchorCoord
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandTanker.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    {
                                        {
                                            id = 'Tanker',
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
                                                        speed = UTILS.KnotsToMps(OnDemandTanker.speed),
                                                        altitude = UTILS.FeetToMeters(OnDemandTanker.altitude)
                                                    }
                                                },
                                                stopCondition = {
                                                    duration = askedDuration * 60
                                                }
                                            },
                                        },
                                    },
                                    "Refuel Start"
                            )
                    )
                    table.insert(
                            TankerRoute,
                            askedAnchorCoord
                                    :Translate(UTILS.NMToMeters(OnDemandTanker.orbit.length), OnDemandTanker.orbit.heading, true, false)
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandTanker.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    {
                                        {
                                            id = 'Tanker',
                                            params = {
                                            }
                                        },
                                    },
                                    "Orbit End"
                            )
                    )
                    table.insert(
                            TankerRoute,
                            RTBAirbase
                                    :GetCoordinate()
                                    :WaypointAirLanding(
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    RTBAirbase
                            )
                    )
                else
                    debug_msg(string.format('OnDemandTanker Spawning %s', OnDemandTanker.groupName))
                    local SpawnTanker = SPAWN:NewWithAlias(
                            OnDemandTanker.groupName,
                            string.format("%s-%s",OnDemandTanker.groupName,OnDemandTanker.type)
                    )
                    if (OnDemandTanker.freq) then
                        SpawnTanker:InitRadioFrequency(OnDemandTanker.freq)
                        SpawnTanker:InitRadioModulation("AM")
                    end
                    if (OnDemandTanker.modex) then
                        SpawnTanker:InitModex(OnDemandTanker.modex)
                    end
                    if (OnDemandTanker.baseUnit) then
                        TankerGroup = SpawnTanker:SpawnAtAirbase(
                                AIRBASE:FindByName(OnDemandTanker.baseUnit),
                                SPAWN.Takeoff.Hot,
                                nil,
                                OnDemandTanker.terminalType
                        )
                        table.insert(TankerRoute,
                                AIRBASE
                                        :FindByName(OnDemandTanker.baseUnit)
                                        :GetCoordinate()
                                        :WaypointAirTakeOffParkingHot()
                        )
                    else
                        TankerGroup = SpawnTanker:SpawnFromCoordinate(
                                askedAnchorCoord
                                        :GetRandomCoordinateInRadius(
                                        UTILS.NMToMeters(30),
                                        UTILS.NMToMeters(20)
                                )
                                        :SetAltitude(
                                        UTILS.FeetToMeters(OnDemandTanker.altitude)
                                )
                        )
                    end
                    TankerGroup.customconfig = OnDemandTanker
                    TankerGroup.spawnAbsTime = timer.getAbsTime()
                    TankerGroup.missionmaxduration = askedDuration
                    table.insert(TankerRoute,
                            askedAnchorCoord
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandTanker.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    {
                                        {
                                            id = 'Tanker',
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
                                                        speed = UTILS.KnotsToMps(OnDemandTanker.speed),
                                                        altitude = UTILS.FeetToMeters(OnDemandTanker.altitude)
                                                    }
                                                },
                                                stopCondition = {
                                                    duration = askedDuration * 60
                                                }
                                            },
                                        },
                                    },
                                    "Refuel Start"
                            )
                    )
                    table.insert(TankerRoute,
                            askedAnchorCoord
                                    :Translate(UTILS.NMToMeters(OnDemandTanker.orbit.length), OnDemandTanker.orbit.heading, true, false)
                                    :SetAltitude(UTILS.FeetToMeters(OnDemandTanker.altitude))
                                    :WaypointAirTurningPoint(
                                    nil,
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    {
                                        {
                                            id = 'Tanker',
                                            params = {
                                            }
                                        }
                                    },
                                    "Orbit End"
                            )
                    )
                    table.insert(TankerRoute,
                            RTBAirbase
                                    :GetCoordinate()
                                    :WaypointAirLanding(
                                    UTILS.KnotsToKmph(OnDemandTanker.speed),
                                    RTBAirbase,
                                    {},
                                    'RTB'
                            )
                    )
                end
                TankerGroup:Route(TankerRoute)
                TankerGroup:CommandEPLRS(true, 4)
                if (OnDemandTanker.tacan) then
                    TankerGroup.beacon=BEACON:New(TankerGroup:GetUnit(1))
                    TankerGroup.beacon:ActivateTACAN(OnDemandTanker.tacan.channel, "Y", OnDemandTanker.tacan.morse, true)
                end
                if (OnDemandTanker.callsign) then
                    TankerGroup:CommandSetCallsign(OnDemandTanker.callsign.name, OnDemandTanker.callsign.number, 2)
                end
                if OnDemandTanker.escortgroupname then
                    TankerGroup.escortSpawnObject = SPAWN:NewWithAlias(OnDemandTanker.escortgroupname,'escort-'.. OnDemandTanker.groupName)
                                                        :InitRepeatOnEngineShutDown()
                                                        :InitSkill("Excellent")
                                                        :OnSpawnGroup(function(SpawnGroup)
                        taskGroupEscort({TankerGroup, SpawnGroup})
                    end)
                    TankerGroup.escortGroupObject = spawnRecoveryTankerEscort(TankerGroup.escortSpawnObject,OnDemandTanker)
                    if OnDemandTanker.missionmaxduration then
                        TankerGroup.escortGroupObject:ScheduleOnce(OnDemandTanker.missionmaxduration*60,
                                function(SpawnGroup, airBaseName)
                                    --trigger.action.outText('RTB schedule trigger Tanker-escort group : '..(SpawnGroup.GroupName)..' airbase'..(airBaseName)..'...', 45)
                                    SpawnGroup:RouteRTB(AIRBASE:FindByName(airBaseName))
                                end,
                                TankerGroup.escortGroupObject,
                                OnDemandTanker.baseUnit
                        )
                        --trigger.action.outText('Tanker-escort configured to RTB in  : '..(OnDemandTanker.missionmaxduration)..' minutes max...', 45)
                    end
                end
                if (map_marker[TankerGroup:GetName()]) then
                    COORDINATE:RemoveMark(map_marker[TankerGroup:GetName()])
                end
                if(OnDemandTanker.tacan) then
                    map_marker[TankerGroup:GetName()] = askedAnchorCoord:MarkToCoalition(
                            string.format(
                                    'OnDemand Tanker %s - TCN %i\nFL %i at %i knots\nFreq %.2f MHz\nOn station for %i minutes\nRacetrack : %i ° for %i nm',
                                    OnDemandTanker.type,
                                    OnDemandTanker.tacan.channel,
                                    UTILS.Round(OnDemandTanker.altitude / 100 , 0),
                                    OnDemandTanker.speed,
                                    OnDemandTanker.freq,
                                    askedDuration,
                                    OnDemandTanker.orbit.heading,
                                    OnDemandTanker.orbit.length
                            ),
                            OnDemandTanker.benefit_coalition,
                            true,
                            'OnDemand Tanker %s is Activated'
                    )
                else
                    map_marker[TankerGroup:GetName()] = askedAnchorCoord:MarkToCoalition(
                            string.format(
                                    'OnDemand Tanker %s\nFL %i at %i knots\nFreq %.2f MHz\nOn station for %i minutes\nRacetrack : %i ° for %i nm',
                                    OnDemandTanker.type,
                                    UTILS.Round(OnDemandTanker.altitude / 100 , 0),
                                    OnDemandTanker.speed,
                                    OnDemandTanker.freq,
                                    askedDuration,
                                    OnDemandTanker.orbit.heading,
                                    OnDemandTanker.orbit.length
                            ),
                            OnDemandTanker.benefit_coalition,
                            true,
                            'OnDemand Tanker %s is Activated'
                    )
                end
                TankerGroup:HandleEvent(EVENTS.Land)
                TankerGroup:HandleEvent(EVENTS.Crash)
                TankerGroup:HandleEvent(EVENTS.Dead)
                function TankerGroup:OnEventLand(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                    if self.custommconfig.escortgroupname then
                        env.info('Tanker RTB: '..self.GroupName..'...')
                        if self.escortGroupObject:IsAirborne(false) == true then
                            env.info('escort RTB : '.. self.escortGroupObject.GroupName..' Tanker : '..self.GroupName..'...')
                            self.escortGroupObject:RouteRTB()
                        else
                            --self.escortGroupObject:Destroy(nil, 5)
                        end
                    end
                end
                function TankerGroup:OnEventCrash(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                    if self.custommconfig.escortgroupname then
                        env.info('Tanker RTB: '..self.GroupName..'...')
                        if self.escortGroupObject:IsAirborne(false) == true then
                            env.info('escort RTB : '.. self.escortGroupObject.GroupName..' Tanker : '..self.GroupName..'...')
                            self.escortGroupObject:RouteRTB()
                        else
                            --self.escortGroupObject:Destroy(nil, 5)
                        end
                    end
                end
                function TankerGroup:OnEventDead(EventData)
                    COORDINATE:RemoveMark(map_marker[self:GetName()])
                    if self.custommconfig.escortgroupname then
                        env.info('Tanker RTB: '..self.GroupName..'...')
                        if self.escortGroupObject:IsAirborne(false) == true then
                            env.info('escort RTB : '.. self.escortGroupObject.GroupName..' Tanker : '..self.GroupName..'...')
                            self.escortGroupObject:RouteRTB()
                        else
                            --self.escortGroupObject:Destroy(nil, 5)
                        end
                    end
                end
            end
        end
    end
    return TankerGroup;
end

--local RestrToCoal = nil
tankersOnDemandArray = {}
local TankerMarkHandler = {}
local CmdSymbol = "-"

function TankerMarkHandler:onEvent(event)

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
            if param2 ~= nil then trigger.action.outText("Duration = " .. param2, 10) end
            if param3 ~= nil then trigger.action.outText("FlightLevel = " .. param3, 10) end
            if param4 ~= nil then trigger.action.outText("Speed = " .. param4, 10) end
            if param5 ~= nil then trigger.action.outText("OrbitHeading = " .. param5, 10) end
            if param6 ~= nil then trigger.action.outText("OrbitLeg = " .. param6, 10) end
        end

        if string.find(cmd, "tanker") then
            if DEBUG_MSG == true then
                trigger.action.outText("DEBUG: On Demand Tanker Started!", 10)
            end
            tankersOnDemandArray[#tankersOnDemandArray+1] = triggerOnDemandTanker(
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

world.addEventHandler(TankerMarkHandler)
