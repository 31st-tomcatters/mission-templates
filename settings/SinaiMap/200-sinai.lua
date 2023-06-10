-- -----------------------------------------------------------------------------
-- |  On demand Tankers auto spawn
-- -----------------------------------------------------------------------------
tankersOnDemandArray[#tankersOnDemandArray+1] = triggerOnDemandTanker(
        "tx3",
        nil,
        nil,
        nil,
        GROUP:FindByName("anchor tx3"):GetCoordinate(),
        nil,
        nil
)
tankersOnDemandArray[#tankersOnDemandArray+1] = triggerOnDemandTanker(
        "ar7",
        nil,
        nil,
        nil,
        GROUP:FindByName("anchor ar7"):GetCoordinate(),
        nil,
        nil
)
tankersOnDemandArray[#tankersOnDemandArray+1] = triggerOnDemandTanker(
        "sh4",
        nil,
        nil,
        nil,
        GROUP:FindByName("anchor sh4"):GetCoordinate(),
        nil,
        nil
)

awacsOnDemandArray[#awacsOnDemandArray+1] = triggerOnDemandAwacs(
        "ds1",
        nil,
        nil,
        nil,
        GROUP:FindByName("anchor ds1"):GetCoordinate(),
        nil,
        nil
)
