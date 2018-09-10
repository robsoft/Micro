pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- oh mummy
-- adam miller & rob uttley

function _init()
  --adam set this to false for normal behaviour
  debug=false

  init_system()
  
  if debug then
    pyramid_modulo = 1 -- how many levels per pyramid?
    -- testing gameover etc
    music(-1)
    init_game()
    p.score=400
    p.level=3
    add_mummy(13,12,dir_up,false,true) -- not 'reveal', not 'smart'
    setup_level_cleared()
    screen=scr_level_cleared
  else
    -- normal code
    screen_timer=1
    setup_menu()
  end
end


function _draw()
  if (screen==scr_game) then draw_game()
  elseif (screen==scr_level_cleared) then draw_level_cleared()
  elseif (screen==scr_menu) then draw_menu()
  elseif (screen==scr_gameover) then draw_gameover()
  elseif (screen==scr_highscores) then draw_highscores()
  elseif (screen==scr_settings) then draw_settings()
  elseif (screen==scr_new_pyramid) then draw_new_pyramid()
  elseif (screen==scr_enterhighscore) then draw_enterhighscore()
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
  elseif (screen==scr_new_pyramid) then update_new_pyramid()
  elseif (screen==scr_enterhighscore) then update_enterhighscore()
  else update_instructions()
  end
end


function draw_game()
  cls()
  map(0,0,0,0,16,16)

  if (debug) print("player speed:"..p.speed.." game speed:"..game_speed,0,0,0) 

  print("score:"..padl(tostr(p.score),5,"0"),10,8,0)
  print("men:",72,8,0)
 
  -- do we need to show the scroll?
  for l=1,min(p.scroll,3) do
    if (l>0) spr(map_scrl,8+(l*8),16)
  end

  local sprites={}
  local frame=flr(p.frame) 
  if p.dir==dir_up then
    spr(pup[frame], p.x*8, (p.oldy*8)-p.frame+1)
    sprites=pup
  elseif p.dir==dir_down then
    spr(pdown[frame], p.x*8, (p.oldy*8)+p.frame-1)
    sprites=pdown
  elseif p.dir==dir_left then
    spr(pleft[frame], (p.oldx*8)-p.frame, p.y*8)
    sprites=pleft
  elseif p.dir==dir_right then
    spr(pright[frame], (p.oldx*8)+p.frame, p.y*8)
    sprites=pright
  end 
  
  -- indicate lives
  -- uncomment this for old behaviour
  --sprite=spr_player_life
  local sprite=frame
  for l=1,min(p.lives,5) do
    sprite+=1
    if (sprite>#sprites) sprite=1
    spr(sprites[sprite], 64+(l*8),16)
  end 
 
  for mummy in all(mummies) do
    if (mummy.active==true) and (mummy.reveal==false) then
      mframe=flr(mummy.frame)
      -- hack palette in case we want to change mummy color
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
      -- restore palette 
      pal()
    end
  end
  
  if game_paused then
    rectfill(0,46,128,82,0)
    centre_text("paused", 62, 15)
  end

end



function update_game()
  if game_paused then
    if btnp(5,0) then
      game_paused=false
      return
    end
  else
    update_player()
    for mummy in all(mummies) do
      update_mummy(mummy)
      if ((mummy.active==false) and (mummy.reveal==false)) del(mummies,mummy)
    end
    if btnp(5,0) then
      game_paused=true
      return
    end
  end
  
end


function update_player()
  if (p.frame==1) and (p.x==p.oldx) and (p.y==p.oldy) then
  
    -- first off, set the floor as we have potentially just finished a move
    this_tile=mget(p.x, p.y)
    if (this_tile==map_walk) complete_step_and_check()
    -- level done?
    if (p.key>0) and (p.royal>0) and (p.x==door.x) and (p.y==door.y) then
      -- okay level done
      setup_level_cleared()
      return
    end

    -- standard thing, sample the buttons. 
    -- nice n easy as only move in one direction at a time
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
  
    -- but can we make this move?
    if (newy!=p.y) or (newx!=p.x) then
      new_tile=mget(newx, newy)
      -- don't bother testing tiles for walls
      -- just test the impass-bit :-)
      if fget(new_tile,flag_impass) then
        -- it''s an invalid move
        newx=p.x
        newy=p.y
        -- don't move, but leave the
        -- dir change standing as it looks cool
      end
    end  
 
    -- trigger a move
    p.oldx=p.x
    p.oldy=p.y
    p.x=newx
    p.y=newy
    p.dir=new_dir
    -- finally, update our footprints in the old tile
    mset(p.oldx,p.oldy,trav[p.dir])

  else
    -- ok we're potentially already moving
    if (p.x!=p.oldx) or (p.y!=p.oldy) then
      -- yup, move thru the anim
      p.frame=p.frame+p.speed
      if (p.frame>8) then
        -- we've done 8 frames, we have
        -- now finised the move
        p.frame=1
        p.oldx=p.x
        p.oldy=p.y
      end
    end
  end
end


function can_look(mummy, dirt)
  newx=mummy.x
  newy=mummy.y
  if (dirt==dir_up) newy-=1
  if (dirt==dir_down) newy+=1
  if (dirt==dir_left) newx-=1
  if (dirt==dir_right) newx+=1
   
  -- can we 'see' in this direction?
  new_tile=mget(newx,newy)
  -- not if it's an impass tile or the 'doorway'
  if (fget(new_tile,flag_impass)) or ((newx==door.x) and (newy==door.y)) then
    -- we can't see this way
    return false
  else
    return true
  end
end


-- using the fact that the grid is regular with width and length-long corridors 
-- to massively cheat - if the grid wasn't a simple lattice, this wouldn't work
function saw_player(mummy, dirt)
  -- which frame better to test, the previous one or the upcoming one?
  if p.frame<4 then
    testx=p.oldx
    testy=p.oldy
  else
    testx=p.x
    testy=p.y
  end

  if ((dirt==dir_up) and (mummy.x==testx) and (mummy.y>=testy)) return true
  if ((dirt==dir_down) and (mummy.x==testx) and (mummy.y<=testy)) return true
  if ((dirt==dir_left) and (mummy.y==testy) and (mummy.x>=testx)) return true
  if ((dirt==dir_right) and (mummy.y==testy) and (mummy.x<=testx)) return true
  return false
end


function smart_mummy_move(mummy)
  mummy.olddir=mummy.dir
  -- what are our surroundings?
  local chkup=can_look(mummy, dir_up)
  local chkdn=can_look(mummy, dir_down)
  local chklt=can_look(mummy, dir_left)
  local chkrt=can_look(mummy, dir_right)

  -- take away any 'behind'
  if (mummy.dir==dir_up) chkdn=false
  if (mummy.dir==dir_down) chkup=false
  if (mummy.dir==dir_left) chkrt=false
  if (mummy.dir==dir_right) chklt=false

  if chkdn and saw_player(mummy, dir_down) then
    mummy.dir=dir_down
  elseif chkup and saw_player(mummy, dir_up) then
    mummy.dir=dir_up
  elseif chklt and saw_player(mummy, dir_left) then
    mummy.dir=dir_left
  elseif chkrt and saw_player(mummy, dir_right) then
    mummy.dir=dir_right
  end

  -- have we changed, or do we still need to?
  if (mummy.change==true) and (mummy.dir==mummy.olddir) then
    dumb_mummy_move(mummy)
  end
end

function dumb_mummy_move(mummy)
  -- if we have 'change' then we need to swap direction
   mummy.olddir=mummy.dir
   mummy.dir=1+flr(rnd(dir_right))
   mummy.change=false
end


function check_mummy_collision(mummy)
-- which frame better to test, the previous one or the upcoming one?
  if p.frame<4 then
    testx=p.oldx
    testy=p.oldy
  else
    testx=p.x
    testy=p.y
  end

  if ((mummy.x==testx) and (mummy.y==testy)) then 
    -- mummy always dies
    mummy.active=false
    p.mummycount=safe_inc(p.mummycount)
    -- did we have the scroll?
    if p.scroll>0 then
      p.scroll-=1
      play_sfx(sfx_mummy_die)
      p.scrollcount=safe_inc(p.scrollcount)
    else
      -- lose a life
      p.lives-=1
      play_sfx(sfx_death)
      p.lostcount=safe_inc(p.lostcount)
      -- and it might be game-over
      if (p.lives<=0) screen=scr_gameover
    end
  end 
end


function validate_mummy_move(mummy)
  -- can we go in current direction?
  newx=mummy.x
  newy=mummy.y
  if (mummy.dir==dir_up) newy-=1
  if (mummy.dir==dir_down) newy+=1
  if (mummy.dir==dir_left) newx-=1
  if (mummy.dir==dir_right) newx+=1
   
  -- can we make this move?
  new_tile=mget(newx,newy)
  -- not if it's an impass tile or the 'doorway'
  if (fget(new_tile,flag_impass)) or ((newx==door.x) and (newy==door.y)) then
    -- okay we can't, next time we change direction    
    mummy.change=true
    newx=mummy.x
    newy=mummy.y
    mummy.dir=mummy.olddir
  end    
   
  if (newx!=mummy.x) or (newy!=mummy.y) then
    mummy.oldx=mummy.x
    mummy.oldy=mummy.y
    mummy.x=newx
    mummy.y=newy
  end
end


function mummy_reveal(mummy)
  mummy.frame+=1
  if (mummy.frame<=#mreveal) then
    mset(mummy.x,mummy.y,mreveal[mummy.frame])
  else
    mummy.frame=1
    mset(mummy.x,mummy.y,map_guard)
    mummy.reveal=false
    mummy.active=true
  end
end



function update_mummy(mummy) 
  if (mummy.reveal==true) mummy_reveal(mummy)
  if (mummy.active!=true) return
 
  -- collision?
  check_mummy_collision(mummy)
  if (mummy.active!=true) return

  -- reached the tile we were walking towards?
  if (mummy.frame==1) and (mummy.x==mummy.oldx) and (mummy.y==mummy.oldy) then
    -- let''s move!
    -- smart mummies constantly look to see what they can do
    if (mummy.tracker==true) then
      smart_mummy_move(mummy)
    -- dumb mummies don't
    elseif flr(rnd(8))==5 or mummy.change==true then
      dumb_mummy_move(mummy)
    end
    
    validate_mummy_move(mummy)
  else
    -- ok we're potentially already moving
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





function update_gameover()
  -- x gone from not-pressed to being pressed?
  if btnp(5,0) then
    -- wait until not pressed
    while (btn(5,0)) do
    end
    if (p.score>high[#high].score) then
      setup_enterhighscore()
      screen=scr_enterhighscore
    else
      screen=scr_highscores
    end
  end
end


function draw_gameover()
  cls()
  title("g a m e   o v e r",15)
  press_x()
  local xpos=12
  print("score              : "..padl(tostr(p.score),5,"0"),xpos,32,10)

  print("pyramids           : "..padl(tostr(p.pyramidcount),5),xpos,42,15)
  print("level              : "..padl(tostr(p.level),5),xpos,48,15)
  print("steps taken        : "..padl(tostr(p.steps),5),xpos,54,15)
  print("mummies vanquished : "..padl(tostr(p.mummycount),5),xpos,60,15)
  print("men consumed       : "..padl(tostr(p.lostcount),5),xpos,66,15)
  print("scrolls used       : "..padl(tostr(p.scrollcount),5),xpos,72,15)
  print("treasures found    : "..padl(tostr(p.treasurecount),5),xpos,78,15)

  -- beaten the lowest high score?
  if (p.score>high[#high].score) then
    centre_text("a new highscore table entry!", 100, 10)
  end
end 
 


function draw_menu()
  cls()
  title("o h   m u m m y!",15)
  press_x()

  local xpos=26
  highlight_line("", " play  game ", xpos, 38, menu_line==1, 10, 15)
  highlight_line("", "instructions", xpos, 58, menu_line==2, 10, 15)
  highlight_line("", "  settings  ", xpos, 78, menu_line==3, 10, 15)

  for men in all(chase_players) do
    spr(pright[men.frame], men.x, men.y)
  end

  for mum in all(chase_mummies) do
    pal(mummy_col, mum.color)
    spr(mright[mum.frame], mum.x, mum.y)
    pal()
  end
end


function setup_menu()
  chase_mummies={}
  chase_players={}
  local ofs=-5
  for i=1,flr(rnd(5))+1 do
    men={}
    men.x=ofs
    men.frame=flr(rnd(8))+1
    men.y=96
    add(chase_players,men)
    ofs=ofs-8
  end
  ofs=ofs-24
  for i=1,flr(rnd(13))+1 do
    mum={}
    mum.x=ofs
    mum.frame=flr(rnd(8))+1
    mum.y=96
    if flr(rnd(2))==0 then
      mum.color=mummy_col
    else
      mum.color=mummy_tracker_col
    end
    add(chase_mummies,mum)
    ofs=ofs-8
  end

  if screen!=scr_menu then
    screen_timer=1
    menu_line=1 -- nice to reset the line to 'play game'
    screen=scr_menu
  end
end



function update_menu()
  screen_timer+=1
  if screen_timer>300 then
    screen_timer=0
    screen=scr_highscores
    return
  end
  
  for men in all(chase_players) do
    men.frame+=1
    if (men.frame>8) men.frame=1
    men.x=men.x+2
    if (men.x>128) del(chase_players, men)
  end

  for mum in all(chase_mummies) do
    mum.frame+=1
    if (mum.frame>8) mum.frame=1
    mum.x=mum.x+2
    if (mum.x>128) del(chase_mummies, mum)
  end
  
  if (#chase_mummies==0) then
    setup_menu()
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
    -- wait until not pressed
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
  title("s e t t i n g s",15)
  press_x()
  local xpos=26
  highlight_line("game speed :",speeds[game_speed], xpos, 28, set_line==1, 10, 15)
  highlight_line("difficulty :",diffs[game_difficulty], xpos, 48, set_line==2, 10, 15)
  highlight_line("game music :",bool_as_switch(game_music), xpos, 68, set_line==3, 10, 15)
  highlight_line("game sound :",bool_as_switch(game_sound), xpos, 88, set_line==4, 10, 15)
end




function update_settings()
  -- handle up & down
  if ((btnp(2,0) and (set_line>1))) set_line-=1
  if ((btnp(3,0) and (set_line<4))) set_line+=1
  new_game_music=game_music
  new_game_sound=game_sound

  -- left
  if btnp(0,0) then
    if set_line==1 then
      if (game_speed>1) game_speed-=1
    elseif set_line==2 then
      if (game_difficulty>1) game_difficulty-=1
    elseif set_line==3 then
      new_game_music = not new_game_music
    elseif set_line==4 then
      new_game_sound = not new_game_sound
    end
  end

  -- right
  if btnp(1,0) then
    if set_line==1 then
      if (game_speed<#speeds) game_speed+=1
    elseif set_line==2 then
      if (game_difficulty<#diffs) game_difficulty+=1
    elseif set_line==3 then
      new_game_music = not new_game_music
    elseif set_line==4 then
      new_game_sound = not new_game_sound
    end
  end

  if (new_game_sound!=game_sound) game_sound=new_game_sound

  if (new_game_music!=game_music) then
    game_music=new_game_music
    if game_music==false then
      music(-1)
    else
     music(0)
    end
  end

  -- x gone from not-pressed to being pressed?
  if btnp(5,0) then
    -- wait until not pressed
    while (btn(5,0)) do
    end
    screen_timer=1
    setup_menu()
  end
end


function draw_instructions()
  cls()
  title("i n s t r u c t i o n s",15)
  press_x()

  --tbx_draw()
  -- Adam this isn't pretty but hopefully it will make sense!
  -- no switch/case statements in Pico's Lua
  -- these are all right at the end of the code section
  if (instr_page>instr_page_count) instr_page=1 -- just in case
  if instr_page==1 then
    draw_instruction_page_01()
  elseif instr_page==2 then
    draw_instruction_page_02()
  elseif instr_page==3 then
    draw_instruction_page_03()
  elseif instr_page==4 then
    draw_instruction_page_04()
  elseif instr_page==5 then
    draw_instruction_page_05()
  elseif instr_page==6 then
    draw_instruction_page_06()
  elseif instr_page==7 then
    draw_instruction_page_07()
  elseif instr_page==8 then
    draw_instruction_page_08()
  elseif instr_page==9 then
    draw_instruction_page_09()
  end
end


function update_instructions()
  -- x gone from not-pressed to being pressed?
  if btnp(❎,0) then
    instr_page+=1
    if (instr_page>instr_page_count) then
      reset_instructions()
      screen_timer=1
      setup_menu()
      return
    end
  end
end

function play_sfx(sfx_id)
  if (game_sound==true) sfx(sfx_id)
end


function draw_highscores()
  cls()
  title("o h   m u m m y!",15)
  press_x()

  centre_text("todays best",20,6)
  print("score",20,32,5)
  print("lvl",48,32,5)
  print("explorer",72,32,5)
  local yline=42
  for x=1,10 do
    score=high[x]
    print(padl(tostr(x),2),5,yline,5)
    print(padl(tostr(score.score),5,"0"),20,yline,6)
    print(score.level,56,yline,6)
    print(score.name,72,yline,6)
    yline=yline+6
  end
end


function update_new_pyramid()
  -- x gone from not-pressed to being pressed?
  if btnp(5,0) then
    if tbx_active then
      tbx_complete()
    else
    -- wait until not pressed
      while (btn(5,0)) do
      end
      next_level()
    end
  end
  tbx_update()
end

function draw_new_pyramid()
  cls()
  title("o h   m u m m y!",15)
  centre_text("!!  s t o p   p r e s s  !!",32,4)
  centre_text("british museum today announced",52,15)
  centre_text("successful excavation of ancient",58,15)
  centre_text("egyptian pyramid.",64,15)
  press_x()
  tbx_draw()
end



function update_highscores()
  screen_timer+=1
  if (screen_timer>300) or (btnp(5,0)) then
    screen_timer=1
    setup_menu()
  end
end 


function draw_enterhighscore()
  cls()
  title("n e w   h i g h s c o r e!",15)
  centre_text("enter your name",20,6)

  print(">"..p.highname, 44,28,10)

  local curstart = 44 + 4 + (high_curpos*4)
  line(curstart, 34, curstart+3, 34, 10)
  
  for curline=1,#highhelp do
    hiscore_helper(curline, 36 + (8*curline))
  end
  centre_text("select 'end' to complete",120,15)
end


function update_enterhighscore()
  if (btnp(0,0) and high_selindex>1) high_selindex-=1
  if (btnp(1,0) and high_selindex<6) high_selindex+=1
  if (btnp(2,0) and high_selline>1) high_selline-=1
  if (btnp(3,0) and high_selline<#highhelp) high_selline+=1

  if btnp(5,0) then
    if (high_selline==#highhelp) then
      -- special ones
      if high_selindex==1 then -- space
        add_highname(" ")
      elseif high_selindex==2 then -- cursor left
        if (high_curpos>0) then
          high_curpos-=1
        else
         bad_highscore()
        end
      elseif high_selindex==3 then -- cursor right
        if high_curpos<#p.highname then
          high_curpos+=1
        else
          bad_highscore() 
        end
      elseif high_selindex==4 then -- delete
        handle_highscore_delete()
      elseif high_selindex==5 then -- clear whole name
        p.highname=""
        high_curpos=0
      elseif high_selindex==6 then -- end
        input_hiscore()
        screen=scr_highscores
      end
    else
      -- normal ones, these just characters
      add_highname(highhelp[high_selline][high_selindex])
    end
  end
end


function hiscore_helper(highline, ypos)
  local xpos=4

  for ind=1,#highhelp[highline] do
    -- get smybol, pad as required
    sym=highhelp[highline][ind]
    if #sym==1 then sym=" "..sym.." "
    elseif #sym==2 then sym=" "..sym
    end
    -- draw it
    if (highline==high_selline) and (ind==high_selindex) then
      print(">"..sym.."<", xpos + (20*(ind-1)), ypos, 10)
    else
      print(" "..sym.." ", xpos + (20*(ind-1)), ypos, 15)
    end    
  end
end


function setup_enterhighscore()
  high_selindex=1
  high_selline=1
  high_curpos=#p.highname
end


function input_hiscore()
  -- pop through the table, inserting the high score in the right place
  for x=1,10 do
    if high[x].score<p.score then
      -- bubble them down
      if x<10 then
        for y=10,x,-1 do
          high[y].score=high[y-1].score
          high[y].level=high[y-1].level
          high[y].name=high[y-1].name
        end
      end
      -- it goes here
      high[x].score=p.score
      high[x].level=p.level
      high[x].name=p.highname   
      break
    end
  end
end


function padl(text,length,char)
  local chr = char or " "
  local res = text
  while #res<length do
    res=chr..res
  end
  return res
end


function padr(text,length,char)
  local chr = char or " "
  local res=text
  while #res<length do
    res=res..chr
  end
  return res
end


function title(text,colour)
  centre_text(text,6, colour)
end


function centre_text(text,ypos,colour)
  local pos = flr((128 - (4*#text)) / 2)
  print(text, pos, ypos, colour)
end


function press_x()
  centre_text("press ❎ ",120,15) -- extra space to overcome extra width of special 'x' char confusing measuring
end


function highlight_line(text,option,xpos,ypos,highlight,highlight_colour,plain_colour)
  if (#text!=0) print(text, xpos, ypos, plain_colour)
  
  if highlight==true then
    print("> "..option.." <", xpos + (#text*4)+4, ypos, highlight_colour)
  else
    print("  "..option.."  ", xpos + (#text*4)+4, ypos, plain_colour)
  end
end


function bad_highscore()
  play_sfx(4) -- temp
end


function add_highname(char)
  if #p.highname<8 then
    p.highname=sub(p.highname,1,high_curpos)..char..sub(p.highname,high_curpos+1)
    high_curpos+=1
  else
    bad_highscore()
  end
end


function handle_highscore_delete()
  if #p.highname>1 then
    if high_curpos>=#p.highname then
      p.highname=sub(p.highname,1,#p.highname-1)
      high_curpos-=1
    else
      if (high_curpos==0) then
        if (#p.highname>1) then 
          p.highname=sub(p.highname,2)
        else
          bad_highscore()
        end
      else
        p.highname=sub(p.highname,1,high_curpos)..sub(p.highname,high_curpos+2)
        high_curpos-=1
      end
    end
  else
    if (#p.highname==0) bad_highscore()
    p.highname=""
    high_curpos=0
  end
end


function setup_level_cleared()
  chase_mummies={}
  chase_players={}
  local ofs=-5
  for i=1,p.lives do
    men={}
    men.x=ofs
    men.frame=flr(rnd(8))+1
    men.y=80
    add(chase_players,men)
    ofs=ofs-8
  end
  ofs=ofs-24
  for i=1,#mummies do
    if mummies[i].active then
      mum={}
      mum.x=ofs
      mum.frame=flr(rnd(8))+1
      mum.y=80
      mum.color=mummies[i].color
      add(chase_mummies,mum)
      ofs=ofs-8
    end
  end
  screen=scr_level_cleared
end


function draw_level_cleared()
  cls()
  centre_text("level "..p.level.." cleared",50,6)
  for men in all(chase_players) do
    spr(pright[men.frame], men.x, men.y)
  end

  for mum in all(chase_mummies) do
    pal(mummy_col, mum.color)
    spr(mright[mum.frame], mum.x, mum.y)
    pal()
  end
  press_x()
end


function update_level_cleared()
  for men in all(chase_players) do
    men.frame+=1
    if (men.frame>8) men.frame=1
    men.x=men.x+2
    if (men.x>128) del(chase_players, men)
  end

  for mum in all(chase_mummies) do
    mum.frame+=1
    if (mum.frame>8) mum.frame=1
    mum.x=mum.x+2
    if (mum.x>128) del(chase_mummies, mum)
  end
  
  if (#chase_mummies<1) and (#chase_players<1) then
    setup_level_cleared()
  end

  if btnp(5,0) then
    if (p.level % pyramid_modulo) == 0 then
      handle_new_pyramid()
    else
     next_level()
    end
  end
end


function next_level()
  p.level+=1
  reset_level()
  screen=scr_game
end

function handle_new_pyramid()
  p.pyramidcount=safe_inc(p.pyramidcount)
  
  if p.lives==5 then
    -- add treasure
    p.score = safe_inc(p.score, 50 + (flr(rnd(6))*10))
    textbox("leader of the team given extra loot as a reward", 8, instr_y + 60, 6, 28)
  else
    -- add lives
    p.lives+=1
    textbox("leader of the team given extra man for next dig", 8, instr_y + 60, 6, 28)
  end
  screen=scr_new_pyramid
end


function bool_as_switch(bool)
  if bool then
    return "on "
  else
    return "off"
  end
end


function reset_level()
  p.key=0
  p.scroll=0
  p.royal=0

  -- just reset the map contents for now
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
--      mset(mx,my,map_chst)
-- pick the unopened colour from our new array
      mset(mx,my,map_unopened[1+(p.level % #map_unopened)])
      chests[x+1][y+1]=map_chst
      -- anything left as map_chst
      -- when we open it now is an 'empty' chest
    end
  end
 
  -- now set the goodies

  -- adam - swap these 2 around to get the guard to be 'random'
  if debug then
    chests[1][1]=map_guard
    chests[2][1]=map_key
    chests[3][1]=map_royal
    chests[4][1]=map_scrl
  else
    set_chest(map_guard)
    set_chest(map_key)
    set_chest(map_royal)
    set_chest(map_scrl)
  end

  for x=1,10 do
    -- on hardest level, 1:3 chance of removing a treasure for something else
    -- artibrarily picked iteration 8 to see if anyone is reading
    if (game_difficulty==4) and (x==8) and (flr(rnd(3))==0) then
      -- now 1:3 chance of it being a scroll
      if (flr(rnd(3))==0) then
        set_chest(map_scrl)
      else
        -- okay it's a tracker, ha ha
        set_chest(map_guard)
      end
    else
      set_chest(map_trsr)
    end
  end

  add_mummy(13,12,dir_up,false,false) -- not 'reveal', not 'smart'
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


function choose_mummy_tracker()
   return (game_difficulty>1) -- maps 1,2,3,4, no trackers on lowest level
end


function choose_mummy_speed(tracker)
  -- can be used to make them move slowly etc
  -- with game difficulty and tracker combinations
  -- original speed was 0,1,2

  -- normal behaviour
  local speed=0.5*game_speed -- map from 1, 2, 3 to 0.5, 1, 1.5
  
  if tracker then
    if (game_difficulty>2) speed=max(speed+0.5,1.5) -- max out at 1.5
  end
  return speed
end


function choose_player_speed()
  return 0.5*game_speed -- map it to 0.5, 1, 1.5
end


function add_mummy(x,y,dir,reveal,tracker)
  -- if it's got silly, don't bother. there's probably something
  -- like this in the original, to be honest!
  if (#mummies>max_mummies) return

  mummy={}
  mummy.x=x
  mummy.y=y
  mummy.frame=1
  mummy.loop=0
  mummy.reveal=reveal
  mummy.active=not reveal
  mummy.oldx=x
  mummy.oldy=y
  mummy.dir=dir
  mummy.olddir=mummy.dir
  mummy.tracker=tracker
  if tracker then
    mummy.color=mummy_tracker_col
  else
    mummy.color=mummy_col 
  end

  mummy.change=false -- flip when we know we need to change direction
  mummy.speed=choose_mummy_speed(tracker)

  add(mummies,mummy)
end

function complete_step_and_check()
  -- yep, we've just completed a move
  mset(p.x,p.y,trav[p.dir])
  p.steps=safe_inc(p.steps)
  -- check to see if we just boxed-off a chest...
  for x=0,4 do
    for y=0,3 do
      mx=map_ofx+(x*2)+1
      my=map_ofy+(y*2)+1
      tile=mget(mx,my)
      -- unopened chest?
//      if tile==map_chst then
      if tile==map_unopened[1+(p.level%#map_unopened)] then
        -- so, are the 8 spaces around it traversed?      
        cleared=true
        for p=mx-1,mx+1 do
          for q=my-1,my+1 do
            tile=mget(p,q)
            traversed=fget(tile,traversed_flag)
            -- don't check the centre
            if (p!=mx) or (q!=my) then
              cleared=cleared and traversed
            end
          end
        end
        if cleared then
          mset(mx,my,chests[x+1][y+1])
          opened_chest(x+1,y+1,mx,my)
        end
      end -- if map chest
    end -- for y
  end -- for x
end

-- we have just opened this chest
function opened_chest(cx,cy,mx,my)
  content=chests[cx][cy]
  if content==map_key then
    p.key+=1
    play_sfx(sfx_key)
  elseif content==map_scrl then
    p.scroll+=1
    play_sfx(sfx_scroll)
    p.scrollcount=safe_inc(p.scrollcount)
  elseif content==map_royal then
    p.royal+=1
    p.score = safe_inc(p.score,50)
    play_sfx(sfx_royal)
  elseif content==map_guard then
    add_mummy(mx, my, dir_down, true, choose_mummy_tracker())
    play_sfx(sfx_guard_free)
  elseif content==map_trsr then
    p.score = safe_inc(p.score,5)
    play_sfx(sfx_treasure)
    p.treasurecount=safe_inc(p.treasurecount)
  else
    -- empty chest
    mset(mx,my,map_chst_empty)
    play_sfx(sfx_nothing)
  end
end


function safe_inc(value,amount)
  local add=amount or 1
  if value < (32767-add) then
    return value+add
  else
    return value
  end
end


function init_game()
  game_paused=false
  p.lives=5
  p.level=5
  p.dir=dir_down
  p.x=door.x
  p.y=door.y
  p.oldx=p.x
  p.oldy=p.y
  p.scrollcount=0
  p.treasurecount=0
  p.lostcount=0
  p.mummycount=0
  p.pyramidcount=1
  p.highname=""
  p.speed=choose_player_speed()
   -- 0.5, 1 or 1.5

  p.score=0
  p.frame=1
  p.steps=0

  -- just for now clear them
  for mummy in all(mummies) do
    del(mummies,mummy)
  end

  reset_level()
  screen=scr_game 
end


function reset_instructions()
  instr_page=1
--  textbox(instr_text[instr_page], instr_x, instr_y, instr_col, instr_width)
end


function init_system()
  -- animation frames
  -- player
  pright={2,1,1,2,2,1,1,2}
  pleft={18,17,17,18,18,17,17,18}
  pdown={35,34,34,35,35,33,33,35}
  pup={51,50,50,51,51,49,49,51}
  -- mummies
  mright={10,9,9,10,10,9,9,10}
  mleft={26,25,25,26,26,25,25,26}
  mdown={43,42,42,43,43,41,41,43}
  mup={59,58,58,59,59,57,57,59}

  -- crude but avoid messing up main routine just for this. at 8 sprites and a silly list, still less than writing more 'special case' code
  mreveal={39,39,39,39,12,12,12,12,12,13,13,13,13,13,14,14,14,14,14,15,15,15,15,15,28,28,28,28,28,29,29,29,29,29,30,30,30,30,30,31,31}

		-- weird order here because of how we calculate using modulo
  map_unopened={63,44,45,46,47,60,61,62}

  -- footsteps - not animation, but same technique of an array of sprites
  trav={40,56,8,24} 

  -- general constants
  dir_up=1
  dir_down=2
  dir_left=3
  dir_right=4
  trav_right=24
  trav_left=8
  trav_up=40
  trav_down=56

  pyramid_modulo = 5 -- how many levels per pyramid?

  -- screen 'id' constants 
  scr_menu=0
  scr_game=1
  scr_gameover=2
  scr_highscores=3
  scr_level_cleared=4
  scr_settings=5
  scr_instructions=6
  scr_new_pyramid=7
  scr_enterhighscore=8

  -- used for tracking current screen, frame timers etc
  screen=scr_menu
  screen_timer=0
  menu_line=1
  set_line=1
  high_selindex=1
  high_selline=1

  chase_mummies={}
  chase_players={}
  -- overridden by the player if required
  speeds={}
  speeds[1]="slow"
  speeds[2]="regular"
  speeds[3]="fast"
  
  diffs={}
  diffs[1]="easy"
  diffs[2]="normal"
  diffs[3]="hard"
  diffs[4]="oh mummy!"

  game_speed=2
  game_difficulty=2
  game_sound=true
  game_music=true

  -- sfx constants
  sfx_treasure=4
  sfx_royal=5
  sfx_key=5
  sfx_death=6

  -- map tile <-> sprite constants
  map_walk = 55 -- where we can go
  map_chst = 37 -- default unopened chest
  map_chst_empty = 39 -- dark, empty chest
  map_key  = 21 -- key
  map_scrl = 22 -- scroll
  map_royal= 23 -- sleeping mummy
  map_trsr = 38 -- treasure
  map_guard= 54
  spr_player_life = 1

  -- set this bit on all tiles that cant be 'crossed'
  impass_flag=0 
  -- used to help track footprints
  traversed_flag=1 

  -- this is the spawn-point, exit and 'safe tile'
  door={}
  door.x=7
  door.y=3 
 
  p={} -- holds the player
  mummies={} -- holds the mummies
  create_chest_array() -- tracks what is in the chests (empty at this point)
  max_mummies = 20 -- max onscreen 
  mummy_col = 10 -- colour of dumb mummies
  mummy_tracker_col = 12 -- colour of smart mummies
 
  -- where does the play area start, basically?
  map_ofx=3
  map_ofy=4
  setup_highscore()

  instr_page_count=9
  reset_instructions()

  music(0)
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
    score.score=100 + ((10-x)*50)
    score.level = flr(score.score/100)
    score.name="king tut"
    add(high,score)
  end

  highhelp={}
  tmpline={"a","b","c","d","e","f"}
  add(highhelp,tmpline)
  tmpline={"g","h","i","j","k","l"}
  add(highhelp,tmpline)
  tmpline={"m","n","o","p","q","r"}
  add(highhelp,tmpline)
  tmpline={"s","t","u","v","w","x"}
  add(highhelp,tmpline)
  tmpline={"y","z","0","1","2","3"}
  add(highhelp,tmpline)
  tmpline={"4","5","6","7","8","9"}
  add(highhelp,tmpline)
  tmpline={"!","&","+","=","-","*"}
  add(highhelp,tmpline)
  tmpline={"spc","<",">","del","clr","end"}
  add(highhelp,tmpline)

end




function tbx_init()
  tbx_lines={}
  tbx_ofsx={}
  tbx_ofsy={}
  tbx_cur_line=1
  tbx_counter=0
  tbx_com_line=0
  tbx_active=true
end


-- signal we don't want to step through the text, just show it all
function tbx_complete()
  tbx_active=false
  tbx_com_line=#tbx_lines
end

function tbx_update()
  if tbx_active then
    tbx_counter+=1
    if tbx_counter>#tbx_lines[tbx_cur_line] then
      tbx_com_line+=1
      tbx_cur_line+=1
      tbx_counter=1
    end

    if tbx_cur_line>#tbx_lines then
      tbx_complete()
    end
  end
end


function tbx_draw()
  if tbx_active then
    --print current line one char at a time
    print(sub(tbx_lines[tbx_cur_line], 1, tbx_counter), tbx_ofsx[tbx_cur_line], tbx_ofsy[tbx_cur_line], tbx_col)
  end

  --print complete lines
  for i=1,tbx_com_line do
    if i>0 then
      print(tbx_lines[i], tbx_ofsx[i], tbx_ofsy[i], tbx_col)
    end
  end
end

function add_tbx_line(text,x,y,width)
  -- drop any trailling space
  if (sub(text,#text,#text)==" ") text=sub(text,1,#text-1)
  -- drop any leading space
  if (sub(text,1,1)==" ") text=sub(text,2)
  add(tbx_lines, text)

  print(#text)
  -- work out the offset based on normal width of chars
  local diff=width - #text
  local ofs=flr((diff*4)/2)
  add(tbx_ofsx, x + ofs)

  -- not using this to centre in screen yet, but could in future
  add(tbx_ofsy, y + ((#tbx_lines-1)*6))
end


function textbox(text,x,y,col,width)
  tbx_init()
  if (#text==0) return
  x=x or 4
  y=y or 4
  tbx_col=col or 7
  width=width or 28

  -- work out lines
  local i=1
  local line_num=1
  local line_str=""
  while (#text>0) do
    -- need to bother?
    if #text<=width then  
      add_tbx_line(text, x, y, width)
      break
    end

    -- find the nearest space, full-stop, hyphen or comma we can break on
    local cutoff=width
    for j = width, 1, -1 do
      local chr=sub(text,j,j)
      if (chr==" ") or (chr==",") or (chr==".") or (chr=="-") then
        cutoff=j
        break
      end
    end
    -- now cutoff is either the full line (no break found), or the point to break at
    line_str=sub(text,1,cutoff)
    add_tbx_line(line_str, x, y, width)
    text=sub(text,cutoff+1)  -- get remainder of string
  end
  
  -- now we have an array of pre-split lines, #tbx_lines gives us the number of rows if we need it
end


-- special version that works with the global varialbe instr_ypos
function instr_text(text,colour)
  local pos = flr((128 - (4*#text)) / 2)
  print(text, pos, instr_ypos, colour)
  instr_ypos+=6 -- move to next line
end


-- top and bottom lines are off limits (title & press X bit)
-- set instr_ypos to be your starting y line
-- use instr_text(string,colour) to draw centred text at 'ypos', it will inc ypos after the call to save you messing
-- use normal print() and spr() commands for other stuff
function draw_instruction_page_01()
  instr_ypos=18
  instr_text("you have been appointed head of",15)
  instr_text("an archaeological expedition, ",15)
  instr_text("sponsored by the british museum,",15)
  instr_text("and have been sent to egypt to ",15)
  instr_text("explore newly found pyramids. ",15)
  instr_ypos+=6 -- make a blank line
  instr_text("your party consists of 5",15)
  instr_text("members.",15)
  instr_ypos+=6 -- make a blank line
  instr_text("your task is to enter the 5",15)
  instr_text("levels of each pyramid, and",15)
  instr_text("recover from them 5 royal",15)
  instr_text("mummies and as much treasure",15)
  instr_text("as you can.",15)
end

function draw_instruction_page_02()
  instr_ypos=18
  instr_text("each level has been partly",15)
  instr_text("uncovered by local workers and",15)
  instr_text("it's up to your team to finish",15)
  instr_text("the dig. unfortunately, the",15)
  instr_text("workers aroused guardians left",15)
  instr_text("behind by the ancient pharoahs",15)
  instr_text("to protect their tombs.",15)

  -- we want to make this right-facing mummy blue not yellow
  pal(mum_col, mum_tracker_col) -- swap all colour 'mum_col' to 'mum_tracker_col'
  spr(10, 60, instr_ypos) -- draw sprite N at x,y
  pal() -- reset the pallete now
  instr_ypos+=12 -- move on a line

  instr_text("each level has 2 guardian",15)
  instr_text("mummies, one lies hidden while",15)
  instr_text("the other one searches for",15)
  instr_text("intruders.",15)
end;

function draw_instruction_page_03()
  instr_ypos=18
  instr_text("the partly excavated levels are",15)
  instr_text("in the form of a grid made up of",15)
  instr_text("20 'boxes'. to uncover a 'box',",15)
  instr_text("move your team along the 4 sides",15)
  instr_text("of the box from each corner to",15)
  instr_text("the next.",15)

  spr(45,60,instr_ypos)
  instr_ypos+=12 -- need to skip 2 lines

  instr_text("not all boxes need to be",15)
  instr_text("uncovered to enable you to go",15)
  instr_text("through the exit and into the",15)
  instr_text("next level.",15)

  -- etc etc etc - you can use print(text,x,y,colour) too if that's better for you
end

function draw_instruction_page_04()
--  "each level contains, 10 treasure boxes, 6 empty boxes, a royal mummy, a guardian mummy, a key and a scroll. if you uncover the box holding the guardian mummy, it will dig its way out and pursue you. being caught by a guardian mummy kills one member of your team and the mummy, unless you have uncovered the scroll."
end
function draw_instruction_page_05()
--  "the magic scroll allows you to be caught by a guardian, without any harm to your team. the scroll works only on the level on which found, it will only destroy 1 guardian. there are two ways to gain points, one is by uncovering the royal mummy the other, by uncovering treasure."
end
function draw_instruction_page_06()
--  "when the boxes holding the key and the royal mummy have been uncovered, you will be able to leave the level. any remaining guardians will be able to follow you onto the next level. after completing all 5 levels of a pyramid you will, when you leave the fifth level, move to level 1, of the next pyramid."
end
function draw_instruction_page_07()
--  "when you have completed a pyramid, your success will be rewarded either by bonus points or the arrival of an extra team member. the guardians in the next pyramid, having been warned by those you have escaped from, will be more alert, so it will pay to be more careful."
end
function draw_instruction_page_08()
--  "you can control your team by using cursor keys. the game has 4 skill levels, these determine how 'clever' the guardians are at the beginning of a game. you may choose between 3 different speed levels, from moderate to murderous."
end
function draw_instruction_page_09()
--  "may ankh-sun-ahmun guide your steps ... "
end



__gfx__
0000000000ccc00000ccc000000000000000000000000000000000000000000000000000000aa000000aa0000000000011111111111111111111111111111111
0000000000a9190000a9190000000000000000000000000000000000000000000000000000aaaa0000aaaa000000000011111111111111111111111111111111
0070070000c9900000c9900000000000000000000000000000000000000000000000044400aaaa0000aaaa000000000011111111111111111111111111111111
0007700000acc00000acc000000000000000000000000000000000000000000004000400000aa000000aa0000000000011111111111111111111111111111111
0007700000caa90000caa900000000000000000000000000000000000000000004440000000aaaa0000aaaa00000000011111111111111111111111100cccc00
0070070000ccc00000ccc000000000000000000000000000000000000000000000000000000aa000000aa00000000000111111111111111100cccc0000cccc00
0000000009c00c00000c000000000000000000000000000000000000000000000000000000a00a00000a0000000000001111111100c00c0000c00c0000c00c00
00000000009009900009900000000000000000000000000000000000000000000000000000aa0aa0000aa000000000000cc00cc00cc00cc00cc00cc00cc00cc0
00000000000ccc00000ccc0000000000aaaaaaaacccccccccccccccccccccccc00000000000aa000000aa00000000000111111111111111111111111c00cc00c
0000000000919a0000919a0000000000aaaaaaaacccccccccccccccccccccccc0000000000aaaa0000aaaa00000000001111111111111111c0cccc0cc0cccc0c
0000000000099c0000099c0000000000aaaaaaaacccccaaccc0cc0cccacccaac0000000000aaaa0000aaaa000000000011111111c0cccc0cc0cccc0cc0cccc0c
00000000000cca00000cca0000000000aaaaaaaacaaaacacc10aa01ccaaaaaac00004440000aa000000aa000000000000c0cc0c00c0cc0c00c0cc0c00c0cc0c0
00000000009aac00009aac0000000000aaaaaaaaccaccaacc10aa01cc999999c004000400aaaa0000aaaa0000000000000cccc0000cccc0000cccc0000cccc00
00000000000ccc00000ccc0000000000aaaaaaaacacacccccc0cc0ccccaccacc44400000000aa000000aa0000000000000cccc0000cccc0000cccc0000cccc00
0000000000c00c900000c00000000000aaaaaaaacccccccccccccccccccccccc0000000000a00a000000a0000000000000c00c0000c00c0000c00c0000c00c00
00000000099009000009900000000000aaaaaaaacccccccccccccccccccccccc000000000aa0aa00000aa000000000000cc00cc00cc00cc00cc00cc00cc00cc0
0000000000cccc0000cccc0000cccc0044444444ffffffff999999991111111100000000a00aa00aa00aa00aa00aa00a999999997777777788888888bbbbbbbb
00000000009cc900009cc900009cc90044444444ffffffff99aaaa991111111100044000a0aaaa0aa0aaaa0aa0aaaa0a999999997777777788888888bbbbbbbb
0000000000999900009999000099990044444444ffffffff9a98c9a91111111100040000a0aaaa0aa0aaaa0aa0aaaa0a999999997777777788888888bbbbbbbb
000000000aacca9009accaa00aaccaa044444444ffffffffa090909a11111111000400000a0aa0a00a0aa0a00a0aa0a0999999997777777788888888bbbbbbbb
0000000009cccca00acccc9009cccc9044444444ffffffffa909090a111111110000000000aaaa0000aaaa0000aaaa00999999997777777788888888bbbbbbbb
0000000000cccc0000cccc0000cccc0044444444ffffffff9ac98ca9111111110000440000aaaa0000aaaa0000aaaa00999999997777777788888888bbbbbbbb
0000000000c0099009900c0000c00c0044444444ffffffff99aaaa99111111110000040000a00aa00aa00a0000a00a00999999997777777788888888bbbbbbbb
0000000009900000000009900990099044444444ffffffff9999999911111111000004000aa0000000000aa00aa00aa0999999997777777788888888bbbbbbbb
0000000000cccc0000cccc0000cccc000000000000000000d11dd11d0000000000400000a00aa00aa00aa00aa00aa00a3333333322222222ddddddddffffffff
0000000000acca0000acca0000acca000000000000000000d1dddd1d0000000000400000a0aaaa0aa0aaaa0aa0aaaa0a3333333322222222ddddddddffffffff
00000000009cc900009cc900009cc9000000000000000000d1dddd1d0000000000440000a0aaaa0aa0aaaa0aa0aaaa0a3333333322222222ddddddddffffffff
000000000acccc9009cccca00acccca000000000000000001d1dd1d100000000000000000a0aa0a00a0aa0a00a0aa0a03333333322222222ddddddddffffffff
0000000009cccca00acccc9009cccc90000000000000000011dddd11000000000000400000aaaa0000aaaa0000aaaa003333333322222222ddddddddffffffff
0000000000cccc0000cccc0000cccc00000000000000000011dddd11000000000000400000aaaa0000aaaa0000aaaa003333333322222222ddddddddffffffff
0000000000c0099009900c0000c00c00000000000000000011d11d11000000000004400000a00aa00aa00a0000a00a003333333322222222ddddddddffffffff
0000000009900000000009900990099000000000000000001dd11dd100000000000000000aa0000000000aa00aa00aa03333333322222222ddddddddffffffff
__gff__
0000000000000000020000000000000000000000010101010200000000000000000000000101010102000000010101010000000000000100020000000103010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1414141414141414141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414140000000000141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
1414141414141414141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414141414141414141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011300000c0300c0300e0300e0300f0300f0300f0300f0300e0300e0300e0300e0300c0300c0300c0300c0000c0300c0300e0300e0300f0300f03013030130300e0300e0300f0300f0300c0300c0300c03000000
011300000f0300f03011030110301303513035130351303513030130301403014030130301303011030110300e0300e0300f0300f030110351103511035110351103011030130301303011030110300f0300f030
011300000007500000070750000000070000000707507075000700000007075070050007000000070750707500075000000707500000000700000007075070750007500000070750000000070000000707507075
000100002e050290502805026050250502405023050230502305023050250502705028050290502b0502f0502e0502c0002c00000000000000000000000000000000000000000000000000000000000000000000
010f00002907729074290742907400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0120010011074100740f0740e0740d0740d0740d07400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01034344
02 02034344

