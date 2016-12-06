local socket = require("socket")
local game = require( "game" );




-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-- Authors: Daniel Burris, Jairo Arreola
--
-- This is the main menu.
-----------------------------------------------------------------------------------------

local composer = require("composer")

-- Scene Creation / Manipulation
local scene = composer.newScene()

-- Widget Creation / Manipulation
-- Used for buttons, sliders, radio buttons
local widget = require("widget")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local ip
-- local cip
-- local cport

-- local server;
-- local client;

-- local rTimer;
-- yourMove = false;


local function setState()

  if yourMove then

    print("Your turn")
    game.activate();

  else
    print("Opponent's turn")
    timer.resume(rTimer)
    
  end

end


function waitForMove()
  
    print ("Waiting to receive move... ");
    timer.pause(rTimer)
    local line, err = client:receive("*l");

    if client == nil then
      print("canceling timer client == nil")
    end
    if not err then
      print ("received.");
      -- if line == "lost" then
      --   native.showAlert("", string.format("You lost!"), {"Exit to Menu"}, exitToMenu)
      -- end
      local x=tonumber(string.sub(line,1,1));
      local y=tonumber(string.sub(line,3,3));
      print ("Got:",x,y);
      print ("-------------");    
      if (game.mark(x,y) == true) then
      game.activate();
      yourMove = true;
      end
      setState();
    else 
      print ("Error.")
    end

end


local function sendMove(event)

    print("I made my move at:", event.x, event.y);
    local sent, msg =   client:send(event.x..","..event.y.."\r\n");


    print("sent from server")
    yourMove = false;
    setState()

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
  yourMove = false;

  -- connect to a TCP server
  ip = "localhost";
  client = socket.connect(ip,20140);
  cip, cport = client:getpeername();
  print ("connected to host at:", cip, ":", cport);


  rTimer = timer.performWithDelay(10, waitForMove, -1);
  timer.pause(rTimer)

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
        -- holds all of the enemy objects that the player will battle

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        Runtime:addEventListener("moved", sendMove);
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

