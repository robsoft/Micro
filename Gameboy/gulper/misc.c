// return the value of the background tile at the specified map pos. 
// returns 0 for positions that fall off the map. This is used within the main
// game loop, although not heavily
unsigned char GetBkgTile(int x, int y)
{
  unsigned char c;
  if ( (x<0) || (x>20) || (y<0) || (y>18) )
    { c=0; }
  else  
    { get_bkg_tiles(x,y, 1,1, &c); }
  return c;
}


// change the specified background tile map to the specified tile, 
void SetBkgTile(int x, int y, unsigned char c)
{
  set_bkg_tiles(x,y, 1,1, &c);
}


// modify the ghost sprite colours. The ghosts change colours collectively
void SetGhostColors(int colored)
{
  if (colored)
  {  
    set_sprite_prop(GHOST1,1);
    set_sprite_prop(GHOST2,1);
    set_sprite_prop(GHOST3,1);
  }
  else
  {  
    set_sprite_prop(GHOST1,2);
    set_sprite_prop(GHOST2,2);
    set_sprite_prop(GHOST3,2);
  }  
}


// initialise the actual level data
void LoadLevel()
{
  int x,y;
  unsigned char ch;

  // and now sort out the background palette    
  set_bkg_palette(0,1, &BackgroundPalette[0]);
  set_bkg_palette(1,1, &BackgroundPalette[4]);
  set_bkg_palette(2,1, &BackgroundPalette[8]);
  set_bkg_palette(3,1, &BackgroundPalette[12]);
  set_bkg_palette(4,1, &BackgroundPalette[16]);
  set_bkg_palette(5,1, &BackgroundPalette[20]);
  set_bkg_palette(6,1, &BackgroundPalette[24]);
  set_bkg_palette(7,1, &BackgroundPalette[28]);

  // load the tile data - it remains constant for all the different levels
  set_bkg_data(0,47,TileLabel);

  // the level numbers here look wonky because I've been playing around with the order of them. :-)
  switch (level)
  {
    case 0x01U:
    {
      VBK_REG = 1;
      set_bkg_tiles(0,0,20,18,lev2cgb);
      VBK_REG = 0;
      set_bkg_tiles(0,0,20,18,lev2map);
      break;
    }
    case 0x02U:
    {
      VBK_REG = 1;
      set_bkg_tiles(0,0,20,18,lev1cgb);
      VBK_REG = 0;
      set_bkg_tiles(0,0,20,18,lev1map);
      break;
    }
    case 0x03U:
    {
      VBK_REG = 1;
      set_bkg_tiles(0,0,20,18,lev4cgb);
      VBK_REG = 0;
      set_bkg_tiles(0,0,20,18,lev4map);
      break;
    }
    default:
    {
      VBK_REG = 1;
      set_bkg_tiles(0,0,20,18,lev3cgb);
      VBK_REG = 0;
      set_bkg_tiles(0,0,20,18,lev3map);
      break;
    }
    
  }    

  // we're going to calculate the number of dots that need to be eaten as we build the map
  dots=0; 

  // Basically we're building the level map 'mask', Anything that can't be passed thru in the level
  // map earns a 1 in the mask. Everything else (dots, pills etc) earns a 0 - ie, can be passed thru
  // The tiles have been arranged so that tile values < 12 are wall-type tiles, and tiles higher >=12
  // are things that can be passed thru/over.
  for (x=0;x!=22;x++) { for (y=0;y!=20;y++) {levmask[x][y]=WALL;} }  // assume it's all wall to start with

  for (x=0;x!=21;x++)
  {
    for (y=0;y!=19;y++)
    {
      ch=GetBkgTile(x,y);
      if (ch<12) { levmask[x][y]=WALL; } else { levmask[x][y]=PASSAGE;}
      if (ch==DOT_TILE) {dots++;}
    }
  }
}

