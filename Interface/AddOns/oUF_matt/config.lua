local _, ns = ...
local cfg = ns.cfg

-- TODO: Create a default table, then copy and modify instance
-- https://stackoverflow.com/questions/640642/how-do-you-copy-a-lua-table-by-value

cfg.FrameSize = { 200, 50 }
cfg.FrameScale = 1.0
cfg.FrameInset = 2

cfg.HealthHeight = 20
cfg.PowerHeight = 5
cfg.HealthPowerMargin = cfg.FrameInset
cfg.FullFrameHeight = cfg.HealthHeight + cfg.PowerHeight + cfg.HealthPowerMargin

cfg.PrimaryFrameWidth = 300
cfg.SecondaryFrameWidth = 150
cfg.PartyFrameWidth = 225
cfg.PrimaryFrameX = 50
cfg.PrimaryFrameY = 225
cfg.SecondaryFrameX = cfg.PrimaryFrameX + cfg.PrimaryFrameWidth
cfg.SecondaryFrameY = cfg.PrimaryFrameY - 50
cfg.FontSize = 20

cfg.CastbarOffsetY = 100
cfg.CastbarFont = "Fonts\\FRIZQT__.TTF"
cfg.CastbarFontSize = 12
cfg.CastbarColor = { 235 / 255, 25 / 255, 25 / 255 } -- TODO: Add rest of units
cfg.UninterruptibleCastbarColor = { 0.4, 0.4, 0.4 }
cfg.InterruptibleCastbarGlowColor = { 25 / 255, 200 / 255, 255 / 255, 1 }
cfg.CastbarTimeToHold = 0.75
cfg.CastbarFader = {
	fadeInAlpha = 1,
	fadeInDuration = 0.1,
	fadeOutAlpha = 0,
	fadeOutDuration = 0.3,
	fadeOutDelay = 0.5
}

-- TODO: Anchor things to PRD:
-- yourFrame:SetPoint("CENTER", C_NamePlate.GetNamePlateForUnit("player"), "CENTER", 0, 0)
-- Would need to watch for events that change nameplates and re-SetPoint when that happens
-- because not guaranteed to always have a specific nameplate instance
cfg.player = {
	Position = {
		"RIGHT",
		WorldFrame,
		"BOTTOM",
		-cfg.PrimaryFrameX,
		cfg.PrimaryFrameY,
	},
	FrameSize = { cfg.PrimaryFrameWidth, cfg.FullFrameHeight },
	FrameScale = 1.0,
	HealthHeight = cfg.HealthHeight,
	PowerHeight = cfg.PowerHeight,
	NameSide = "LEFT",
	HPSide = "RIGHT",
	EnableCastbar = true,
	CastbarColor = { 5 / 255, 107 / 255, 246 / 255 },
	FontSize = cfg.FontSize,
	HealPrediction = true,
}

cfg.target = {
	Position = {
		"LEFT",
		WorldFrame,
		"BOTTOM",
		cfg.PrimaryFrameX,
		cfg.PrimaryFrameY,
	},
	FrameSize = { cfg.PrimaryFrameWidth, cfg.FullFrameHeight },
	FrameScale = 1.0,
	HealthHeight = cfg.HealthHeight,
	PowerHeight = cfg.PowerHeight,
	NameSide = "RIGHT",
	HPSide = "LEFT",
	EnableCastbar = true,
	CastbarColor = { 235 / 255, 25 / 255, 25 / 255 },
	FontSize = cfg.FontSize,
	HealPrediction = true,
}

cfg.pet = {
	Position = {
		"LEFT",
		WorldFrame,
		"BOTTOM",
		-cfg.SecondaryFrameX,
		cfg.SecondaryFrameY,
	},
	FrameSize = { cfg.SecondaryFrameWidth, cfg.HealthHeight },
	FrameScale = 1.0,
	HealthHeight = cfg.HealthHeight,
	PowerHeight = 0,
	NameSide = nil,
	HPSide = nil,
}

cfg.targettarget = {
	Position = {
		"RIGHT",
		WorldFrame,
		"BOTTOM",
		cfg.SecondaryFrameX,
		cfg.SecondaryFrameY,
	},
	FrameSize = { cfg.SecondaryFrameWidth, cfg.HealthHeight },
	FrameScale = 1.0,
	HealthHeight = cfg.HealthHeight,
	PowerHeight = 0,
	NameSide = "RIGHT",
	HPSide = nil,
	FontSize = cfg.FontSize - 6,
}

cfg.party = {
	Position = {
		"BOTTOMRIGHT",
		WorldFrame,
		"BOTTOMLEFT",
		500,
		400,
	},
	FrameSize = { cfg.PartyFrameWidth, cfg.HealthHeight },
	FrameOffsetY = 40 + cfg.HealthHeight,
	FrameScale = 1.0,
	HealthHeight = cfg.HealthHeight - 5,
	PowerHeight = cfg.PowerHeight - 2,
	NameSide = "RIGHT",
	HPSide = nil,
	FontSize = cfg.FontSize - 6,
	HealPrediction = true,
}

cfg.colors = {
	backdrop = { 0, 0, 0, 0.9 }, -- Backdrop Color (Some frames might not be affected)
	health = { 0.2, 0.2, 0.2, 1 }, -- Fallback color
	inverted = { 0.1, 0.1, 0.1, 1 } -- Inverted Color
}
