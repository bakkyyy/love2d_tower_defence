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
        attackRange = 2,
        attackSpeed = 1,
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
        attackRange = 2,
        attackSpeed = 2.75,
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
        attackRange = 2,
        attackSpeed = 1.25,
        damage = 7.5,
        shot = Utils.audioFromCache('Arrow.mp3')
    }
}

local uniqueId = 1
local Tower = {}

function Tower:new(type, position)
    local o = {
        id = uniqueId,
        data = towerTypes[type],
        target = nil,
        lastShotAt = 0,
        position = position,
        rotation = 1,
        type = type
    }
    uniqueId = uniqueId + 1
    self.__index = self
    return setmetatable(o, self)
end

function Tower:turn()
    local angle = math.deg(math.atan2(self.target.position[1] - self.position[1], self.target.position[2] - self.position[2]))
    local rotation = self.rotation

    if angle < 0 then
        angle = angle + 360
    end

    if 45 < angle and angle < 135 then
        rotation = 1
    elseif 135 < angle and angle < 225 then
        rotation = 2
    elseif 225 < angle and angle < 315 then
        rotation = 3
    else
        rotation = 4
    end

    self.rotation = rotation
end

function Tower:getImage()
    return Utils.imageFromCache(self.data.images[self.rotation])
end

function Tower:getAttackRange()
    return self.data.attackRange
end

function Tower:getAttackSpeed()
    return self.data.attackSpeed
end

function Tower:getDamage()
    return self.data.damage
end

function Tower:getRefund()
    return self.data.price/2
end

function Tower:shot()
    self.data.shot:play()
    self:turn()
end

return Tower
