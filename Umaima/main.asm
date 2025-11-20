INCLUDE Irvine32.inc
.data

m1 BYTE " _______       ___      .___  ___.  _______    .___  ___.  _______ .__   __.  __    __ ",0 
m2 BYTE "/  _____|     /   \     |   \/   | |   ____|   |   \/   | |   ____||  \ |  | |  |  |  |",0 
m3 BYTE "|  |  __     /  ^  \    |  \  /  | |  |__      |  \  /  | |  |__   |   \|  | |  |  |  |",0 
m4 BYTE "|  | |_ |   /  /_\  \   |  |\/|  | |   __|     |  |\/|  | |   __|  |  . `  | |  |  |  |",0
m5 BYTE "|  |__| |  /  _____  \  |  |  |  | |  |____    |  |  |  | |  |____ |  |\   | |  `--'  |",0 
m6 BYTE " \______| /__/     \__\ |__|  |__| |_______|   |__|  |__| |_______||__| \__|  \______/ ",0 
                                                                                        
menuTitle DWORD m1, m2, m3, m4, m5, m6
MENU_LINES = 6

o1 BYTE "      EXECUTE: MAZE_PROTOCOL.EXE              ",0
o2 BYTE "      INITIATE: FLIGHT_SIMULATION.EXE         ",0
o3 BYTE "      DECRYPT: WORD_MATRIX.EXE                ",0
o4 BYTE "      TERMINATE: SESSION.EXE                  ",0
options DWORD o1, o2, o3, o4
OPTION_LINES = 4

msg BYTE "ENTER COMMAND SEQUENCE (NUMBER): ",solid,solid,solid,solid,solid,solid,solid,solid,solid,0
invalidText BYTE " INVALID ",0
exitMsg BYTE "Press ENTER to Leave or Press BACKSPACE to go back to the menu ",0

pointer BYTE 175,175,0          ;175 is ASCII of >>
num1 BYTE "[1]  ",174,174,0  ;174 is ASCII of the opposite wala arrow <<
num2 BYTE "[2]  ",174,174,0
num3 BYTE "[3]  ",174,174,0
num4 BYTE "[4]  ",174,174,0
numbers DWORD num1, num2, num3, num4
nCol DWORD ?
s2 BYTE "       ",0

current DWORD ?   ;jis par abhi ye pointer point krega
start DWORD ?  ;kahaan se shru krna hai
ending DWORD ?    ;and kahaan par end krna hai (loop-wise)
pCol DWORD ?      ;column in which the >> arrow will be shown (same column mein aayega)
s1 BYTE "  ",0     ;to make it disappear


;All of the text for Loading screen
loadingText DWORD l1, l2, l3, l4, l5, l6
LOADING_LINES = 6

l1 BYTE "______              _____________                    _________                       ",0
l2 BYTE "___  / ____________ ______  /__(_)_____________ _    __  ____/_____ _______ ________ ",0
l3 BYTE "__  /  _  __ \  __ `/  __  /__  /__  __ \_  __ `/    _  / __ _  __ `/_  __ `__ \  _ \",0
l4 BYTE "_  /___/ /_/ / /_/ // /_/ / _  / _  / / /  /_/ /     / /_/ / / /_/ /_  / / / / /  __/",0
l5 BYTE "/_____/\____/\__,_/ \__,_/  /_/  /_/ /_/_\__, /      \____/  \__,_/ /_/ /_/ /_/\___/ ",0
l6 BYTE "                                        /____/                                       ",0


pleaseText DWORD p1, p2, p3, p4, p5
PLEASE_LINES = 5

p1 BYTE "______________                             ___       __      __________ ",0
p2 BYTE "___  __ \__  /__________ ____________      __ |     / /_____ ___(_)_  /_",0
p3 BYTE "__  /_/ /_  /_  _ \  __ `/_  ___/  _ \     __ | /| / /_  __ `/_  /_  __/",0
p4 BYTE "_  ____/_  / /  __/ /_/ /_(__  )/  __/     __ |/ |/ / / /_/ /_  / / /_  ",0
p5 BYTE "/_/     /_/  \___/\__,_/ /____/ \___/      ____/|__/  \__,_/ /_/  \__/  ",0


;Text for the exit screen/goodbye screen
exitText DWORD exit1, exit2, exit3, exit4, exit5, exit6, exit7
EXIT_LINES = 7

exit1 BYTE " ::::::::   ::::::::   ::::::::  :::::::::  :::::::::  :::   ::: :::::::::: :::",0 
exit2 BYTE ":+:    :+: :+:    :+: :+:    :+: :+:    :+: :+:    :+: :+:   :+: :+:        :+:",0 
exit3 BYTE "+:+        +:+    +:+ +:+    +:+ +:+    +:+ +:+    +:+  +:+ +:+  +:+        +:+",0 
exit4 BYTE ":#:        +#+    +:+ +#+    +:+ +#+    +:+ +#++:++#+    +#++:   +#++:++#   +#+",0 
exit5 BYTE "+#+   +#+# +#+    +#+ +#+    +#+ +#+    +#+ +#+    +#+    +#+    +#+        +#+",0 
exit6 BYTE "#+#    #+# #+#    #+# #+#    #+# #+#    #+# #+#    #+#    #+#    #+#           ",0 
exit7 BYTE " ########   ########   ########  #########  #########     ###    ########## ###",0 
                                                                                
                                                                                
screenWidth DWORD ?
screenHeight DWORD ?
centerCol DWORD ?
centerRow DWORD ?

;outer box
obt DWORD 3     ;outer box top
obr DWORD ?     ;outer box right
obb DWORD ?     ;outer box bottom
obl DWORD 9     ;outer box left

;inner box
ibt DWORD ?     ;inner box top
ibr DWORD ?     ;inner box right
ibb DWORD ?     ;inner box bottom
ibl DWORD ?     ;inner box left

;characters used for drawing
trc EQU 191         ;top right corner
tlc EQU 218         ;top left corner
blc EQU 192         ;bottom left corner
brc EQU 217         ;bottom right corner
lShade EQU 178      ;light shade block
mShade EQU 177      ;medium shade block
dShade EQU 176      ;dark shade block
solid EQU 219      ;full/filled/solid block
lHalf EQU 220       ;lower half of the block
uHalf EQU 223       ;upper half of the block
sHor EQU 196        ;single horizontal line
sVer EQU 179        ;single vertical line

.code

Reset PROC
    mov eax, white + (black * 16)
    call SetTextColor
    mov eax, 1000
    call Delay
    call SetupScreen
    call ClrScr
    ret 
Reset ENDP

SetupScreen PROC            ;calculating and setting the screen sizes and center wali cheezein
    call GetMaxXY
    movzx eax, ax
    mov screenHeight, eax
    movzx edx, dx
    mov screenWidth, edx
    shr eax, 1
    mov centerRow, eax
    shr edx, 1
    mov centerCol, edx
    ret
SetupScreen ENDP


DrawCol PROC         ;for drawing a column (aik hi character se)
    push edx            ;ecx already has index and edx already has the Gotoxy wali cheezein
    push ecx            ;al has the character jisse column banega
draw_col_loop:
    call Gotoxy         ;DH = row    DL = column
    call WriteChar      
    inc dh              ;incrementing row (same column obviously)
    loop draw_col_loop
    pop ecx             ;restoring ecx kionke I was making two sides of a box together to same hi no. of times loop chalaana tha
    pop edx             ;to baar baar set krne se behter wohi wala use kr loon
    ret                 ;edx isliye restore kia kionke then I'll only need to change the column (box ki sides draw krte waqy starting row is same)
DrawCol ENDP

DrawRow PROC            ;type of similar to DrawCol bs is baar col k bajaye we ar drawing row
    push edx
    push ecx
draw_row_loop:
    call Gotoxy         ;DH = row   DL = column
    call WriteChar      ;
    inc dl              ;incrementing col (same row obvioudly)
    loop draw_row_loop 
    pop ecx
    pop edx
    ret
DrawRow ENDP

DrawTwoCols PROC        ;for the shaded columns kionke one was looking too weird and aik hi cheez baar baar likne se behter proc bana loon
    call DrawCol
    inc dl              ;same starting row ass it is restored by DrawCol and then incrementing the column to draw it beside the previous one
    call DrawCol     ;baaki restoring wala kaam to DrawCol mein ho hi rha hai to baar baar set krne ki zaroorat nhi
    ret
DrawTwoCols ENDP

DrawAltCol PROC  ;This is similar to DrawCol bs wahaan aik hi character use ho rha tha yahaan 2 hain - full block and lower half block
    push edx
    push ecx
    
    mov al, solid    ;Starting with full block
col_loop:
    call Gotoxy
    call WriteChar
    
    cmp al, solid       ;pattern will be solid -> uHalf -> solid -> uHalf and so on
    je to_upper         ;if it is already solid to ab lHalf print hoga and vice versa
    mov al, solid
    jmp next
    
to_upper:
    mov al, uHalf
    
next:
    inc dh              ;har baar row to increment hogi hi
    loop col_loop

    pop ecx
    pop edx
    ret
DrawAltCol ENDP

DrawShades PROC
    pushad                  ;As input we are taking starting column in dl (for Gotoxy) - rows will be calculated here kionke poori screen pr hi show krna hai to PROC k baahir kro ya ander aik hi baat hai since this PROC is specifically for the outer most columns
    mov ecx, screenHeight   
    sub ecx, 2              ;2 bcoz 1 row up and 1 row bottom bhi krna hai for the box
    
    mov al, lShade
    call DrawTwoCols        
    inc dl                  ;only 1 increment bcoz 1 increment DrawTwoCOl k ander pehle se huawa hai
    mov al, mShade
    call DrawTwoCols
    inc dl
    mov al, dShade
    call DrawTwoCols
    
    popad
    ret
DrawShades ENDP

DisplayTextArray PROC
display_loop:             ; ESI = array offset, ECX = no of lines, DH = starting row
    mov ebx, [esi]
    call TextinCenter
    inc dh                ;This PROC is specifically for the bara bara text like Game Menu Loading Please and GoodBye
    add esi, TYPE ebx
    loop display_loop
    ret
DisplayTextArray ENDP

TextinCenter PROC
    push ecx        ;Input: EBX = offset of string, DH = row
    push edx        ;Storing ecx and edx kionke usse aur calculations krni hain
    
    mov edx, ebx        ;string needs to be in edx
    call StrLength      ;length is stored in eax
    shr eax, 1         ; length / 2

    ;for the center position of the text the starting col of the text needs to be: centerCol - (length/2)
    mov ecx, centerCol
    sub ecx, eax       

    pop edx             ;restoring edx, since it has the dh and dl values
    push edx            ;pushing it back kionke PROC ke baad wo salaamat chahye
    ; Set cursor position
    mov dl, cl         ; DL = calculated column
    call Gotoxy
    
    mov edx, ebx
    call WriteString
    
    pop edx
    pop ecx
    ret
TextinCenter ENDP

main PROC
    call Clrscr
    
menu::                  ;global bcoz LaunchGame bhi jmp krega yahaan
    call SetupScreen

    mov eax, screenHeight   ;calculating the outer box boundaries
    dec eax                 ;bottom will be 3 rows above the last row
    mov obb, eax
    sub obb, 3

    mov eax, screenWidth    ;right side will be 8 cols before the last col
    dec eax                 ;top and left side are already set
    mov obr, eax
    sub obr, 8

    mov eax, obb            ;inner box's bottom will bw 2 rows above outer box's bottom
    mov ibb, eax
    sub ibb, 2

    mov eax, obl            ;inner ki left side is 8 cols after outer's
    mov ibl, eax
    add ibl, 8

    mov eax, obr            ;inner's right is 8 cols left of outer's right
    mov ibr, eax
    sub ibr, 8

    mov eax, screenHeight   ;top is at screen's 43% row
    mov edx, 0
    imul eax, 43
    mov ebx, 100
    div ebx
    mov ibt, eax

    mov dh, 0
    mov dl, 0
    push edx

    mov eax, white + (black*16)
    call SetTextColor
    mov al, solid
    call writeChar         ;Drawing the top most row
    inc dl                 ;solid charaters at wither side wrna the row has only lower halves
    mov ecx, screenWidth
    sub ecx, 2             ;2 for the solids
    mov al, lHalf
    call DrawRow

    mov al, solid
    call WriteChar

    pop edx                ;restoring edx, becuase we need to draw the left-most col and we need to start from (0,1) to restore krke increment row
    inc dh  
    mov ecx, screenHeight  ;setting the loop
    sub ecx, 2             ;2 for the rows (top and bottom)

    call DrawAltCol  ;left most col

    mov dl, BYTE PTR screenWidth
    dec dl                      ;dh is already set (restored from the PROC)
    call DrawAltCol  ;right most col

    mov eax, lightCyan + (black*16) ;colour for the shaded cols
    call SetTextColor

    mov dl, 1               ;setting dl - dh is the same as before
    call DrawShades         ;left 

    mov dl, BYTE PTR screenWidth
    sub dl, 7               ;7 because 2+2+2+1 
    call DrawShades         ;right

    mov eax, white + (black * 16)   ;resetting colour
    call SetTextColor

    mov dh, BYTE PTR screenHeight
    dec dh
    mov dl, 0
    mov al, solid
    call Gotoxy
    call WriteChar
    inc dl
    mov al, uHalf
    mov ecx, screenWidth
    sub ecx, 2
    call DrawRow        ;bottom row - similar to the top row 2 solids on sides and lHalfs in the middle

    mov al, solid
    call WriteChar


    mov ecx, obr            ;outer box top row
    sub ecx, obl            ;loop with be according to the no of cols (left to right)
    mov dl, BYTE PTR obl    ;starting pos will be top left corner
    mov dh, BYTE PTR obt
    mov al, dShade
    call DrawRow

    mov ecx, obb            ;left side    
    sub ecx, obt            ;loop will be of the no of rows (top to bottom)
    mov dl, BYTE PTR obl    ;starting pos will be one row below top left corner since we don't want to ovrewrite that character in the top row
    mov dh, BYTE PTR obt
    inc dh
    call DrawAltCol

    mov dl, BYTE PTR obr    ;right side - similar to left one
    mov dh, BYTE PTR obt    ;starting pos is top right corner
    inc dh                  ;starting from one col left bcoz it is going out of the box
    dec dl
    call DrawAltCol

    mov ecx, obr            ;outer bottom row - similar to the top row
    sub ecx, obl
    mov dl, BYTE PTR obl    ;starting pos will be bottom left corner
    mov dh, BYTE PTR obb
    mov al, dShade
    call DrawRow

    mov eax, lightCyan + (black *16) 
    call SetTextColor

    mov ecx, ibr            ;same things for the inner box
    sub ecx, ibl            ;doing the bottom row first
    sub ecx, 2              ;the corner one first
    mov dl, BYTE PTR ibl
    mov dh, BYTE PTR ibb
    call Gotoxy
    mov al, blc
    call WriteChar
    inc dl                  ;incrementing col and then printing the lines
    mov al, sHor
    call DrawRow
    mov al, brc             ;then the other corner
    call WriteChar

    mov ecx, ibr            ;same with the top row
    sub ecx, ibl
    sub ecx, 2
    mov dl, BYTE PTR ibl
    mov dh, BYTE PTR ibt
    call Gotoxy
    mov al, tlc
    call WriteChar
    inc dl
    mov al, sHor
    call DrawRow
    mov al, trc
    call WriteChar

    mov ecx, ibb            ;then the cols - this is for the left one
    sub ecx, ibt
    dec  ecx                ;bcoz of the corner characters
    mov dl, BYTE PTR ibl
    mov dh, BYTE PTR ibt
    inc dh
    mov al, sVer
    call DrawCol

    mov dl, BYTE PTR ibr    ;right side
    mov dh, BYTE PTR ibt
    inc dh
    dec dl                  ;going outside of boundary
    call DrawCol

    mov eax, 7 + (black*16) ;7 is for lightgray (almost a whitish colour)
    call SetTextColor

    mov ecx, MENU_LINES         ;printing the GAME MENU 
    mov esi, OFFSET menuTitle   ;for input to the PROC
    mov eax, ibt                ;calculating the center row of the outer box and inner box wali jagah 
    add eax, obt
    shr eax, 1
    sub eax, 2
    mov dh, al
    call DisplayTextArray       ;ye wala row to khud hi calcualte kr lega
     
    mov eax, ibt        ;Displaying the options now
    add eax, ibb        ;calculating the center row for it
    shr eax, 1
    sub eax, 4
    mov dh, al

    mov ecx, OPTION_LINES
    mov esi, OFFSET options
    mov BYTE PTR current, dh  ;for the pointer animation thing, since it is starting from the first option ka row 
    mov BYTE PTR start, dh ;ye to aik baar hi calculate krna hai - this will remain fixed
    mov BYTE PTR ending, dh   
    add ending, 6             ;This too

    mov eax, LENGTHOF o1    ;acha since saare options ki length same hi hai isliye i used first option ki length (aik hi baat hai kisi aur ki bhi kr skte hain)
    shr eax, 1              ;calculate the starting col of that
    mov ebx, centerCol  
    sub ebx, eax           ;gap is already in the option -  blkl chipka kr nhi start krna thora gap rkhna hai acha lagega
    mov pCol, ebx

    mov ebx, centerCol     ;same for the num-and-arrow column
    add ebx, eax
    mov nCol, ebx
    
    mov eax, LightCyan + (black * 16)
    call SetTextColor

optioning:
    mov ebx, [esi]      ;printing the options
    call TextinCenter   
    add dh, 2           ;aik line ka gap and then next option (wrna ajeeb sa lag rha tha)
    add esi, 4
    loop optioning

    mov esi, OFFSET numbers

checking:
    
    mov eax, white + (black * 16)
    call SetTextColor

    mov dh, BYTE PTR ibb      ;msg will be inner bottom se 2 oopar 
    sub dh, 2
    mov ebx, OFFSET msg
    call TextinCenter
    
    mov dh, BYTE PTR current  
    mov dl, BYTE PTR pCol     ;positioning for the left side wale arrows
    push edx                        ;storing for the erasing part
    call Gotoxy
    mov edx, OFFSET pointer         ;printing both sides
    call WriteString

    mov dh, BYTE PTR current
    mov dl, BYTE PTR nCol
    call Gotoxy
    mov edx, [esi]
    call WriteString

    mov eax, 800           ;thora sa ruk kr erasing
    call Delay

    pop edx                ;isliye pop kia tha
    call Gotoxy
    mov edx, OFFSET s1
    call WriteString

    mov dh, BYTE PTR current
    mov dl, BYTE PTR nCol
    call Gotoxy
    mov edx, OFFSET s2
    call WriteString


    mov eax, ending   ;checking k agar last option tk pehunch gaye hain to start from the first option
    cmp eax, current
    je phir_se
    add esi, 4
    add current, 2
    jmp abhi_nahi

phir_se:
    mov esi, OFFSET numbers ;starting from [1]
    mov eax, start
    mov current, eax

abhi_nahi:
    mov eax, black + (white*16)     ;user input ko likhna hai in the white box
    call SetTextColor
    call ReadKey
    jz checking
    mov dh, BYTE PTR ibb        ;calculating the position of where to write it
    sub dh, 2
    mov ebx, LENGTHOF msg
    shr ebx, 1
    add ebx, centerCol
    sub ebx, 5
    mov dl,bl
    call Gotoxy
    call WriteChar

    
    ; Process choice
    cmp al, '1'
    je playMaze
    cmp al, '2'
    je playFlappy
    cmp al, '3'
    je playHangman
    cmp al, '4'
    je quitProgram
    

    mov eax, black + (red * 16)  
    call SetTextColor

    mov ebx, LENGTHOF msg    ;if invalid we will write that inblack with red background inside that box
    shr ebx, 1
    add ebx, centerCol
    sub ebx, 9
    mov dl, bl
    call Gotoxy

    mov edx, OFFSET invalidText
    call WriteString

    mov eax, 1500       ;thora sa ruk kr loop again
    call Delay

    jmp checking

playMaze:
    mov ebx, OFFSET TreasureHuntMaze
    call LaunchGame

playFlappy:
    mov ebx, OFFSET FlappyBird
    call LaunchGame

playHangman:
    mov ebx, OFFSET Hangman
    call LaunchGame


quitProgram:
   
    call Reset

    mov esi, OFFSET exitText
    mov ecx, EXIT_LINES
    mov dh, BYTE PTR centerRow
    sub dh, 6           ;Start row for GOODBYE is a bit oopar than being exaclty in the middle
    call DisplayTextArray
    
    mov dh, BYTE PTR centerRow
    add dh, 3
    mov ebx, OFFSET exitMsg
    call TextinCenter
    
    call ReadChar
    cmp al, 0Dh      ;0D represents the ENTER key
    je entered
    cmp al, 08h      ;08 represents backspace
    je going_back    ;uske ilawa kuch bhi dabaya to it will jsut clearscreen and show it again
    jmp quitProgram

going_back:
    mov eax, 800    ;thori der ruk kr waapis to the main menu
    call Delay
    call ClrScr
    jmp menu


entered:
    call crlf       ;direct kia tha but wo jo neeche likha aata hai it was way too close to the exitMsg for my liking 
    call crlf
    exit

main ENDP

Loading PROC
    pushad      ;push isliye bcoz it is called in LaunchGame which takes ebx as input - agar store nhi krwaaya to error aayega
    call Clrscr
    
    mov eax, lightCyan + (black * 16)
    call SetTextColor

    mov esi, OFFSET loadingText  
    mov ecx, LOADING_LINES          ;calculating where to print it
    mov eax, screenHeight
    mov ebx, 3
    mov edx, 0
    div ebx
    sub eax, 3
    mov dh, al
    call DisplayTextArray
    
    mov eax, lightGreen + (black * 16)
    call SetTextColor

    mov esi, OFFSET pleaseText  
    mov ecx, PLEASE_LINES       
    call DisplayTextArray

    mov eax, yellow + (black * 16)  ;this is for the process bar
    call SetTextColor

    mov ecx, LENGTHOF p1     ;bar ki length is almost same to please ki line - bs thori se chhoti hai
    mov eax, ecx
    sub ecx, 2
    shr eax, 1
    mov ebx, centerCol
    sub ebx, eax                   
    sub ebx, 2

    inc dh          ;Drawing a [ and a ] on either sides of the bar
    mov dl, bl                     
    call Gotoxy
    mov al, '['
    call WriteChar


    inc dl  ;incrementing col

progressBar:
    call Gotoxy
    mov al, solid                
    call WriteChar
    
    mov eax, 30         ;thora sa delay taake animated lage
    call Delay
    
    inc dl             ;increasing col for next drawing
    loop progressBar

    mov al, ']'
    call WriteChar


    mov eax, white + (black * 16)
    call SetTextColor

    mov eax, 500    ;thora sa ruk kr game shru krna hai
    call Delay
    call Clrscr

    popad
    ret
Loading ENDP

LaunchGame PROC
    call Reset
    call Loading
    call ebx        ;we are taking the game pROC ka offset as input in ebx
    call Clrscr
    jmp menu
LaunchGame ENDP

TreasureHuntMaze PROTO
FlappyBird PROTO
Hangman PROTO

END main
