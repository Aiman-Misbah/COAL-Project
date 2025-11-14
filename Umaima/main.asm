INCLUDE Irvine32.inc


.data
; Character aliases for clarity
quote   EQU 34     ; "
bslash  EQU 92     ; \
fslash  EQU 47     ; /
pipe    EQU 124    ; |
colon   EQU 58     ; :
openP   EQU 40     ; (
closeP  EQU 41     ; )
underscore EQU 95  ; _
space   EQU 32

menuL1 BYTE " _______       ___      .___  ___.  _______    .___  ___.  _______ .__   __.  __    __ ",0 
menuL2 BYTE "/  _____|     /   \     |   \/   | |   ____|   |   \/   | |   ____||  \ |  | |  |  |  |",0 
menuL3 BYTE "|  |  __     /  ^  \    |  \  /  | |  |__      |  \  /  | |  |__   |   \|  | |  |  |  |",0 
menuL4 BYTE "|  | |_ |   /  /_\  \   |  |\/|  | |   __|     |  |\/|  | |   __|  |  . `  | |  |  |  |",0
menuL5 BYTE "|  |__| |  /  _____  \  |  |  |  | |  |____    |  |  |  | |  |____ |  |\   | |  `--'  |",0 
menuL6 BYTE " \______| /__/     \__\ |__|  |__| |_______|   |__|  |__| |_______||__| \__|  \______/ ",0 
                                                                                        
menuTitle DWORD menuL1, menuL2, menuL3, menuL4, menuL5, menuL6
MENU_LINES = 6


option1 BYTE "    EXECUTE: MAZE_PROTOCOL.EXE              ",0
option2 BYTE "    INITIATE: FLIGHT_SIMULATION.EXE         ",0
option3 BYTE "    DECRYPT: WORD_MATRIX.EXE                ",0
option4 BYTE "    TERMINATE: SESSION.EXE                  ",0
options DWORD option1, option2, option3, option4
OPTION_LINES = 4

prompt BYTE "ENTER COMMAND SEQUENCE (NUMBER): ",solid,solid,solid,solid,solid,solid,solid,solid,solid,0
invalidText BYTE " INVALID ",0
exitMsg BYTE "Press ENTER to Leave or Press BACKSPACE to go back to the menu ",0

pointer BYTE 175,175,0        ; »» using ASCII 175
number1 BYTE "[1]  ",174,174,0
number2 BYTE "[2]  ",174,174,0
number3 BYTE "[3]  ",174,174,0
number4 BYTE "[4]  ",174,174,0
numbers DWORD number1, number2, number3, number4
numberCol DWORD ?
spaces2 BYTE "       ",0

currentOption DWORD ?
startingOption DWORD ?
endingOption DWORD ?
pointerCol DWORD ?
spaces1 BYTE "  ",0

; Big "LOADING GAME" text
loadingText DWORD loadingL1, loadingL2, loadingL3, loadingL4, loadingL5, loadingL6
LOADING_LINES = 6

loadingL1 BYTE "______              _____________                    _________                       ",0
loadingL2 BYTE "___  / ____________ ______  /__(_)_____________ _    __  ____/_____ _______ ________ ",0
loadingL3 BYTE "__  /  _  __ \  __ `/  __  /__  /__  __ \_  __ `/    _  / __ _  __ `/_  __ `__ \  _ \",0
loadingL4 BYTE "_  /___/ /_/ / /_/ // /_/ / _  / _  / / /  /_/ /     / /_/ / / /_/ /_  / / / / /  __/",0
loadingL5 BYTE "/_____/\____/\__,_/ \__,_/  /_/  /_/ /_/_\__, /      \____/  \__,_/ /_/ /_/ /_/\___/ ",0
loadingL6 BYTE "                                        /____/                                       ",0



; Big "PLEASE WAIT" text 
pleaseText DWORD pleaseL1, pleaseL2, pleaseL3, pleaseL4, pleaseL5
PLEASE_LINES = 5

pleaseL1 BYTE "______________                             ___       __      __________ ",0
pleaseL2 BYTE "___  __ \__  /__________ ____________      __ |     / /_____ ___(_)_  /_",0
pleaseL3 BYTE "__  /_/ /_  /_  _ \  __ `/_  ___/  _ \     __ | /| / /_  __ `/_  /_  __/",0
pleaseL4 BYTE "_  ____/_  / /  __/ /_/ /_(__  )/  __/     __ |/ |/ / / /_/ /_  / / /_  ",0
pleaseL5 BYTE "/_/     /_/  \___/\__,_/ /____/ \___/      ____/|__/  \__,_/ /_/  \__/  ",0


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
switch BYTE 'd'      ;u = up     d = down

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

SetupScreen PROC
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

; Procedure to draw a vertical column
DrawColumn PROC
    push edx
    push ecx
draw_col_loop:
    call Gotoxy         ; Use current DH (row) and DL (column)
    call WriteChar      ; Draw the character in AL
    inc dh              ; Move to next row
    loop draw_col_loop  ; Repeat ECX times
    pop ecx
    pop edx
    ret
DrawColumn ENDP

DrawRow PROC
    push edx
    push ecx
draw_row_loop:
    call Gotoxy         ; Use current DH (row) and DL (column)
    call WriteChar      ; Draw the character in AL
    inc dl              ; Move to next row
    loop draw_row_loop  ; Repeat ECX times
    pop ecx
    pop edx
    ret
DrawRow ENDP

DrawTwoCols PROC
    call DrawColumn
    inc dl
    call DrawColumn
    ret
DrawTwoCols ENDP

; Procedure to draw alternating half-blocks
DrawAlternatingColumn PROC
    push edx
    push ecx
    
    mov al, solid    ; Start with solid block
col_loop:
    call Gotoxy
    call WriteChar
    
    ; Cycle through the pattern: solid -> lHalf -> solid -> lHalf -> repeat
    cmp al, solid
    je to_lower
    ; If lHalf, go back to solid
    mov al, solid
    jmp next
    
to_lower:
    mov al, uHalf
    
next:
    inc dh
    loop col_loop

    pop ecx
    pop edx
    ret
DrawAlternatingColumn ENDP

DrawShades PROC
    ; Input: DL = starting column
    pushad
    mov ecx, screenHeight
    sub ecx, 2
    
    mov al, lShade
    call DrawTwoCols
    inc dl
    mov al, mShade
    call DrawTwoCols
    inc dl
    mov al, dShade
    call DrawTwoCols
    
    popad
    ret
DrawShades ENDP

DisplayTextArray PROC
    ; ESI = array offset, ECX = line count, DH = starting row
display_loop:
    mov ebx, [esi]
    call TextinCenter
    inc dh
    add esi, TYPE ebx
    loop display_loop
    ret
DisplayTextArray ENDP

TextinCenter PROC
    ; Input: EBX = offset of string, DH = row
    push ecx
    push edx
    
    ; Get string length
    mov edx, ebx
    call StrLength      ; EAX = string length
    shr eax, 1         ; length / 2

    ; Calculate center position: centerCol - (length/2)
    mov ecx, centerCol
    sub ecx, eax       ; centerCol - half length

    pop edx
    push edx
    ; Set cursor position
    mov dl, cl         ; DL = calculated column
    call Gotoxy
    
    ; Print the string
    mov edx, ebx
    call WriteString
    
    pop edx
    pop ecx
    ret
TextinCenter ENDP

main PROC

    call Clrscr
    
menu::
    call SetupScreen

    mov eax, screenHeight
    dec eax
    mov obb, eax
    sub obb, 3

    mov eax, screenWidth
    dec eax
    mov obr, eax
    sub obr, 8

    mov eax, obb
    mov ibb, eax
    sub ibb, 2

    mov eax, obl
    mov ibl, eax
    add ibl, 8

    mov eax, obr
    mov ibr, eax
    sub ibr, 8

    mov eax, screenHeight
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
    call writeChar
    inc dl
    mov ecx, screenWidth
    sub ecx, 2
    mov al, lHalf
    call DrawRow

    mov al, solid
    call WriteChar

    pop edx
    inc dh  
    mov ecx, screenHeight
    sub ecx, 2

    mov dl, 0
    call DrawAlternatingColumn

    mov dl, BYTE PTR screenWidth
    dec dl
    call DrawAlternatingColumn


    mov eax, lightCyan + (black*16)
    call SetTextColor

    mov ecx, screenHeight
    sub ecx, 2
    mov dl, 1
    call DrawShades

    mov dl, BYTE PTR screenWidth
    sub dl, 7
    call DrawShades

    mov eax, white + (black * 16)
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
    call DrawRow  

    mov al, solid
    call WriteChar

    mov eax, white + (black * 16)
    call SetTextColor

    mov ecx, obr
    sub ecx, obl
    mov dl, BYTE PTR obl
    mov dh, BYTE PTR obt
    mov al, dShade
    call DrawRow


    mov ecx, obb
    sub ecx, obt
    mov dl, BYTE PTR obl
    mov dh, BYTE PTR obt
    inc dh
    call DrawAlternatingColumn

    mov dl, BYTE PTR obr
    mov dh, BYTE PTR obt
    inc dh
    dec dl
    call DrawAlternatingColumn

    mov ecx, obr
    sub ecx, obl
    mov dl, BYTE PTR obl
    mov dh, BYTE PTR obb
    mov al, dShade
    call DrawRow

    mov eax, lightCyan + (black *16) 
    call SetTextColor

    mov ecx, ibr
    sub ecx, ibl
    sub ecx, 2
    mov dl, BYTE PTR ibl
    mov dh, BYTE PTR ibb
    call Gotoxy
    mov al, blc
    call WriteChar
    inc dl
    mov al, sHor
    call DrawRow
    mov al, brc
    call WriteChar

    mov ecx, ibr
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

    mov ecx, ibb
    sub ecx, ibt
    dec  ecx
    mov dl, BYTE PTR ibl
    mov dh, BYTE PTR ibt
    inc dh
    mov al, sVer
    call DrawColumn

    mov dl, BYTE PTR ibr
    mov dh, BYTE PTR ibt
    inc dh
    dec dl
    call DrawColumn

    mov eax, 7 + (black*16)
    call SetTextColor
    mov ecx, MENU_LINES
    mov esi, OFFSET menuTitle
    mov eax, ibt
    add eax, obt
    shr eax, 1
    sub eax, 2
    mov dh, al
    call DisplayTextArray
    mov eax, white + (black*16)
    call SetTextColor

   ; Display options using array
    mov eax, ibt
    add eax, ibb
    shr eax, 1
    sub eax, 4
    mov dh, al

    mov ecx, OPTION_LINES
    mov esi, OFFSET options
    mov BYTE PTR currentOption, dh
    mov BYTE PTR startingOption, dh
    mov BYTE PTR endingOption, dh
    add endingOption, 6

    mov eax, LENGTHOF option1
    shr eax, 1
    mov ebx, centerCol
    sub ebx, eax
    sub ebx, 2
    mov pointerCol, ebx

    mov ebx, centerCol
    add ebx, eax
    mov numberCol, ebx
    
    mov eax, LightCyan + (black * 16)
    call SetTextColor
    optionsLoop:
        mov ebx, [esi]
        call TextinCenter
        add dh, 2
        add esi, 4
        loop optionsLoop

    mov esi, OFFSET numbers
anim_and_invalid_check:
    
    mov eax, white + (black * 16)
    call SetTextColor

    ; Display prompt (centered)
    mov dh, BYTE PTR ibb
    sub dh, 2
    mov ebx, OFFSET prompt
    call TextinCenter
    
    mov dh, BYTE PTR currentOption
    mov dl, BYTE PTR pointerCol
    push edx
    call Gotoxy
    mov edx, OFFSET pointer
    call WriteString

    mov dh, BYTE PTR currentOption
    mov dl, BYTE PTR numberCol
    call Gotoxy
    mov edx, [esi]
    call WriteString

    mov eax, 800
    call Delay

    pop edx
    call Gotoxy
    mov edx, OFFSET spaces1
    call WriteString

    mov dh, BYTE PTR currentOption
    mov dl, BYTE PTR numberCol
    call Gotoxy
    mov edx, OFFSET spaces2
    call WriteString


    mov eax, endingOption
    cmp eax, currentOption
    je phir_se
    add esi, 4
    add currentOption, 2
    jmp abhi_nahi

phir_se:
    mov esi, OFFSET numbers
    mov eax, startingOption
    mov currentOption, eax

abhi_nahi:
    ; Get user choice (input at current position)
    mov eax, black + (white*16)
    call SetTextColor
    call ReadKey
    jz anim_and_invalid_check
    mov dh, BYTE PTR ibb
    sub dh, 2
    mov ebx, LENGTHOF prompt
    shr ebx, 1
    add ebx, centerCol
    sub ebx, 5
    mov dl,bl
    call Gotoxy
    call WriteChar
    call Crlf
    
    ; Process choice
    cmp al, '1'
    je playMaze
    cmp al, '2'
    je playFlappy
    cmp al, '3'
    je playHangman
    cmp al, '4'
    je quitProgram
    

    ; Invalid choice - display red box with "INVALID" text
    mov eax, black + (red * 16)
    call SetTextColor

    mov ebx, LENGTHOF prompt
    shr ebx, 1
    add ebx, centerCol
    sub ebx, 9
    mov dl, bl
    call Gotoxy

    mov edx, OFFSET invalidText
    call WriteString

    call Crlf
    mov eax, 1500
    call Delay

    jmp anim_and_invalid_check

playMaze:
    mov ebx, OFFSET TreasureHuntMaze
    call LaunchGame
    jmp menu

playFlappy:
    mov ebx, OFFSET FlappyBird
    call LaunchGame
    jmp menu

playHangman:
    mov ebx, OFFSET Hangman
    call LaunchGame
    jmp menu


quitProgram:
   
    call Reset
    call Clrscr           ; Clear screen FIRST

    ; Display exit ASCII art
    mov esi, OFFSET exitText
    mov ecx, EXIT_LINES
    mov dh, BYTE PTR centerRow
    sub dh, 6           ; Start position for the art
    
    call DisplayTextArray
    
    ; Display additional message below the art
    mov dh, BYTE PTR centerRow
    add dh, 3
    mov ebx, OFFSET exitMsg
    call TextinCenter
    
    call ReadChar
    cmp al, 0Dh      ;ENTER key
    je entered
    cmp al, 08h
    je going_back
    jmp quitProgram

going_back:
    mov eax, 800
    call Delay
    call ClrScr
    jmp menu


entered:
    call crlf
    call crlf
    exit

main ENDP

ShowLoadingScreen PROC
    pushad
    call Clrscr
    
    ; Set color for "LOADING GAME" text
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
    ; Display "Loading Game" ASCII art using array
    mov esi, OFFSET loadingText  ; Point to array of pointers
    mov ecx, LOADING_LINES       ; Number of lines
    mov eax, screenHeight
    mov ebx, 3
    mov edx, 0
    div ebx
    sub eax, 3
    mov dh, al

    call DisplayTextArray
    
    ; Set color for "PLEASE WAIT" text
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    ; Display "PLEASE WAIT" ASCII art using array
    mov esi, OFFSET pleaseText  ; Point to array of pointers
    mov ecx, PLEASE_LINES       ; Number of lines

    call DisplayTextArray

    ; Progress bar (same as before)
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    ; Large centered progress bar
    mov ecx, LENGTHOF pleaseL1     ; Progress bar length 
    mov eax, ecx
    sub ecx, 2
    shr eax, 1
    mov ebx, centerCol
    sub ebx, eax                   ; Subtract bar length
    sub ebx, 2

    ; Draw opening bracket
    inc dh                         ; Row
    mov dl, bl                     ; Column
    call Gotoxy
    mov al, '['
    call WriteChar

    ; Progress bar animation
    inc dl                         ; Move past opening bracket

progressBar:
    call Gotoxy
    mov al, solid                
    call WriteChar
    
    mov eax, 30                ; Speed
    call Delay
    
    inc dl                     ; Next position
    loop progressBar

; Draw closing bracket
mov al, ']'
call WriteChar

    ; Reset to default color
    mov eax, white + (black * 16)
    call SetTextColor

    ; Brief pause before clearing
    mov eax, 500
    call Delay
    
    call Clrscr
    popad
    ret
ShowLoadingScreen ENDP

LaunchGame PROC
    call Reset
    call ShowLoadingScreen
    call ebx        ; Input: EBX = address of game procedure
    call Clrscr
    jmp menu
LaunchGame ENDP

TreasureHuntMaze PROTO
FlappyBird PROTO
Hangman PROTO

END main
