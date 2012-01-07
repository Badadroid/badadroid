@echo off

call :main
echo Done!
pause
goto :eof


:main
set ROOT_DIR=%CD%
path %ROOT_DIR%\bin
cd %ROOT_DIR%\src

for /f %%g in ('dir /b *.c') do (call :sub "%%g")
goto :eof


:sub
set C_FLAGS=-c -Os -save-temps -mcpu=cortex-a8 -mfpu=vfpv3 -mfloat-abi=hard -mthumb-interwork
set C_FLAGS=%C_FLAGS% -Wall -nostdinc -std=gnu99 -fshort-wchar -fno-common -fno-strict-aliasing -funsigned-char
gcc %C_FLAGS% %1
goto :eof
