OnDemandReapersConfig = {
    --Uzi = MQ9
    {
        enable = false,
        type = "uzi",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Nevada.Creech_AFB,
        terminalType = AIRBASE.TerminalType.OpenMed,
        groupName = 'reaper-1',
        laserCode = 1688,
        airboss_recovery = false,
        --escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 90,
        altitude = 19000,
        speed = 200 ,
        freq = 274.500,
        fuelwarninglevel=35,
        modex = 15,
        callsign = {
            alias = 'Uzi',
            name = CALLSIGN.Uzi,
            number = 1
        }
    }
}
