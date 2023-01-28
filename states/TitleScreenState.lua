--[[
    TitleScreenState Class

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

TitleScreenState = Class { __includes = BaseState }

function TitleScreenState:update(dt)
    -- start the game with the return key or a right-click
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.mouse.wasPressed(2) then
        gStateMachine:change('countdown')
    elseif love.keyboard.wasPressed('c') then
        -- first character in sequence, otherwise reset table
        if table.getn(easterEgg) == 0 then
            table.insert(easterEgg, 'C')
        else
            easterEgg = {}
        end
    elseif love.keyboard.wasPressed('s') then
        -- second character in sequence, otherwise reset table
        if table.getn(easterEgg) == 1 then
            table.insert(easterEgg, 'S')
        else
            easterEgg = {}
        end
        -- third character in sequence, otherwise reset table
    elseif love.keyboard.wasPressed('5') then
        if table.getn(easterEgg) == 2 then
            table.insert(easterEgg, '5')
        else
            easterEgg = {}
        end
    elseif love.keyboard.wasPressed('0') then
        -- final character in sequence is inputted, activate the easter egg and play a success notification
        if table.getn(easterEgg) == 3 then
            table.insert(easterEgg, '0')
            sounds['success']:play()
            easterEggFlag = true
        end
    else
        -- reset the easter egg code table, if the sequence is incorrect
        for key, val in pairs(love.keyboard.keysPressed) do
            if table.getn(easterEgg) == 3 and key ~= '0' then
                easterEgg = {}
            elseif table.getn(easterEgg) == 2 and key ~= '5' then
                easterEgg = {}
            elseif table.getn(easterEgg) == 1 and key ~= 's' then
                easterEgg = {}
            end
        end
    end
end

function TitleScreenState:render()
    -- updated to my font variable
    love.graphics.setFont(lgFont)
    love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    -- updated to my font variable
    love.graphics.setFont(mdFont)
    love.graphics.printf('Press Enter to play', 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press P to pause", 0, 120, VIRTUAL_WIDTH, 'center')
end
