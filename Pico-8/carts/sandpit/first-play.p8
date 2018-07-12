pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- rob lua pico play
local player
local backclr=2

function _init()  
  player={
    x=10, 
    y=10, 
    colour=1, 
    size=10
  }
end


function _update()
 if btn(1) and player.x<127 then
   player.x+=1
 end
 if btn(0) and player.x>0 then
   player.x-=1
 end
 if btn(2) and player.y>0 then
   player.y-=1
 end
 if btn(3) and player.y<127 then
   player.y+=1
 end
 -- dont let us set colour to same as background
 if btnp(4) then
   player.colour+=1
   if (player.colour==backclr) player.colour+=1
   if (player.colour>15) player.colour=0
 end
 -- limit the size
 if btnp(5) then
   player.size+=1
   if (player.size>20) player.size=2
 end
end

function _draw()
  cls(backclr)
  rectfill(
    player.x,
  	 player.y,
  	 player.x+player.size,
  	 player.y+player.size,
  	 player.colour)
  print(
    "x:"..player.x..
  	 " y:"..player.y..
  	 " s:"..player.size..
  	 " c:"..player.colour,
  	 0,0,14)
end
