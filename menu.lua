local Utils = require 'utils'

local Menu = { buttons = {} }

function Menu:load()
    logo = Utils.imageFromCache('assets/logo.png')

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/menu2.png'), fn = function()
        App.changeScreen('newgame')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/menu3.png'), fn = function()
        if Utils.fileExists('save.ppg') then
            music:stop()
            App.changeScreen('game')
            App.game:loadFromFile()
        else
            App.changeScreen('loadgame')
        end
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/menu4.png'), fn = function()
        App.changeScreen('settings')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/menu5.png'), fn = function()
        music:stop()
        love.window.close()
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/menu.png'), fn = nil })
end

function Menu:update(dt)

end

function Menu:draw(mx, my)
    love.graphics.setColor({1, 1, 1})
    love.graphics.draw(dayGradient, 0, 0, 0, App.width, App.height)

    local cx = App.width / 2
    local cy = App.height / 2

    love.graphics.draw(logo, cx, App.height/5, 0, 1.5*cx/logo:getWidth(), 1.5*cx/logo:getWidth(), 0.5*logo:getWidth(), 0.5*logo:getHeight())

    local cursorY = 0
    local hovered = false

    for i = 1,4 do
        local btn = self.buttons[i]
        local bx = cx - 200 + 24
        local by = 2*App.height/5 + cursorY
        local mouseOver = bx < mx and mx < bx + 360 and by < my and my < by + 105

        if mouseOver then
            love.graphics.draw(btn.image, cx, 2*App.height/5, 0, 1, 1, btn.image:getWidth()/2)
            hovered = true
            if App.isMouseDown(1) then
                btn.fn()
            end
        end

        cursorY = cursorY + 147
    end

    if not hovered then
        love.graphics.draw(self.buttons[5].image, cx, 2*App.height/5, 0, 1, 1, self.buttons[1].image:getWidth()/2)
    end
end

return Menu
