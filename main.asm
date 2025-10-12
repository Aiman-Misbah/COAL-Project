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

; Big "LOADING GAME" text
loadingText DWORD loadingL1, loadingL2, loadingL3, loadingL4, loadingL5, loadingL6
LOADING_LINES = 6

loadingL1 BYTE " _       _____   ____    ___   _   _    _____    ____    ___    __   ____",0
loadingL2 BYTE "| |     |  _  | |  _ |  /   | | | | |  |  _  |  |  _ |  /   |  /  | |  _ |",0
loadingL3 BYTE "| |     | | | | | |_| | / /| | | | | | | | | |  | |_| | / /| | / /| | |_| |",0
loadingL4 BYTE "| |     | | | | |  _ < / /_| | | | | | | | | |  |  _ < / /_| |/ / | | |  _ <",0
loadingL5 BYTE "| |___  | |_| | | |_| | |  | | | |_| | | |_| |  | |_| | |  | | |  | | | |_| |",0
loadingL6 BYTE "|_____| |_____| |____/ |__| | |_____|  |_____|  |____/ |__| | |__| | |____/",0



; Big "PLEASE WAIT" text 
pleaseText DWORD pleaseL1, pleaseL2, pleaseL3, pleaseL4, pleaseL5, pleaseL6
PLEASE_LINES = 6

pleaseL1 BYTE " ____   _       _____   ____    ___    __     _   _   ___   _____",0
pleaseL2 BYTE "|  _ | | |     |  ___| |  _ |  /   |  /  |   | | | | |_  | |_   _|",0
pleaseL3 BYTE "| |_| | | |     | |___  | |_| | / /| | / /| |  | | | |   | |  | |",0
pleaseL4 BYTE "|  _ <  | |     |  ___| |  _ < / /_| |/ / | |  | | | |   | |  | |",0
pleaseL5 BYTE "| |_| | | |___  | |___  | |_| | |  | | |  | |  | |_| | __| |  | |",0
pleaseL6 BYTE "|____/  |_____| |_____| |____/ |__| | |__| |   |_____| |____|  |_|",0

.code
main PROC
    call Clrscr
    
menu:
    ; Display menu
    mov edx, OFFSET menuTitle
    call WriteString
    call Crlf
    call Crlf
    
    mov edx, OFFSET option1
    call WriteString
    call Crlf
    
    mov edx, OFFSET option2
    call WriteString
    call Crlf
    
    mov edx, OFFSET option3
    call WriteString
    call Crlf
    
    mov edx, OFFSET option4
    call WriteString
    call Crlf
    call Crlf
    
    ; Get user choice
    mov edx, OFFSET prompt
    call WriteString
    call ReadChar
    call WriteChar
    call Crlf
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
    
    ; Invalid choice
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
    call Delay
    call ShowLoadingScreen
    call FlappyBird
    call Clrscr
    jmp menu

playHangman:
    call Delay
    call ShowLoadingScreen
    call Hangman
    call Clrscr
    jmp menu

quitProgram:
    call Delay
    call Clrscr
    mov edx, OFFSET exitMsg
    call WriteString
    call Crlf
    call WaitMsg
    invoke ExitProcess, 0

main ENDP

; Centered loading screen with different animations
; Centered loading screen with arrays
; Centered loading screen with arrays
ShowLoadingScreen PROC
    pushad
    call Clrscr
    
    ; Set color for "LOADING GAME" text
    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
    ; Display "LOADING GAME" ASCII art using array
    mov esi, OFFSET loadingText  ; Point to array of pointers
    mov ecx, LOADING_LINES       ; Number of lines
    mov edx, 3                   ; Starting row
    
loadingLoop:
    push ecx
    push edx
    
    ; Get current string pointer
    mov ebx, [esi]              ; Get pointer from array
    
    ; Calculate horizontal center
    push edx
    mov edx, ebx
    call StrLength              ; Get string length in EAX
    mov ebx, 80                 ; Screen width
    sub ebx, eax                ; Subtract string length
    shr ebx, 1                  ; Divide by 2 for center
    pop edx
    
    ; Position and print
    mov dh, dl                  ; Row
    mov dl, bl                  ; Column
    call Gotoxy
    mov edx, [esi]              ; Get string pointer again
    call WriteString
    
    ; Next array element and row
    add esi, 4                  ; Next DWORD pointer (4 bytes)
    pop edx
    inc edx                     ; Next row
    pop ecx
    loop loadingLoop
    
    ; Set color for "PLEASE WAIT" text
    mov eax, lightGreen + (black * 16)
    call SetTextColor
    
    ; Display "PLEASE WAIT" ASCII art using array
    mov esi, OFFSET pleaseText  ; Point to array of pointers
    mov ecx, PLEASE_LINES       ; Number of lines
    mov edx, 10                 ; Starting row
    
pleaseLoop:
    push ecx
    push edx
    
    ; Get current string pointer
    mov ebx, [esi]              ; Get pointer from array
    
    ; Calculate horizontal center
    push edx
    mov edx, ebx
    call StrLength              ; Get string length in EAX
    mov ebx, 80                 ; Screen width
    sub ebx, eax                ; Subtract string length
    shr ebx, 1                  ; Divide by 2 for center
    pop edx
    
    ; Position and print
    mov dh, dl                  ; Row
    mov dl, bl                  ; Column
    call Gotoxy
    mov edx, [esi]              ; Get string pointer again
    call WriteString
    
    ; Next array element and row
    add esi, 4                  ; Next DWORD pointer (4 bytes)
    pop edx
    inc edx                     ; Next row
    pop ecx
    loop pleaseLoop
    
    ; Progress bar (same as before)
    mov eax, yellow + (black * 16)
    call SetTextColor
    
    ; Large centered progress bar
    mov ecx, 50                 ; Progress bar length
    mov ebx, 80                 ; Screen width
    sub ebx, ecx                ; Subtract bar length
    sub ebx, 2                  ; Subtract brackets
    shr ebx, 1                  ; Divide by 2 for center
    
    ; Draw opening bracket
    mov dh, 18                  ; Row
    mov dl, bl                  ; Column
    call Gotoxy
    mov al, '['
    call WriteChar
    
    ; Progress bar animation
    inc dl                      ; Move past opening bracket
    mov esi, ecx                ; Save total length
    
progressBar:
    push ecx
    push edx
    
    mov dh, 18                  ; Row
    call Gotoxy
    mov al, 219                 ; Block character
    call WriteChar
    
    
    mov eax, 60                 ; Speed
    call Delay
    
    pop edx
    inc dl                      ; Next position
    pop ecx
    loop progressBar

    ; Draw closing bracket
    mov al, ']'
    call WriteChar

    ; Reset to default color
    mov eax, white + (black * 16)
    call SetTextColor

    ; Brief pause before clearing
    mov eax, 800
    call Delay
    
    call Clrscr
    popad
    ret
ShowLoadingScreen ENDP

; External procedures from other files
TreasureHuntMaze PROTO
FlappyBird PROTO
Hangman PROTO

END main
