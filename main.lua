push = require 'push'
Class = require 'class'

require 'bird'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local bkgnd = love.graphics.newImage('assets/background.png')
local bkScroll = 0
local BACKGROUND_SCROLL_SPEED = 30

local ground = love.graphics.newImage('assets/ground.png')
local gndScroll = 0
local GROUND_SCROLL_SPEED = 60

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

    bird = Bird()
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if not bird:collides() then
        bkScroll = bkScroll - BACKGROUND_SCROLL_SPEED * dt
        if bkScroll < -413 then
            bkScroll = 0
        end

        gndScroll = gndScroll - GROUND_SCROLL_SPEED * dt
        if gndScroll < -1100 + VIRTUAL_WIDTH then
            gndScroll = 0
        end

        if love.keyboard.isDown('up') then
            bird.y = bird.y - 10
            if bird.y < 0 then
                bird.y = 0
            end
        end
        bird:update(dt)
        love.keyboard.keysPressed = {}
    end
end

function love.draw()
    push:start()

    love.graphics.draw(bkgnd, bkScroll, 0)
    love.graphics.draw(ground, gndScroll, VIRTUAL_HEIGHT - ground:getHeight())
    -- love.graphics.print(love.getVersion() .. gndScroll, 10, 10)

    bird:render()

    push:finish()
end
