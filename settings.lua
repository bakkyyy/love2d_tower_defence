local Utils = require 'utils'

local Settings = { buttons = {} }

function Settings:load()
    logo = Utils.imageFromCache("assets/logo.png")
    scroll = Utils.imageFromCache("assets/settings/scroll_area.png")
    mc = Utils.imageFromCache("assets/settings/scroll.png")
    es = Utils.imageFromCache("assets/settings/scroll.png")
    music = 0.5
    effects = 0.5

    table.insert(self.buttons, {image = Utils.imageFromCache("assets/settings/button_back2.png"), fn = function()
        App.changeScreen('menu')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/settings/button_back.png"), fn = nil })
    mesh = Utils.gradientMesh("vertical", {0.160784, 0.501961, 0.72549, 1}, {0.427451, 0.835294, 0.980392, 1}, {1, 1, 1, 1})
end

function Settings:update(dt)

end

function Settings:draw(ww, wh)
    love.graphics.draw(mesh, 0, 0, 0, ww, hh)

    local cx = ww / 2
    local cy = wh / 2

    love.graphics.draw(logo, cx, wh/5, 0, 1.5*cx/logo:getWidth(), 1.5*cx/logo:getWidth(), 0.5*logo:getWidth(), 0.5*logo:getHeight())
    love.graphics.print("МУЗЫКА", font, cx - 15*6, cy - 0.25*cy)
    love.graphics.draw(scroll, cx, wh/2.20, 0, 0.5*cx/scroll:getWidth(), 0.5*cx/scroll:getWidth(), 0.5*scroll:getWidth(), 0.5*scroll:getHeight())
    love.graphics.print("ЭФФЕКТЫ", font, cx - 15*7, cy + 0.05*cy)
    love.graphics.draw(scroll, cx, wh/1.65, 0, 0.5*cx/scroll:getWidth(), 0.5*cx/scroll:getWidth(), 0.5*scroll:getWidth(), 0.5*scroll:getHeight())

    local mx, my = love.mouse.getPosition()
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

    love.graphics.print(Utils.dump(App.mouseDown), 10, 10)
end

return Settings
