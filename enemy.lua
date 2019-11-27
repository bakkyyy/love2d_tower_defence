local Utils = require 'utils'

local enemyTypes = {
    {
        run = {
            'assets/actors/animation/1/run/6_enemies_1_run_000.png',
            'assets/actors/animation/1/run/6_enemies_1_run_001.png',
            'assets/actors/animation/1/run/6_enemies_1_run_002.png',
            'assets/actors/animation/1/run/6_enemies_1_run_003.png',
            'assets/actors/animation/1/run/6_enemies_1_run_004.png',
            'assets/actors/animation/1/run/6_enemies_1_run_005.png',
            'assets/actors/animation/1/run/6_enemies_1_run_006.png',
            'assets/actors/animation/1/run/6_enemies_1_run_007.png',
            'assets/actors/animation/1/run/6_enemies_1_run_008.png',
            'assets/actors/animation/1/run/6_enemies_1_run_009.png',
            'assets/actors/animation/1/run/6_enemies_1_run_010.png',
            'assets/actors/animation/1/run/6_enemies_1_run_011.png',
            'assets/actors/animation/1/run/6_enemies_1_run_012.png',
            'assets/actors/animation/1/run/6_enemies_1_run_013.png',
            'assets/actors/animation/1/run/6_enemies_1_run_014.png',
            'assets/actors/animation/1/run/6_enemies_1_run_015.png',
            'assets/actors/animation/1/run/6_enemies_1_run_016.png',
            'assets/actors/animation/1/run/6_enemies_1_run_017.png',
            'assets/actors/animation/1/run/6_enemies_1_run_018.png',
            'assets/actors/animation/1/run/6_enemies_1_run_019.png'
        },
        die = {
            'assets/actors/animation/1/die/6_enemies_1_die_000.png',
            'assets/actors/animation/1/die/6_enemies_1_die_001.png',
            'assets/actors/animation/1/die/6_enemies_1_die_002.png',
            'assets/actors/animation/1/die/6_enemies_1_die_003.png',
            'assets/actors/animation/1/die/6_enemies_1_die_004.png',
            'assets/actors/animation/1/die/6_enemies_1_die_005.png',
            'assets/actors/animation/1/die/6_enemies_1_die_006.png',
            'assets/actors/animation/1/die/6_enemies_1_die_007.png',
            'assets/actors/animation/1/die/6_enemies_1_die_008.png',
            'assets/actors/animation/1/die/6_enemies_1_die_009.png',
            'assets/actors/animation/1/die/6_enemies_1_die_010.png',
            'assets/actors/animation/1/die/6_enemies_1_die_011.png',
            'assets/actors/animation/1/die/6_enemies_1_die_012.png',
            'assets/actors/animation/1/die/6_enemies_1_die_013.png',
            'assets/actors/animation/1/die/6_enemies_1_die_014.png',
            'assets/actors/animation/1/die/6_enemies_1_die_015.png',
            'assets/actors/animation/1/die/6_enemies_1_die_016.png',
            'assets/actors/animation/1/die/6_enemies_1_die_017.png',
            'assets/actors/animation/1/die/6_enemies_1_die_018.png',
            'assets/actors/animation/1/die/6_enemies_1_die_019.png'
        }
    },
    {
        run = {
            'assets/actors/animation/2/run/2_enemies_1_run_000.png',
            'assets/actors/animation/3/run/2_enemies_1_run_001.png',
            'assets/actors/animation/2/run/2_enemies_1_run_002.png',
            'assets/actors/animation/2/run/2_enemies_1_run_003.png',
            'assets/actors/animation/2/run/2_enemies_1_run_004.png',
            'assets/actors/animation/2/run/2_enemies_1_run_005.png',
            'assets/actors/animation/2/run/2_enemies_1_run_006.png',
            'assets/actors/animation/2/run/2_enemies_1_run_007.png',
            'assets/actors/animation/2/run/2_enemies_1_run_008.png',
            'assets/actors/animation/2/run/2_enemies_1_run_009.png',
            'assets/actors/animation/2/run/2_enemies_1_run_010.png',
            'assets/actors/animation/2/run/2_enemies_1_run_011.png',
            'assets/actors/animation/2/run/2_enemies_1_run_012.png',
            'assets/actors/animation/2/run/2_enemies_1_run_013.png',
            'assets/actors/animation/2/run/2_enemies_1_run_014.png',
            'assets/actors/animation/2/run/2_enemies_1_run_015.png',
            'assets/actors/animation/2/run/2_enemies_1_run_016.png',
            'assets/actors/animation/2/run/2_enemies_1_run_017.png',
            'assets/actors/animation/2/run/2_enemies_1_run_018.png',
            'assets/actors/animation/2/run/2_enemies_1_run_019.png'
        },
        die = {
            'assets/actors/animation/2/die/2_enemies_1_die_000.png',
            'assets/actors/animation/2/die/2_enemies_1_die_001.png',
            'assets/actors/animation/2/die/2_enemies_1_die_002.png',
            'assets/actors/animation/2/die/2_enemies_1_die_003.png',
            'assets/actors/animation/2/die/2_enemies_1_die_004.png',
            'assets/actors/animation/2/die/2_enemies_1_die_005.png',
            'assets/actors/animation/2/die/2_enemies_1_die_006.png',
            'assets/actors/animation/2/die/2_enemies_1_die_007.png',
            'assets/actors/animation/2/die/2_enemies_1_die_008.png',
            'assets/actors/animation/2/die/2_enemies_1_die_009.png',
            'assets/actors/animation/2/die/2_enemies_1_die_010.png',
            'assets/actors/animation/2/die/2_enemies_1_die_011.png',
            'assets/actors/animation/2/die/2_enemies_1_die_012.png',
            'assets/actors/animation/2/die/2_enemies_1_die_013.png',
            'assets/actors/animation/2/die/2_enemies_1_die_014.png',
            'assets/actors/animation/2/die/2_enemies_1_die_015.png',
            'assets/actors/animation/2/die/2_enemies_1_die_016.png',
            'assets/actors/animation/2/die/2_enemies_1_die_017.png',
            'assets/actors/animation/2/die/2_enemies_1_die_018.png',
            'assets/actors/animation/2/die/2_enemies_1_die_019.png'
        }
    },
    {
        run = {
            'assets/actors/animation/3/run/3_enemies_1_run_000.png',
            'assets/actors/animation/3/run/3_enemies_1_run_001.png',
            'assets/actors/animation/3/run/3_enemies_1_run_002.png',
            'assets/actors/animation/3/run/3_enemies_1_run_003.png',
            'assets/actors/animation/3/run/3_enemies_1_run_004.png',
            'assets/actors/animation/3/run/3_enemies_1_run_005.png',
            'assets/actors/animation/3/run/3_enemies_1_run_006.png',
            'assets/actors/animation/3/run/3_enemies_1_run_007.png',
            'assets/actors/animation/3/run/3_enemies_1_run_008.png',
            'assets/actors/animation/3/run/3_enemies_1_run_009.png',
            'assets/actors/animation/3/run/3_enemies_1_run_010.png',
            'assets/actors/animation/3/run/3_enemies_1_run_011.png',
            'assets/actors/animation/3/run/3_enemies_1_run_012.png',
            'assets/actors/animation/3/run/3_enemies_1_run_013.png',
            'assets/actors/animation/3/run/3_enemies_1_run_014.png',
            'assets/actors/animation/3/run/3_enemies_1_run_015.png',
            'assets/actors/animation/3/run/3_enemies_1_run_016.png',
            'assets/actors/animation/3/run/3_enemies_1_run_017.png',
            'assets/actors/animation/3/run/3_enemies_1_run_018.png',
            'assets/actors/animation/3/run/3_enemies_1_run_019.png'
        },
        die = {
            'assets/actors/animation/3/die/3_enemies_1_die_000.png',
            'assets/actors/animation/3/die/3_enemies_1_die_001.png',
            'assets/actors/animation/3/die/3_enemies_1_die_002.png',
            'assets/actors/animation/3/die/3_enemies_1_die_003.png',
            'assets/actors/animation/3/die/3_enemies_1_die_004.png',
            'assets/actors/animation/3/die/3_enemies_1_die_005.png',
            'assets/actors/animation/3/die/3_enemies_1_die_006.png',
            'assets/actors/animation/3/die/3_enemies_1_die_007.png',
            'assets/actors/animation/3/die/3_enemies_1_die_008.png',
            'assets/actors/animation/3/die/3_enemies_1_die_009.png',
            'assets/actors/animation/3/die/3_enemies_1_die_010.png',
            'assets/actors/animation/3/die/3_enemies_1_die_011.png',
            'assets/actors/animation/3/die/3_enemies_1_die_012.png',
            'assets/actors/animation/3/die/3_enemies_1_die_013.png',
            'assets/actors/animation/3/die/3_enemies_1_die_014.png',
            'assets/actors/animation/3/die/3_enemies_1_die_015.png',
            'assets/actors/animation/3/die/3_enemies_1_die_016.png',
            'assets/actors/animation/3/die/3_enemies_1_die_017.png',
            'assets/actors/animation/3/die/3_enemies_1_die_018.png',
            'assets/actors/animation/3/die/3_enemies_1_die_019.png'
        }
    },
    {
        run = {
            'assets/actors/animation/4/run/5_enemies_1_run_000.png',
            'assets/actors/animation/4/run/5_enemies_1_run_001.png',
            'assets/actors/animation/4/run/5_enemies_1_run_002.png',
            'assets/actors/animation/4/run/5_enemies_1_run_003.png',
            'assets/actors/animation/4/run/5_enemies_1_run_004.png',
            'assets/actors/animation/4/run/5_enemies_1_run_005.png',
            'assets/actors/animation/4/run/5_enemies_1_run_006.png',
            'assets/actors/animation/4/run/5_enemies_1_run_007.png',
            'assets/actors/animation/4/run/5_enemies_1_run_008.png',
            'assets/actors/animation/4/run/5_enemies_1_run_009.png',
            'assets/actors/animation/4/run/5_enemies_1_run_010.png',
            'assets/actors/animation/4/run/5_enemies_1_run_011.png',
            'assets/actors/animation/4/run/5_enemies_1_run_012.png',
            'assets/actors/animation/4/run/5_enemies_1_run_013.png',
            'assets/actors/animation/4/run/5_enemies_1_run_014.png',
            'assets/actors/animation/4/run/5_enemies_1_run_015.png',
            'assets/actors/animation/4/run/5_enemies_1_run_016.png',
            'assets/actors/animation/4/run/5_enemies_1_run_017.png',
            'assets/actors/animation/4/run/5_enemies_1_run_018.png',
            'assets/actors/animation/4/run/5_enemies_1_run_019.png'
        },
        die = {
            'assets/actors/animation/4/die/5_enemies_1_die_000.png',
            'assets/actors/animation/4/die/5_enemies_1_die_001.png',
            'assets/actors/animation/4/die/5_enemies_1_die_002.png',
            'assets/actors/animation/4/die/5_enemies_1_die_003.png',
            'assets/actors/animation/4/die/5_enemies_1_die_004.png',
            'assets/actors/animation/4/die/5_enemies_1_die_005.png',
            'assets/actors/animation/4/die/5_enemies_1_die_006.png',
            'assets/actors/animation/4/die/5_enemies_1_die_007.png',
            'assets/actors/animation/4/die/5_enemies_1_die_008.png',
            'assets/actors/animation/4/die/5_enemies_1_die_009.png',
            'assets/actors/animation/4/die/5_enemies_1_die_010.png',
            'assets/actors/animation/4/die/5_enemies_1_die_011.png',
            'assets/actors/animation/4/die/5_enemies_1_die_012.png',
            'assets/actors/animation/4/die/5_enemies_1_die_013.png',
            'assets/actors/animation/4/die/5_enemies_1_die_014.png',
            'assets/actors/animation/4/die/5_enemies_1_die_015.png',
            'assets/actors/animation/4/die/5_enemies_1_die_016.png',
            'assets/actors/animation/4/die/5_enemies_1_die_017.png',
            'assets/actors/animation/4/die/5_enemies_1_die_018.png',
            'assets/actors/animation/4/die/5_enemies_1_die_019.png'
        }
    },
}

local uniqueId = 1
local Enemy = {}

function Enemy:new(type, path, speed, reward, health)
    local o = {
        type = type,
        id = uniqueId,
        path = path,
        pathIndex = 1,
        position = Utils.deepcopy(path[1]),
        speed = speed,
        speedModifier = 1,
        timeToUnfroze = 0,
        health = health,
        isDead = false,
        reward = reward,
        currentFrame = 1,
        timeSinceFrameChange = 0,
        frames = enemyTypes[type].run
    }

    uniqueId = uniqueId + 1
    self.__index = self
    return setmetatable(o, self)
end

function Enemy:getImage()
    return Utils.imageFromCache(self.frames[self.currentFrame])
end

function Enemy:update(state, dt)
    self.timeSinceFrameChange = self.timeSinceFrameChange + dt
    if self.timeSinceFrameChange > 0.1 then
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame == #self.frames and self.isDead then
            self:destroy(state)
        end
        self.currentFrame = self.currentFrame % #self.frames + 1
        self.timeSinceFrameChange = self.timeSinceFrameChange - 0.1
    end

    if self.timeToUnfroze <= 0 and self.speedModifier < 1 and not self.isDead then
        self.speedModifier = 1
        self.currentFrame = 1
        self.frames = enemyTypes[self.type].run
    end
    self.timeToUnfroze = self.timeToUnfroze - dt

    if self.pathIndex >= #self.path then
        state.lives = state.lives - 1
        self.isDead = true
        self:destroy(state)
        return
    end

    if self.isDead then
        state.money = state.money + self.reward
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
        self.position = Utils.deepcopy(nextPos)
    end
end

function Enemy:takeDamage(amount)
    self.health = self.health - amount
    if self.health <= 0 then
        self.isDead = true
        self.currentFrame = 1
        self.frames = enemyTypes[self.type].die
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
