local Summer = require 'summer'
local Winter = require 'winter'
local Enemy = require 'enemy'
local Tower = require 'tower'
local Utils = require 'utils'

local Map = Winter

local Game = { screens = {}, tiles = Map.tiles, ufos = {}, towers = {}, time_since_start = 0, wave = 1, left_to_spawn = 0, last_spawn_at = 0, wave_part = 0, selectedTower = 0}
local score = 2

function Game:load(screens)
    self.screens = screens
    mesh = Utils.gradientMesh("vertical", {0.160784, 0.501961, 0.72549, 1}, {0.427451, 0.835294, 0.980392, 1}, {1, 1, 1, 1})
end

function Game:move_ufos(dt)
    for i, ufo in ipairs(self.ufos) do
        -- local ufo = self.ufos[i]
        local path = Map.paths[(i % #Map.paths) + 1]
        if ufo.pos_index >= #path then
            score = score - 1
            Utils.removeIndex(self.ufos, i)
            -- if #self.ufos == 0 then
            --     self.wave = self.wave + 1
            -- end
        else
            local prev_pos = path[ufo.pos_index]
            local next_pos = path[ufo.pos_index+1]
            local reached = false

            if prev_pos[1] < next_pos[1] then
                ufo.pos[1] = ufo.pos[1] + ufo.speed*dt
                if ufo.pos[1] > next_pos[1] then
                    reached = true
                end
            elseif prev_pos[1] > next_pos[1] then
                ufo.pos[1] = ufo.pos[1] - ufo.speed*dt
                if ufo.pos[1] < next_pos[1] then
                    reached = true
                end
            elseif prev_pos[2] < next_pos[2] then
                ufo.pos[2] = ufo.pos[2] + ufo.speed*dt
                if ufo.pos[2] > next_pos[2] then
                    reached = true
                end
            elseif prev_pos[2] > next_pos[2] then
                ufo.pos[2] = ufo.pos[2] - ufo.speed*dt
                if ufo.pos[2] < next_pos[2] then
                    reached = true
                end
            end

            if reached then
                ufo.pos_index = ufo.pos_index + 1
                ufo.pos = Utils.deepcopy(next_pos)
            end
        end
    end
end

function Game:update(dt)
    self.time_since_start = self.time_since_start + dt

    for i,part in ipairs(Map.waves[self.wave]) do
        if part.time_offset < self.time_since_start then
            if i > self.wave_part then
                self.wave_part = i
                self.left_to_spawn = part.count
                self.last_spawn_at = 0
            end

            if self.time_since_start - self.last_spawn_at > 2 and self.left_to_spawn > 0 then
                table.insert(self.ufos, Enemy:new('enemy_ufoPurple_E.png', Map.paths[1][1], math.random(part.speed_range[1], part.speed_range[2])))
                self.last_spawn_at = self.time_since_start
                self.left_to_spawn = self.left_to_spawn - 1
            end
        end
    end

    Game:move_ufos(dt)
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

        if self.selectedTower > 0 and love.mouse.isDown(1) then
            tile.tower = Tower:new(self.selectedTower)
            self.selectedTower = 0
        end
    end

    love.graphics.draw(Utils.imageFromCache(tile.image), u, v)
    if tile.tower ~= nil then
        love.graphics.draw(tile.tower.image, u, v - 16)
    end
    love.graphics.setColor({1, 1, 1, 1})

    for i = tile.start[1],tile.stop[1] do
        for j = tile.start[2],tile.stop[2] do
            self.tiles[j][i].rendered = true
        end
    end
end

function Game:reset_tiles()
    for i, row in ipairs(self.tiles) do
        for j, tile in ipairs(row) do
            tile.rendered = false
        end
    end
end

function Game:draw_ufos(ww, wh)
    for i, ufo in ipairs(self.ufos) do
        local sx = ufo.pos[1]
        local sy = ufo.pos[2]
        local u = ww/2
        local v = (wh - #self.tiles*65) / 2
        u = u + (sx - sy) * 65 - 130
        v = v + (sx + sy - 2) * 32 - 141
        love.graphics.draw(Utils.imageFromCache(ufo.image), u, v)
    end
end

function Game:draw_tools(ww, wh)
    local seconds_since_start = math.floor(self.time_since_start)
    local minutes = math.floor(seconds_since_start / 60)
    local seconds = seconds_since_start % 60
    love.graphics.print(string.format('%02d:%02d', minutes, seconds), font, ww - 150, 30)

    local mx, my = love.mouse.getPosition()
    local minx = ww - 132
    local maxx = ww - 20

    local tools = {
        {
            image = Utils.imageFromCache('assets/actors/weapon_crystals_N.png'),
            min = {minx, wh - 20*4 - 96*3 - 96},
            max = {maxx, wh - 20*4 - 96*3}
        },
        {
            image = Utils.imageFromCache('assets/actors/weapon_cannon_E.png'),
            min = {minx, wh - 20*3 - 96*2 - 96},
            max = {maxx, wh - 20*3 - 96*2}
        },
        {
            image = Utils.imageFromCache('assets/actors/weapon_ballista_E.png'),
            min = {minx, wh - 20*2 - 96 - 78},
            max = {maxx, wh - 20*2 - 96}
        },
        {
            image = Utils.imageFromCache('assets/actors/sell.png'),
            min = {minx, wh - 20 - 78},
            max = {maxx, wh - 20}
        }
    }

    for i, t in ipairs(tools) do
        if t.min[1] <= mx and mx <= t.max[1] and t.min[2] <= my and my <= t.max[2] then
            love.graphics.setColor({1, 1, 1, 0.5})
            if love.mouse.isDown(1) then
                self.selectedTower = i
            end
        end
        love.graphics.draw(t.image, minx - 74, t.max[2] - 218)
        love.graphics.setColor({1, 1, 1})
    end

    if self.selectedTower > 0 then
        local ti = tools[self.selectedTower].image
        local tw = ti:getWidth()

        love.graphics.draw(ti, mx, my, 0, 1, 1, tw/2, 173)
    end
end

function Game:draw(ww, wh)
    love.graphics.draw(mesh, 0, 0, 0, ww, hh)

    self:draw_tiles(ww, wh, #self.tiles, #self.tiles)
    self:reset_tiles()

    self:draw_ufos(ww, wh)
    self:draw_tools(ww, wh)
end

return Game
