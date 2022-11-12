SkynetConfig = {
    {
        name = "Saipan IADS",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_HQ_Saipan"},
        nodes = {
            {
                connection = "STATIC_RADIO_TOWER_SOUTH",
                ewrs = {"EWR_SAIPAN_SUD"},
                sites = {
                    easy = {
                    },
                    medium = {
                        {
                            sam = "SAM_HAWK_SAIPAN_SUD",
                            harmDetectionChance = 55,
                            goLiveRangePercent = 70,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = {
                                "SAM_SA15_SAIPAN_SUD",
                            }
                        },
                        {
                            sam = "SAM_NASAM_SAIPAN_SUSUPE",
                            harmDetectionChance = 90,
                            actAsEw = true,
                        },
                        {
                            sam = "SAM_NASAM_SAIPAN_GARAPAN",
                            harmDetectionChance = 90,
                            actAsEw = true,
                        },
                        {
                            sam = "SAM_NASAM_SAIPAN_ISLAND",
                            harmDetectionChance = 90,
                            actAsEw = true,
                        },
                    },
                    hard = {
                    },
                    extreme = {
                    },
                }
            },
            {
                connection = "STATIC_RADIO_TOWER_NORTH",
                ewrs = {"EWR_SAIPAN_NORD"},
                sites = {
                    easy = {
                    },
                    medium = {
                        {
                            sam = "SAM_HAWK_SAIPAN_NORD",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 60,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = {
                                "SAM_SA15_SAIPAN_NORD",
                            }
                        },
                        {
                            sam = "SAM_NASAM_SAIPAN_MATANSA",
                            harmDetectionChance = 90,
                            actAsEw = true,
                        },
                        {
                            sam = "SAM_NASAM_SAIPAN_TANAPAG",
                            harmDetectionChance = 90,
                            actAsEw = true,
                        },
                    },
                    hard = {
                    },
                    extreme = {
                    },
                }
            },
        },
    },
}
