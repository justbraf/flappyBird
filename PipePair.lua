PipePair = Class {}

local GAP_HEIGHT = 90

function PipePair:init()
    self.x = VIRTUAL_WIDTH + 32
    self.y = y
    
    local gap = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 160)
    -- minimum gap start top = 40 or 10
    -- maximum gap start bottom = 128 0r 268
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', gap + GAP_HEIGHT)
    }
    self.width = self.pipes['upper'].width
end

function PipePair:update(dt)
    self.pipes['upper']:update(dt)
    self.pipes['lower']:update(dt)
end

function PipePair:render()
    self.pipes['upper']:render()
    self.pipes['lower']:render()
end