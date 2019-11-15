local Utils = require 'utils'

local Enemy = {}

function Enemy:new(image, pos, speed, reward)
    local o = {
        image = 'assets/actors/' .. image,
        pos_index = 1,
        pos = Utils.deepcopy(pos),
        speed = speed,
        health = 100,
        isDead = false,
        reward = reward
    }
    self.__index = self
    return setmetatable(o, self)
end

function Enemy:setHealth(amount)
  self.health = amount
end

function Enemy:takeDamage(amount)
    self.health = self.health - amount
    if self.health <= 0 then
        self.isDead = true
    end
end

return Enemy
