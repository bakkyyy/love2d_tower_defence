local test = require 'gambiarra'

test('Нажатие мышкой один раз', function()
    ok(App.isMouseDown(1) == false, 'кнопка ещё не была нажата')
    App.mouseDown[1] = true
    ok(App.isMouseDown(1), 'кнопка была нажата')
    ok(App.isMouseDown(1) == false, 'нажатие уже зафиксировано')
end)
