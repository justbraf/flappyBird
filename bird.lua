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
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy
    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end
end

function Bird:collides(pipePair)
    if self.x + 2 > pipePair.pipes['upper'].x + pipePair.width then
        return false
    end
    if self.x + self.width - 2 > pipePair.pipes['upper'].x and self.y + 2 < pipePair.pipes['upper'].y then
        print('upperpipe.x ' .. pipePair.pipes['upper'].y)
        return true
    elseif self.x + self.width - 2 > pipePair.pipes['upper'].x and self.y + self.height - 2 > pipePair.pipes['lower'].y then
        print('lowerpipe.x ' .. pipePair.pipes['lower'].y)
        return true
    elseif self.y > VIRTUAL_HEIGHT - 16 - self.height - 2 then
        return true
    end
    return false
end
