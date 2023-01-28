Bird = Class {}

local GRAVITY = 20

function Bird:init()
    -- set bird sprite based on easter egg flag
    if easterEggFlag then
        self.image = love.graphics.newImage('assets/birdcs50.png')
    else
        self.image = love.graphics.newImage('assets/bird.png')
    end
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    -- make bird fly with spacebar or left-click
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -5
        sounds['jump']:play()
    end
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy
    -- if the bird sprite is above the view port then limit its y position to zero
    if self.y < 0 then
        self.y = 0
    end
end

function Bird:collides(pipePair)
    -- if the bird has flown pass a pipePair then ignore them
    if self.x + 2 > pipePair.x + pipePair.width then
        return false
    end
    -- if the bird is not within the pipe gap then indicate a collision
    if self.x + self.width - 2 > pipePair.x and
        (self.y + 2 < pipePair.y or self.y + self.height - 2 > pipePair.pipes['lower'].y) then
        return true
    end
    -- no conditions have been met. The bird is flying in open space
    return false
end

function Bird:collideGround()
    -- if the bird is touching the ground indicate a collision
    if self.y > VIRTUAL_HEIGHT - 16 - self.height - 2 then
        return true
    end
end
