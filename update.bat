echo Execute update for katana packages...
call flutter pub upgrade
call flutter format .
call echo y | flutter pub publish