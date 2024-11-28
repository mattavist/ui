local _, ns = ...
local media = ns.media


media.colors = {
	backdrop = { 0, 0, 0, 0.9 }, -- Backdrop Color (Some frames might not be affected)
	health = { 0.2, 0.2, 0.2, 1 }, -- Fallback color
	inverted = { 0.1, 0.1, 0.1, 1 } -- Inverted Color
}

local mediaPath = "Interface\\AddOns\\oUF_matt\\media\\"
media.textures = {
	status_texture = mediaPath .. "statusbar",
	bg_texture = mediaPath .. "texture_bg",
	aura_border = mediaPath .. "aura_border",
	button_border = mediaPath .. "button_border",
	white_square = mediaPath .. "white",
	glow_texture = mediaPath .. "glow",
	damager_texture = mediaPath .. "damager",
	healer_texture = mediaPath .. "healer",
	tank_texture = mediaPath .. "tank",
	debuff_texture = mediaPath .. "debuff_highlight",
}


media.roleIconTextures = {
	TANK = media.textures.tank_texture,
	HEALER = media.textures.healer_texture,
	DAMAGER = media.textures.damager_texture
}

media.roleIconColor = {
	TANK = { 0 / 255, 175 / 255, 255 / 255 },
	HEALER = { 0 / 255, 255 / 255, 100 / 255 },
	DAMAGER = { 225 / 255, 0 / 255, 25 / 255 }
}
