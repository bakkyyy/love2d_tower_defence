local test = require 'gambiarra'

local Tower = require 'tower'

test('Создание башни', function()
    local t1 = Tower:new(1, { 1, 1 })
    local t2 = Tower:new(2, { 1, 1 })
    local t3 = Tower:new(3, { 1, 1 })

    ok(eq(t1.data, towerTypes[1]), 'Башня 1 создана с корректными параметрами')
    ok(eq(t2.data, towerTypes[2]), 'Башня 2 создана с корректными параметрами')
    ok(eq(t3.data, towerTypes[3]), 'Башня 3 создана с корректными параметрами')

    ok(t1.id == '1', 'id = 1')
    ok(t2.id == '2', 'id = 2')
    ok(t3.id == '3', 'id = 3')
end)

test('Сериализация башни', function()
    local t = Tower:new(1, { 1, 1 })

    ok(eq(t:serialize(), {
        id = 4,
        lastShotAt = 0,
        position = { 1, 1 },
        rotation = 1,
        type = 1
    }), 'Сериализация совпала')
end)

test('Десериализация башни', function()
    local t = Tower:new(1, { 1, 1 })
    local st = t:serialize()

    ok(eq(t:deserialize(st), t), 'de(s(t)) = t')
end)

test('Поворот башни', function()
    local t = Tower:new(1, { 1, 1 })
    t.target =  { position = { 1, 2 } }
    t:turnToTarget()
    ok(t.rotation == 4, "S")
    t.target =  { position = { 2, 1 } }
    t:turnToTarget()
    ok(t.rotation == 1, "E")
    t.target =  { position = { 0, 1 } }
    t:turnToTarget()
    ok(t.rotation == 3, "W")
    t.target =  { position = { 1, 0 } }
    t:turnToTarget()
    ok(t.rotation == 2, "N")
end)

test('Возвращает дальность стрельбы башни', function()
    local t = Tower:new(1, { 1, 1 })
    ok(t:getAttackRange() == 2.05, "range = 2.05")
end)

test('Возвращает интервал между выстрелами', function()
    local t = Tower:new(1, { 1, 1 })
    ok(t:getAttackInterval() == 1, "interval = 1")
end)

test('Возвращает урон', function()
    local t = Tower:new(1, { 1, 1 })
    ok(t:getDamage() == 1, "damage = 1")
end)

test('Возвращает стоимость продажи', function()
    local t1 = Tower:new(1, { 1, 1 })
    local t2 = Tower:new(2, { 1, 1 })
    local t3 = Tower:new(3, { 1, 1 })
    ok(t1:getRefundAmount() == 45, "t1 продана за 45")
    ok(t2:getRefundAmount() == 60, "t2 продана за 60")
    ok(t3:getRefundAmount() == 36, "t3 продана за 36")
end)

test('Поиск противника', function()
    local t = Tower:new(1, { 1, 1 })
    t:findEnemy({ enemies = {} })
    ok(t.enemy == nil, "нет противника")
    t:findEnemy({ enemies = {{ position = { 1, 1 } }} })
    ok(t.enemy ~= nil, "противник в центре")
    t.enemy = nil
    t:findEnemy({ enemies = {{ position = { 1, 3 } }} })
    ok(t.enemy ~= nil, "противник на границе")
end)
