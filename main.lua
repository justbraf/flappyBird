push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local bkgnd = love.graphics.newImage('assets/background.png')
local bkScroll = 0

local ground = love.graphics.newImage('assets/ground.png')
local gndScroll = 0

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Fifty Bird")

    medFont = love.graphics.newFont('assets/font.ttf', 16)
    love.graphics.setFont(medFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    bkScroll = bkScroll - 50 * dt
    gndScroll = gndScroll - 100 * dt
    if gndScroll < -1050 + VIRTUAL_WIDTH then
        gndScroll = 0
    end
end

function love.draw()
    push:start()
    love.graphics.draw(bkgnd, bkScroll, 0)
    love.graphics.draw(ground, gndScroll, VIRTUAL_HEIGHT - 16)
    love.graphics.print(gndScroll, 10, 10)
    push:finish()
end
