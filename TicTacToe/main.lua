-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Authors: Daniel Burris, Jairo Arreola
--
-- This is our main function. Its only function is to take us into the menu scene.

-----------------------------------------------------------------------------------------

-- Composer object is used for the creation and manipulation of scenes
local composer = require("composer")

-- Default code, hiding the status bar
display.setStatusBar(display.HiddenStatusBar)

-- Only thing main.lua does is push us into the menu scene, all other functions are 
-- carried out in their respective scenes
composer.gotoScene("menu")