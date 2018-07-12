pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
::_::
cls()
z=t()/4
for a=1,.05,-.005 do
for i=1,14 do
r=a*60+max(0,i*3*sin(a+z))
x=r*cos(a*4-z)
y=r*sin(a*4-z)
circfill(64+x,64+y,3,i)
end
end
flip()
goto _
