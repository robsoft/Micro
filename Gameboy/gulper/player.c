void Move_Pacman() // move pacman
{
  int pad = joypad();

  // crude temporary pause function
  if (pad & J_START)
  {
      waitpadup();       // wait until nothing is being pressed
      DISPLAY_OFF;
      waitpad(J_START);  // then wait for START to be pressed
      waitpadup();
      DISPLAY_ON;
  }

  
  // this is a bit weird looking but the idea is to preserve any existing vector,
  // unless a valid change of direction is being made at the keypad.
  // note how we set both dx and dy vectors when we decide the change is valid
  if (pad & J_LEFT)  { if (levmask[ mpx-1 ][mpy]==PASSAGE) {  dpx=-1; dpy=0; } }
  else  
  {
    if (pad & J_RIGHT)  { if (levmask[ mpx+1 ][mpy]==PASSAGE) {  dpx=1; dpy=0; } }
  }
    
  if (pad & J_UP)  { if (levmask[mpx][ mpy-1 ]==PASSAGE) {  dpx=0; dpy=-1; } }
  else
  {  
    if (pad & J_DOWN) { if (levmask[mpx][ mpy+1 ]==PASSAGE) {  dpx=0; dpy=1; } }
  }


  // special handling for our 2 exits - basically just hack the sprite across the
  // screen and update the px,py map co-ordinates appropriately
  if ((dpy==0) && (mpy==EXIT_Y))
  {
    if ((mpx<EXIT_LEFT_X) && (dpx==-1)) { mpx=20; move_sprite(0, 168, 80); }
    else
    if ((mpx>=EXIT_RIGHT_X) && (dpx==1)) { mpx=-1; move_sprite(0, 0, 80); }
  }

  // similarly, stop pacman from travelling back into the ghosts' pen
  if ((dpy==0) && (mpy==PEN_Y))
  {
    if ((mpx==PEN_X) && (dpx==-1)) {dpx=0; } // stop intended left movement
  }

    
  // okay, so can we actually make this move?
  if (levmask[ mpx+dpx ][ mpy+dpy ]==PASSAGE)
  {
    
    // handle horizontal motion
    if (dpx!=0)
    {
      mpx=mpx+dpx;
      // update sprite tile
      if (dpx==-1)  { playsprite=PLAYER_LEFT; }   else          { playsprite=PLAYER_RIGHT; }
    }
    else
    {
      // handle vertical motion
      if (dpy!=0)
      {
        mpy=mpy+dpy;
        // update sprite tile
        if (dpy==-1)  { playsprite=PLAYER_UP; }  else       { playsprite=PLAYER_DOWN; }
      }
    }

  }
  else  
  {
    // basically, stop pacman from moving
    dpx=0;
    dpy=0;
    // no need to update the sprite tile - the last tile shape we used is fine
  }

}

