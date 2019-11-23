local Utils = require 'utils'

local Menu = { buttons = {} }

function Menu:load()
    logo = Utils.imageFromCache("assets/logo.png")
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/menu/menu2.png"), fn = function()
        App.changeScreen('game')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/menu/menu3.png"), fn = nil })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/menu/menu4.png"), fn = function()
        App.changeScreen('settings')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/menu/menu5.png"), fn = function()
        love.window.close()
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/menu/menu.png"), fn = nil })
    mesh = Utils.gradientMesh("vertical", {0.160784, 0.501961, 0.72549, 1}, {0.427451, 0.835294, 0.980392, 1}, {1, 1, 1, 1})
end

function Menu:update(dt)

end

function Menu:draw(ww, wh)
    love.graphics.draw(mesh, 0, 0, 0, ww, hh)

    local cx = ww / 2
    local cy = wh / 2

    love.graphics.draw(logo, cx, wh/5, 0, 1.5*cx/logo:getWidth(), 1.5*cx/logo:getWidth(), 0.5*logo:getWidth(), 0.5*logo:getHeight())

    local mx, my = love.mouse.getPosition()
    local cursorY = 0
    local hovered = false

    for i, btn in ipairs(self.buttons) do
        local bx = cx - 200 + 24
        local by = 2*wh/5 + cursorY
        local mouseOver = bx < mx and mx < bx + 360 and by < my and my < by + 105

        if mouseOver then
            love.graphics.draw(btn.image, cx, 2*wh/5, 0, 1, 1, 0.5*btn.image:getWidth())
            hovered = true
            if App.isMouseDown(1) then
                btn.fn()
            end
        end

        cursorY = cursorY + 147
    end

    if not hovered then
        love.graphics.draw(self.buttons[5].image, cx, 2*wh/5, 0, 1, 1, 0.5*self.buttons[1].image:getWidth())
    end

    love.graphics.print(Utils.dump(App.mouseDown), 10, 10)
end

return Menu
