pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
::_::
cls()
for k=16,144 do
j=k-16
d=.2*sin(t()/2+j/150)
for i=7,-7,-1 do
s=.5*i*cos(sin(4*t()+j/48)/6+i/8)
p=1000/k*d
b=d*j+s+(i-1)*p
a=d*j+s+i*p
f=b>a
if(f)b,a=a,b
line(64+b-1,j,64+a+1,j,7+abs(i))
end
end
flip()
goto _
