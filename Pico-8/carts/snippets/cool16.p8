pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
cls()t,m,z,s,c=0,127,64,sin,cos::_::t+=.01
function a(d,e)
return sqrt((d-64)^2+(e-64)^2)/20
end
for i=0,m,3 do
for j=0,m,3 do
b=a(i,j)v=c(i/z)*c(j/z)*b+s(t)*b
v+=z
rect(i,j,i+2,j+2,v%3+5)
end end
flip()goto _
