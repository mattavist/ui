local debug = function(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local cfg = {
	-- FrameMargin = {200, 300},
	FrameMargin = {2, 3},
	FrameScale = 1.0,
}

local UnitSpecific = {
	target = function(self)
		local Health = CreateFrame('StatusBar', nil, self)
		Health:SetHeight(20)
		Health:SetPoint('TOP')
		Health:SetPoint('LEFT')
		Health:SetPoint('RIGHT')

		-- Add a background
		local Background = Health:CreateTexture(nil, 'BACKGROUND')
		Background:SetAllPoints()
		Background:SetTexture(1, 1, 1, .5)

		-- Options
		Health.colorTapping = true
		Health.colorDisconnected = true
		Health.colorClass = true
		Health.colorReaction = true
		Health.colorHealth = true

		-- Make the background darker.
		Background.multiplier = .5

		-- Register it with oUF
		Health.bg = Background
		self.Health = Health

	end,
}

local Shared = function(self, unit)
	if(UnitSpecific[unit]) then
		-- Formalize this
		local unitFrame = UnitSpecific[unit](self)
		self:SetSize(250, 50)
		self:SetScale(2.0)
		return unitFrame
	end
end

oUF:RegisterStyle("matt", Shared)
oUF:Factory(function(self)

     self:SetActiveStyle("matt")

     self:Spawn("target"):SetPoint("CENTER")

end)
