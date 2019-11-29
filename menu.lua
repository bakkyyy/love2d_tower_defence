local Utils = require 'utils'

local Menu = { buttons = {} }

function file_exists(name)
    local f = io.open(name,'r')
    if f~=nil then
        io.close(f)
    --else love.graphics.rectangle('line', 50, 50, 150, 150)
    end
 end

function Menu:load()
    logo = Utils.imageFromCache('assets/logo.png')
    local fex = file_exists('save.bin')

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/menu2.png'), fn = function()
        App.changeScreen('newgame')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/menu3.png'), fn = function()
        -- if not fex then
        --     App.changeScreen('loadgame')
        -- end
        App.changeScreen('game')
        App.game:loadFromFile()
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

        --love.graphics.rectangle('line', bx, by, 360, 105)

        if mouseOver then
            love.graphics.draw(btn.image, cx, 2*App.height/5, 0, 1, 1, 0.5*btn.image:getWidth())
            hovered = true
            if App.isMouseDown(1) then
                btn.fn()
            end
        end

        cursorY = cursorY + 147
    end

    if not hovered then
        love.graphics.draw(self.buttons[5].image, cx, 2*App.height/5, 0, 1, 1, 0.5*self.buttons[1].image:getWidth())
    end
end

return Menu
