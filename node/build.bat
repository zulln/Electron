::Batch script for building native NodeJS modules for Windows (X86)
@echo off
set version=%1
if [%1]==[] (
  @echo off
  setlocal EnableDelayedExpansion
  set c=0
  for /f "tokens=2 delims=:, " %%a in (' find ":" ^< "%userprofile%\AppData\Roaming\npm\node_modules\electron-prebuilt\package.json" ') do (
     set /a c+=1
     set val[!c!]=%%~a
  )
  set version=!val[2]!
)
::Currently defaulting to 0.33.3 if no argument is set
::TODO: Implement electron --version functionality
set arch=ia32
echo Version: %version%
node-gyp rebuild --target=%version% --arch=%arc% --dist-url=https://atom.io/download/atom-shell
