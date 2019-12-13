local Bullet = require 'bullet'
local Utils = require 'utils'

towerTypes = {
    {
        images = {
            'assets/actors/weapon_crystals_N.png',
            'assets/actors/weapon_crystals_N.png',
            'assets/actors/weapon_crystals_N.png',
            'assets/actors/weapon_crystals_N.png'
        },
        price = 60,
        attackRange = 2.05,
        attackInterval = 1,
        damage = 1,
        shot = Utils.audioFromCache('Snow.mp3')
    },
    {
        images = {
            'assets/actors/weapon_cannon_E.png',
            'assets/actors/weapon_cannon_N.png',
            'assets/actors/weapon_cannon_W.png',
            'assets/actors/weapon_cannon_S.png'
        },
        price = 80,
        attackRange = 2.05,
        attackInterval = 2.75,
        damage = 25,
        shot = Utils.audioFromCache('Cannon.mp3')
    },
    {
        images = {
            'assets/actors/weapon_ballista_E.png',
            'assets/actors/weapon_ballista_N.png',
            'assets/actors/weapon_ballista_W.png',
            'assets/actors/weapon_ballista_S.png'
        },
        price = 48,
        attackRange = 2.05,
        attackInterval = 1.25,
        damage = 7.5,
        shot = Utils.audioFromCache('Arrow.mp3')
    }
}

local Tower = { uniqueId = 1 }

function Tower:new(type, position)
    local o = {
        id = tostring(self.uniqueId),
        data = towerTypes[type],
        target = nil,
        lastShotAt = 0,
        position = position,
        rotation = 1,
        type = type
    }

    build:setLooping(false)
    build:setVolume(App.settings.effectsVolume)
    build:play()

    self.uniqueId = self.uniqueId + 1
    self.__index = self
    return setmetatable(o, self)
end

function Tower:getImage()
    return Utils.imageFromCache(self.data.images[self.rotation])
end

function Tower:serialize()
    local t = {
        id = self.id,
        lastShotAt = self.lastShotAt,
        position = self.position,
        rotation = self.rotation,
        type = self.type
    }

    if self.target ~= nil then
        t.target = self.target.id
    end

    return t
end

function Tower:deserialize(de)
    local t = {
        id = de.id,
        data = towerTypes[de.type],
        target = App.game.enemies[de.target],
        lastShotAt = de.lastShotAt,
        position = de.position,
        rotation = de.rotation,
        type = de.type
    }

    self.__index = self
    return setmetatable(t, self)
end

function Tower:turnToTarget()
    local angle = math.deg(math.atan2(self.target.position[1] - self.position[1], self.target.position[2] - self.position[2]))
    if angle < 0 then
        angle = angle + 360
    end

    if 45 < angle and angle < 135 then
        self.rotation = 1
    elseif 135 < angle and angle < 225 then
        self.rotation = 2
    elseif 225 < angle and angle < 315 then
        self.rotation = 3
    else
        self.rotation = 4
    end
end

function Tower:getAttackRange()
    return self.data.attackRange
end

function Tower:getAttackInterval()
    return self.data.attackInterval
end

function Tower:getDamage()
    return self.data.damage
end

function Tower:getRefundAmount()
    sellsound:setLooping(false)
    sellsound:setVolume(App.settings.effectsVolume)
    sellsound:play()
    return 3*self.data.price/4
end

function Tower:findEnemy(state)
    for j, enemy in pairs(state.enemies) do
        local dx = enemy.position[1] - self.position[1]
        local dy = enemy.position[2] - self.position[2]
        local ar = self:getAttackRange()
        if dx*dx+dy*dy <= ar*ar and not enemy.isDead then
            self.target = enemy
            return
        end
    end
end

function Tower:update(state, dt)
    if self.target ~= nil then
        local dx = self.target.position[1] - self.position[1]
        local dy = self.target.position[2] - self.position[2]
        local ar = self:getAttackRange()
        if self.target.isDead or dx*dx+dy*dy > ar*ar then
            self.target = nil
        end
    end

    self:findEnemy(state)

    if self.target ~= nil then
        self:turnToTarget()
        if state.timeNow - self.lastShotAt > self:getAttackInterval() then
            self.lastShotAt = state.timeNow
            self.data.shot:setVolume(App.settings.effectsVolume)
            self.data.shot:play()
            local b = Bullet:new(self, self.target)
            state.bullets[b.id] = b
        end
    end

    for _,bullet in pairs(state.bullets) do
        bullet:update(state, dt)
    end
end

function Tower:draw(state, u, v)
    love.graphics.draw(self:getImage(), u, v - 16)
    for _,bullet in pairs(state.bullets) do
        bullet:draw()
    end
end

return Tower
