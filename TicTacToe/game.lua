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
local player = 0 -- swap between 0 and 1

-- Drawing the game board according to screen resolution
-- ------------------------------------------------------

-- Drawing the whole board
local zone = display.newRect (display.contentCenterX, display.contentCenterY, display.contentWidth/1.2, display.contentHeight/1.2)
zone.strokeWidth = 2
zone:setFillColor(0,0.2,0)
zone.isSensor = true

-- Drawing the vertical lines
local ver = display.newRect (display.contentCenterX, display.contentCenterY, display.contentWidth/1.2, display.contentHeight/3.6)
ver:setFillColor(0,0,0,0)
ver.strokeWidth = 2 

-- Drawing the horizontal lines
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
    print("canceling timer")
    timer.cancel(rTimer)
    print("removing objects")
    zone:removeSelf()
    ver:removeSelf()
    hor:removeSelf()
    print("closing connections")
    server:close()
    print("closing client")
    client:close()
    composer.gotoScene("menu")
end

-- checkWin()
--      input: none
--      output: none
--
--      Checks win conditions for columns, rows, and diagonals
function checkWin() 
    --check columns
    for i=1, 3 do
        if (board[i][1] == board[i][2] and 
            board[i][1] == board[i][3] and 
            board[i][1] ~= -1) then
            -- local sent, msg =   client:send("lost".."\r\n")
            native.showAlert("", string.format("Player %01d wins!", board[i][1]), {"Exit to Menu"}, exitToMenu)
        end
    end

    --check rows
    for i=1, 3 do
        if (board[1][i] == board[2][i] and 
            board[1][i] == board[3][i] and 
            board[1][i] ~= -1) then
            -- local sent, msg =   client:send("lost".."\r\n")
            native.showAlert("", string.format("Player %01d wins!", board[1][i]), {"Exit to Menu"}, exitToMenu)
        end
    end

    --check diagonals
    if (board[1][1] == board[2][2] and 
        board[1][1] == board[3][3] and 
        board[1][1] ~= -1) then
        -- local sent, msg =   client:send("lost".."\r\n")
        native.showAlert("Congratulations!", string.format("Player %01d wins!", board[1][1]), {"Exit to Menu"}, exitToMenu)
    elseif (board[3][1] == board[2][2] and 
        board[3][1] == board[1][3] and 
        board[3][1] ~= -1) then
        -- local sent, msg =   client:send("lost".."\r\n")
        native.showAlert("", string.format("Player %01d wins!", board[3][1]), {"Exit to Menu"}, exitToMenu)
    end
     
end

-- zoneHandler()
--      input: none
--      output: none
--
--      Checks win conditions for columns, rows, and diagonals
local function zoneHandler(event)
    -- convert the tap position to 3x3 grid position 
    --   based on the board size
    print("zoneHandler tapped")
    local x, y = event.target:contentToLocal(event.x, event.y)
    x = x + (display.contentWidth/2.4)  -- conversion
    y = y + (display.contentHeight/2.4)   -- conversion
    x = math.ceil( x/(display.contentWidth/3.6))
    y = math.ceil( y/(display.contentHeight/3.6))

    if (game.mark(x,y)==false) then   --bad move
    print("bad move")
    	return
    end

    zone:removeEventListener("tap", zoneHandler)
    Runtime:dispatchEvent({name="moved", x=x, y=y}) 

    checkWin()
end
zone:addEventListener("tap", zoneHandler)

-- game.activate()
--      input: none
--      output: none
--
--      Checks win conditions for columns, rows, and diagonals
function game.activate ()
    zone:addEventListener("tap", zoneHandler)
end

-- game.mark()
--      input: x, y
--      output: boolean
--
--      Checks win conditions for columns, rows, and diagonals
function game.mark (x,y)
    if (board[x][y] ~= -1) then  -- space not empty!
        return false
    end

    -- mark the game board (logical)
    board[x][y] = player 
    --place the piece on the board (visual)
    local _x = 0
    local _y = 0

    local xgaps = (display.contentWidth-display.contentWidth/1.2)/2
    local ygaps = (display.contentHeight-display.contentHeight/1.2)/2

    _x = ((x-1)*((display.contentWidth/1.2)/3))+xgaps +(display.contentWidth/7.2)
    _y = ((y-1)*((display.contentHeight/1.2)/3))+ygaps  +(display.contentHeight/7.2)


    --local _x, _y = 
    --zone:localToContent(75+150*(x-1) - (display.contentHeight/2.4), 75+150*(y-1) - (display.contentHeight/2.4))
    piece:new(player, _x, _y)	
    player = (player + 1) % 2

  return true
end

return game