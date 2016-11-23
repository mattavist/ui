local f = CreateFrame("Frame")
local s = CreateFrame("Frame")

local framesToMove = {
    ["ObjectiveTrackerFrame"] = {
        name = ObjectiveTrackerFrame,
        func = "SetPoint",
        frameAnchor = "TOPLEFT",
        parent = UIParent,
        parentAnchor = "TOPLEFT",
        x = 30,
        y = -12,
        height = 500
    },
    ["AlertFrame"] = {
        name = AlertFrame,
        func = "SetParent",
        frameAnchor = "TOP",
        parent = UIParent,
        parentAnchor = "BOTTOM",
        x = 0,
        y = 600,
        height = nil
    },
    ["TalkingHeadFrame"] = {
        name = TalkingHeadFrame,
        func = "TalkingHeadFrame_PlayCurrent",
        frameAnchor = "TOP",
        parent = WorldFrame,
        parentAnchor = "CENTER",
        x = 300,
        y = -300,
        height = 300
    },
    ["ArcheologyDigsiteProgressBar"] = {
        name = {ArcheologyDigsiteProgressBar},
        func = "ArcheologyDigsiteProgressBar_OnUpdate",
        frameAnchor = "BOTTOM",
        parent = WorldFrame,
        parentAnchor = "BOTTOM",
        x = 0,
        y = 50,
        height = nil
    }
}

local function moveFrame(frame)
    if frame.hooked then
        return
    end
    frame.hooked = true
    local moving
    hooksecurefunc(frame.name, frame.func, function(self)
        if moving then
            return
        end
        moving = true
        self:ClearAllPoints()
        self:SetPoint(frame.frameAnchor, frame.parent, frame.parentAnchor, frame.x, frame.y)
        if frame.height then
            self:SetHeight(frame.height)
        end
        moving = nil
    end)
end

function s:OnAddon(event, addon)
    -- Move Talking Head Frame to top of screen
    if addon == "Blizzard_TalkingHeadUI" then
        hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
            AlertFrame:ClearAllPoints()
            AlertFrame:SetPoint("BOTTOM", 0, 350)
            TalkingHeadFrame:SetPoint("BOTTOMRIGHT", WorldFrame, "BOTTOMRIGHT", -10, 650)
            TalkingHeadFrame.ignoreFramePositionManager = true
        end)

    -- Move Digsite Progress to Bottom of screen
    elseif addon == "Blizzard_ArchaeologyUI" then
        hooksecurefunc("ArcheologyDigsiteProgressBar_OnUpdate", function()
            ArcheologyDigsiteProgressBar:SetPoint("BOTTOM", WorldFrame, "BOTTOM", 0, 50)
            ArcheologyDigsiteProgressBar.ignoreFramePositionManager = true
        end)
    end
end

function f:OnEnter()
    moveFrame(framesToMove["ObjectiveTrackerFrame"])
    --moveFrame(framesToMove["AlertFrame"])
    AlertFrame:ClearAllPoints()
    AlertFrame:SetPoint("BOTTOM", 0, 350)
    f:UnregisterEvent("PLAYER_ENTERING_WORLD")
    s:SetScript("OnEvent", s.OnAddon)
    s:RegisterEvent("ADDON_LOADED")
end


f:SetScript("OnEvent", f.OnEnter)
s:SetScript("OnEvent", s.OnAddon)
f:RegisterEvent("PLAYER_ENTERING_WORLD")