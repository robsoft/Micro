pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
t=0
l=line
s=64
o=128::_::
for q=1,15 do l(0,s-((t/q)%s),o,s-((t/q)%s),q)l(0,s+((t/q)%s),o,s+((t/q)%s),q)l(s-((t/q)%s),0,s-((t/q)%s),o,q)l(s+((t/q)%s),0,s+((t/q)%s),o,q)end
t=t+1
flip()goto _ 

