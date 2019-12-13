local test = require 'gambiarra'

local Enemy = require 'enemy'
local Summer = require 'summer'

test('Создание противника', function()
    local e = Enemy:new(1, 1, 2, 5, 7)

    ok(e.id == '1', 'id = 1')
    ok(e.type == 1, 'type = 1')
    ok(e.whichPath == 1, 'whichPath = 1')
    ok(e.speed == 2, 'speed = 2')
    ok(e.reward == 5, 'reward = 5')
    ok(e.health == 7, 'health = 7')
end)

test('Сериализация противника', function()
    local e = Enemy:new(1, 1, 2, 5, 7)

    ok(eq(e:serialize(),{
        type = 1,
        id = 2,
        whichPath = 1,
        pathIndex = 1,
        position = e.path[1],
        speed = 2,
        speedModifier = 1,
        timeToUnfroze = 0,
        health = 7,
        isDead = false,
        reward = 5,
        currentFrame = 1,
        timeSinceFrameChange = 0
    }), 'Сериализация совпала')
end)

test('Десериализация противника', function()
    local e = Enemy:new(1, 1, 2, 5, 7)
    local se = e:serialize()

    ok(eq(e:deserialize(se), e), 'de(s(e)) = e')
end)

test('Обновление противника', function()
    local e = Enemy:new(1, 1, 2, 5, 7)
    local s = { money = 0 }

    e:update(s, 0.05)
    ok(e.timeToUnfroze == -0.05, 'timeToUnfroze = -0.05')
    ok(e.pathIndex == 1, 'pathIndex = 1')
    ok(e.currentFrame == 1, 'currentFrame = 1')
    e:update(s, 0.05)
    ok(e.timeToUnfroze == -0.1, 'timeToUnfroze = -0.1')
    ok(e.pathIndex == 1, 'pathIndex = 1')
    ok(e.currentFrame == 2, 'currentFrame = 2')
end)

test('Нанесение урона противнику', function()
    local e = Enemy:new(1, 1, 2, 5, 7)
    local s = { money = 0 }

    e:takeDamage(s, 5)
    ok(e.health == 2, 'health = 2')
    ok(s.money == 0, 'money = 0')

    e:takeDamage(s, 5)
    ok(e.health == -3, 'health = -3')
    ok(s.money == 5, 'money = 5')
end)

test('Заморозка противника', function()
    local e = Enemy:new(1, 1, 2, 5, 7)
    e:froze()

    ok(e.speedModifier = 0.5, 'speedModifier = 0.5')
    ok(e.timeToUnfroze = 1, 'timeToUnfroze = 1')
end)
