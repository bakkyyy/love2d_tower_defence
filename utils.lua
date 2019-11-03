-- кеш изображений: путь - Image
local imageCache = {}

-- возвращает изображение из кеша или открывает из файла и кеширует
local function imageFromCache(path)
    if imageCache[path] == nil then
        imageCache[path] = love.graphics.newImage(path)
    end
    return imageCache[path]
end

-- создаёт вертикальный или горизонтальный градиент
local function gradientMesh(dir, ...)
    local isHorizontal = true
    if dir == 'vertical' then
        isHorizontal = false
    elseif dir ~= 'horizontal' then
        error("bad argument #1 to 'gradient' (invalid value)", 2)
    end

    local colorLen = select('#', ...)
    if colorLen < 2 then
        error('color list is less than two', 2)
    end

    local meshData = {}
    if isHorizontal then
        for i = 1, colorLen do
            local color = select(i, ...)
            local x = (i - 1) / (colorLen - 1)

            meshData[#meshData + 1] = {x, 1, x, 1, color[1], color[2], color[3], color[4]}
            meshData[#meshData + 1] = {x, 0, x, 0, color[1], color[2], color[3], color[4]}
        end
    else
        for i = 1, colorLen do
            local color = select(i, ...)
            local y = (i - 1) / (colorLen - 1)

            meshData[#meshData + 1] = {1, y, 1, y, color[1], color[2], color[3], color[4]}
            meshData[#meshData + 1] = {0, y, 0, y, color[1], color[2], color[3], color[4]}
        end
    end

    return love.graphics.newMesh(meshData, 'strip', 'static')
end

-- форматирует объект в строку для дебага
local function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. ' }\n'
    else
        return tostring(o)
    end
 end

-- делает копию объекта
local function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
        end
    else
        copy = orig
    end
    return copy
end

-- удаляет элемент из массива по индексу (быстрее table.remove)
local function removeIndex(array, index)
    array[index] = array[#array]
    array[#array] = nil
end

return {
    imageFromCache = imageFromCache,
    gradientMesh = gradientMesh,
    dump = dump,
    deepcopy = deepcopy,
    removeIndex = removeIndex
}
