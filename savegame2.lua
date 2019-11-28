local Utils = require 'utils'

local Savegame2 = { buttons = {} }

function Savegame2:load()
    logo = Utils.imageFromCache("assets/logo.png")
    local fex = file_exists('save.bin')
    music:play()

    table.insert(self.buttons, {image = Utils.imageFromCache("assets/savegame/savegame5.png"), fn = function()
        --save
        App.changeScreen('menu')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/savegame/savegame6.png"), fn = function()
        App.changeScreen('menu')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/savegame/savegame4.png"), fn = nil })
end

function Savegame2:update(dt)

end

function Savegame2:draw(mx, my)
    love.graphics.draw(dayGradient, 0, 0, 0, App.width, App.height)

    local cx = App.width / 2
    local cy = App.height / 2

    love.graphics.draw(logo, cx, App.height/5, 0, 1.5*cx/logo:getWidth(), 1.5*cx/logo:getWidth(), 0.5*logo:getWidth(), 0.5*logo:getHeight())

    local hovered = false
    local bx1 = cx - 400
    local by1 = cy - 40
    local bx2 = cx + 15
    local by2 = cy - 40
    local bx3 = cx - 200 + 24
    local by3 = cy + 205

    mouseOver1 = bx1 < mx and mx < bx1 + 385 and by1 < my and my < by1 + 215
    mouseOver2 = bx2 < mx and mx < bx2 + 385 and by2 < my and my < by2 + 215

    if mouseOver1 then
        love.graphics.draw(self.buttons[1].image, cx, cy - 175, 0, 1, 1, 0.5*self.buttons[1].image:getWidth())
        hovered = true
        if App.isMouseDown(1) then
            self.buttons[1].fn()
        end
    end

    if mouseOver2 then
        love.graphics.draw(self.buttons[2].image, cx, cy - 175, 0, 1, 1, 0.5*self.buttons[2].image:getWidth())
        hovered = true
        if App.isMouseDown(1) then
            self.buttons[2].fn()
        end
    end

    if not hovered then
        love.graphics.draw(self.buttons[3].image, cx, cy - 175, 0, 1, 1, 0.5*self.buttons[3].image:getWidth())
    end
end

return Savegame2
