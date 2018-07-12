pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
t=0
m=360
c=63
o=cos
s=sin
a={}for i=0,60 do
add(a,6*i)end::_::cls()for i=1,61 do
p=a[i]
b=p/180
r=40+20*s(t/m)
d=40+20*o(t/m)
line(c+d*o(b),c+d*s(b),c+r*o(b+.3),c+r*s(b+.3),8+(t/2+p/6)%6)a[i]=(p+1)%m
end
t=(t+1)%m
flip()goto _

