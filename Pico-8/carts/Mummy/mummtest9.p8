pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- oh mummy
-- adam miller

function _init()
 init_system()
 screen=scr_highscores
 //screen=scr_instructions
end

function _draw()
 if (screen==scr_game) then draw_game()
 elseif (screen==scr_level_cleared) then draw_level_cleared()
 elseif (screen==scr_menu) then draw_menu()
 elseif (screen==scr_gameover) then draw_gameover()
 elseif (screen==scr_highscores) then draw_highscores()
 elseif (screen==scr_settings) then draw_settings()
 else draw_instructions()
 end
end

function _update()
 if (screen==scr_game) then update_game()
  elseif (screen==scr_level_cleared) then update_level_cleared()
 elseif (screen==scr_menu) then update_menu()
 elseif (screen==scr_gameover) then update_gameover()
 elseif (screen==scr_highscores) then update_highscores()
 elseif (screen==scr_settings) then update_settings()
 else update_instructions()
 end
end


-->8
-- game draw logic

function draw_game()
 cls()
 map(0,0,0,0,16,16)
 scr=score_to_string(p.score)
 print("score:"..scr,10,8,0)
 if (p.scroll!=0) spr(map_scrl,16,16)
 for l=1,min(p.lives,5) do
  spr(player_live, 64+(l*8),8)
 end 
 
 if p.dir==dir_up then
   spr(pup[player_frame], p.x*8, (p.oldy*8)-player_frame+1)
 elseif p.dir==dir_down then
   spr(pdown[player_frame], p.x*8, (p.oldy*8)+player_frame-1)
 elseif p.dir==dir_left then
   spr(pleft[player_frame], (p.oldx*8)-player_frame, p.y*8)
 elseif p.dir==dir_right then
   spr(pright[player_frame], (p.oldx*8)+player_frame, p.y*8)
 end 
 
 for mummy in all(mummies) do
  mframe=flr(mummy.frame)
  //if (mummy.active==true) then
   // hack palette in case we
   // want to change mummy color
   pal(mummy_col,mummy.color)
   if mummy.dir==dir_up then
    spr(mup[mframe], mummy.x*8, (mummy.oldy*8)-mummy.frame+1)
   elseif mummy.dir==dir_down then
    spr(mdown[mframe], mummy.x*8, (mummy.oldy*8)+mummy.frame-1)
   elseif mummy.dir==dir_left then
    spr(mleft[mframe], (mummy.oldx*8)-mummy.frame, mummy.y*8)
   elseif mummy.dir==dir_right then
    spr(mright[mframe], (mummy.oldx*8)+mummy.frame, mummy.y*8)
   end
   // restore palette 
   pal()
  //end
 end         
end


-->8
-- game update logic

function update_game()
 if (player_frame==1) and 
    (p.x==p.oldx) and 
    (p.y==p.oldy) then
  
  // first off, set the floor
  // as we have potentially just
  // finished a move
  this_tile=mget(p.x, p.y)
  if (this_tile==map_walk) then
   complete_step_and_check()
  end

 // level done?
if (p.key>0) and (p.royal>0) and (p.x==door.x) and (p.y==door.y) then
  // okay level done
  screen=scr_level_cleared
  return
end

  // standard thing, sample the
  // buttons. nice n easy as only move
  // in one direction at a time
  newx=p.x
  newy=p.y
  new_dir=p.dir
  if btn(0,0) then
    newx-=1
    new_dir=dir_left
  elseif btn(1,0) then
    newx+=1
    new_dir=dir_right
  elseif btn(2,0) then
    newy-=1
    new_dir=dir_up
  elseif btn(3,0) then
    newy+=1
    new_dir=dir_down
  end
  
  // but can we make this move?
  if (newy!=p.y) or (newx!=p.x) then
   new_tile=mget(newx, newy)
   // don't bother testing tiles for walls
   // just test the impass-bit :-)
   if fget(new_tile,flag_impass) then
    // it's an invalid move
    newx=p.x
    newy=p.y
    // dont move, but leave the
    // dir change, it looks cool
   end
  end  
 
  // trigger a move
  p.oldx=p.x
  p.oldy=p.y
  p.x=newx
  p.y=newy
  p.dir=new_dir
  // finally, update our footprints 
  // in the old tile
  mset(p.oldx,p.oldy,trav[p.dir])

 else
  // ok we're potentially already moving
  if (p.x!=p.oldx) or (p.y!=p.oldy) then
   // yup, move thru the anim
   player_frame+=1
   if (player_frame>8) then
    // we've done 8 frames, we have
    // now finised the move
    player_frame=1
    p.oldx=p.x
    p.oldy=p.y
   end
  end
 end
   
 for mummy in all(mummies) do
  update_mummy(mummy)
  if (mummy.active==false) del(mummies,mummy)

 end
end


function update_mummy(mummy) 
 if (mummy.active!=true) return
 
 // collision?
 // need to tweak this a bit, think we can get pass-bys'
 if ((mummy.x==p.x) and (mummy.y==p.y)) then 
  if p.scroll>0 then
   mummy.active=false

   p.scroll-=1
   sfx(sfx_mummy_die)
  else
   p.lives-=1
   sfx(sfx_death)
   if p.lives>0 then
    p.x=door.x
    p.y=door.y
    p.oldx=p.x
    p.oldy=p.y
    player_frame=1
    p.dir=dir_down
   else
    screen=scr_gameover
   end
  end 
 end
 
 if (mummy.frame==1) and
  (mummy.x==mummy.oldx) and
  (mummy.y==mummy.oldy) then
  // let's move!
   
  // if we have 'change' then
  // we need to swap direction
  if flr(rnd(7))==5 or mummy.change==true then
   mummy.olddir=mummy.dir
   mummy.dir=1+flr(rnd(dir_right))
   mummy.change=false
  end
    
  // can we go in current direction?
  // will add random factor in here later
  // or maybe even 'spot' the player?
  newx=mummy.x
  newy=mummy.y
   
  if (mummy.dir==dir_up) newy-=1
  if (mummy.dir==dir_down) newy+=1
  if (mummy.dir==dir_left) newx-=1
  if (mummy.dir==dir_right) newx+=1
   
   
  // can we make this move?
  new_tile=mget(newx,newy)
  // not if impass tile or the 'doorway'
  if (fget(new_tile,flag_impass)) or 
    ((newx==door.x) and (newy==door.y)) then
   // okay we cant, next time we change direction    
   mummy.change=true
   newx=mummy.x
   newy=mummy.y
   mummy.dir=mummy.olddir // fixed
  end    
   
  if (newx!=mummy.x) or (newy!=mummy.y) then
   mummy.oldx=mummy.x
   mummy.oldy=mummy.y
   mummy.x=newx
   mummy.y=newy
  end
    
 else
  // ok we're potentially already moving
  if (mummy.x!=mummy.oldx) or (mummy.y!=mummy.oldy) then
   mummy.frame=mummy.frame+mummy.speed
   if mummy.frame>8 then
    mummy.frame=1
    mummy.oldx=mummy.x
    mummy.oldy=mummy.y
   end
  end
  
 end
   
end


function complete_step_and_check()
 // yep, we've just completed a move

 mset(p.x,p.y,trav[p.dir])
 p.steps+=1
 // here we would check to
 // see if we just boxed-off
 // a chest...
 // there are probably more effecient
 // ways given that we kinda know
 // where we just stood, but for starters
 // lets do it the long way
 for x=0,4 do
  for y=0,3 do
   mx=map_ofx+(x*2)+1
   my=map_ofy+(y*2)+1
   tile=mget(mx,my)
   // unopened chest?
   if tile==map_chst then
    // so, are the 8 spaces around it traversed?      
    cleared=true
    for p=mx-1,mx+1 do
     for q=my-1,my+1 do
      tile=mget(p,q)
      traversed=fget(tile,traversed_flag)
      // dont check the centre
      if (p!=mx) or (q!=my) then
       cleared=cleared and traversed
      end
     end
    end
    
    if cleared then
     mset(mx,my,chests[x+1][y+1])
     opened_chest(x+1,y+1,mx,my)
    end
   end // if map chest
  end // for y
 end // for x
end

-->8
-- misc routines

function update_gameover()
  // x gone from not-pressed to being pressed?
  if btnp(5,0) then
    // wait until not pressed
    while (btn(5,0)) do
    end
    screen=scr_menu
  end
end

function draw_gameover()
 cls()
 print("g a m e   o v e r",32,6,15)
 print("score : "..score_to_string(p.score),44,26,5)
 print("level : "..p.level,44,32,5)
 print("press ❎", 48,112,15)
end 
 
function score_to_string(score)
 local scr=10000+score
 return sub(scr,2,5).."0"
end

-->8
-- menu draw and update
function draw_menu()
 cls()
 print("o h   m u m m y!",32,6,15)
 print("press ❎", 48,112,15)

 if menu_line==1 then 
  print(">  play  game  <", 30, 42, 10)
 else
  print("   play  game   ", 30, 42, 15)
 end
 if menu_line==2 then
  print("> instructions <", 30, 62, 10)
 else
  print("  instructions  ", 30, 62, 15)
 end
 if menu_line==3 then
  print(">   settings   <", 30, 82, 10)
 else
  print("    settings    ", 30, 82, 15)
 end
end


function update_menu()
 screen_timer+=1
 if screen_timer>300 then
  screen_timer=0
  screen=scr_highscores
  return
 end
  
 if (btnp(2,0) and (menu_line>1)) then
  menu_line-=1
  screen_timer=1
 end
 if (btnp(3,0) and (menu_line<3)) then 
  menu_line+=1
  screen_timer=1
 end

 if btnp(5,0) then
  // wait until not pressed
  while (btn(5,0)) do
  end
  if menu_line==1 then
   init_game()
   screen=scr_game
  elseif menu_line==2 then
   screen=scr_instructions
  elseif menu_line==3 then
   screen=scr_settings
  end
 end
end


function draw_settings()
 cls()
 print("s e t t i n g s",36,6,15)
 print("press ❎", 48,112,15)

 if set_line==1 then
  print(">   game speed :  "..game_speed.."   <", 22, 28, 10) 
 else
  print("    game speed :  "..game_speed.."    ", 22, 28, 15) 
 end
 if set_line==2 then
  print(">   difficulty :  "..game_difficulty.."   <", 22, 48, 10) 
 else
  print("    difficulty :  "..game_difficulty.."    ", 22, 48, 15) 
 end
 if set_line==3 then
  print(">   game music : "..bool_as_switch(game_music).."  <", 22, 68, 10) 
 else
  print("    game music : "..bool_as_switch(game_music).."   ", 22, 68, 15) 
 end
 if set_line==4 then
  print("> sound effects : "..bool_as_switch(game_sound).." <", 22, 88, 10) 
 else
  print("  sound effects : "..bool_as_switch(game_sound).."  ", 22, 88, 15) 
 end
 
end


function update_settings()
 if (btnp(2,0) and (set_line>1)) then
  set_line-=1
 end
 if (btnp(3,0) and (set_line<4)) then 
  set_line+=1
 end
 if btnp(0,0) then
  if set_line==1 then
    if (game_speed>1) game_speed-=1
  elseif set_line==2 then
    if (game_difficulty>1) game_difficulty-=1
  elseif set_line==3 then
    game_music = not game_music
  elseif set_line==4 then
    game_sound = not game_sound
  end
 end
 if btnp(1,0) then
  if set_line==1 then
    if (game_speed<5) game_speed+=1
  elseif set_line==2 then
    if (game_difficulty<5) game_difficulty+=1
  elseif set_line==3 then
    game_music = not game_music
  elseif set_line==4 then
    game_sound = not game_sound
  end
 end

 // x gone from not-pressed to being pressed?
 if btnp(5,0) then
  // wait until not pressed
  while (btn(5,0)) do
  end
  screen=scr_menu
 end
end


function draw_instructions()
 cls()
 print("i n s t r u c t i o n s",24,6,15)
 print("page "..instr_page,52,64,15)
 print("press ❎", 48,112,15)
end


function update_instructions()
 // x gone from not-pressed to being pressed?
 if btnp(5,0) then
  // wait until not pressed
  while (btn(5,0)) do
  end
  if screen==scr_instructions then
   instr_page+=1
   if instr_page>5 then
    instr_page=1
    screen=scr_menu
   end 
  end
 end
end


function draw_highscores()
 cls()
 print("o h   m u m m y!",32,6,15)
 print("press ❎", 48,112,15)

 print("todays best",40,20,6)
 print("score",12,26,5)
 print("lvl",48,26,5)
 print("explorer",72,26,5)
 line=32
 for score in all(high) do
  print(score_to_string(score.score),12,line,6)
  print(score.level,56,line,6)
  print(score.name,72,line,6)
  line=line+6
 end
end


function update_highscores()
 screen_timer+=1
 if screen_timer>200 then
  screen_timer=0
  screen=scr_menu
  return
 end
 // x gone from not-pressed to being pressed?
 if btnp(5,0) then
  // wait until not pressed
  while (btn(5,0)) do
  end
  screen=scr_menu
 end
end 


function draw_level_cleared()
 cls()
 print("level "..p.level.." cleared",32,60,6)
end


function update_level_cleared()
 screen_timer+=1
 if screen_timer>100 then
  screen_timer=0
  p.level+=1
  reset_level()
  screen=scr_game
 end
end


function bool_as_switch(bool)
  if bool then
   return "on "
  else
   return "off"
  end
end

-->8
-- animation support

-->8
-- monster & level support
function reset_level()

 p.key=0
 p.scroll=0
 p.royal=0

 // just reset the map contents for now
 for x=2,14 do
  for y=3,13 do
   local tile=mget(x,y)
   traversed=fget(tile,traversed_flag)
   if (traversed) mset(x,y,map_walk)
  end
 end
 
 for x=0,4 do
  for y=0,3 do
   mx=map_ofx+(x*2)+1
   my=map_ofy+(y*2)+1
   mset(mx,my,map_chst)
   chests[x+1][y+1]=map_chst
   // anything left as map_chst
   // when we open it now is
   // an 'empty' chest
  end
 end
 
 // now set the goodies
 
 set_chest(map_key)
 set_chest(map_guard)
 set_chest(map_royal)
 set_chest(map_scrl)
 for x=1,10 do
  set_chest(map_trsr)
 end

 // add another mummuy to whatever is already there
 add_mummy(13,12,dir_up)
end         


function set_chest(tile)
 done=false
 while (done==false) do
  x=1+ flr(rnd(5))
  y=1+ flr(rnd(4))
  if chests[x][y]==map_chst then
   chests[x][y]=tile
   done=true
  end
 end
end         

function add_mummy(x,y,dir)
 if #mummies>max_mummies then
  return
 end
 mummy={}
 mummy.x=x
 mummy.y=y
 mummy.frame=1
 mummy.loop=0
 mummy.active=true
 mummy.oldx=x
 mummy.oldy=y
 mummy.dir=dir
 mummy.olddir=mummy.dir
 mummy.color=mummy_col // can change this on the fly
 mummy.change=false // flip when we know we need to change
 
 // 3 levels of smarts, potentially
 mummy.brains=flr(rnd(3)) // 0,1,2
 // can be used to make them move slowly etc
 //mummy.speed=0.5*(flr(rnd(3))+1) // 0.5,1,1.5
 mummy.speed=1

 add(mummies,mummy)
end

// we've just opened this chest
function opened_chest(cx,cy,mx,my)
 content=chests[cx][cy]
 if content==map_key then
  p.key+=1
  sfx(sfx_key)
 elseif content==map_scrl then
  p.scroll+=1
  sfx(sfx_scroll)
 elseif content==map_royal then
  p.royal+=1
  sfx(sfx_royal)
 elseif content==map_guard then
  add_mummy(mx,my,dir_down)
  sfx(sfx_guard_free)
 elseif content==map_trsr then
  p.score = p.score + 10
  sfx(sfx_treasure)
 else
  // empty chest
  sfx(sfx_nothing)
 end
end
-->8
-- init etc

function init_game()
 p.lives=5
 p.level=1
 p.dir=dir_down
 p.x=door.x
 p.y=door.y
 p.oldx=p.x
 p.oldy=p.y
 
 p.score=0
 player_frame=1
 frame_timer=0
 
 // these all work per-level
 // and will probably go into
 // a different object
 p.steps=0 // will track when we've completed

 // just for now clear them
 for mummy in all(mummies) do
  del(mummies,mummy)
 end

 reset_level()
 
 screen=scr_game 
end

function init_system()
 // animation frames

 pright={2,1,1,2,2,1,1,2}
 pleft={18,17,17,18,18,17,17,18}
 pdown={35,34,34,35,35,33,33,35}
 pup={51,50,50,51,51,49,49,51}

 mright={10,9,9,10,10,9,9,10}
 mleft={26,25,25,26,26,25,25,26}
 mdown={43,42,42,43,43,41,41,43}
 mup={59,58,58,59,59,57,57,59}

 dir_up=1
 dir_down=2
 dir_left=3
 dir_right=4

 trav_right=24
 trav_left=8
 trav_up=40
 trav_down=56
 
 scr_menu=0
 scr_game=1
 scr_gameover=2
 scr_highscores=3
 scr_level_cleared=4
 scr_settings=5
 scr_instructions=6
 instr_page=1
 screen=scr_menu // for later 
 screen_timer=0 // used for non-game screen timers
 menu_line=1
 set_line=1

 game_speed=1
 game_difficulty=1
 game_sound=true
 game_music=true

 // set these to the relevant sfx
 sfx_scroll=5
 sfx_guard_free=4
 sfx_treasure=4
 sfx_royal=5
 sfx_key=4
 sfx_death=6

 map_walk = 55 // where we can go
 map_chst = 39 // default unopened chest
 map_key  = 21 // key
 map_scrl = 22 // scroll
 map_royal= 23 // sleeping mummy
 map_trsr = 38 // treasure
 map_guard= 54
 
 // set this bit on all tiles that cant be 'crossed'
 impass_flag=0 
 // used to help track footprints
 traversed_flag=1 

 trav={40,56,8,24} // sprites used to denote traversed 
 
 door={}
 door.x=7
 door.y=3 
 
 p={}
 mummies={}
 create_chest_array()
 max_mummies = 20 // max onscreen 
 mummy_col=10
 player_live=1
 
 // where does the play area start, basically?
 map_ofx=3
 map_ofy=4
 setup_highscore()
end


function create_chest_array()
 chests={}
 for x=1,5 do
  chests[x]={}
  for y=1,4 do
   chests[x][y]=0
  end
 end
end


function setup_highscore()
 high={}
 for x=1,10 do
  score={}
  score.score=100
  score.level=1
  score.name="king tut"
  add(high,score)
 end
end

__gfx__
0000000000ccc00000ccc000000000000000000000000000000000000000000000000000000aa000000aa0000000000000000000000000000000000000000000
0000000000a9190000a9190000000000000000000000000000000000000000000000000000aaaa0000aaaa000000000000000000000000000000000000000000
0070070000c9900000c9900000000000000000000000000000000000000000000000044400aaaa0000aaaa000000000000000000000000000000000000000000
0007700000acc00000acc000000000000000000000000000000000000000000004000400000aa000000aa0000000000000000000000000000000000000000000
0007700000caa90000caa900000000000000000000000000000000000000000004440000000aaaa0000aaaa00000000000000000000000000000000000000000
0070070000ccc00000ccc000000000000000000000000000000000000000000000000000000aa000000aa0000000000000000000000000000000000000000000
0000000009c00c00000c000000000000000000000000000000000000000000000000000000a00a00000a00000000000000000000000000000000000000000000
00000000009009900009900000000000000000000000000000000000000000000000000000aa0aa0000aa0000000000000000000000000000000000000000000
00000000000ccc00000ccc0000000000aaaaaaaacccccccccccccccccccccccc00000000000aa000000aa0000000000000000000000000000000000000000000
0000000000919a0000919a0000000000aaaaaaaacccccccccccccccccccccccc0000000000aaaa0000aaaa000000000000000000000000000000000000000000
0000000000099c0000099c0000000000aaaaaaaacccccaaccc0cc0cccacccaac0000000000aaaa0000aaaa000000000000000000000000000000000000000000
00000000000cca00000cca0000000000aaaaaaaacaaaacacc10aa01ccaaaaaac00004440000aa000000aa0000000000000000000000000000000000000000000
00000000009aac00009aac0000000000aaaaaaaaccaccaacc10aa01cc999999c004000400aaaa0000aaaa0000000000000000000000000000000000000000000
00000000000ccc00000ccc0000000000aaaaaaaacacacccccc0cc0ccccaccacc44400000000aa000000aa0000000000000000000000000000000000000000000
0000000000c00c900000c00000000000aaaaaaaacccccccccccccccccccccccc0000000000a00a000000a0000000000000000000000000000000000000000000
00000000099009000009900000000000aaaaaaaacccccccccccccccccccccccc000000000aa0aa00000aa0000000000000000000000000000000000000000000
0000000000cccc0000cccc0000cccc0044444444ffffffff999999991111111100000000a00aa00aa00aa00aa00aa00a00000000000000000000000000000000
00000000009cc900009cc900009cc90044444444ffffffff99aaaa991111111100044000a0aaaa0aa0aaaa0aa0aaaa0a00000000000000000000000000000000
0000000000999900009999000099990044444444ffffffff9a98c9a91111111100040000a0aaaa0aa0aaaa0aa0aaaa0a00000000000000000000000000000000
000000000aacca9009accaa00aaccaa044444444ffffffffa090909a11111111000400000a0aa0a00a0aa0a00a0aa0a000000000000000000000000000000000
0000000009cccca00acccc9009cccc9044444444ffffffffa909090a111111110000000000aaaa0000aaaa0000aaaa0000000000000000000000000000000000
0000000000cccc0000cccc0000cccc0044444444ffffffff9ac98ca9111111110000440000aaaa0000aaaa0000aaaa0000000000000000000000000000000000
0000000000c0099009900c0000c00c0044444444ffffffff99aaaa99111111110000040000a00aa00aa00a0000a00a0000000000000000000000000000000000
0000000009900000000009900990099044444444ffffffff9999999911111111000004000aa0000000000aa00aa00aa000000000000000000000000000000000
0000000000cccc0000cccc0000cccc000000000000000000c11cc11c0000000000400000a00aa00aa00aa00aa00aa00a00000000000000000000000000000000
0000000000acca0000acca0000acca000000000000000000c1cccc1c0000000000400000a0aaaa0aa0aaaa0aa0aaaa0a00000000000000000000000000000000
00000000009cc900009cc900009cc9000000000000000000c1cccc1c0000000000440000a0aaaa0aa0aaaa0aa0aaaa0a00000000000000000000000000000000
000000000acccc9009cccca00acccca000000000000000001c1cc1c100000000000000000a0aa0a00a0aa0a00a0aa0a000000000000000000000000000000000
0000000009cccca00acccc9009cccc90000000000000000011cccc11000010000000400000aaaa0000aaaa0000aaaa0000000000000000000000000000000000
0000000000cccc0000cccc0000cccc00000000000000000011cccc11000000000000400000aaaa0000aaaa0000aaaa0000000000000000000000000000000000
0000000000c0099009900c0000c00c00000000000000000011c11c11000000000004400000a00aa00aa00a0000a00a0000000000000000000000000000000000
0000000009900000000009900990099000000000000000001cc11cc100000000000000000aa0000000000aa00aa00aa000000000000000000000000000000000
__gff__
0000000000000000020000000000000000000000010101010200000000000000000000000101010102000000000000000000000000000100020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1414141414141414141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141437141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414143737373737373737373737141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414143716371537273727372437141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414143737373737373737373737141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414143724371537273727372737141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414143737373737373737373737141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414143724372437273717372437141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414143737373737373737373737141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414143724372437243724372437141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414143737373737373737373737141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011300000c0300c0300e0300e0300f0300f0300f0300f0300e0300e0300e0300e0300c0300c0300c0300c0000c0300c0300e0300e0300f0300f03013030130300e0300e0300f0300f0300c0300c0300c03000000
011300000f0300f03011030110301303513035130351303513030130301403014030130301303011030110300e0300e0300f0300f030110351103511035110351103011030130301303011030110300f0300f030
011300000007500000070750000000070000000707507075000700000007075070050007000000070750707500075000000707500000000700000007075070750007500000070750000000070000000707507075
000100002e050290502805026050250502405023050230502305023050250502705028050290502b0502f0502e0502c0002c00000000000000000000000000000000000000000000000000000000000000000000
010f00002907729074290742907400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0120010011074100740f0740e0740c0740c0740c07400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01034344
02 02034344

