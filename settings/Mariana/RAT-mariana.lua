-- AVAILABLE GROUPS :
    -- EL AL 757 #IFF:1562UN
    -- AirChina 330 #IFF:1563UN
    -- Cathay 747 #IFF:1564UN
    -- Quantas 747 #IFF:3212UN
    -- DHL 757 #IFF:7316UN
    -- MEA 320 #IFF:2631UN
    -- TNT 737 #IFF:3242UN

RATConfig = {
    {
        name = 'civil',
        enable = true,
        maximum_aircrafts = 5,
        aircrafts_groupconfigs = {
            {
                templatename = 'EL AL 757 #IFF:1562UN',
                minimun_spawns = 0,
                spawns = 1,
                flightlevel = 330,
                speed = 480,
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.MarianaIslands.Saipan_Intl
                    },
                    arrival = {
                        'zone_rat_north_east'
                    }
                }
            },
            {
                templatename = 'AirChina 330 #IFF:1563UN',
                minimun_spawns = 0,
                spawns = 1,
                flightlevel = 290,
                speed = 468,
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.MarianaIslands.Antonio_B_Won_Pat_Intl
                    },
                    arrival = {
                        'zone_rat_south_east'
                    }
                }
            },
            {
                templatename = 'Cathay 747 #IFF:1564UN',
                minimun_spawns = 0,
                spawns = 1,
                flightlevel = 340,
                speed = 460,
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone_rat_south_west'
                    },
                    arrival = {
                        'zone_rat_north_east'
                    }
                }
            },
            {
                templatename = 'Quantas 747 #IFF:3212UN',
                minimun_spawns = 0,
                spawns = 1,
                flightlevel = 310,
                speed = 466,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.MarianaIslands.Antonio_B_Won_Pat_Intl
                    },
                    arrival = {
                        'zone_rat_north_center'
                    }
                }
            },
            {
                templatename = 'DHL 757 #IFF:7316UN',
                minimun_spawns = 0,
                spawns = 1,
                flightlevel = 290,
                speed = 470,
                inactive_timer = 1200,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        AIRBASE.MarianaIslands.Saipan_Intl
                    },
                    arrival = {
                        'zone_rat_north_center'
                    }
                }
            },
            {
                templatename = 'MEA 320 #IFF:2631UN',
                minimun_spawns = 0,
                spawns = 0,
                flightlevel = 360,
                speed = 480,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone_rat_south_east'
                    },
                    arrival = {
                        'zone_rat_south_west'
                    }
                }
            },
            {
                templatename = 'TNT 737 #IFF:3242UN',
                minimun_spawns = 0,
                spawns = 1,
                flightlevel = 335,
                speed = 490,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = false,
                atcmessage_enable = false,
                airbases_names = {
                    departure = {
                        'zone_rat_north_west'
                    },
                    arrival = {
                        'zone_rat_south_center'
                    }
                }
            }
        }
    },
    {
        name = 'military',
        enable = false,
        aircrafts_groupconfigs = {}
    }
}

