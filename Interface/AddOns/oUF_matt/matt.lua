local debug = function(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local cfg = {
	FrameMargin = {200, 300},
	FrameScale = 1.0,
}

local oUF_matt = {}
oUF_matt.sharedStyle = function(self, unit, isSingle)
end

-- Frame creation --------------------------------

oUF:RegisterStyle("matt", oUF_matt.sharedStyle)
oUF:SetActiveStyle("matt")

oUF:Spawn("target", "oUF_target"):SetPoint("LEFT", UIParent, "CENTER", cfg.FrameMargin[1], -cfg.FrameMargin[2])

oUF_target:SetScale(cfg.FrameScale)
