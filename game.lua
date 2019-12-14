---
-- Класс Игры
-- @module Game

local json = require 'json'

local Winter = require 'winter'
local Summer = require 'summer'
local Enemy = require 'enemy'
local Tower = require 'tower'
local Bullet = require 'bullet'
local Utils = require 'utils'

GAME_STATE_PLAYING = 1
GAME_STATE_WIN = 2
GAME_STATE_LOSE = 4
GAME_STATE_PAUSED = 8
GAME_STATE_STOPPED = 16
GAME_STATE_SAVING = 32
GAME_STATE_SETTINGS = 64
GAME_STATE_OVERWRITE = 128

local Game = { state = GAME_STATE_STOPPED }


--- ставит игру на паузу
function Game:pause()
    if self.state == GAME_STATE_PLAYING then
        self.state = GAME_STATE_PAUSED
        musicwar:setVolume(0.5*App.settings.musicVolume)
        click:play()
    elseif self.state == GAME_STATE_PAUSED then
        self.state = GAME_STATE_PLAYING
        musicwar:setVolume(App.settings.musicVolume)
        click:play()
    end
end

--- сбрасывает состояние игры к начальному
function Game:reset()
    self.tiles = Utils.deepCopy(self.map.tiles)
    self.enemies = {}
    self.towers = {}
    self.bullets = {}
    self.buttons = {}
    self.timeNow = 0
    self.timeLastSpawn = 0
    self.enemiesToSpawn = 0
    self.spawnedAt = 0
    self.selectedTower = 0
    self.state = GAME_STATE_PLAYING
    self.wave = 1
    self.subwave = 0
    self.lives = 20
    self.money = 72
    self.night = os.time() % 2 == 0
end

--- сериализует состояние игры
-- @return таблица
function Game:serialize()
    local g = {
        mapType = self.mapType,
        enemies = {},
        towers = {},
        bullets = {},
        timeNow = self.timeNow,
        timeLastSpawn = self.timeLastSpawn,
        wave = self.wave,
        subwave = self.subwave,
        enemiesToSpawn = self.enemiesToSpawn,
        spawnedAt = self.spawnedAt,
        selectedTower = self.selectedTower,
        state = GAME_STATE_PAUSED,
        lives = self.lives,
        money = self.money,
        night = self.night,
        enemyId = Enemy.uniqueId,
        bulletId = Bullet.uniqueId,
        towerId = Tower.uniqueId
    }

    for id, enemy in pairs(self.enemies) do
        g.enemies[id] = enemy:serialize()
    end

    for id, bullet in pairs(self.bullets) do
        g.bullets[id] = bullet:serialize()
    end

    for id, tower in pairs(self.towers) do
        g.towers[id] = tower:serialize()
    end

    return g
end

--- сохраняет состояние игры в файл
function Game:saveToFile()
    local f = love.filesystem.newFile('save.ppg')
    f:open('w')
    f:write(json.encode(self:serialize()))
    f:close()
end

--- загружает состояние игры из файла
function Game:loadFromFile()
    local contents = love.filesystem.read('save.ppg')
    if contents == nil then
        return
    end

    local de = json.decode(contents)
    self.mapType = de.mapType
    self:loadMap()

    self.tiles = Utils.deepCopy(self.map.tiles)
    self.enemies = {}
    self.towers = {}
    self.bullets = {}
    self.timeNow = de.timeNow
    self.timeLastSpawn = de.timeLastSpawn
    self.enemiesToSpawn = de.enemiesToSpawn
    self.spawnedAt = de.spawnedAt
    self.selectedTower = de.selectedTower
    self.state = de.state
    self.wave = de.wave
    self.subwave = de.subwave
    self.lives = de.lives
    self.money = de.money
    self.night = de.night
    Enemy.uniqueId = de.enemyId
    Bullet.uniqueId = de.bulletId
    Tower.uniqueId = de.towerId

    for id,enemy in pairs(de.enemies) do
        self.enemies[id] = Enemy:deserialize(enemy)
    end

    for id,tower in pairs(de.towers) do
        local t = Tower:deserialize(tower)
        self.towers[id] = t
        local x = t.position[1]
        local y = t.position[2]
        self.tiles[y][x].tower = t
    end

    for id,bullet in pairs(de.bullets) do
        self.bullets[id] = Bullet:deserialize(bullet)
    end
end

--- загружает выбранную карту
function Game:loadMap()
    if self.mapType == 1 then
        self.map = Summer
    else
        self.map = Winter
    end
end

--- загружает необходимые файлы для сцены игры
function Game:load()
    self:loadMap()
    self:reset()

    musicwar:setLooping(true)
    musicwar:setVolume(App.settings.musicVolume)
    musicwar:play()

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/pause_continue_hover.png'), fn = function()
        App.game:pause()
    end })

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/pause_reset_hover.png'), fn = function()
        click:play()
        App.changeScreen('game')
    end })

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/pause_settings_hover.png'), fn = function()
        click:play()
        self.state = GAME_STATE_SETTINGS
    end })

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/pause_exit_hover.png'), fn = function()
        click:play()
        self.state = GAME_STATE_SAVING
    end })

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/pause.png'), fn = nil })
    --для настроек паузы

    mc = Utils.imageFromCache('assets/menu/scroll.png')
    ec = Utils.imageFromCache('assets/menu/scroll.png')

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/pause_settings_back.png'), fn = function()
        click:play()
        self.state = GAME_STATE_PAUSED
    end })

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/pause_settings.png'), fn = nil })

    --для сохранения

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/savegame_yes.png'), fn = function()
        click:play()
        if Utils.fileExists('save.ppg') then
            self.state = GAME_STATE_OVERWRITE
        else
            self:saveToFile()
            musicwar:stop()
            App.changeScreen('menu')
            music:play()
        end
    end })

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/savegame_no.png'), fn = function()
        musicwar:stop()
        App.changeScreen('menu')
        music:play()
    end })

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/savegame.png'), fn = nil })
    --для перезаписи

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/savegame_overwrite_yes.png'), fn = function()
        click:play()
        self:saveToFile()
        musicwar:stop()
        App.changeScreen('menu')
        music:play()
    end })

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/savegame_overwrite_no.png'), fn = function()
        musicwar:stop()
        App.changeScreen('menu')
        music:play()
    end })

    table.insert(self.buttons, {image = Utils.imageFromCache('assets/menu/savegame_overwrite.png'), fn = nil })
end


--- жизненный цикл игры
-- @param dt время, прошедшее с прошлого обновления
function Game:update(dt)
    if self.state ~= GAME_STATE_PLAYING then
        return
    end

    self.timeNow = self.timeNow + dt

    local wave = self.map.waves[self.wave]
    local subwave = wave[self.subwave]

    if self.enemiesToSpawn == 0 then
        if self.subwave < #wave then
            self.subwave = self.subwave + 1
            self.enemiesToSpawn = wave[self.subwave].count
        elseif self.wave < #self.map.waves then
            self.wave = self.wave + 1
            wave = self.map.waves[self.wave]
            self.timeSinceWaveChange = 0
            self.subwave = 1
            self.enemiesToSpawn = wave[self.subwave].count
        end
    end

    subwave = wave[self.subwave]

    if self.timeNow - self.spawnedAt > subwave.spawnInterval and self.enemiesToSpawn > 0 then
        local whichPath = (Enemy.uniqueId % #self.map.paths) + 1
        local e = Enemy:new(subwave.type, whichPath, subwave.speed, subwave.reward, subwave.health)
        self.enemies[e.id] = e
        self.spawnedAt = self.timeNow
        self.enemiesToSpawn = self.enemiesToSpawn - 1
    end

    if self.enemiesToSpawn == 0 then
        self.timeLastSpawn = self.timeNow
    end

    if App.isMouseDown(2) then
        self.selectedTower = 0
    end

    for i,enemy in pairs(self.enemies) do
        enemy:update(self, dt)
    end

    for i,tower in pairs(self.towers) do
        tower:update(self, dt)
    end

    if self.lives == 0 then
        self.state = GAME_STATE_LOSE
        musicwar:stop()
        losesound:setVolume(App.settings.effectsVolume)
        losesound:setLooping(false)
        losesound:play()
    end

    if self.wave == #self.map.waves and self.subwave == #wave and Utils.tableSize(self.enemies) == 0 and self.enemiesToSpawn == 0 then
        self.state = GAME_STATE_WIN
        musicwar:stop()
        winsound:setVolume(App.settings.effectsVolume)
        winsound:setLooping(false)
        winsound:play()
    end
end

--- отрисовывает тайлы
-- @param mx координата x мыши
-- @param my координата y мыши
function Game:drawTiles(mx, my)
    local color = {1, 1, 1}
    local colorHover = {0.7, 0.7, 0.7}
    if self.night then
        color = {0.7, 0.7, 0.7}
        colorHover = {1, 1, 1}
    end

    for k = 0,23 do
        for j = 0,k do
            local i = k - j
            if i < 12 and j < 12 then
                local tile = self.tiles[i+1][j+1]
                local u = App.width/2
                local v = App.height/2 - 6*65
                u = u + (j - i) * 65 - 130
                v = v + (j + i) * 32 - 141

                local cursor = { mx, my }
                local bottom = { u+130, v+205 }
                local right = { u+195, v+173 }
                local top = { u+130, v+141 }
                local left = { u+65, v+173 }

                if tile.towerable and Utils.pointInRect(top, right, bottom, left, cursor) and self.state == GAME_STATE_PLAYING then
                    love.graphics.setColor(colorHover)

                    if App.isMouseDown(1) then
                        if self.selectedTower > 0 and tile.tower == nil then
                            local t = Tower:new(self.selectedTower, {j+1, i+1})
                            self.towers[t.id] = t
                            tile.tower = t
                            self.money = self.money - towerTypes[self.selectedTower].price
                            self.selectedTower = 0
                        elseif self.selectedTower < 0 and tile.tower ~= nil then
                            Utils.removeByKey(self.towers, tile.tower.id)
                            self.money = self.money + tile.tower:getRefundAmount()
                            tile.tower = nil
                        end
                    end
                end

                love.graphics.draw(tile:getImage(), u, v)
                love.graphics.setColor(color)

                for _, enemy in pairs(self.enemies) do
                    local x = enemy.position[1]
                    local y = enemy.position[2]
                    if i < y and y <= i+1 and j < x and x <= j+1 then
                        local image = enemy:getImage()
                        local u = App.width/2 + (x - y) * 65 - image:getWidth()/2
                        local v = App.height/2 - 6*65 + (x + y - 2) * 32 - 21
                        love.graphics.draw(enemy:getImage(), u, v)
                    end
                end

                if tile.tower ~= nil then
                    tile.tower:draw(self, u, v)
                end
                tile.rendered = true
            end
        end
    end
end

--- сбрасывает состояние тайлов
function Game:resetTiles()
    for i, row in pairs(self.tiles) do
        for j, tile in pairs(row) do
            tile.rendered = false
        end
    end
end

--- отрисовывает интерфейс игры
-- @param mx координата x мыши
-- @param my координата y мыши
function Game:drawHUD(mx, my)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor({1, 1, 1})

    local livesString = tostring(self.lives)
    local livesWidth = font:getWidth(livesString)
    love.graphics.draw(Utils.imageFromCache('assets/hp.png'), 40, 30)
    love.graphics.print(livesString, font, 40 + 40 + 20, 25)

    local moneyString = tostring(self.money)
    love.graphics.draw(Utils.imageFromCache('assets/money.png'), 40 + 40 + 20 + livesWidth + 20, 30)
    love.graphics.print(moneyString, font, 40 + 40 + 20 + livesWidth + 40 + 20 + 20, 25)

    love.graphics.print('Волна ' .. tostring(self.wave) .. '/' .. tostring(#self.map.waves), font, 40, App.height - 40 - 64)

    local seconds_since_start = math.floor(self.timeNow)
    local minutes = math.floor(seconds_since_start / 60)
    local seconds = seconds_since_start % 60
    love.graphics.print(string.format('%02d:%02d', minutes, seconds), font, App.width - 150, 30)

    local toolOffset = 20
    local toolSize = 112
    local maxx = App.width - 40
    local miny = App.height - 20 - 112
    local maxy = App.height - 20

    local tools = {}
    table.insert(tools, -1, {
        image = Utils.imageFromCache('assets/actors/sell.png'),
        price = 0,
        min = {maxx - toolSize, miny},
        max = {maxx, maxy}
    })
    table.insert(tools, 1, {
        image = Utils.imageFromCache('assets/actors/weapon_crystals_N.png'),
        price = towerTypes[1].price,
        min = {maxx - toolSize*4 - toolOffset*3, miny},
        max = {maxx - toolSize*3 - toolOffset*3, maxy}
    })
    table.insert(tools, 2, {
        image = Utils.imageFromCache('assets/actors/weapon_cannon_E.png'),
        price = towerTypes[2].price,
        min = {maxx - toolSize*3 - toolOffset*2, miny},
        max = {maxx - toolSize*2 - toolOffset*2, maxy}
    })
    table.insert(tools, 3, {
        image = Utils.imageFromCache('assets/actors/weapon_ballista_E.png'),
        price = towerTypes[3].price,
        min = {maxx - toolSize*2 - toolOffset, miny},
        max = {maxx - toolSize - toolOffset, maxy}
    })

    for i, tool in pairs(tools) do
        if tool.price > self.money then
            love.graphics.setColor({1, 1, 1, 0.5})
        end

        local scale = 0.8
        if tool.min[1] <= mx and mx <= tool.max[1] and tool.min[2] <= my and my <= tool.max[2] then
            scale = 1
            if App.isMouseDown(1) and self.state == GAME_STATE_PLAYING and tool.price <= self.money then
                self.selectedTower = i
            end
        end
        love.graphics.draw(tool.image, tool.min[1] + 56, tool.max[2] - 56, 0, scale, scale, 130, 180)
        love.graphics.setColor({1, 1, 1})

        if tool.price > 0 then
            love.graphics.setColor({0.996078, 0.929412, 0.239216})
            local cx = font20:getWidth(tostring(tool.price)) / 2
            love.graphics.print(tostring(tool.price), font20, tool.min[1] + 56, tool.max[2]-15, 0, 1, 1, cx)
            love.graphics.setColor({1, 1, 1})
        end
    end

    if self.selectedTower ~= 0 then
        local ti = tools[self.selectedTower].image
        local tw = ti:getWidth()

        love.graphics.draw(ti, mx, my, 0, 1, 1, tw/2, 173)
    end

    love.graphics.setColor({r, g, b, a})
end

--- отрисовывает меню паузы
-- @param mx координата x мыши
-- @param my координата y мыши
function Game:drawPause(mx, my)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor({1, 1, 1})

    local cx = App.width / 2
    local cy = App.height / 2
    local cursorY = 0
    local hovered = false

    for i = 1,4 do
        local btn = self.buttons[i]
        local bx = cx - 195 + 24
        local by = cy - 192 + cursorY
        local mouseOver = bx < mx and mx < bx + 355 and by < my and my < by + 110

        if mouseOver then
            love.graphics.draw(btn.image, cx, cy, 0, 1, 1, 0.5*btn.image:getWidth(), 0.5*btn.image:getHeight())
            hovered = true
            if App.isMouseDown(1) then
                btn.fn()
            end
        end

        cursorY = cursorY + 110
    end

    if not hovered then
        love.graphics.draw(self.buttons[5].image, cx, cy, 0, 1, 1, 0.5*self.buttons[1].image:getWidth(), 0.5*self.buttons[1].image:getHeight())
    end

    love.graphics.setColor({r, g, b, a})
end

--- отрисовывает победу
function Game:drawWin()
    local image = Utils.imageFromCache('assets/win.png')
    love.graphics.draw(image, App.width/2, App.height/2, 0, 1, 1, image:getWidth()/2, image:getHeight()/2)
end

--- отрисовывает поражение
function Game:drawLose()
    local image = Utils.imageFromCache('assets/lose.png')
    love.graphics.draw(image, App.width/2, App.height/2, 0, 1, 1, image:getWidth()/2, image:getHeight()/2)
end

--- отрисовывает результаты
function Game:drawResults()
    local r, g, b, a = love.graphics.getColor()

    love.graphics.setColor({1, 1, 1})

    if self.state == GAME_STATE_WIN then
        self:drawWin()
    elseif self.state == GAME_STATE_LOSE then
        self:drawLose()
    end

    love.graphics.setColor({r, g, b, a})
end

--- отрисовывает настройки
-- @param mx координата x мыши
-- @param my координата y мыши
function Game:drawSettings(mx, my)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor({1, 1, 1})
    local cx = App.width / 2
    local cy = App.height / 2
    local hovered = false
    local bx = cx - 195 + 24
    local by = cy + 135
    local mouseOver = bx < mx and mx < bx + 355 and by < my and my < by + 110

    if mouseOver then
        love.graphics.draw(self.buttons[6].image, cx, cy, 0, 1, 1, 0.5*self.buttons[1].image:getWidth(), 0.5*self.buttons[1].image:getHeight())
        hovered = true
        if App.isMouseDown(1) then
            self.buttons[6].fn()
        end
    end

    if not hovered then
        love.graphics.draw(self.buttons[7].image, cx, cy, 0, 1, 1, 0.5*self.buttons[1].image:getWidth(), 0.5*self.buttons[1].image:getHeight())
    end

    local hovered = false
    local msx = cx - 135
    local msy = cy - 80
    local mouseOver = msx - 10 < mx and mx < msx + 290 + 10 and msy < my and my < msy + 20
    if mouseOver and love.mouse.isDown(1) then
        local ox = msx + 290 - mx
        App.settings.musicVolume = 1 - (ox/(290))
        if App.settings.musicVolume < 0.001 then App.settings.musicVolume = 0
        elseif App.settings.musicVolume > 0.99 then App.settings.musicVolume = 1
        end
        music:setVolume(App.settings.musicVolume)
        musicwar:setVolume(App.settings.musicVolume)
    end
    love.graphics.draw(mc, msx + (App.settings.musicVolume*290*0.98), msy - 12, 0)

    local esx = cx - 135
    local esy = cy + 72
    local mouseOver = esx - 10 < mx and mx < esx + 290 + 10 and esy < my and my < esy + 20
    if mouseOver and love.mouse.isDown(1) then
        local ax = esx + 290 - mx
        App.settings.effectsVolume = 1 - (ax/(290))
        if App.settings.effectsVolume < 0.001 then App.settings.effectsVolume = 0
        elseif App.settings.effectsVolume > 0.99 then App.settings.effectsVolume = 1
        end
        click:setVolume(App.settings.effectsVolume)
        build:setVolume(App.settings.effectsVolume)
    end

    love.graphics.draw(ec, esx + (App.settings.effectsVolume*290*0.98), esy - 12, 0)

    love.graphics.setColor({r, g, b, a})
end

--- отрисовывает сохранение
-- @param mx координата x мыши
-- @param my координата y мыши
function Game:drawSaving(mx, my)
    local r, g, b, a = love.graphics.getColor()

    love.graphics.setColor({1, 1, 1})

    local cx = App.width / 2
    local cy = App.height / 2
    local hovered = false
    local bx1 = cx - 250
    local by1 = cy + 50
    local bx2 = cx + 50
    local by2 = cy + 50

    mouseOver1 = bx1 < mx and mx < bx1 + 206 and by1 < my and my < by1 + 86
    mouseOver2 = bx2 < mx and mx < bx2 + 206 and by2 < my and my < by2 + 86

    if mouseOver1 then
        love.graphics.draw(self.buttons[8].image, cx, cy - 175, 0, 1, 1, 0.5*self.buttons[8].image:getWidth())
        hovered = true
        if App.isMouseDown(1) then
            self.buttons[8].fn()
        end
    end

    if mouseOver2 then
        love.graphics.draw(self.buttons[9].image, cx, cy - 175, 0, 1, 1, 0.5*self.buttons[8].image:getWidth())
        hovered = true
        if App.isMouseDown(1) then
            self.buttons[9].fn()
        end
    end

    if not hovered then
        love.graphics.draw(self.buttons[10].image, cx, cy - 175, 0, 1, 1, 0.5*self.buttons[8].image:getWidth())
    end

    love.graphics.setColor({r, g, b, a})
end

--- отрисовывает перезапись
-- @param mx координата x мыши
-- @param my координата y мыши
function Game:drawOverWr(mx, my)
    local r, g, b, a = love.graphics.getColor()

    love.graphics.setColor({1, 1, 1})

    local cx = App.width / 2
    local cy = App.height / 2
    local hovered = false
    local bx1 = cx - 250
    local by1 = cy + 50
    local bx2 = cx + 50
    local by2 = cy + 50

    mouseOver1 = bx1 < mx and mx < bx1 + 206 and by1 < my and my < by1 + 86
    mouseOver2 = bx2 < mx and mx < bx2 + 206 and by2 < my and my < by2 + 86

    if mouseOver1 then
        love.graphics.draw(self.buttons[11].image, cx, cy - 175, 0, 1, 1, 0.5*self.buttons[11].image:getWidth())
        hovered = true
        if App.isMouseDown(1) then
            self.buttons[11].fn()
        end
    end

    if mouseOver2 then
        love.graphics.draw(self.buttons[12].image, cx, cy - 175, 0, 1, 1, 0.5*self.buttons[11].image:getWidth())
        hovered = true
        if App.isMouseDown(1) then
            self.buttons[12].fn()
        end
    end

    if not hovered then
        love.graphics.draw(self.buttons[13].image, cx, cy - 175, 0, 1, 1, 0.5*self.buttons[11].image:getWidth())
    end

    love.graphics.setColor({r, g, b, a})
end

--- отрисовывает игру
-- @param mx координата x мыши
-- @param my координата y мыши
function Game:draw(mx, my)
    if self.night then
        love.graphics.draw(nightGradient, 0, 0, 0, App.width, App.height)
    else
        love.graphics.draw(dayGradient, 0, 0, 0, App.width, App.height)
    end

    self:drawTiles(mx, my)
    self:resetTiles()
    self:drawHUD(mx, my)

    if self.state == GAME_STATE_PAUSED then
        self:drawPause(mx, my)
    end

    if self.state == GAME_STATE_SAVING then
        self:drawSaving(mx, my)
    end

    if self.state == GAME_STATE_OVERWRITE then
        self:drawOverWr(mx, my)
    end

    if self.state == GAME_STATE_SETTINGS then
        self:drawSettings(mx, my)
    end

    if self.state == GAME_STATE_WIN or self.state == GAME_STATE_LOSE then
        self:drawResults()
    end
end

return Game
