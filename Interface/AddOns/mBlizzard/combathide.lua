FramesToHandle = {}
FramesToHandleByHealth = {}

local function setAlpha(frame, alpha)
    if frame then
        frame:SetAlpha(alpha)
    end
end

local function hideAll()
    for _, frame in pairs(FramesToHandle) do
        setAlpha(frame, 0)
    end

    if UnitHealth("player") == UnitHealthMax("player") then
        for _, frame in pairs(FramesToHandleByHealth) do
            setAlpha(frame, 0)
        end
    end
end

local function showAll()
    for _, frame in pairs(FramesToHandle) do
        setAlpha(frame, 1)
    end

    for _, frame in pairs(FramesToHandleByHealth) do
        setAlpha(frame, 1)
    end
end

-- Hides when exiting combat or stopping spell cast or losing target when ooc
local hider = CreateFrame("Frame", nil, UIParent)
hider:SetScript("OnEvent", function(self, event, unit, ...)
    if not InCombatLockdown() and not UnitExists("target") then
        if event == "UNIT_SPELLCAST_STOP" and not unit == "player" then
            return
        end
    else
        hideAll()
    end
end)

-- Shows when starting spell cast, entering combat, or gaining a target
local shower = CreateFrame("Frame", nil, UIParent)
shower:SetScript("OnEvent", function(self, event, unit, ...)
    if event == "PLAYER_TARGET_CHANGED" and not UnitExists("target") then
        return
    elseif event == "UNIT_HEALTH" then
        if unit == "player" and UnitHealth("player") < UnitHealthMax("player") then
            for _, frame in pairs(FramesToHandleByHealth) do
                setAlpha(frame, 1)
            end
        end
    else
        showAll()
    end
end)

-- Hides when exiting combat or stopping spell cast or losing target when ooc
local hider = CreateFrame("Frame", nil, UIParent)
hider:SetScript("OnEvent", function(self, event, unit, ...)
    if not InCombatLockdown() and not UnitExists("target") then
        if event == "UNIT_SPELLCAST_STOP" and not unit == "player" then
            return
        end
        hideAll()
    end
end)

-- Small tweaks and register hider/shower
local addon = CreateFrame("Frame", nil, UIParent)
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:SetScript("OnEvent", function(self, event, unit, ...)
    FramesToHandleByHealth = {
        oUF_mattPlayer or PlayerFrame,
    }

    FramesToHandle = {
        MainMenuBar,
        MultiBarBottomLeft,
        MultiBarBottomRight,
        MultiBar7,
        BuffFrame,
        mGuideFrame,
        oUF_mattPet or PetFrame,
    }
    addon:UnregisterEvent("PLAYER_ENTERING_WORLD")

    hider:RegisterEvent("PLAYER_REGEN_ENABLED")
    hider:RegisterEvent("UNIT_SPELLCAST_STOP")
    hider:RegisterEvent("PLAYER_TARGET_CHANGED")
    hider:RegisterEvent("UNIT_HEALTH")

    shower:RegisterEvent("PLAYER_REGEN_DISABLED")
    shower:RegisterEvent("UNIT_SPELLCAST_START")
    shower:RegisterEvent("PLAYER_TARGET_CHANGED")
    shower:RegisterEvent("UNIT_HEALTH")
end)
