local Utils = require 'utils'

DRAW_MODE_1x1 = 1
DRAW_MODE_2x1 = 2
DRAW_MODE_1x2 = 4
DRAW_MODE_2x2 = 8

local Tile = {}

function Tile:new(image, start, stop, mode, towerable)
    local t = {
        image = Utils.imageFromCache('assets/tiles/' .. image),
        start = start,
        stop = stop,
        mode = mode,
        tower = nil,
        towerable = towerable,
        rendered = false
    }
    self.__index = self
    return setmetatable(t, self)
end

return Tile
