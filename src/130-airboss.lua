-- *****************************************************************************
--                     **                       AirBoss                       **
--                     *********************************************************
function detectShitHotBreak(objAirboss)
    local clientData={}
    local player_name=""
    --env.info('detectShitHotBreak : '.. objAirboss.customconfig.alias..' suspense ...')
    objAirboss.CVNClients:ForEachClientInZone( objAirboss.CVN_GROUPZone,
            function( MooseClient )

                local function resetFlag()
                    --trigger.action.outText('RESET SH Pass FLAG)', 5 )
                    client_in_zone_flag:Set(0)
                end

                local player_velocity = MooseClient:GetVelocityKNOTS()
                local player_name = MooseClient:GetPlayerName()
                local player_alt = MooseClient:GetAltitude()
                local player_type = MooseClient:GetTypeName()

                local player_alt_feet = math.floor((player_alt * ( 3.28 / 10)))*10

                local player_velocity_round = math.floor((player_velocity/10))*10

                local Play_SH_Sound = USERSOUND:New( "AIRBOSS/Airboss Soundfiles/GreatBallsOfFire.ogg" )
                --trigger.action.outText(player_name..' altitude is '..player_alt, 5)
                --trigger.action.outText(player_name..' speed is '..player_velocity, 5)
                if client_in_zone_flag == nil then
                    client_in_zone_flag = USERFLAG:New(MooseClient:GetClientGroupID() + 10000000)
                else
                end

                if client_performing_sh == nil then
                    client_performing_sh = USERFLAG:New(MooseClient:GetClientGroupID() + 100000000)
                else
                end

                if client_in_zone_flag:Get() == 0 and player_velocity > 475 and player_alt < 213 then
                    -- Requirements for Shit Hot break are velocity >475 knots and less than 213 meters (700')
                    --trigger.action.outText(player_name..' performing a Sierra Hotel Break!', 10)
                    local sh_message_to_discord = ('**'..player_name..' is performing a Sierra Hotel Break at '..player_velocity_round..' knots and '..player_alt_feet..' feet!**')
                    GemMan:SendTable({
                        command="moose_text",
                        text=sh_message_to_discord,
                        msg_type='lso'
                    })
                    Play_SH_Sound:ToAll()
                    client_in_zone_flag:Set(1)
                    client_performing_sh:Set(1)
                    timer.scheduleFunction(resetFlag, {}, timer.getTime() + 10)
                else
                end

                --trigger.action.outText('ForEachClientInZone: Client name is '..clientData.clientName , 5)
                --trigger.action.outText('ForEachClientInZone: Client fuel1 is '..clientData.clientFuel1 , 5)

            end
    )
end

function switchCarrierDefCon2(params)
    local carrierName = params[1]
    local timeMinutes = params[2]
    local cvUnit = UNIT:FindByName(carrierName)
    local cvGroup = cvUnit:GetGroup()
    cvGroup:OptionROE(ENUMS.ROE.WeaponFree):OptionAlarmStateRed()
    debug_msg(string.format("CSG : %s DEFCON 2 -> ROE = %d", carrierName, ENUMS.ROE.WeaponFree))
    SCHEDULER:New(
            nil,
            function(carrierName)
                debug_squeduler_msg(carrierName .. " switchback to DEFCON 4")
                debug_msg(string.format("CSG : %s DEFCON 4 -> ROE = %d", carrierName, ENUMS.ROE.ReturnFire))
                UNIT:FindByName(carrierName):GetGroup():OptionROE(ENUMS.ROE.ReturnFire):OptionAlarmStateRed()
            end,
            { carrierName },
            timeMinutes*60
    )
end

function forceCarrierDefCon4(params)
    local carrierName = params[1]
    local cvUnit = UNIT:FindByName(carrierName)
    local cvGroup = cvUnit:GetGroup()
    cvGroup:OptionROE(ENUMS.ROE.WeaponFree):OptionAlarmStateRed()
end

AIRBOSSArray = {}
compteur = 0
MenuCoalitionCSGCommandsBlue = MENU_COALITION:New(coalition.side.BLUE, "CSG Commands", MenuCoalitionBlue)
MenuCoalitionCSGCommandsRed = MENU_COALITION:New(coalition.side.RED, "CSG Commands", MenuCoalitionRed)
for index, airbossconfig in ipairs(AirBossConfig) do
    if airbossconfig.enable == true then
        compteur = compteur +1
        --populate_SC(airbossconfig.carriername)
        local MenuCoalitionCSGCommands = nil
        if airbossconfig.coalition == coalition.side.BLUE then
            MenuCoalitionCSGCommands = MenuCoalitionCSGCommandsBlue
        else
            MenuCoalitionCSGCommands = MenuCoalitionCSGCommandsRed
        end
        local objAirboss = AIRBOSS:New(airbossconfig.carriername, airbossconfig.alias)
        objAirboss.menuObject = MENU_COALITION:New(
                airbossconfig.coalition,
                airbossconfig.alias,
                MenuCoalitionCSGCommands
        )
        MENU_COALITION_COMMAND:New(
                airbossconfig.coalition,
                "DEFCON 2 - 5 minutes",
                objAirboss.menuObject,
                switchCarrierDefCon2,
                {
                    airbossconfig.carriername,
                    5
                }
        )
        MENU_COALITION_COMMAND:New(
                airbossconfig.coalition,
                "DEFCON 2 - 10 minutes",
                objAirboss.menuObject,
                switchCarrierDefCon2,
                {
                    airbossconfig.carriername,
                    10
                }
        )
        MENU_COALITION_COMMAND:New(
                airbossconfig.coalition,
                "Release : DEFCON 4",
                objAirboss.menuObject,
                forceCarrierDefCon4,
                {
                    airbossconfig.carriername
                }
        )
        objAirboss:SetTACAN(airbossconfig.tacan.channel, airbossconfig.tacan.mode, airbossconfig.tacan.morse)
        objAirboss:SetICLS(airbossconfig.icls.channel, airbossconfig.icls.morse)
        objAirboss:SetLSORadio(airbossconfig.freq.lso)
        objAirboss:SetMarshalRadio(airbossconfig.freq.marshall)
        if (airbossconfig.infinitepatrol) then
            objAirboss:SetPatrolAdInfinitum(true)
        end
        objAirboss:SetCarrierControlledArea(airbossconfig.controlarea)
        objAirboss:SetStaticWeather(true)
        objAirboss:SetRespawnAI(false)
        objAirboss:SetRecoveryCase(airbossconfig.recoverycase)
        objAirboss:SetEmergencyLandings(true)
        objAirboss:SetMaxLandingPattern(airbossconfig.maxpatterns)
        objAirboss:SetMaxSectionSize(4)
        objAirboss:SetMaxMarshalStacks(airbossconfig.maxstacks)
        objAirboss:SetDefaultPlayerSkill(airbossconfig.difficulty) -- other options EASY / HARD
        objAirboss:SetFunkManOn(10043, "127.0.0.1")
        if airbossconfig.wirecorrection then
            objAirboss:SetMPWireCorrection(airbossconfig.wirecorrection)
        else
            objAirboss:SetMPWireCorrection()
        end
        if airbossconfig.operationsstatspath then
            objAirboss:Load(airbossconfig.operationsstatspath)
            if airbossconfig.operationsstatspath then
                objAirboss:SetTrapSheet(airbossconfig.operationstrapsheetpath)
            end
            --objAirboss:SetAutoSave(airbossconfig.operationsstatspath)
        end
        if airbossconfig.handleAI == true then
            objAirboss:SetHandleAION()
            objAirboss:SetDespawnOnEngineShutdown(true)
        else
            objAirboss:SetHandleAIOFF()
        end
        if airbossconfig.recoverytanker then
            for index,value in pairs(tankersArray) do
                if ((value.customconfig.airboss_recovery == true) and (value.customconfig.groupName == airbossconfig.recoverytanker))then
                    objAirboss:SetRecoveryTanker(tankersArray[index])
                    objAirboss:MessageToMarshal('Recovery Tanker Setup : '..airbossconfig.recoverytanker, airbossconfig.alias, "", 30, false, 0)
                    break
                end
            end
        end
        if airbossconfig.menurecovery.enable == true then
            objAirboss:SetMenuRecovery(airbossconfig.menurecovery.duration,
                    airbossconfig.menurecovery.windondeck,
                    airbossconfig.menurecovery.uturn,
                    airbossconfig.menurecovery.offset)
        end
        objAirboss:SetMenuMarkZones(airbossconfig.enable_menumarkzones)
        objAirboss:SetMenuSmokeZones(airbossconfig.enable_menusmokezones)
        objAirboss:SetAirbossNiceGuy(airbossconfig.enable_niceguy)
        objAirboss:SetRadioRelayMarshal(airbossconfig.releayunit.marshall)
        objAirboss:SetRadioRelayLSO(airbossconfig.releayunit.lso)
        objAirboss:SetSoundfilesFolder(soundFilesPrefix .. "AIRBOSS/Airboss Soundfiles/")
        if airbossconfig.voices.marshall then
            if airbossconfig.voices.marshall == "Raynor" then
                objAirboss:SetVoiceOversMarshalByRaynor(soundFilesPrefix .. 'AIRBOSS/Airboss Soundpack Marshal Raynor/')
            elseif airbossconfig.voices.marshall == "Gabriella" then
                    objAirboss:SetVoiceOversMarshalByGabriella(soundFilesPrefix .. 'AIRBOSS/Airboss Soundpack Marshal Gabriella/')
            elseif airbossconfig.voices.marshall == "FF" then
                    objAirboss:SetVoiceOversMarshalByFF(soundFilesPrefix .. 'AIRBOSS/Airboss Soundpack Marshal FF/')
            end
        else
            objAirboss:SetVoiceOversMarshalByRaynor(soundFilesPrefix .. 'AIRBOSS/Airboss Soundpack Marshal Raynor/')
        end
        if airbossconfig.voices.lso then
            if airbossconfig.voices.lso == "Raynor" then
                objAirboss:SetVoiceOversLSOByRaynor(soundFilesPrefix .. 'AIRBOSS/Airboss Soundpack LSO Raynor/')
            elseif airbossconfig.voices.lso == "FF" then
                    objAirboss:SetVoiceOversLSOByFF(soundFilesPrefix .. 'AIRBOSS/Airboss Soundpack LSO FF/')
            end
        else
            objAirboss:SetVoiceOversLSOByRaynor(soundFilesPrefix .. 'AIRBOSS/Airboss Soundpack LSO Raynor/')
        end
        objAirboss:SetDebugModeOFF()
        objAirboss.trapsheet = false
        if airbossconfig.singlecarrier == true then
            objAirboss:SetMenuSingleCarrier()
        end
        if (airbossconfig.recoveryops.mode == 'cyclic') then
            if not(airbossconfig.recoveryops.cyclic.event_duration_minutes) then
                airbossconfig.recoveryops.cyclic.event_duration_minutes = 60
            end
        end
        if (airbossconfig.dl4) then
            local cvUnit = UNIT:FindByName(airbossconfig.carriername)
            cvUnit:SetCommand(
                    {
                        id = "ActivateLink4",
                        params =
                        {
                            ["unitId"] = cvUnit:GetID(),
                            ["frequency"] = airbossconfig.dl4.freq * 1000000
                        },
                    }
            )
            cvUnit:SetCommand(
                    {
                        id = "ActivateACLS",
                        params =
                        {
                            ["unitId"] = cvUnit:GetID(),
                        },
                    }
            )
        end
        objAirboss.customconfig = airbossconfig

        function objAirboss:OnAfterLSOGrade(From, Event, To, playerData, myGrade)

            local string_grade = myGrade.grade
            local player_callsign = playerData.callsign
            local unit_name = playerData.unitname
            local player_name = playerData.name
            local player_wire = playerData.wire

            player_name = player_name:gsub('[%p]', '')
            local client_performing_sh = USERFLAG:New(UNIT:FindByName(unit_name):GetClient():GetClientGroupID() + 100000000)
            --local gradeForFile
            if  string_grade == "_OK_" then
                --if  string_grade == "_OK_" and player_wire == "3" and player_Tgroove >=15 and player_Tgroove <19 then
                timer.scheduleFunction(
                        function()
                            trigger.action.outSound("Airboss Soundfiles/ffyrtp.ogg")
                        end,
                        {},
                        timer.getTime() + 5
                )
                if client_performing_sh:Get() == 1 then
                    myGrade.grade = "_OK_<SH>"
                    myGrade.points = myGrade.points
                    client_performing_sh:Set(0)
                    self:SetTrapSheet(self.trappath, "SH_unicorn_AIRBOSS-trapsheet-"..player_name)
                    timer.scheduleFunction(
                            function()
                                trigger.action.outSound("Airboss Soundfiles/sureshot.ogg")
                            end,
                            {},
                            timer.getTime() + 5
                    )
                else
                    self:SetTrapSheet(self.trappath, "unicorn_AIRBOSS-trapsheet-"..player_name)
                end

            elseif string_grade == "OK" and player_wire >1 then
                if client_performing_sh:Get() == 1 then
                    myGrade.grade = "OK<SH>"
                    myGrade.points = myGrade.points + 0.5
                    client_performing_sh:Set(0)
                    self:SetTrapSheet(self.trappath, "SH_AIRBOSS-trapsheet-"..player_name)
                else
                    self:SetTrapSheet(self.trappath, "AIRBOSS-trapsheet-"..player_name)
                end

            elseif string_grade == "(OK)" and player_wire >1 then
                self:SetTrapSheet(self.trappath, "AIRBOSS-trapsheet-"..player_name)
                if client_performing_sh:Get() == 1 then
                    myGrade.grade = "(OK)<SH>"
                    myGrade.points = myGrade.points + 1.00
                    client_performing_sh:Set(0)
                    self:SetTrapSheet(self.trappath, "SH_AIRBOSS-trapsheet-"..player_name)
                else
                    self:SetTrapSheet(self.trappath, "AIRBOSS-trapsheet-"..player_name)
                end

            elseif string_grade == "--" and player_wire >1 then
                if client_performing_sh:Get() == 1 then
                    myGrade.grade = "--<SH>"
                    myGrade.points = myGrade.points + 1.00
                    client_performing_sh:Set(0)
                    self:SetTrapSheet(self.trappath, "SH_AIRBOSS-trapsheet-"..player_name)
                else
                    self:SetTrapSheet(self.trappath, "AIRBOSS-trapsheet-"..player_name)
                end
            else
                self:SetTrapSheet(self.trappath, "AIRBOSS-trapsheet-"..player_name)
            end
            myGrade.messageType = 2
            myGrade.callsign = playerData.callsign
            myGrade.name = playerData.name
            myGrade.airbossconfig = self.customconfig
            if playerData.wire == 1 then
                myGrade.points = myGrade.points -1.00
                local onewire_to_discord = ('**'..player_name..' almost had a rampstrike with that 1-wire!**')
                GemMan:SendTable({
                    command="moose_text",
                    text=onewire_to_discord,
                    msg_type='lso'
                })
            end
            self:_SaveTrapSheet(playerData, myGrade)

            --if self.funkmanSocket then
            --
            --    -- Extract used info for FunkMan. We need to be careful with the amount of data send via UDP socket.
            --    local trapsheet={} ; trapsheet.X={} ; trapsheet.Z={} ; trapsheet.AoA={} ; trapsheet.Alt={}
            --
            --    -- Loop over trapsheet and extract used values.
            --    for i = 1, #playerData.trapsheet do
            --        local ts=playerData.trapsheet[i] --#AIRBOSS.GrooveData
            --        table.insert(trapsheet.X, UTILS.Round(ts.X, 1))
            --        table.insert(trapsheet.Z, UTILS.Round(ts.Z, 1))
            --        table.insert(trapsheet.AoA, UTILS.Round(ts.AoA, 2))
            --        table.insert(trapsheet.Alt, UTILS.Round(ts.Alt, 1))
            --    end
            --
            --    local result={}
            --    result.command=SOCKET.DataType.LSOGRADE
            --    result.name=playerData.name
            --    result.trapsheet=trapsheet
            --    result.airframe=myGrade.airframe
            --    result.modex=myGrade.modex
            --    result.mitime=myGrade.mitime
            --    result.midate=myGrade.midate
            --    result.wind=myGrade.wind
            --    result.carriertype=myGrade.carriertype
            --    result.carriername=myGrade.carriername
            --    result.carrierrwy=myGrade.carrierrwy
            --    result.landingdist=self.carrierparam.landingdist
            --    result.theatre=myGrade.theatre
            --    result.case=playerData.case
            --    result.Tgroove=myGrade.Tgroove
            --    result.wire=myGrade.wire
            --    result.grade=myGrade.grade
            --    result.points=myGrade.points
            --    result.details=myGrade.details
            --    result.finalscore=myGrade.finalscore or myGrade.points
            --
            --    -- Debug info.
            --    self:T(self.lid.."Result onafterLSOGrade")
            --    self:T(result)
            --
            --    -- Send result.
            --    self.funkmanSocket:SendTable(result)
            --end

            --TODO reactivate the timer.schedule maybe ?
            --timer.scheduleFunction(
            --        function(airbossObject)
            --            airbossObject:SetTrapSheet(airbossObject.trappath)
            --        end,
            --        {self},
            --        timer.getTime() + 10
            --)
            --local myScheduleTime = TIMER:New(10, nil,nil):resetTrapSheetFileFormat()
        end



        function objAirboss:OnAfterRecoveryStart(From, Event, To, Case, Offset)
            self:MessageToMarshal('Recovery started Case '..Case..'...', self.customconfig.alias, "", 30, false, 10)
        end

        function objAirboss:OnAfterRecoveryStop(From, Event, To)
            self:MessageToMarshal('Recovery finished.', self.customconfig.alias, "", 30, false, 10)
            if (airbossconfig.recoveryops.mode == 'cyclic') then
                if self.recoverywindow then
                    if ((timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*1/3, 0) > self.recoverywindow.STOP)
                            or (timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*3/3, 0) < self.recoverywindow.START)) then
                        if ((timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*3/3, 0)) >= (self:GetCoordinate():GetSunset(true) - 30*60)) then
                            --fin du prochain event apres la nuit aeronavale
                            self:MessageToMarshal('switching to case III due to Naval Sunset on the next event !', self.customconfig.alias, "", 45, false, 0)
                            self:SetRecoveryCase(3)
                            self:SetMaxSectionSize(1)
                        else
                            if ((timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*1/3, 0)) >= (self:GetCoordinate():GetSunrise(true) + 30*60)) then
                                --debut du prochain recovery apres l aube aeronavale
                                self:SetRecoveryCase(self.customconfig.recoverycase)
                                if self.customconfig.recoverycase == 3 then
                                    self:SetMaxSectionSize(1)
                                else
                                    self:SetMaxSectionSize(4)
                                end
                            end
                        end
                        self:AddRecoveryWindow(
                                UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*1/3, 0),
                                UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*3/3, 0),
                                self.defaultcase,
                                self.customconfig.menurecovery.offset,
                                true,
                                self.customconfig.menurecovery.windondeck,
                                self.customconfig.menurecovery.uturn
                        )
                        self:MessageToMarshal('Next Recovery in : '..UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes/3, 0)..' minutes', self.customconfig.alias, "", 30, false, 0)
                        --LeaveRecovery(self)
                    end
                else
                    if ((timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*3/3,0)) >= (self:GetCoordinate():GetSunset(true) - 30*60)) then
                        --fin du prochain event apres la nuit aeronavale
                        self:MessageToMarshal('switching to case III due to Naval Sunset on the next event !', self.customconfig.alias, "", 45, false, 0)
                        self:SetRecoveryCase(3)
                        self:SetMaxSectionSize(1)
                    else
                        if ((timer.getAbsTime() + UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*1/3, 0)) >= (self:GetCoordinate():GetSunrise(true) + 30*60)) then
                            --debut du prochain recovery apres l aube aeronavale
                            self:SetRecoveryCase(self.customconfig.recoverycase)
                            if self.customconfig.recoverycase == 3 then
                                self:SetMaxSectionSize(1)
                            else
                                self:SetMaxSectionSize(4)
                            end
                        end
                    end
                    self:AddRecoveryWindow(
                            UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*1/3, 0),
                            UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes*60*3/3, 0),
                            self.defaultcase,
                            self.customconfig.menurecovery.offset,
                            true,
                            self.customconfig.menurecovery.windondeck,
                            self.customconfig.menurecovery.uturn
                    )
                    self:MessageToMarshal('Next Recovery in : '..UTILS.Round(self.customconfig.recoveryops.cyclic.event_duration_minutes/3, 0)..' minutes', self.customconfig.alias, "", 30, false, 0)
                    --LeaveRecovery(self)
                end
            end
        end

        AIRBOSSArray[compteur] = objAirboss
        AIRBOSSArray[compteur]:Start()
        AIRBOSSArray[compteur].CVN_GROUPZone = ZONE_GROUP:New(
                'cvnGroupZone-'..AIRBOSSArray[compteur].customconfig.alias,
                AIRBOSSArray[compteur].carrier:GetGroup(),
                1111)
        AIRBOSSArray[compteur].CVNClients = SET_CLIENT:New()
                                                      :FilterCoalitions(UTILS.GetCoalitionName(AIRBOSSArray[compteur].customconfig.coalition))
                                                      :FilterStart()
        local myscheduler
        local myschedulerID
        myscheduler, myschedulerID = SCHEDULER:New(
                nil,
                detectShitHotBreak,
                {AIRBOSSArray[compteur]},
                2,
                1
        )
        AIRBOSSArray[compteur].scheduler = myscheduler
        AIRBOSSArray[compteur].schedulerID = myschedulerID
        --trigger.action.outText('INFO '..airbossconfig.alias..' : Naval sunset at '..UTILS.SecondsToClock((AIRBOSSArray[compteur]:GetCoordinate():GetSunset(true) - 30*60)), 75)
        if (airbossconfig.recoveryops.mode == 'cyclic') then
            if ((timer.getAbsTime() + airbossconfig.recoveryops.cyclic.event_duration_minutes*60) >= (AIRBOSSArray[compteur]:GetCoordinate():GetSunset(true) - 30*60)) then
                AIRBOSSArray[compteur]:MessageToMarshal('switching to case III due to Naval Sunset on the next event !', airbossconfig.alias, "", 45, false, 0)
                AIRBOSSArray[compteur]:SetRecoveryCase(3)
                AIRBOSSArray[compteur]:SetMaxSectionSize(1)
            else
                if ((timer.getAbsTime() + UTILS.Round(airbossconfig.recoveryops.cyclic.event_duration_minutes*60/3, 0)) >= (AIRBOSSArray[compteur]:GetCoordinate():GetSunrise(true) + 30*60)) then
                    AIRBOSSArray[compteur]:SetRecoveryCase(airbossconfig.recoverycase)
                    if airbossconfig.recoverycase == 3 then
                        AIRBOSSArray[compteur]:SetMaxSectionSize(1)
                    else
                        AIRBOSSArray[compteur]:SetMaxSectionSize(4)
                    end
                end
            end
            if airbossconfig.recoveryops.cyclic.event_ia_reserved_minutes then
                AIRBOSSArray[compteur]:AddRecoveryWindow(
                        (airbossconfig.recoveryops.cyclic.event_ia_reserved_minutes)*60+UTILS.Round(airbossconfig.recoveryops.cyclic.event_duration_minutes*60*0/3, 0),
                        (airbossconfig.recoveryops.cyclic.event_ia_reserved_minutes)*60+UTILS.Round(airbossconfig.recoveryops.cyclic.event_duration_minutes*60*2/3, 0),
                        AIRBOSSArray[compteur].defaultcase,
                        airbossconfig.menurecovery.offset,
                        true,
                        airbossconfig.menurecovery.windondeck,
                        airbossconfig.menurecovery.uturn
                )
            else
                AIRBOSSArray[compteur]:AddRecoveryWindow(
                        15*60+UTILS.Round(airbossconfig.recoveryops.cyclic.event_duration_minutes*60*0/3, 0),
                        15*60+UTILS.Round(airbossconfig.recoveryops.cyclic.event_duration_minutes*60*2/3, 0),
                        AIRBOSSArray[compteur].defaultcase,
                        airbossconfig.menurecovery.offset,
                        true,
                        airbossconfig.menurecovery.windondeck,
                        airbossconfig.menurecovery.uturn
                )
            end
        else
            if (airbossconfig.recoveryops.mode == 'alpha') then
                if (airbossconfig.recoveryops.alpha) then
                    if (airbossconfig.recoveryops.alpha.recoveries) then
                        for alphaindex, alphaevent in ipairs(airbossconfig.recoveryops.alpha.recoveries) do
                            local effectiveeventcase = airbossconfig.recoverycase or 1
                            if (alphaevent.recovery_case) then
                                effectiveeventcase = alphaevent.recovery_case
                            end
                            if (env.mission.start_time +
                                    ( ( alphaevent.recovery_start_minutes +
                                            alphaevent.recovery_duration_minutes ) * 60
                                    )
                                    >= (AIRBOSSArray[compteur]:GetCoordinate():GetSunset(true) - 30*60)) then
                                effectiveeventcase = 3
                            end
                            AIRBOSSArray[compteur]:AddRecoveryWindow(
                                    UTILS.SecondsToClock(env.mission.start_time + (alphaevent.recovery_start_minutes * 60) ),
                                    UTILS.SecondsToClock(env.mission.start_time +
                                            ( (alphaevent.recovery_start_minutes + alphaevent.recovery_duration_minutes) * 60)),
                                    effectiveeventcase,
                                    airbossconfig.menurecovery.offset,
                                    true,
                                    airbossconfig.menurecovery.windondeck,
                                    airbossconfig.menurecovery.uturn
                            )
                        end
                    end
                end
            end
        end
        trigger.action.outText('AIRBOSS scripts Loaded for unit '..airbossconfig.carriername, 10)
        timer.scheduleFunction(function()
            trigger.action.outText(	"<< If the AIRBOSS option does not appear in your F10 - Other Menu, try switching slots a few times and you will get the AIRBOSS message popups! Check the AIRBOSS documentation (link in briefing for more info) >>", 30)
        end, nil, timer.getTime() + 30  )
    else
        timer.scheduleFunction(function()
            trigger.action.outText('AIRBOSS script disabled for unit '..airbossconfig.carriername, 10)
        end, nil, timer.getTime() + 8  )
    end
end
