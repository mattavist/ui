local f = CreateFrame("Frame")

function f:OnEvent(event, addon)
    -- Move Talking Head Frame to top of screen
    if addon == "Blizzard_TalkingHeadUI" then
        hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
            TalkingHeadFrame:SetPoint("BOTTOM", WorldFrame, "TOP", 0, -300)
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

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)