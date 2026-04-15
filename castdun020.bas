' Castle Dungeon PicoCalc 0.020
' 6 Apr 2026
'
' Loosely based on Compute!'s Gazette
' Castle Dungeon for VIC-20 June 1984
'
' Level 1 - 5 minutes, 9 beasts
'         - 3+3 pits, 20 spells
' Level 2 - 4 minutes, +3 beasts@doors
'         - 10 spells
' Level 3 - 3 minutes, +3 beasts@doors
'         - 8 spells
' Level 4 - 2 minutes, 7 spells
' Level 5 - 1 minute, 6 spells
'
' Score = Time_left


' Initialization of variables
  Dim image$(11,4)
  Dim maze$(20)
  Dim castle$(10)
' Victory tune
  Dim fr(4)
  fr(0) = 392 : fr(1) = 440
  fr(2) = 494 : fr(3) = 523
' For title screen tune
  Dim note%(8)
' Gameplay settings
  Dim tlimit(6)
  tlimit(1) = 5*60*1000
  tlimit(2) = 4*60*1000
  tlimit(3) = 3*60*1000
  tlimit(4) = 2*60*1000
  tlimit(5) = 1*60*1000
  Dim maxspell(6)
  maxspell(1)=20 : maxspell(2)=10
  maxspell(3)=9  : maxspell(4)=8
  maxspell(5)=7
  highscore = 0
  totscore = 0
  level = 0
 ' Colours
  fore%=RGB(yellow)
  back%=RGB(black)


' Setup BMP images
' similar to user-defined chars
SetupImages
PrintTitleScreen

' ------------------------------------
' Main loop
Do
  InitGame
  gameover = 0
  Timer = 0
  Do
    PlayGame
    UpdateInfo
    If Timer>tlimit(level) Then gameover=4
  Loop Until gameover
  PrintMaze
  Select Case gameover
    Case 1
      Message "You saved the castle"
      SoundWin
    Case 2
      Message "You fell into a pit"
    Case 3
      Message "You lost to a beast"
    Case 4
      Message "Castle is destroyed"
  End Select
  Pause 2000
  uplay = PlayAgain()
Loop While uplay
CLS
Print "Bye!"
End

' ------------------------------------
' The game / main routine
Sub PlayGame
  MovePlayer row,col
  If spell=2 Then spell=0
  If spell=1 Then spell=2
  Do
    k = Asc(Inkey$)
  Loop Until k>0
  r = 0 :  c = 0
  Select Case k
    Case 128
      r = r-1
    Case 129
      r = r+1
    Case 130
      c = c-1
    Case 131
      c = c+1
    Case 108, 76
      If numspell>0 Then
        spell = 1
        SoundSpell
        numspell = numspell-1
      Else
        SoundError
     EndIf
  End Select
  m$ = Mid$(maze$(row+r),col+c+1,1)
  Select Case m$
    Case "#"
      r = 0 : c = 0
    Case "-"
      If ukey=1 Then
        RemoveItem row+r, col+c
      Else
        BumpDoor row, r, col
        r = 0 : c = 0
      EndIf
    Case "+"
      ukey = 1
      RemoveItem row+r, col+c
    Case "/"
      usword = 1
      RemoveItem row+r, col+c
    Case "*"
      ubomb = ubomb+1
      RemoveItem row+r, col+c
      If ubomb=3 Then
        gameover = 1
        score = Int((tlimit(level)-Timer)/100)
      EndIf
    Case "@"
      If spell=0 Then
        gameover = 2
        FallinPit
      EndIf
    Case "&"
      If usword=0 Then
        gameover = 3
        LosttoBeast
      Else
        SoundBeast
        RemoveItem row+r, col+c
      EndIf
  End Select
  If Not gameover Then
    EraseCells row,col
    row = row+r
    col = col+c
  EndIf
  ' Print @(0,0) row,col
End Sub

' ------------------------------------
Sub initgame
  Colour fore%,back%
  CLS
  Randomize Timer
  setupmaze
  ' Randomly place player in maze
  Do
    row=Int(Rnd(0)*20)
    col=Int(Rnd(0)*20)
    m$=Mid$(maze$(row),col+1,1)
  Loop Until m$=" "
  level = level+1
  numspell = maxspell(level)
  spell = 0
  ukey = 0
  usword = 0
  ubomb = 0
  score = 0
End Sub

' ------------------------------------
Sub MovePlayer row, col
  For i=row-1 To row+1
    For j=col-1 To col+1
      m$=Mid$(maze$(i),j+1,1)
      DrawCell i,j,m$
    Next
  Next
  drawman row,col
End Sub

' ------------------------------------
Sub DrawMan row, col
  x = col*16
  y = row*16
  GUI bitmap x,y,image$(0,0)
  GUI bitmap x+8,y,image$(0,1)
  GUI bitmap x,y+8,image$(0,2)
  GUI bitmap x+8,y+8,image$(0,3)
End Sub

' ------------------------------------
Sub DrawCell row, col, m$, hi
  x = col*16
  y = row*16
  Select Case m$
    Case " ", "."
            n = 1
    Case "#"
            n = 2
    Case "-"
            n = 3
    Case "@"
            n = 4
    Case "&"
            n = 5
    Case "+"
            n = 6
    Case "/"
            n = 7
    Case "*"
            n = 8
    Case "f"
            n = pitfall%
    Case "e"
            n = eaten%
    End Select
    If hi=1 Then
      Colour RGB(black),RGB(cyan)
    ElseIf hi=2 Then
      Colour RGB(blue),RGB(red)
    EndIf
    GUI bitmap x,y,image$(n,0)
    GUI bitmap x+8,y,image$(n,1)
    GUI bitmap x,y+8,image$(n,2)
    GUI bitmap x+8,y+8,image$(n,3)
End Sub

' ------------------------------------
Sub EraseCells row,col
  x = (col-1)*16
  y = (row-1)*16
  Box x, y, 48, 48, 1, back%, bBack%
End Sub

' ------------------------------------
Sub BumpDoor row, r, col
  x = col*16
  y = (row+r)*16
  DrawCell row, col, " "
  Colour fore%,RGB(red)
  DrawCell row+r, col, "-"
  Colour fore%,back%
  DrawMan row+r/3, col
  SoundBump
  DrawMan row, col
  DrawCell row+r, col, "-"
End Sub

' ------------------------------------
Sub FallinPit
  DrawCell row, col, " "
  Colour fore%,RGB(red)
  DrawCell row+r, col+c, "f"
  SoundFall
  Pause 1000
  Colour fore%,back%
End Sub

' ------------------------------------
Sub LosttoBeast
  DrawCell row, col, " "
  Colour fore%,RGB(red)
  DrawCell row+r, col+c, "e"
  SoundBeast
  Pause 1000
  Colour fore%,back%
End Sub

' ------------------------------------
Sub RemoveItem row,col
  m$ = Left$(maze$(row),col)
  m$ = m$+" "
  m$ = m$ + Right$(maze$(row),19-col)
  maze$(row) = m$
  SoundAlert
End Sub

' ------------------------------------
Sub UpdateInfo
  If ukey Then DrawCell 19,14,"+",1
  If usword Then DrawCell 19,15,"/",1
  If ubomb>0 Then DrawCell 19,16,"*",1
  If ubomb>1 Then DrawCell 19,17,"*",1
  If ubomb>2 Then DrawCell 19,18,"*",1
  y = 19*16 : x = 19*16
  Colour fore%,back%
  If spell>0 Then
    Text x,y,"L ","lt",1,1,RGB(green)
  Else
    m$ = Str$(numspell)
    Text x,y, m$,"lt",1,1,RGB(cyan)
  EndIf
  tline = Int(tlimit(level)-Timer)/1000
  Line 0,319,319,319,1,back%
  Line 0,319,tline,319,1,RGB(cyan)
End Sub

' ------------------------------------
Sub Message s$
  Colour fore%,back%
  Text 160,160,s$,"cm",,2
  SoundAlert
End Sub

' ------------------------------------
Function PlayAgain() As integer
  CLS
  Colour RGB(white),back%
  totscore = totscore + score
  If totscore>highscore Then highscore = totscore
  m$ = "Score = "+ Str$(totscore)
  Text 160,100,m$,"cm",,2
  m$ = "High Score = "+ Str$(highscore)
  Text 160,125,m$,"cm",,2
  If gameover=1 And level<5 Then
    level = level+1
    m$ = "Play level "+Str$(level)+"?"
    Text 160,160,m$,"cm",,2
  Else
    m$ = "GAME OVER"
    Text 160,160,m$,"cm",,2,RGB(red)
    m$ = "Play again? (Y/N)"
    Text 160,190,m$,"cm",,2
    level = 0
    totscore = 0
  EndIf
  SoundAlert
  Do
    yn$ = Inkey$
  Loop Until yn$="y" Or yn$="Y" Or yn$="n" Or yn$="N"
  If yn$="y" Or yn$="Y" Then
    PlayAgain = 1
  Else
    PlayAgain = 0
  EndIf
End Function

' -----------------------------------
Sub SoundWin
  For i=0 To 3
    Play sound 2,"b","w",fr(i)
    Pause 500
  Next
  Pause 1500
  Play stop
End Sub

' ------------------------------------
Sub SoundSpell
  For f=300 To 400 Step 2
    Play tone f,f,15
    Pause 5
  Next
  For f=300 To 500 Step 3
    Play tone f,f,15
    Pause 5
  Next
End Sub

' ------------------------------------
Sub SoundBeast
  For p=70 To 20 Step-1
    Play sound 1,"b","n",p
    Pause 5
  Next
  For p=20 To 150
    Play sound 1,"b","n",p
    Pause 10
  Next
  Play stop
End Sub

' ------------------------------------
Sub SoundFall
  For f=550 To 350 Step-2
    Play tone f,f,15
    Pause 10
  Next
End Sub

' ------------------------------------
Sub SoundBump
  For v=25 To 0 Step-1
    Play sound 1,"b","w",65,v
    Pause 6
  Next
  Play stop
End Sub

' ------------------------------------
Sub SoundError
  Play sound 1,"b","w",65
  Pause 100
  Play sound 1,"b","w",100
  Pause 300
End Sub

' ------------------------------------
Sub SoundAlert
  Play tone 500,500,200
  Pause 200
  Play tone 700,700,100
  Pause 100
End Sub

' ------------------------------------
Sub PrintMaze
  CLS
  If gameover=1 Then Colour RGB(cyan)
  If gameover>1 Then Colour RGB(blue)
  For i=0 To 19
    For j=0 To 19
      m$=Mid$(maze$(i),j+1,1)
      DrawCell i,j,m$
    Next
  Next
End Sub

' ------------------------------------
Sub RandomPlace c$, n
  For i=1 To n
    Do
      row = Int(Rnd(0)*20)
      col = Int(Rnd(0)*20)
      m$ = Mid$(maze$(row),col+1,1)
    Loop Until m$=" "
    m$ = Left$(maze$(row),col)
    m$ = m$+c$
    m$ = m$ + Right$(maze$(row),19-col)
    maze$(row) = m$
  Next
End Sub

' ------------------------------------
Sub RandomRoom c$, n
  For i=1 To n
    Do
      row = Rnd(0)*20
      col = Rnd(0)*20
      m$ = Mid$(maze$(row),col+1,1)
    Loop Until m$="."
    m$ = Left$(maze$(row),col)
    m$ = m$+c$
    m$ = m$ + Right$(maze$(row),19-col)
    maze$(row) = m$
  Next
End Sub

' ------------------------------------
Sub SetupMaze
  maze$(0)  = "####################"
  maze$(1)  = "#..#..#     #      #"
  maze$(2)  = "#..#..# ### # ##-# #"
  maze$(3)  = "#-###-# #   # #..# #"
  maze$(4)  = "# #   # # ###-#..# #"
  maze$(5)  = "# # # # #  #..#### #"
  maze$(6)  = "#   # #-## #..#    #"
  maze$(7)  = "##### #..# #### ####"
  maze$(8)  = "#     #..# #..# #..#"
  maze$(9)  = "# ###-#### #..# #..#"
  maze$(10) = "# #......# ##-# ##-#"
  maze$(11) = "# ########         #"
  maze$(12) = "#          ####### #"
  maze$(13) = "# ## ## ####       #"
  maze$(14) = "####  # #..# #####-#"
  maze$(15) = "#..####-#..# # #...#"
  maze$(16) = "#..#....##-# # #####"
  maze$(17) = "#-######## #    ...#"
  maze$(18) = "#            #######"
  maze$(19) = "####################"
  ' place items in rooms
  RandomRoom "*", 3   ' bombs
  RandomRoom "@", 3   ' pits
  RandomRoom "&", 10  ' beasts
  ' place items randomly elsewhere
  RandomPlace "@", 3  ' pits
  RandomPlace "+", 1  ' key
  RandomPlace "/", 1  ' sword
End Sub

' ------------------------------------
Sub PrintTitleScreen
  SetupTitleScreen
  CLS
  Colour RGB(black),RGB(white)
  For i=0 To 9
    For j=0 To Len(castle$(i))-1
      m$=Mid$(castle$(i),j+1,1)
      If m$<>" " Then DrawCell 2+i,j,m$
    Next
  Next
  red%=RGB(red)
  m$ = "CASTLE"
  Text 150,110, m$,"cm",3,2,red%,-1
  m$ = "DUNGEON"
  Text 150,160, m$,"cm",3,2,red%,-1
  Colour RGB(green),back%
  Print @(0,200)
  Print "Find and defuse the bombs hidden in the"
  Print " dungeon. Don't fall into a pit or get"
  Print "           eaten by a beast."
  Print  "Press the ";
  Colour RGB(white) : Print "L";
  Colour RGB(green)
  Print " key for a levitation spell."
  Print "     You have ";
  Colour RGB(white) : Print "5";
  Colour RGB(green)
  Print " minutes to complete"
  Print  "              your quest."
  Colour RGB(white)
  Print
  Print  "        Press any key to start"
  i = 0
  Do
    For v=25 To 0 Step-1
      Play sound 1,"b","q",note%(i),v/2
      Play sound 2,"b","w",note%(i+4),v
      Pause 40
    Next
    i = i+1
    If i>3 Then i = 0
    yn$ = Inkey$
  Loop Until yn$<>""
  Play stop
End Sub

' ------------------------------------
Sub SetupTitleScreen
  castle$(0) = "# # #         # # #"
  castle$(1) = "#####         #####"
  castle$(2) = "##### # # # # #####"
  castle$(3) = "###################"
  castle$(4) = " #################"
  castle$(5) = "  ###############"
  castle$(6) = "  ######...######"
  castle$(7) = "  ######...######"
  castle$(8) = "  ######...######"
  castle$(9) = "  ######...######"
  ' The opening tune
  note%(0) = 156 : note%(4) = 73 'D#
  note%(1) = 139 : note%(5) = 65 'C#
  note%(2) = 123 : note%(6) = 58 'B
  note%(3) = 117 : note%(7) = 55 'A#
End Sub

' ------------------------------------
Sub SetupImages
  player%=0 :floor%=1 :wall%=2 :door%=3
  pit%=4 :beast%=5 :key%=6 :sword%=7
  bomb%=8 :pitfall%=9 :eaten%=10

  For i=0 To 10
    For j=0 To 3
      a$ = ""
      For k=0 To 7
        Read b
        Print i;j;k;b
        a$ = a$+Chr$(b)
      Next
      image$(i,j) = a$
    Next
  Next
End Sub
' 0. Player
Data 254,253,253,254,248,244,244,244
Data 127,191,187,119,15,63,63,63
Data 244,244,253,253,253,253,253,249
Data 63,63,191,191,191,191,191,159
' 1. Floor
Data 255,255,255,255,255,255,255,255
Data 255,255,255,255,255,255,255,255
Data 255,255,255,255,255,255,255,255
Data 255,255,255,255,255,255,255,255
' 2. Wall
Data 8,8,8,8,8,8,8,255
Data 0,0,0,0,0,0,0,255
Data 0,0,0,0,0,0,0,255
Data 8,8,8,8,8,8,8,255
' 3. Door
Data 255,255,255,255,255,255,192,128
Data 255,255,255,255,255,255,3,1
Data 128,192,255,255,255,255,255,255
Data 1,3,255,255,255,255,255,255
' 4. Pit
Data 255,255,255,252,240,224,128,128
Data 255,255,255,63,15,7,3,1
Data 128,192,224,240,252,255,255,255
Data 1,1,7,15,63,255,255,255
' 5. Beast
Data 255,159,193,224,108,142,198,0
Data 255,249,131,7,54,113,10,0
Data 195,230,244,240,195,139,171,255
Data 195,103,47,15,195,209,213,255
' 6. Key
Data 255,255,255,255,255,255,255,128
Data 255,255,255,255,255,243,237,13
Data 128,215,215,255,255,255,255,255
Data 13,237,243,255,255,255,255,255
' 7. Sword
Data 255,255,255,255,255,255,255,254
Data 255,249,245,235,215,175,95,191
Data 221,226,241,225,197,142,159,255
Data 127,255,255,255,255,255,255,255
' 8. Bomb
Data 255,255,255,255,254,248,240,224
Data 255,171,127,255,127,31,111,55
Data 224,224,224,240,248,255,255,255
Data 7,7,7,15,31,255,255,255
' 9. Pitfall
Data 255,190,221,236,242,232,132,132
Data 255,123,183,175,79,23,35,33
Data 130,193,224,249,252,255,255,255
Data 65,129,7,15,63,255,255,255
' 9. Eaten by beast
Data 251,189,223,108,187,230,221,176
Data 239,221,251,54,221,103,59,13
Data 176,208,220,230,187,116,239,223
Data 13,27,59,103,221,46,247,251
'
' ------------ end ------------------
                                                                                                                       