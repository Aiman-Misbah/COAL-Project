INCLUDE Irvine32.inc

.data
menuTitle BYTE "MAIN MENU - CHOOSE YOUR GAME",0
option1 BYTE "1. Treasure Hunt Maze",0
option2 BYTE "2. Flappy Bird",0
option3 BYTE "3. Hangman",0
option4 BYTE "4. Exit",0
prompt BYTE "Enter your choice (1-4): ",0
invalidChoice BYTE "Invalid choice! Please enter 1-4.",0
exitMsg BYTE "Thanks for playing! Goodbye!",0
loadingStartRow DWORD ?
pleaseStartRow DWORD ?
progressBarRow DWORD ?

loadingText DWORD loadingL1, loadingL2, loadingL3, loadingL4, loadingL5, loadingL6
LOADING_LINES = 6

loadingL1 BYTE "    __                    ___                ______                    ",0
loadingL2 BYTE "   / /   ____  ____ _____/ (_)___  ____ _   / ____/___ _____ ___  ___  ",0
loadingL3 BYTE "  / /   / __ \/ __ `/ __  / / __ \/ __ `/  / / __/ __ `/ __ `__ \/ _ \ ",0
loadingL4 BYTE " / /___/ /_/ / /_/ / /_/ / / / / / /_/ /  / /_/ / /_/ / / / / / /  __/ ",0
loadingL5 BYTE "/_____/\____/\__,_/\__,_/_/_/ /_/\__, /   \____/\__,_/_/ /_/ /_/\___/  ",0
loadingL6 BYTE "                                /____/                                 ",0

pleaseText DWORD pleaseL1, pleaseL2, pleaseL3
PLEASE_LINES = 3

pleaseL1 BYTE "___  _    ____ ____ ____ ____    _ _ _ ____ _ ___ ",0
pleaseL2 BYTE "|__] |    |___ |__| [__  |___    | | | |__| |  |  ",0
pleaseL3 BYTE "|    |___ |___ |  | ___] |___    |_|_| |  | |  |  ",0

screenWidth DWORD ?
screenHeight DWORD ?
col DWORD ?
row DWORD ?

.code
main PROC
    call Clrscr
menu:
    call GetMaxXY
    movzx eax, ax
    mov screenHeight, eax
    movzx edx, dx
    mov screenWidth, edx

    shr eax, 1
    mov row, eax
    shr edx, 1
    mov col, edx

    mov dh, 5
    mov eax, col
    mov ebx, LENGTHOF menuTitle
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET menuTitle
    call WriteString

    mov dh, 8
    mov eax, col
    mov ebx, LENGTHOF option1
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET option1
    call WriteString

    mov dh, 10
    mov eax, col
    mov ebx, LENGTHOF option2
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET option2
    call WriteString

    mov dh, 12
    mov eax, col
    mov ebx, LENGTHOF option3
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET option3
    call WriteString

    mov dh, 14
    mov eax, col
    mov ebx, LENGTHOF option4
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET option4
    call WriteString

    mov dh, 17
    mov eax, col
    mov ebx, LENGTHOF prompt
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET prompt
    call WriteString

    call ReadChar
    call WriteChar
    call Crlf

    cmp al, '1'
    je playMaze
    cmp al, '2'
    je playFlappy
    cmp al, '3'
    je playHangman
    cmp al, '4'
    je quitProgram

    mov dh, 19
    mov eax, col
    mov ebx, LENGTHOF invalidChoice
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET invalidChoice
    call WriteString
    call Crlf
    call WaitMsg
    call Clrscr
    jmp menu

playMaze:
    mov eax, 500
    call Delay
    call ShowLoadingScreen
    call TreasureHuntMaze
    call Clrscr
    jmp menu

playFlappy:
    mov eax, 500
    call Delay
    call ShowLoadingScreen
    call FlappyBird
    call Clrscr
    jmp menu

playHangman:
    mov eax, 500
    call Delay
    call ShowLoadingScreen
    call Hangman
    call Clrscr
    jmp menu

quitProgram:
    mov eax, 500
    call Delay
    call Clrscr
    mov dh, 12
    mov eax, col
    mov ebx, LENGTHOF exitMsg
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET exitMsg
    call WriteString
    call Crlf
    call WaitMsg
    exit
main ENDP

ShowLoadingScreen PROC
    pushad
    call Clrscr
    call GetMaxXY
    movzx eax, ax
    mov screenHeight, eax
    movzx edx, dx
    mov screenWidth, edx

    mov eax, LOADING_LINES
    add eax, PLEASE_LINES
    add eax, 2
    mov ebx, eax
    mov eax, screenHeight
    sub eax, ebx
    shr eax, 1
    mov loadingStartRow, eax

    mov edx, eax
    add edx, LOADING_LINES
    add edx, 1
    mov pleaseStartRow, edx

    add edx, PLEASE_LINES
    add edx, 2
    mov progressBarRow, edx

    mov eax, 14 + (black * 16)
    call SetTextColor

    mov esi, OFFSET loadingText
    mov ecx, LOADING_LINES
    mov edx, loadingStartRow

loadingLoop:
    push ecx
    push edx
    mov ebx, [esi]
    push edx
    mov edx, ebx
    call StrLength
    mov ebx, screenWidth
    sub ebx, eax
    shr ebx, 1
    pop edx
    mov dh, dl
    mov dl, bl
    call Gotoxy
    mov edx, [esi]
    call WriteString
    add esi, 4
    pop edx
    inc edx
    pop ecx
    loop loadingLoop

    mov eax, 11 + (black * 16)
    call SetTextColor

    mov esi, OFFSET pleaseText
    mov ecx, PLEASE_LINES
    mov edx, pleaseStartRow

pleaseLoop:
    push ecx
    push edx
    mov ebx, [esi]
    push edx
    mov edx, ebx
    call StrLength
    mov ebx, screenWidth
    sub ebx, eax
    shr ebx, 1
    pop edx
    mov dh, dl
    mov dl, bl
    call Gotoxy
    mov edx, [esi]
    call WriteString
    add esi, 4
    pop edx
    inc edx
    pop ecx
    loop pleaseLoop

    mov eax, 2 + (black * 16)
    call SetTextColor

    mov ecx, 50
    mov ebx, screenWidth
    sub ebx, ecx
    sub ebx, 2
    shr ebx, 1

    mov eax, progressBarRow
    mov dh, al
    mov dl, bl
    call Gotoxy
    mov al, '['
    call WriteChar

    inc dl
    mov esi, ecx

progressBar:
    push ecx
    push edx
    mov eax, progressBarRow
    mov dh, al
    call Gotoxy
    mov al, 219
    call WriteChar
    mov eax, 60
    call Delay
    pop edx
    inc dl
    pop ecx
    loop progressBar

    mov al, ']'
    call WriteChar
    mov eax, white + (black * 16)
    call SetTextColor
    mov eax, 800
    call Delay
    call Clrscr
    popad
    ret
ShowLoadingScreen ENDP

TreasureHuntMaze PROTO
FlappyBird PROTO
Hangman PROTO

END main
