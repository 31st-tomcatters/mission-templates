AirBossConfig = {
    {
        enable = true,
        carriername = 'CSG-9 CVN-71',
        alias = 'CVN-71 Roosevelt',
        coalition = coalition.side.BLUE,
        enable_menumarkzones = true,
        enable_menusmokezones = true,
        enable_niceguy = true,
        handleAI = true,
        recoverytanker = 'CSG-9 Nanny #IFF:4775FR',
        recoveryops = {
            mode = 'cyclic',
            cyclic = {
                event_duration_minutes = 60,
                event_ia_reserved_minutes = 10,
            }
        },
        tacan = {
            channel = 71,
            mode = 'X',
            morse = 'RSV',
        },
        icls = {
            channel = 11,
            morse = 'RSVLSO',
        },
        dl4 = {
            freq = 307.850,
        },
        freq = {
            base = 127.3,
            marshall = 127.5,
            lso = 127.4
        },
        infintepatrol = true,
        controlarea = 65,
        recoverycase = 1,
        maxpatterns = 5,
        maxstacks = 8,
        difficulty = AIRBOSS.Difficulty.HARD,
        menurecovery = {
            enable = true,
            duration = 30,
            windondeck = 30,
            offset = 0,
            uturn = false
        },
        releayunit = {
            marshall = 'CSG-9 Escort-1',
            lso = 'CSG-9 Escort-2',
        },
        voices = {
            marshall = 'Raynor', --Gabriella , FF or Raynor
            lso = 'FF' --FF or Raynor
        },
        singlecarrier = false,
        operationsstatspath = "C:/airboss-stats",
        operationstrapsheetpath = "C:/airboss-trapsheets"
    },
    {
        enable = true,
        carriername = 'ESG-1 LHA-1',
        alias = 'LHA-1 Tarawa',
        coalition = coalition.side.BLUE,
        enable_menumarkzones = true,
        enable_menusmokezones = true,
        enable_niceguy = true,
        handleAI = true,
        recoverytanker = 'ESG-1 Nanny #IFF:4776FR',
        recoveryops = {
            mode = 'cyclic',
            cyclic = {
                event_duration_minutes = 60,
                event_ia_reserved_minutes = 10,
            }
        },
        tacan = {
            channel = 51,
            mode = 'X',
            morse = 'TWA',
        },
        icls = {
            channel = 20,
            morse = 'TWALSO',
        },
        freq = {
            base = 251.75,
            marshall = 251.95,
            lso = 251.85
        },
        infintepatrol = true,
        controlarea = 50,
        recoverycase = 1,
        maxpatterns = 5,
        maxstacks = 8,
        difficulty = AIRBOSS.Difficulty.HARD,
        menurecovery = {
            enable = true,
            duration = 30,
            windondeck = 15,
            offset = 0,
            uturn = false
        },
        releayunit = {
            marshall = 'ESG-1 Escort-1',
            lso = 'ESG-1 Escort-2',
        },
        voices = {
            marshall = 'Gabriella', --Gabriella , FF or Raynor
            lso = 'Raynor' --FF or Raynor
        },
        singlecarrier = false,
        operationsstatspath = "C:/airboss-stats",
        operationstrapsheetpath = "C:/airboss-trapsheets"
    }
}
