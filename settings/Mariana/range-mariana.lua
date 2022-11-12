RangeConfig = {
    {
        name = "Farallon de Medinilla",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        subRange = {
            {
                name = "Z4",
                groupsToSpawn = {"RANGE-FDM-TGTS-1", "RANGE-FDM-TGTS-2"},
                holdFire = true
            }
        }
    },
    {
        name = "Sinkex",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        subRange = {
            {
                name = "Z1",
                groupsToSpawn = {"SINKEX-CIVILIAN"},
            },
            {
                name = "Z2",
                groupsToSpawn = {"SINKEX-MILITARY"},
                holdFire = true
            }
        }
    },
    {
        name = "Pagan",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        subRange = {
            {
                name = "Z2",
                groupsToSpawn = {"PAGAN-SA2"}
            },
            {
                name = "Z10",
                groupsToSpawn = {"PAGAN-SA10B"}
            },
            {
                name = "Z11",
                groupsToSpawn = {"PAGAN-SA11"}
            },
            {
                name = "Z15A",
                groupsToSpawn = {"PAGAN-SA15-SMALL"}
            },
            {
                name = "Z15B",
                groupsToSpawn = {"PAGAN-SA15-BIG"}
            }
        }
    }
}

TrainingRangeConfig = {
    {
        name = "Farallon de Medinilla",
        enable = true,
        targetsheetpath = "C:/rangeboss-targetsheets",
		        srs = {
            useSRS = true,
            path = "C:\\SRS",
            port = 5002
        },
        instructionradio = {
            unitname = "RANGE-FDM-CONTROL",
            freq = 251.75,
        },
        controlradio = {
            unitname = "RANGE-FDM-CONTROL",
            freq = 250.25,
        },
        targets = {
            {
                type = "Strafepit",
                unit_name = "RANGE-FDM-STRAFE-PIT",
                foul_line = "RANGE-FDM-STRAFE-FOUL-LINE",
                boxlength = 2000,
                boxwidth = 200,
                heading = 203,
                inverseheading = true,
                goodpass = 20
            },
            {
                type = "BombCircle",
                unit_name = "RANGE-FDM-CIRCLES-1",
                precision = 15
            },
            {
                type = "BombCircle",
                unit_name = "RANGE-FDM-CIRCLES-2",
                precision = 15
            },
            {
                type = "BombCircle",
                unit_name = "RANGE-FDM-CIRCLES-3",
                precision = 15
            },
            {
                type = "BombCircle",
                unit_name = "RANGE-FDM-CIRCLES-4",
                precision = 15
            }
        }
    }
}
