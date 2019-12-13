local test = require 'gambiarra'

local Tower = require 'tower'
local Bullet = require 'bullet'

test('Создание снаряда', function()
    local t = Tower:new(1, { 1, 1 })
    local b = Bullet:new(t, t.target)

    ok(b.id == '1', 'id = 1')
end)

test('Сериализация снаряда', function()
    local t = Tower:new(1, { 1, 1 })
    local b = Bullet:new(t, t.target)

    ok(eq(b:serialize(), {
        id = 2,
        position = self.position,
        rotation = self.rotation,
        tower = t.id
    }), 'Сериализация совпала')
end)

test('Десериализация снаряда', function()
    local t = Tower:new(1, { 1, 1 })
    local b = Bullet:new(t, t.target)
    local sb = b:serialize()

    ok(eq(b:deserialize(sb), b), 'de(s(b)) = b')
end)
