CTLDConfig = {
    {
        name = "Turkish Logistics",
        enable = false,
        benefit_coalition = coalition.side.BLUE,
    },
    {
        name = "US Logistics",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        useprefix = false,
        dropcratesanywhere = true,
        maximumHoverHeight = 15,
        minimumHoverHeight = 1,
        forcehoverload = false,
        hoverautoloading = false,
        smokedistance = UTILS.NMToMeters(5),
        movetroopstowpzone = true,
        movetroopsdistance = UTILS.NMToMeters(3),
        smokedistance = UTILS.NMToMeters(2),
        suppressmessages = false,
        repairtime = 300,
        buildtime = 300,
        allowcratepickupagain = true,
        enableslingload = true,
        pilotmustopendoors = false,
        placeCratesAhead = true,
        nobuildinloadzones = true,
        zones = {
            {
                zoneName = "ctld-deir-er-zor",
                zoneType = CTLD.CargoZoneType.LOAD,
                beacon = false,
                smokeColor = SMOKECOLOR.Blue,
                active = true,
            },
        },
        crates = {
            {
                crateName = "JTAC",
                templateGroups = {"crate-jtac"},
                crateNumber = 4,
                crateWeight = 1000,
                crateStock = 20,
                crateCargoType = CTLD_CARGO.Enum.VEHICLE,
            },
        },
        troops = {
            {
                troopName = "Artillery",
                templateGroups = {"troop-mortar"},
                troopSeats = 2,
                troopWeight = 100,
                troopStock = 20,
                troopCargoType = CTLD_CARGO.Enum.TROOPS,
            },
            {
                troopName = "Infantry",
                templateGroups = {"troop-m4"},
                troopSeats = 4,
                troopWeight = 100,
                troopStock = 20,
                troopCargoType = CTLD_CARGO.Enum.TROOPS,
            },
            {
                troopName = "JTAC",
                templateGroups = {"troop-jtac"},
                troopSeats = 1,
                troopWeight = 100,
                troopStock = 10,
                troopCargoType = CTLD_CARGO.Enum.TROOPS,
            },
            {
                troopName = "Manpads",
                templateGroups = {"troop-stinger"},
                troopSeats = 2,
                troopWeight = 100,
                troopStock = 10,
                troopCargoType = CTLD_CARGO.Enum.TROOPS,
            },
            {
                troopName = "Engineers",
                templateGroups = {"troop-engineer"},
                troopSeats = 4,
                troopWeight = 100,
                troopStock = 20,
                troopCargoType = CTLD_CARGO.Enum.ENGINEERS,
            },
        },
    },
    {
        name = "Syrian Logistics",
        enable = false,
        benefit_coalition = coalition.side.RED,
    },
    {
        name = "Russian Logistics",
        enable = false,
        benefit_coalition = coalition.side.RED,
    },
}
