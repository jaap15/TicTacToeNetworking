local game = {};
local piece = require( "piece" );
local physics = require("physics");
physics.start();  physics.setDrawMode ("normal");
physics.setGravity (0,0);

-- game board logical struct = 3x3 matrix
local board = {{-1,-1,-1},{-1,-1,-1},{-1,-1,-1}};
local player = 0; -- swap between 0 and 1

-- game board display layout
local zone = display.newRect (display.contentCenterX, display.contentCenterY, 450,450);
zone.strokeWidth = 2;
zone:setFillColor(0,0.2,0);
physics.addBody ( zone, "static");
zone.isSensor = true;

local ver = display.newRect (display.contentCenterX, display.contentCenterY, 150,450);
ver:setFillColor(0,0,0,0);
ver.strokeWidth = 2; 

local hor = display.newRect (display.contentCenterX, display.contentCenterY, 450,150);
hor:setFillColor(0,0,1,0);
hor.strokeWidth = 2; 

function checkWin() 
  --check columns
  for i=1, 3 do
    if (board[i][1] == board[i][2] and 
        board[i][1] == board[i][3] and 
        board[i][1] ~= -1) then
      local winner = tostring(board[i][1]).." wins!";		
      display.newText(winner, 100, 200, native.systemFont, 40);
     end
   end

   --check rows

   --check diagonals
     
end


local function zoneHandler(event)
   -- convert the tap position to 3x3 grid position 
   --   based on the board size
   local x, y = event.target:contentToLocal(event.x, event.y);
   x = x + 225;  -- conversion
   y = y + 225;  -- conversion
   x = math.ceil( x/150 );
   y = math.ceil( y/150 );
	
   if (game.mark(x,y)==false) then   --bad move
   	return;
   end
   
   zone:removeEventListener("tap", zoneHandler);
   Runtime:dispatchEvent({name="moved", x=x, y=y}); 

   checkWin();
end
-- zone:addEventListener("tap", zoneHandler);

function game.activate ()
  zone:addEventListener("tap", zoneHandler);
end

function game.mark (x,y)
  if (board[x][y] ~= -1) then  -- space not empty!
    return false;
  end

  -- mark the game board (logical)
  board[x][y] = player; 
  --place the piece on the board (visual)
  local _x, _y = 
   zone:localToContent(75+150*(x-1) - 225, 75+150*(y-1) - 225);
  piece:new(player, _x, _y);	
  player = (player + 1) % 2;

  return true;
end

function game.setPlayer(num)
  player = num;
end


return game;
