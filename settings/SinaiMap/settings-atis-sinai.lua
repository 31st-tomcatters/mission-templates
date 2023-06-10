AtisConfig = {
    {
        enable = true,
        airfield = AIRBASE.Sinai.Hatzor,
        radio = {
            freq = 270.1,
            power = 100,
            modulation = radio.modulation.AM,
            relayunit = 'ATISRelay-1-1',
            tower = {
                39.000,
                118.600,
                250.600,
                4.050}
        },
        active = {
            number = '23',
            side = 'L'
        },
        tacan = {
            channel = 106
        },
        ils = {
            freq = 108.50,
            runway = '05'
        },
        srs = {
            path = "C:\\SRS"
        }
    }
}
