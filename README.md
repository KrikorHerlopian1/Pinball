# Pinball
Pinball game written in arm assembly, on Raspberry Pi 3.

Compile the code
gcc -g -Wall -o pinball setframe.s dist.s updatepaddle.s initpaddle.s initball.s updatealien.s initalien.s draw_square.s  draw_circle.s paddleballoverlap.s drawimage.s drawdigit.s drawletter.s drawstring.s getdigitimages.s updateball.s  getletterimages.s drawinfo.s doending.s dointro.s drawnumber.s pinball.s -lm


Run the game
./pinball 1
