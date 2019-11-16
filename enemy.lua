local Utils = require 'utils'

local uniqueId = 1
local Enemy = {}

function Enemy:new(image, path, speed, reward)
    local o = {
        id = uniqueId,
        image = Utils.imageFromCache('assets/actors/' .. image),
        path = path,
        pathIndex = 1,
        position = Utils.deepcopy(path[1]),
        speed = speed,
        health = 6,
        isDead = false,
        reward = reward
    }
    uniqueId = uniqueId + 1
    self.__index = self
    return setmetatable(o, self)
end

function Enemy:update(state, dt)
    if self.pathIndex >= #self.path then
        state.lives = state.lives - 1
        self:destroy(state)
        return
    end

    if self.isDead then
        state.money = state.money + self.reward
        self:destroy(state)
        return
    end

    local prevPos = self.path[self.pathIndex]
    local nextPos = self.path[self.pathIndex + 1]
    local reached = false

    if prevPos[1] < nextPos[1] then
        self.position[1] = self.position[1] + self.speed*dt
        if self.position[1] > nextPos[1] then
            reached = true
        end
    elseif prevPos[1] > nextPos[1] then
        self.position[1] = self.position[1] - self.speed*dt
        if self.position[1] < nextPos[1] then
            reached = true
        end
    elseif prevPos[2] < nextPos[2] then
        self.position[2] = self.position[2] + self.speed*dt
        if self.position[2] > nextPos[2] then
            reached = true
        end
    elseif prevPos[2] > nextPos[2] then
        self.position[2] = self.position[2] - self.speed*dt
        if self.position[2] < nextPos[2] then
            reached = true
        end
    end

    if reached then
        self.pathIndex = self.pathIndex + 1
        self.position = Utils.deepcopy(nextPos)
    end
end

function Enemy:takeDamage(amount)
    self.health = self.health - amount
    if self.health <= 0 then
        self.isDead = true
    end
end

function Enemy:destroy(state)
    Utils.removeByKey(state.enemies, self.id)
end

return Enemy
