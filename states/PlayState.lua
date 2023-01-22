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

    -- my sprites are rotated instead of scaled, so my values start within the screen
    self.lastY = math.random(VIRTUAL_HEIGHT / 14, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT / 2.2))

end

-- updated code to my implementation of the game update function
function PlayState:update(dt)
    -- update timer for pipe spawning
    self.spawnTimer = self.spawnTimer + dt

    -- spawn a new pipe pair every second and a half0
    if self.spawnTimer > 2 then
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
        -- end
        -- check table for pipe pairs that are out of the zone and remove them
        for key, pipePair in pairs(self.pipePairs) do
            if pipePair.pipes['upper'].x < -pipePair.width then
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

    -- check for collisions between bird and pipes or ground
    for key, pipePair in pairs(self.pipePairs) do
        if self.bird:collides(pipePair) then
            gStateMachine:change('title')
        end
    end
end

function PlayState:render()
    -- updated code to my implementation of rendering pipes
    for key, pipes in pairs(self.pipePairs) do
        pipes:render()
    end

    self.bird:render()
end
