--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class { __includes = BaseState }

-- load medal sprites
local goldMedal = love.graphics.newImage('assets/gold.png')
local silverMedal = love.graphics.newImage('assets/silver.png')
local bronzeMedal = love.graphics.newImage('assets/bronze.png')

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed or right-click is detected
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.mouse.wasPressed(2) then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(lgFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    -- display a medal sprite based on the score
    love.graphics.setFont(smFont)
    if self.score < 2 then
        love.graphics.draw(bronzeMedal, VIRTUAL_WIDTH / 2 - 50, 120)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('Chick \nAward', 0, 165, VIRTUAL_WIDTH, 'center')
    elseif self.score < 4 then
        love.graphics.draw(silverMedal, VIRTUAL_WIDTH / 2 - 50, 120)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('Fledgling \nAward', 0, 165, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.draw(goldMedal, VIRTUAL_WIDTH / 2 - 50, 120)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('Adult \nAward', 0, 165, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(mdFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 230, VIRTUAL_WIDTH, 'center')
end
