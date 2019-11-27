local Utils = require 'utils'

local Settings = { buttons = {}, musicVolume = 0.5, effectsVolume = 0.5 }

function Settings:load()
    logo = Utils.imageFromCache("assets/logo.png")
    scroll = Utils.imageFromCache("assets/settings/scroll_area.png")
    mc = Utils.imageFromCache("assets/settings/scroll.png")
    sc = Utils.imageFromCache("assets/settings/scroll.png")

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

    local musicWidth = font:getWidth("МУЗЫКА")
    local effectsWidth = font:getWidth("ЭФФЕКТЫ")

    love.graphics.draw(logo, cx, App.height/5, 0, 1.5*cx/logo:getWidth(), 1.5*cx/logo:getWidth(), 0.5*logo:getWidth(), 0.5*logo:getHeight())
    love.graphics.print("МУЗЫКА", font, cx - musicWidth/2, 1.75*App.height/5)
    love.graphics.draw(scroll, cx, 2.25*App.height/5, 0, 1.5, 1.5, 0.5*scroll:getWidth(), 0.5*scroll:getHeight())
    
    local msx = cx - 1.5*0.5*scroll:getWidth()
    local msy = 2.25*App.height/5 - 12
    local mouseOver = msx < mx and mx < msx + 1.5*scroll:getWidth() and msy < my and my < msy + 1.5*scroll:getHeight()
    if mouseOver and love.mouse.isDown(1) then
        local ox = msx + 1.5*scroll:getWidth() - mx
        self.musicVolume = 1 - (ox/(1.5*scroll:getWidth()))
        music:setVolume(App.settings.musicVolume)
        --love.graphics.print(self.musicVolume, font, cx+200, cy - 0.25*cy)
    end
    --love.graphics.print({msx + 1.5*scroll:getWidth(), mx})
    --love.graphics.rectangle('line', msx, msy, 1.5*scroll:getWidth(), 1.5*scroll:getHeight())
    love.graphics.draw(mc, msx + 1.45*scroll:getWidth()*self.musicVolume, 2.25*App.height/5 - 30, 0, 1.5, 1.5)
    --love.graphics.draw(mc, cx - 3*scroll:getWidth()/4 + 1.5*scroll:getWidth() * (1 - self.musicVolume), App.height/2.20, 0, 1.5, 1.5)
    
    love.graphics.print("ЭФФЕКТЫ", font, cx - effectsWidth/2, 2.75*App.height/5)
    love.graphics.draw(scroll, cx, 3.25*App.height/5, 0, 1.5, 1.5, 0.5*scroll:getWidth(), 0.5*scroll:getHeight())
    
    local esx = cx - 1.5*0.5*scroll:getWidth()
    local esy = 3.25*App.height/5 -12
    local mouseOver = esx < mx and mx < esx + 1.5*scroll:getWidth() and esy < my and my < esy + 1.5*scroll:getHeight()
    if mouseOver and love.mouse.isDown(1) then
        local ax = esx + 1.5*scroll:getWidth() - mx
        self.effectsVolume = 1 - (ax/(1.5*scroll:getWidth()))
        click:setVolume(App.settings.effectsVolume)
    end
    
    love.graphics.draw(sc, esx + 1.45*scroll:getWidth()*self.effectsVolume, 3.25*App.height/5 - 30, 0, 1.5, 1.5)

    
    local hovered = false

        local btn = self.buttons[1]
        local bx = cx - 200 + 24
        local by = 4*App.height/5
        mouseOver = bx < mx and mx < bx + 360 and by < my and my < by + 105

        if mouseOver then
            love.graphics.draw(btn.image, cx, 4*App.height/5, 0, 1, 1, 0.5*btn.image:getWidth())
            hovered = true
            if App.isMouseDown(1) then
                btn.fn()
            end
        end

    if not hovered then
        love.graphics.draw(self.buttons[2].image, cx, 4*App.height/5, 0, 1, 1, 0.5*self.buttons[1].image:getWidth())
    end
end

return Settings
