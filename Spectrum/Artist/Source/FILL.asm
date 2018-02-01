	org 64800
	di			 ; 64800 243 4ts
	jp l_fdca		 ; 64801 195 202 253 10ts
l_fd24: inc bc			 ; 64804 3     6ts
	push hl			 ; 64805 229 11ts
	nop			 ; 64806 0     4ts
l_fd27: push bc			 ; 64807 197 11ts
	ld a, 175		 ; 64808 62     175 7ts
	sub b			 ; 64810 144 4ts
	jr nc, l_fd31		 ; 64811 48     4	 7/12ts
	ld a, 1			 ; 64813 62     1	 7ts
	pop bc			 ; 64815 193 10ts
	ret			 ; 64816 201 10ts
l_fd31: push hl			 ; 64817 229 11ts
	call 8910		 ; 64818 205 206 34     17ts
	call 11682		 ; 64821 205 162 45     17ts
	pop hl			 ; 64824 225 10ts
	ld a, c			 ; 64825 121 4ts
	pop bc			 ; 64826 193 10ts
	ret			 ; 64827 201 10ts
l_fd3c: push bc			 ; 64828 197 11ts
	ld a, 175		 ; 64829 62     175 7ts
	sub b			 ; 64831 144 4ts
	jr nc, l_fd46		 ; 64832 48     4	 7/12ts
	ld a, 0			 ; 64834 62     0	 7ts
	pop bc			 ; 64836 193 10ts
	ret			 ; 64837 201 10ts
l_fd46: ld b, a			 ; 64838 71     4ts
	ld e, c			 ; 64839 89     4ts
	ld c, b			 ; 64840 72     4ts
	ld b, 0			 ; 64841 6     0	 7ts
	sla c			 ; 64843 203 33	 8ts
	rl b			 ; 64845 203 16	 8ts
	sla c			 ; 64847 203 33	 8ts
	rl b			 ; 64849 203 16	 8ts
	sla c			 ; 64851 203 33	 8ts
	rl b			 ; 64853 203 16	 8ts
	sla c			 ; 64855 203 33	 8ts
	rl b			 ; 64857 203 16	 8ts
	sla c			 ; 64859 203 33	 8ts
	rl b			 ; 64861 203 16	 8ts
	ld a, e			 ; 64863 123 4ts
	srl e			 ; 64864 203 59	 8ts
	srl e			 ; 64866 203 59	 8ts
	srl e			 ; 64868 203 59	 8ts
	ld d, 0			 ; 64870 22     0	 7ts
	ld hl, (l64804)		 ; 64872 42     36	 253 16ts
	add hl, de		 ; 64875 25     11ts
	add hl, bc		 ; 64876 9     11ts
	sla e			 ; 64877 203 35	 8ts
	sla e			 ; 64879 203 35	 8ts
	sla e			 ; 64881 203 35	 8ts
	pop bc			 ; 64883 193 10ts
	ld a, c			 ; 64884 121 4ts
	sub e			 ; 64885 147 4ts
	add a, 1		 ; 64886 198 1	 7ts
	ret			 ; 64888 201 10ts
l_fd79: ld b, a			 ; 64889 71     4ts
	ld a, (hl)		 ; 64890 126 7ts
l_fd7b: sla a			 ; 64891 203 39	 8ts
	djnz l_fd7b		 ; 64893 16     252 8/13ts
	jr c, l_fd84		 ; 64895 56     3	 12/7ts
	ld a, 0			 ; 64897 62     0	 7ts
	ret			 ; 64899 201 10ts
l_fd84: ld a, 1			 ; 64900 62     1	 7ts
	ret			 ; 64902 201 10ts
l_fd87: ld b, a			 ; 64903 71     4ts
	ld a, 0			 ; 64904 62     0	 7ts
	scf			 ; 64906 55     4ts
l_fd8b: rra			 ; 64907 31     4ts
	djnz l_fd8b		 ; 64908 16     253 8/13ts
	or (hl)			 ; 64910 182 7ts
	ld (hl), a		 ; 64911 119 7ts
	ret			 ; 64912 201 10ts
l_fd91: push bc			 ; 64913 197 11ts
	push hl			 ; 64914 229 11ts
	push de			 ; 64915 213 11ts
	call l64828		 ; 64916 205 60	 253 17ts
	cp 0			 ; 64919 254 0	 7ts
	jr nz, l_fd9f		 ; 64921 32     4	 7/12ts
	pop de			 ; 64923 209 10ts
	pop hl			 ; 64924 225 10ts
	pop bc			 ; 64925 193 10ts
	ret			 ; 64926 201 10ts
l_fd9f: call l64889		 ; 64927 205 121 253 17ts
	pop de			 ; 64930 209 10ts
	pop hl			 ; 64931 225 10ts
	pop bc			 ; 64932 193 10ts
	ret			 ; 64933 201 10ts
l_fda6: push bc			 ; 64934 197 11ts
	push hl			 ; 64935 229 11ts
	push de			 ; 64936 213 11ts
	call l64828		 ; 64937 205 60	 253 17ts
	cp 0			 ; 64940 254 0	 7ts
	jr nz, l_fdb4		 ; 64942 32     4	 7/12ts
	pop de			 ; 64944 209 10ts
	pop hl			 ; 64945 225 10ts
	pop bc			 ; 64946 193 10ts
	ret			 ; 64947 201 10ts
l_fdb4: call l64903		 ; 64948 205 135 253 17ts
	pop de			 ; 64951 209 10ts
	pop hl			 ; 64952 225 10ts
	pop bc			 ; 64953 193 10ts
	ret			 ; 64954 201 10ts
l_fdbb: push bc			 ; 64955 197 11ts
	push af			 ; 64956 245 11ts
	ld a, 175		 ; 64957 62     175 7ts
	sub b			 ; 64959 144 4ts
	jr c, l_fdc7		 ; 64960 56     5	 12/7ts
	push hl			 ; 64962 229 11ts
	call 8927		 ; 64963 205 223 34     17ts
	pop hl			 ; 64966 225 10ts
l_fdc7: pop af			 ; 64967 241 10ts
	pop bc			 ; 64968 193 10ts
	ret			 ; 64969 201 10ts
l_fdca: ld hl, (l64804)		 ; 64970 42     36	 253 16ts
	ld bc, 5632		 ; 64973 1     0	 22     10ts
l_fdd0: ld (hl), 0		 ; 64976 54     0	 10ts
	inc hl			 ; 64978 35     6ts
	dec bc			 ; 64979 11     6ts
	ld a, b			 ; 64980 120 4ts
	or c			 ; 64981 177 4ts
	cp 0			 ; 64982 254 0	 7ts
	jr nz, l_fdd0		 ; 64984 32     246 7/12ts
	ld hl, (23677)		 ; 64986 42     125 92     16ts
	push hl			 ; 64989 229 11ts
	ld b, h			 ; 64990 68     4ts
	ld c, l			 ; 64991 77     4ts
l_fde0: inc c			 ; 64992 12     4ts
	call l64807		 ; 64993 205 39	 253 17ts
	cp 0			 ; 64996 254 0	 7ts
	jr nz, l_fdf2		 ; 64998 32     10	 7/12ts
	call l64955		 ; 65000 205 187 253 17ts
	call l64934		 ; 65003 205 166 253 17ts
	jr l_fde0		 ; 65006 24     240 12ts
	nop			 ; 65008 0     4ts
	nop			 ; 65009 0     4ts
l_fdf2: pop hl			 ; 65010 225 10ts
	ld b, h			 ; 65011 68     4ts
	ld c, l			 ; 65012 77     4ts
l_fdf5: dec c			 ; 65013 13     4ts
	call l64807		 ; 65014 205 39	 253 17ts
	cp 0			 ; 65017 254 0	 7ts
	jr nz, l_fe05		 ; 65019 32     8	 7/12ts
	call l64955		 ; 65021 205 187 253 17ts
	call l64934		 ; 65024 205 166 253 17ts
	jr l_fdf5		 ; 65027 24     240 12ts
l_fe05: ld a, 0			 ; 65029 62     0	 7ts
	ld (23681), a		 ; 65031 50     129 92     13ts
	ld hl, (l64804)		 ; 65034 42     36	 253 16ts
	ld bc, 44800		 ; 65037 1     0	 175 10ts
l_fe10: ld a, (hl)		 ; 65040 126 7ts
	cp 0			 ; 65041 254 0	 7ts
	call nz, l65145		 ; 65043 196 121 254 10/17ts
	inc hl			 ; 65046 35     6ts
	ld a, c			 ; 65047 121 4ts
	add a, 8		 ; 65048 198 8	 7ts
	cp 0			 ; 65050 254 0	 7ts
	jr nz, l_fe1f		 ; 65052 32     1	 7/12ts
	dec b			 ; 65054 5     4ts
l_fe1f: ld c, a			 ; 65055 79     4ts
	ld a, 255		 ; 65056 62     255 7ts
	cp b			 ; 65058 184 4ts
	jr z, l_fe9f		 ; 65059 40     122 12/7ts
	jr l_fe10		 ; 65061 24     233 12ts
l_fe27: call l64913		 ; 65063 205 145 253 17ts
	cp 0			 ; 65066 254 0	 7ts
	ret z			 ; 65068 200 11/5ts
	inc b			 ; 65069 4     4ts
	call l64807		 ; 65070 205 39	 253 17ts
	cp 0			 ; 65073 254 0	 7ts
	call z, l65165		 ; 65075 204 141 254 17/10ts
	dec b			 ; 65078 5     4ts
	inc c			 ; 65079 12     4ts
	call l64807		 ; 65080 205 39	 253 17ts
	cp 0			 ; 65083 254 0	 7ts
	call z, l65165		 ; 65085 204 141 254 17/10ts
	dec c			 ; 65088 13     4ts
	dec b			 ; 65089 5     4ts
	call l64807		 ; 65090 205 39	 253 17ts
	cp 0			 ; 65093 254 0	 7ts
	call z, l65165		 ; 65095 204 141 254 17/10ts
	inc b			 ; 65098 4     4ts
	dec c			 ; 65099 13     4ts
	call l64807		 ; 65100 205 39	 253 17ts
	cp 0			 ; 65103 254 0	 7ts
	call z, l65165		 ; 65105 204 141 254 17/10ts
	inc c			 ; 65108 12     4ts
	ret			 ; 65109 201 10ts
l_fe56: push hl			 ; 65110 229 11ts
	ld de, 32		 ; 65111 17     32	 0     10ts
	inc hl			 ; 65114 35     6ts
	ld a, (hl)		 ; 65115 126 7ts
	bit 7, a		 ; 65116 203 127 8ts
	pop hl			 ; 65118 225 10ts
	ret z			 ; 65119 200 11/5ts
	push hl			 ; 65120 229 11ts
	dec hl			 ; 65121 43     6ts
	ld a, (hl)		 ; 65122 126 7ts
	bit 0, a		 ; 65123 203 71	 8ts
	pop hl			 ; 65125 225 10ts
	ret z			 ; 65126 200 11/5ts
	push hl			 ; 65127 229 11ts
	add hl, de		 ; 65128 25     11ts
	ld a, (hl)		 ; 65129 126 7ts
	cp 255			 ; 65130 254 255 7ts
	pop hl			 ; 65132 225 10ts
	ret nz			 ; 65133 192 5/11ts
	push hl			 ; 65134 229 11ts
	and a			 ; 65135 167 4ts
	sbc hl, de		 ; 65136 237 82	 15ts
	ld a, (hl)		 ; 65138 126 7ts
	cp 255			 ; 65139 254 255 7ts
	pop hl			 ; 65141 225 10ts
	ret nz			 ; 65142 192 5/11ts
	pop de			 ; 65143 209 10ts
	ret			 ; 65144 201 10ts
l_fe79: call l65110		 ; 65145 205 86	 254 17ts
	push bc			 ; 65148 197 11ts
	ld e, 0			 ; 65149 30     0	 7ts
l_fe7f: push de			 ; 65151 213 11ts
	call l65063		 ; 65152 205 39	 254 17ts
	pop de			 ; 65155 209 10ts
	inc c			 ; 65156 12     4ts
	inc e			 ; 65157 28     4ts
	ld a, 8			 ; 65158 62     8	 7ts
	cp e			 ; 65160 187 4ts
	jr nz, l_fe7f		 ; 65161 32     244 7/12ts
	pop bc			 ; 65163 193 10ts
	ret			 ; 65164 201 10ts
l_fe8d: call l64913		 ; 65165 205 145 253 17ts
	cp 1			 ; 65168 254 1	 7ts
	ret z			 ; 65170 200 11/5ts
	call l64934		 ; 65171 205 166 253 17ts
	call l64955		 ; 65174 205 187 253 17ts
	ld a, 1			 ; 65177 62     1	 7ts
	ld (23681), a		 ; 65179 50     129 92     13ts
	ret			 ; 65182 201 10ts
l_fe9f: ld a, (23681)		 ; 65183 58     129 92     13ts
	cp 0			 ; 65186 254 0	 7ts
	jp z, l_feec		 ; 65188 202 236 254 10/10ts
	ld a, 0			 ; 65191 62     0	 7ts
	ld (23681), a		 ; 65193 50     129 92     13ts
	ld hl, (l64804)		 ; 65196 42     36	 253 16ts
	ld de, 5631		 ; 65199 17     255 21     10ts
	add hl, de		 ; 65202 25     11ts
	ld bc, 255		 ; 65203 1     255 0     10ts
l_feb6: ld a, (hl)		 ; 65206 126 7ts
	cp 0			 ; 65207 254 0	 7ts
	call nz, l65229		 ; 65209 196 205 254 10/17ts
	dec hl			 ; 65212 43     6ts
	ld a, c			 ; 65213 121 4ts
	sub 8			 ; 65214 214 8	 7ts
	cp 255			 ; 65216 254 255 7ts
	jr nz, l_fec5		 ; 65218 32     1	 7/12ts
	inc b			 ; 65220 4     4ts
l_fec5: ld c, a			 ; 65221 79     4ts
	ld a, 176		 ; 65222 62     176 7ts
	cp b			 ; 65224 184 4ts
	jr z, l_fee1		 ; 65225 40     22	 12/7ts
	jr l_feb6		 ; 65227 24     233 12ts
l_fecd: call l65110		 ; 65229 205 86	 254 17ts
	push bc			 ; 65232 197 11ts
	ld e, 0			 ; 65233 30     0	 7ts
l_fed3: push de			 ; 65235 213 11ts
	call l65063		 ; 65236 205 39	 254 17ts
	pop de			 ; 65239 209 10ts
	dec c			 ; 65240 13     4ts
	inc e			 ; 65241 28     4ts
	ld a, 8			 ; 65242 62     8	 7ts
	cp e			 ; 65244 187 4ts
	jr nz, l_fed3		 ; 65245 32     244 7/12ts
	pop bc			 ; 65247 193 10ts
	ret			 ; 65248 201 10ts
l_fee1: ld a, (23681)		 ; 65249 58     129 92     13ts
	cp 0			 ; 65252 254 0	 7ts
	jp z, l_feec		 ; 65254 202 236 254 10/10ts
	jp l_fe05		 ; 65257 195 5	 254 10ts
l_feec: ld hl, (l64804)		 ; 65260 42     36	 253 16ts
	ld de, 0		 ; 65263 17     0	 0     10ts
	ld bc, 5632		 ; 65266 1     0	 22     10ts
l_fef5: ld a, (hl)		 ; 65269 126 7ts
	push bc			 ; 65270 197 11ts
	ld b, 8			 ; 65271 6     8	 7ts
l_fef9: sla a			 ; 65273 203 39	 8ts
	jr nc, l_fefe		 ; 65275 48     1	 7/12ts
	inc de			 ; 65277 19     6ts
l_fefe: djnz l_fef9		 ; 65278 16     249 8/13ts
	pop bc			 ; 65280 193 10ts
	dec bc			 ; 65281 11     6ts
	inc hl			 ; 65282 35     6ts
	ld a, b			 ; 65283 120 4ts
	or c			 ; 65284 177 4ts
	cp 0			 ; 65285 254 0	 7ts
	jr nz, l_fef5		 ; 65287 32     236 7/12ts
	ld b, d			 ; 65289 66     4ts
	ld c, e			 ; 65290 75     4ts
	ei			 ; 65291 251 4ts
	ret			 ; 65292 201 10ts
	nop			 ; 65293 0     4ts
	nop			 ; 65294 0     4ts
	nop			 ; 65295 0     4ts
	nop			 ; 65296 0     4ts
	nop			 ; 65297 0     4ts
	nop			 ; 65298 0     4ts
	nop			 ; 65299 0     4ts
