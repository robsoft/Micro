pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
s="◆◆◆◆◆◆◆◆◆◆"t=0;a=0
poke(0x5f2c,7)::_::cls()t+=1;a=t/100;for i=1,15 do for y=1,#s do print(sub(s,y,y),i*6+sin(a*y)*5,2+y*6,i)end end;flip()
goto _
