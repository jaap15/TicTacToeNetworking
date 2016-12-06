-----------------------------------------------------------------------------------------
--
-- piece.lua
--
-- Authors: Daniel Burris, Jairo Arreola
--
-- This class represents an X or O piece. He is placed whenever a square is tapped.
-----------------------------------------------------------------------------------------

local piece = { }

-- piece:new()
--      input: type, x, y
--      output: piece object
--
--      Constructor method. He is given an type (0 (O) or 1 (X)) and x,y coordinates
--      Using these parameters he draws himself and is placed on the board.
function piece:new (type, x, y)    --constructor
  
  -- Standard Corona class construction
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.type = type

  -- Piece is an O
  if (type == 0) then
  	o.shape = display.newCircle (x,y, display.contentWidth/10.8)
  	o.shape:setFillColor (1,0,0)
  else
    -- Piece is an X
  	o.shape = display.newRect (x,y, display.contentWidth/5.4, display.contentHeight/10.8)
  	o.shape.rotation= 45
  	o.shape:setFillColor (0,0,1)
  end

  -- Returning my newly created object
  return o
end
return piece