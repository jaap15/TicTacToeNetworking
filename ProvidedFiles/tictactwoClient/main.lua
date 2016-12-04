
local socket = require("socket")
local game = require( "game" );


-- connect to a TCP server
local ip = "localhost";
client = socket.connect(ip,20140);
local cip, cport = client:getpeername();
print ("connected to host at:", cip, ":", cport);



local buttons = display.newGroup();

local sBtn = display.newRect (buttons, 30,0,35,20 );
sBtn:setFillColor(0,0.5,0);
display.newText(buttons, "Host", 30, 0,native.systemFont,15);

local cBtn = display.newRect (buttons, 80,0,40,20 );
cBtn:setFillColor(0,0.5,0);
display.newText(buttons, "Guest", 80,0,native.systemFont,15);





function waitForMove()
  print ("Waiting to receive move... ");
  local line, err = client:receive();
  print ("received.");
  if not err then 
    local x=tonumber(string.sub(line,1,1));
    local y=tonumber(string.sub(line,3,3));
    print ("Got:",x,y);
    print ("-------------");    
    game.mark(x,y);
    game.activate();
  else 
    print ("Error.")
  end
end



local function gameStart (event)
  buttons:removeSelf();  -- remove the buttons
  buttons=nil;


  --determine: host vs guest
  if (event.target==sBtn) then --------------- host/server role
  	game.activate ();

  else  --------------- guest/client role
  	waitForMove();  
  end
end
sBtn:addEventListener("tap", gameStart);
cBtn:addEventListener("tap", gameStart);



local function sendMove(event)
  print("I made my move at:", event.x, event.y);
  local sent, msg =   client:send(event.x..","..event.y.."\r\n");
  
  waitForMove();
end

Runtime:addEventListener("moved", sendMove);


