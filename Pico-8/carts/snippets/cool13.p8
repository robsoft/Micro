pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
cls()i=0::_::fillp(23130)
c=sin(t()/2)*5+10.5
d=flr(sin(t()/2+.04)*5+10.5)
circfill(64+sin(t()/2)*54,10,5,c+d*16)fillp()
x=rnd(128)y=rnd(128)srand(flr(x))
r=sqrt(max(0,1-y/(110+rnd(17))))
srand(i)i+=1/2^16
v=min(y-rnd(3*r),127)
pset(x,y,pget(x,v))goto _ 
