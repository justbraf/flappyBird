Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')
local PIPE_SCROLL = -60

function Pipe:init(placement, y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.width = PIPE_IMAGE:getWidth()
    self.placement = placement
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    -- rotated my sprites instead of reflecting them about an axis
    love.graphics.draw(PIPE_IMAGE, self.placement == 'bottom' and self.x or self.x + self.width, self.y,
        self.placement == 'bottom' and 0 or math.pi)
end
