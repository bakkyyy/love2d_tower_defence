local Utils = require 'utils'

local Loadgame = { buttons = {}, musicVolume = 0.5, effectsVolume = 0.5 }

function Loadgame:load()
    logo = Utils.imageFromCache("assets/logo.png")
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/loadgame/loadgame2.png"), fn = function()
        App.changeScreen('menu')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/loadgame/loadgame.png.png"), fn = nil })
end

function Loadgame:update(dt)
end

function Loadgame:draw(mx, my)
    love.graphics.draw(dayGradient, 0, 0, 0, App.width, App.height)

    local cx = App.width / 2
    local cy = App.height / 2

    love.graphics.draw(logo, cx, App.height/5, 0, 1.5*cx/logo:getWidth(), 1.5*cx/logo:getWidth(), 0.5*logo:getWidth(), 0.5*logo:getHeight())
    
    local cursorY = 0
    local hovered = false

    for i, btn in ipairs(self.buttons) do
        local bx = cx - 200 + 24
        local by = 1.55*cy + cursorY
        local mouseOver = bx < mx and mx < bx + 360 and by < my and my < by + 105

        if mouseOver then
            love.graphics.draw(btn.image, cx, 1.55*cy, 0, 1, 1, 0.5*btn.image:getWidth())
            hovered = true
            if App.isMouseDown(1) then
                btn.fn()
            end
        end

        cursorY = cursorY + 147
    end

    if not hovered then
        love.graphics.draw(self.buttons[2].image, cx, 1.55*cy, 0, 1, 1, 0.5*self.buttons[1].image:getWidth())
    end
end

return Loadgame
