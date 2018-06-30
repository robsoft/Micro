/*
  
*/


#include <gb\gb.h>
#include <stdio.h>
#include <rand.h>
#include "data.h"
#include <types.h>
#include "vars.h"
#include "misc.c"
#include "ghost.c"
#include "player.c"
//#include <stdio.h>




// initialise the sprite and palette data
void InitSystem()
{
  unsigned short o;

  DISPLAY_OFF;
  HIDE_BKG;
  HIDE_SPRITES;
 
  cpu_fast();

  // sort out the sprites first
  SPRITES_8x8;
  set_sprite_palette(0,1, &SpritePalette[0]);
  set_sprite_palette(1,1, &SpritePalette[4]);
  set_sprite_palette(2,1, &SpritePalette[8]);
  set_sprite_palette(3,1, &SpritePalette[12]);
  set_sprite_palette(4,1, &SpritePalette[16]);
  set_sprite_palette(5,1, &SpritePalette[20]);
  set_sprite_palette(6,1, &SpritePalette[24]);
  set_sprite_palette(7,1, &SpritePalette[28]);
  set_sprite_data(0,15,Sprite);

  for (o=PLAYER;o<ALLSPRITES;o++) {move_sprite(o,0,0);}
  
}



void PlayLevel()
{
  unsigned short o, moving, cherryon;
  unsigned long gametime;
 

  cherryon=0x0U;


  // initialise pacman's position, etc
  playsprite=PLAYER_LEFT; // initially, we'll use the left-facing pacman sprite
  set_sprite_tile(PLAYER, playsprite);
  set_sprite_prop(PLAYER, PLAYER_PALETTE); // set pacman color
  mpx=START_PLAYER_X; mpy=START_PLAYER_Y; 
  dpx=-1; dpy=0; // pacman's position, vector on the 'map'
  move_sprite(PLAYER, (mpx<<3)+8, (mpy<<3)+16 ); // put the little guy there

  // initialise ghost's positions, etc
  mgx[GHOST1]= 9; mgy[GHOST1]= 7; 
  dgx[GHOST1]= 1; dgy[GHOST1]= 0; // ghost1
  mgx[GHOST2]=10; mgy[GHOST2]= 8; 
  dgx[GHOST2]= 0; dgy[GHOST2]= -1; // ghost2
  mgx[GHOST3]=11; mgy[GHOST3]= 7; 
  dgx[GHOST3]= 1; dgy[GHOST3]= 0; // ghost3

  // move the sprites into the playarea
  for (o=GHOST1; o!=GHOSTS; o++) 
  { set_sprite_tile(o, GHOST_LEFT); 
    set_sprite_prop(o, GHOST_PALETTE);
    move_sprite(o, (mgx[o]<<3)+8, (mgy[o]<<3)+16 ); 
    hit[o]=0;     // clear the host 'hit' array
  }


  scared = INITIAL_SCARED_DELAY; // scared timeout - give the little guy a few seconds grace before he becomes edible
  SetGhostColors(0); // gray ghosts (scared!=0)
  
  gametime=0;

  DISPLAY_ON;
  SHOW_SPRITES;

  
  while (1) 
  {

    gametime++;

    // update pacman's notional position, optionally with input from the user :-)
    Move_Pacman();
    // by the way, the Move_Pacman routine handles PAUSE, as it's already dealing with user input...
        
    // let them ghosties have their turn
    Move_Ghost(1);
    Move_Ghost(2);
    Move_Ghost(3);

    switch (cherryon)
    {
      case 0:
      {
        if ( (gametime>=CHERRYDELAY) && (GetBkgTile(START_PLAYER_X,START_PLAYER_Y)==CLEAR_TILE) )
        {
          cherryon=1;
          gametime=0;
        }
        break;
      }
      case 1:
      {
        if (gametime>=CHERRYDELAY)
        {
          VBK_REG=1;
          SetBkgTile(START_PLAYER_X,START_PLAYER_Y,CHERRY_PALETTE); // palette value for cherry
          VBK_REG=0;
          SetBkgTile(START_PLAYER_X,START_PLAYER_Y,CHERRY_TILE);  // whack the cherry on the screen
          gametime=0;
          cherryon=2;
        }        
        break;
      }
      case 2:
      {
        if (gametime>=CHERRYVISIBLE)
        {
          VBK_REG=1;
          SetBkgTile(START_PLAYER_X,START_PLAYER_Y,CLEAR_PALETTE); // palette value for clear tile
          VBK_REG=0;
          SetBkgTile(START_PLAYER_X,START_PLAYER_Y,CLEAR_TILE);  // hide it again
          cherryon=0;
          gametime=0;
        }
      }
    }          
    

    // move the sprites the 8 pixels in the directions they're supposed to be moving
    // note that although the map positions are already up-to-date (for hit testing purposes etc),
    // until the point the sprites themselves are sat at the old map positions
    moving=((dpx!=0)||(dpy!=0));
    set_sprite_tile(PLAYER,playsprite);
    for (o=0;o!=2;o++)
    {
      scroll_sprite(PLAYER, dpx,dpy);
      scroll_sprite(GHOST1, dgx[GHOST1],dgy[GHOST1]);
      scroll_sprite(GHOST2, dgx[GHOST2],dgy[GHOST2]);
      scroll_sprite(GHOST3, dgx[GHOST3],dgy[GHOST3]);
      delay(speed);
    }
    
    if (moving==1) {set_sprite_tile(PLAYER,playsprite+1);} // don't animate pacman if not moving
    for (o=2;o!=6;o++)
    {
      scroll_sprite(PLAYER, dpx,dpy);
      scroll_sprite(GHOST1, dgx[GHOST1],dgy[GHOST1]);
      scroll_sprite(GHOST2, dgx[GHOST2],dgy[GHOST2]);
      scroll_sprite(GHOST3, dgx[GHOST3],dgy[GHOST3]);
      delay(speed);
    }
    
    if (moving==1) {set_sprite_tile(PLAYER,playsprite);} // no need to revert sprite if not moving
    for (o=6;o!=8;o++)
    {
      scroll_sprite(PLAYER, dpx,dpy);
      scroll_sprite(GHOST1, dgx[GHOST1],dgy[GHOST1]);
      scroll_sprite(GHOST2, dgx[GHOST2],dgy[GHOST2]);
      scroll_sprite(GHOST3, dgx[GHOST3],dgy[GHOST3]);
      delay(speed);
    }


    // get the backround tile that the player is on, and let's have a butcher's...
    switch  (GetBkgTile(mpx,mpy)) 
    {
      // have we eaten a dot?
      case DOT_TILE: 
      { 
        SetBkgTile(mpx,mpy,CLEAR_TILE); // turn this map position into a blank from now on
        score += DOT_SCORE; // increase score
        // now we test to see if we've eaten all the dots - if so, we've finished the level

        if (--dots < 1) 
        {
          level++;
          totlevel++;
          if (level==MAX_LEVELS)
          {
            level=INITIAL_LEVEL;
            if ((totlevel % 10)==0)
            {
              if (lives<MAX_LIVES) { lives++; }
            }
            if (speed>MIN_SPEED) { speed--; }
          }
          return; // end of level
        }
        

        break;
      }
      
      // did we eat a pill?
      case PILL_TILE: 
      { 
        SetBkgTile(mpx,mpy,CLEAR_TILE);  // again, blank the tile from now on
        scared = MAX_SCARED; // set the 'scared' timeout back to it's maximum - note that this means eating 2 pills
        // in quick succession doesn't give you any extra time
        score += PILL_SCORE; // increase score
        break;
      }
      
      // did we eat the cherry thingy?
      case CHERRY_TILE:
      { 
        SetBkgTile(mpx,mpy,CLEAR_TILE);  // blank the map position again
        score += CHERRY_SCORE; // increase score
        cherryon=0;
        gametime=0;
        break;
      }
    }

    
    // time to review the situation with the ghosts;
    
    // are the buggers dangerous?
    if (scared == 0) 
    { 

      // have we touched one? 
      if ((hit[GHOST1] || hit[GHOST2] || hit[GHOST3]) !=0) 
      { 
        
        // hide the ghosts - don't bother unrolling loops in this section
        for (o=GHOST1; o!=GHOSTS; o++) move_sprite(o, 0,0);
        
        // cause pacman to spin around on the spot. It's crap but who cares?
        for (o=0; o!=4; o++) 
        {
          set_sprite_tile(PLAYER, 0); delay(DIEWAIT);
          set_sprite_tile(PLAYER, 12); delay(DIEWAIT);
          set_sprite_tile(PLAYER, 2); delay(DIEWAIT);
          set_sprite_tile(PLAYER, 13); delay(DIEWAIT);
          set_sprite_tile(PLAYER, 4); delay(DIEWAIT);
          set_sprite_tile(PLAYER, 14); delay(DIEWAIT);
          set_sprite_tile(PLAYER, 6); delay(DIEWAIT);
          set_sprite_tile(PLAYER, 15); delay(DIEWAIT);
        }
        lives--;
        return;
        
      }
      
    } 
    
    else // ghosts are scared, so we look to see if we've touched them...
    
    
    
    {
      for (o=GHOST1; o!=GHOSTS; o++)
      {
        if (hit[o]!=0) 
        { 
          // move the ghost in question back to the ghost-pen
          mgx[o] = 10; mgy[o] = 7; 
          dgx[o] = 1; // head for the way out immediately
          dgy[o] = 0;
          hit[o] = 0;  // and turn off the 'hit' indication for this ghost
          
          move_sprite(o, (mgx[o]<<3)+8, (mgy[o]<<3)+16); // re-position sprite
        
          score += GHOST_SCORE;  // increase score        
        }
      }
     
      // is the timeout nearing it's end?
      if (scared < SCARED_WARNING)
        SetGhostColors(1 + scared&2); // cause ghosts to blink their colours
      else
        SetGhostColors(0); // scared
      scared--;
      
      if (scared==0) {SetGhostColors(2);}
      
      
    }
  }
}



void SplashScreen()
{
  HIDE_SPRITES;
  DISPLAY_OFF;
  HIDE_BKG;
  
  set_bkg_palette( 7, 1, &SplashPalette[28] );
  set_bkg_palette( 6, 1, &SplashPalette[24] );
  set_bkg_palette( 5, 1, &SplashPalette[20] );
  set_bkg_palette( 4, 1, &SplashPalette[16] );
  set_bkg_palette( 3, 1, &SplashPalette[12] );
  set_bkg_palette( 2, 1, &SplashPalette[8] );
  set_bkg_palette( 1, 1, &SplashPalette[4] );
  set_bkg_palette( 0, 1, &SplashPalette[0] );
  set_bkg_data(0 , 140 , SplashTile );

  VBK_REG = 1;
  set_bkg_tiles(0,0,20,18,splash_cgb);
  
  VBK_REG = 0;
  set_bkg_tiles(0,0,20,18,splash_map);

  SHOW_BKG;
  DISPLAY_ON;
  
  waitpadup();       // wait until nothing is being pressed
  waitpad(J_START);  // then wait for START to be pressed before launching new game
  waitpadup();
  
  DISPLAY_OFF;
}



void Scores(UWORD showmode)
{
  char str[10];
  int n;
  UWORD tmp;
  
  
  HIDE_SPRITES;
  DISPLAY_OFF;
 
  set_bkg_palette( 7, 1, &TextTilePalette[28] );
  set_bkg_palette( 6, 1, &TextTilePalette[24] );
  set_bkg_palette( 5, 1, &TextTilePalette[20] );
  set_bkg_palette( 4, 1, &TextTilePalette[16] );
  set_bkg_palette( 3, 1, &TextTilePalette[12] );
  set_bkg_palette( 2, 1, &TextTilePalette[8] );
  set_bkg_palette( 1, 1, &TextTilePalette[4] );
  set_bkg_palette( 0, 1, &TextTilePalette[0] );
  set_bkg_data(0 , 140 , TextTile );

  
  VBK_REG = 1;
  set_bkg_tiles(0,0,20,18,TextTileCGB);
  
  VBK_REG = 0;
  set_bkg_tiles(0,0,20,18,TextTileData);


  // I wish I could persuade sprintf to work; I want it to zero-leading-space pad an unsigned long.
  // Unfortunately, I can't seem to persuade it. Hence the crappy looking score display
  sprintf(str,"%d!",score);
  for(n=0; str[n]!='!'; n++)
  {
	tmp = (str[n] - '0') + 0x1A;
    SetBkgTile(11+n,1,tmp);
  }
                
  sprintf(str,"%d!",totlevel);
  for(n=0; str[n]!='!'; n++)
  {
	tmp = (str[n] - '0') + 0x1A;
    SetBkgTile(11+n,4,tmp);
  }

  n=(lives) + 0x1A;
  SetBkgTile(11,7, n);


  // output the relevant bit of text into the middle of the screen; this is set by the showmode var
  switch (showmode)
  {

    case 0:
    {
      // try again
      SetBkgTile( 5,11,0x13);      SetBkgTile( 6,11,0x11);
      SetBkgTile( 7,11,0x18);      SetBkgTile( 8,11,0x28);
      SetBkgTile( 9,11,0x00);      SetBkgTile(10,11,0x06);
      SetBkgTile(11,11,0x00);      SetBkgTile(12,11,0x08);
      SetBkgTile(13,11,0x0D);
      break; 
    }
    case 1:
    {
      // game over
      SetBkgTile( 5,11,0x06);      SetBkgTile( 6,11,0x00);
      SetBkgTile( 7,11,0x0C);      SetBkgTile( 8,11,0x04);
      SetBkgTile( 9,11,0x28);      SetBkgTile(10,11,0x0E);
      SetBkgTile(11,11,0x15);      SetBkgTile(12,11,0x04);
      SetBkgTile(13,11,0x11);
      break;
    }
    case 2:
    {
      // ready!
      SetBkgTile( 5,11,0x28);      SetBkgTile( 6,11,0x11);
      SetBkgTile( 7,11,0x04);      SetBkgTile( 8,11,0x00);
      SetBkgTile( 9,11,0x03);      SetBkgTile(10,11,0x18);
      SetBkgTile(11,11,0x26);      SetBkgTile(12,11,0x24);
      SetBkgTile(13,11,0x28);
      break;
    }
  }

  
  DISPLAY_ON;
  waitpadup();       // wait until nothing is being pressed
  waitpad(J_START);  // then wait for START to be pressed before returning
  waitpadup();
  DISPLAY_OFF;
}



void main()
{
  static int seed;
  int oldlives, oldlevel;
  
  DISPLAY_OFF;

  initrand(seed++);

  InitSystem();

  while (1)
  {

    SplashScreen();

    // reset our game variables
    score = 0;
    level = INITIAL_LEVEL;
    speed = INITIAL_SPEED;
    lives = INITIAL_LIVES;
    totlevel = 1;
    
    Scores(2);
    
    while (lives!=0) 
    {
      oldlives=lives;
      oldlevel=level;
      LoadLevel();  // load the correct map and prepare the datastructures
      PlayLevel();  // play the game
      if ( (oldlives!=lives) && (lives>0) ) 
        {Scores(0);} // show 'try again'
      else
        { if (oldlevel!=level) 
          {Scores(2);}  // show 'ready'
        }
      
    }
    
    Scores(1); // show 'game over'
  }
  
}