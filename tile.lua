local Utils = require 'utils'

local Tile = {}

function Tile:new(image, towerable)
    local t = {
        image = Utils.imageFromCache('assets/tiles/' .. image),
        tower = nil,
        towerable = towerable,
        rendered = false
    }
    self.__index = self
    return setmetatable(t, self)
end

return Tile
