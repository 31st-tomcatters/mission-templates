-- *****************************************************************************
--                     **                     RANGES                         **
--                     *********************************************************

RangesArray = {}
compteur = 0
mainRadioMenuForRangesBlue =  MENU_COALITION:New( coalition.side.BLUE , "RANGES", MenuCoalitionBlue )
mainRadioMenuForRangesRed =  MENU_COALITION:New( coalition.side.RED , "RANGES", MenuCoalitionRed )
for index, rangeconfig in ipairs(RangeConfig) do
    if rangeconfig.enable == true then
        compteur = compteur + 1
        env.info('creation Range : '.. rangeconfig.name..'...')
        RangesArray[compteur] = {
            customconfig = rangeconfig,
            RangeRootMenu = {},
            SubRangeMenus = {},
        }
        if (rangeconfig.benefit_coalition == coalition.side.BLUE) then
            RangesArray[compteur].RangeRootMenu = MENU_COALITION:New( coalition.side.BLUE, rangeconfig.name , mainRadioMenuForRangesBlue)
            local radioMenuForRange = RangesArray[compteur].RangeRootMenu
            for indexsubRange, subRangeConfig in ipairs(rangeconfig.subRange) do
                RangesArray[compteur].SubRangeMenus[indexsubRange] = MENU_COALITION:New(rangeconfig.benefit_coalition, subRangeConfig.name, radioMenuForRange)
                local radioMenuSubRange = RangesArray[compteur].SubRangeMenus[indexsubRange]
                if (subRangeConfig.subsubRange ~= nil) then
                    for indexSubSubRange, subsubRangeConfig in ipairs(subRangeConfig.subsubRange) do
                        local radioMenuSubSubRange = MENU_COALITION:New(rangeconfig.benefit_coalition, subsubRangeConfig.name, radioMenuSubRange)
                        addSubRangeRadioMenus(radioMenuSubSubRange, rangeconfig, subsubRangeConfig)
                    end
                else
                    addSubRangeRadioMenus(radioMenuSubRange, rangeconfig, subRangeConfig)
                end
            end
            AddWholeRangeCoalitionCommandMenus(radioMenuForRange, rangeconfig)
        else
            local radioMenuForRange = MENU_COALITION:New( coalition.side.RED, rangeconfig.name , mainRadioMenuForRangesRed)
            for index, subRangeConfig in ipairs(rangeconfig.subRange) do
                local radioMenuSubRange = MENU_COALITION:New(rangeconfig.benefit_coalition, subRangeConfig.name, radioMenuForRange)
                if (subRangeConfig.subsubRange ~= nil) then
                    for index, subsubRangeConfig in ipairs(subRangeConfig.subsubRange) do
                        local radioMenuSubSubRange = MENU_COALITION:New(rangeconfig.benefit_coalition, subsubRangeConfig.name, radioMenuSubRange)
                        addSubRangeRadioMenus(radioMenuSubSubRange, rangeconfig, subsubRangeConfig)
                    end
                else
                    addSubRangeRadioMenus(radioMenuSubRange, rangeconfig, subRangeConfig)
                end
            end
            AddWholeRangeCoalitionCommandMenus(radioMenuForRange, rangeconfig)
        end
    end
end

if compteur == 0 then
    mainRadioMenuForRangesBlue:Remove()
    mainRadioMenuForRangesRed:Remove()
end
