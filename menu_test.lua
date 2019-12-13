local test = require 'gambiarra'

local Menu = require 'menu'

test('Нажатие кнопки новая игра', function()
    Menu.buttons[2].fn()
    ok(Menu.state == MENU_STATE_NEWGAME, 'переключилось')
end)

test('Нажатие кнопки загрузить игру', function()
    Menu.buttons[3].fn()
    ok(Menu.state == MENU_STATE_LOADGAME, 'переключилось')
end)

test('Нажатие кнопки настройки', function()
    Menu.buttons[4].fn()
    ok(Menu.state == MENU_STATE_SETTINGS, 'переключилось')
end)
