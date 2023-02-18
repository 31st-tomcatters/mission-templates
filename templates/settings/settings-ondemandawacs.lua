OnDemandAwacsConfig = {
    --DarkStar 1 E3
    {
        enable = false,
        type = "ds1",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.Syria.Incirlik,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'DarkStar 1-1 #IFF:4275FR',
        missionmaxduration = 135,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 106,
            morse = 'DS1',
        },
        freq = 265.8,
        modex = 23,
        orbit = {
            heading = 090,
            length = 30,
        },
        callsign = {
            alias = 'Darkstar-1',
            name = CALLSIGN.AWACS.Darkstar,
            number = 1
        }
    },
}
