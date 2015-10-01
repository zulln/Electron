::Batch script for building native NodeJS modules for Windows (X86)
@echo off
set version=%1
if [%1]==[] set version=0.33.3
::Currently defaulting to 0.33.3 if no argument is set
::TODO: Implement electron --version functionality
set arch=ia32
echo Version: %version%
node-gyp rebuild --target=%version% --arch=%arc% --dist-url=https://atom.io/download/atom-shell
