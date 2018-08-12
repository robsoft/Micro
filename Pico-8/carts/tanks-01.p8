pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- main

function _init()
 // tweak 1,2,3, will put this
 // in menu soon!
 cur_map = 2


 timer = 0
 // how many frames 
 // between 'inputs'
 // make this lower to speed it
 // up, at 1 you go same speed
 // as a shot (but turning hard)
 timer_rst = 3
 
 screen = in_splash
 // this is a timer to make the
 // player wait before he can
 // shoot again
 shottimer_rst = 15
 // this is how long a shot lasts
 // for
 shot_dur = 105
 // over water, shot duration
 // goes down quickly
 water_shot = 11
 
 splash_timer=0
 menu_timer=0
 
	setup_vars()
	setup_gfx()
	setup_shots()
	setup_bounce()

 // how far into the maps is
 // the map we want to use?
	map_ofs=(cur_map-1)*16
	
	// finally, we start with the
	// splash
	cur_screen=in_splash
	
end


function _draw()
 if cur_screen==in_splash then
  draw_splash()
 elseif cur_screen==in_menu then
  draw_menu()
 else if cur_screen==in_game then
  draw_game()
 else
  draw_gameover()
 end  
end


function _update()
 if cur_screen==in_menu then
  update_menu()
 elseif cur_screen==in_splash then
  update_splash()
 elseif cur_screen==in_gameover then
  update_gameover()
 else  
  update_game()
 end
end

function update_game()
 // only check inputs if timer fires
 if timer<=0 then
  move_tank(p1,p2)
  move_tank(p2,p1)
  timer=timer_rst
 end
	timer-=1  

 // hold off 'reload'
 if p1.shottimer>0 then p1.shottimer-=1 end
 if p2.shottimer>0 then p2.shottimer-=1	end
 
	move_shots()
 check_hits()
 end
end

function update_splash()
 splash_timer+=1
 if btnp(4,0) or btnp(5,0) 
   or (splash_timer>150) then
  menu_timer=0
  cur_screen=in_menu
 end
end

function update_menu()
 if btnp(5,0) or btnp(4,0) then
  // wait for the buttons to be released
  repeat
  until btn(5,0)==false and btn(4,0)==false
    
  init_game()
    
  cur_screen=in_game
  return
 end
 
 menu_timer+=1
 if menu_timer>320 then
  splash_timer=0
  cur_screen=in_splash
 end
end



function update_gameover()
 if btnp(4,0) or btnp(5,0) then
  cur_screen=in_menu
 end
end

function init_game()
	setup_players()
end

-->8
-- menu

function draw_menu()
 cls(0)
 print("tanks...v0.1",42,2,4)
 print("2 players only, no 1 player yet!",0,26,4)
 print("shots travel over water, but not",0,42,4)
 print("as far as over land. shots can't",0,50,4)
 print("pass through mountains, but they",0,58,4)
 print("will bounce 🐱",38,66,4)

 print("change cur_map at top of tab 0",6,92,1)
 print("=1,2 or 3 for different maps",10,98,1)
 print("❎ to start",42,110,4)
 
end

function draw_splash()
 map(0,16,0,0,16,16)
 print("robsoft",6,120,2)
end

function draw_gameover()
 cls(3)
 print("game over!",42,2,0)
 print("❎ to continue",32,24,0)
end


-->8
-- game draw

function draw_game() 
 cls(3)
 map(map_ofs+0,0,0,0,16,16)
 // order is important here
 draw_shots()
 draw_tank(p1)
 draw_tank(p2)
 draw_stats()
 // draw a line along top 
 // to show frame rate - closer to
 // right, the more cpu used
 if debug then 
  line(0,0,stat(1)*128,0,15)
 end
end

function draw_shots()
 for shot in all(shots) do
  if shot.dur>0 then
   pset(shot.x,shot.y,0)
  end
 end
end
 
function draw_stats()
 rectfill(0,0,128,7,0)
 for x=1,min(p1.lives,5) do
  spr(1,(x-1)*8,0)
 end
 for x=1,min(p2.lives,5) do
  spr(4,120-((x-1)*8),0)
 end

 // cheat for score
 local p1s=10000+p1.score
 local p2s=10000+p2.score
 print(sub(p1s,2,5).." : "..sub(p2s,2,5),44,1,9)
end


function draw_tank(player)
 local sprline = tankspr[player.dirt]
 local sprt = sprline[1] + ((player.id-1)*3)+1

 spr(sprt, player.x, player.y, 1, 1, 
     sprline[2], sprline[3])
end
  
-->8
-- player update

// look at direction, 
// figure out next position
function get_x(player)
 if player.dirt==2 or
    player.dirt==3 or
    player.dirt==4 then 
     return player.x + 1
 end
 if player.dirt==8 or
    player.dirt==7 or
    player.dirt==6 then 
     return player.x - 1
 end
 return player.x
end

// figure out new position
function get_y(player)
 if player.dirt==8 or
    player.dirt==1 or
    player.dirt==2 then 
     return player.y - 1
 end
 if player.dirt==4 or
    player.dirt==5 or
    player.dirt==6 then 
     return player.y + 1
 end
 return player.y
end

// trigger off a shot
function start_shot(player)
 // make sure player can't fire
 // again for a while
 player.shottimer=shottimer_rst
 // copy the player's direction
 shtln=shotfs[player.dirt]
 newshot = {
  id=player.id, 
  dirt=player.dirt,
   x=player.x+shtln.x,
   y=player.y+shtln.y, 
   dur=shot_dur}
 add(shots, newshot)
 sfx(1)
end      

// move the give player, taking
// into account collisions with
// the other plater and scenery
function move_tank(player,other)
 plr=player.id-1 // shortcut
 
 if btn(2,plr) then
  old_x = player.x
  old_y = player.y
  new_x = get_x(player)
  new_y = get_y(player)
  // test if we need to clip
  player.x = mid(0,new_x,120)
  player.y = mid(7,new_y,120)

  // will we hit the other player
  o=other.x
  p=other.y
  x=player.x
  y=player.y
  // messy. the 6 is width of tank
  if (((x+6>=o) and (x+6<=o+6))
      or
     ((x>=o) and (x<o+6)))
     and
     (((y+6>=p) and (y+6<=p+6))
      or
     ((y>=p) and (y<p+6))) then
   player.x=old_x
   player.y=old_y
  end
   
  // look at map, we okay?
  mx=flr(0.5 + (player.x/8))
  my=flr(0.5 + (player.y/8))
  newmap=mget(map_ofs+mx, my)
  // bit 0 of the 'wall' sprite
  // gets tested
  if fget(newmap,0) then
   // okay we can't make the move
   player.x=old_x
   player.y=old_y
  end    
  
  // did we clip/abandon move?
  if (player.x==old_x) and (player.y==old_y) then
   sfx(3)
  end
 end
 
 // kick off a shot?
 if btn(5,plr) and (player.shottimer==0) then
  start_shot(player)
 end
 
 // turn left & right
 if btn(0,plr) then player.dirt-=1 end
 if btn(1,plr) then player.dirt+=1 end
 // wrap round our turning
 if player.dirt<1 then player.dirt=8 end
 if player.dirt>8 then player.dirt=1 end
end

-->8
-- setup

function setup(play,id,x,y,dirt,colour)
 play.x = x
 play.y = y
 play.id = id
 play.dirt = dirt
 play.shottimer = 0
 play.score = 0
 play.lives = 3
 play.colour = colour
end

function setup_vars()
 in_splash = 1
 in_menu = 2
 in_game = 3
 in_end = 4
end


function setup_shots()
 shots={}
 
 // this controls the offset for the bullet
 // when first fired, 
 // based on the players x,y
 shotfs={}
 local shtline={x=4,y=0}
 add(shotfs,shtline)
 local shtline={x=6,y=2}
 add(shotfs,shtline)
 local shtline={x=6,y=4}
 add(shotfs,shtline)
 local shtline={x=5,y=6}
 add(shotfs,shtline)
 local shtline={x=4,y=7}
 add(shotfs,shtline)
 local shtline={x=2,y=6}
 add(shotfs,shtline)
 local shtline={x=1,y=4}
 add(shotfs,shtline)
 local shtline={x=1,y=2}
 add(shotfs,shtline)
end

function setup_gfx()
 // green will be transparent
 palt(3,true)
 // setup our array of sprite numbers & h/v flips
 tankspr = {}
 local sprline = {0,false,false}
 add (tankspr,sprline)
 local sprline = {1,false,false}
 add (tankspr,sprline)
 local sprline = {2,false,false}
 add (tankspr,sprline)
 local sprline = {1,false,true}
 add (tankspr,sprline)
 local sprline = {0,false,true}
 add (tankspr,sprline)
 local sprline = {1,true,true}
 add (tankspr,sprline)
 local sprline = {2,true,true}
 add (tankspr,sprline)
 local sprline = {1,true,false}
 add (tankspr,sprline)
end

function setup_players()
 p1 = {}
 p2 = {}
 setup(p1,1,8,64,3,11)
 setup(p2,2,112,64,7,6)
end

function setup_bounce()
 bounce1={5,8,7,6,1,4,3,2}
 bounce2={1,4,3,2,5,8,7,6}
end
-->8
function move_shots()
 for shot in all(shots) do
  if shot.dur>0 then
   local new_x=get_shot_x(shot)
   local new_y=get_shot_y(shot)
   // clip = stop
   shot.x=mid(0,new_x,128)
   shot.y=mid(7,new_y,128)
   if (shot.x!=new_x) or (shot.y!=new_y) then
    shot.dur=0
   else
    shot.dur-=1
   end
  end
  // if we've flicked duration to zero, kill the shot
  if shot.dur<=0 then del(shots,shot) end
 end
end

function get_shot_x(shot)
 if shot.dirt==2 or
    shot.dirt==3 or
    shot.dirt==4 then 
     return shot.x + 1
 end
 if shot.dirt==8 or
    shot.dirt==7 or
    shot.dirt==6 then 
     return shot.x - 1
 end
 return shot.x
end

function get_shot_y(shot)
 if shot.dirt==8 or
    shot.dirt==1 or
    shot.dirt==2 then 
     return shot.y - 1
 end
 if shot.dirt==4 or
    shot.dirt==5 or
    shot.dirt==6 then 
     return shot.y + 1
 end
 return shot.y
end

function check_hits()
 // crude, we can check pixel colours for
 // each shot, as we draw the tanks after the shots
 for shot in all(shots) do
  local colr = pget(shot.x, shot.y)
  if (colr==p1.colour) then
   handle_hit(shot,p1,p2)
  elseif (colr==p2.colour) then
   handle_hit(shot,p2,p1)  
  elseif (colr==5) then
   bounce_shot(shot)
  elseif (colr==12) or (colr==7) then
   shot.dur-=water_shot
   sfx(5)
  elseif (colr!=3) then
   shot.dur=0
  end
  // time to e-o-l the shot?
  if shot.dur<=0 then
   del(shots,shot)
  end
 end
end

// the shot hit bounceable scenery
function bounce_shot(shot)
 local old=shot.dirt
 // flip the shot's direction
 shot.dirt=bounce1[shot.dirt]
 // still hit?
 local new_x=get_shot_x(shot)
 local new_y=get_shot_y(shot)
 if pget(new_x, new_y)==5 then
  shot.dirt=bounce2[old]
  local new_x=get_shot_x(shot)
  local new_y=get_shot_y(shot)
  if pget(new_x, new_y)==5 then
   if (old>4) shot.dirt=8-old else shot.dirt=4+old
  end 
 end     
 sfx(4)
end

// deal with getting hit
function handle_hit(shot,struck,other)
 sfx(2)
 other.score+=1
 struck.lives-=1
 shot.dur=0
 // player who was hit gets
 // their shot timer reset
 struck.shottimer=0
 // victime out of lives?
 if struck.lives<0 then 
  gameover() 
 end
end  
  

function gameover()
 // feel like more to do here
 cur_screen=in_gameover
end

__gfx__
0000000033333333333b33333333333333333333333633333333333333cccccccccccc33cccccccccccccccccccccccccc333333333333cc3333333333333333
00000000333bb33333b33bb33bbbbb333336633333633663366666333ccc77cccccc77c3cccc77cccccc77cccccc77ccc33333333333333c3333333333333333
007007003b3bb3b33bbbbbb333bbb333363663633666666333666333cccccccccccccccccccccccccccccccccccccccc33333333333333333333333333333333
000770003bbbbbb3bbbbbb3333bbbbb3366666636666663333666663cccccccccccccccccccccccccccccccccccccccc33333333333333333333333333333333
000770003bbbbbb3b3bbbb3b33bbbbb3366666636366663633666663ccc77cccccc77cccccc77cccccc77cccccc77ccc33333333333333333333333333333333
007007003bbbbbb3333bbbb333bbb333366666633336666333666333c77cc7ccc77cc7ccc77cc7ccc77cc7ccc77cc7cc33333333333333333333333333333333
000000003b3333b33333bb333bbbbb33363333633333663336666633ccccccccccccccccccccccc33ccccccccccccccc3333333333333333c33333333333333c
0000000033333333333bb33333333333333333333336633333333333cccccccccccccccccccccc3333cccccccccccccc3333333333333333cc333333333333cc
00000000333333333355555555555533555555555555555555555555553333333333335533333333333333330000000000000000000000000000000000000000
00000000333333333555555555555553555555555555555555555555533333333333333533333333333333330000000000000000000000000000000000000000
00000000333333335555555555555555555555555555555555555555333333333333333333333333333333330000000000000000000000000000000000000000
00000000333333335555555555555555555555555555555555555555333333333333333333333333333333330000000000000000000000000000000000000000
00000000333333335555555555555555555555555555555555555555333333333333333333333333333333330000000000000000000000000000000000000000
00000000333333335555555555555555555555555555555555555555333333333333333333333333333333330000000000000000000000000000000000000000
00000000333333335555555555555555555555533555555555555555333333333333333353333333333333350000000000000000000000000000000000000000
00000000333333335555555555555555555555333355555555555555333333333333333355333333333333550000000000000000000000000000000000000000
00000000000000000000000077777777777777777777767777777777777777777777777777777777777777777777777777777677777777777777777777777777
00000000000000000000000077777777777777777776677777777777777766777777777777777777777777777777777777766777777777777777667777777777
00000000000000000000000077777777777777777766777777777777777667777777777777777777777777777777777777667777777777777776677777777777
00000000000000000000000077777777777777777667777777777777766777777777777777777777777777777777777776677777777777777667777777777777
0000000000000000000000007777777777777777667777777777777766777777777777777ff77777777777777777777766777777777777776677777777777777
0000000000000000000000007777777777777777677777777777776677777777777777fff77777777777777777777777677777777777776677777777777777ff
000000000000000000000000777777767777777d67777777777776c7777777777777fff777777777777777777777777d67777777777776c7777777777777fff7
00000000000000000000000077777767777777d6777777777777dd777777777777fef7777777777777777777777777d6777777777777dd777777777777fef777
7777777777777777777777777777766777777777777cd777777777777ee77777777777777777777777777777556777777776ccc77777777f888f777777777777
777777777777777777777777777765777777777777cc77777777777f4f777777777777777777777777777776b6777777777ccc67777777748447777777777777
77777777777777777777777777775677777777776cc777777777774477777777777777777777777777777775b677777777dccc77777777e848e7777777777777
777777777777777777777777777dd77777777776cc6777777777f4477777777777777777777777777777776bd777777776cccd7777777f8448f7777777777777
7ff777777777777777777777776b67777777777cc6777777777f84777777777777777777777777777777775b677777777cccc6777777748448f7777777777777
f7777777777777777777777776b67777777777ccd777777777f88f7777777777777777777777777777777655677777776cccc7777777f84488f7777777777777
7777777777777777777777777d57777777777dcc777777777f84f7777777777777777777777777777777755577777777ccccc777777748448877777777777777
7777777777777777777777776b67777777776cc677777777f84477777777777777777777777777777777655677777776cccc6777777f844488f7777777777777
0000000000000000777777777777d5567777777ccccc6777777e844448f777777777777700000000000000000000000000000000000000000000000000000000
000000000000000077777777777655567777776ccccc67777774844448e777777777777700000000000000000000000000000000000000000000000000000000
00000000000000007777777777765557777777cccccc677777f88444484777777777777700000000000000000000000000000000000000000000000000000000
000000000000000077777777777d55d7777776cccccc677777f84444488f77777777777700000000000000000000000000000000000000000000000000000000
00000000000000007777777777655567777776cccccc677777e84488848e77777777777700000000000000000000000000000000000000000000000000000000
000000000000000077777777776b5b6777777ccccccc677777e844888448f7777777777700000000000000000000000000000000000000000000000000000000
00000000000000007777777777d55b6777776ccccccc677777e84488884847777777777700000000000000000000000000000000000000000000000000000000
00000000000000007777777776555b6777776ccccccc67777748488888848e777777777700000000000000000000000000000000000000000000000000000000
00000000000000007777777776b5556777776ccccccc677777484888888848e77777777777777777777777777777777777777777777777770000000000000000
00000000000000007777777776b555677777ccccccccd77777e848888888848e7777777777777777777777777777777777777777777777770000000000000000
0000000000000000777777777d5555677777ccccccccc77777e8488888888888e777777777777777777777777777777777777777777777770000000000000000
000000000000000077777777755555677776ccccccccc67777e848888888888884f7777777777777777777777777777777777777777777770000000000000000
000000000000000077777777655555677776cccccccccd7777f8488888888888488e777777777777777777777777777777777777777777770000000000000000
0000000000000000777777776b5555677776cccccccccc7777f888888888888884884f7777777777777777777777777777777777777777770000000000000000
0000000000000000777777776b555b677776cccccccccc677774888888888888888888ef77777777777777777777777777777777777777770000000000000000
000000000000000077777777d5555b677776ccccccccccc7777e88888888888888888888ef777777777777777777777777777777777777770000000000000000
000000000000000077777777d55555677776ccccccccccc6777f8888888888888888888888ef7777777777777777777777777777777777770000000000000000
000000000000000077777777d55555d77776cccccccccccc77778888888888888888888888888ef7777777777777777777777777777777770000000000000000
000000000000000077777777555555577776cccccccccccc6777e8488888888888888888888888884eff77777777777777777777777777770000000000000000
000000000000000077777777555555567776ccccccccccccc677f88888888888888888888888888888888eeeffff777777ffffff777777770000000000000000
000000000000000077777777555555567776cccccccccccccc777e84888888888888888888888888888888888888f7777e888888f77777770000000000000000
000000000000000077777776555555567776ccccccccccccccc77788888888888888888888888888888888888888f7777f888888f77777770000000000000000
0000000000000000777777765555555d7777ccccccccccccccc677f8888888888888888888888888888888888888f7777f888888f77777770000000000000000
000000000000000077777776555555556777cccccccccccccccc677e888888888888888888888888888888888888f7777f888888f77777770000000000000000
0000000000000000777777765555555567776cccccccccccccccc677488888888888888888888888888888888888f7777f888888f77777770000000000000000
00000000000000007777777755555555d7776ccccccccccccccccc67788888888888888888888888888888888888f7777f888888f77777770000000000000000
0000000000000000777777775555555556777cccccccccccccccccc6778888888888888888888888888888888888f7777f888888f77777770000000000000000
0000000000000000777777775555555556777dccccccccccccccccccc77888888888888888888888888888888888f7777f888888f77777770000000000000000
000000000000000077777777d55555555d7776cccccccccccccccccccc67e8888888888888888888888888888888f7777f888888f77777770000000000000000
000000000000000077777777d5555555556776ccccccccccccccccccccc67e888888888888888888888888888888f7777f888888f77777770000000000000000
0000000000000000777777776b55555555d777dcccccccccccccccccccccc6f88888888888888888888888888888f7777f888888f77777770000000000000000
0000000000000000777777776b5555555556776ccccccccccccccccccccccc66e888888888888888888888888888f7777f888888f77777770000000000000000
0000000000000000777777776b555555555d777ccccccccccccccccccccccccc6e88888888888888888888888888f7777f888888f77777770000000000000000
0000000000000000777777776555555555556776ccccccccccccccccccccccccccde888888888888888888888888f7777f888888f77777770000000000000000
0000000000000000777777777555555555555677ccccccccccccccccccccccccccccdd4888888888888888888888f7777f888888f77777770000000000000000
0000000000000000777777777d55555555555d776ccccccccccccccccccccccccccccccdd8888888888888888888f7777f888888f77777770000000000000000
00000000000000007777777776b55555555555677ccccccccccccccccccccccccccccccccddd4888888888888888f7777f888888f77777770000000000000000
000000000000000077777777765555555555555676cccccccccccccccccccccccccccccccccccddd448888888888f7777e888888f77777770000000000000000
000000000000000077777777775555555555555d776cccccccccccccccccccccccccccccccccccccccddddd44448f7777f844448f77777770000000000000000
00000000000000007777777777d5555555555555677cccccccccccccccccccccccccccccccccccccccccccccccdc677776cccccc677777770000000000000000
00000000000000007777777777655555555555555676cccccccccccccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
000000000000000077777777776555555555555555676ccccccccccccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
000000000000000077777777777d555555555555555676cccccccccccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
00000000000000007777777777765555555555555d5567cccccccccccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
000000000000000077777777777755555555555555d5567ccccccccccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
0000000000000000777777777777655555555555555d5567cccccccccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
00000000000000007777777777776555555555555555d5567ccccccccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
00000000000000007777777777777d555555555555555d5566cccccccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
0000000000000000000000007777765555555555555555dd5666cccccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
000000000000000000000000777777d55555555555555dddd5666ccccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
000000000000000000000000777777655555555555555ddddd5a66cccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
0000000000000000000000007777777d5555555555555ddddddd466ccccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
00000000000000000000000077777776555555555555ddddddddd5a6dccccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
00000000000000000000000077777777655555555555dddddddddddaddcccccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
00000000000000000000000077777777755555555555dddddddddddddaddcccccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
00000000000000000000000077777777765555555555ddddddddddddddaaddcccccccccccccccccccccccccccccc677776cccccc677777770000000000000000
0000000000000000000000007777777777d555555555ddddddddddddddddaaddcccccccccccccccccccccccccccc677776cccccc677777770000000000000000
00000000000000000000000077777777777555555555ddddddddddddddddddaadddccccccccccccccccccccccccc677776cccccc677777770000000000000000
00000000000000000000000077777777777655555555ddddddddddddddddddddaaadddcccccccccccccccccccccc677776cccccc677777770000000000000000
00000000000000000000000077777777777765d55555ddddddddddddddddddddddaaaa6ddccccccccccccccccccc677776cccccc677777770000000000000000
0000000000000000000000007777777777777d5d555ddddddddddddddddddddaaaddaaaaa66ddccccccccccccccc677776cccccc677777770000000000000000
00000000000000000000000077777777777777d5d55dddddddddddddddddddddaaaaa6aaaaaaaa666ddccccccccc677776cccccc677777770000000000000000
00000000000000000000000077777777777777655d5ddddddddddddddddddddaaaaaaaaaa6aaaaaaaaaa6666666d677776d66666777777770000000000000000
000000000000000000000000777777777777777655d5dddddddddddddddddddaaaaaaaaaaaaaa6aaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
0000000000000000000000000000000077777777655d5ddddddddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaa66a67777faaaaaa777777770000000000000000
00000000000000000000000000000000777777777655dddddddddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaa6a67777faaaaaa777777770000000000000000
000000000000000000000000000000007777777777655ddddddddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
0000000000000000000000000000000077777777777655dddddddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
00000000000000000000000000000000777777777777655ddddddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
0000000000000000000000000000000077777777777776d5ddddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
0000000000000000000000000000000077777777777777765dddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
00000000000000000000000000000000777777777777777765ddddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
00000000000000000000000000000000000000007777777776d5ddddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
00000000000000000000000000000000000000007777777777765dddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
00000000000000000000000000000000000000007777777777776a5dddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
0000000000000000000000000000000000000000777777777777776aaddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
000000000000000000000000000000000000000077777777777777766aaddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
0000000000000000000000000000000000000000777777777777777776aaaddaaaaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
000000000000000000000000000000000000000077777777777777777776aaaa6aaaaaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
000000000000000000000000000000000000000077777777777777777777766aaa66aaaaaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
00000000000000000000000000000000000000000000000077777777777777766aaaa66aaaaaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
00000000000000000000000000000000000000000000000077777777777777777666aaaa66aaaaaaaaaaaaaaaaaa67777faaaaaa777777770000000000000000
00000000000000000000000000000000000000000000000077777777777777777777666aaaaa666aaaaaaaaaaaaa67777faaaaaa777777770000000000000000
00000000000000000000000000000000000000000000000077777777777777777777777666aaaaaaa6666aaaaaaa67777faaaaaa777777770000000000000000
0000000000000000000000000000000000000000000000007777777777777777777777777776666aaaaaaaaaaa6a67777faaaaaa777777770000000000000000
0000000000000000000000000000000000000000000000007777777777777777777777777777777766666aaaaaaa67777faaaaaa777777770000000000000000
00000000000000000000000000000000000000000000000077777777777777777777777777777777777777777777777777ffffff777777770000000000000000
00000000000000000000000000000000000000000000000077777777777777777777777777777777777777777777777777777777777777770000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000077777777777777777777777777777777777777770000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000077777777777777777777777777777777777777770000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000077777777777777777777777777777777777777770000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000077777777777777777777777777777777777777770000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000077777777777777777777777777777777777777770000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000077777777777777777777777777777777777777770000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000077777777777777777777777777777777777777770000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000077777777777777777777777777777777777777770000000000000000
__gff__
0000000000000001010101010000000000000101010101000000000000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2120202020202020202020202020202121202020202020202020202020202021212020202020202020202020202020212020100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111111111111111111111111110b0b0c11111111111111111111181516111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111611111111111116111111110b091111111111111111111111111815111111111111161111161111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111161616161616161611111111090c1111111111111111111111111118111116161111161616161111161611111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111116161616161616161111111111111111111111111111111111111111111116111111111111111111111611111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111116161111111111111111111111111216161319111111111111111116111111161616161111111611111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111111111111111111111111616161616131111111111111616111111111111111111111616111111101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111161111111111111111111116111111111111111617111118141111111111111111111116161616161611111111111111101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111161111111111111111111116111111111111111619111111111111111111111111111116161616161611111111111111100000100000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111161111111111111111111116111111111111111513191111111107081111111111111116161616161611111111111111101000101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111111111111111111111111111111111111181513191111110a091111111616111111111111111111111616111111101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111116161111111111111111111111111118161319111111111111111116111111161616161111111611111111101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111116161616161616161111111111111111111112161616131911111111111116111111111111111111111611111111101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111111616161616161616111111111111111a121614171118151319111111111116161111161616161111161611111111101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111116111111111111161111111111111112141711111111181513111111111111111111161111161111111111111111101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131313131313131313131313131313120202020202020202020202020202020202020202020202020202020202020202020102020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
31313131232c2d2e2f2e31313131313110101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131313133343536373131313131313110101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131393a3b3c3d3e313131313131313110101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131424344454647483131313131313110101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
313152535455565758595a5b5c5d313110101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
313162636465666768696a6b6c6d313110101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
313172737475767778797a7b7c7d313110101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
313182838485868788898a8b8c8d313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
313192939495969798999a9b9c9d313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
313131a3a4a5a6a7a8a9aaabacad313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
313131b3b4b5b6b7b8b9babbbcbd313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3131313131c5c6c7c8c9cacbcccd313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
313131313131d6d7d8d9dadbccdd313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
313131313131e6e7e8e9eaebeced313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
313131313131313131f9fafbfcfd313100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000300000505003750027500175001750017300001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000e65009650066500465001630016300162001620016100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000267002670056700767005670026700266001660016500265003650026500264001640016400264002640026400163001630016200162001620016200161001610016100160001600000000000000000
000200000805009050090500705005030050200301000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000775006740047300172000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005000021050200401f0301e0301b0301903017030140200f0200901009000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000