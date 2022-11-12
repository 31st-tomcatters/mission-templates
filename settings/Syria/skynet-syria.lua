SkynetConfig = {
    {
        name = "Syrian IADS Alpha",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG_Alpha_AlSafirah"},
        nodes = {
            {
                connection = "Node_Alpha_Aleppo",
                ewrs = {"EWR_SYR_Aleppo"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Aleppo-3",
                        },
                        {
                            sam = "SAM-SA-3-Kuweires-1",
                        },
                        {
                            sam = "SAM-SA-3-Aleppo-1",
                        },
                        {
                            sam = "SAM-SA-3-Aleppo-2",
                        },
                        {
                            sam = "SAM-SA-3-NorthAbuAlDuhur-1",
                        },
                        {
                            sam = "SAM-SA-3-AlGhadfah-1",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Alsafira-1",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 60,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = {
                                "SAM-SA-15-Aleppo-1","SAM-SA-15-Aleppo-3"
                            }
                        },
                        {
                            sam = "SAM-SA-2-AbuAlDuhur-1",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 60,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = {
                                "SAM-SA-15-AbuAlDuhur-1","SAM-SA-15-AbuAlDuhur-2"
                            }
                        },
                        {
                            sam = "SAM-SA-2-Taannah-1",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 60,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                        },
                    },
                    hard = {
                    },
                    extreme = {
                    },
                }
            },
            {
                connection = "Node_Alpha_Hama",
                ewrs = {"EWR_SYR_Hama"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-6-Hama-1",
                        },
                        {
                            sam = "SAM-SA-3-Hama-1",
                        },
                        {
                            sam = "SAM-SA-6-Hama-2",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 60,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = {
                                "SAM-SA-8-PD-Hama-1","SAM-SA-8-PD-Hama-2"
                            }
                        },
                    },
                    medium = {
                    },
                    hard = {
                    },
                    extreme = {
                    },
                },
            },
        }
    },
    {
        name = "Syrian IADS Bravo",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG_Bravo_Bassel"},
        nodes = {
            {
                connection = "Node_Bravo_Latakia",
                ewrs = {"EWR_SYR_Latakia"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Latakia-3",
                        },
                        {
                            sam = "SAM-SA-3-Latakia-1",
                        },
                        {
                            sam = "SAM-SA-3-Latakia-2",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Latakia-2",
                        },
                        {
                            sam = "SAM-SA-2-Latakia-1",
                        },
                        {
                            sam = "SAM-SA-2-Bassel-2",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 80,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = {"SAM-SA-15-PD-Bassel"}
                        },
                    },
                    hard = {
                    },
                    extreme = {
                        {
                            sam = "SAM-SA-23-Bassel-1",
                            goLiveRangePercent = 45,
                            actAsEw = false,
                            pointDefenses = {"SAM-SA-19-PD-Bassel", "SAM-SA-15-PD-Bassel-2", "SAM-SA-15-PD-Bassel-1"}
                        },
                    },
                }
            },
            {
                connection = "Node_Bravo_Baniyas",
                ewrs = {"EWR_SYR_Baniyas","EWR_SYR_Tartus"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Baniyas-1",
                        },
                        {
                            sam = "SAM-SA-3-Tartus-3",
                        },
                        {
                            sam = "SAM-SA-3-Tartus-1",
                        },
                        {
                            sam = "SAM-SA-3-ReneMouawad-1",
                        },
                        {
                            sam = "SAM-SA-3-Tartus-2",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Baniyas-1",
                        },
                        {
                            sam = "SAM-SA-2-Tartus-1",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 65,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = {"SAM-SA-15-PD-Tartus-1","SAM-SA-15-PD-Tartus-2","SAM-SA-15-PD-Tartus-3"}
                        },
                        {
                            sam = "SAM-SA-2-ReneMouawad-1",
                        },
                        {
                            sam = "SAM-SA-2-Bassel-1",
                        },
                    },
                    hard = {
                        {
                            sam = "SAM-SA-5-Baniyas-1",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 40,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = {"SAM-SA-15-PD-Baniyas-1","SAM-SA-19-PD-Baniyas-1"}
                        },
                    },
                    extreme = {
                    },
                },
            },
        }
    },
    {
        name = "Syrian IADS Charlie",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG_Charlie_Homs"},
        nodes = {
            {
                connection = "Node_Charlie_Tiyas",
                ewrs = {"EWR_SYR_Tiyas", "EWR_SYR_Tiyas-mountain"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Tiyas-2",
                        },
                        {
                            sam = "SAM-SA-3-Tiyas-1",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Tiyas-1",
                        },
                        {
                            sam = "SAM-SA-2-Tiyas-2",
                        },
                    },
                    hard = {
                    },
                    extreme = {
                    },
                },
            },
            {
                connection = "Node_Charlie_Homs",
                ewrs = {"EWR_SYR_Homs-mountain", "EWR_SYR_Homs"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Homs-1",
                        },
                        {
                            sam = "SAM-SA-3-Homs-2",
                        },
                        {
                            sam = "SAM-SA-6-Homs-1",
                        },
                        {
                            sam = "SAM-SA-3-Homs-1",
                        },
                        {
                            sam = "SAM-SA-6-Shayrat-2",
                        },
                        {
                            sam = "SAM-SA-6-Shayrat-1",
                        },
                        {
                            sam = "SAM-SA-6-Shayrat-3",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Homs-1",
                        },
                        {
                            sam = "SAM-SA-2-Homs-3",
                        },
                    },
                    hard = {
                        {
                            sam = "SAM-SA-5-Homs-1",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 40,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                        },
                    },
                    extreme = {
                    },
                },
            },
        }
    },
    {
        name = "Syrian IADS Delta",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG_Delta_Damas"},
        nodes = {
            {
                connection = "Node_Delta_Damascus",
                ewrs = {"EWR_SYR_Damascus", "EWR_SYR_Damascus-1"},
                sites = {
                    easy = {
                        {
                            sam = "Damascus SA6-13",
                        },
                        {
                            sam = "SAM-SA-6-Damascus-1",
                        },
                        {
                            sam = "SAM-SA-6-Rayak-1",
                        },
                        {
                            sam = "SAM-SA-6-Rayak-2",
                        },
                        {
                            sam = "SAM-SA-6-Damascus-4",
                        },
                        {
                            sam = "SAM-SA-3-Damascus-1",
                        },
                        {
                            sam = "SAM-SA-3-Damascus-3",
                        },
                        {
                            sam = "SAM-SA-6-Damascus-2",
                        },
                        {
                            sam = "SAM-SA-6-Damascus-3",
                        },
                        {
                            sam = "SAM-SA-3-Damascus-2",
                        },
                        {
                            sam = "SAM-SA-6-Marj-1",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Dumayr-1",
                        },
                        {
                            sam = "SAM-SA-2-Marj-1",
                        },
                        {
                            sam = "SAM-SA-2-Marj-3",
                        },
                        {
                            sam = "SAM-SA-2-Damascus-1",
                        },
                    },
                    hard = {
                        {
                            sam = "SAM-SA-5-Dumayr-1",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 50,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                        },
                    },
                    extreme = {
                    },
                },
            },
            {
                connection = "Node_Delta_Thalah",
                ewrs = {"EWR_SYR_Thalah"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-6-Thalah-1",
                        },
                        {
                            sam = "SAM-SA-6-Thalah-6",
                        },
                        {
                            sam = "SAM-SA-6-Thalah-2",
                        },
                        {
                            sam = "SAM-SA-3-Thalah-4",
                        },
                        {
                            sam = "SAM-SA-6-Khalkhalah-1",
                        },
                        {
                            sam = "SAM-SA-3-Khalkhalah-1",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Thalah-1",
                            pointDefenses = {"SAM-ZSU23-Thalah-PD-4","SAM-ZSU23-Thalah-PD-2","SAM-ZSU23-Thalah-PD-1","SAM-ZSU23-Thalah-PD-3"}
                        },
                        {
                            sam = "SAM-SA-2-Sayqal-1",
                        },
                        {
                            sam = "SAM-SA-2-Khalkhalah-1",
                        },
                    },
                    hard = {
                        {
                            sam = "SAM-SA-5-Khalkhalah-1",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 50,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = {"SAM-SA-8-PD-Damascus-SA-5","SAM-SA-19-PD-Damascus-SA-5","SAM-SA-15-PD-Damascus-SA-5"}
                        },
                    },
                    extreme = {
                    },
                },
            },
            {
                connection = "Node_Delta_Sayqal",
                ewrs = {"EWR_SYR_Sayqal"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Sayqal-1",
                        },
                        {
                            sam = "SAM-SA-6-Nasiriyah-2",
                        },
                        {
                            sam = "SAM-SA-6-Nasiriyah-1",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Sayqal-2",
                            pointDefenses = {"SAM-SA-8-PD-Sayqal-2", "SAM-SA-8-PD-Sayqal-1"}
                        },
                    },
                    hard = {
                    },
                    extreme = {
                    },
                },
            },
        }
    },
    {
        name = "Syrian IADS Echo",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG_Echo_Tabqa"},
        nodes = {
            {
                connection = "Node_Echo_Raqqa",
                ewrs = {"EWR_SYR_Tabqa", "EWR_SYR_TalSiman"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-6-Tabqa-1"
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-TalSiman-1"
                        },
                        {
                            sam = "SAM-SA-2-Tabqa-1"
                        }
                    },
                    hard = {
                    },
                    extreme = {
                    },
                }
            },
        }
    },
    {
        name = "Iraki IADS Foxtrot",
        enable = true,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG_H3"},
        nodes = {
            {
                connection = "IADS_QG_H3",
                ewrs = {"EWR_IRK_H3"},
                sites = {
                    easy = {
                    },
                    medium = {
                    },
                    hard = {
                        {
                            sam = "H-3 SA-5",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 40,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = "SAM-SA-15-PD-H3"
                        }
                    },
                    extreme = {
                    },
                },
            }
        }
    },
}
