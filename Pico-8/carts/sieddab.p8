pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
 weapheat=90
 sheild=100
 power=450
 powercol=10
 sheildcol=11
 weaponcol=12
 dangercol=8
end

function _update()
end

function _draw()
cls()
-- draw main screen
	line(0,88,127,88,7)
	rect(0,0,127,127,7)
	rect(40,90,87,125,7)

-- levels
 xp=3
 col=pickcol(sheildcol, sheild, 100, dangercol)
 for x=1,sheild,10 do
  line(xp,90,xp,94,col)
  line(xp+1,90,xp+1,94,col)
  xp=xp+3
 end
 
 xp=3
 col=pickcol(powercol, power, 500, dangercol)
 for x=1,power/5,10 do
  line(xp,96,xp,100,5)
  line(xp+1,96,xp+1,100,5)
  xp=xp+3
 end

 xp=3
 col=pickcol(weapheatcol, weapheat, 100, dangercol)
 for x=1,power/5,10 do
  line(xp,96,xp,100,5)
  line(xp+1,96,xp+1,100,5)
  xp=xp+3
 end
 
-- draw ships etc	
end

function pickcol(normalcol, var, maxval, badcol)
	if var>=0.9*maxval then
	  return badcol
	else
	  return normalcol
	end
end


