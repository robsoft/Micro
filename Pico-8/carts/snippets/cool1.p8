pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
t,h=0,127::🐱::cls()t+=.01
for i=0,h,4 do
for j=0,h,4 do
d=i/h+t
e=j/h+t
a=sin(sin(i/h)/2+cos(j/h)/2+t)*2
rectfill(i,j,i+a*8,j+a*8,11.5+a/2)
end end
flip()
goto 🐱

