pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
s,c,t=sin,cos,0::_::cls()t+=.1
srand()h,r=64,rnd
function m(x,y,o)
d=r(32)
for i=0,d do
a,b=x+c(-t*d/h+i/d)*d/8,y+i-t*d
line(a,(h+b)%127,
a+s(i/d/2)*d/4,(h+b)%127,10.5-i/d*2)
end end
for j=0,h do
m(8+r(127),r(127),5+j/20)
end
flip()goto _
