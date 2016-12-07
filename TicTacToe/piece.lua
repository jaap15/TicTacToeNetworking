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
function piece:new (o)    --constructor
  -- Standard Corona class construction
  o = o or {}; 
  setmetatable(o, self)
  self.__index = self
  return o
end

function piece:create(id, type, x, y)
  self.id = id
  self.type = type
  self.x = x
  self.y = y

  -- Piece is an O
  if (type == 0) then
    self.shape = display.newCircle (x,y, display.contentWidth/10.8)
    self.shape:setFillColor (1,0,0)
  else
    -- Piece is an X
    self.shape = display.newRect (x,y, display.contentWidth/5.4, display.contentHeight/10.8)
    self.shape.rotation= 45
    self.shape:setFillColor (0,0,1)
  end
end

function piece:remove()
  if (self.shape ~= nil) then
    self.shape:removeSelf()
    self.shape = nil
  end
end
return piece