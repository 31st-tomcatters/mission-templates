-- *****************************************************************************
--                     **                CAPZone War                          **
--                     *********************************************************
function toggleDebugCapWarZone(objCapWarZone)
    objCapWarZone.objDispatcher:SetTacticalDisplay(not(objCapWarZone.objDispatcher.TacticalDisplay))
end

function wipeCapWarZone(objCapWarZone)
    objCapWarZone.objDispatcher:SetTacticalDisplay(false)
    objCapWarZone.objDispatcher:Stop()
    objCapWarZone.objDispatcher = nil
    objCapWarZone.objDetectionAreas = nil
    objCapWarZone.objEWRNetwork = nil
    objCapWarZone.objMenu:RemoveSubMenus()
    MENU_MISSION_COMMAND:New(
            "Start ".. objCapWarZone.customconfig.name .. " CAP War Zone",
            objCapWarZone.objMenu,
            startCapWarZone,
            objCapWarZone)
    trigger.action.outText('CAP War Zone '..(objCapWarZone.customconfig.name)..' disabled !!', 30)
end

function startCapWarZone(objCapWarZone)
    objCapWarZone.objEWRNetwork = SET_GROUP:New()
    objCapWarZone.objEWRNetwork:FilterPrefixes(objCapWarZone.customconfig.ewrPrefixes)
    objCapWarZone.objEWRNetwork:FilterStart()
    objCapWarZone.objDetectionAreas = DETECTION_AREAS:New( objCapWarZone.objEWRNetwork, UTILS.NMToMeters(objCapWarZone.customconfig.detectionGroupingRadius or UTILS.MetersToNM(30000)))
    objCapWarZone.objDispatcher = AI_A2A_DISPATCHER:New( objCapWarZone.objDetectionAreas )
    objCapWarZone.objDispatcher:SetBorderZone(objCapWarZone.objZone)
    objCapWarZone.objDispatcher:SetEngageRadius(UTILS.NMToMeters(objCapWarZone.customconfig.engageRadius or UTILS.MetersToNM(100000)))
    objCapWarZone.objDispatcher:SetGciRadius(UTILS.NMToMeters(objCapWarZone.customconfig.gciRadius or UTILS.MetersToNM(200000)))
    objCapWarZone.objDispatcher:SetDefaultTakeoffFromParkingHot()
    objCapWarZone.objDispatcher:SetDefaultLandingAtRunway()
    objCapWarZone.objDispatcher:SetDefaultFuelThreshold(0.30)
    objCapWarZone.objDispatcher:SetDefaultCapRacetrack(
            UTILS.NMToMeters(20),
            UTILS.NMToMeters(40),
            0,
            180,
            15*60,
            45*60
    )
    for indexbase, capbaseconfig in ipairs(objCapWarZone.customconfig.CAPBases) do
        for indexcapsqn, capsqnconfig in ipairs(capbaseconfig.patrolSquadrons) do
            if capsqnconfig.enable then
                if AIRBASE:FindByName(capbaseconfig.baseName) then
                    --baseName is Airbase
                    objCapWarZone.objDispatcher:SetSquadron(
                            "CAP-"..capbaseconfig.baseName.."-"..indexcapsqn,
                            capbaseconfig.baseName,
                            capsqnconfig.groupName,
                            capsqnconfig.groupNumber * capsqnconfig.groupForce
                    )
                    objCapWarZone.objDispatcher:SetSquadronGrouping(
                            "CAP-"..capbaseconfig.baseName.."-"..indexcapsqn,
                            capsqnconfig.groupForce
                    )
                else
                    --baseName is not an Airbase --> Airstart
                    objCapWarZone.objDispatcher:SetSquadron(
                            "CAP-"..capbaseconfig.baseName.."-"..indexcapsqn,
                            capbaseconfig.baseName,
                            capsqnconfig.groupName,
                            capsqnconfig.groupNumber * capsqnconfig.groupForce
                    )
                    objCapWarZone.objDispatcher:SetSquadronGrouping(
                            "CAP-"..capbaseconfig.baseName.."-"..indexcapsqn,
                            capsqnconfig.groupForce
                    )
                    objCapWarZone.objDispatcher:SetSquadronTakeoffInAir(
                            "CAP-"..capbaseconfig.baseName.."-"..indexcapsqn,
                            UTILS.FeetToMeters(20000)
                    )
                end
                function objCapWarZone.objDispatcher:OnEventBirth(eventData)
                    local unit = UNIT:Find(eventData.initiator)
                    if (objCapWarZone.customconfig.fireRange) then
                        unit:OptionAAAttackRange(objCapWarZone.customconfig.fireRange)
                    else
                        unit:OptionAAAttackRange(AAMAxRange.TARGET_THREAT_EST)
                    end
                    unit:OptionROT(ENUMS.ROT.EvadeFire)
                end
                local CapZone = nil
                if capsqnconfig.patrolZoneName then
                    if capsqnconfig.patrolZoneGroupName then
                        CapZone = ZONE_POLYGON:New(capsqnconfig.patrolZoneGroupName, GROUP:FindByName(capsqnconfig.patrolZoneGroupName))
                    else
                        CapZone = ZONE:New(capsqnconfig.patrolZoneName)
                    end
                else
                    if capsqnconfig.patrolZoneGroupName then
                        CapZone = ZONE_POLYGON:New(capsqnconfig.patrolZoneGroupName, GROUP:FindByName(capsqnconfig.patrolZoneGroupName))
                    else
                        CapZone = objCapWarZone.objZone
                    end
                end
                objCapWarZone.objDispatcher:SetSquadronCap(
                        "CAP-"..capbaseconfig.baseName.."-"..indexcapsqn,
                        CapZone,
                        UTILS.FeetToMeters(objCapWarZone.customconfig.capParameters.patrolFloor) or UTILS.FeetToMeters(20000),
                        UTILS.FeetToMeters(objCapWarZone.customconfig.capParameters.patrolCeiling) or UTILS.FeetToMeters(50000),
                        UTILS.KnotsToKmph(objCapWarZone.customconfig.capParameters.minPatrolSpeed) or UTILS.KnotsToKmph(200),
                        UTILS.KnotsToKmph(objCapWarZone.customconfig.capParameters.maxPatrolSpeed) or UTILS.KnotsToKmph(400),
                        UTILS.KnotsToKmph(objCapWarZone.customconfig.capParameters.minEngageSpeed) or UTILS.KnotsToKmph(200),
                        UTILS.KnotsToKmph(objCapWarZone.customconfig.capParameters.maxEngageSpeed) or UTILS.KnotsToKmph(2000),
                        "BARO"
                )
                objCapWarZone.objDispatcher:SetSquadronCapInterval(
                        "CAP-"..capbaseconfig.baseName.."-"..indexcapsqn,
                        capsqnconfig.patrolInAirNumber,
                        8*60,
                        13*60,
                        1
                )
            end
        end
        for indexinterceptsqn, interceptsqnconfig in ipairs(capbaseconfig.interceptSquadrons) do
            if interceptsqnconfig.enable then
                if AIRBASE:FindByName(capbaseconfig.baseName) then
                    --baseName is Airbase
                    objCapWarZone.objDispatcher:SetSquadron(
                            "GCI-"..capbaseconfig.baseName.."-"..indexinterceptsqn,
                            capbaseconfig.baseName,
                            interceptsqnconfig.groupName,
                            interceptsqnconfig.groupNumber
                    )
                    objCapWarZone.objDispatcher:SetSquadronGrouping(
                            "GCI-"..capbaseconfig.baseName.."-"..indexinterceptsqn,
                            interceptsqnconfig.groupForce
                    )
                else
                    --baseName is not an Airbase --> Airstart
                end
                objCapWarZone.objDispatcher:SetSquadronGci(
                        "GCI-"..capbaseconfig.baseName.."-"..indexinterceptsqn,
                        UTILS.KnotsToKmph(objCapWarZone.customconfig.capParameters.minEngageSpeed) or UTILS.KnotsToKmph(200),
                        UTILS.KnotsToKmph(objCapWarZone.customconfig.capParameters.maxEngageSpeed) or UTILS.KnotsToKmph(5000)
                )
            end
        end
    end
    objCapWarZone.objDispatcher:SetTacticalDisplay(objCapWarZone.customconfig.debug or false)
    objCapWarZone.objMenu:RemoveSubMenus()
    MENU_MISSION_COMMAND:New(
            "Stop ".. objCapWarZone.customconfig.name .. " CAP War Zone",
            objCapWarZone.objMenu,
            wipeCapWarZone,
            objCapWarZone
    )
    MENU_MISSION_COMMAND:New(
            "Toggle Display Status ".. objCapWarZone.customconfig.name .. " CAP War Zone",
            objCapWarZone.objMenu,
            toggleDebugCapWarZone,
            objCapWarZone
    )
end

CAPWarZoneArray = {}
compteur = 0
MenuCoalitionCAPWarZone = MENU_MISSION:New("CAP War Zones", nil)
for index, capwarzoneconfig in ipairs(WarCAPConfig) do
    if capwarzoneconfig.enable == true and #(capwarzoneconfig.ewrPrefixes) > 0 then
        compteur = compteur + 1
        env.info('creation CAP WarZone : '.. capwarzoneconfig.name..'...')
        objCapWarZone = {}
        if capwarzoneconfig.borderZoneGroupName then
            objCapWarZone.objZone = ZONE_POLYGON:New( capwarzoneconfig.borderZoneGroupName, GROUP:FindByName( capwarzoneconfig.borderZoneGroupName ) )
        else
            if capwarzoneconfig.borderZoneName then
                objCapWarZone.objZone = ZONE:New(capwarzoneconfig.borderZoneName)
            else
                objCapWarZone.objZone = ZONE_GROUP:New(
                        "border_" .. capwarzoneconfig.name,
                        GROUP:FindByName(capwarzoneconfig.ewrPrefixes[1]),
                        UTILS.NMToMeters(600)
                )
            end
        end
        objCapWarZone.customconfig = capwarzoneconfig
        objCapWarZone.objMenu = MENU_MISSION:New(capwarzoneconfig.name, MenuCoalitionCAPWarZone)
        objCapWarZone.objMenu:RemoveSubMenus()
        CAPWarZoneArray[compteur] = objCapWarZone
        MENU_MISSION_COMMAND:New(
                "Start ".. capwarzoneconfig.name .. " CAP War Zone",
                CAPWarZoneArray[compteur].objMenu,
                startCapWarZone,
                CAPWarZoneArray[compteur])
    end
end
