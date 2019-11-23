App = {
    _current = nil,
    menu = require 'menu',
    game = require 'game',
    settings = require 'settings',
    mouseDown = {}
}

App.changeScreen = function(name, ...)
    App._current = App[name]
    App._current:load(...)
end

App.isMouseDown = function(i)
    local f = App.mouseDown[i]
    App.mouseDown[i] = false
    return f
end

function love.load()
    math.randomseed(os.time())

    font = love.graphics.newFont('DoublePixel.ttf', 64)
    font20 = love.graphics.newFont('DoublePixel.ttf', 20)
    font56 = love.graphics.newFont('DoublePixel.ttf', 56)

    love.window.setFullscreen(true)
    love.keyboard.setKeyRepeat(false)
    App.changeScreen('menu')
end

function love.mousepressed(x, y, button, istouch, presses)
    App.mouseDown[button] = true
end

function love.mousereleased(x, y, button, istouch, presses)
    App.mouseDown[button] = false
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' and App._current == App.game then
        App.game.paused = not App.game.paused
    end
end

function love.update(dt)
    App._current:update(dt)
end

function love.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    App._current:draw(ww, wh)
end
