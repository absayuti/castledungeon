   10 REM Castle Dungeon 0.93 for Agon BASIC
   20 REM Written for Agon but tries to be BBCSDL compatible
   30 REM
   40 REM Using MODE 2 (40x30) in AGON
   50 REM       MODE 8 (40x32) in FAB Agon emulator
   60 REM       MODE 9 (40x32) in BBSDL (Windows/Mac)
   70 REM
   80 REM Shifted the display/maze a few lines down so that
   90 REM it appears in the middle of the screen.
  100 REM Also.. reorganize code.
  110 REM
  120 REM To run on AGON LIGHT:
  130 REM   o Save this file as CASTLED093.BAS in the AGON's SDCARD,
  140 REM     preferably in its BAS folder.
  150 REM   o On AGON, enter:
  160 REM        *CD BAS
  170 REM        LOAD "CASTLE093.BAS"
  180 REM        RUN
  190 REM
  200 REM To run in FAB-agon-emulator:
  210 REM   o Copy CASTLE093.BAS to the sdcard\BAS subfolder inside the
  220 REM     Fab-agon-emulator-v0.9.77 folder.
  230 REM   o Enter the same commands as above.
  240 REM
  250
  260 PROC_initialization
  270 PROC_titlescreen
  280 PROC_customchar
  290 VDU 23,1,0;0;0;0;
  300
  310 play = TRUE
  320 REPEAT
  330   PROC_makemaze
  340   CLS
  350   PROC_initgame
  360   REPEAT
  370     PROC_playgame
  380   UNTIL gameover
  390   play = FN_playagain
  400 UNTIL play = FALSE
  410 CLS
  420 VDU 23,1,1;0;0;0;
  430 PRINT "BYE!"
  440 END
  450
  460
  470 DEF PROC_makemaze
  480 CLS
  490 PRINT TAB(4,mid%);"Please wait"
  500 maze$(0)  = "####################"
  510 maze$(1)  = "#..#..#     #      #"
  520 maze$(2)  = "#..#..# ### # #### #"
  530 maze$(3)  = "#-###-# #   # #..# #"
  540 maze$(4)  = "# #   # # ###-#..# #"
  550 maze$(5)  = "# # # # #  #..#-## #"
  560 maze$(6)  = "#   # #-## #..#    #"
  570 maze$(7)  = "##### #..# #### ####"
  580 maze$(8)  = "#     #..#    # #..#"
  590 maze$(9)  = "# ###-#### #  # #..#"
  600 maze$(10) = "# #    ..# #### ##-#"
  610 maze$(11) = "# #  # ..#         #"
  620 maze$(12) = "# ######## #-##### #"
  630 maze$(13) = "#          #..#..# #"
  640 maze$(14) = "### # #-## #..#..# #"
  650 maze$(15) = "# # # #..# #####-# #"
  660 maze$(16) = "# # # #..#  #..# # #"
  670 maze$(17) = "#   ####### #..# # #"
  680 maze$(18) = "# # #       #-##   #"
  690 maze$(19) = "# #### #### #  # # #"
  700 maze$(20) = "#-#..# #    #  # ###"
  710 maze$(21) = "#....# #  #        #"
  720 maze$(22) = "###### #########-# #"
  730 maze$(23) = "#      #....#....# #"
  740 maze$(24) = "#-######..#-###### #"
  750 maze$(25) = "#......#..#        #"
  760 maze$(26) = "####################"
  770 REM Place stuff at random locations
  780 FOR i=1 TO 3
  790   PROC_randomroom("*")
  800 NEXT
  810 FOR i=1 TO 2
  820   PROC_randomplace("%")
  830 NEXT
  840 FOR i=1 TO 7
  850   PROC_randomroom("%")
  860 NEXT
  870 PROC_randomplace("+")
  880 PROC_randomplace("/")
  890 FOR i=1 TO 3
  900   PROC_randomplace("@")
  910 NEXT
  920 ENDPROC
  930
  940 DEF PROC_randomplace(ch$)
  950 REPEAT
  960   c = RND(20)
  970   r = RND(25)
  980   n$ = MID$(maze$(r),c,1)
  990 UNTIL n$=" "
 1000 m$ = LEFT$(maze$(r),c-1)
 1010 m$ = m$ + ch$
 1020 m$ = m$ + RIGHT$(maze$(r),20-c)
 1030 maze$(r) = m$
 1040 ENDPROC
 1050
 1060 DEF PROC_randomroom(ch$)
 1070 REPEAT
 1080   c = RND(20)
 1090   r = RND(25)
 1100   n$ = MID$(maze$(r),c,1)
 1110 UNTIL n$="."
 1120 m$ = LEFT$(maze$(r),c-1)
 1130 m$ = m$ + ch$
 1140 m$ = m$ + RIGHT$(maze$(r),20-c)
 1150 maze$(r) = m$
 1160 ENDPROC
 1170
 1180 DEF PROC_initgame
 1190 REPEAT
 1200   col = RND(20)
 1210   row = RND(25)
 1220   n$ = MID$(maze$(row),col,1)
 1230 UNTIL n$=" "
 1240 cc = 0 :rr = 0
 1250 timelimit = 30000
 1260 tstart = TIME
 1270 gameover = FALSE
 1280 spell = 0
 1290 usword = FALSE
 1300 ukey = FALSE
 1310 ubombs = 0
 1320 PROC_sound_pling
 1330 ENDPROC
 1340
 1350 REM **************** THE GAME LOOP **********************
 1360 DEF PROC_playgame
 1370 COLOUR YELLOW%
 1380 PROC_moveplayer
 1390 IF spell=2 THEN spell=0
 1400 IF spell=1 THEN spell=2
 1410 tgame = TIME - tstart
 1420 IF tgame > timelimit THEN PROC_lostcastle :gameover=TRUE
 1430 PROC_printtimebar(tgame)
 1440 PROC_printstatus
 1450 k = INKEY(1000)
 1460 IF k=8 OR k=136 THEN cc=-1
 1470 IF k=21 OR k=137 THEN cc=1
 1480 IF k=11 OR k=139 THEN rr=-1
 1490 IF k=10 OR k=138 THEN rr=1
 1500 IF k=76 OR k=108 THEN PROC_sound_levitate :spell = 1
 1510 ns$ = MID$(maze$(row+rr),col+cc,1)
 1520 IF ns$="#" THEN cc=0 :rr=0
 1530 IF ns$="/" THEN PROC_removeitem(col+cc,row+rr) :usword=TRUE
 1540 IF ns$="+" THEN PROC_removeitem(col+cc,row+rr) :ukey = TRUE
 1550 IF ns$="*" THEN PROC_removeitem(col+cc,row+rr) :ubombs=ubombs+1
 1560 IF ubombs=3 THEN PROC_savedcastle :gameover = TRUE
 1570 IF ns$="@" AND spell=0 THEN PROC_fellpit :gameover=TRUE
 1580 IF ns$="%" AND usword THEN PROC_killbeast
 1590 IF ns$="%" AND usword=FALSE THEN PROC_beastlost :gameover = TRUE
 1600 IF ns$="-" AND ukey THEN PROC_removeitem(col+cc,row+rr)
 1610 IF ns$="-" AND ukey=FALSE THEN PROC_doorbumped
 1620 ENDPROC
 1630 REM **********************************************
 1640
 1650 DEF PROC_printtimebar(tgame)
 1660 tbar = INT((timelimit-tgame)/3000)
 1670 IF tbar>9 THEN tbar = 9
 1680 IF tbar=0 THEN COLOUR RED% ELSE COLOUR CYAN%
 1690 REM
 1700 FOR i=0 TO tbar
 1710   PRINT TAB(i*2,bot%);CHR$(bar%);;CHR$(bar%);
 1720 NEXT
 1730 PRINT "  "
 1740 ENDPROC
 1750
 1760 DEF PROC_printstatus
 1770 COLOUR BLACK%
 1780 COLOUR CYAN%+128
 1790 r = 23+top%
 1800 IF usword THEN PRINT TAB(30,bot%);CHR$(sword%);CHR$(sword%+1)
 1810 IF ukey THEN PRINT TAB(32,bot%);CHR$(key%);CHR$(key%+1)
 1820 IF ubombs>0 THEN PRINT TAB(34,bot%);CHR$(bomb%);CHR$(bomb%+1)
 1830 IF ubombs>1 THEN PRINT TAB(36,bot%);CHR$(bomb%);CHR$(bomb%+1)
 1840 IF ubombs>2 THEN PRINT TAB(38,bot%);CHR$(bomb%);CHR$(bomb%+1)
 1850 COLOUR GREEN%
 1860 COLOUR BLACK%+128
 1870 IF spell THEN PRINT TAB(29,bot%);"L"; ELSE PRINT TAB(29,bot%);" ";
 1880 COLOUR YELLOW%
 1890 ENDPROC
 1900
 1910 DEF PROC_moveplayer
 1920 COLOUR YELLOW%
 1930 PROC_erasepart(col,row)
 1940 col = col+cc
 1950 row = row+rr
 1960 PROC_printpart(col,row)
 1970 cc = 0
 1980 rr = 0
 1990 REM PROC_sound_step
 2000 ENDPROC
 2010
 2020 DEF PROC_printpart(c,r)
 2030 FOR j=0 TO 2
 2040   FOR i=0 TO 2
 2050     n$ = MID$(maze$(r+j-1),c+i-1,1)
 2060     mm$ = FN_convert(n$)
 2070     PRINT TAB((c+i)*2-4,r+j-1+top%);mm$
 2080   NEXT
 2090 NEXT
 2100 PRINT TAB(c*2-2,r+top%);CHR$(man%);CHR$(man%+1)
 2110 ENDPROC
 2120
 2130 DEF PROC_erasepart(c,r)
 2140 FOR i=0 TO 2
 2150   IF r+i>0 THEN PRINT TAB(c*2-4,r-1+i+top%);"      "
 2160 NEXT
 2170 ENDPROC
 2180
 2190 DEF PROC_removeitem(c,r)
 2200 SOUND 1,-15,166,1
 2210 m1$ = LEFT$(maze$(r),c-1)
 2220 m2$ = RIGHT$(maze$(r),20-c)
 2230 maze$(r) = m1$+" "+m2$
 2240 k = INKEY(7)
 2250 SOUND 2,-15,190,1
 2260 ENDPROC
 2270
 2280 DEF PROC_printmaze
 2290 COLOUR WHITE%
 2300 PRINT TAB(0,top%);
 2310 FOR r=0 TO 22
 2320   m$ = maze$(r)
 2330   FOR c=1 TO 20
 2340     n$ = MID$(m$,c,1)
 2350     x$ = FN_convert(n$)
 2360     PRINT x$;
 2370   NEXT
 2380 NEXT
 2390 ENDPROC
 2400
 2410 DEF FN_convert(n$)
 2420 mm$ = ""
 2430 IF n$=" " THEN mm$=CHR$(empty%)+CHR$(empty%)
 2440 IF n$="." THEN mm$=CHR$(empty%)+CHR$(empty%)
 2450 IF n$="#" THEN mm$=CHR$(wall%)+CHR$(wall%)
 2460 IF n$="-" THEN mm$=CHR$(door%)+CHR$(door%)
 2470 IF n$="+" THEN mm$=CHR$(key%)+CHR$(key%+1)
 2480 IF n$="/" THEN mm$=CHR$(sword%)+CHR$(sword%+1)
 2490 IF n$="*" THEN mm$=CHR$(bomb%)+CHR$(bomb%+1)
 2500 IF n$="@" THEN mm$=CHR$(pit%)+CHR$(pit%+1)
 2510 IF n$="%" THEN mm$=CHR$(beast%)+CHR$(beast%+1)
 2520 =mm$
 2530
 2540 DEF PROC_lostcastle
 2550 PROC_printmaze
 2560 PROC_explode
 2570 COLOUR RED%
 2580 PRINT TAB(10,mid%);"THE CASTLE DESTROYED"
 2590 k = INKEY(100)
 2600 ENDPROC
 2610
 2620 DEF PROC_explode
 2630 SOUND 0,-15,4,10
 2640 COLOUR RED%
 2650 FOR col=0 TO 70
 2660   SOUND 1,-15,col,1
 2670   row=col
 2680   IF row>22 THEN row=22
 2690   FOR n=row TO 0 STEP-1
 2700     IF col-n<40 THEN PRINT TAB(col-n,n+top%);" ";
 2710   NEXT
 2720 NEXT
 2730 CLS
 2740 ENDPROC
 2750
 2760 DEF PROC_savedcastle
 2770 CLS
 2780 COLOUR WHITE%
 2790 PRINT TAB(0,4)
 2800 PRINT TAB(9);"# # #             # # #"
 2810 PRINT TAB(9);"#####             #####"
 2820 PRINT TAB(9);"##### # # # # # # #####"
 2830 PRINT TAB(9);"#######################"
 2840 PRINT TAB(9);" #####################"
 2850 PRINT TAB(9);"  ###################"
 2860 PRINT TAB(9);"  ###################"
 2870 PRINT TAB(9);"  ###################"
 2880 PRINT TAB(9);"  ###################"
 2890 PRINT TAB(9);"  ###################"
 2900 PRINT TAB(9);"  ###################"
 2910 COLOUR 128+BLUE%
 2920 PRINT TAB(19,12);"   "
 2930 PRINT TAB(19,13);"   "
 2940 PRINT TAB(19,14);"   "
 2950 PRINT TAB(19,15);"   "
 2960 COLOUR 128
 2970 COLOUR CYAN%
 2980 PRINT TAB(10,24);"YOU SAVED THE CASTLE!"
 2990 PROC_happytune
 3000 k = INKEY(300)
 3010 ENDPROC
 3020
 3030 DEF PROC_beastlost
 3040 PROC_moveplayer
 3050 COLOUR 128+RED%
 3060 PRINT TAB(col*2-2,row+top%);CHR$(beast%);CHR$(beast%+1)
 3070 PROC_sound_beast
 3080 COLOUR 128: COLOUR RED%
 3090 PRINT TAB(10,mid%);"YOU LOST TO A BEAST!"
 3100 k = INKEY(300)
 3110 ENDPROC
 3120
 3130 DEF PROC_killbeast
 3140 COLOUR 128+RED%
 3150 PRINT TAB((col+cc)*2-2,row+rr+top%);CHR$(beast%);CHR$(beast%+1)
 3160 COLOUR 128
 3170 PROC_sound_beast
 3180 PROC_removeitem(col+cc,row+rr)
 3190 PROC_moveplayer
 3200 ENDPROC
 3210
 3220 DEF PROC_fellpit
 3230 PROC_moveplayer
 3240 COLOUR 128+RED%
 3250 PRINT TAB(col*2-2,row+top%);CHR$(pit%);CHR$(pit%+1)
 3260 PROC_sound_pitfall
 3270 COLOUR 128: COLOUR RED%
 3280 PRINT TAB(10,mid%);"YOU FELL INTO A PIT "
 3290 k = INKEY(300)
 3300 ENDPROC
 3310
 3320 DEF PROC_doorbumped
 3330 SOUND 1,-15,1,2
 3340 PRINT TAB(col*2-2,row+top%);CHR$(empty%);CHR$(empty%)
 3350 PRINT TAB((col+cc)*2-2,row+rr+top%);CHR$(door2%);CHR$(door2%)
 3360 k = INKEY(10)
 3370 SOUND 1,0,0,0
 3380 PRINT TAB(col*2-2,row+top%);CHR$(man%)
 3390 cc=0 :rr=0
 3400 ENDPROC
 3410
 3420 DEF FN_playagain
 3430 SOUND 1,-15,240,1
 3440 CLS
 3450 COLOUR WHITE%
 3460 PRINT TAB(10,mid%);" Play again? [Y/N] "
 3470 answer = FALSE
 3480 REPEAT
 3490   a$ = INKEY$(0)
 3500 UNTIL a$="Y" OR a$="y" OR a$="N" OR a$="n"
 3510 IF a$="Y" OR a$="y" THEN answer = TRUE
 3520 =answer
 3530
 3540 DEF PROC_sound_pling
 3550 SOUND 1,-15,196,1
 3560 SOUND 2,-15,220,1
 3570 ENDPROC
 3580
 3590 DEF PROC_sound_foundit
 3600 SOUND 1,-15,166,1
 3610 k = INKEY(10)
 3620 SOUND 2,-15,190,1
 3630 ENDPROC
 3640
 3650 DEF PROC_sound_step
 3660 SOUND 0,-15,1,1
 3670 ENDPROC
 3680
 3690 DEF PROC_sound_pitfall
 3700 LOCAL v, j
 3710 v = 15
 3720 FOR j=154 TO 80 STEP-2
 3730   SOUND 2,-v,j,2
 3740   v = v-1
 3750 NEXT
 3760 ENDPROC
 3770
 3780 DEF PROC_sound_beast
 3790 LOCAL f
 3800 FOR f=1 TO 14 STEP 2
 3810   SOUND 1,-f,5+f,1
 3820 NEXT
 3830 FOR f=15 TO 1 STEP -1
 3840   SOUND 1,-f,5+f,1
 3850 NEXT
 3860 ENDPROC
 3870
 3880 DEF PROC_sound_levitate
 3890 LOCAL f
 3900 FOR f=5 TO 14
 3910   SOUND 1,-15+f,50+f,1
 3920 NEXT
 3930 FOR f=1 TO 15
 3940   SOUND 1,-15+f,40+f,1
 3950 NEXT
 3960 ENDPROC
 3970
 3980 DEF PROC_happytune
 3990 FOR j=1 TO 2
 4000   FOR i=0 TO 8
 4010     SOUND 1,-15,happy%(i), 3
 4020   NEXT
 4030   k = INKEY(170)
 4040 NEXT
 4050 ENDPROC
 4060
 4070 DEF PROC_titlescreen
 4080 DIM pitch%(4)
 4090 pitch%(0) = 41   :REM A
 4100 pitch%(1) = 33   :REM G
 4110 pitch%(2) = 25   :REM F
 4120 pitch%(3) = 21   :REM E
 4130 REM
 4140 COLOUR 128
 4150 CLS
 4160 PROC_printtitle(5)
 4170 n = 18
 4180 COLOUR WHITE%
 4190 PRINT TAB(1,n);  " Find and defuse the bombs hidden in"
 4200 PRINT TAB(1,n+1);"the dungeon. Don't fall into a pit or"
 4210 PRINT TAB(1,n+2);"        get eaten by a beast."
 4220 PRINT TAB(1,n+3);"   Press 'L' for a levitation spell."
 4230 PRINT TAB(1,n+4);"    You have 5 minutes to complete"
 4240 PRINT TAB(1,n+5);"            your quest."
 4250 COLOUR 1
 4260 PRINT TAB(1,n+8);"      Press any key to begin..."
 4270 i=0
 4280 REPEAT
 4290   SOUND 1,-7,pitch%(i),15
 4300   SOUND 2,-5,pitch%(i)+2,14
 4310   i=i+1: IF i>3 THEN i=0
 4320   k$ = INKEY$(100)
 4330 UNTIL k$<>""
 4340 ENDPROC
 4350
 4360 DEF PROC_printtitle(n)
 4370 VDU 23,35, 223,223,223,0,251,251,251,0
 4380 COLOUR RED%
 4390 PRINT TAB(9,n);" ##  #   ## ### #    ##"
 4400 PRINT TAB(9,n+1);"#   # # #    #  #   #"
 4410 PRINT TAB(9,n+2);"#   # # ###  #  #   ##"
 4420 PRINT TAB(9,n+3);"#   ###   #  #  #   #"
 4430 PRINT TAB(9,n+4);"### # # ###  #  ### ###"
 4440 PRINT TAB(7,n+6);"##  # # ##   ##  ##  ## ##"
 4450 PRINT TAB(7,n+7);"# # # # # # #   #   # # # #"
 4460 PRINT TAB(7,n+8);"# # # # # # # # ##  # # # #"
 4470 PRINT TAB(7,n+9);"# # # # # # # # #   # # # #"
 4480 PRINT TAB(7,n+10);"##  ##  # # ### ### ##  # #"
 4490 ENDPROC
 4500
 4510 DEF PROC_initialization
 4520 dummy%=RND(-TIME)
 4530 DIM maze$(27)
 4540 top%=1 :mid%=14: :bot%=28 :REM row offsets
 4550 REM Notes for happy tune
 4560 DIM happy%(9)
 4570 FOR i=0 TO 8
 4580   READ happy%(i)
 4590 NEXT
 4600 DATA 164,164,164,0,148,164,176,0,128
 4610 REM ASCII codes for custom chars
 4620 n = 225
 4630 man% = n :wall% = n+2 :empty% = n+3 :room% = n+4 :door% = n+5
 4640 door2% = n+6 :key% =  n+7 :sword% = n+9  :bomb% = n+11
 4650 pit% = n+13 :beast% = n+15 :bar% = n+17
 4660 REM Colours
 4670 BLACK% = 0 :RED% = 1 :GREEN% = 2 :YELLOW% = 3
 4680 BLUE% = 4 :MAGENTA% = 5 :CYAN% = 6 :WHITE% = 7
 4690 REM Select MODE based on the machine type
 4700 REM 1st, assume that we are running on Windows or Mac
 4710 machine$="sdl"
 4720 IF HIMEM = 65280 PROC_realoremu
 4730 IF machine$="sdl" THEN MODE 9
 4740 IF machine$="agon" THEN MODE 2
 4750 IF machine$="emu" THEN MODE 8
 4760 ENDPROC
 4770
 4780 DEF PROC_realoremu
 4790 IF GET(128)=12 THEN machine$="agon" ELSE machine$="emu"
 4800 ENDPROC
 4810
 4820 DEF PROC_customchar
 4830 VDU 23,man%,   252,252,240,232,232,248,251,243
 4840 VDU 23,man%+1, 115,207,31,127,127,127,127,63
 4850 VDU 23,wall%,  32,32,32,255,4,4,4,255
 4860 VDU 23,empty%, 255,255,255,255,255,255,255,255
 4870 VDU 23,room%,  255,255,255,255,255,255,255,255
 4880 VDU 23,door%,  255,255,255,129,129,255,255,255
 4890 VDU 23,door2%, 255,255,231,0,0,231,255,255
 4900 VDU 23,key%,   255,255,255,192,215,215,255,255
 4910 VDU 23,key%+1, 255,255,231,27,219,231,255,255
 4920 VDU 23,sword%, 255,255,223,224,241,225,141,254
 4930 VDU 23,sword%+1,243,199,31,127,255,255,255,255
 4940 VDU 23,bomb%,  255,255,254,248,240,240,248,255
 4950 VDU 23,bomb%+1,255,43,127,31,15,15,31,255
 4960 VDU 23,pit%,   255,248,224,192,192,240,252,255
 4970 VDU 23,pit%+1, 255,63,15,3,3,7,31,255
 4980 VDU 23,beast%, 195,159,141,192,192,207,231,255
 4990 VDU 23,beast%+1,255,135,17,7,1,159,207,255
 5000 VDU 23,bar%,   0,126,126,126,126,126,126,0
 5010 ENDPROC
 5020
 5030
