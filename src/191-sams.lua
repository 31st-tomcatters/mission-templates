-- *****************************************************************************
--                     **                     SAMS                         **
--                     *********************************************************

SamsArray = {}
compteur = 0
mainRadioMenuForSamsBlue =  MENU_COALITION:New( coalition.side.BLUE , "SAMs", MenuCoalitionBlue )
mainRadioMenuForSamsRed =  MENU_COALITION:New( coalition.side.RED , "SAMs", MenuCoalitionRed )
for index, samconfig in ipairs(SamsConfig) do
    if samconfig.enable == true then
        compteur = compteur + 1
        env.info('creation Sam site : '.. samconfig.name..'...')
        SamsArray[compteur] = {
            customconfig = samconfig
        }
        if (samconfig.benefit_coalition == coalition.side.BLUE) then
            local radioMenuForRange   =  MENU_COALITION:New( coalition.side.BLUE, samconfig.name , mainRadioMenuForSamsBlue)
            for index, subRangeConfig in ipairs(samconfig.subRange) do
                local radioMenuSubRange     = MENU_COALITION:New(samconfig.benefit_coalition, subRangeConfig.name,   radioMenuForRange)
                if (subRangeConfig.subsubRange ~= nil) then
                    for index, subsubRangeConfig in ipairs(subRangeConfig.subsubRange) do
                        local radioMenuSubSubRange     = MENU_COALITION:New(samconfig.benefit_coalition, subsubRangeConfig.name,   radioMenuSubRange)
                        addSubRangeRadioMenus(radioMenuSubSubRange, samconfig, subsubRangeConfig)
                    end
                else
                    addSubRangeRadioMenus(radioMenuSubRange, samconfig, subRangeConfig)
                end
            end
        else
            local radioMenuForRange   =  MENU_COALITION:New( coalition.side.RED, samconfig.name , mainRadioMenuForSamsRed)
            for index, subRangeConfig in ipairs(samconfig.subRange) do
                local radioMenuSubRange     = MENU_COALITION:New(samconfig.benefit_coalition, subRangeConfig.name,   radioMenuForRange)
                if (subRangeConfig.subsubRange ~= nil) then
                    for index, subsubRangeConfig in ipairs(subRangeConfig.subsubRange) do
                        local radioMenuSubSubRange     = MENU_COALITION:New(samconfig.benefit_coalition, subsubRangeConfig.name,   radioMenuSubRange)
                        addSubRangeRadioMenus(radioMenuSubSubRange, samconfig, subsubRangeConfig)
                    end
                else
                    addSubRangeRadioMenus(radioMenuSubRange, samconfig, subRangeConfig)
                end
            end
        end
    end
end

if compteur == 0 then
    mainRadioMenuForSamsBlue:Remove()
    mainRadioMenuForSamsRed:Remove()
end
