AAMAxRange = {
    MAX_RANGE = 0,
    NEZ_RANGE = 1,
    HALF_WAY_RMAX_NEZ = 2,
    TARGET_THREAT_EST = 3,
    RANDOM_RANGE = 4,
}

WarCAPConfig = {
    {
        enable = true,
        coalitionCAP = coalition.side.RED,
        name = 'Alpha Airspace',
        debug = false,
        borderZoneGroupName = 'border-syria',
        --borderZoneName = 'red_north_patrol_zone',
        detectionGroupingRadius = 15,
        engageRadius = 100,
        gciRadius = 300,
        fireRange = AAMAxRange.MAX_RANGE,
        ewrPrefixes = {
            "EWR_SYR"
        },
        CAPBases = {
            {
                baseName = AIRBASE.Syria.Hama,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-SY-Mig29A-27ER",
                        groupForce = 2,
                        groupNumber = 8,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "airspace-alpha",
                    },
                    {
                        enable = true,
                        groupName = "CAP-SY-Mig21",
                        groupForce = 2,
                        groupNumber = 8,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "airspace-alpha",
                    }
                },
                interceptSquadrons = {
                }
            },
            {
                baseName = AIRBASE.Syria.Abu_al_Duhur,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-SY-Mig23",
                        groupForce = 2,
                        groupNumber = 8,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "airspace-alpha",
                    },
                },
                interceptSquadrons = {
                }
            },
        },
        capParameters = {
            patrolFloor = 20000,
            patrolCeiling = 40000,
            minPatrolSpeed = 250,
            maxPatrolSpeed = 400,
            minEngageSpeed = 250,
            maxEngageSpeed = 900,
            engageFloor = 5000,
            engageCeiling = 55000
        }
    },
    {
        enable = true,
        coalitionCAP = coalition.side.RED,
        name = 'Bravo Airspace',
        debug = false,
        borderZoneGroupName = 'border-syria',
        --borderZoneName = 'red_north_patrol_zone',
        detectionGroupingRadius = 15,
        engageRadius = 100,
        gciRadius = 300,
        fireRange = AAMAxRange.MAX_RANGE,
        ewrPrefixes = {
            "EWR_SYR"
        },
        CAPBases = {
            {
                baseName = AIRBASE.Syria.Bassel_Al_Assad,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-RU-Mig29S",
                        groupForce = 2,
                        groupNumber = 6,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "airspace-bravo",
                    },
                    {
                        enable = true,
                        groupName = "CAP-RU-Su27",
                        groupForce = 2,
                        groupNumber = 6,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "airspace-bravo",
                    }
                },
                interceptSquadrons = {
                    {
                        enable = false,
                        groupName = "INT-SY-MIG29",
                        groupForce = 2,
                        groupNumber = 3,
                    },
                    {
                        enable = false,
                        groupName = "INT-RU-MIG29",
                        groupForce = 2,
                        groupNumber = 2,
                    }
                }
            }
        },
        capParameters = {
            patrolFloor = 20000,
            patrolCeiling = 40000,
            minPatrolSpeed = 250,
            maxPatrolSpeed = 400,
            minEngageSpeed = 250,
            maxEngageSpeed = 900,
            engageFloor = 5000,
            engageCeiling = 55000
        }
    },
    {
        enable = true,
        coalitionCAP = coalition.side.RED,
        name = 'Charlie Airspace',
        debug = false,
        borderZoneGroupName = 'border-syria',
        --borderZoneName = 'red_north_patrol_zone',
        detectionGroupingRadius = 15,
        engageRadius = 100,
        gciRadius = 300,
        fireRange = AAMAxRange.MAX_RANGE,
        ewrPrefixes = {
            "EWR_SYR"
        },
        CAPBases = {
            {
                baseName = AIRBASE.Syria.Tiyas,
                patrolSquadrons = {
                },
                interceptSquadrons = {
                    {
                        enable = true,
                        groupName = "INT-SY-MIG25",
                        groupForce = 2,
                        groupNumber = 8,
                    }
                }
            },
            {
                baseName = AIRBASE.Syria.Shayrat,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-SY-Mig23-1",
                        groupForce = 2,
                        groupNumber = 12,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "airspace-charlie",
                    },
                },
                interceptSquadrons = {
                }
            },
        },
        capParameters = {
            patrolFloor = 20000,
            patrolCeiling = 40000,
            minPatrolSpeed = 250,
            maxPatrolSpeed = 400,
            minEngageSpeed = 250,
            maxEngageSpeed = 900,
            engageFloor = 5000,
            engageCeiling = 55000
        }
    },
    {
        enable = true,
        coalitionCAP = coalition.side.RED,
        name = 'Delta Airspace',
        debug = false,
        borderZoneGroupName = 'border-syria',
        --borderZoneName = 'red_north_patrol_zone',
        detectionGroupingRadius = 15,
        engageRadius = 100,
        gciRadius = 300,
        fireRange = AAMAxRange.MAX_RANGE,
        ewrPrefixes = {
            "EWR_SYR"
        },
        CAPBases = {
            {
                baseName = AIRBASE.Syria.Sayqal,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-SY-Mig29A-27ER-1",
                        groupForce = 2,
                        groupNumber = 4,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "airspace-delta",
                    }
                },
                interceptSquadrons = {
                    {
                        enable = true,
                        groupName = "INT-SY-MIG29-1",
                        groupForce = 2,
                        groupNumber = 4,
                    }
                }
            },
            {
                baseName = AIRBASE.Syria.Marj_Ruhayyil,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-SY-Mig23-2",
                        groupForce = 2,
                        groupNumber = 12,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "airspace-delta",
                    },
                },
                interceptSquadrons = {
                    {
                        enable = true,
                        groupName = "INT-SY-MIG25-1",
                        groupForce = 1,
                        groupNumber = 4,
                    }
                }
            },
            {
                baseName = AIRBASE.Syria.Thalah,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-SY-Mig21-1",
                        groupForce = 1,
                        groupNumber = 12,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "airspace-delta",
                    }
                },
                interceptSquadrons = {
                    {
                        enable = true,
                        groupName = "INT-SY-MIG25-2",
                        groupForce = 1,
                        groupNumber = 2,
                    }
                }
            },
        },
        capParameters = {
            patrolFloor = 20000,
            patrolCeiling = 40000,
            minPatrolSpeed = 250,
            maxPatrolSpeed = 400,
            minEngageSpeed = 250,
            maxEngageSpeed = 900,
            engageFloor = 5000,
            engageCeiling = 55000
        }
    },
    {
        enable = true,
        coalitionCAP = coalition.side.RED,
        name = 'Echo Airspace',
        debug = false,
        borderZoneGroupName = 'border-syria',
        --borderZoneName = 'red_north_patrol_zone',
        detectionGroupingRadius = 15,
        engageRadius = 100,
        gciRadius = 300,
        fireRange = AAMAxRange.MAX_RANGE,
        ewrPrefixes = {
            "EWR_SYR"
        },
        CAPBases = {
            {
                baseName = AIRBASE.Syria.Tabqa,
                patrolSquadrons = {
                    {
                        enable = true,
                        groupName = "CAP-SY-Mig21-2",
                        groupForce = 2,
                        groupNumber = 12,
                        patrolInAirNumber = 1,
                        patrolZoneGroupName = "airspace-echo",
                    }
                },
                interceptSquadrons = {
                    {
                        enable = false,
                        groupName = "INT-SY-MIG29-2",
                        groupForce = 2,
                        groupNumber = 4,
                    }
                }
            },
            {
                baseName = AIRBASE.Syria.Jirah,
                patrolSquadrons = {
                },
                interceptSquadrons = {
                    {
                        enable = true,
                        groupName = "INT-ISIS-MIG21",
                        groupForce = 2,
                        groupNumber = 2,
                    }
                }
            },
        },
        capParameters = {
            patrolFloor = 20000,
            patrolCeiling = 40000,
            minPatrolSpeed = 250,
            maxPatrolSpeed = 400,
            minEngageSpeed = 250,
            maxEngageSpeed = 900,
            engageFloor = 5000,
            engageCeiling = 55000
        }
    },
}
