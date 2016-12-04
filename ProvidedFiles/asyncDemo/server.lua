local composer = require( "composer" );
local physics = require("physics");
local socket = require("socket")
local square = require( "square" );

local scene = composer.newScene();

function scene:create(event)
  local sceneGroup = self.view;
  local server = assert(socket.bind("*", 20140));
  
  local client;  -- used to communicate via socket
  local cube;    -- object the guest will control

 

  local g1 = display.newGroup();  
	local btnConnect = display.newRect(g1,30,0,30,10);
	btnConnect:setFillColor(0.5,0.5,0);
	display.newText(g1,"Wait",30,0, native.systemFont, 15 );
	  
local function REC (event)    
		
	  msg, err = client:receive('*l'); 
	    print(msg);   
	  if (not err) then            
	     local i = string.find(msg,":");
	     local j = string.find(msg,";");
	     cube.shape.x=tonumber(string.sub(msg,1,i-1));
	     cube.shape.y=tonumber(string.sub(msg,i+1,j-1));                
	  end
	end

    local function CON (event)	
	    client = server:accept(); -- accept: BLOCKING call.
	    client:settimeout(0);  -- future use of client will be
	                            --   NON-Blocking from here on
	    g1:removeSelf();  --remove button
	    g1 = nil;
	    --create the object that will mirror the guest’s object.
	    cube = square:new({x=35,y=100});
	    cube:spawn();
	    cube.shape:setFillColor (0,1,0);


	    timer.performWithDelay(10, REC, -1);
  
	end
	btnConnect:addEventListener("tap", CON);

	

	
end

scene:addEventListener( "create", scene );
return scene;
