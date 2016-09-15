local timerUpdater = CreateFrame('Frame', UIParent)
local auraUpdater = CreateFrame('Frame', UIParent)
local chatFrame = ChatFrame3
local barAnchor = oUF_karmaPlayer
local throttleCount = 0
local mediaPath = "Interface\\AddOns\\oUF_Karma\\media\\"
barHeight = 20
barOffset = 28
playerFrameOffset = 15

local trackedTimers = {}
local trackedBuffs = {
  ["Shield Block"] = {
    active = false,
    isTimer = true,
    color = { 14/255, 86/255, 153/255 }
  },
  ["Ignore Pain"] = {
    active = false,
    barValue = function(absorb)
        local maxHealth = UnitHealthMax("player")
        return math.floor(100 * absorb/maxHealth)
    end,
    maxValue = function()
        return UnitHealthMax("player")
    end,
    color = { 178/255, 101/255, 1/255 }
  },
}

--backdrop table
local backdrop_tab = { 
bgFile = mediaPath.."backdrop", 
edgeFile = mediaPath.."backdrop_edge",
tile = false,
tileSize = 0, 
edgeSize = 5, 
insets = { 
  left = 3, 
  right = 3, 
  top = 3, 
  bottom = 3,
},
}

-- Creates a new bar frame
local function createBar()
    bar = CreateFrame("StatusBar", nil, UIParent)
    bar:SetStatusBarTexture(mediaPath.."Statusbar")
    bar:GetStatusBarTexture():SetHorizTile(false)
    bar:GetStatusBarTexture():SetVertTile(false)
    bar:SetWidth(oUF_karmaPlayer:GetWidth())
    bar:SetHeight(barHeight)
    bar:SetFrameLevel(1)

    helper = CreateFrame("Frame", nil, bar)
    helper:SetFrameLevel(0)
    helper:SetPoint("TOPLEFT",-5,5)
    helper:SetPoint("BOTTOMRIGHT",5,-5)
    helper:SetBackdrop(backdrop_tab)
    helper:SetBackdropColor(0,0,0,0.6)
    helper:SetBackdropBorderColor(0,0,0,1)
    return bar
end

-- Repositions all bars in a stack
local function positionBars()
    local activeBars = 0
    for buff, info in pairs(trackedBuffs) do
        if info.active then
            info.bar:SetPoint("BOTTOM", oUF_karmaPlayer, "TOP", 0, playerFrameOffset + activeBars * barOffset)
            activeBars = activeBars + 1
        end
    end
end

-- Displays the bar, or create it if it didn't exist already
local function drawBar(info)
    if not info.bar then
        info.bar = createBar()
        info.bar:SetStatusBarColor(info.color[1], info.color[2], info.color[3])
    end
    positionBars()
    info.bar:Show()
end

-- Redraw the bar based on buff duration, runs OnUpdate if there are active bars to redraw
local function updateTimers()
    -- Save CPU by only running once every throttleCount times
    throttleCount = throttleCount + 1
    if (throttleCount < 3) then -- Hard coded for performance
        return
    end
    throttleCount = 0

    -- This will only update currently active timers in trackedTimers
    for _, info in pairs(trackedTimers) do
        info.bar:SetValue(info.expires - GetTime())
    end
end

-- Every time UNIT_AURA fires collect the information on all tracked buffs
local function updateAuras()
    local activeTimers = false
    for buff, info in pairs(trackedBuffs) do
        local name, _, _, _, _, duration, expires, _, _, _, _, _, _, _, _, _, value1, _, _ = UnitBuff("player", buff)
        if name then
            if not info.active then -- create frame
                info.active = true
                drawBar(info)
            end

            if info.isTimer then
                info.expires = expires
                info.bar:SetMinMaxValues(0, duration)
                trackedTimers[buff] = info
                timerUpdater:SetScript("OnUpdate", updateTimers)
                activeTimers = true
            else
                info.bar:SetMinMaxValues(0, info.maxValue())
                info.bar:SetValue(value1)
            end
            
        elseif info.active then -- destroy frame
            info.active = false
            trackedTimers[buff] = nil -- What if this isnt in the table? Crash?
            info.bar:Hide()
            positionBars()
        end
    end
    if not activeTimers then
        timerUpdater:SetScript("OnUpdate", nil)
    end

end

auraUpdater:SetScript("OnEvent", function () updateAuras() end)
auraUpdater:RegisterEvent("UNIT_AURA", "player")
