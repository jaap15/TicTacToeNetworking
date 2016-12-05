
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

local server;
local client;
-- local buttons;
-- local sBtn;
-- local cBtn;
local cip
local cport
local rTimer;
local yourMove = true;


function waitForMove()

  -- if not yourMove then
    print ("Waiting to receive move... ");
    local line, err = client:receive('*l');
    -- local line, err = client:receive(512);
    print ("received.");
    if client == nil then
      print("canceling timer client == nil")
      -- timer.cancel(rTimer)
    end
    if not err then
      -- timer.cancel(rTimer)
      local x=tonumber(string.sub(line,1,1));
      local y=tonumber(string.sub(line,3,3));
      print ("Got:",x,y);
      print ("-------------");    
      game.mark(x,y);
      game.activate();
    else 
      print ("Error.")
    end
  -- end

end

local function setState()

  if yourMove then

    print("Your turn")
    game.activate();

    -- Runtime:addEventListener("moved", sendMove);


  else

    print("Opponent's turn")
  end

end

local function sendMove(event)
  print("I made my move at:", event.x, event.y);
  local sent, msg =   client:send(event.x..","..event.y.."\r\n");

  print("sent from server")
  setState()
  -- waitForMove();
  -- rTimer = timer.performWithDelay(10, waitForMove, -1);
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

  -- local server = socket.bind("*", 20140);
  server = assert(socket.bind("*", 20140));
  -- Wait for connection from client
  client = server:accept();
  -- local cip, cport = client:getpeername();
  -- print ("connected to:", cip, ":", cport);
  cip, cport = client:getpeername();
  print ("connected to:", cip, ":", cport);


  -- game.setPlayer(0);

  -- buttons = display.newGroup();

  -- sBtn = display.newRect (buttons, 30,0,35,20 );
  -- sBtn:setFillColor(0,0.5,0);
  -- display.newText(buttons, "Host", 30, 0,native.systemFont,15);

  -- cBtn = display.newRect (buttons, 80,0,40,20 );
  -- cBtn:setFillColor(0,0.5,0);
  -- display.newText(buttons, "Guest", 80,0,native.systemFont,15);

    -- Adding all objects to the scene group, this will bind these object to the scene
    -- and they will be removed / replaced when switching to and from scenes
    -- sceneGroup:insert( server )
    -- sceneGroup:insert( client )
    -- sceneGroup:insert( buttons )
    -- sceneGroup:insert( sBtn )
    -- sceneGroup:insert( cBtn )
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
        -- sBtn:addEventListener("tap", gameStart);
        -- cBtn:addEventListener("tap", gameStart);
        Runtime:addEventListener("moved", sendMove);
        game.activate();
        -- rTimer = timer.performWithDelay(500, waitForMove, -1);
        -- rTimer = timer.performWithDelay(500, setState, -1);

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



