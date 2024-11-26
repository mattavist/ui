local mediaPath = "Interface\\media\\"

local mPlayerFrame = oUF_LumenPlayer or PlayerFrame

local function hideAll()
    MainMenuBar:SetAlpha(0)
    MultiBarBottomLeft:SetAlpha(0)
    MultiBarBottomRight:SetAlpha(0)
    MultiBar7:SetAlpha(0)
    BuffFrame:SetAlpha(0)
    if mGuideFrame then mGuideFrame:SetAlpha(0) end
    if UnitHealth("player") == UnitHealthMax("player") then
        mPlayerFrame:SetAlpha(0)
    end
end

local function showAll()
    MainMenuBar:SetAlpha(1)
    MultiBarBottomLeft:SetAlpha(1)
    MultiBarBottomRight:SetAlpha(1)
    MultiBar7:SetAlpha(1)
    mPlayerFrame:SetAlpha(1)
    BuffFrame:SetAlpha(1)
    if mGuideFrame then mGuideFrame:SetAlpha(1) end
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
            mPlayerFrame:SetAlpha(1)
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