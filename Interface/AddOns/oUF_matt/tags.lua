local _, ns = ...
local tags = ns.tags

local font = "Fonts\\FRIZQT__.TTF"
local fontSize = 20
local fontOutline = "THINOUTLINE"

function CreateFontstring(frame)
	-- local Text = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	local fs = frame:CreateFontString(nil, "OVERLAY")
	fs:SetFont(font, fontSize, fontOutline)
	fs:SetShadowColor(0, 0, 0, 1)
	fs:SetShadowOffset(1, -1)
	return fs
end

oUF.Tags.Methods['matt:name'] = function(unit, realUnit)
	return UnitName(unit or realUnit)
end
oUF.Tags.Events['matt:name'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION UNIT_ENTERING_VEHICLE UNIT_EXITING_VEHICLE'

oUF.Tags.Methods['matt:hpperc'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local percent = floor((min / max) * 100 + 0.5)

	if percent < 100 and percent > 0 then
		return percent .. "%"
	else
		return ""
	end
end
oUF.Tags.Events['matt:hpperc'] = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE'

function tags:CreateNameString(self, point, width)
	-- if not self.Health or not self.cfg.name.show then return end

	local name = CreateFontstring(self.Health)
	name:SetPoint(point, self, "TOP" .. point, 4, 0)
	name:SetJustifyH(point)
	name:SetWidth(width)
	name:SetHeight(fontSize)
	self:Tag(name, "[matt:name]")
	self.Name = name
end

function tags:CreateHPPercString(self, point, width)
	-- if not self.Health or not self.cfg.name.show then return end

	local name = CreateFontstring(self.Health)
	name:SetPoint(point, self, "TOP" .. point, -4, 0)
	name:SetJustifyH(point)
	name:SetWidth(width)
	name:SetHeight(fontSize)
	self:Tag(name, "[matt:hpperc]")
	self.Name = name
end
