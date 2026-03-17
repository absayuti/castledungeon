   10 REM Castle Dungeon 0.93 for Agon BASIC
   20 REM Written for Agon but tries to be BBCSDL compatible
   30 REM
   40 REM Using MODE 2 (40x30) in AGON
   50 REM       MODE 8 (40x32) in FAB Agon emulator
   60 REM       MODE 9 (40x32) in BBSDL (Windows/Mac)
   70 REM
   80 REM Trying to expand the maze... maybe to 27 rows...???
   90 REM Also.. reorganize code
  100 REM
  110 REM Save this file as CASTLED093.BAS in SDCARD of AGON
  120 REM (In FAB-agon-emulator, in the BAS folder)
  130
  140 PROC_initialization
  150 PROC_titlescreen
  160 PROC_customchar
  170 VDU 23,1,0;0;0;0;
  180
  190 play = TRUE
  200 REPEAT
  210   PROC_makemaze
  220   CLS
  230   PROC_initgame
  240   REPEAT
  250     PROC_playgame
  260   UNTIL gameover
  270   play = FN_playagain
  280 UNTIL play = FALSE
  290 CLS
  300 VDU 23,1,1;0;0;0;
  310 PRINT "BYE!"
  320 END
  330
  340
  350 DEF PROC_makemaze
  360 CLS
  370 PRINT TAB(4,mid%);"Please wait"
  380 maze$(0)  = "####################"
  390 maze$(1)  = "#..#..#     #      #"
  400 maze$(2)  = "#..#..# ### # #### #"
  410 maze$(3)  = "#-###-# #   # #..# #"
  420 maze$(4)  = "# #   # # ###-#..# #"
  430 maze$(5)  = "# # # # #  #..#-## #"
  440 maze$(6)  = "#   # #-## #..#    #"
  450 maze$(7)  = "##### #..# #### ####"
  460 maze$(8)  = "#     #..#    # #..#"
  470 maze$(9)  = "# ###-#### #  # #..#"
  480 maze$(10) = "# #    ..# #### ##-#"
  490 maze$(11) = "# #  # ..#         #"
  500 maze$(12) = "# ######## #-##### #"
  510 maze$(13) = "#          #..#..# #"
  520 maze$(14) = "### # #-## #..#..# #"
  530 maze$(15) = "# # # #..# #####-# #"
  540 maze$(16) = "# # # #..#  #..# # #"
  550 maze$(17) = "#   ####### #..# # #"
  560 maze$(18) = "# # #       #-##   #"
  570 maze$(19) = "# #### #### #  # # #"
  580 maze$(20) = "#-#..# #    #  # ###"
  590 maze$(21) = "#....# #  #        #"
  600 maze$(22) = "###### #########-# #"
  610 maze$(23) = "#      #....#....# #"
  620 maze$(24) = "#-######..#-###### #"
  630 maze$(25) = "#......#..#        #"
  640 maze$(26) = "####################"
  650 REM Place stuff at random locations
  660 FOR i=1 TO 3
  670   PROC_randomroom("*")
  680 NEXT
  690 FOR i=1 TO 2
  700   PROC_randomplace("%")
  710 NEXT
  720 FOR i=1 TO 7
  730   PROC_randomroom("%")
  740 NEXT
  750 PROC_randomplace("+")
  760 PROC_randomplace("/")
  770 FOR i=1 TO 3
  780   PROC_randomplace("@")
  790 NEXT
  800 ENDPROC
  810
  820 DEF PROC_randomplace(ch$)
  830 REPEAT
  840   c = RND(20)
  850   r = RND(25)
  860   n$ = MID$(maze$(r),c,1)
  870 UNTIL n$=" "
  880 m$ = LEFT$(maze$(r),c-1)
  890 m$ = m$ + ch$
  900 m$ = m$ + RIGHT$(maze$(r),20-c)
  910 maze$(r) = m$
  920 ENDPROC
  930
  940 DEF PROC_randomroom(ch$)
  950 REPEAT
  960   c = RND(20)
  970   r = RND(25)
  980   n$ = MID$(maze$(r),c,1)
  990 UNTIL n$="."
 1000 m$ = LEFT$(maze$(r),c-1)
 1010 m$ = m$ + ch$
 1020 m$ = m$ + RIGHT$(maze$(r),20-c)
 1030 maze$(r) = m$
 1040 ENDPROC
 1050
 1060 DEF PROC_initgame
 1070 REPEAT
 1080   col = RND(20)
 1090   row = RND(25)
 1100   n$ = MID$(maze$(row),col,1)
 1110 UNTIL n$=" "
 1120 cc = 0 :rr = 0
 1130 timelimit = 30000
 1140 tstart = TIME
 1150 gameover = FALSE
 1160 spell = 0
 1170 usword = FALSE
 1180 ukey = FALSE
 1190 ubombs = 0
 1200 PROC_sound_pling
 1210 ENDPROC
 1220
 1230 REM **************** THE GAME LOOP **********************
 1240 DEF PROC_playgame
 1250 COLOUR YELLOW%
 1260 PROC_moveplayer
 1270 IF spell=2 THEN spell=0
 1280 IF spell=1 THEN spell=2
 1290 tgame = TIME - tstart
 1300 IF tgame > timelimit THEN PROC_lostcastle :gameover=TRUE
 1310 PROC_printtimebar(tgame)
 1320 PROC_printstatus
 1330 k = INKEY(1000)
 1340 IF k=8 OR k=136 THEN cc=-1
 1350 IF k=21 OR k=137 THEN cc=1
 1360 IF k=11 OR k=139 THEN rr=-1
 1370 IF k=10 OR k=138 THEN rr=1
 1380 IF k=76 OR k=108 THEN PROC_sound_levitate :spell = 1
 1390 ns$ = MID$(maze$(row+rr),col+cc,1)
 1400 IF ns$="#" THEN cc=0 :rr=0
 1410 IF ns$="/" THEN PROC_removeitem(col+cc,row+rr) :usword=TRUE
 1420 IF ns$="+" THEN PROC_removeitem(col+cc,row+rr) :ukey = TRUE
 1430 IF ns$="*" THEN PROC_removeitem(col+cc,row+rr) :ubombs=ubombs+1
 1440 IF ubombs=3 THEN PROC_savedcastle :gameover = TRUE
 1450 IF ns$="@" AND spell=0 THEN PROC_fellpit :gameover=TRUE
 1460 IF ns$="%" AND usword THEN PROC_killbeast
 1470 IF ns$="%" AND usword=FALSE THEN PROC_beastlost :gameover = TRUE
 1480 IF ns$="-" AND ukey THEN PROC_removeitem(col+cc,row+rr)
 1490 IF ns$="-" AND ukey=FALSE THEN PROC_doorbumped
 1500 ENDPROC
 1510 REM **********************************************
 1520
 1530 DEF PROC_printtimebar(tgame)
 1540 tbar = INT((timelimit-tgame)/3000)
 1550 IF tbar>9 THEN tbar = 9
 1560 IF tbar=0 THEN COLOUR RED% ELSE COLOUR CYAN%
 1570 REM
 1580 FOR i=0 TO tbar
 1590   PRINT TAB(i*2,bot%);CHR$(bar%);;CHR$(bar%);
 1600 NEXT
 1610 PRINT "  "
 1620 ENDPROC
 1630
 1640 DEF PROC_printstatus
 1650 COLOUR BLACK%
 1660 COLOUR CYAN%+128
 1670 r = 23+top%
 1680 IF usword THEN PRINT TAB(30,bot%);CHR$(sword%);CHR$(sword%+1)
 1690 IF ukey THEN PRINT TAB(32,bot%);CHR$(key%);CHR$(key%+1)
 1700 IF ubombs>0 THEN PRINT TAB(34,bot%);CHR$(bomb%);CHR$(bomb%+1)
 1710 IF ubombs>1 THEN PRINT TAB(36,bot%);CHR$(bomb%);CHR$(bomb%+1)
 1720 IF ubombs>2 THEN PRINT TAB(38,bot%);CHR$(bomb%);CHR$(bomb%+1)
 1730 COLOUR GREEN%
 1740 COLOUR BLACK%+128
 1750 IF spell THEN PRINT TAB(29,bot%);"L"; ELSE PRINT TAB(29,bot%);" ";
 1760 COLOUR YELLOW%
 1770 ENDPROC
 1780
 1790 DEF PROC_moveplayer
 1800 COLOUR YELLOW%
 1810 PROC_erasepart(col,row)
 1820 col = col+cc
 1830 row = row+rr
 1840 PROC_printpart(col,row)
 1850 cc = 0
 1860 rr = 0
 1870 REM PROC_sound_step
 1880 ENDPROC
 1890
 1900 DEF PROC_printpart(c,r)
 1910 FOR j=0 TO 2
 1920   FOR i=0 TO 2
 1930     n$ = MID$(maze$(r+j-1),c+i-1,1)
 1940     mm$ = FN_convert(n$)
 1950     PRINT TAB((c+i)*2-4,r+j-1+top%);mm$
 1960   NEXT
 1970 NEXT
 1980 PRINT TAB(c*2-2,r+top%);CHR$(man%);CHR$(man%+1)
 1990 ENDPROC
 2000
 2010 DEF PROC_erasepart(c,r)
 2020 FOR i=0 TO 2
 2030   IF r+i>0 THEN PRINT TAB(c*2-4,r-1+i+top%);"      "
 2040 NEXT
 2050 ENDPROC
 2060
 2070 DEF PROC_removeitem(c,r)
 2080 SOUND 1,-15,166,1
 2090 m1$ = LEFT$(maze$(r),c-1)
 2100 m2$ = RIGHT$(maze$(r),20-c)
 2110 maze$(r) = m1$+" "+m2$
 2120 k = INKEY(7)
 2130 SOUND 2,-15,190,1
 2140 ENDPROC
 2150
 2160 DEF PROC_printmaze
 2170 COLOUR WHITE%
 2180 PRINT TAB(0,top%);
 2190 FOR r=0 TO 22
 2200   m$ = maze$(r)
 2210   FOR c=1 TO 20
 2220     n$ = MID$(m$,c,1)
 2230     x$ = FN_convert(n$)
 2240     PRINT x$;
 2250   NEXT
 2260 NEXT
 2270 ENDPROC
 2280
 2290 DEF FN_convert(n$)
 2300 mm$ = ""
 2310 IF n$=" " THEN mm$=CHR$(empty%)+CHR$(empty%)
 2320 IF n$="." THEN mm$=CHR$(empty%)+CHR$(empty%)
 2330 IF n$="#" THEN mm$=CHR$(wall%)+CHR$(wall%)
 2340 IF n$="-" THEN mm$=CHR$(door%)+CHR$(door%)
 2350 IF n$="+" THEN mm$=CHR$(key%)+CHR$(key%+1)
 2360 IF n$="/" THEN mm$=CHR$(sword%)+CHR$(sword%+1)
 2370 IF n$="*" THEN mm$=CHR$(bomb%)+CHR$(bomb%+1)
 2380 IF n$="@" THEN mm$=CHR$(pit%)+CHR$(pit%+1)
 2390 IF n$="%" THEN mm$=CHR$(beast%)+CHR$(beast%+1)
 2400 =mm$
 2410
 2420 DEF PROC_lostcastle
 2430 PROC_printmaze
 2440 PROC_explode
 2450 COLOUR RED%
 2460 PRINT TAB(10,mid%);"THE CASTLE DESTROYED"
 2470 k = INKEY(100)
 2480 ENDPROC
 2490
 2500 DEF PROC_explode
 2510 SOUND 0,-15,4,10
 2520 COLOUR RED%
 2530 FOR col=0 TO 70
 2540   SOUND 1,-15,col,1
 2550   row=col
 2560   IF row>22 THEN row=22
 2570   FOR n=row TO 0 STEP-1
 2580     IF col-n<40 THEN PRINT TAB(col-n,n+top%);" ";
 2590   NEXT
 2600 NEXT
 2610 CLS
 2620 ENDPROC
 2630
 2640 DEF PROC_savedcastle
 2650 CLS
 2660 COLOUR WHITE%
 2670 PRINT TAB(0,4)
 2680 PRINT TAB(9);"# # #             # # #"
 2690 PRINT TAB(9);"#####             #####"
 2700 PRINT TAB(9);"##### # # # # # # #####"
 2710 PRINT TAB(9);"#######################"
 2720 PRINT TAB(9);" #####################"
 2730 PRINT TAB(9);"  ###################"
 2740 PRINT TAB(9);"  ###################"
 2750 PRINT TAB(9);"  ###################"
 2760 PRINT TAB(9);"  ###################"
 2770 PRINT TAB(9);"  ###################"
 2780 PRINT TAB(9);"  ###################"
 2790 COLOUR 128+BLUE%
 2800 PRINT TAB(19,12);"   "
 2810 PRINT TAB(19,13);"   "
 2820 PRINT TAB(19,14);"   "
 2830 PRINT TAB(19,15);"   "
 2840 COLOUR 128
 2850 COLOUR CYAN%
 2860 PRINT TAB(10,24);"YOU SAVED THE CASTLE!"
 2870 PROC_happytune
 2880 k = INKEY(300)
 2890 ENDPROC
 2900
 2910 DEF PROC_beastlost
 2920 PROC_moveplayer
 2930 COLOUR 128+RED%
 2940 PRINT TAB(col*2-2,row+top%);CHR$(beast%);CHR$(beast%+1)
 2950 PROC_sound_beast
 2960 COLOUR 128: COLOUR RED%
 2970 PRINT TAB(10,mid%);"YOU LOST TO A BEAST!"
 2980 k = INKEY(300)
 2990 ENDPROC
 3000
 3010 DEF PROC_killbeast
 3020 COLOUR 128+RED%
 3030 PRINT TAB((col+cc)*2-2,row+rr+top%);CHR$(beast%);CHR$(beast%+1)
 3040 COLOUR 128
 3050 PROC_sound_beast
 3060 PROC_removeitem(col+cc,row+rr)
 3070 PROC_moveplayer
 3080 ENDPROC
 3090
 3100 DEF PROC_fellpit
 3110 PROC_moveplayer
 3120 COLOUR 128+RED%
 3130 PRINT TAB(col*2-2,row+top%);CHR$(pit%);CHR$(pit%+1)
 3140 PROC_sound_pitfall
 3150 COLOUR 128: COLOUR RED%
 3160 PRINT TAB(10,mid%);"YOU FELL INTO A PIT "
 3170 k = INKEY(300)
 3180 ENDPROC
 3190
 3200 DEF PROC_doorbumped
 3210 SOUND 1,-15,1,2
 3220 PRINT TAB(col*2-2,row+top%);CHR$(empty%);CHR$(empty%)
 3230 PRINT TAB((col+cc)*2-2,row+rr+top%);CHR$(door2%);CHR$(door2%)
 3240 k = INKEY(10)
 3250 SOUND 1,0,0,0
 3260 PRINT TAB(col*2-2,row+top%);CHR$(man%)
 3270 cc=0 :rr=0
 3280 ENDPROC
 3290
 3300 DEF FN_playagain
 3310 SOUND 1,-15,240,1
 3320 CLS
 3330 COLOUR WHITE%
 3340 PRINT TAB(10,mid%);" Play again? [Y/N] "
 3350 answer = FALSE
 3360 REPEAT
 3370   a$ = INKEY$(0)
 3380 UNTIL a$="Y" OR a$="y" OR a$="N" OR a$="n"
 3390 IF a$="Y" OR a$="y" THEN answer = TRUE
 3400 =answer
 3410
 3420 DEF PROC_sound_pling
 3430 SOUND 1,-15,196,1
 3440 SOUND 2,-15,220,1
 3450 ENDPROC
 3460
 3470 DEF PROC_sound_foundit
 3480 SOUND 1,-15,166,1
 3490 k = INKEY(10)
 3500 SOUND 2,-15,190,1
 3510 ENDPROC
 3520
 3530 DEF PROC_sound_step
 3540 SOUND 0,-15,1,1
 3550 ENDPROC
 3560
 3570 DEF PROC_sound_pitfall
 3580 LOCAL v, j
 3590 v = 15
 3600 FOR j=154 TO 80 STEP-2
 3610   SOUND 2,-v,j,2
 3620   v = v-1
 3630 NEXT
 3640 ENDPROC
 3650
 3660 DEF PROC_sound_beast
 3670 LOCAL f
 3680 FOR f=1 TO 14 STEP 2
 3690   SOUND 1,-f,5+f,1
 3700 NEXT
 3710 FOR f=15 TO 1 STEP -1
 3720   SOUND 1,-f,5+f,1
 3730 NEXT
 3740 ENDPROC
 3750
 3760 DEF PROC_sound_levitate
 3770 LOCAL f
 3780 FOR f=5 TO 14
 3790   SOUND 1,-15+f,50+f,1
 3800 NEXT
 3810 FOR f=1 TO 15
 3820   SOUND 1,-15+f,40+f,1
 3830 NEXT
 3840 ENDPROC
 3850
 3860 DEF PROC_happytune
 3870 FOR j=1 TO 2
 3880   FOR i=0 TO 8
 3890     SOUND 1,-15,happy%(i), 3
 3900   NEXT
 3910   k = INKEY(170)
 3920 NEXT
 3930 ENDPROC
 3940
 3950 DEF PROC_titlescreen
 3960 DIM pitch%(4)
 3970 pitch%(0) = 41   :REM A
 3980 pitch%(1) = 33   :REM G
 3990 pitch%(2) = 25   :REM F
 4000 pitch%(3) = 21   :REM E
 4010 REM
 4020 COLOUR 128
 4030 CLS
 4040 PROC_printtitle(5)
 4050 n = 18
 4060 COLOUR WHITE%
 4070 PRINT TAB(1,n);  " Find and defuse the bombs hidden in"
 4080 PRINT TAB(1,n+1);"the dungeon. Don't fall into a pit or"
 4090 PRINT TAB(1,n+2);"        get eaten by a beast."
 4100 PRINT TAB(1,n+3);"   Press 'L' for a levitation spell."
 4110 PRINT TAB(1,n+4);"    You have 5 minutes to complete"
 4120 PRINT TAB(1,n+5);"            your quest."
 4130 COLOUR 1
 4140 PRINT TAB(1,n+8);"      Press any key to begin..."
 4150 i=0
 4160 REPEAT
 4170   SOUND 1,-7,pitch%(i),15
 4180   SOUND 2,-5,pitch%(i)+2,14
 4190   i=i+1: IF i>3 THEN i=0
 4200   k$ = INKEY$(100)
 4210 UNTIL k$<>""
 4220 ENDPROC
 4230
 4240 DEF PROC_printtitle(n)
 4250 VDU 23,35, 223,223,223,0,251,251,251,0
 4260 COLOUR RED%
 4270 PRINT TAB(9,n);" ##  #   ## ### #    ##"
 4280 PRINT TAB(9,n+1);"#   # # #    #  #   #"
 4290 PRINT TAB(9,n+2);"#   # # ###  #  #   ##"
 4300 PRINT TAB(9,n+3);"#   ###   #  #  #   #"
 4310 PRINT TAB(9,n+4);"### # # ###  #  ### ###"
 4320 PRINT TAB(7,n+6);"##  # # ##   ##  ##  ## ##"
 4330 PRINT TAB(7,n+7);"# # # # # # #   #   # # # #"
 4340 PRINT TAB(7,n+8);"# # # # # # # # ##  # # # #"
 4350 PRINT TAB(7,n+9);"# # # # # # # # #   # # # #"
 4360 PRINT TAB(7,n+10);"##  ##  # # ### ### ##  # #"
 4370 ENDPROC
 4380
 4390 DEF PROC_initialization
 4400 dummy%=RND(-TIME)
 4410 DIM maze$(27)
 4420 top%=1 :mid%=14: :bot%=28 :REM row offsets
 4430 REM Notes for happy tune
 4440 DIM happy%(9)
 4450 FOR i=0 TO 8
 4460   READ happy%(i)
 4470 NEXT
 4480 DATA 164,164,164,0,148,164,176,0,128
 4490 REM ASCII codes for custom chars
 4500 n = 225
 4510 man% = n :wall% = n+2 :empty% = n+3 :room% = n+4 :door% = n+5
 4520 door2% = n+6 :key% =  n+7 :sword% = n+9  :bomb% = n+11
 4530 pit% = n+13 :beast% = n+15 :bar% = n+17
 4540 REM Colours
 4550 BLACK% = 0 :RED% = 1 :GREEN% = 2 :YELLOW% = 3
 4560 BLUE% = 4 :MAGENTA% = 5 :CYAN% = 6 :WHITE% = 7
 4570 REM Select MODE based on the machine type
 4580 REM 1st, assume that we are running on Windows or Mac
 4590 machine$="sdl"
 4600 IF HIMEM = 65280 PROC_realoremu
 4610 IF machine$="sdl" THEN MODE 9
 4620 IF machine$="agon" THEN MODE 2
 4630 IF machine$="emu" THEN MODE 8
 4640 ENDPROC
 4650
 4660 DEF PROC_realoremu
 4670 IF GET(128)=12 THEN machine$="agon" ELSE machine$="emu"
 4680 ENDPROC
 4690
 4700 DEF PROC_customchar
 4710 VDU 23,man%,   252,252,240,232,232,248,251,243
 4720 VDU 23,man%+1, 115,207,31,127,127,127,127,63
 4730 VDU 23,wall%,  32,32,32,255,4,4,4,255
 4740 VDU 23,empty%, 255,255,255,255,255,255,255,255
 4750 VDU 23,room%,  255,255,255,255,255,255,255,255
 4760 VDU 23,door%,  255,255,255,129,129,255,255,255
 4770 VDU 23,door2%, 255,255,231,0,0,231,255,255
 4780 VDU 23,key%,   255,255,255,192,215,215,255,255
 4790 VDU 23,key%+1, 255,255,231,27,219,231,255,255
 4800 VDU 23,sword%, 255,255,223,224,241,225,141,254
 4810 VDU 23,sword%+1,243,199,31,127,255,255,255,255
 4820 VDU 23,bomb%,  255,255,254,248,240,240,248,255
 4830 VDU 23,bomb%+1,255,43,127,31,15,15,31,255
 4840 VDU 23,pit%,   255,248,224,192,192,240,252,255
 4850 VDU 23,pit%+1, 255,63,15,3,3,7,31,255
 4860 VDU 23,beast%, 195,159,141,192,192,207,231,255
 4870 VDU 23,beast%+1,255,135,17,7,1,159,207,255
 4880 VDU 23,bar%,   0,126,126,126,126,126,126,0
 4890 ENDPROC
 4900
 4910
