PipePair = Class {}


function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y
    self.scored = false

    -- randomize the pipe gap between 70 and 100 pixels
    local GAP_HEIGHT = math.random(70, 100)

    -- minimum gap start top = 40 or 10
    -- maximum gap start bottom = 128 0r 268
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + GAP_HEIGHT)
    }
    self.width = self.pipes['upper'].width
end

function PipePair:update(dt)
    self.pipes['upper']:update(dt)
    self.pipes['lower']:update(dt)

    -- update pipePair x position
    self.x = self.pipes['upper'].x
end

function PipePair:render()
    self.pipes['upper']:render()
    self.pipes['lower']:render()
end