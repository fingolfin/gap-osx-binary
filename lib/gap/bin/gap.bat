set TERMINFO=/cygdrive/c/gap4r7/terminfo
set CYGWIN=nodosfilewarning
set LANG=en_US.UTF-8
set HOME=%HOMEDRIVE%%HOMEPATH%
cd %HOME%
start "GAP" C:\gap4r7\bin\mintty.exe -s 120,40 /cygdrive/c/gap4r7/bin/gapw95.exe -l /cygdrive/c/gap4r7 %*
exit
