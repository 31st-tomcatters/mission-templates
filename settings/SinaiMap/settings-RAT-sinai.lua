-- *****************************************************************************
-- *                         RAT settings                                      *
-- *****************************************************************************
RATConfig = {
    {
        name = 'civil',
        enable = false,
        maximum_aircrafts = 10,
        aircrafts_groupconfigs = {
            {
                templatename = { 'RAT_A320' },
                minimun_spawns = 1,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = true,
                atcmessage_enable = false,
                commute = false,
                liveries = { "Aeroflot", "Aeroflot 1", "Air Asia", "Air Berlin", "Air Berlin FFO", "Air Berlin OLT",
                    "Air Berlin retro", "Air France", "Air Moldova", "Airbus Neo", "Al Maha", "Alaska Modern", "Alitalia",
                    "Allegiant", "American Airlines", "British Airways", "Brussels airlines Tintin", "Cebu Pacific",
                    "Clean", "Condor", "Delta Airlines", "Easy Jet", "Easy Jet Berlin", "Easy Jet w", "Edelweiss",
                    "Emirates", "Etihad", "Eurowings", "Eurowings BVB09", "Eurowings Europa Park", "FAB", "Fly Georgia",
                    "Fly Niki", "Frontier", "German Wings", "Gulf Air", "Iberia", "Iran Air", "Israir B", "Israir W",
                    "Jet Blue NY", "JetBlue", "jetBlue FDNY", "Kish Air", "Kuwait Airways", "Lufthansa", "Lufthansa New",
                    "MEA", "MRTT Canada", "MRTT Luftwaffe", "Qatar", "RAF MPA", "RAF VIP", "Republique Francaise", "S7",
                    "SAS", "Saudi Gulf", "Saudia", "Small Planet", "Spirit", "Star Alliance", "SWISS", "Thomas Cook",
                    "Tunis Air", "Turkish Airlines", "United", "Ural Airlines", "US Airways", "Vietnam Airlines",
                    "Virgin", "Virgin Atlantic A_320_Rosie Lee_EI-EZW", "Volaris", "WiZZ", "WiZZ Budapest", "WOW",
                    "Yemenia" },
                airbases_names = {
                    departure = {
                        'zone-RAT-Gazipasa'
                    },
                    arrival = {
                        AIRBASE.Syria.Adana_Sakirpasa
                    }
                }
            },
            {
                templatename = { 'RAT_A330' },
                minimun_spawns = 1,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = true,
                atcmessage_enable = false,
                liveries = { "Aer Lingus", "Aeroflot", "Air Canada", "Air China", "Air Tahiti Nui", "AirAsia", "Airbus",
                    "BOURKHAN", "Brussels Airline", "Cathay Pacific", "CEBU Pacific", "China Eastern", "Clean", "DELTA",
                    "DragonAir", "Edelweiss", "Egypt Air", "Emirates", "ETIHAD", "EVA", "FIJI", "FinnAir", "FrenchBlue",
                    "FrenchMRTT042", "Garude Indunesia", "GulfAir", "Hainan Airlines", "Iberia", "IRoI", "KLM",
                    "LAN Airways", "Lion Air PK-LEG", "LTU", "Lufthansa", "McRondForce", "NWA", "nwaold", "Olympic",
                    "OmanAir", "Orbit", "Philipines", "Qantas", "Qatar", "RAF Voyager", "Singapore", "Skyteam",
                    "Srilankan", "Star Aliance", "Swiss", "Thomas Cook", "Turkish Airlines", "US Airways",
                    "Virgin Atlantic", "WorldTrave" },
                airbases_names = {
                    departure = {
                        'zone-RAT-Gazipasa'
                    },
                    arrival = {
                        AIRBASE.Syria.Damascus
                    }
                }
            },
            {
                templatename = { 'RAT_A380' },
                minimun_spawns = 1,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = true,
                atcmessage_enable = false,
                liveries = { "Air France", "Ana Honululu", "BA", "China Southern", "Clean", "Emirates",
                    "Emirates _United  for  Wildlife", "KA", "LH", "LHF", "Qantas Airways", "QTR", "SA", "TA" },
                airbases_names = {
                    departure = {
                        'zone-RAT-Adana'
                    },
                    arrival = {
                        AIRBASE.Syria.Beirut_Rafic_Hariri
                    }
                }
            },
            {
                templatename = { 'RAT_B727' },
                minimun_spawns = 2,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = true,
                atcmessage_enable = false,
                liveries = { "AEROFLOT", "Air France", "Alaska", "Alitalia", "American Airlines", "AsemanAir", "Clean",
                    "Delta Airlines", "Delta Airlines OLD", "Emirates", "FedEx", "Hapag Lloyd", "IraqAir", "Lufthansa",
                    "Lufthansa Oberhausen Old", "Northwest", "OmanAir", "Pan Am", "SaudiArabian", "Singapore Airlines",
                    "Southwest", "UNITED", "UNITED Old", "ZERO G" },
                airbases_names = {
                    departure = {
                        'zone-RAT-Adana'
                    },
                    arrival = {
                        AIRBASE.Syria.Adana_Sakirpasa
                    }
                }
            },
            {
                templatename = { 'RAT_B737' },
                minimun_spawns = 1,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = true,
                atcmessage_enable = false,
                liveries = { "Air Algerie", "Air Berlin", "Air France", "AirArabian", "airBaltic", "Airzena", "AM",
                    "Amazon Prime", "American Classic", "American Modern", "American_Airlines", "British Airways", "C40s",
                    "Clean", "Delta Modern", "Disney", "EA", "easyJet", "EGYPTAIR_SU-AYK", "EL AL", "FINNAIR", "flyAdeal",
                    "GulfAir", "HARIBO", "Israir", "JA", "Jet2", "kulula", "LH", "Lufthansa BA", "Lufthansa KR", "OLD_BA",
                    "OMAN AIR", "P8 RAF", "P8 USN", "PakistanInt", "PAN AM", "Polskie Linie Lotnicze LOT", "QANTAS",
                    "RAAF No. 11 Sqn", "RAAF No. 11 Sqn A47-001", "RAAF No. 11 Sqn A47-002", "RAAF No. 11 Sqn A47-003",
                    "RAAF No. 11 Sqn A47-004", "RAAF No. 11 Sqn A47-005", "RAAF No. 11 Sqn A47-006",
                    "RAAF No. 11 Sqn A47-007", "RAAF No. 11 Sqn A47-008", "RAAF No. 11 Sqn A47-009",
                    "RAAF No. 11 Sqn A47-010", "RAAF No. 11 Sqn A47-011", "RAAF No. 11 Sqn A47-012",
                    "RAAF No. 11 Sqn A47-013", "RAAF No. 11 Sqn A47-014", "RAAF No. 2 Sqn", "RAAF No. 2 Sqn A30-001",
                    "RAAF No. 2 Sqn A30-001 100 Years", "RAAF No. 2 Sqn A30-002", "RAAF No. 2 Sqn A30-003",
                    "RAAF No. 2 Sqn A30-004", "RAAF No. 2 Sqn A30-005", "RAAF No. 2 Sqn A30-006",
                    "RAAF No. 2 Sqn A30-006 100 Years", "RYANAIR", "SaudiArabian", "SouthWest Lone Star",
                    "Southwest Modern", "Swoop", "ThomsonFly", "TNT", "Ukraine Airlines", "United Modern", "United_Retro",
                    "UPS", "WestJet Retro" },
                airbases_names = {
                    departure = {
                        'zone-RAT-Gazipasa'
                    },
                    arrival = {
                        AIRBASE.Syria.Beirut_Rafic_Hariri
                    }
                }
            },
            {
                templatename = { 'RAT_B747' },
                minimun_spawns = 1,
                speed = 450,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = true,
                atcmessage_enable = false,
                liveries = { "AF", "AF-One", "AI", "CP", "EL AL Modern", "IM", "JASDF 20-1101", "JASDF 20-1102", "KLM",
                    "KLM Modern", "Korean Air B-747", "Korean Air Cargo", "LH", "NW", "PA", "QA", "TA",
                    "Virgin Atlantic 747_Barbarella_G-VROM", "Virgin Atlantic Modern" },
                airbases_names = {
                    departure = {
                        'zone-RAT-Gaziantep'
                    },
                    arrival = {
                        AIRBASE.Syria.Adana_Sakirpasa
                    }
                }
            },
            {
                templatename = { 'RAT_B757' },
                minimun_spawns = 1,
                speed = 450,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = true,
                atcmessage_enable = false,
                liveries = { "AA", "AirArabia", "American Airlines_ Generic (Silver Mica)",
                    "American Airlines_One World (Metallic)", "American Airlines_One World (Silver Mica)", "BA", "C-32",
                    "Delta", "DHL", "easyJet", "EL AL", "EL AL Special", "FedEx", "GulfAir", "Korean Air", "OmanAir",
                    "Pakistan1", "Pakistan2", "SaudiArabian", "Swiss", "Thomson", "United_Retro" },
                airbases_names = {
                    departure = {
                        AIRBASE.Syria.Damascus
                    },
                    arrival = {
                        AIRBASE.Syria.Gazipasa
                    }
                }
            },
            {
                templatename = { 'RAT_DC10' },
                minimun_spawns = 1,
                speed = 450,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = true,
                atcmessage_enable = false,
                liveries = { "SWISSAIR HB-IHL", "SWISSAIR HB-IMC", "SWISSAIR HB-IPF" },
                airbases_names = {
                    departure = {
                        'zone-RAT-Gaziantep'
                    },
                    arrival = {
                        'zone-RAT-Adana'
                    }
                }
            },
            {
                templatename = { 'RAT_Yak40' },
                minimun_spawns = 1,
                speed = 450,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = true,
                atcmessage_enable = false,
                liveries = { "Aeroflot", "Algeria GLAM", "Georgian Airlines", "Olympic Airways", "Ukranian" },
                airbases_names = {
                    departure = {
                        'zone-RAT-Adana'
                    },
                    arrival = {
                        'zone-RAT-Gaziantep'
                    }
                }
            },
            {
                templatename = { 'RAT_An26B' },
                minimun_spawns = 1,
                speed = 450,
                inactive_timer = 600,
                allow_immortal = false,
                allow_invisible = true,
                atcmessage_enable = false,
                liveries = { "Abkhazian AF", "Aeroflot", "China PLAAF", "Georgian AF", "RF Air Force", "RF Navy",
                    "Ukraine AF" },
                airbases_names = {
                    departure = {
                        AIRBASE.Syria.Adana_Sakirpasa
                    },
                    arrival = {
                        AIRBASE.Syria.Damascus
                    }
                }
            },
        }
    },
    {
        name = 'military',
        enable = false,
        aircrafts_groupconfigs = {}
    }
}
