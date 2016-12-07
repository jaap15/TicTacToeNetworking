-----------------------------------------------------------------------------------------
--
-- game.lua
--
-- Authors: Daniel Burris, Jairo Arreola
--
-- This is our game file. It contains all methods and objects used to create and 
-- run the Tic-Tac-Toe game. It is not a scene.
-----------------------------------------------------------------------------------------

-- Game object
local game = {}

-- Represents an X or an O
local piece = require( "piece" )

local composer = require("composer")

-- Game board logical struct = 3x3 matrix
local board = {{-1,-1,-1},{-1,-1,-1},{-1,-1,-1}}
local player = 0 -- Swaps between 0 and 1, represents the player
local gamePieces = {}

-- Drawing the game board according to screen resolution
-- ------------------------------------------------------
-- Drawing the whole board, based on screen resolution
local zone
local ver
local hor

local zone = display.newRect (display.contentCenterX, display.contentCenterY, display.contentWidth/1.2, display.contentHeight/1.2)
zone.strokeWidth = 2
zone:setFillColor(0,0.2,0)
zone.isSensor = true

-- Drawing the vertical lines, based on screen resolution
local ver = display.newRect (display.contentCenterX, display.contentCenterY, display.contentWidth/1.2, display.contentHeight/3.6)
ver:setFillColor(0,0,0,0)
ver.strokeWidth = 2 

-- Drawing the horizontal lines, based on screen resolution
local hor = display.newRect (display.contentCenterX, display.contentCenterY,display.contentWidth/3.6 , display.contentHeight/1.2)
hor:setFillColor(0,0,1,0)
hor.strokeWidth = 2 
-- ------------------------------------------------------

-- exitToMenu()
--      input: none
--      output: none
--
--      This function closes all connections, stops all timers, removes all objects, and returns
--      us to the menu.
function exitToMenu(event)
    -- Stopping timers
    print("canceling timer")
    timer.cancel(rTimer)

    -- Removing objects
    print("removing objects")
    zone.isVisible = false
    ver.isVisible = false
    hor.isVisible = false

    for i = 1, #gamePieces do
        gamePieces[i]:remove()
    end

    -- Reseting the board / player / pieces
    board = {{-1,-1,-1},{-1,-1,-1},{-1,-1,-1}}
    player = 0
    gamePieces = {}

    composer.gotoScene("menu")
end

-- checkWin()
--      input: none
--      output: none
--
--      Checks win conditions for columns, rows, and diagonals
function checkWin() 
    -- Checking columns for win conditions (3 in a row)
    for i=1, 3 do
        if (board[i][1] == board[i][2] and board[i][1] == board[i][3] and board[i][1] ~= -1) then
            -- local sent, msg =   client:send("lost".."\r\n")
            native.showAlert("", string.format("Player %01d wins!", board[i][1]), {"Exit to Menu"}, exitToMenu)
        end
    end

    -- Checking rows for win conditions (3 in a row)
    for i=1, 3 do
        if (board[1][i] == board[2][i] and board[1][i] == board[3][i] and board[1][i] ~= -1) then
            -- local sent, msg =   client:send("lost".."\r\n")
            native.showAlert("", string.format("Player %01d wins!", board[1][i]), {"Exit to Menu"}, exitToMenu)
        end
    end

    -- Checking diagonals for win conditions (3 in a row)
    if (board[1][1] == board[2][2] and board[1][1] == board[3][3] and board[1][1] ~= -1) then
        -- local sent, msg =   client:send("lost".."\r\n")
        native.showAlert("Congratulations!", string.format("Player %01d wins!", board[1][1]), {"Exit to Menu"}, exitToMenu)
    elseif (board[3][1] == board[2][2] and board[3][1] == board[1][3] and board[3][1] ~= -1) then
        -- local sent, msg =   client:send("lost".."\r\n")
        native.showAlert("", string.format("Player %01d wins!", board[3][1]), {"Exit to Menu"}, exitToMenu)
    end
end

-- zoneHandler()
--      input: none
--      output: none
--
--      This function is a tap event. He is bound to the zone which is the
--      game board. When he is tapped he finds out what his x and y are
--      converts his coordinates into a matrix index. 
local function zoneHandler(event)
    -- Convert the tap position to 3x3 grid position 
    -- based on resolution

    -- Get x and y from event listener.
    local x, y = event.target:contentToLocal(event.x, event.y)
    x = x + (display.contentWidth/2.4)
    y = y + (display.contentHeight/2.4)
    x = math.ceil( x/(display.contentWidth/3.6))
    y = math.ceil( y/(display.contentHeight/3.6))

    -- Illegal move is made
    if (game.mark(x,y)==false) then
    	return
    end

    -- Move is made, turn is over
    zone:removeEventListener("tap", zoneHandler)

    -- Nothing can happen until the next turn is made
    Runtime:dispatchEvent({name="moved", x=x, y=y}) 

    -- Check to see if anyone won after this move 
    checkWin()
end
-- zone:addEventListener("tap", zoneHandler)

-- game.activate()
--      input: none
--      output: none
--
--      Called when its the users turn
function game.activate ()
    zone:addEventListener("tap", zoneHandler)
    zone.isVisible = true
    ver.isVisible = true
    hor.isVisible = true
end

-- game.mark()
--      input: x, y
--      output: boolean
--
--      Called every tap, we are given the x and y coordinates from the 
--      zoneHandler function and place a peice at the converted coordinates.
function game.mark (x,y)

    -- If the space has already been taken, return false
    if (board[x][y] ~= -1) then
        return false
    end

    -- Logically mark the board
    -- board[x][y] = player 

    -- Physically place the peice on the board
    local _x = 0
    local _y = 0

    -- Calculations for where to place the peice
    local xgaps = (display.contentWidth-display.contentWidth/1.2)/2
    local ygaps = (display.contentHeight-display.contentHeight/1.2)/2
    _x = ((x-1)*((display.contentWidth/1.2)/3))+xgaps +(display.contentWidth/7.2)
    _y = ((y-1)*((display.contentHeight/1.2)/3))+ygaps  +(display.contentHeight/7.2)

    local i = #gamePieces
    i = i + 1

    -- Placing the peice at specified + calculated coordinates
    gamePieces[i] = piece:new()   
    print("Creating peice # " .. i)
    gamePieces[i]:create(i, player, _x, _y)
    board[x][y] = player
    player = (player + 1) % 2

    return true
end

function game.checkWin() 
    -- Checking columns for win conditions (3 in a row)
    for i=1, 3 do
        if (board[i][1] == board[i][2] and board[i][1] == board[i][3] and board[i][1] ~= -1) then
            -- local sent, msg =   client:send("lost".."\r\n")
            native.showAlert("", string.format("Player %01d wins!", board[i][1]), {"Exit to Menu"}, exitToMenu)
        end
    end

    -- Checking rows for win conditions (3 in a row)
    for i=1, 3 do
        if (board[1][i] == board[2][i] and board[1][i] == board[3][i] and board[1][i] ~= -1) then
            -- local sent, msg =   client:send("lost".."\r\n")
            native.showAlert("", string.format("Player %01d wins!", board[1][i]), {"Exit to Menu"}, exitToMenu)
        end
    end

    -- Checking diagonals for win conditions (3 in a row)
    if (board[1][1] == board[2][2] and board[1][1] == board[3][3] and board[1][1] ~= -1) then
        -- local sent, msg =   client:send("lost".."\r\n")
        native.showAlert("Congratulations!", string.format("Player %01d wins!", board[1][1]), {"Exit to Menu"}, exitToMenu)
    elseif (board[3][1] == board[2][2] and board[3][1] == board[1][3] and board[3][1] ~= -1) then
        -- local sent, msg =   client:send("lost".."\r\n")
        native.showAlert("", string.format("Player %01d wins!", board[3][1]), {"Exit to Menu"}, exitToMenu)
    end
end

return game