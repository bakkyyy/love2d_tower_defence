local Summer = require 'summer'
local Winter = require 'winter'
local Enemy = require 'enemy'
local Tower = require 'tower'
local Bullet = require 'bullet'
local Utils = require 'utils'

local Map = Summer

GAME_STATE_PLAYING = 1
GAME_STATE_WIN = 2
GAME_STATE_LOSE = 4
GAME_STATE_PAUSED = 8

local Game = {
    tiles = Map.tiles,
    enemies = {},
    towers = {},
    bullets = {},
    timeNow = 0,
    timeLastSpawn = 0,
    wave = 1,
    subwave = 0,
    enemiesToSpawn = 0,
    spawnedAt = 0,
    selectedTower = 0,
    paused = false,
    win = false,
    lose = false,
    lives = 20,
    money = 72,
    night = os.time() % 2 == 0
}

function Game:load()
    musicwar:setLooping(true)
    musicwar:setVolume(0.1)
    musicwar:play()
end

function Game:towers_shot()
    for i,tower in pairs(self.towers) do
        if tower.target ~= nil then
            local dx = tower.target.position[1] - tower.position[1]
            local dy = tower.target.position[2] - tower.position[2]
            local ar = tower:getAttackRange()
            if tower.target.isDead or dx*dx+dy*dy > ar*ar then
                tower.target = nil
            end
        end

        if tower.target == nil then
            for j, enemy in pairs(self.enemies) do
                local dx = enemy.position[1] - tower.position[1]
                local dy = enemy.position[2] - tower.position[2]
                local ar = tower:getAttackRange()
                if dx*dx+dy*dy <= ar*ar and not enemy.isDead then
                    tower.target = enemy
                end
            end
        end

        if tower.target ~= nil then
            if self.timeNow - tower.lastShotAt > tower:getAttackSpeed() then
                tower.lastShotAt = self.timeNow
                local b = Bullet:new(tower, tower.target)
                table.insert(self.bullets, b.id, b)
                tower:shot()
            end
        end
    end

    for i,bullet in pairs(self.bullets) do
        local u = App.width/2
        local v = (App.height - #self.tiles*65) / 2

        local bx = u + (bullet.position[1] - bullet.position[2]) * 65
        local by = v + (bullet.position[1] + bullet.position[2] - 2) * 32

        love.graphics.draw(bullet:getImage(), bx, by, bullet.rotation)
    end
end

function Game:update(dt)
    if self.paused or self.win or self.lose then
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

    for i, bullet in pairs(self.bullets) do
        bullet:update(self, dt)
    end

    for i, enemy in pairs(self.enemies) do
        enemy:update(self, dt)
    end

    if self.lives == 0 then
        self.lose = true
        musicwar:stop()
        losesound:setVolume(1)
        losesound:setLooping(false)
        losesound:play()
    end

    if self.wave == #Map.waves and self.subwave == #wave and Utils.tableSize(self.enemies) == 0 and self.enemiesToSpawn == 0 then
        self.win = true
        musicwar:stop()
        winsound:setVolume(1)
        winsound:setLooping(false)
        winsound:play()
    end
end

function Game:draw_tiles(mx, my, x, y)
    local tile = self.tiles[y][x]
    if tile.rendered then
        return
    end

    local sx = tile.start[1]
    local sy = tile.start[2]

    if sy > 1 then
        self:draw_tiles(mx, my, sx, sy-1)
        if tile.mode == DRAW_MODE_2x2 or tile.mode == DRAW_MODE_2x1 then
            self:draw_tiles(mx, my, sx+1, sy-1)
        end
    end

    if sx > 1 then
        self:draw_tiles(mx, my, sx-1, sy)
        if tile.mode == DRAW_MODE_2x2 or tile.mode == DRAW_MODE_1x2 then
            self:draw_tiles(mx, my, sx-1, sy+1)
        end
    end

    local u = App.width/2
    local v = (App.height - #self.tiles*65) / 2

    if tile.mode == DRAW_MODE_1x1 then
        u = u + (sx - sy) * 65 - 130
        v = v + (sx + sy - 2) * 32 - 141
    end

    if tile.mode == DRAW_MODE_1x2 then
        u = u + (sx - sy) * 97 - 130
        v = v + (sx + sy - 2) * 32 - 125
    end

    if tile.mode == DRAW_MODE_2x1 then
        u = u + (sx - sy) * 97 - 97
        v = v + (sx + sy - 2) * 32 - 125
    end

    if tile.mode == DRAW_MODE_2x2 then
        u = u + (sx - sy) * 130 - 130
        v = v + (sx + sy - 4) * 65 - 111
    end

    local m = { mx, my }
    local a = { u+130, v+205 }
    local b = { u+195, v+173 }
    local c = { u+130, v+141 }
    local d = { u+65, v+173 }

    local color = {1, 1, 1}
    local colorHover = {0.7, 0.7, 0.7}
    if self.night then
        color = {0.7, 0.7, 0.7}
        colorHover = {1, 1, 1}
    end

    if tile.towerable and Utils.pointInRect(a, b, c, d, m) then
        love.graphics.setColor(colorHover)

        if self.selectedTower ~= 0 and App.isMouseDown(1) then
            if self.selectedTower > 0 and tile.tower == nil then
                local t = Tower:new(self.selectedTower, {x, y})
                table.insert(self.towers, t.id, t)
                tile.tower = t
                self.money = self.money - towerTypes[self.selectedTower].price
                self.selectedTower = 0
            elseif self.selectedTower < 0 and tile.tower ~= nil then
                Utils.removeByKey(self.towers, tile.tower.id)
                self.money = self.money + tile.tower:getRefund()
                tile.tower = nil
            end
        end
    end

    love.graphics.draw(tile.image, u, v)
    if tile.tower ~= nil then
        love.graphics.draw(tile.tower:getImage(), u, v - 16)
    end
    love.graphics.setColor(color)

    for i = tile.start[1],tile.stop[1] do
        for j = tile.start[2],tile.stop[2] do
            self.tiles[j][i].rendered = true
        end
    end
end

function Game:reset_tiles()
    for i, row in pairs(self.tiles) do
        for j, tile in pairs(row) do
            tile.rendered = false
        end
    end
end

function Game:draw_enemies()
    for i, enemy in pairs(self.enemies) do
        local image = enemy:getImage()
        local sx = enemy.position[1]
        local sy = enemy.position[2]
        local u = App.width/2
        local v = (App.height - #self.tiles*65) / 2
        u = u + (sx - sy) * 65 - image:getWidth()/2
        v = v + (sx + sy - 2) * 32 - 21
        love.graphics.draw(enemy:getImage(), u, v)
    end
end

function Game:draw_tools(mx, my)
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
            if App.isMouseDown(1) and not self.paused and not self.win and not self.lose and tool.price <= self.money then
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

function Game:draw_lose()
    local image = Utils.imageFromCache('assets/lose.png')
    love.graphics.draw(image, App.width/2, App.height/2, 0, 1, 1, image:getWidth()/2, image:getHeight()/2)
end

function Game:draw_results()
    local r, g, b, a = love.graphics.getColor()

    love.graphics.setColor({0, 0, 0, 0.7})
    love.graphics.rectangle('fill', 0, 0, App.width, App.height)

    love.graphics.setColor({1, 1, 1})
    if self.win then
        self:draw_win()
    elseif self.lose then
        self:draw_lose()
    end

    love.graphics.setColor({r, g, b, a})
end

function Game:draw_all(mx, my)
    if self.night then
        love.graphics.draw(nightGradient, 0, 0, 0, App.width, App.height)
    else
        love.graphics.draw(dayGradient, 0, 0, 0, App.width, App.height)
    end

    self:draw_tiles(mx, my, #self.tiles, #self.tiles)
    self:reset_tiles()

    self:draw_enemies()
    self:towers_shot()

    self:draw_tools(mx, my)
end

function Game:draw(mx, my)
    if self.paused or self.win or self.lose then
        blurEffect(function()
            self:draw_all(mx, my)
        end)
    else
        self:draw_all(mx, my)
    end

    if self.win or self.lose then
        self:draw_results()
    end
end

return Game
