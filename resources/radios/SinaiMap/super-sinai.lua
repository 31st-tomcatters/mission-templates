descriptor = {
    aircraft = "F-16C_50",
    group_name = "(^Super)",
}

radio_descriptor_table = {
    [1] =
    {
        ["modulations"] =
        {
        }, -- end of ["modulations"]
        ["channels"] = --UHF
        {
            [1] = 270.100, --ATIS
            [2] = 250.700, -- Hatzor Ground
            [3] = 250.800, -- Hatzor Tower
            [4] = 250.900, -- Hatzor Approach
            [5] = 377.800, --BlackJack
            [6] = 265.800, --AWACS IA
            [7] = 261.000, --AIC 1
            [8] = 261.500, --AIC 2
            [9] = 279.000, --Squad TAC
            [10] = 279.250, --Squad TAC
            [11] = 250.250, --Range ctrl 1
            [12] = 250.500, --Range ctrl 2
            [13] = 309.000, --CSAR
            [14] = 276.200, --TKR 1 Boom
            [15] = 317.500, --TKR 2 Basket
            [16] = 236.250, --2/5 IDF Tac
            [17] = 236.500, --2/5 IDF Tac
            [18] = 274.500, --JTAC 1
            [19] = 251.750, --CTAF
            [20] = 243.000, --Guard
        }, -- end of ["channels"]
    }, -- end of [1]
    [2] =
    {
        ["modulations"] =
        {
        }, -- end of ["modulations"]
        ["channels"] = --VHF
        {
            [1] = 135.250, --Squad tac
            [2] = 135.500, --Squad tac
            [3] = 135.750, --Squad tac
            [4] = 135.950, --Squad tac
            [5] = 127.500, --BlakJack
            [6] = 133.250, --354Th FS Tac
            [7] = 133.500, --354Th FS Tac
            [8] = 133.750, --354Th FS Tac
            [9] = 133.950, --354Th FS Tac
            [10] = 139.250, --N/A
            [11] = 139.500, --N/A
            [12] = 139.750, --N/A
            [13] = 131.250, --VMFA 314 Tac
            [14] = 131.500, --VMFA 314 Tac
            [15] = 137.250, --N/A
            [16] = 137.500, --N/A
            [17] = 137.750, --N/A
            [18] = 130.250, --JTAC 2
            [19] = 125.000, --N/A
            [20] = 121.500, --Emergency
        }, -- end of ["channels"]
    }, -- end of [2]
} -- end of ["Radio"]

