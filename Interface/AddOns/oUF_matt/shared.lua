local _, ns = ...

local api = CreateFrame("Frame") -- API like methods
local matt = CreateFrame("Frame", "oUF_matt") -- Main Frame
local oUF = ns.oUF or oUF
local G = {} -- Globals
local cfg, media = {}, {}

ns.api = api
ns.cfg = cfg
ns.media = media
ns.matt = matt
ns.oUF = oUF
ns.G = G
