# Artist
Artist was originally a 48K basic program (simple drawing package) that got expanded a bit when I got my +3. It has a flood fill, it has icons and an early-WIMP-type environment, it has lots of interesting ideas (such as being able to merge your own routines into a specific program location, which is a fore-runner to Photoshop's Plugins, surely??!) but it's slow (95% BASIC).  
The aim of the project here is to move key routines into assembler (learning as we go) and to tidy it up, ready for potential use on the Spectrum and Spectrum Next (etc etc).  

# "inputs"  
 (work-in-progress to move stuff from BASIC to assembler)  
 have a flag 'variable' and allow OVER 1/OVER 0 type drawing  
 _hide the top left debug display unless another 'variable' set_  
 build-in the behaviour for '1' key (cursor highlight)  
 ret to BASIC for SPACE and ENTER, nothing else  
 j,k to popup an on-screen 'JUMP 0x' type window  
 
 
# current to-do
-  complete "inputs" sub-project (above)  
-  add Kempston Mouse & Joystick support to the dummy 'INPUTS' code  
    (there is code at RANDOMIZE USR 63000 to demonstrate the in-dev INPUTS code, press 0 to exit)
-  remove BASIC keyreading code and use INPUTS routine instead  
-  improve ICON display/selection code (assembler?)  
-  improve bottom-screen-area information display (and put icons there?)  
-  improve/add support for various disk systems (saving & loading files)  
-  speed improvements using my variable and line number hacks?
-  rewrite magnification code in assembler  
-  write 'texture' code as a follow on to fill routine  
-  document (or replace) the third party fill routine  
-  text at pixel positions  
-  branch out into the font editor program, bring that into GitHub etc etc - can it all be one app?  


# TAP contents
- ARTIST LINE 1 (BASIC)  
- UTILS  45000, 035  (CODE, screen loading & saving )  
- FONT   42000, 868  (RAW, spectrum font data ) - length/scope needs checking  
- ICONS  43000, 912  (RAW, spectrum font data for icons ) - length/scope needs checking  
- FILL   64800, 500  (CODE, third part fill routine )  
- INPUTS 63000, 313  (CODE, input routine code)  

# Rough dev notes
Work in BasinC, ZX Spin - whatever  
run 9999  
use blockeditor to clear out previous version of files on tape  
run 9999 to resave whole project  
poke 23606, 23607 with 42744 to give us 43000 as start of ICONS charset  
poke 23606, 23607 with 41744 to give us 42000 as start of thickened 'FONT' charset  
  
calls:   
45000 - save screen to 45100  
45012 - restore screen from 45100  
45024 - restore screen from 45100 but omit attribs  
63000 - inputs entry point
64800 - flood fill routine  

variables:  
63004 - xpos  
63006 - ypos  
63008 - speed  
63003 - action


# charedit  
g = get  
q a o p = move  
5 =   
Chr7 =  
c =  
SPACE = set pixel  
i =  invert cells  
R =  
Chr12 (delete) = delete pixel  

