Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage('assets/pipe.png')
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
    if self.placement == 'bottom' then
        love.graphics.draw(PIPE_IMAGE, self.x, self.y)
    else
        love.graphics.draw(PIPE_IMAGE, self.x + self.width, self.y, math.pi)
    end
end
