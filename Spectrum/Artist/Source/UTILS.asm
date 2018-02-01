	org 45000
	ld hl, 16384		 ; copy screen to 45100
	ld de, 45100		 ;
	ld bc, 6912		 ;
	ldir			 ;
	ret			 ;
	ld hl, 45100		 ; restore screen from 45100
	ld de, 16384		 ;
	ld bc, 6912		 ;
	ldir			 ;
	ret			 ;
	ld hl, 45100		 ; restore screen from 45100
	ld de, 16384		 ;
	ld bc, 6144		 ; omitting attribs
	ldir			 ;
	ret			 ;
