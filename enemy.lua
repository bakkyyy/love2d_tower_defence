local Utils = require 'utils'

ANIMATION_TYPE_RUN = 'run'
ANIMATION_TYPE_DIE = 'die'

local Enemy = { uniqueId = 1 }

function Enemy:new(type, whichPath, speed, reward, health)
    local path = App.game.map.paths[whichPath]
    local o = {
        type = type,
        id = tostring(self.uniqueId),
        path = path,
        whichPath = whichPath,
        pathIndex = 1,
        position = Utils.deepCopy(path[1]),
        speed = speed,
        speedModifier = 1,
        timeToUnfroze = 0,
        health = health,
        isDead = false,
        reward = reward,
        currentFrame = 1,
        timeSinceFrameChange = 0,
        animationType = ANIMATION_TYPE_RUN
    }

    self.uniqueId = self.uniqueId + 1
    self.__index = self
    return setmetatable(o, self)
end

function Enemy:getImage()
    local sf = string.format('assets/actors/%d/%s/%d.png', self.type, self.animationType, self.currentFrame)
    return Utils.imageFromCache(sf)
end

function Enemy:serialize()
    return {
        type = self.type,
        id = self.id,
        whichPath = self.whichPath,
        pathIndex = self.pathIndex,
        position = self.position,
        speed = self.speed,
        speedModifier = self.speedModifier,
        timeToUnfroze = self.timeToUnfroze,
        health = self.health,
        isDead = self.isDead,
        reward = self.reward,
        currentFrame = self.currentFrame,
        timeSinceFrameChange = self.timeSinceFrameChange
    }
end

function Enemy:deserialize(de)
    local path = App.game.map.paths[de.whichPath]
    local e = {
        type = de.type,
        id = de.id,
        path = path,
        whichPath = de.whichPath,
        pathIndex = de.pathIndex,
        position = de.position,
        speed = de.speed,
        speedModifier = de.speedModifier,
        timeToUnfroze = de.timeToUnfroze,
        health = de.health,
        isDead = de.isDead,
        reward = de.reward,
        currentFrame = de.currentFrame,
        timeSinceFrameChange = de.timeSinceFrameChange
    }

    if e.isDead then
        e.animationType = ANIMATION_TYPE_DIE
    else
        e.animationType = ANIMATION_TYPE_RUN
    end

    self.__index = self
    return setmetatable(e, self)
end

function Enemy:update(state, dt)
    self.timeSinceFrameChange = self.timeSinceFrameChange + dt
    if self.timeSinceFrameChange > 0.1 then
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame == 20 and self.isDead then
            self:destroy(state)
        end
        self.currentFrame = self.currentFrame % 20 + 1
        self.timeSinceFrameChange = self.timeSinceFrameChange - 0.1
    end

    if self.timeToUnfroze <= 0 and self.speedModifier < 1 and not self.isDead then
        self.speedModifier = 1
        self.currentFrame = 1
        self.animationType = ANIMATION_TYPE_RUN
    end
    self.timeToUnfroze = self.timeToUnfroze - dt

    if self.pathIndex >= #self.path then
        state.lives = state.lives - 1
        self.isDead = true
        self:destroy(state)
        return
    end

    if self.isDead then
        return
    end

    local prevPos = self.path[self.pathIndex]
    local nextPos = self.path[self.pathIndex + 1]
    local reached = false

    if prevPos[1] < nextPos[1] then
        self.position[1] = self.position[1] + self.speed*dt*self.speedModifier
        if self.position[1] > nextPos[1] then
            reached = true
        end
    elseif prevPos[1] > nextPos[1] then
        self.position[1] = self.position[1] - self.speed*dt*self.speedModifier
        if self.position[1] < nextPos[1] then
            reached = true
        end
    elseif prevPos[2] < nextPos[2] then
        self.position[2] = self.position[2] + self.speed*dt*self.speedModifier
        if self.position[2] > nextPos[2] then
            reached = true
        end
    elseif prevPos[2] > nextPos[2] then
        self.position[2] = self.position[2] - self.speed*dt*self.speedModifier
        if self.position[2] < nextPos[2] then
            reached = true
        end
    end

    if reached then
        self.pathIndex = self.pathIndex + 1
        self.position = Utils.deepCopy(nextPos)
    end
end

function Enemy:takeDamage(state, amount)
    self.health = self.health - amount
    if self.health <= 0 then
        self.isDead = true
        state.money = state.money + self.reward
        self.currentFrame = 1
        self.animationType = ANIMATION_TYPE_DIE
    end
end

function Enemy:froze()
    self.speedModifier = 0.5
    self.currentFrame = 1
    self.timeToUnfroze = 1
end

function Enemy:destroy(state)
    Utils.removeByKey(state.enemies, self.id)
end

return Enemy
