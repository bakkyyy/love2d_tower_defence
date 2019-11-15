local Summer = require 'summer'
local Winter = require 'winter'
local Enemy = require 'enemy'
local Tower = require 'tower'
local Utils = require 'utils'

local Map = Summer

local Game = {
    screens = {},
    tiles = Map.tiles,
    enemies = {},
    towers = {},
    timeNow = 0,
    wave = 1,
    subwave = 0,
    enemiesToSpawn = 0,
    spawnedAt = 0,
    selectedTower = 0,
    paused = false,
    lives = 20,
    money = 100
}

function Game:load(screens)
    self.screens = screens
    mesh = Utils.gradientMesh("vertical", {0.160784, 0.501961, 0.72549, 1}, {0.427451, 0.835294, 0.980392, 1}, {1, 1, 1, 1})

    -- for i = 1,#self.tiles do
    --     for j, tile in ipairs(self.tiles[i]) do
    --         if tile.towerable then
    --             local t = Tower:new(2, {j, i})
    --             table.insert(self.towers, t)
    --             tile.tower = t
    --         end
    --     end
    -- end
end

function Game:towers_shot(ww, wh)
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
                if dx*dx+dy*dy <= ar*ar then
                    tower.target = enemy
                end
            end
        end

        if tower.target ~= nil then
            if self.timeNow - tower.lastShotAt > tower:getAttackSpeed() then
                tower.lastShotAt = self.timeNow
                local u = ww/2
            local v = (wh - #self.tiles*65) / 2

            local tx = u + (tower.position[1] - tower.position[2]) * 65
            local ty = v + (tower.position[1] + tower.position[2] - 2) * 32
            local cx = u + (tower.target.position[1] - tower.target.position[2]) * 65
            local cy = v + (tower.target.position[1] + tower.target.position[2] - 2) * 32

            love.graphics.line(tx, ty, cx, cy)
            tower:shot()
            end
        end
    end
end

function Game:update(dt)
    if self.paused then
        return
    end

    self.timeNow = self.timeNow + dt

    for i,part in pairs(Map.waves[self.wave]) do
        if part.time_offset < self.timeNow then
            if i > self.subwave then
                self.subwave = i
                self.enemiesToSpawn = part.count
                self.spawnedAt = 0
            end

            if self.timeNow - self.spawnedAt > 3 and self.enemiesToSpawn > 0 then
                local whichPath = (self.enemiesToSpawn % #Map.paths) + 1
                local e = Enemy:new('enemy_ufoPurple_E.png', Map.paths[whichPath], math.random(part.speed_range[1], part.speed_range[2]), part.reward)
                table.insert(self.enemies, e.id, e)
                self.spawnedAt = self.timeNow
                self.enemiesToSpawn = self.enemiesToSpawn - 1
            end
        end
    end

    if love.mouse.isDown(2) then
        self.selectedTower = 0
    end

    for i, enemy in pairs(self.enemies) do
        enemy:update(self, dt)
    end
end

function Game:draw_tiles(ww, wh, x, y)
    local tile = self.tiles[y][x]

    if tile.rendered then
        return
    end

    local sx = tile.start[1]
    local sy = tile.start[2]

    if sy > 1 then
        self:draw_tiles(ww, wh, sx, sy-1)
        if tile.mode == DRAW_MODE_2x2 or tile.mode == DRAW_MODE_2x1 then
            self:draw_tiles(ww, wh, sx+1, sy-1)
        end
    end

    if sx > 1 then
        self:draw_tiles(ww, wh, sx-1, sy)
        if tile.mode == DRAW_MODE_2x2 or tile.mode == DRAW_MODE_1x2 then
            self:draw_tiles(ww, wh, sx-1, sy+1)
        end
    end

    local u = ww/2
    local v = (wh - #self.tiles*65) / 2

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

    local mx, my = love.mouse.getPosition()

    local m = { mx, my }
    local a = { u+130, v+205 }
    local b = { u+195, v+173 }
    local c = { u+130, v+141 }
    local d = { u+65, v+173 }

    if tile.towerable and Utils.pointInRect(a, b, c, d, m) then
        love.graphics.setColor({0.8, 0.8, 0.8})

        if self.selectedTower ~= 0 and love.mouse.isDown(1) then
            if self.selectedTower > 0 and tile.tower == nil then
                local t = Tower:new(self.selectedTower, {x, y})
                table.insert(self.towers, t.id, t)
                tile.tower = t
                self.money = self.money - towerTypes[self.selectedTower].price
                self.selectedTower = 0
            elseif self.selectedTower < 0 and tile.tower ~= nil then
                Utils.removeByKey(self.towers, tile.tower.id)
                tile.tower = nil
            end
        end
    end

    love.graphics.draw(tile.image, u, v)
    if tile.tower ~= nil then
        love.graphics.draw(tile.tower:getImage(), u, v - 16)
    end
    love.graphics.setColor({1, 1, 1, 1})

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

function Game:draw_enemies(ww, wh)
    for i, enemy in pairs(self.enemies) do
        local sx = enemy.position[1]
        local sy = enemy.position[2]
        local u = ww/2
        local v = (wh - #self.tiles*65) / 2
        u = u + (sx - sy) * 65 - 130
        v = v + (sx + sy - 2) * 32 - 141
        love.graphics.draw(enemy.image, u, v)
    end
end

function Game:draw_tools(ww, wh)
    love.graphics.print(tostring(self.lives), font, 20, 30)

    love.graphics.print(tostring(self.money), font, 100, 30)

    local seconds_since_start = math.floor(self.timeNow)
    local minutes = math.floor(seconds_since_start / 60)
    local seconds = seconds_since_start % 60
    love.graphics.print(string.format('%02d:%02d', minutes, seconds), font, ww - 150, 30)

    local mx, my = love.mouse.getPosition()
    local minx = ww - 132
    local maxx = ww - 20

    local tools = {}
    table.insert(tools, -1, {
        image = Utils.imageFromCache('assets/actors/sell.png'),
        price = 0,
        min = {minx, wh - 20 - 78},
        max = {maxx, wh - 20}
    })
    table.insert(tools, 1, {
        image = Utils.imageFromCache('assets/actors/weapon_crystals_N.png'),
        price = towerTypes[1].price,
        min = {minx, wh - 20*4 - 96*3 - 96},
        max = {maxx, wh - 20*4 - 96*3}
    })
    table.insert(tools, 2, {
        image = Utils.imageFromCache('assets/actors/weapon_cannon_E.png'),
        price = towerTypes[2].price,
        min = {minx, wh - 20*3 - 96*2 - 96},
        max = {maxx, wh - 20*3 - 96*2}
    })
    table.insert(tools, 3, {
        image = Utils.imageFromCache('assets/actors/weapon_ballista_E.png'),
        price = towerTypes[3].price,
        min = {minx, wh - 20*2 - 96 - 78},
        max = {maxx, wh - 20*2 - 96}
    })

    for i, tool in pairs(tools) do
        if tool.price > self.money then
            love.graphics.setColor({1, 1, 1, 0.5})
        end

        if tool.min[1] <= mx and mx <= tool.max[1] and tool.min[2] <= my and my <= tool.max[2] then
            love.graphics.setColor({1, 1, 1})
            if love.mouse.isDown(1) and not self.paused and tool.price <= self.money then
                self.selectedTower = i
            end
        end
        love.graphics.draw(tool.image, minx - 74, tool.max[2] - 218)
        love.graphics.setColor({1, 1, 1})
    end

    if self.selectedTower ~= 0 then
        local ti = tools[self.selectedTower].image
        local tw = ti:getWidth()

        love.graphics.draw(ti, mx, my, 0, 1, 1, tw/2, 173)
    end
end

function Game:draw(ww, wh)
    love.graphics.draw(mesh, 0, 0, 0, ww, hh)

    self:draw_tiles(ww, wh, #self.tiles, #self.tiles)
    self:reset_tiles()

    self:draw_enemies(ww, wh)
    self:towers_shot(ww, wh)
    self:draw_tools(ww, wh)
    love.graphics.print(Utils.dump(self.enemies), 10, 10)
end

return Game
