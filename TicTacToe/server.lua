-----------------------------------------------------------------------------------------
--
-- server.lua
--
-- Authors: Daniel Burris, Jairo Arreola
--
-- This is the server scene. We are taken here when the user presses the server button.
-----------------------------------------------------------------------------------------

-- Socket widget. Used for network connections
local socket = require("socket")

-- Game.lua contains methods and objects used to control and manpiulate the game
local game = require( "game" )

local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- setState()
--      input: none
--      output: none
--      
--      Sets and tracks the state of the game. (Whose turn it is)
local function setState()
    -- The board is playable and game is activated if it is your turn

    game.checkWin()
    -- sendMove()
    --      input: none
    --      output: none
    --      
    --      Called with a tap listener event, sends the x,y coordinates of the slot we
    --      played on
    local function sendMove(event)
        local a = event.x;
        local b = event.y;
        print("I made my move at:", event.x, event.y)
        local sent, msg =   client:send(event.x..","..event.y.."\r\n")

        print("sent from server")
        yourMove = false
        setState()
    end
    if yourMove then
        game.activate()
        Runtime:addEventListener("moved", sendMove)
    else
        -- The board is not playable or active when it is the enemies turn
        timer.resume(rTimer)
    end
end

-- waitForMove()
--      input: none
--      output: none
--      
--      This method is associated with rTimer, which is called after we make a move
--      and now wait for the enemy to make his move. 
function waitForMove()

    -- Do nothing, pause timer
    print ("Waiting to receive move... ")
    timer.pause(rTimer)
    -- Waiting for communication from client
    local line, err = client:receive("*l")
    client:settimeout(1);
    if client == nil then
        print("canceling timer client == nil")
    end

    -- We got something from client
    if not err then
        print ("received.")
        -- if line == "lost" then
        --   native.showAlert("", string.format("You lost!"), {"Exit to Menu"}, exitToMenu)
        -- end

        -- Extract information (which board he played on)
        local x=tonumber(string.sub(line,1,1))
        local y=tonumber(string.sub(line,3,3))
        print ("Got:",x,y)
        print ("-------------")    

        -- Mark the board
        if (game.mark(x,y) == true) then
            game.activate()
            yourMove = true
        end

        -- Swap turns
        setState()
    else
        print ("Error.")
        timer.resume(rTimer)
    end
    game.checkWin()
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
--      input: none
--      output: none
--
--      This function creates all the objects that will be used in the scene and adds
--      them to the scene group.
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    yourMove = true

    -- Setting up the server
    -- server = assert(socket.bind("*", 20140))
    server = socket.bind("*", 20140);
    -- Wait for connection from client
    client = server:accept()
    cip, cport = client:getpeername()
    print ("connected to:", cip, ":", cport)

    rTimer = timer.performWithDelay(10, waitForMove, -1)
    timer.pause(rTimer)

    --test connection
    local sent, msg =   client:send("sent from server".."\r\n")

    if sent then
        print("Message sent")
        local line, err = client:receive("*l")

        if not err then
            print(line);
        else
            print("Unable to receive on server side")
        end

    else
        print("Unable to send from server side")
    end

end


-- show()
--      input: none
--      output: none
--
--      This function destroys the game scenes when its swapped to the menu scene
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        composer.removeScene("menu")

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        setState()

    end
end


-- hide()
--      input: none
--      output: none
--
--      This function does nothing for us, but is still part of Corona SDK scene creation requirements
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        server:close()
        composer.removeScene("server")

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end


-- destroy()
--      input: none
--      output: none
--
--      This function does nothing for us, but is still part of Corona SDK scene creation requirements
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene



