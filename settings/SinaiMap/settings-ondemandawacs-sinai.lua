OnDemandAwacsConfig = {
    --Darkstar 1 = E3
    {
        enable = true,
        type = "ds1",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Sinai.Hatzor,
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
            heading = 270
        },
    },
    --Overlord 1 = E3
    {
        enable = false,
        type = "ov1",
        benefit_coalition = coalition.side.RED,
        baseUnit = AIRBASE.Sinai.Ovda,
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
