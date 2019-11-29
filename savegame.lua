local Utils = require 'utils'

local Savegame = { buttons = {} }

function file_exists(name)
    local f = io.open(name,"r")
    if f~=nil then 
        io.close(f)  
    --else love.graphics.rectangle('line', 50, 50, 150, 150)
    end
 end

function Savegame:load()
    logo = Utils.imageFromCache("assets/logo.png")
    local fex = file_exists('save.bin')
    music:play()

    table.insert(self.buttons, {image = Utils.imageFromCache("assets/savegame/savegame2.png"), fn = function()
        if not fex then
            --save
            App.changeScreen('menu')
        else App.changeScreen('Savegame2')
        end
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/savegame/savegame3.png"), fn = function()
        App.changeScreen('menu')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/savegame/savegame.png"), fn = nil })
end

function Savegame:update(dt)

end

function Savegame:draw(mx, my)
    love.graphics.draw(dayGradient, 0, 0, 0, App.width, App.height)

    local cx = App.width / 2
    local cy = App.height / 2

    love.graphics.draw(logo, cx, App.height/5, 0, 1.5*cx/logo:getWidth(), 1.5*cx/logo:getWidth(), 0.5*logo:getWidth(), 0.5*logo:getHeight())

    local hovered = false
    local bx1 = cx - 250
    local by1 = cy + 50
    local bx2 = cx + 45
    local by2 = cy + 50
    
    mouseOver1 = bx1 < mx and mx < bx1 + 210 and by1 < my and my < by1 + 80
    mouseOver2 = bx2 < mx and mx < bx2 + 210 and by2 < my and my < by2 + 80

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

return Savegame
