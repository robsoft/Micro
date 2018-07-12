pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- thanks to bridgs on youtube for her excellent tutorials


local player
local bombs
local score
local show_bounds

function _init()
	score=0

  -- debug
	show_bounds=false

	player={
	  	x=64,
  		y=64,
  		width=7,
  		height=7,
  		color=12,
  		speed=1,
      xmax=128-7,
      ymax=128-7,
  		update=function(self)
		    if (btn(0)) self.x-=self.speed
		    if (btn(1)) self.x+=self.speed
	    	if (btn(2)) self.y-=self.speed
	    	if (btn(3)) self.y+=self.speed
        if (self.x>self.xmax) self.x=self.xmax
        if (self.y>self.ymax) self.y=self.ymax
        if (self.x<0) self.x=0
        if (self.y<0) self.y=0
  		end,

    	draw=function(self)
    		spr(1, self.x, self.y)
    		if (show_bounds) rect(self.x, self.y, self.x+self.width, self.y+self.height, 14)
  		end,

  		check_for_collision=function(self,bomb)
          if (not bomb.collected) and rects_overlapping(self.x, self.y, self.x+self.width, self.y+self.height,
          		bomb.x, bomb.y, bomb.x+bomb.width, bomb.y+bomb.height)	then
            bomb.collected=true
            score+=1
          end
  		end
 	}

 	make_bombs_list()
end


function _draw()
  cls(4)

  print(score,0,0)

  player:draw()

  local bomb
  for bomb in all(bombs) do
  	bomb:draw()
  end
end



function _update()
  player:update()
  local bomb
  local spare_bombs=0

  for bomb in all(bombs) do
    bomb:update()
    player:check_for_collision(bomb)
    if (not bomb.collected) spare_bombs+=1
  end

  if (spare_bombs==0) then
  	-- make new bombs
  		make_bombs_list()
  	end
end

function make_bombs_list()
  bombs={}
  -- need to sort out how to get initial position checked against width & height in the constructor
  for loop = 1, 5, 1 do
    add(bombs, make_bomb( flr(rnd(121)), flr(rnd(122)) ) )
  end
end


function make_bomb(x,y)
	local bomb
  -- need to learn how to create this nicely - want to ensure x and y are within legal bounds given width and height
	bomb={
	  	x=x,
  		y=y,
  		dir=1 + flr(rnd(4)),
  		width=6,
  		height=5,
  		collected=false,
  		xmax=128-6,
  		ymax=128-5,
      speed=1+flr(rnd(3)),

  		update=function(self)
  		  if (self.dir==1) self.x-=self.speed
  		  if (self.dir==2) self.x+=self.speed
  		  if (self.dir==3) self.y-=self.speed
  		  if (self.dir==4) self.y+=self.speed
  		  if (self.x<0) self.x=0 self.dir=2
  		  if (self.x>self.xmax) self.x=self.xmax self.dir=1
  		  if (self.y<0) self.y=0 self.dir=4
  		  if (self.y>self.ymax) self.y=self.ymax self.dir=3
    	end,

    	draw=function(self)
    	  if (not self.collected) then
    		  spr(2,self.x,self.y-1)
    		  if (show_bounds) rect(self.x, self.y, self.x+self.width, self.y+self.height,12)
    	  end
		  end
	}
	return bomb
end


function is_point_in_rect(x,y,left,top,right,bottom)
  return top<y and y<bottom and left<x and x<right
end

function lines_overlapping(min1, max1, min2, max2)
  return (max1 > min2) and (max2 > min1)
end

function rects_overlapping(left1, top1, right1, bottom1, left2, top2, right2, bottom2)
  return lines_overlapping(left1, right1, left2, right2) and lines_overlapping(top1, bottom1, top2, bottom2)
 end

function circles_overlapping(x1,y1,r1,x2,y2,r2)
  local dx=mid(-100,x2-x1,100)
  local dy=mid(-100,y2-y2,100)
  return dx*dx+dy*dy < (r1+r2) * (r1+r2)
end


__gfx__
00000000441111444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000041aaaa144411114400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007001aaacca141cccc1400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770001aaaaca11ccc7cc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770001aaaaaa11cccc7c100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007001aaaaaa11cccccc100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000041aaaa1441cccc1400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000441111444411114400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
