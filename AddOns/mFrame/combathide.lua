local mediaPath = "Interface\\media\\"

local function buttonAlphaHigh()    
    for i = 1, 24 do
        local button = nil
        if i < 13 then
            button = _G["ActionButton"..i]
        else
            button = _G["MultiBarBottomLeftButton"..i-12]
            i = i + 48
        end
        button:SetAlpha(1)
    end
end

local function hideAll()
    MultiBarBottomLeft:SetAlpha(0)
    rABS_MainMenuBar:SetAlpha(0)
    BuffFrame:SetAlpha(0)
    mGuideFrame:SetAlpha(0)
    if UnitHealth("player") == UnitHealthMax("player") then
        oUF_LumenPlayer:SetAlpha(0)
    end
end

local function showAll()
    MultiBarBottomLeft:SetAlpha(1)
    oUF_LumenPlayer:SetAlpha(1)
    rABS_MainMenuBar:SetAlpha(1)
    BuffFrame:SetAlpha(1)
    mGuideFrame:SetAlpha(1)
    buttonAlphaHigh()
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
            oUF_LumenPlayer:SetAlpha(1)
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