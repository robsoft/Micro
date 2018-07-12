pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
t,h,d,e,f,r=0,127,{},{},64,rnd
for i=1,h do d[i]=0;e[i]=0;end::🐱::srand(flr(t))t+=.01
for i=1,h do
d[i]+=(r(h)-d[i])/f
e[i]+=(r(h)-e[i])/f
b=r(8)+8*sin(t+i/h)g=13+i/48
circfill(d[i],e[i],b,g)circ(d[i],e[i],b+3,g)end
z=f+f*sin(t)rectfill(0,z,h,z+4,5)flip()goto 🐱

