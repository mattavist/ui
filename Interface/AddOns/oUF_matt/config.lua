local _, ns = ...
local cfg = ns.cfg


cfg.InProgress = "pet"

cfg.FrameSize = { 200, 50 }
cfg.FrameScale = 1.0
cfg.FrameInset = 2

cfg.HealthHeight = 20
cfg.PowerHeight = 5
cfg.HealthPowerMargin = cfg.FrameInset
cfg.FrameHeight = cfg.HealthHeight + cfg.PowerHeight + cfg.HealthPowerMargin

cfg.pet = {
	Position = {
		"LEFT",
		UIParent,
		"LEFT",
		50,
		-250,
	},
	FrameSize = { 400, cfg.HealthHeight },
	FrameScale = 1.0,
	HealthHeight = cfg.HealthHeight,
	PowerHeight = 0,
}

cfg.target = {
	Position = {
		"CENTER",
		UIParent,
		"CENTER",
		0,
		300,
	},
	FrameSize = { 400, cfg.FrameHeight },
	FrameScale = 1.0,
	HealthHeight = cfg.HealthHeight,
	PowerHeight = cfg.PowerHeight,
}


cfg.colors = {
	backdrop = { 0, 0, 0, 0.9 }, -- Backdrop Color (Some frames might not be affected)
	health = { 0.2, 0.2, 0.2, 1 }, -- Fallback color
	inverted = { 0.1, 0.1, 0.1, 1 } -- Inverted Color
}
