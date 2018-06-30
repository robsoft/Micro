// Basically these are used as array elements, loop comparisions and sprite numbers
// The idea is just to make some of the code easier to read
#define PLAYER 0
#define GHOST1 1
#define GHOST2 2
#define GHOST3 3
#define GHOSTS 4 
#define ALLSPRITES 4


#define WALL    0x1U          // we use a 1 in our mask array to indicate a wall
#define PASSAGE 0x0U          // and a 0 to indicate a valid 'empty' position


#define DIEWAIT 90            // used in the 'spinning pacman' loop
#define CHERRYDELAY 100       // how long should we wait before we consider showing a cherry?
#define CHERRYVISIBLE 120     // and how long should we show it for?


#define START_PLAYER_X 10
#define START_PLAYER_Y 10


#define INITIAL_LEVEL 1
#define MAX_LEVELS    5
#define INITIAL_LIVES 3
#define MAX_LIVES     5
#define INITIAL_SPEED 25
#define MIN_SPEED     12


#define INITIAL_SCARED_DELAY  25
#define MAX_SCARED            90
#define SCARED_WARNING        15

// map tile & palette numbers
#define DOT_TILE    13
#define PILL_TILE   14
#define CHERRY_TILE 15
#define CLEAR_TILE  16
#define CHERRY_PALETTE 1
#define CLEAR_PALETTE  0
#define PLAYER_PALETTE 0
#define GHOST_PALETTE  1
#define GHOST_SCARED_PALETTE 2

// sprite tile numbers
#define GHOST_LEFT    8
#define GHOST_RIGHT	  9
#define GHOST_UP	 10
#define GHOST_DOWN	 11
#define PLAYER_LEFT	  0
#define PLAYER_RIGHT  2
#define PLAYER_UP	  4
#define PLAYER_DOWN	  6


#define CHERRY_SCORE 200
#define PILL_SCORE     5
#define DOT_SCORE	   1
#define GHOST_SCORE	  50


#define PEN_X 14
#define PEN_Y 7
#define EXIT_Y 8
#define EXIT_LEFT_X 1
#define EXIT_RIGHT_X 19



// these hold the player map positions and vectors
int mpx,mpy;
int dpx,dpy;


unsigned short level;  // level number, 1-4
int totlevel;
unsigned short speed;  // games speed (used in a delay() call - lower the value, faster the game)
unsigned short dots;   // how many dots need eating to clear the screen
unsigned short scared; // >0 indicates ghosts are scared of pacman, used to countdown to end of effect
unsigned short lives;  // the number of lives remaining
unsigned int score;   // somewhere to keep the score


unsigned short playsprite;  // somewhere to keep a flag for the pacman sprite image in use


short levmask[22][20]; // this stores a 'mask' of the level, in terms of walls and passages


// We ignore the zero element of the ghosts arrays - it's only wasting a few bytes in total
// and will make mapping to sprite numbers easier
int mgx[GHOSTS], mgy[GHOSTS];  // stores the map (tile) position of each ghost
int dgx[GHOSTS], dgy[GHOSTS];  // and stores the direction of each ghost

short hit[GHOSTS];             // stores whether or not each ghost has made contact with pacman

