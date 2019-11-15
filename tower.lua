local Utils = require 'utils'

local tId = 1
local Tower = {}
towerTypes = {
    {
        image = {
            'assets/actors/weapon_crystals_N.png',
            'assets/actors/weapon_crystals_N.png',
            'assets/actors/weapon_crystals_N.png',
            'assets/actors/weapon_crystals_N.png'
        },
        price = 150
    },
    {
        image = {
            'assets/actors/weapon_cannon_E.png',
            'assets/actors/weapon_cannon_N.png',
            'assets/actors/weapon_cannon_W.png',
            'assets/actors/weapon_cannon_S.png'
        },
        price = 50
    },
    {
        image = {
            'assets/actors/weapon_ballista_E.png',
            'assets/actors/weapon_ballista_N.png',
            'assets/actors/weapon_ballista_W.png',
            'assets/actors/weapon_ballista_S.png'
        },
        price = 20
    }
}

function Tower:new(type, pos)
    local o = {
        id = tId,
        image = Utils.imageFromCache(towerTypes[type].image[1]),
        attackRange = 2,
        attackSpeed = 1, -- интервал в секундах
        target = nil,
        lastShotAt = 0,
        damage = 50,
        pos = pos,
        type = type,
        rotation = 1
    }
    tId = tId + 1
    self.__index = self
    return setmetatable(o, self)
end

function Tower:turn()
    local angle = math.deg(math.atan2(self.target.pos[1] - self.pos[1], self.target.pos[2] - self.pos[2]))
    local rotation = self.rotation

    if angle < 0 then
        angle = angle + 360
    end
    self.deg = angle

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
    self.image = Utils.imageFromCache(towerTypes[self.type].image[self.rotation])
end

function Tower:shot()
    self:turn()
    self.target:takeDamage(self.damage)
end

return Tower
