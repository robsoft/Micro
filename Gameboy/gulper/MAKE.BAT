@echo off
del err.txt
del \temp\lcc*.*
c:\gbdk\bin\lcc -Wa-l -Wl-m -Wl-j -Wl-yp0x143=0xC0 -o gulper.GBC gulper.c 2>>err.txt
del gulper.map
del gulper.sym
del \temp\sdcc*.*
type err.txt
pause
c:\gbdk\gbdev\emu\vgb\vgb.exe gulper.GBC


