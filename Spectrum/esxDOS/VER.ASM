; ver.asm - produce a 'dot ver' command
; skeleton code, awaiting esxDOS api stuff!

org 0x2000               ; I don't know if I need this yet,
                         ; but in theory the commands are 
                         ; patched in at 0x2000 so in case
                         ; I have any absolutely jumps, I 
                         ; ought to have this I guess.
                         ;
                         ; coming in from esxDOS, hl 
                         ; contains optional parameters
main:      ld a, h       ;
           or l          ; if it's empty, no parameters
           jr z, allGood ;

haveArgs:  ld hl, errMsg ; ok mate we don't support params
           jr print_msg  ; print message and bail

allGood:   ld hl, okMsg  ; it's fine, do our stuff
                         ; so here is where I'd get the 
                         ; version info from the esxDOS API
                         ; decode it and print it
                         ; but for now just fall through
                         ;
print_msg: ld a,(hl)     ; the message address is in hl
           or a          ; zero byte = end of message
           ret z         ; return from call/ret to basic
           rst 10h       ; this is the 'print char in a'
                         ; that esxDOS also supports
           inc hl        ; step along the message
           jr print_msg  ; go back for more


errMsg db "Hey, no args in this one dude", 13, 0
okMsg db "Welcome to the version 0.8.whatever!",13,0

end 0x2000