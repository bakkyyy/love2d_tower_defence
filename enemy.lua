local Utils = require 'utils'

local Enemy = { health = 0, image = '' }

function Enemy:new(image, pos, speed)
    local o = {
        image = 'assets/actors/' .. image,
        pos_index = 1,
        pos = Utils.deepcopy(pos),
        speed = speed,
        health = 0
    }
    self.__index = self
    return setmetatable(o, self)
end

function Enemy:setHealth(amount)
  self.health = amount
end

return Enemy
