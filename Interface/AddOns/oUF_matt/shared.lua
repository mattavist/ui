local _, ns = ...

local api = CreateFrame("Frame") -- API like methods
local tags = CreateFrame("Frame") -- API like methods
local bars = CreateFrame("Frame") -- API like methods
local util = CreateFrame("Frame") -- API like methods
local matt = CreateFrame("Frame", "oUF_matt") -- Main Frame
local oUF = ns.oUF or oUF
local G = {} -- Globals
local cfg, media = {}, {}

ns.cfg = cfg
ns.util = util
ns.media = media
ns.api = api
ns.tags = tags
ns.bars = bars
ns.matt = matt
ns.oUF = oUF
ns.G = G
