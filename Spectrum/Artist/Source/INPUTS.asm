                             ; first draft keyboard reading routine to replace some BASIC
                             ;
                             ; Kempston mouse and joystick not implemented yet
                             ; DEBUG CODE - PRESS 0 TO RETURN TO BASIC
                             ; Q,A,O,P move cursor
                             ; SPACE, ENTER, 1 and 0 are detected and indicated
                             ; K and J alter cursor speed
                             ;
P_FLAG     equ 23697
ATTR_P     equ 23693
LAST_K     equ 23560
ROM_PLOT   equ 8937
BEEPER     equ 949
CLS        equ 8859
CHAN2      equ 3503
OPEN_CHAN  equ 5633
PRINT_BC   equ 6683

           org 63000         ; everyone has to start somewhere
           jp init           ; for ease of use in BASIC, we're going to keep
                             ; our variables at the start of the routine, so
                             ; jump up out of the way, this is probably sub-optimal
                             ;
           nop               ; to get us on byte align
action     defb 0, 0         ; we store our 'action' indicator, then one unused byte
xpos       defb 10, 0        ; have 2 bytes to make BC printing easy for now
oldxpos    defb 0, 0         ; store old x position
ypos       defb 10, 0        ; have 2 bytes to make BC printing easy for now
oldypos    defb 255, 0       ; store old y position
speed      defb 1, 0         ; have 2 bytes to make BC printing easy for now
drawmode   defb 1, 0         ; whether we're trailing a line or not
debugmode  defb 1, 0         ; whether to show debug info or not
newgui     defb 1, 0         ; whether to show new gui or not
                             ;
                             ;
                             ; screen init code
                             ; ================
init       ei
           ld a, 71          ; black paper, white ink
           ld (ATTR_P), a    ; save attribs
           xor a             ; a = 0
           ld (action), a    ; reset our action indicator
           call CLS          ; clear the screen
           call CHAN2        ; setup channel 2
           jp plotdraw       ;
                             ;
                             ;
                             ; main code
                             ; =========
mainloop   xor a             ; a = 0
           ld (action), a    ; reset our action indicator
                             ;
           ld bc, 57342      ; keyrow for Y-P
           in a,(c)          ; get value
           push af           ; save it so we don't need to re-read in a moment
           cp 190            ; P key pressed?
           call z, moveright ; move cursor right
                             ;
           pop af            ; get action back
           cp 189            ; O key pressed?
           call z, moveleft  ; move cursor left
                             ;
           ld bc, 64510      ; keyrow for Q-T
           in a,(c)          ; get value
           cp 190            ; Q key pressed?
           call z, movedown  ; move cursor down (towards origin)
                             ;
           ld bc, 65022      ; keyrow for A-G
           in a,(c)          ; get value
           cp 190            ; A key pressed?
           call z, moveup    ; move cursor up
                             ;
           ld a, (action)    ; ok, so have we 'moved' at all?
           cp 7              ;
           jp z, plot       ; if so, skip straight to drawing
                             ;
                             ; ideally the following keys would be debounced
                             ; or whatever, so there was no auto-repeat going on
                             ; or at least there was a delay between repeats
                             ;
           ld bc, 32766      ; keyrow for B-SPACE
           in a,(c)          ; get value
           cp 190            ; SPACE key pressed?
           call z, spacehit  ; update action
                             ;
           ld bc, 63486      ; keyrow for 1-5
           in a,(c)          ; get value
           cp 190            ; 1 key pressed?
           call z, onehit    ; update action
           cp 189
           call z, twohit
                             ;
           ld bc, 61438      ; keyrow for 6-0
           in a,(c)          ; get value
           cp 190            ; 0 key pressed?
           call z, zerohit   ; update action
                             ;
           ld bc, 49150      ; keyrow for H-ENTER
           in a,(c)          ; get value
           push af           ; save it
           cp 190            ; ENTER key pressed?
           call z, enterhit  ; update action
                             ;
           pop af            ; get it back
           push af           ; and save it again
           cp 187            ; K key pressed? (+) symbol
           call z, speedup   ; speed up cursor
                             ;
           pop af            ; get action value again
           cp 183            ; J key pressed? (-) symbol
           call z, speeddown ; slow down cursor
                             ;
           ld a, (action)    ; ok, so have we done anything else
           cp 0              ;
           jp z, endprint    ; if not, skip straight to end, no need to draw or refresh
                             ;
                             ; start debug code
                             ; ================
                             ; debugging - in final routine, we'd loop around
                             ; until the action code!=0, at which point we'd RET
                             ; to let BASIC handle things. But for now we're just
                             ; blindy plotting, printing to the screen and looping forever
                             ; until 0 key is pressed
                             ;
plot       ld hl, P_FLAG     ; get P_FLAG
           set 0, (hl)       ; set bit 1
                             ;
           ld a, (drawmode)  ; do we need to rub out the previous pixel?
           cp 0              ;
           jp z, plotdraw   ; no, we don't
                             ;
undraw     ld a, (oldypos)   ; crappy hack to easily plot the pixel
           cp 255
           jp z, plotdraw
           ld b, a           ;
           ld a, (oldxpos)   ;
           ld c, a           ;
           call ROM_PLOT     ; ROM PLOT - not the entry point, assumes BC setup
                             ;
plotdraw   ld a, (ypos)      ; crappy hack to easily plot the pixel
           ld b, a           ;
           ld (oldypos), a   ; save it
           ld a, (xpos)      ;
           ld c, a           ;
           ld (oldxpos), a   ; save it
           call ROM_PLOT     ; ROM PLOT - not the entry point, assumes BC setup
                             ;
print      ld a, (debugmode) ;
           cp 0              ;
           jp z, endprint    ; not printing debug, skip
                             ;
           ld a, 1
           call OPEN_CHAN
           ld hl, P_FLAG     ; get P_FLAG
           res 0, (hl)       ; reset bit 0
           ld a, 22          ; now print at 0, 0
           rst 16            ;
           ld a, 0           ;
           rst 16            ;
           ld a, 0           ;
           rst 16            ;
           ld bc, (xpos)     ; get the xpos value (xpos in C, B is 0)
           call PRINT_BC     ; print BC
           ld a, 44          ; and a comma
           rst 16            ;
           ld bc, (ypos)     ; get the ypos value (ypos in C, B is 0)
           call PRINT_BC     ; print BC
           ld a, 32          ; and print 2 trailing spaces
           rst 16            ;
           ld a, 32          ;
           rst 16            ;

           ld a, 22          ; now, print at 1, 0
           rst 16            ;
           ld a, 1           ;
           rst 16            ;
           ld a, 0           ;
           rst 16            ;
           ld bc, (speed)    ; get the speed value (speed in C, B is 0)
           call PRINT_BC     ; print BC
           ld a, 32          ; and print a trailing space
           rst 16            ;

           ld a, 22          ; print at 1, 16
           rst 16            ;
           ld a, 1           ;
           rst 16            ;
           ld a, 16           ;
           rst 16            ;
           ld a, (action)    ; get the action value
           add a, 48         ; normalise it (0='0', 1='1' etc)
           rst 16            ; print it
                             ;
endprint   ld a, (action)    ; get the action value
           cp 6              ; if it was 6 (zero pressed)
           ret z             ; then we return to basic
                             ; otherwise
           cp 5
           call z, debounce
           ld a, (action)
           cp 2
           call z, debounce
                             ;
           halt              ; wait for an interrupt
           jp mainloop       ; go back to the top
                             ;
                             ; end debug code
                             ; ==============
                             ;
                             ;
                             ; subroutines
                             ; ===========
                             ;
speeddown  ld a, (speed)     ; fetch the speed
           dec a             ; subtract 1
           ret z
           jp savespeed
speedup    ld a, (speed)     ; fetch the speec
           inc a             ; add 1
           cp 11             ; we're good as long as its <=10
           ret z
savespeed  push af
           call sysbeep
           pop af
           ld (speed), a     ; save A back into the speed var
           ld a, 2           ; action code = 2
           ld (action), a    ; save action code
           ret

enterhit   ld a, 3           ; action code = 3
           ld (action), a    ; save action code
           ret

spacehit   ld a, 4           ; action code = 4
           ld (action), a    ; save action code
           ret

onehit     ld a, 5           ; action code = 5
           ld (action), a    ; save action code
           ld a, (drawmode)  ;
           ld b, %00000001   ;
           xor b             ;
           ld (drawmode), a  ;
           ld hl, oldypos
           ld (hl), 255
           ret

twohit     ld a, 5           ; action code = 5
           ld (action), a    ; save action code
           ld a, (debugmode)  ;
           ld b, %00000001   ;
           xor b             ;
           ld (debugmode), a  ;
           ld hl, oldypos
           ret

zerohit    ld a, 6           ; action code = 6
           ld (action), a    ; save action code
           ret

moveright  ld a, (xpos)      ; fetch the current xpos in A
           ld hl, speed      ; get speed address into HL
           ld c, (hl)        ; load C with speed
           add a, c          ; add C to A
           jp nc, savex      ; if it's not overflowed, we're good to save
           ret               ; ignore event

moveleft   ld a, (xpos)      ; fetch current xpos in A
           ld hl, speed      ; get speed address into HL
           ld c, (hl)        ; load C with speed
           sub c             ; subtract C from A
           jp nc, savex      ; if not underflow, we're good to save
           ret               ; ignore event

moveup     ld a, (ypos)      ; get ypos into A
           ld hl, speed      ; get speed address in HL
           ld c, (hl)        ; get speed in C
           sub c             ; subtract C from A
           jp nc, savey      ; if no underflow, we're good to save
           ret               ; ignore event

movedown   ld a, (ypos)      ; get ypos into A
           ld hl, speed      ; and get speed adddress in HL
           ld c, (hl)        ; get speed into C
           add a, c          ; add C to A
           cp 176            ; compare 176
           jp c, savey       ; if A <176 we can save it
           ret               ; ignore event

savey      ld (ypos), a      ; save A back into ypos
           jp commoncur      ; go and save it etc

savex      ld (xpos), a      ; save A back into xpos
                             ; drop thru into commoncur code

commoncur  ld a, 7           ; action code for cursor move = 7
           ld (action), a    ; update action code
           ret

sysbeep    nop
           IF 0
             ld hl, 1642
             ld de, 26
             call BEEPER
           ENDIF
           ret

debounce   ld a, 0
           in a, (254)
           cpl
           and %00011111
           jp nz, debounce
           ret

end 63000
