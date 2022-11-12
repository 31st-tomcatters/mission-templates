-- -----------------------------------------------------------------------------
-- |  On demand Tankers auto spawn
-- -----------------------------------------------------------------------------
tankersOnDemandArray[#tankersOnDemandArray+1] = triggerOnDemandTanker(
        "tx3",
        nil,
        nil,
        nil,
        GROUP:FindByName("sea-anchor-2"):GetCoordinate(),
        nil,
        nil
)
tankersOnDemandArray[#tankersOnDemandArray+1] = triggerOnDemandTanker(
        "ar7",
        nil,
        nil,
        nil,
        GROUP:FindByName("sea-anchor-3"):GetCoordinate(),
        nil,
        nil
)
tankersOnDemandArray[#tankersOnDemandArray+1] = triggerOnDemandTanker(
        "sh4",
        nil,
        nil,
        nil,
        GROUP:FindByName("ground-anchor-1"):GetCoordinate(),
        nil,
        nil
)

-- -----------------------------------------------------------------------------
-- |  Fire on derricks
-- -----------------------------------------------------------------------------
-- Derrick Fire Made by Tata Wolf4Pm
local someZone = trigger.misc.getZone('Deir ez-Zor Derrick-1').point
someZone.y = land.getHeight({x = someZone.x, y = someZone.z})+85
trigger.action.effectSmokeBig(someZone, 1, 1)

local someZone = trigger.misc.getZone('Deir ez-Zor Derrick-2').point
someZone.y = land.getHeight({x = someZone.x, y = someZone.z})+85
trigger.action.effectSmokeBig(someZone, 1, 1)

local someZone = trigger.misc.getZone('Deir ez-Zor Derrick-3').point
someZone.y = land.getHeight({x = someZone.x, y = someZone.z})+85
trigger.action.effectSmokeBig(someZone, 1, 1)

local someZone = trigger.misc.getZone('Deir ez-Zor Derrick-4').point
someZone.y = land.getHeight({x = someZone.x, y = someZone.z})+85
trigger.action.effectSmokeBig(someZone, 1, 1)

local someZone = trigger.misc.getZone('Deir ez-Zor Derrick-5').point
someZone.y = land.getHeight({x = someZone.x, y = someZone.z})+85
trigger.action.effectSmokeBig(someZone, 1, 1)

local someZone = trigger.misc.getZone('Deir ez-Zor Derrick-6').point
someZone.y = land.getHeight({x = someZone.x, y = someZone.z})+85
trigger.action.effectSmokeBig(someZone, 1, 1)

local someZone = trigger.misc.getZone('Deir ez-Zor Derrick-7').point
someZone.y = land.getHeight({x = someZone.x, y = someZone.z})+85
trigger.action.effectSmokeBig(someZone, 1, 1)

local someZone = trigger.misc.getZone('Deir ez-Zor Derrick-8').point
someZone.y = land.getHeight({x = someZone.x, y = someZone.z})+85
trigger.action.effectSmokeBig(someZone, 1, 1)

local someZone = trigger.misc.getZone('Deir ez-Zor Derrick-9').point
someZone.y = land.getHeight({x = someZone.x, y = someZone.z})+85
trigger.action.effectSmokeBig(someZone, 1, 1)

local someZone = trigger.misc.getZone('Deir ez-Zor Derrick-10').point
someZone.y = land.getHeight({x = someZone.x, y = someZone.z})+85
trigger.action.effectSmokeBig(someZone, 1, 1)
