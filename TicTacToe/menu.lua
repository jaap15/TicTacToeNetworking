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

local serverButton;
local clientButton;

-- serverButtonEvent()
--      input: none
--      output: none
--      
--      This function just switches from the menu scene to the server scene
local function serverButtonEvent(event)
	if ("ended" == event.phase) then
        print("server")
        serverButton:setLabel("Waiting on client")
		-- composer.gotoScene("server")
	end
end

-- clientButtonEvent()
--      input: none
--      output: none
--      
--      This function just switches from the menu scene to the client scene
local function clientButtonEvent(event)
    if ("ended" == event.phase) then
        print("client")
        -- composer.gotoScene("client")
    end
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

    -- Creating the start button, sends us from the menu scene to the game scene
    serverButton = widget.newButton({    
            id = "serverButton",
            label = "Create Server",    
            labelColor = { default={ 1, 1, 0 }, over={ 0, 1, 1, 0.5 } },
            width = 300,
            height = 60,
            fontSize = 30,
            defaultFile = "images/menuBtn.png",
            overFile  = "images/menuBtnOnClick.png",
            onEvent = serverButtonEvent 
        } )    

    -- Creating the help button, sends us from the menu scene to the help scene
    clientButton = widget.newButton({    
            id = "clientButton",
            label = "Join as Client",
            labelColor = { default={ 1, 1, 0 }, over={ 0, 0, 0, 0.5 } },
            width = 300,
            height = 60,
            fontSize = 30,
            defaultFile = "images/menuBtn.png",
            overFile  = "images/menuBtnOnClick.png",
            onEvent = clientButtonEvent 
        } )  


    -- Positioning all objects on the screen
    serverButton.x = display.contentCenterX
    serverButton.y = display.contentCenterY-(display.contentCenterY/2)
    clientButton.x = display.contentCenterX
    clientButton.y = display.contentCenterY+(display.contentCenterY/2)

    -- Adding all objects to the scene group, this will bind these object to the scene
    -- and they will be removed / replaced when switching to and from scenes
    sceneGroup:insert( serverButton )
    sceneGroup:insert( clientButton )
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