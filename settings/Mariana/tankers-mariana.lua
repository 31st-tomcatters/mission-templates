TankersConfig = {
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'CSG-9 CVN-71',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = 'CSG-9 CVN-71',
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'CSG-9 Nanny #IFF:4775FR',
        airboss_recovery = true,
        missionmaxduration = 480,
        altitude = 8000,
        speed = 320,
        tacan = {
            channel = 100,
            morse = 'SH1',
        },
        freq = 264.250,
        fuelwarninglevel = 35,
        racetrack = {
            front = -15,
            back = 25
        },
        modex = 100,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 1
        }
    },
    {
        enable = true,
        autorespawn = true,
        patternUnit = 'ESG-1 LHA-1',
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenMedOrBig,
        groupName = 'ESG-1 Nanny #IFF:4776FR',
        airboss_recovery = true,
        missionmaxduration = 480,
        altitude = 7000,
        speed = 320,
        tacan = {
            channel = 101,
            morse = 'SH7',
        },
        freq = 264.350,
        fuelwarninglevel = 35,
        racetrack = {
            front = -10,
            back = 20
        },
        modex = 101,
        callsign = {
            alias = 'Shell',
            name = CALLSIGN.Tanker.Shell,
            number = 7
        }
    },
}

OnDemandTankersConfig = {
    -- TEXACO 1 -- KC135MPRS
    {
        enable = true,
        type = "tx1",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 1-1 #IFF:7367FR',
        missionmaxduration = 180,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 120,
            morse = 'TX1',
        },
        orbit = {
            heading = 180,
            length = 45,
        },
        freq = 317.5,
        modex = 010,
        callsign = {
            alias = 'Texaco',
            name = CALLSIGN.Tanker.Texaco,
            number = 1
        }
    },
    -- TEXACO 7 --KC135MPRS
    {
        enable = true,
        type = "tx7",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 7-1 #IFF:4274FR',
        missionmaxduration = 180,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 121,
            morse = 'TX7',
        },
        orbit = {
            heading = 325,
            length = 45,
        },
        freq = 317.500,
        modex = 011,
        callsign = {
            alias = 'Texaco',
            name = CALLSIGN.Tanker.Texaco,
            number = 7
        }
    },
    -- TEXACO 4 - KC135MPRS
    {
        enable = true,
        type = "tx4",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 4-1 #IFF:4276FR',
        missionmaxduration = 180,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 122,
            morse = 'TX4',
        },
        orbit = {
            heading = 90,
            length = 25,
        },
        freq = 317.500,
        modex = 015,
        callsign = {
            alias = 'Texaco',
            name = CALLSIGN.Tanker.Texaco,
            number = 4
        }
    },
    -- TEXACO 5 - KC135MPRS
    {
        enable = true,
        type = "tx5",
        benefit_coalition = coalition.side.RED,
        baseUnit = AIRBASE.MarianaIslands.Saipan_Intl,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'TEXACO 5-1 #IFF:4277FR',
        missionmaxduration = 180,
        altitude = 26000,
        speed = 420,
        tacan = {
            channel = 110,
            morse = 'TX5',
        },
        orbit = {
            heading = 90,
            length = 25,
        },
        freq = 317.600,
        modex = 017,
        callsign = {
            alias = 'Texaco',
            name = CALLSIGN.Tanker.Texaco,
            number = 5
        }
    },
    -- ARCO 2 - KC135
    {
        enable = true,
        type = "ar2",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 2-1 #IFF:7541FR',
        missionmaxduration = 180,
        altitude = 27000,
        speed = 420,
        tacan = {
            channel = 123,
            morse = 'AR2',
        },
        orbit = {
            heading = 180,
            length = 45,
        },
        freq = 276.2,
        modex = 012,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 2
        }
    },
    -- ARCO 6 - KC135
    {
        enable = true,
        type = "ar6",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 6-1 #IFF:7542FR',
        missionmaxduration = 180,
        altitude = 27000,
        speed = 420,
        tacan = {
            channel = 124,
            morse = 'AR6',
        },
        orbit = {
            heading = 325,
            length = 45,
        },
        freq = 276.2,
        modex = 013,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 6
        }
    },
    -- ARCO 5 - KC135
    {
        enable = true,
        type = "ar5",
        benefit_coalition = coalition.side.BLUE,
        baseUnit = AIRBASE.MarianaIslands.Andersen_AFB,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 5-1 #IFF:7543FR',
        missionmaxduration = 180,
        altitude = 27000,
        speed = 420,
        tacan = {
            channel = 125,
            morse = 'AR5',
        },
        orbit = {
            heading = 90,
            length = 25,
        },
        freq = 276.2,
        modex = 016,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 5
        }
    },
    -- ARCO 1 - KC135
    {
        enable = true,
        type = "ar1",
        benefit_coalition = coalition.side.RED,
        baseUnit = AIRBASE.MarianaIslands.Saipan_Intl,
        terminalType = AIRBASE.TerminalType.OpenBig,
        groupName = 'ARCO 1-1 #IFF:7547FR',
        missionmaxduration = 180,
        altitude = 23000,
        speed = 420,
        tacan = {
            channel = 111,
            morse = 'AR1',
        },
        orbit = {
            heading = 90,
            length = 25,
        },
        freq = 276.3,
        modex = 017,
        callsign = {
            alias = 'Arco',
            name = CALLSIGN.Tanker.Arco,
            number = 1
        }
    }
}
