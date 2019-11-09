local Utils = require 'utils'

local Tower = {}

function Tower:new(type)
    local image = Utils.imageFromCache('assets/actors/weapon_crystals_N.png')
    if type == 2 then
        image = Utils.imageFromCache('assets/actors/weapon_cannon_E.png')
    elseif type == 3 then
        image = Utils.imageFromCache('assets/actors/weapon_ballista_E.png')
    end

    local o = {
        image = image,
        attackRange = nil,
        attackSpeed = nil,
        target = nil,
        lastShotAt = nil,
        damage = nil
    }
    self.__index = self
    return setmetatable(o, self)
end

return Tower
