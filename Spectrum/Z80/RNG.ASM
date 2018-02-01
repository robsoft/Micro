; https://www.worldofspectrum.org/forums/discussion/23070/xor-shift-random-number-generator-for-z80/
; Patrik Rak's RND routine with additional optimisation by Einar Saukas (p3 of thread)
;
;
; this is self-modifying code, the random seed is pushed back into the code
; on the line indicated below, so always assemble for a fixed location

        org 41000
rnd:    ld  de,0xDEAD   ; xz -> yw
        ld  hl,0xBEEF   ; yw -> zt
        ld  (rnd+1),hl  ; x = y, z = w
        ld  a,l         ; w = w ^ ( w << 3 )
        add a,a
        add a,a
        add a,a
        xor l
        ld  l,a
        ld  a,d         ; t = x ^ (x << 1)
        add a,a
        xor d
        ld  h,a
        rra             ; t = t ^ (t >> 1) ^ w
        xor h
        xor l
        ld  h,e         ; y = z
        ld  l,a         ; w = t
        ld  (rnd+4),hl
        ld  b,0         ; omit this is not returning to BASIC
        ld c,a          ;
        ret
        
end 41000
