SkynetConfig = {
    {
        name = "Syrian IADS",
        enable = false,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG"},
        nodes = {
            {
                connection = "Node_Aleppo",
                ewrs = {"EWR_SYR_Kuweires"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Aleppo",
                        },
                        {
                            sam = "SAM-SA-3-Kuweires",
                        },
                        {
                            sam = "SAM-SA-3-WestAleppo",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Aleppo",
                        },
                    },
                    hard = {
                    },
                    extreme = {
                    },
                }
            }, {
                connection = "Node_Latakia",
                ewrs = {"EWR_SYR_Latakia"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Jablah",
                        },
                        {
                            sam = "SAM-SA-3-Latakia",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Latakia",
                        },
                    },
                    hard = {
                    },
                    extreme = {
                    },
                }
            }, {
                connection = "Node_Baniyas",
                ewrs = {"EWR_SYR_Baniyas"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Tartus",
                        },
                        {
                            sam = "SAM-SA-3-ReneMouawad",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Tartus",
                        },
                    },
                    hard = {
                    },
                    extreme = {
                    },
                },
            }, {
                connection = "Node_Hama",
                ewrs = {"EWR_SYR_Hama"},
                sites = {
                    easy = {
                    },
                    medium = {
                    },
                    hard = {
                        {
                            sam = "SAM-SA-5-Baniyas",
                        },
                        {
                            sam = "SAM-SA-5-Tartus",
                        },
                    },
                    extreme = {
                    },
                },
            }, {
                connection = "Node_Tiyas",
                ewrs = {"EWR_SYR_Tiyas"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Tiyas",
                        },
                        {
                            sam = "SAM-SA-3-SouthTiyas",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Tiyas",
                        },
                    },
                    hard = {
                    },
                    extreme = {
                    },
                },
            }, {
                connection = "Node_Homs",
                ewrs = {"EWR_SYR_Damascus_North"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Homs",
                        },
                        {
                            sam = "SAM-SA-3-SouthHoms",
                        },
                        {
                            sam = "SAM-SA-6-Homs",
                        },
                        {
                            sam = "SAM-SA-6-Shayrat",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Homs",
                        },
                    },
                    hard = {
                        {
                            sam = "SAM-SA-5-Homs",
                        },
                    },
                    extreme = {
                    },
                },
            }, {
                connection = "Node_Damascus",
                ewrs = {"EWR_SYR_Damascus_West", "EWR_SYR_Sayqal"},
                sites = {
                    easy = {
                        {
                            sam = "SAM-SA-3-Damascus",
                        },
                        {
                            sam = "SAM-SA-6-Damascus",
                        },
                        {
                            sam = "SAM-SA-6-Mezzeh",
                        },
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Marj",
                        },
                        {
                            sam = "SAM-SA-2-Damascus",
                        },
                        {
                            sam = "SAM-SA-2-Dumayr",
                        },
                    },
                    hard = {
                        {
                            sam = "SAM-SA-5-Khalkhalah",
                        },
                        {
                            sam = "SAM-SA-5-Damascus",
                        },
                    },
                    extreme = {
                    },
                },
            }, {
                connection = "Node_Thalah",
                ewrs = {"EWR_SYR_Thalah"},
                sites = {
                    easy = {
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Thalah",
                        },
                    },
                    hard = {
                    },
                    extreme = {
                    },
                },
            }
        }
    },
    {
        name = "Bassel El Assad IADS",
        enable = false,
        benefit_coalition = coalition.side.BLUE,
        headQuarter = {"IADS_QG_Bassel"},
        nodes = {
            {
                connection = "IADS_QG_Bassel",
                ewrs = {"EWR_SYR_NorthBassel", "EWR_SYR_SouthBassel"},
                sites = {
                    easy = {
                    },
                    medium = {
                        {
                            sam = "SAM-SA-2-Bassel",
                            harmDetectionChance = 65,
                            goLiveRangePercent = 60,
                            pdharmDetectionChance = 90,
                            actAsEw = false,
                            pointDefenses = "SAM-SA-15-PD-Bassel"
                        },
                    },
                    hard = {
                        {
                            sam = "SAM-SA-19-Bassel",
                            goLiveRangePercent = 70,
                        }
                    },
                    extreme = {
                    },
                },
            }
        }
    },
}
