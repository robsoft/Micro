
void Move_Ghost(unsigned short GHOST) // move ghost
{

  unsigned short m_up, m_down, m_left, m_right;  
  unsigned short loopcount;
  
  int gx, gy;
  int badx, bady;
  unsigned short randtest; // used to provide a little variety
  // the 'higher' ghosts are less prone to acts of RANDom directional change

  gx=mgx[GHOST];
  gy=mgy[GHOST];
  
  // rob's patented 'hit-test-before-you-even-think-of-moving'. Get out of that, pacman!
  if ((gx==mpx) && (gy==mpy)) {hit[GHOST]=1; dgx[GHOST]=0; dgy[GHOST]=0; return;}

  badx=0;
  bady=0;  
  randtest=(rand() % (GHOST+0x02U)) ;  
  m_up=levmask[gx][gy-1];
  m_down=levmask[gx][gy+1];
  m_left=levmask[gx-1][gy];
  m_right=levmask[gx+1][gy];
      

  // ghosts continue in the direction that they're travelling until they have to change direction
  // note the basic similarity between this framework and the one in Move_Pacman...

  // I'm absolutely convinced that someone could make this cleaner for me... :-)

  switch (dgx[GHOST])
  {
    case -1:
    {
      if (m_left==WALL) { dgx[GHOST]=0; badx=-1;  } // bad move, stop moving
      else
      { // look for a possible vertical switch
         if (m_up==PASSAGE) 
           { if (randtest==0x0U) { dgy[GHOST]=-1; dgx[GHOST]=0;}  }
         if (m_down==PASSAGE) 
           { if (randtest==0x0U) { dgy[GHOST]= 1; dgx[GHOST]=0;}  }
      }
      break;
    }
    case 0:
    {
      if (dgy[GHOST]<0)  // moving up the screen?
      {
        if (m_up==WALL) { dgy[GHOST]=0; bady=-1; }  
        else
        { // look for a possible horizontal switch
          if (m_left==PASSAGE) 
            { if (randtest==0x0U) { dgx[GHOST]=-1; dgy[GHOST]=0; }  }          
          if (m_right==PASSAGE) 
            { if (randtest==0x0U) { dgx[GHOST]= 1; dgy[GHOST]=0; } }          
        }  
      }
      else
      {
        if (dgy[GHOST]>0)  // going down? 
        {
          if (m_down==WALL) { dgy[GHOST]=0; bady=1;  }  
          else
          { // look for a possible horizontal switch
            if (m_left==PASSAGE) 
              { if (randtest==0x0U) { dgx[GHOST]=-1; dgy[GHOST]=0;  }  }
            if (m_right==PASSAGE) 
              { if (randtest==0x0U) { dgx[GHOST]=1; dgy[GHOST]=0;  }  }
          }  
        }
      }
      break;
    }
    case 1:
    {
      if (m_right==WALL) { dgx[GHOST]=0; badx=1; }  
      else
      { // look for a possible vertical switch
        if (m_up==PASSAGE) 
          { if (randtest==0x0U) { dgy[GHOST]=-1; dgx[GHOST]=0; }  }
        if (m_down==PASSAGE) 
          { if (randtest==0x0U) { dgy[GHOST]= 1; dgx[GHOST]=0; }  }
      }
    }
  }


  // well, the right-on coding brigade will never see this so who cares. This would be a pain if I
  // nested it up nicely - I reckon this is a bit easier to follow, myself. Anyway - a couple of
  // GOTOs (gasp!) coming up...
  
  //------------ 
  // this marks the start of the main ghost moving routine. We're interested in testing the move held
  // in dgx, dgy. If it's good, we jump out of the routine. If not, we try to pick an alternative that
  // hasn't already been considered. If we can't do that, we bail out after a couple of iterations anyway -
  // this has the nice side effect that the ghosts occassionally appear to 'pause' for a split second. :-)

  loopcount=0x00U;
    
  outerloop:

  // special handling for our 2 exits - basically ensure the ghosts can't move horizontally into the exits
  if ((dgy[GHOST]==0) && (gy==EXIT_Y))
  {
    if ((gx<= EXIT_LEFT_X) && (dgx[GHOST]==-1)) { dgx[GHOST]=0; badx=-1; }
    else
    if ((gx>=(EXIT_RIGHT_X+1)) && (dgx[GHOST]==1)) { dgx[GHOST]=0; badx=1;}
  }
  
  // similarly, stop ghosts from travelling back into their pen
  if ((dgy[GHOST]==0) && (gy==PEN_Y))
  {
    // push right if it's on or just left of the arrow...
    if ((gx>=11) && (gx<PEN_X)) {dgx[GHOST]=1; badx=-1;} 
    else
    {
      // if we're trying to get back in, stop intended movement
      if ((gx==PEN_X) && (dgx[GHOST]==-1)) {dgx[GHOST]=0; badx=-1;}
    } 
  }
  
  
  // if we still have a vector, it's good. So just push it through and exit
  if ((dgx[GHOST]!=0) || (dgy[GHOST]!=0))
  {

    getout:
    
    // moving horizontally?
    if (dgx[GHOST]!=0) 
    {
      mgx[GHOST]=mgx[GHOST]+dgx[GHOST]; // update the notional map position
      if (dgx[GHOST]==-1) 
        {set_sprite_tile(GHOST,GHOST_LEFT);} 
      else 
        {set_sprite_tile(GHOST,GHOST_RIGHT);} // and frig the sprite
    }      
    else
    {
      // so it's moving vertically
      mgy[GHOST]=mgy[GHOST]+dgy[GHOST];  // same idea
      if (dgy[GHOST]==-1) 
        {set_sprite_tile(GHOST,GHOST_UP);} 
      else 
        {set_sprite_tile(GHOST,GHOST_DOWN);}  // and same sprite frigging
    }      
      
    // your common-garden 'hit-test-the-new-position' collision detection test
    if ((mgx[GHOST]==mpx) && (mgy[GHOST]==mpy)) {hit[GHOST]=1; }
     
    return;
  }    


  innerloop:
  
  loopcount++;
  // if we've spent too long in here, skip this ghost's go
  if (loopcount==0x04U) 
  {  
    // clear out the vectors
    dgx[GHOST]=0; dgy[GHOST]=0; 
    goto getout;
  }
  
  // time to pick a new direction. 
  // the 'bad' variables flag that direction shouldn't be chosen. If we decide to pick a
  // horizontal move then we flag the badx var to '2', making sure that we don't try and pick
  // another horizontal move should we come bakc here again during this particular move sequence
  
  // the random factor here is to cause vertical moves to be chosen from time to time, too
  if ((rand() % 2)==0x01U)
  {
    if (badx<2)
    {
      // pick a horizontal direction, avoiding our recent direction if we can
      switch (badx)
      {
        case -1: { dgx[GHOST]=1; break;}

        case 0:  { if (randtest==0x00U) { dgx[GHOST]=-1;} 
                   else { dgx[GHOST]=1; } break; }

        case 1: { dgx[GHOST]=-1; break;}
     }
      badx=2;  // flag up that no more horizontal moves should be chosen
    }
    else
    {
      if (bady<2)
      {
        // pick a vertical direction, avoiding our recent direction if we can
        switch (bady)
        {
          case -1: { dgy[GHOST]=1; break;}
          case 0:  { if (randtest==0x00U) { dgy[GHOST]=-1; } 
                     else { dgy[GHOST]=1; } break; }
          case 1: { dgy[GHOST]=-1; break;}
        }
        bady=2;  // flag up that no more vertical moves shold be chosen
      }
    }
  }
  else
  { // same code as above, but testing in reverse. Hmmmm.
    if (bady<2)
    {
      // pick a vertical direction, avoiding our recent direction if we can
      switch (bady)
      {
        case -1: { dgy[GHOST]=1; break;}
        case 0:  { if (randtest==0x00U) { dgy[GHOST]=-1; } 
                   else { dgy[GHOST]=1; } break; }
        case 1: { dgy[GHOST]=-1; break;}
      }
      bady=2;  // flag up that no more vertical moves shold be chosen
    }
    else 
    {
      if (badx<2)
      {
        // pick a horizontal direction, avoiding our recent direction if we can
        switch (badx)
        {
          case -1: { dgx[GHOST]=1; break;}

          case 0:  { if (randtest==0x00U) { dgx[GHOST]=-1;} 
                     else { dgx[GHOST]=1; } break; }

          case 1: { dgx[GHOST]=-1; break;}
       }
        badx=2;  // flag up that no more horizontal moves should be chosen
      }
    }
  }  
    

  // test that we haven't chosen an invalid map position anyway...
  if (levmask[ gx+dgx[GHOST] ][ gy+dgy[GHOST] ]==WALL)
  {
    // sigh. oh well, clear out the vectors
    dgx[GHOST]=0; dgy[GHOST]=0; 
    // and JUMP (argh!) back to our inner testing section
    goto innerloop;
  }
  
  // so we have a potentially valid move - best JUMP (no!) round to all the other tests again
  goto outerloop;
  
}  
