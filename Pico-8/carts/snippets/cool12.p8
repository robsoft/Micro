pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
poke(0x5f2c,6)
::_::
cls(12)
for j=0,128 do
d=.2*sin(t()/4+j/128)
for i=14,1,-1 do
s=.4*i*cos(sin(2*t()+d*i/2+j/64)/8+t()/4+d*4+i/8)
a=d*j+s+i*4
line(j,64,j,64-a,i-3)
end
end
flip()
goto _
