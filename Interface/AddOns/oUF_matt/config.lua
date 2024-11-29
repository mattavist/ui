local _, ns = ...
local cfg = ns.cfg


cfg.InProgress = "target"

cfg.FrameSize = { 150, 50 }
cfg.FrameScale = 1.0

cfg.colors = {
	backdrop = { 0, 0, 0, 0.9 }, -- Backdrop Color (Some frames might not be affected)
	health = { 0.2, 0.2, 0.2, 1 }, -- Fallback color
	inverted = { 0.1, 0.1, 0.1, 1 } -- Inverted Color
}
