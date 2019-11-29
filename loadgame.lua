local Utils = require 'utils'

local Loadgame = { buttons = {} }

function Loadgame:load()
    logo = Utils.imageFromCache('assets/logo.png')
    table.insert(self.buttons, {image = Utils.imageFromCache('assets/loadgame/loadgame2.png'), fn = function()
        App.changeScreen('menu')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache('assets/loadgame/loadgame.png'), fn = nil })
end

function Loadgame:update(dt)
end

function Loadgame:draw(mx, my)
    love.graphics.draw(dayGradient, 0, 0, 0, App.width, App.height)

    local cx = App.width / 2
    local cy = App.height / 2

    love.graphics.draw(logo, cx, App.height/5, 0, 1.5*cx/logo:getWidth(), 1.5*cx/logo:getWidth(), 0.5*logo:getWidth(), 0.5*logo:getHeight())

    local hovered = false
    local bx = cx - 180
    local by = cy + 60
    local mouseOver = bx < mx and mx < bx + 350 and by < my and my < by + 105

    if mouseOver then
        love.graphics.draw(self.buttons[1].image, cx, cy - 150, 0, 1, 1, 0.5*self.buttons[1].image:getWidth())
        hovered = true
        if App.isMouseDown(1) then
            self.buttons[1].fn()
        end
    end

    if not hovered then
        love.graphics.draw(self.buttons[2].image, cx, cy - 150, 0, 1, 1, 0.5*self.buttons[1].image:getWidth())
    end
end

return Loadgame
