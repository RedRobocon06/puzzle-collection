// GameCube "Nintendo Puzzle Collection" Japanese To English Translation

endian msb // GameCube PPC requires Big-Endian Encoding (Most Significant Bit)
output "../output/Nintendo Puzzle Collection [U].iso", create
origin $000000; insert "../input/Nintendo Puzzle Collection [J].iso" // Include Japanese Puzzle Collection ISO

macro Text(OFFSET, TEXT) {
  map 0, 0, 256 // Map Default ASCII Chars
  map '|', 0x00 // End of string
  map '\n', 0x0A // New line

  origin {OFFSET}
  variable availableLength = 0;
  while (read(origin() + availableLength) != 0x00) {
    ds 1
  }

  if (read(origin()) == 0x00) {
    fill 1
  }
  if (read(origin()) == 0x00) {
    fill 1
  }
  if (read(origin()) == 0x00) {
    fill 1
  }
  if (read(origin()) == 0x00) {
    fill 1
  }

  availableLength = origin() - {OFFSET} - 1
  
  origin {OFFSET}
  db {TEXT} // ASCII Text To Print

  variable newLength = origin() - {OFFSET}
  if (newLength > availableLength) {
    print {TEXT}
    print " is too big by "
    print (newLength - availableLength)
  }

  while (read(origin()) != 0x00) {
    fill 1
  } 
}

// Warning: use address first!!
macro Text(TEXT) {
  variable i = 40;
  while (i > 0 && read(origin()) < 0x01) {
    ds 1
    i = i - 1;
  }
  
  variable ori = origin()
  Text(ori, {TEXT})
}

macro TextShiftJIS(OFFSET, TEXT) {
  // Map Shift-JIS Words
  map ' ',  $8140
  map $2C,  $8143 // Comma ","
  map '.',  $8144
  map ':',  $8146
  map '?',  $8148
  map '!',  $8149
  map '~',  $8160
  //map '\s', $8166 // Single Quote "'"
  //map '\d', $8168 // Double Quote '"'
  map '+',  $817B
  map '&',  $8195
  map '0',  $824F, 10 // Map Numbers
  map 'A',  $8260, 26 // Map English "Upper Case" Characters
  map 'a',  $8281, 26 // Map English "Lower Case" Characters

  origin {OFFSET}
  dw {TEXT} // Shift-JIS Text To Print
}

//Not a real assert, just prints the error message in console and doesn't compile further
macro Assert(MESSAGE) {
  "{MESSAGE}\n"
}

macro ReplaceAsset(ORIGIN, FILE, SIZE) {
  if !file.exists({FILE}) {
    print "{FILE} doesn't exist!"
  } else if file.exists({FILE}) {
    if (file.size({FILE}) > {SIZE} && {SIZE} != -1) {
      Assert("File {FILE} is bigger than Size {SIZE}")
    } else if (file.size({FILE}) <= {SIZE}) {
      origin {ORIGIN}
      insert {FILE}
      fill {SIZE} - file.size({FILE})
    }
  }
}

//Region
//Uncomment BOTH lines to change region to NTSC-U.
//Doing so will garble the untranslated Japanese characters.
origin $3; db $45 //E
origin $45B; db $01

include "Banner.asm"
include "Control.asm"
include "Seg.asm"
include "System.asm"

include "Menu/Main.asm"
include "DrMario/Main.asm"
//include "PuzzleLeague/Main.asm"
include "YCookie/Main.asm"
