--[[
    My implementation of Fifty Bird. I challenged myself to write the code before I watched the video
    for each segment. I would then use any code that I found to be better implemented and incorporate
    it into my code along with any new concepts I couldn't figure out.
]]

push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- background sprite config
local bkgnd = love.graphics.newImage('assets/background.png')
local bkScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOP_POINT = -413

-- ground sprite config
local ground = love.graphics.newImage('assets/ground.png')
local gndScroll = 0
local GROUND_SCROLL_SPEED = 60
local GROUND_LOOP_POINT = -1100

local pipePairs = {}
local spawnTimer = 0
-- my sprites are rotated, so my values start within the screen
local lastY -- = math.random(VIRTUAL_HEIGHT/14, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT/14))
local collisionDetected = false
function love.load()
    math.randomseed(os.time())
    -- my sprites are rotated, so my values start within the screen
    lastY = math.random(VIRTUAL_HEIGHT / 14, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT / 2.2))
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
    if not collisionDetected then
        bkScroll = bkScroll - BACKGROUND_SCROLL_SPEED * dt
        if bkScroll < BACKGROUND_LOOP_POINT then
            bkScroll = 0
        end

        gndScroll = gndScroll - GROUND_SCROLL_SPEED * dt
        if gndScroll < GROUND_LOOP_POINT + VIRTUAL_WIDTH then
            gndScroll = 0
        end

        spawnTimer = spawnTimer + dt
        if spawnTimer > 2 then
            local y = math.max(VIRTUAL_HEIGHT / 14,
                math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT / 2.2)))
            print("y=" .. y)
            lastY = y
            table.insert(pipePairs, PipePair(y))
            spawnTimer = 0
            -- check table for pipe pairs that are out of the zone
            for key, pipePair in pairs(pipePairs) do
                if pipePair.pipes['upper'].x < -pipePair.width then
                    table.remove(pipePairs, key)
                end
            end
        end
        bird:update(dt)
        -- update pie pair positions
        for key, pipePair in pairs(pipePairs) do
            pipePair:update(dt)
        end
        -- check for collisions
        for key, pipePair in pairs(pipePairs) do
            collisionDetected = bird:collides(pipePair)
            if collisionDetected then
                break
            end
        end
        love.keyboard.keysPressed = {}
    end
end

function love.draw()
    push:start()

    love.graphics.draw(bkgnd, bkScroll, 0)
    for key, pipes in pairs(pipePairs) do
        pipes:render()
    end
    love.graphics.draw(ground, gndScroll, VIRTUAL_HEIGHT - ground:getHeight())
    -- love.graphics.print(math.random(2)-1, 10, 10)

    bird:render()

    push:finish()
end
