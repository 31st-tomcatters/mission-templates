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
