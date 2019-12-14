---
-- Класс Тайла
-- @module Tile

local Utils = require 'utils'

local Tile = {}

--- создаёт новый экземпляр Tile
-- @param image название файла изображения
-- @param towerable возможно ли установить башню на данный тайл
-- @return новый тайл
function Tile:new(image, towerable)
    local t = {
        image = 'assets/tiles/' .. image,
        tower = nil,
        towerable = towerable,
        rendered = false
    }
    self.__index = self
    return setmetatable(t, self)
end

--- возвращает изображение текущего тайла
-- @return изображение
function Tile:getImage()
    return Utils.imageFromCache(self.image)
end

return Tile
