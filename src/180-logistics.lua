-- *****************************************************************************
--                     **                     CTLD Logistics                  **
--                     *********************************************************

CTLDArray = {}
compteur = 0
mainRadioMenuForLogisticsBlue =  MENU_COALITION:New( coalition.side.BLUE , "Logistics", MenuCoalitionBlue )
mainRadioMenuForLogisticsRed =  MENU_COALITION:New( coalition.side.RED , "Logistics", MenuCoalitionRed )
for index, ctldconfig in ipairs(CTLDConfig) do
    if ctldconfig.enable == true then
        compteur = compteur + 1
        env.info('creation Logistics : '.. ctldconfig.name..'...')
        CTLDArray[compteur] = {
            customconfig = ctldconfig,
            CTLDObject = CTLD:New(ctldconfig.benefit_coalition,{},ctldconfig.name),
            LogisticsRootMenu = {},
            SubLogisticsMenus = {},
        }
        if (ctldconfig.benefit_coalition == coalition.side.BLUE) then
            CTLDArray[compteur].LogisticsRootMenu = MENU_COALITION:New( coalition.side.BLUE, ctldconfig.name , mainRadioMenuForLogisticsBlue)
            local radioMenuForRange = CTLDArray[compteur].LogisticsRootMenu
        else
            CTLDArray[compteur].LogisticsRootMenu = MENU_COALITION:New( coalition.side.RED, ctldconfig.name , mainRadioMenuForLogisticsRed)
            local radioMenuForRange = CTLDArray[compteur].LogisticsRootMenu
        end
        CTLDArray[compteur].CTLDObject.useprefix = ctldconfig.useprefix
        CTLDArray[compteur].CTLDObject.CrateDistance = ctldconfig.CrateDistance or 35
        CTLDArray[compteur].CTLDObject.dropcratesanywhere = ctldconfig.dropcratesanywhere
        CTLDArray[compteur].CTLDObject.maximumHoverHeight = ctldconfig.maximumHoverHeight or 15
        CTLDArray[compteur].CTLDObject.minimumHoverHeight = ctldconfig.minimumHoverHeight or 4
        CTLDArray[compteur].CTLDObject.forcehoverload = ctldconfig.forcehoverload
        CTLDArray[compteur].CTLDObject.hoverautoloading = ctldconfig.hoverautoloading
        CTLDArray[compteur].CTLDObject.smokedistance = ctldconfig.smokedistance or UTILS.NMToMeters(5)
        CTLDArray[compteur].CTLDObject.movetroopstowpzone = ctldconfig.movetroopstowpzone
        CTLDArray[compteur].CTLDObject.movetroopsdistance = ctldconfig.movetroopsdistance or UTILS.NMToMeters(3)
        CTLDArray[compteur].CTLDObject.smokedistance = ctldconfig.smokedistance or UTILS.NMToMeters(2)
        CTLDArray[compteur].CTLDObject.suppressmessages = ctldconfig.suppressmessages
        CTLDArray[compteur].CTLDObject.repairtime = ctldconfig.repairtime or 300
        CTLDArray[compteur].CTLDObject.buildtime = ctldconfig.buildtime or 300
        CTLDArray[compteur].CTLDObject.allowcratepickupagain = ctldconfig.allowcratepickupagain
        CTLDArray[compteur].CTLDObject.enableslingload = ctldconfig.enableslingload
        CTLDArray[compteur].CTLDObject.pilotmustopendoors = ctldconfig.pilotmustopendoors
        CTLDArray[compteur].CTLDObject.placeCratesAhead = ctldconfig.placeCratesAhead
        CTLDArray[compteur].CTLDObject.nobuildinloadzones = ctldconfig.nobuildinloadzones
        for indexzone, zone in ipairs(ctldconfig.zones) do
            CTLDArray[compteur].CTLDObject:AddCTLDZone(
                    zone.zoneName,
                    zone.zoneType or CTLD.CargoZoneType.LOAD,
                    zone.smokeColor or nil,
                    zone.active or false,
                    zone.beacon or false)
        end
        for indexcrate, crate in ipairs(ctldconfig.crates) do
            CTLDArray[compteur].CTLDObject:AddCratesCargo(
                    crate.crateName,
                    crate.templateGroups or {},
                    crate.crateCargoType or CTLD_CARGO.Enum.CRATE,
                    crate.crateNumber or 1,
                    crate.crateWeight or 0,
                    crate.crateStock or 10
            )
        end
        for indextroops, troop in ipairs(ctldconfig.troops) do
            CTLDArray[compteur].CTLDObject:AddTroopsCargo(
                    troop.troopName,
                    troop.templateGroups or {},
                    troop.crateCargoType or CTLD_CARGO.Enum.TROOPS,
                    troop.troopSeats or 1,
                    troop.troopWeight or 0,
                    troop.troopStock or 10
            )
        end
        CTLDArray[compteur].CTLDObject:__Start(5)
    end
end

if compteur == 0 then
    mainRadioMenuForLogisticsBlue:Remove()
    mainRadioMenuForLogisticsRed:Remove()
end
