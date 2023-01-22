Bird = Class {}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('assets/bird.png')
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
    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy
    -- if the bird sprite is above the view port then limit its y position
    if self.y < 0 then
        self.y = 0
    end
end

function Bird:collides(pipePair)
    -- if the bird has flown pass a pipePair then ignore them
    if self.x + 2 > pipePair.pipes['upper'].x + pipePair.width then
        return false
    end
    -- if the bird is not within the pipe gap then indicate a collision
    if self.x + self.width - 2 > pipePair.pipes['upper'].x and
        (self.y + 2 < pipePair.pipes['upper'].y or self.y + self.height - 2 > pipePair.pipes['lower'].y) then
        print('pipe.x ' .. pipePair.pipes['lower'].y)
        return true
    elseif self.y > VIRTUAL_HEIGHT - 16 - self.height - 2 then
        return true
    end
    -- no conditions have been met. The bird is flying in open space
    return false
end
