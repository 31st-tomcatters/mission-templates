AwacsConfig = {
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'CSG-2 CVN-73-3',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = 'CSG-2 CVN-73',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'WIZARD #IFF:4773FR',
        airboss_recovery = true,
        escortgroupname = 'jolly_hornet #IFF:7323FR',
        missionmaxduration = 120,
        altitude = 28000,
        speed = 380,
        freq = 377.800,
        fuelwarninglevel=45,
        racetrack = {
            front = 80,
            back = -20
        },
        tacan = {
            channel = 100,
            morse = 'WZD',
        },
        modex = 705,
        callsign = {
            alias = 'Wizard',
            name = CALLSIGN.AWACS.Wizard,
            number = 1
        }
    },
}

OnDemandAwacsConfig = {
    --Darkstar 1 = E3
    {
        enable = true,
        type = "ds1",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'DARKSTAR #IFF:4772FR',
        airboss_recovery = false,
        escortgroupname = 'F-15C CAP #IFF:7321FR',
        missionmaxduration = 165,
        altitude = 35000,
        speed = 402,
        freq = 265.8,
        fuelwarninglevel=25,
        modex = 11,
        callsign = {
            alias = 'Darkstar',
            name = CALLSIGN.AWACS.Darkstar,
            number = 1
        },
        orbit = {
            length = 55,
            heading = 20
        },
    },
    --Overlord 1 = E3
    {
        enable = true,
        type = "ov1",
        benefit_coalition = coalition.side.RED,
        baseUnit = AIRBASE.Syria.Marj_Ruhayyil,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'LCD-03 AWACS RED',
        airboss_recovery = false,
        missionmaxduration = 120,
        altitude = 38000,
        speed = 402,
        freq = 251,
        fuelwarninglevel=25,
        modex = 15,
        callsign = {
            alias = 'OverLord',
            name = CALLSIGN.AWACS.Overlord,
            number = 1
        },
        orbit = {
            length = 30,
            heading = 45
        },
    },
}
