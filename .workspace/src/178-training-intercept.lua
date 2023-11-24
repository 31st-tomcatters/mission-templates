-- *****************************************************************************
--                     **                    Interception Training            **
--                     *********************************************************
function clearIntercept(param)
    local objInterceptIndex = param[1]
    local objIntercept = InterceptArray[objInterceptIndex]
    debug_msg(string.format("Intercept: objIntercept.objSpawn is %s", net.lua2json(objIntercept.objSpawn)))
    local GroupPlane, Index = objIntercept.objSpawn:GetFirstAliveGroup()
    while GroupPlane ~= nil do
        GroupPlane:ScheduleStop()
        GroupPlane:Destroy(true,0)
        GroupPlane, Index = objIntercept.objSpawn:GetNextAliveGroup( Index )
    end
    collectgarbage()
end

function interceptDefendFicghter(targetGroup)
    targetGroup:OptionROEWeaponFree()
    targetGroup:OptionROTVertical()
    targetGroup:OptionRTBBingoFuel(true)
    targetGroup:OptionRestrictBurner(false)
    targetGroup:EnableEmission(true)
    targetGroup:OptionAlarmStateRed()
    targetGroup:OptionECM_DetectedLockByRadar()
    targetGroup:CommandEPLRS(true)
end

function interceptDefendFastBomber(targetGroup)
    targetGroup:OptionRestrictBurner(false)
    local targetDestinationCoord = targetGroup:GetCoordinate():Translate(
            UTILS.NMToMeters(150),
            targetGroup:GetHeading(),
            true,
            false
    ):SetAltitude(UTILS.FeetToMeters(55000), true)
    targetGroup:Route(
            {
                targetDestinationCoord:WaypointAirTurningPoint(
                        COORDINATE.WaypointAltType.BARO,
                        UTILS.KnotsToKmph(5000),
                        nil,
                        "End interception"
                ),
                targetDestinationCoord:GetClosestAirbase(
                        targetGroup:GetCategory(),
                        targetGroup:GetCoalition()
                ):GetCoordinate():WaypointAirLanding(
                        UTILS.KnotsToKmph(250),
                        targetDestinationCoord:GetClosestAirbase(
                                targetGroup:GetCategory(),
                                targetGroup:GetCoalition()
                        )
                )
            }
    )
end

function interceptDetection(param)
    local objIntercept = param[1]
    debug_msg(string.format("Intercept: objIntercept.interceptDetectionZone is %s", net.lua2json(objIntercept.interceptDetectionZone)))
    --debug_msg(string.format("Intercept: interceptorUnitName is %s", net.lua2json(interceptorUnitName)))
    if ( objIntercept.bubbleInvaded == false ) then
        debug_msg(string.format("Intercept: %s has not yet been intercepted", objIntercept.interceptTarget:GetName()))
        --debug_msg(string.format("Intercept: interceptDetectionZone is %s", net.lua2json(interceptDetectionZone)))
        if (SET_CLIENT:New():FilterZones({objIntercept.interceptDetectionZone}):FilterOnce():CountAlive() > 0) then
            objIntercept.bubbleInvaded = true
            debug_msg(string.format("Intercept: %s has been intercepted", objIntercept.interceptTarget:GetName()))
            if (objIntercept.knowIsIntercepted == false) then
                if (math.random(1,100) >= 75) then
                    local delay = math.random(15,120)
                    debug_msg(string.format("Intercept: %s has detected it has been intercepted : he will react accordingly in %i seconds !", objIntercept.interceptTarget:GetName(), delay))
                    objIntercept.knowIsIntercepted = true
                    if objIntercept.customconfig.type == 'fastbomber' then
                        SCHEDULER:New(
                                objIntercept.interceptTarget,
                                interceptDefendFastBomber,
                                {},
                                delay
                        )
                    elseif objIntercept.customconfig.type == 'fighter' then
                        SCHEDULER:New(
                                objIntercept.interceptTarget,
                                interceptDefendFicghter,
                                {},
                                delay
                        )
                    end
                else
                    debug_msg(string.format("Intercept: %s has not detected soon enough it has been intercepted", objIntercept.interceptTarget:GetName()))
                end
            end
        end
    end
end

function StartInterceptTraining(param)
    local fighterUnitName = param[1]
    local objInterceptIndex = param[2]
    local minTA = param[3]
    local maxTA = param[4]
    local fighterUnit = UNIT:FindByName(fighterUnitName)
    local fighterGroup = fighterUnit:GetGroup()
    local fighterCoord = fighterUnit:GetCoordinate()
    local fighterHeading = fighterUnit:GetHeading()
    local fighterAltitude = fighterUnit:GetAltitude(false)
    local deltaAltMax = nil
    local targetGroup = nil
    local targetRange = nil
    local targetGroundSpeed = 450
    local targetAngle = math.mod(minTA + math.random(0,maxTA-minTA),360)
    if (math.abs(math.mod(targetAngle,180)) > 50) then
        targetRange = 40
        deltaAltMax = 7000
    elseif (math.abs(math.mod(targetAngle,180)) > 20) then
        targetRange = 60
        deltaAltMax = 10000
    else
        targetRange = 90
        deltaAltMax = 15000
    end
    debug_msg(string.format("Intercept: Launching exercise TargetAngle %i degrees", targetAngle))
    debug_msg(string.format("Intercept: Index is : %i", objInterceptIndex))
    local targetSpawnObj = InterceptArray[objInterceptIndex].objSpawn
    local targetCoord = POINT_VEC3:NewFromVec3(
            {
                x = fighterCoord.x + math.floor(UTILS.NMToMeters(targetRange) * math.cos(math.rad(fighterHeading))),
                y = math.max(
                        math.min(
                                math.random(
                                        fighterCoord.y - UTILS.FeetToMeters(deltaAltMax),
                                        fighterCoord.y + UTILS.FeetToMeters(deltaAltMax)
                                ),
                                UTILS.FeetToMeters(32000)
                        ),
                        UTILS.FeetToMeters(8000)
                ),
                z = fighterCoord.z + math.floor(UTILS.NMToMeters(targetRange) * math.sin(math.rad(fighterHeading))),
            }
    )
    debug_msg(string.format("Intercept: Spawning target based on %s with TargetAngle of %i degrees", targetSpawnObj.SpawnTemplatePrefix, targetAngle))
    targetGroup = targetSpawnObj:InitHeading(math.mod(fighterHeading + 180 + targetAngle,360)):SpawnFromVec3(targetCoord)
    targetGroup:OptionROE(ENUMS.ROE.WeaponHold)
    targetGroup:OptionROT(ENUMS.ROT.NoReaction)
    targetGroup:OptionRTBBingoFuel(true)
    targetGroup:OptionRestrictBurner(false)
    targetGroup:EnableEmission(false)
    targetGroup:OptionAlarmStateGreen()
    targetGroup:OptionECM_Never()
    targetGroup:CommandEPLRS(true)
    InterceptArray[objInterceptIndex].interceptTarget = targetGroup
    InterceptArray[objInterceptIndex].knowIsIntercepted = false
    InterceptArray[objInterceptIndex].bubbleInvaded = false
    local targetDetectionRange = 1.5
    --targetDetectionRange = 70
    InterceptArray[objInterceptIndex].interceptDetectionZone = ZONE_GROUP:New(
            "intercept-" .. targetGroup:GetName(),
            targetGroup,
            UTILS.NMToMeters(targetDetectionRange)
    )
    InterceptArray[objInterceptIndex].interceptTarget:ScheduleRepeat(
            0,
            5,
            nil,
            nil,
            interceptDetection,
            {
                InterceptArray[objInterceptIndex]
            }
    )
    local targetDestinationCoord = targetGroup:GetCoordinate():Translate(
            UTILS.NMToMeters(200),
            math.mod(fighterHeading+180+ targetAngle,360),
            true,
            false
    )
    targetGroup:Route(
            {
                targetDestinationCoord:WaypointAirTurningPoint(
                        COORDINATE.WaypointAltType.BARO,
                        UTILS.KnotsToKmph(targetGroundSpeed),
                        nil,
                        "End interception"
                ),
                targetDestinationCoord:GetClosestAirbase(
                        targetGroup:GetCategory(),
                        targetGroup:GetCoalition()
                ):GetCoordinate():WaypointAirLanding(
                        UTILS.KnotsToKmph(targetGroundSpeed),
                        targetDestinationCoord:GetClosestAirbase(
                                targetGroup:GetCategory(),
                                targetGroup:GetCoalition()
                        )
                )
            }
    )
    return targetGroup
end

InterceptArray = {}
compteur = 0
MenuCoalitionInterceptBlue = MENU_COALITION:New(coalition.side.BLUE, "Intercept Training", MenuCoalitionBlue)
MenuCoalitionInterceptRed = MENU_COALITION:New(coalition.side.RED, "Intercept Training", MenuCoalitionRed)
for index, intconfig in ipairs(InterceptConfig) do
    if intconfig.enable == true then
        debug_msg(string.format("Intercept: Enable %s with %s behavior", intconfig.name, intconfig.type))
        compteur = compteur +1
        local objIntercept = {
            customconfig = {},
            objSpawn = nil,
            menus = {},
            menu_finex = {},
            knowIsIntercepted = false,
            bubbleInvaded = false,
        }
        objIntercept.objSpawn = SPAWN:New(intconfig.templates[1])
                                     :InitSkill(intconfig.skill)
                                     :InitRandomizeTemplatePrefixes(intconfig.templates)
        if (intconfig.type == 'civil') then
            objIntercept.menus[coalition.side.BLUE] = MENU_COALITION:New(coalition.side.BLUE, intconfig.name, MenuCoalitionInterceptBlue)
            objIntercept.menu_finex[coalition.side.BLUE] = MENU_COALITION_COMMAND:New(
                    coalition.side.BLUE,
                    "Knock it off, FinEx !!",
                    objIntercept.menus[coalition.side.BLUE],
                    clearIntercept,
                    {
                        compteur
                    }
            )
            objIntercept.menus[coalition.side.RED] = MENU_COALITION:New(coalition.side.RED, intconfig.name, MenuCoalitionInterceptRed)
            objIntercept.menu_finex[coalition.side.RED] = MENU_COALITION_COMMAND:New(
                    coalition.side.RED,
                    "Knock it off, FinEx !!",
                    objIntercept.menus[coalition.side.RED],
                    clearIntercept,
                    {
                        compteur
                    }
            )
        else
            if (intconfig.benefitCoalition == coalition.side.BLUE) then
                objIntercept.menus[intconfig.benefitCoalition] = MENU_COALITION:New(intconfig.benefitCoalition, intconfig.name, MenuCoalitionInterceptBlue)
            else
                objIntercept.menus[intconfig.benefitCoalition] = MENU_COALITION:New(intconfig.benefitCoalition, intconfig.name, MenuCoalitionInterceptRed)
            end
            objIntercept.menu_finex[intconfig.benefitCoalition] = MENU_COALITION_COMMAND:New(
                    intconfig.benefitCoalition,
                    "Knock it off, FinEx !!",
                    objIntercept.menus[intconfig.benefitCoalition],
                    clearIntercept,
                    {
                        compteur
                    }
            )
        end
        objIntercept.customconfig = intconfig
        InterceptArray[compteur] = objIntercept
    end
end

if compteur == 0 then
    MenuCoalitionInterceptBlue:Remove()
    MenuCoalitionInterceptRed:Remove()
end
