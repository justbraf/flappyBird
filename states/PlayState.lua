--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class { __includes = BaseState }

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0
    -- keeps track of the value that will vary for the spawn time
    self.spawnTimerInterval = 1
    self.score = 0

    -- my sprites are rotated instead of scaled, so my values start within the screen
    self.lastY = math.random(VIRTUAL_HEIGHT / 14, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT / 2.2))

    -- track game pause
    self.gamePaused = false
end

-- updated code to my implementation of the game update function
function PlayState:update(dt)
    if love.keyboard.wasPressed('p') then
        self.gamePaused = not self.gamePaused
    end
    if not self.gamePaused then
        -- update timer for pipe spawning
        self.spawnTimer = self.spawnTimer + dt

        -- spawn a new pipe pair at the set time interval
        if self.spawnTimer > self.spawnTimerInterval then
            --[[
            last Y no higher than 20 pixels (mouth height of the top pipe sprite) from
            the top edge of the screen and no lower than 157 pixels from the top edge
            of the screen. This allows for a gap length (90 pixels) before the minimum
            height of 30 pixels (mouth height of the bottom pipe sprite & the height of
            the ground sprite) from the bottom edge of the screen.
        ]]
            local y = math.max(VIRTUAL_HEIGHT / 14,
                math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT / 2.2)))
            self.lastY = y

            -- add a new pipe pair at the end of the screen at our new Y
            table.insert(self.pipePairs, PipePair(y))

            -- reset timer
            self.spawnTimer = 0
            -- generate new spawn time interval
            self.spawnTimerInterval = math.random(2, 5)

            -- check table for pipe pairs that are out of the zone and remove them
            for key, pipePair in pairs(self.pipePairs) do
                if pipePair.x < -pipePair.width then
                    table.remove(self.pipePairs, key)
                end
            end
        end

        -- update the bird sprite position
        self.bird:update(dt)

        -- update the pair of pipe sprites positions
        for key, pipePair in pairs(self.pipePairs) do
            pipePair:update(dt)
        end

        -- check for collisions between bird and ground
        if self.bird:collideGround() then
            sounds['hurt']:play()
            sounds['explosion']:play()
            gStateMachine:change('score', {
                score = self.score
            })
        end
        -- check for collisions between bird and pipes
        for key, pipePair in pairs(self.pipePairs) do
            if self.bird:collides(pipePair) then
                sounds['hurt']:play()
                sounds['explosion']:play()
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end

        -- check if bird has passed a pipe and it wasn't scored then score it
        for key, pipePair in pairs(self.pipePairs) do
            if not pipePair.scored then
                if pipePair.x + pipePair.width < self.bird.x then
                    self.score = self.score + 1
                    sounds['score']:play()
                    pipePair.scored = true
                end
            end
        end
    end
end

function PlayState:render()
    -- updated code to my implementation of rendering pipes
    for key, pipes in pairs(self.pipePairs) do
        pipes:render()
    end

    self.bird:render()

    -- show score
    love.graphics.setFont(lgFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
end

function PlayState:paused()
    -- make the pause state accessible outside of the class
    return self.gamePaused
end
