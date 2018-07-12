pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
o,s,j=19,sin,{2,4,9,10,7}cls()::_::t=time()for i=0,512 do
x,y,z=i%o,flr(i/o),4v,b=9+s(t/10)*6-x,13+s(.25+t/10)*6-y
a,l=atan2(v,b),sqrt(v*v+b*b)c=j[flr((s(a*s(t/20)*10+l/15+t)/5+s((v*b)/150+t)/5)*5.5+3.5)]
if(y%2==0)z=1
?"◆",x*7-z+rnd(2),y*5-4+rnd(2),c
end goto _

