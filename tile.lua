local Utils = require 'utils'

local Tile = {}

function Tile:new(image, towerable)
    local t = {
        image = 'assets/tiles/' .. image,
        tower = nil,
        towerable = towerable,
        rendered = false
    }
    self.__index = self
    return setmetatable(t, self)
end

function Tile:getImage()
    return Utils.imageFromCache(self.image)
end

function Tile:serialize()
    return {
        image = self.image,
        tower = self.tower.id,
        towerable = self.towerable,
        rendered = self.rendered
    }
end

return Tile
