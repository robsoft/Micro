pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
s,c,r,t,h,m=sin,cos,rnd,0,127,64::_::srand()cls()t+=.01
function b(x,y,n)
a=12
for i=1,n do
d,e=i/n+t+i/n,(i+1)/n+t
line(x+c(d)*a,y+s(d)*a,x+c(e)*a,y+s(e)*a,7+n)
end end
for j=1,8 do
z=32
b(m+c(j/8+t)*z,
m+s(j/8+t)*z*s(t),j)
end
flip()goto _
