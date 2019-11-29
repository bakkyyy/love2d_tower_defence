local Summer = require 'summer'
local Winter = require 'winter'
local Enemy = require 'enemy'
local Tower = require 'tower'
local Bullet = require 'bullet'
local Utils = require 'utils'

local Map = nil

GAME_STATE_PLAYING = 1
GAME_STATE_WIN = 2
GAME_STATE_LOSE = 4
GAME_STATE_PAUSED = 8
GAME_STATE_STOPPED = 16

local Game = { state = GAME_STATE_STOPPED }

function Game:pause()
    if self.state == GAME_STATE_PLAYING then
        self.state = GAME_STATE_PAUSED
        --self:draw_pause() надо отрисовать
    elseif self.state == GAME_STATE_PAUSED then
        self.state = GAME_STATE_PLAYING
    end
end

function Game:reset()
    self.tiles = Map.tiles
    self.enemies = {}
    self.towers = {}
    self.bullets = {}
    self.timeNow = 0
    self.timeLastSpawn = 0
    self.wave = 1
    self.subwave = 0
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

function Game:load()
    Map = App.newgame.mapType
    self:reset()
    musicwar:setLooping(true)
    musicwar:setVolume(App.settings.musicVolume)
    musicwar:play()
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/pause/pause2.png"), fn = function()
        App.game:pause()
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/pause/pause3.png"), fn = function()
        App.changeScreen('game')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/pause/pause4.png"), fn = function()
        App.changeScreen('settings')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/pause/pause5.png"), fn = function()
        musicwar:stop()
        App.changeScreen('savegame')
    end })
    table.insert(self.buttons, {image = Utils.imageFromCache("assets/pause/pause.png"), fn = nil })
end

function Game:update(dt)
    if self.state ~= GAME_STATE_PLAYING then
        return
    end

    self.timeNow = self.timeNow + dt

    local wave = Map.waves[self.wave]
    local subwave = wave[self.subwave]

    if self.enemiesToSpawn == 0 then
        if self.subwave < #wave then
            self.subwave = self.subwave + 1
            self.enemiesToSpawn = wave[self.subwave].count
        elseif self.wave < #Map.waves then
            self.wave = self.wave + 1
            wave = Map.waves[self.wave]
            self.timeSinceWaveChange = 0
            self.subwave = 1
            self.enemiesToSpawn = wave[self.subwave].count
        end
    end

    subwave = wave[self.subwave]

    if self.timeNow - self.spawnedAt > subwave.spawnInterval and self.enemiesToSpawn > 0 then
        local whichPath = (self.enemiesToSpawn % #Map.paths) + 1
        local e = Enemy:new(subwave.type, Map.paths[whichPath], subwave.speed, subwave.reward, subwave.health)
        table.insert(self.enemies, e.id, e)
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

    if self.wave == #Map.waves and self.subwave == #wave and Utils.tableSize(self.enemies) == 0 and self.enemiesToSpawn == 0 then
        self.state = GAME_STATE_WIN
        musicwar:stop()
        winsound:setVolume(App.settings.effectsVolume)
        winsound:setLooping(false)
        winsound:play()
    end
end

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

                if tile.towerable and Utils.pointInRect(top, right, bottom, left, cursor) then
                    love.graphics.setColor(colorHover)

                    if App.isMouseDown(1) then
                        if self.selectedTower > 0 and tile.tower == nil then
                            local t = Tower:new(self.selectedTower, {j+1, i+1})
                            table.insert(self.towers, t.id, t)
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

                love.graphics.draw(tile.image, u, v)
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

function Game:resetTiles()
    for i, row in pairs(self.tiles) do
        for j, tile in pairs(row) do
            tile.rendered = false
        end
    end
end

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

    love.graphics.print('Волна ' .. tostring(self.wave) .. '/' .. tostring(#Map.waves), font, 40, App.height - 40 - 64)

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

        -- love.graphics.rectangle('line', tool.min[1], tool.min[2], tool.max[1] - tool.min[1], tool.max[1] - tool.min[1])
    end

    if self.selectedTower ~= 0 then
        local ti = tools[self.selectedTower].image
        local tw = ti:getWidth()

        love.graphics.draw(ti, mx, my, 0, 1, 1, tw/2, 173)
    end

    love.graphics.setColor({r, g, b, a})
end

function Game:draw_win()
    local image = Utils.imageFromCache('assets/win.png')
    love.graphics.draw(image, App.width/2, App.height/2, 0, 1, 1, image:getWidth()/2, image:getHeight()/2)
end

function Game:draw_pause(mx, my)
    --local cx = App.width / 2
    --local cy = App.height / 2
    --local cursorY = 0
    --local hovered = false

    --for i = 1,4 do
        --local btn = self.buttons[i]
        --local bx = cx - 200 + 24
        --local by = 2*App.height/5 + cursorY
        --local mouseOver = bx < mx and mx < bx + 360 and by < my and my < by + 105    тут крашится

        --if mouseOver then
            --love.graphics.draw(btn.image, cx, 2*App.height/5, 0, 1, 1, 0.5*btn.image:getWidth())
            --hovered = true
            --if App.isMouseDown(1) then
                --btn.fn()
            --end
        --end

        --cursorY = cursorY + 147
    --end

    --if not hovered then
        --love.graphics.draw(self.buttons[5].image, cx, 2*App.height/5, 0, 1, 1, 0.5*self.buttons[1].image:getWidth())
    --end
end

function Game:draw_lose()
    local image = Utils.imageFromCache('assets/lose.png')
    love.graphics.draw(image, App.width/2, App.height/2, 0, 1, 1, image:getWidth()/2, image:getHeight()/2)
end

function Game:draw_results()
    local r, g, b, a = love.graphics.getColor()

    love.graphics.setColor({1, 1, 1})
    if self.state == GAME_STATE_WIN then
        self:draw_win()
    elseif self.state == GAME_STATE_LOSE then
        self:draw_lose()
    end

    love.graphics.setColor({r, g, b, a})
end

function Game:drawAll(mx, my)
    if self.night then
        love.graphics.draw(nightGradient, 0, 0, 0, App.width, App.height)
    else
        love.graphics.draw(dayGradient, 0, 0, 0, App.width, App.height)
    end

    self:drawTiles(mx, my)
    self:resetTiles()
    self:drawHUD(mx, my)
end

function Game:draw(mx, my)
    if self.state ~= GAME_STATE_PLAYING then
        blurEffect(function()
            self:drawAll(mx, my)
        end)
    else
        self:drawAll(mx, my)
    end

    if self.state == GAME_STATE_WIN or self.state == GAME_STATE_LOSE then
        self:draw_results()
    end
end

return Game
