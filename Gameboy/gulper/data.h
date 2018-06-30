#include "export.h"
#include "export.c"

#include "sprites.h"
#include "sprites.c"

#include "levels.h"
#include "levels.c"

#include "splashtiles.h"
#include "splashtiles.c"
#include "splashscreen.h"
#include "splashscreen.c"

#include "textdata.h"
#include "textdata.c"
#include "gulptext.h"
#include "gulptext.c"

const UWORD BackgroundPalette[] =
{
  TileLabelCGBPal0c0,TileLabelCGBPal0c1,TileLabelCGBPal0c2,TileLabelCGBPal0c3,
  TileLabelCGBPal1c0,TileLabelCGBPal1c1,TileLabelCGBPal1c2,TileLabelCGBPal1c3,
  TileLabelCGBPal2c0,TileLabelCGBPal2c1,TileLabelCGBPal2c2,TileLabelCGBPal2c3,
  TileLabelCGBPal3c0,TileLabelCGBPal3c1,TileLabelCGBPal3c2,TileLabelCGBPal3c3,
  TileLabelCGBPal4c0,TileLabelCGBPal4c1,TileLabelCGBPal4c2,TileLabelCGBPal4c3,
  TileLabelCGBPal5c0,TileLabelCGBPal5c1,TileLabelCGBPal5c2,TileLabelCGBPal5c3,
  TileLabelCGBPal6c0,TileLabelCGBPal6c1,TileLabelCGBPal6c2,TileLabelCGBPal6c3,
  TileLabelCGBPal7c0,TileLabelCGBPal7c1,TileLabelCGBPal7c2,TileLabelCGBPal7c3,
};

const UWORD SpritePalette[] =
{
  SpriteCGBPal0c0,SpriteCGBPal0c1,SpriteCGBPal0c2,SpriteCGBPal0c3,
  SpriteCGBPal1c0,SpriteCGBPal1c1,SpriteCGBPal1c2,SpriteCGBPal1c3,
  SpriteCGBPal2c0,SpriteCGBPal2c1,SpriteCGBPal2c2,SpriteCGBPal2c3,
  SpriteCGBPal3c0,SpriteCGBPal3c1,SpriteCGBPal3c2,SpriteCGBPal3c3,
  SpriteCGBPal4c0,SpriteCGBPal4c1,SpriteCGBPal4c2,SpriteCGBPal4c3,
  SpriteCGBPal5c0,SpriteCGBPal5c1,SpriteCGBPal5c2,SpriteCGBPal5c3,
  SpriteCGBPal6c0,SpriteCGBPal6c1,SpriteCGBPal6c2,SpriteCGBPal6c3,
  SpriteCGBPal7c0,SpriteCGBPal7c1,SpriteCGBPal7c2,SpriteCGBPal7c3,
};


const UWORD SplashPalette[] =
{
  SplashTileCGBPal0c0,SplashTileCGBPal0c1,SplashTileCGBPal0c2,SplashTileCGBPal0c3,
  SplashTileCGBPal1c0,SplashTileCGBPal1c1,SplashTileCGBPal1c2,SplashTileCGBPal1c3,
  SplashTileCGBPal2c0,SplashTileCGBPal2c1,SplashTileCGBPal2c2,SplashTileCGBPal2c3,
  SplashTileCGBPal3c0,SplashTileCGBPal3c1,SplashTileCGBPal3c2,SplashTileCGBPal3c3,
  SplashTileCGBPal4c0,SplashTileCGBPal4c1,SplashTileCGBPal4c2,SplashTileCGBPal4c3,
  SplashTileCGBPal5c0,SplashTileCGBPal5c1,SplashTileCGBPal5c2,SplashTileCGBPal5c3,
  SplashTileCGBPal6c0,SplashTileCGBPal6c1,SplashTileCGBPal6c2,SplashTileCGBPal6c3,
  SplashTileCGBPal7c0,SplashTileCGBPal7c1,SplashTileCGBPal7c2,SplashTileCGBPal7c3
};
   
const UWORD TextTilePalette[] =
{
  TileLabelCGBPal0c0,TextTileCGBPal0c1,TextTileCGBPal0c2,TextTileCGBPal0c3,
  TextTileCGBPal1c0,TextTileCGBPal1c1,TextTileCGBPal1c2,TextTileCGBPal1c3,
  TextTileCGBPal2c0,TextTileCGBPal2c1,TextTileCGBPal2c2,TextTileCGBPal2c3,
  TextTileCGBPal3c0,TextTileCGBPal3c1,TextTileCGBPal3c2,TextTileCGBPal3c3,
  TextTileCGBPal4c0,TextTileCGBPal4c1,TextTileCGBPal4c2,TextTileCGBPal4c3,
  TextTileCGBPal5c0,TextTileCGBPal5c1,TextTileCGBPal5c2,TextTileCGBPal5c3,
  TextTileCGBPal6c0,TextTileCGBPal6c1,TextTileCGBPal6c2,TextTileCGBPal6c3,
  TextTileCGBPal7c0,TextTileCGBPal7c1,TextTileCGBPal7c2,TextTileCGBPal7c3,
};
