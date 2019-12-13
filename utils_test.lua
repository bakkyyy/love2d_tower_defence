local test = require 'gambiarra'

local Utils = require 'utils'

test('Загрузка несуществующего изображения', function()
    ok(eq(Utils.imageFromCache('assets/win.jpg'), nil))
end)

test('Загрузка существующего изображения', function()
    ok(eq(Utils.imageFromCache('assets/win.png'), love.graphics.newImage('assets/win.png')))
end)

test('Загрузка несуществующего звука', function()
    ok(eq(Utils.audioFromCache('assets/win.jpg'), nil))
end)

test('Загрузка существующего звука', function()
    ok(eq(Utils.audioFromCache('Arrow.mp3'), love.audio.newSource('assets/music/Arrow.mp3', 'static')))
end)

test('Копирование таблицы', function()
    local t1 = { a = 1 }
    local t2 = Utils.deepCopy(t1)
    t2.a = t2.a + 1
    ok(t1.a ~= t2.a, 't1.a не t2.a')
end)

test('Удаление из массива', function()
    local a = { 1, 2, 3 }
    Utils.removeByKey(a, 2)
    ok(eq(a, { 1, 3 }), 'элемент удалён')
end)

test('Удаление из таблицы', function()
    local a = { b = 1, c = 2 }
    Utils.removeByKey(a, 'c')
    ok(eq(a, { b = 1 }), 'элемент удалён')
end)

test('Удаление отрицательного индекса', function()
    local a = { -1 = 1, 0 = 2, 1 = 3 }
    Utils.removeByKey(a, -1)
    ok(eq(a, { 0 = 2, 1 = 3 }), 'элемент удалён')
end)

test('Площадь треугольника', function()
    local a = { 0, 0 }
    local b = { 3, 0 }
    local c = { 0, 4 }
    ok(Utils.triangleArea(a, b, c) == 6, 'равна 6')
end)

test('Площадь четырёхугольника', function()
    local a = { 0, 0 }
    local b = { 3, 0 }
    local c = { 1, 2 }
    local d = { 4, 2 }
    ok(Utils.rectangleArea(a, b, c, d) == 3, 'равна 3')
end)

test('Точка и четырёхугольник', function()
    local a = { 0, 0 }
    local b = { 3, 0 }
    local c = { 1, 2 }
    local d = { 4, 2 }
    ok(Utils.pointInRect(a, b, c, d, { 0, 0 }) == true, 'внутри')
    ok(Utils.pointInRect(a, b, c, d, { 1, 1 }) == true, 'внутри')
    ok(Utils.pointInRect(a, b, c, d, { -1, 0 }) == false, 'снаружи')
end)

test('Ограничитель', function()
    ok(Utils.clamp(-1, 0, 1) == 0, '-1 -> 0')
    ok(Utils.clamp(2, 0, 1) == 1, '2 -> 1')
    ok(Utils.clamp(0.5, 0, 1) == 0.5, '0.5 -> 0.5')
    ok(Utils.clamp(0, 0, 1) == 0, '0 -> 0')
    ok(Utils.clamp(0.5, 0, 1) == 1, '1 -> 1')
end)

test('Размер таблицы', function()
    ok(Utils.tableSize({ -1 = 1, 0 = 2, 1 = 3 }) == 3, 'tableSize({ -1 = 1, 0 = 2, 1 = 3 }) = 3')
    ok(Utils.tableSize({ k = 1, v = 2 }) == 2, 'tableSize({ k = 1, v = 2 }) = 2')
end)

test('Существование файла', function()
    ok(Utils.fileExists('assets/win.png'), 'win.png существует')
    ok(Utils.fileExists('assets/win.jpg') == false, 'win.jpg не существует')
end)
