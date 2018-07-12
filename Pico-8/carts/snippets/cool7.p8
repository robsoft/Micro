pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
::_::cls(4)srand()for i=0,1500 do
x=rnd(1500)l=sqrt((rnd()-t()/9)%1*100)/10
x*=1-l
y=170-250*l
circ(x,y,(1-l)+rnd(),5+rnd(6))
end
for j=0,1 do
for i=0,70 do
h=0
if(i<9)h=(4-abs(i-4))/2
circ(64+i/2+sin(i/40-t())*3,63+i,1.5+j+i/25+h,(4+i%2*5)*j+7*(1-j))
end
end
flip()goto _ 

