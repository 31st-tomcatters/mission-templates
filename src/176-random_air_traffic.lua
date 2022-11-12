-- *****************************************************************************
--                     **                    Random Air Traffic               **
--                     *********************************************************
RATManagerArray = {}
compteur = 0
for index, ratconfig in ipairs(RATConfig) do
    if ratconfig.enable == true then
        debug_msg(string.format("RAT Enable"))
        compteur = compteur +1
        if not (ratconfig.maximum_aircrafts) then
            ratconfig.maximum_aircrafts = 10
        end
        local RATmanager=RATMANAGER:New(ratconfig.maximum_aircrafts)
        for index_planegroup, planegroupconfig in ipairs(ratconfig.aircrafts_groupconfigs) do
            if (type(planegroupconfig.templatename) == "string") then
                planegroupconfig.templatename = {planegroupconfig.templatename}
            end
            if (type(planegroupconfig.templatename) == "table") then
                for index, templatename in ipairs(planegroupconfig.templatename) do
                    debug_msg(string.format("RAT %s", templatename))
                    local RATGroup = RAT:New(templatename)
                    if (type(planegroupconfig.airbases_names) == "table" ) then
                        RATGroup:SetTakeoff("cold")
                        for airstartindex, airstartname in ipairs(planegroupconfig.airbases_names.departure) do
                            if not(RATGroup:_AirportExists(airstartname)) then
                                RATGroup:SetTakeoff("air")
                            end
                        end
                        for airstopindex, airstopname in ipairs(planegroupconfig.airbases_names.arrival) do
                            if not(RATGroup:_AirportExists(airstopname)) then
                                RATGroup:DestinationZone()
                            end
                        end
                        RATGroup:SetDeparture(planegroupconfig.airbases_names.departure)
                        RATGroup:SetDestination(planegroupconfig.airbases_names.arrival)
                    end
                    if (type(planegroupconfig.inactive_timer) == "number" ) then
                        RATGroup:TimeDestroyInactive(planegroupconfig.inactive_timer)
                    end
                    if (type(planegroupconfig.atcmessage_enable) == "boolean" ) then
                        RATGroup:ATC_Messages(planegroupconfig.atcmessage_enable)
                    else
                        RATGroup:ATC_Messages(false)
                    end
                    if (type(planegroupconfig.flightlevel) == "number" ) then
                        RATGroup:SetFLcruise(planegroupconfig.flightlevel)
                    end
                    if (type(planegroupconfig.speed) == "number") then
                        RATGroup:SetMaxCruiseSpeed(UTILS.KnotsToKmph(planegroupconfig.speed))
                    end
                    if (planegroupconfig.liveries) then
                        RATGroup:Livery(planegroupconfig.liveries)
                    end
                    if (type(planegroupconfig.allow_immortal) == "boolean" and planegroupconfig.allow_immortal == true) then
                        RATGroup:Immortal()
                    end
                    if (type(planegroupconfig.allow_invisible) == "boolean" and planegroupconfig.allow_invisible == true) then
                        RATGroup:Invisible()
                    end
                    if (type(planegroupconfig.commute) == "boolean" and planegroupconfig.commute == true) then
                        RATGroup:Commute(true)
                    end
                    RATGroup:SetEPLRS(true)
                    RATmanager:Add(RATGroup, planegroupconfig.minimun_spawns)
                end
            else
                debug_msg(string.format("RAT error in template name type : %s", planegroupconfig.templatename))
            end
        end
        RATManagerArray[compteur] = RATmanager
        RATManagerArray[compteur]:Start(spawnStandardDelay)
    end
end
