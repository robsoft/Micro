pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
poke(0x5f2c,5)
::_::
cls(8)
for j=0,128 do
d=.2*sin(t()/2+j/128)
for i=18,4,-1 do
s=.5*i*cos(sin(4*t()+j/42)/8+i/8)
a=d*j+s+i*5
line(84,j,84-a,j,8+(i-2)%3)
end
end
flip()
goto _

