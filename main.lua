local screens = {
    _current = nil,
    menu = require 'menu',
    game = require 'game'
}

screens.changeScreen = function(name, ...)
    screens._current = screens[name]
    screens._current:load(...)
end

function love.load()
    math.randomseed(os.time())
    font = love.graphics.newFont("DoublePixel.ttf", 64)
    love.window.setFullscreen(true)
    love.keyboard.setKeyRepeat(false)
    screens.changeScreen('menu', screens)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        screens.game.paused = not screens.game.paused
    end
end

function love.update(dt)
    screens._current:update(dt)
end

function love.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    screens._current:draw(ww, wh)
end
