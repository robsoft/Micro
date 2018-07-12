pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
t,h=0,136::🐱::cls(7)t+=.005
for i=-8,h,3 do
for j=-8,h,3 do
d=i/h+t
e=j/h+t
a=sin(sin(i/h*cos(t/3))+cos(j/h*cos(t/2)+t)+cos(t/2)+3*t)*2
circfill(i+a,j+a,1,0)
end end
flip()
goto 🐱
