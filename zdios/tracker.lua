local timerUpdater = CreateFrame('Frame', UIParent)
local auraUpdater = CreateFrame('Frame', UIParent)
local chatFrame = ChatFrame3
local barAnchor = oUF_karmaPlayer
local throttleCount = 0
local mediaPath = "Interface\\AddOns\\oUF_Karma\\media\\"
barHeight = 20
barWidth = oUF_karmaPlayer:GetWidth()
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

-- Returns a font object
local function getFont(frame, name, size, outline)
    local font = frame:CreateFontString(nil, "OVERLAY")
    font:SetFont(name, size, outline)
    font:SetShadowColor(0, 0, 0, 0.8)
    font:SetShadowOffset(1, -1)
    return font
end


-- Creates a new bar frame
local function createBar()
    local bar = CreateFrame("StatusBar", nil, UIParent)
    bar:SetStatusBarTexture(mediaPath.."Statusbar")
    bar:GetStatusBarTexture():SetHorizTile(false)
    bar:GetStatusBarTexture():SetVertTile(false)
    bar:SetWidth(barWidth)
    bar:SetHeight(barHeight)
    bar:SetFrameLevel(1)

    -- Helper frame for the backdrop
    local backdrop = CreateFrame("Frame", nil, bar)
    backdrop:SetFrameLevel(0)
    backdrop:SetPoint("TOPLEFT",-5,5)
    backdrop:SetPoint("BOTTOMRIGHT",5,-5)
    backdrop:SetBackdrop(backdrop_tab)
    backdrop:SetBackdropColor(0,0,0,0.6)
    backdrop:SetBackdropBorderColor(0,0,0,1)

    -- Spell name text
    local spellName = getFont(bar, mediaPath.."ROADWAY.ttf", 16, "THINOUTLINE")
    spellName:SetPoint("LEFT", 2, 10)
    spellName:SetJustifyH("LEFT")

    -- Tracked value text
    local spellValue = getFont(bar, mediaPath.."ROADWAY.ttf", 18, "THINOUTLINE")
    spellValue:SetPoint("LEFT", -2, 0)
    spellValue:SetJustifyH("RIGHT", spellValue, "LEFT", -5, 0)

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
local function drawBar(buffName, info)
    if not info.bar then
        info.bar = createBar()
        info.bar:SetStatusBarColor(info.color[1], info.color[2], info.color[3])
        info.bar.SpellName:SetFormattedText(buffName)
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
        --info.bar.SpellName:SetFormattedText(duration) -- Fix and timeleft
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
                drawBar(buff, info)
            end

            if info.isTimer then
                info.expires = expires
                info.bar:SetMinMaxValues(0, duration)
                info.bar.SpellName:SetFormattedText(duration) -- Temporary test
                trackedTimers[buff] = info
                activeTimers = true
                timerUpdater:SetScript("OnUpdate", updateTimers)
            else
                info.bar:SetMinMaxValues(0, info.maxValue())
                info.bar:SetValue(value1)
                info.bar.SpellName:SetFormattedText(value1) -- Have to format this
            end
            
        elseif info.active then -- destroy frame
            info.active = false
            trackedTimers[buff] = nil
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
