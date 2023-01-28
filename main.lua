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
require 'states/ScoreState'
require 'states/TitleScreenState'
require 'states/CountdownState'


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

-- pause sprite
local pause = love.graphics.newImage('assets/pause.png')

-- pause screen overlay
local overlay = love.graphics.newImage('assets/transparent1.png')
-- easter egg activation table
easterEgg = {}
-- easter egg flag
easterEggFlag = false

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
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['countdown'] = function() return CountdownState() end
    }
    gStateMachine:change('title')

    sounds = {
        ['jump'] = love.audio.newSource('assets/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('assets/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('assets/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('assets/score.wav', 'static'),
        ['music'] = love.audio.newSource('assets/marios_way.mp3', 'static'),
        -- load audio for easter egg activation
        ['success'] = love.audio.newSource('assets/success.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- initialize keyboard input table
    love.keyboard.keysPressed = {}
    -- initialize mouse input table
    love.mouse.buttonPressed = {}
    -- set mouse to be invisible
    love.mouse.setVisible(false)
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

function love.mousepressed(x, y, button)
    love.mouse.buttonPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.buttonPressed[key]
end

function love.update(dt)
    -- check the state machine to see if the game was paused
    local pauseState = gStateMachine:paused()
    if not pauseState then
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
    end
    gStateMachine:update(dt)

    -- reset keyboard input table
    love.keyboard.keysPressed = {}
    -- reset mouse input table
    love.mouse.buttonPressed = {}
end

function love.draw()
    push:start()

    -- draw background
    love.graphics.draw(bkgnd, bkScroll, 0)
    gStateMachine:render()
    -- draw ground
    love.graphics.draw(ground, gndScroll, VIRTUAL_HEIGHT - ground:getHeight())

    if gStateMachine:paused() then
        -- draw overlay image
        love.graphics.draw(overlay, 0, 0)
        -- display pause text and icon
        love.graphics.print('PAUSED', VIRTUAL_WIDTH / 2 - 55, VIRTUAL_HEIGHT / 2 - 30)
        love.graphics.draw(pause, VIRTUAL_WIDTH / 2 - 31, VIRTUAL_HEIGHT / 2)
        -- if audio is playing then pause it
        if sounds['music']:isPlaying() then
            sounds['music']:pause()
        end
    elseif not sounds['music']:isPlaying() then
        -- if the audio was not resumed then resume it
        sounds['music']:play()
    end

    push:finish()
end
