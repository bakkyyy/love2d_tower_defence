local Utils = require 'utils'

local Settings = { buttons = {}, musicVolume = 0.5, effectsVolume = 0.5 }

function Settings:load()
    logo = Utils.imageFromCache("assets/logo.png")
    scroll = Utils.imageFromCache("assets/settings/scroll_area.png")
    mc = Utils.imageFromCache("assets/settings/scroll.png")
    es = Utils.imageFromCache("assets/settings/scroll.png")

    table.insert(self.buttons, {image = Utils.imageFromCache("assets/settings/button_back2.png"), fn = function()
        App.changeScreen('menu')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/settings/button_back.png"), fn = nil })
end

function Settings:update(dt)

end

function Settings:draw(mx, my)
    love.graphics.draw(dayGradient, 0, 0, 0, App.width, App.height)

    local cx = App.width / 2
    local cy = App.height / 2

    love.graphics.draw(logo, cx, App.height/5, 0, 1.5*cx/logo:getWidth(), 1.5*cx/logo:getWidth(), 0.5*logo:getWidth(), 0.5*logo:getHeight())
    love.graphics.print("МУЗЫКА", font, cx - 15*6, cy - 0.25*cy)
    love.graphics.draw(scroll, cx, App.height/2.20, 0, 0.5*cx/scroll:getWidth(), 0.5*cx/scroll:getWidth(), 0.5*scroll:getWidth(), 0.5*scroll:getHeight())
    love.graphics.print("ЭФФЕКТЫ", font, cx - 15*7, cy + 0.05*cy)
    love.graphics.draw(scroll, cx, App.height/1.65, 0, 0.5*cx/scroll:getWidth(), 0.5*cx/scroll:getWidth(), 0.5*scroll:getWidth(), 0.5*scroll:getHeight())

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

return Settings
