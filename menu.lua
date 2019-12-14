---
-- Класс Меню
-- @module Menu

local Utils = require 'utils'

MENU_STATE_MAIN = 1
MENU_STATE_NEWGAME = 6
MENU_STATE_LOADGAME = 10
MENU_STATE_SETTINGS = 12

local Menu = { state = MENU_STATE_MAIN }

--- подгружает ресурсы, необходимые для меню
function Menu:load()
    logo = Utils.imageFromCache('assets/logo.png')

    self.buttons = {
        {image = 'menu.png', fn = nil},
        {image = 'menu_new_game.png', fn = function()
            self.state = MENU_STATE_NEWGAME
        end},
        {image = 'menu_load_game.png', fn = function()
            self.state = MENU_STATE_LOADGAME
        end},
        {image = 'menu_settings.png', fn = function()
            self.state = MENU_STATE_SETTINGS
        end},
        {image = 'menu_exit.png', fn = function()
            love.audio.stop()
            love.window.close()
        end},
        {image = 'newgame.png', fn = nil},
        {image = 'newgame_left.png', fn = function()
            App.game.mapType = 1
            App.changeScreen('game')
            self.state = MENU_STATE_MAIN
            music:stop()
        end},
        {image = 'newgame_right.png', fn = function()
            App.game.mapType = 2
            App.changeScreen('game')
            self.state = MENU_STATE_MAIN
            music:stop()
        end},
        {image = 'newgame_back.png', fn = function()
            self.state = MENU_STATE_MAIN
        end},
        {image = 'file_not_found.png', fn = function()

        end},
        {image = 'file_not_found_hover.png', fn = function()
            self.state = MENU_STATE_MAIN
        end},
        {image = 'back.png', fn = function()

        end},
        {image = 'back_hover.png', fn = function()
            self.state = MENU_STATE_MAIN
        end}
    }
end

--- жизненный цикл меню
-- @param dt время, прошедшее с прошлого обновления
function Menu:update(dt)

end

--- отрисовывает главное меню
-- @param mx координата x мыши
-- @param my координата y мыши
function Menu:drawMain(mx, my)
    local cx = App.width / 2
    local cy = App.height / 2

    local image = Utils.imageFromCache('assets/menu/' .. self.buttons[self.state].image)
    love.graphics.draw(image, cx, 2*App.height/5, 0, 1, 1, image:getWidth()/2)

    local cursorY = 0

    for i = 1,4 do
        local btn = self.buttons[self.state + i]
        local bx = cx - 200 + 24
        local by = 2*App.height/5 + cursorY
        local mouseOver = bx < mx and mx < bx + 360 and by < my and my < by + 105

        if mouseOver then
            love.graphics.draw(Utils.imageFromCache('assets/menu/' .. btn.image), cx, 2*App.height/5, 0, 1, 1, image:getWidth()/2)
            if App.isMouseDown(1) then
                btn.fn()
            end
        end

        cursorY = cursorY + 147
    end
end

--- отрисовывает меню новая игра
-- @param mx координата x мыши
-- @param my координата y мыши
function Menu:drawNewGame(mx, my)
    local cx = App.width / 2
    local cy = App.height / 2

    local image = Utils.imageFromCache('assets/menu/' .. self.buttons[self.state].image)
    love.graphics.draw(image, cx, cy - 175, 0, 1, 1, image:getWidth()/2)

    local bx1 = cx - 400
    local by1 = cy - 40
    local bx2 = cx + 15
    local by2 = cy - 40
    local bx3 = cx - 200 + 24
    local by3 = cy + 205

    local mouseOver1 = bx1 < mx and mx < bx1 + 385 and by1 < my and my < by1 + 215
    local mouseOver2 = bx2 < mx and mx < bx2 + 385 and by2 < my and my < by2 + 215
    local mouseOver3 = bx3 < mx and mx < bx3 + 360 and by3 < my and my < by3 + 100

    if mouseOver1 then
        local image = Utils.imageFromCache('assets/menu/' .. self.buttons[self.state + 1].image)
        love.graphics.draw(image, cx, cy - 175, 0, 1, 1, image:getWidth()/2)
        if App.isMouseDown(1) then
            self.buttons[self.state + 1].fn()
        end
    end

    if mouseOver2 then
        local image = Utils.imageFromCache('assets/menu/' .. self.buttons[self.state + 2].image)
        love.graphics.draw(image, cx, cy - 175, 0, 1, 1, image:getWidth()/2)
        if App.isMouseDown(1) then
            self.buttons[self.state + 2].fn()
        end
    end

    if mouseOver3 then
        local image = Utils.imageFromCache('assets/menu/' .. self.buttons[self.state + 3].image)
        love.graphics.draw(image, cx, cy - 175, 0, 1, 1, image:getWidth()/2)
        if App.isMouseDown(1) then
            self.buttons[self.state + 3].fn()
        end
    end
end

--- отрисовывает меню загрузить игру
-- @param mx координата x мыши
-- @param my координата y мыши
function Menu:drawLoadGame(mx, my)
    if Utils.fileExists('save.ppg') then
        music:stop()
        App.changeScreen('game')
        App.game:loadFromFile()
        self.state = MENU_STATE_MAIN
    else
        local cx = App.width / 2
        local cy = App.height / 2

        local image = Utils.imageFromCache('assets/menu/' .. self.buttons[self.state].image)
        love.graphics.draw(image, cx, cy - 150, 0, 1, 1, image:getWidth()/2)

        local bx = cx - 180
        local by = cy + 60
        local mouseOver = bx < mx and mx < bx + 350 and by < my and my < by + 105

        if mouseOver then
            local image = Utils.imageFromCache('assets/menu/' .. self.buttons[self.state + 1].image)
            love.graphics.draw(image, cx, cy - 150, 0, 1, 1, image:getWidth()/2)
            if App.isMouseDown(1) then
                self.buttons[self.state + 1].fn()
                self.state = MENU_STATE_MAIN
            end
        end
    end
end

--- отрисовывает меню настройки
-- @param mx координата x мыши
-- @param my координата y мыши
function Menu:drawSettings(mx, my)
    local cx = App.width / 2
    local cy = App.height / 2

    local musicWidth = font:getWidth('МУЗЫКА')
    local effectsWidth = font:getWidth('ЭФФЕКТЫ')

    local scroll = Utils.imageFromCache('assets/menu/scroll.png')
    local scrollArea = Utils.imageFromCache('assets/menu/scroll_area.png')

    love.graphics.print('МУЗЫКА', font, cx - musicWidth/2, 1.75*App.height/5)
    love.graphics.draw(scrollArea, cx, 2.25*App.height/5, 0, 1.5, 1.5, scrollArea:getWidth()/2, scrollArea:getHeight()/2)

    local msx = cx - 0.75*scrollArea:getWidth()
    local msy = 2.25*App.height/5 - 12
    local mouseOver = msx < mx and mx < msx + 1.5*scrollArea:getWidth() and msy < my and my < msy + 1.5*scrollArea:getHeight()
    if mouseOver and love.mouse.isDown(1) then
        local ox = msx + 1.5*scrollArea:getWidth() - mx
        App.settings.musicVolume = 1 - (ox/(1.5*scrollArea:getWidth()))
        if App.settings.musicVolume < 0.001 then
            App.settings.musicVolume = 0
        elseif App.settings.musicVolume > 0.99 then
            App.settings.musicVolume = 1
        end
        music:setVolume(App.settings.musicVolume)
    end
    love.graphics.draw(scroll, msx + 1.45*scrollArea:getWidth()*App.settings.musicVolume, 2.25*App.height/5 - 30, 0, 1.5, 1.5, scroll:getWidth()/7)

    love.graphics.print('ЭФФЕКТЫ', font, cx - effectsWidth/2, 2.75*App.height/5)
    love.graphics.draw(scrollArea, cx, 3.25*App.height/5, 0, 1.5, 1.5, scrollArea:getWidth()/2, scrollArea:getHeight()/2)

    local esx = cx - 0.75*scrollArea:getWidth()
    local esy = 3.25*App.height/5 -12
    local mouseOver = esx - 10 < mx and mx < esx + 1.5*scrollArea:getWidth() + 10 and esy < my and my < esy + 1.5*scrollArea:getHeight()
    if mouseOver and love.mouse.isDown(1) then
        local ax = esx + 1.5*scrollArea:getWidth() - mx
        App.settings.effectsVolume = 1 - ax/(1.5*scrollArea:getWidth())
        if App.settings.effectsVolume < 0.001 then
            App.settings.effectsVolume = 0
        elseif App.settings.effectsVolume > 0.99 then
            App.settings.effectsVolume = 1
        end
        click:setVolume(App.settings.effectsVolume)
        build:setVolume(App.settings.effectsVolume)
    end

    love.graphics.draw(scroll, esx + 1.45*scrollArea:getWidth()*App.settings.effectsVolume, 3.25*App.height/5 - 30, 0, 1.5, 1.5, scroll:getWidth()/7)

    local bx = cx - 200 + 24
    local by = 4*App.height/5

    mouseOver = bx < mx and mx < bx + 360 and by < my and my < by + 105

    if mouseOver then
        local image = Utils.imageFromCache('assets/menu/' .. self.buttons[self.state + 1].image)
        love.graphics.draw(image, cx, 4*App.height/5, 0, 1, 1, image:getWidth()/2)
        if App.isMouseDown(1) then
            self.buttons[self.state+1].fn()
        end
    else
        local image = Utils.imageFromCache('assets/menu/' .. self.buttons[self.state].image)
        love.graphics.draw(image, cx, 4*App.height/5, 0, 1, 1, image:getWidth()/2)
    end
end

--- отрисовывает меню в соответствии с текущим состоянием
-- @param mx координата x мыши
-- @param my координата y мыши
function Menu:draw(mx, my)
    love.graphics.setColor({1, 1, 1})
    love.graphics.draw(dayGradient, 0, 0, 0, App.width, App.height)

    local cx = App.width / 2
    local cy = App.height / 2

    love.graphics.draw(logo, cx, App.height/5, 0, 1.5*cx/logo:getWidth(), 1.5*cx/logo:getWidth(), logo:getWidth()/2, logo:getHeight()/2)

    if self.state == MENU_STATE_MAIN then
        self:drawMain(mx, my)
    elseif self.state == MENU_STATE_NEWGAME then
        self:drawNewGame(mx, my)
    elseif self.state == MENU_STATE_LOADGAME then
        self:drawLoadGame(mx, my)
    elseif self.state == MENU_STATE_SETTINGS then
        self:drawSettings(mx, my)
    end
end

return Menu
