local moonshine = require 'moonshine'

local Utils = require 'utils'

App = {
    _current = nil,
    menu = require 'menu',
    newgame = require 'newgame',
    game = require 'game',
    settings = require 'settings',
    loadgame = require 'loadgame',
    mouseDown = {},
    width = 1920,
    height = 1080
}

App.changeScreen = function(name)
    App._current = App[name]
    App._current:load()
    click:play()
end

App.isMouseDown = function(i)
    local f = App.mouseDown[i]
    App.mouseDown[i] = false
    return f
end

function love.load()
    love.window.setFullscreen(true)

    music = Utils.audioFromCache('Main.mp3')
    musicwar = Utils.audioFromCache('Battle.mp3')
    build = Utils.audioFromCache('Build.ogg')
    click = Utils.audioFromCache('Click.ogg')
    losesound = Utils.audioFromCache('Lose.mp3')
    winsound = Utils.audioFromCache('Win.mp3')
    sellsound = Utils.audioFromCache('Sell.mp3')
    music:setVolume(App.settings.musicVolume)
    music:setLooping(true)
    music:play()
    math.randomseed(os.time())

    font = love.graphics.newFont('DoublePixel.ttf', 64)
    font20 = love.graphics.newFont('DoublePixel.ttf', 20)
    font56 = love.graphics.newFont('DoublePixel.ttf', 56)

    dayGradient = Utils.gradientMesh('vertical', {0.160784, 0.501961, 0.72549, 1}, {0.427451, 0.835294, 0.980392, 1})
    nightGradient = Utils.gradientMesh('vertical', {0, 0.0156863, 0.156863, 1}, {0, 0.305882, 0.572549, 1})

    blurEffect = moonshine(moonshine.effects.gaussianblur)
    blurEffect.gaussianblur.sigma = 5
    App._current = App['menu']
    App._current:load()
end

function love.mousepressed(x, y, button, istouch, presses)
    App.mouseDown[button] = true
end

function love.mousereleased(x, y, button, istouch, presses)
    App.mouseDown[button] = false
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' and App._current == App.game then
        App.game:pause()
    end

    if App._current == App.game and (App.game.state == GAME_STATE_WIN or App.game.state == GAME_STATE_LOSE) then
        App.game.state = GAME_STATE_STOPED
        App.changeScreen('menu')
    end
end

function love.update(dt)
    App._current:update(dt)
end

function love.draw()
    love.graphics.push()
    local sx = love.graphics.getPixelWidth()/App.width
    local sy = love.graphics.getPixelHeight()/App.height
    love.graphics.scale(sx, sy)
    local mx, my = love.mouse.getPosition()
    App._current:draw(mx/sx, my/sy)
    love.graphics.pop()
end

function love.quit()
    love.audio.stop()
end
