local square = {name="square"};

function square:new (o)    --constructor
  o = o or {}; -- recall how OR works  
  setmetatable(o, self);
  self.__index = self;
  return o;
end

function square:spawn()
 self.shape = display.newRect (self.x, self.y, 30,30);
 self.shape.pp = self;  
 self.shape.markX = self.shape.x;
 self.shape.markY = self.shape.y;
end

function square:touch (event)	
 if event.phase == "began" then		
   self.shape.markX = self.shape.x;
   self.shape.markY = self.shape.y;
 elseif event.phase == "moved" then	 	
   self.updated=true;	 	
   local x = (event.x - event.xStart) + self.shape.markX;
   local y = (event.y - event.yStart) + self.shape.markY;	
   self.shape.x = x;		
   self.shape.y = y;
 end
end

return square;

