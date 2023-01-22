--[[
    My implementation of Fifty Bird. I challenged myself to write the code before I watched the video
    for each segment. I would then use any code that I found to be better implemented and incorporate
    it into my code along with any new concepts I couldn't figure out.
]]

push = require 'push'
Class = require 'class'

-- class to manage bird
require 'Bird'
-- class to manage an instance of a pipe
require 'Pipe'
-- class to manage a pair of pipe instances
require 'PipePair'
-- class to manage the game's various states imported from sourcecode
require 'StateMachine'
-- subclasses of the state machine
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'


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

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Fifty Bird")

    smFont = love.graphics.newFont('assets/font.ttf', 8)
    mdFont = love.graphics.newFont('assets/flappy.ttf', 14)
    lgFont = love.graphics.newFont('assets/flappy.ttf', 28)
    xlFont = love.graphics.newFont('assets/flappy.ttf', 56)
    love.graphics.setFont(lgFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('title')

    -- initialize keyboard input table
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
    -- update background scroll position
    bkScroll = bkScroll - BACKGROUND_SCROLL_SPEED * dt
    if bkScroll < BACKGROUND_LOOP_POINT then
        bkScroll = 0
    end

    -- update ground scroll position
    gndScroll = gndScroll - GROUND_SCROLL_SPEED * dt
    if gndScroll < GROUND_LOOP_POINT + VIRTUAL_WIDTH then
        gndScroll = 0
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    -- end
end

function love.draw()
    push:start()

    -- draw background
    love.graphics.draw(bkgnd, bkScroll, 0)
    gStateMachine:render()
    -- draw ground
    love.graphics.draw(ground, gndScroll, VIRTUAL_HEIGHT - ground:getHeight())

    push:finish()
end