local composer = require( "composer" );
local physics = require("physics");
local socket = require("socket")
local square = require( "square" );

local scene = composer.newScene();

function scene:create(event)
 local sceneGroup = self.view  

 local mine = square:new({x=35,y=100});
  mine:spawn();
  mine.shape:setFillColor (0,1,0);
  Runtime:addEventListener("touch", mine);

  -- . . .
 local g1 = display.newGroup();  
 local btnConnect = display.newRect(g1,30,0, 30,10);
  btnConnect:setFillColor(0.5,0.5,0);
  display.newText(g1,"Connect", 30,0, native.systemFont, 15 );

local function SND (event)
 	 
	  if mine.updated then
	      local sent, msg = 
	      client:send(tostring(mine.shape.x)..":"..tostring(mine.shape.y)..";".."\r\n");  
	      mine.updated = false;       
	  end
 end


 local ip = "localhost";
 local function CNT (event)
    client = socket.connect(ip,20140);
    client:settimeout(0);
    g1:removeSelf();
    g1 = nil;
    print('connect CNT')
    timer.performWithDelay(10,SND, -1); -- send @10ms
  end  
  btnConnect:addEventListener("tap", CNT);

 

end
scene:addEventListener( "create", scene );

return scene;
