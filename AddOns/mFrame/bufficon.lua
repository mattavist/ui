-- Remove default buff borders, replace with a black square
local f = CreateFrame("Frame")

function redrawBorder(button, icon)
    local buttonbg = button:CreateTexture(nil, "BACKGROUND", nil, -1)
    buttonbg:ClearAllPoints()
    buttonbg:SetPoint("BOTTOMRIGHT", button, 2, -2)
    buttonbg:SetPoint("TOPLEFT", button, -2, 2)
    buttonbg:SetColorTexture(0, 0, 0)
    icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)
end

function f:OnEvent(event, addon)
    hooksecurefunc("CreateFrame", function(frameType, name, parent, template)
        if parent then
            ChatFrame1:AddMessage(parent)
        end
        if (template == "BuffButtonTemplate") then
            --ChatFrame1:AddMessage("This is the message "..variable)
            local buff = _G[name]
            local icon = _G[name.."Icon"]
            if buff then
                redrawBorder(buff, icon)
            end
        end
    end)

    self:UnregisterEvent(event)
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)