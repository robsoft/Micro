/*

 PACTEXT.C

 Tile Source File.

 Info:
  Form                 : All tiles as one unit.
  Format               : Gameboy 4 color.
  Compression          : None.
  Counter              : None.
  Tile size            : 8 x 8
  Tiles                : 0 to 63

  Palette colors       : Included.
  SGB Palette          : None.
  CGB Palette          : 1 Byte per entry.

  Convert to metatiles : No.

 This file was generated by GBTD v2.2

*/

/* CGBpalette entries. */
/*
const unsigned char TextTileCGB[] =
{
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
};
*/
/* Start of tile array. */
const unsigned char TextTile[] =
{
  0x00,0x00,0x3C,0x3C,0x42,0x42,0x42,0x42,
  0x42,0x42,0x7E,0x7E,0x42,0x42,0x42,0x42,
  0x00,0x00,0x7C,0x7C,0x42,0x42,0x42,0x42,
  0x7C,0x7C,0x42,0x42,0x42,0x42,0x7C,0x7C,
  0x00,0x00,0x3C,0x3C,0x42,0x42,0x40,0x40,
  0x40,0x40,0x40,0x40,0x42,0x42,0x3C,0x3C,
  0x00,0x00,0x7C,0x7C,0x42,0x42,0x42,0x42,
  0x42,0x42,0x42,0x42,0x42,0x42,0x7C,0x7C,
  0x00,0x00,0x7E,0x7E,0x40,0x40,0x40,0x40,
  0x7C,0x7C,0x40,0x40,0x40,0x40,0x7E,0x7E,
  0x00,0x00,0x7E,0x7E,0x40,0x40,0x40,0x40,
  0x7C,0x7C,0x40,0x40,0x40,0x40,0x40,0x40,
  0x00,0x00,0x3C,0x3C,0x42,0x42,0x40,0x40,
  0x4E,0x4E,0x42,0x42,0x42,0x42,0x7E,0x7E,
  0x00,0x00,0x42,0x42,0x42,0x42,0x42,0x42,
  0x7E,0x7E,0x42,0x42,0x42,0x42,0x42,0x42,
  0x00,0x00,0x7C,0x7C,0x10,0x10,0x10,0x10,
  0x10,0x10,0x10,0x10,0x10,0x10,0x7C,0x7C,
  0x00,0x00,0x7E,0x7E,0x04,0x04,0x04,0x04,
  0x04,0x04,0x04,0x04,0x44,0x44,0x38,0x38,
  0x00,0x00,0x42,0x42,0x42,0x42,0x44,0x44,
  0x78,0x78,0x44,0x44,0x42,0x42,0x42,0x42,
  0x00,0x00,0x40,0x40,0x40,0x40,0x40,0x40,
  0x40,0x40,0x40,0x40,0x40,0x40,0x7E,0x7E,
  0x00,0x00,0x42,0x42,0x66,0x66,0x4A,0x4A,
  0x5A,0x5A,0x42,0x42,0x42,0x42,0x42,0x42,
  0x00,0x00,0x42,0x42,0x62,0x62,0x52,0x52,
  0x4A,0x4A,0x46,0x46,0x42,0x42,0x42,0x42,
  0x00,0x00,0x3C,0x3C,0x42,0x42,0x42,0x42,
  0x42,0x42,0x42,0x42,0x42,0x42,0x3C,0x3C,
  0x00,0x00,0x7C,0x7C,0x42,0x42,0x42,0x42,
  0x42,0x42,0x7C,0x7C,0x40,0x40,0x40,0x40,
  0x00,0x00,0x3C,0x3C,0x42,0x42,0x42,0x42,
  0x42,0x42,0x4A,0x4A,0x46,0x46,0x3E,0x3E,
  0x00,0x00,0x7C,0x7C,0x42,0x42,0x42,0x42,
  0x7C,0x7C,0x42,0x42,0x42,0x42,0x42,0x42,
  0x00,0x00,0x3C,0x3C,0x40,0x40,0x40,0x40,
  0x3C,0x3C,0x02,0x02,0x42,0x42,0x3C,0x3C,
  0x00,0x00,0x7C,0x7C,0x10,0x10,0x10,0x10,
  0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10,
  0x00,0x00,0x42,0x42,0x42,0x42,0x42,0x42,
  0x42,0x42,0x42,0x42,0x42,0x42,0x3C,0x3C,
  0x00,0x00,0x42,0x42,0x42,0x42,0x42,0x42,
  0x24,0x24,0x24,0x24,0x24,0x24,0x18,0x18,
  0x00,0x00,0x42,0x42,0x42,0x42,0x42,0x42,
  0x42,0x42,0x42,0x42,0x5A,0x5A,0x24,0x24,
  0x00,0x00,0x42,0x42,0x24,0x24,0x24,0x24,
  0x18,0x18,0x24,0x24,0x24,0x24,0x42,0x42,
  0x00,0x00,0x42,0x42,0x42,0x42,0x42,0x42,
  0x3E,0x3E,0x02,0x02,0x42,0x42,0x3C,0x3C,
  0x00,0x00,0x7E,0x7E,0x04,0x04,0x08,0x08,
  0x10,0x10,0x20,0x20,0x40,0x40,0x7E,0x7E,
  0x00,0x00,0x38,0x38,0x4C,0x4C,0x4C,0x4C,
  0x54,0x54,0x64,0x64,0x64,0x64,0x38,0x38,
  0x00,0x00,0x10,0x10,0x30,0x30,0x10,0x10,
  0x10,0x10,0x10,0x10,0x10,0x10,0x7C,0x7C,
  0x00,0x00,0x38,0x38,0x44,0x44,0x04,0x04,
  0x38,0x38,0x40,0x40,0x40,0x40,0x7C,0x7C,
  0x00,0x00,0x38,0x38,0x44,0x44,0x04,0x04,
  0x38,0x38,0x04,0x04,0x44,0x44,0x38,0x38,
  0x00,0x00,0x40,0x40,0x40,0x40,0x50,0x50,
  0x7C,0x7C,0x10,0x10,0x10,0x10,0x10,0x10,
  0x00,0x00,0x7C,0x7C,0x40,0x40,0x78,0x78,
  0x04,0x04,0x04,0x04,0x44,0x44,0x38,0x38,
  0x00,0x00,0x38,0x38,0x40,0x40,0x40,0x40,
  0x78,0x78,0x44,0x44,0x44,0x44,0x38,0x38,
  0x00,0x00,0x7C,0x7C,0x04,0x04,0x08,0x08,
  0x08,0x08,0x10,0x10,0x10,0x10,0x10,0x10,
  0x00,0x00,0x38,0x38,0x44,0x44,0x44,0x44,
  0x38,0x38,0x44,0x44,0x44,0x44,0x38,0x38,
  0x00,0x00,0x38,0x38,0x44,0x44,0x44,0x44,
  0x3C,0x3C,0x04,0x04,0x44,0x44,0x38,0x38,
  0x00,0x00,0x10,0x10,0x10,0x10,0x10,0x10,
  0x10,0x10,0x00,0x00,0x10,0x10,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x10,0x10,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x54,0x54,0x00,0x00,
  0x00,0x00,0x00,0x00,0x10,0x10,0x00,0x00,
  0x00,0x00,0x10,0x10,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
};

/* End of PACTEXT.C */
