local physics = require("physics");
local socket = require("socket");
local composer = require("composer");

physics.start();
physics.setDrawMode ("normal");
physics.setGravity (0,0);
	
local g = display.newGroup();

local btn1 = display.newRect(g, 30,0,30,10);
btn1:setFillColor(0.5,0.5,0);
display.newText(g, "Host", 30,0, native.systemFont, 15 );

local btn2 = display.newRect(g, 80,0,30,10);
btn2:setFillColor(0.5,0.5,0);
display.newText(g, "Guest",  80,0, native.systemFont, 15 );

local function start (event)
  if (event.target == btn1) then
    g:removeSelf();
    g=nil;   
    composer.gotoScene ("server");
  else
    g:removeSelf();
    g=nil;   
    composer.gotoScene ("client");
  end
end

btn1:addEventListener("tap", start);
btn2:addEventListener("tap", start);
