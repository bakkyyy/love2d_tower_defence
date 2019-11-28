local Utils = require 'utils'

local bulletTypes = {
    'assets/crystal.png',
    'assets/ball.png',
    'assets/bolt.png'
}

local uniqueId = 1
local Bullet = {}

function Bullet:new(tower, enemy)
    local b = {
        id = uniqueId,
        image = Utils.imageFromCache(bulletTypes[tower.type]),
        position = Utils.deepcopy(tower.position),
        tower = tower,
        target = enemy,
        rotation = 0
    }

    uniqueId = uniqueId + 1
    self.__index = self
    return setmetatable(b, self)
end

function Bullet:turn()
    local angle = math.atan2(self.target.position[1] - self.position[1], self.target.position[2] - self.position[2])
    if angle < 0 then
        angle = angle + 2*math.pi
    end
    self.rotation = math.pi/4 - angle
end

function Bullet:update(state, dt)
    local dx = self.target.position[1] - self.position[1]
    local dy = self.target.position[2] - self.position[2]

    self.position[1] = self.position[1] + 10*dx*dt
    self.position[2] = self.position[2] + 10*dy*dt

    if dx*dx+dy*dy < 0.5 then
        self.target:takeDamage(state, self.tower:getDamage())
        if self.tower.type == 1 then
            self.target:froze()
        end
        self:destroy(state)
    end
end

function Bullet:getImage()
    self:turn()
    return self.image
end

function Bullet:draw()
    local u = App.width/2
    local v = App.height/2 - 6*65

    local bx = u + (self.position[1] - self.position[2]) * 65
    local by = v + (self.position[1] + self.position[2] - 2) * 32

    love.graphics.draw(self:getImage(), bx, by, self.rotation)
end

function Bullet:destroy(state)
    Utils.removeByKey(state.bullets, self.id)
end

return Bullet
