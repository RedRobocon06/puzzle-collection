@echo off

set ISOFile=..\input\Nintendo Puzzle Collection [J].iso
set ISOTargetSize=1459978240

if not exist "%ISOFile%" (
	echo [INFO] "%ISOFile%" was not found
	echo Did you name the ROM correctly and place it in the correct folder?
	echo Exiting in 10 seconds..
	C:\Windows\System32\timeout.exe /t 10 /nobreak >nul
	exit /b 0
)

for %%F in ("%ISOFile%") do (
    set "ISOSize=%%~zF"
)

if %ISOSize% neq %ISOTargetSize% (
    echo [INFO] "%ISOFile%" has an incorrect size
    echo Are you using the uncompressed ROM?
    echo Exiting in 10 seconds..
    C:\Windows\System32\timeout.exe /t 10 /nobreak >nul
    exit /b 0
)

echo [INFO] Compiling patches - Please wait..

py extract.py "../src/Menu/fs/menu_relsamp.szp" "../input/Nintendo Puzzle Collection [J].iso" 0x1D4EC90 2580535
py extract.py "../src/DrMario/fs/dr_mario.szp" "../input/Nintendo Puzzle Collection [J].iso" 0xE413BC 2585632
::py extract.py "../src/PuzzleLeague/fs/panepon.szp" "../input/Nintendo Puzzle Collection [J].iso" 0x2F19E24 1111675
::note: panepon.szp should be extracted from April's translation as a base
py extract.py "../src/YCookie/fs/ycookie.szp" "../input/Nintendo Puzzle Collection [J].iso" 0x699BA58 480778

py decompress.py ../src/Menu/fs/menu.szp ../src/Menu/fs/menu.rel
py decompress.py ../src/Menu/fs/menu_relsamp.szp ../src/Menu/fs/menu_relsamp.rel
py decompress.py ../src/DrMario/fs/dr_mario.szp ../src/DrMario/fs/dr_mario.rel
py decompress.py ../src/PuzzleLeague/fs/panepon.szp ../src/PuzzleLeague/fs/panepon.rel
py decompress.py ../src/YCookie/fs/ycookie.szp ../src/YCookie/fs/ycookie.rel

bass\\win\\bass.exe ..\\src\\Menu\\Main.asm
bass\\win\\bass.exe ..\\src\\DrMario\\Main.asm
bass\\win\\bass.exe ..\\src\\PuzzleLeague\\Main.asm
bass\\win\\bass.exe ..\\src\\YCookie\\Main.asm
 
szp.exe ../src/Menu/fs/menu-eng.rel
ren .szp "menu-eng.szp"
move menu-eng.szp "../src/Menu/fs/"
szp.exe ../src/Menu/fs/menu_relsamp-eng.rel
ren .szp "menu_relsamp-eng.szp"
move menu_relsamp-eng.szp "../src/Menu/fs/"
szp.exe ../src/DrMario/fs/dr_mario-eng.rel
ren .szp "dr_mario-eng.szp"
move dr_mario-eng.szp "../src/DrMario/fs/"
szp.exe ../src/PuzzleLeague/fs/panepon-eng.rel
ren .szp "panepon-eng.szp"
move panepon-eng.szp "../src/PuzzleLeague/fs/"
szp.exe ../src/YCookie/fs/ycookie-eng.rel
ren .szp "ycookie-eng.szp"
move ycookie-eng.szp "../src/YCookie/fs/"

bass\\win\\bass.exe ..\\src\\Main\\Main.asm

echo [INFO] Patches compiled
echo ---------- 
echo Finished!
echo ----------
C:\Windows\System32\timeout.exe /t 5 /nobreak >nul
exit /b 0