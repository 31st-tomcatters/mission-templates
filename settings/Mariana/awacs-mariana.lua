AwacsConfig = {
    {
        enable = true,
        autorespawn = true,
        airspawn = false,
        patternUnit = 'CSG-9 Escort-7',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = 'CSG-9 CVN-71',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'WIZARD #IFF:4773FR',
        airboss_recovery = true,
        escortgroupname = 'FA-18C ESCORT #IFF:7322FR',
        missionmaxduration = 240,
        altitude = 28000,
        speed = 380,
        freq = 265.800,
        fuelwarninglevel = 20,
        racetrack = {
            front = 50,
            back = -10
        },
        tacan = {
            channel = 130,
            morse = 'WZD',
        },
        modex = 705,
        callsign = {
            alias = 'Wizard',
            name = CALLSIGN.AWACS.Wizard,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        airspawn = false,
        patternUnit = 'awacs-anchor-1',
        benefit_coalition = coalition.side.RED,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'DARKSTAR #IFF:4772FR',
        airboss_recovery = false,
        escortgroupname = 'F-15C ESCORT #IFF:7321FR',
        missionmaxduration = 240,
        altitude = 33000,
        speed = 410,
        freq = 265.8,
        fuelwarninglevel = 20,
        racetrack = {
            front = 25,
            back = 50
        },
        tacan = {
            channel = 131,
            morse = 'DRK',
        },
        modex = 11,
        callsign = {
            alias = 'Darkstar',
            name = CALLSIGN.AWACS.Darkstar,
            number = 1
        }
    }
}
