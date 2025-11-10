INCLUDE Irvine32.inc

.data
; Hangman visual stages
spc EQU 32
trc EQU 187
tlc EQU 201
blc EQU 200
vl EQU 186
hl EQU 205

screen_width DWORD ?
screen_height DWORD ?
center_col DWORD ?
center_row DWORD ?
word_start_col DWORD ?

hangman0 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,hl,hl,hl,hl,hl,hl,hl,hl,0

hangman1 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,hl,hl,hl,hl,hl,hl,hl,hl,0

hangman2 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,hl,hl,hl,hl,hl,hl,hl,hl,0

hangman3 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/","|",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,hl,hl,hl,hl,hl,hl,hl,hl,0

hangman4 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/","|","\",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,hl,hl,hl,hl,hl,hl,hl,hl,0

hangman5 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/","|","\",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,hl,hl,hl,hl,hl,hl,hl,hl,0

hangman6 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/","|","\",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/"," ","\",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,hl,hl,hl,hl,hl,hl,hl,hl,0

hangman_stages DWORD hangman0, hangman1, hangman2, hangman3, hangman4, hangman5, hangman6

; Welcome screen content
welcome_title1 BYTE "  _    _    _    _    _    _    _    _  ",0
welcome_title2 BYTE " / \  / \  / \  / \  / \  / \  / \  / \ ",0
welcome_title3 BYTE "( H )( A )( N )( G )( M )( A )( N )( ! )",0
welcome_title4 BYTE " \_/  \_/  \_/  \_/  \_/  \_/  \_/  \_/ ",0

welcome_msg1   BYTE "WELCOME, BRAVE GUESSER!",0
welcome_msg2   BYTE "Ready to save a virtual life?",0
welcome_msg3   BYTE "Guess the word before the stick figure meets its doom!",0

menu_option1   BYTE "[1] - PLAY GAME",0
menu_option2   BYTE "[2] - INSTRUCTIONS",0
menu_option3   BYTE "[3] - RETURN TO MAIN MENU",0

instructions1  BYTE "=== HOW TO PLAY ===",0
instructions2  BYTE "1. Guess letters one at a time",0
instructions3  BYTE "2. Each wrong guess adds a body part to the hangman",0
instructions4  BYTE "3. 6 wrong guesses and... GAME OVER!",0
instructions5  BYTE "4. Guess all letters correctly to WIN!",0

press_key_msg  BYTE "Press BACKSPACE to go back",0

; Game variables
mistakes    BYTE 0
success_guess_counter BYTE 0

; Multiple words to guess
word1 BYTE "COMPUTER",0
word2 BYTE "PROGRAMMING",0
word3 BYTE "LANGUAGE",0
word4 BYTE "ASSEMBLY",0
word5 BYTE "PROCESSOR",0
word6 BYTE "MEMORY",0
word7 BYTE "KEYBOARD",0
word8 BYTE "SOFTWARE",0

word_list DWORD OFFSET word1, OFFSET word2, OFFSET word3, OFFSET word4, OFFSET word5, OFFSET word6, OFFSET word7, OFFSET word8
word_count = 8

str_word BYTE 20 DUP(0)
str_word_msg BYTE "The word was: ",0

last_word_index DWORD -1

; Messages
msg_restart     BYTE "Press [R] to Replay or [M] for Menu",0
msg_won         BYTE "CONGRATULATIONS! YOU WON!",0
msg_lost        BYTE "GAME OVER! YOU LOSE!",0
already_guessed BYTE "ALREADY GUESSED!",0
msg_top         BYTE "=== HANGMAN GAME ===",0
prompt_msg      BYTE "Enter your guess: ",0
wrong_msg       BYTE "Incorrect! Try again.",0
correct_msg     BYTE "Correct guess!",0
attempts_msg    BYTE "Lives remaining: ",0

str_guess BYTE 26 DUP(0)

; Colors
title_color     DWORD lightcyan + (blue * 16)
hangman_color   DWORD white + (black * 16)
word_color      DWORD yellow + (black * 16)
prompt_color    DWORD white + (black * 16)
correct_color   DWORD lightgreen + (black * 16)
wrong_color     DWORD lightred + (black * 16)
win_color       DWORD lightmagenta + (black * 16)
lose_color      DWORD lightred + (black * 16)
attempts_color  DWORD lightblue + (black * 16)
already_color   DWORD brown + (black * 16)
welcome_color   DWORD lightred + (black * 16)
menu_color      DWORD lightgreen + (black * 16)
instructions_color DWORD lightblue + (black * 16)

.code

Hangman PROC
    call InitializeScreenForSize
    call HangmanMenu
    ret
Hangman ENDP

HangmanMenu PROC
MenuLoop:
    call Clrscr
    call DisplayWelcomeScreen
    call DisplayMenuOptions
    
    call ReadChar
    
    cmp al, '1'
    je PlayGame
    cmp al, '2'
    je ShowInstructions
    cmp al, '3'
    je ReturnToMain
    jmp MenuLoop

PlayGame:
    mov eax, 800
    call Delay
    call PlayHangmanGame
    jmp ReturnToMain

ShowInstructions:
    mov eax, 800
    call Delay
    call DisplayInstructions
    jmp MenuLoop

ReturnToMain:
    mov eax, 800
    call Delay
    mov eax, white + (black * 16)
    call SetTextColor
    ret
HangmanMenu ENDP

GetLowerMidRow PROC
    mov eax, center_row
    add eax, screen_height
    shr eax, 1
    ret
GetLowerMidRow ENDP

CenterTextAtRow PROC
    ; Input: EBX = row, EDX = message offset
    push eax
    push ebx
    push ecx
    push edx
    
    ; Save message offset
    mov ecx, edx
    
    ; Get string length
    call StrLength      ; length in EAX
    shr eax, 1          ; divide by 2
    
    ; Calculate centered position
    mov edx, center_col
    sub edx, eax
    mov dl, dl          ; column in DL
    mov dh, bl          ; row in DH
    
    ; Set cursor position and write string
    call Gotoxy
    mov edx, ecx        ; restore message offset
    call WriteString
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
CenterTextAtRow ENDP

DisplayWelcomeScreen PROC
    mov eax, welcome_color
    call SetTextColor
    
    mov ebx, center_row
    sub ebx, 12
    mov edx, OFFSET welcome_title1
    call CenterTextAtRow
  
    inc ebx
    mov edx, OFFSET welcome_title2
    call CenterTextAtRow

    inc ebx
    mov edx, OFFSET welcome_title3
    call CenterTextAtRow
    
    inc ebx
    mov edx, OFFSET welcome_title4
    call CenterTextAtRow

    
    mov eax, menu_color
    call SetTextColor
    
    add ebx, 3
    mov edx, OFFSET welcome_msg1
    call CenterTextAtRow
    
    add ebx, 2
    mov edx, OFFSET welcome_msg2
    call CenterTextAtRow
    
    add ebx, 2
    mov edx, OFFSET welcome_msg3
    call CenterTextAtRow

    
    mov eax, hangman_color
    call SetTextColor

    mov esi, OFFSET hangman2
    call DisplayHangmanAt


HangmanDone:
    ret
DisplayWelcomeScreen ENDP

DisplayMenuOptions PROC
    mov eax, menu_color
    call SetTextColor
    
    mov ebx, center_row
    add ebx, 2
    mov dh, bl
    mov ecx, center_col
    add ecx, 5
    mov dl, cl
    call Gotoxy
    mov edx, OFFSET menu_option1
    call WriteString
    
    add bl, 2
    mov dh, bl
    mov dl, cl
    call Gotoxy
    mov edx, OFFSET menu_option2
    call WriteString
    
    add bl, 2
    mov dh, bl
    mov dl, cl
    call Gotoxy
    mov edx, OFFSET menu_option3
    call WriteString
    
    ret
DisplayMenuOptions ENDP

DisplayInstructions PROC
    call Clrscr
    
    mov eax, instructions_color
    call SetTextColor
    
    mov ebx, center_row
    sub ebx, 12
    mov edx, OFFSET instructions1
    call CenterTextAtRow

    add ebx, 2
    mov edx, OFFSET instructions2
    call CenterTextAtRow

    add ebx, 2
    mov edx, OFFSET instructions3
    call CenterTextAtRow

    add ebx, 2
    mov edx, OFFSET instructions4
    call CenterTextAtRow

    add ebx, 2
    mov edx, OFFSET instructions5
    call CenterTextAtRow

    mov eax, hangman_color
    call SetTextColor

    ; Replace all the hangman display code with:
    mov esi, OFFSET hangman6

    call DisplayHangmanAt

    mov eax, menu_color
    call SetTextColor
    
    mov eax, center_col
    add eax, 5
    mov dl, al
    
    add ebx, 7
    mov dh, bl
    call Gotoxy
    mov edx, OFFSET press_key_msg
    call WriteString


    ; Wait for backspace key only
WaitForBackspace:
    call ReadChar
    cmp al, 8  ; Backspace ASCII code
    jne WaitForBackspace

    mov eax, 800
    call Delay
    ret
DisplayInstructions ENDP

PlayHangmanGame PROC
GameReplayLoop:
    call Clrscr
    call InitializeScreenForSize
    call InitializeGame
    call GameLoop

WaitForChoice:
    call WaitForKey  ; Returns choice in AL
    cmp al, 'R'
    je GameReplayLoop
    cmp al, 'r'
    je GameReplayLoop
    cmp al, 'M'
    je ReturnToMenu
    cmp al, 'm'
    je ReturnToMenu
    jmp WaitForChoice  ; Invalid key, wait again

ReturnToMenu:
    ret
PlayHangmanGame ENDP

InitializeScreenForSize PROC
    call GetMaxXY
    movzx eax, ax
    mov screen_height, eax
    shr eax, 1
    mov center_row, eax
    movzx edx, dx
    mov screen_width, edx
    shr edx, 1
    mov center_col, edx
    ret
InitializeScreenForSize ENDP

ClearMessageLine PROC
    pushad
    mov dl, 0
    call Gotoxy
    mov ecx, screen_width
ClearLoop:
    mov al, ' '
    call WriteChar
    loop ClearLoop
    popad
    ret
ClearMessageLine ENDP


InitializeGame PROC
    mov mistakes, 0
    mov success_guess_counter, 0
    
        mov ecx, 26
    mov esi, OFFSET str_guess
    mov al, 0
ClearGuess:
    mov [esi], al
    inc esi
    loop ClearGuess
    
    call SelectRandomWord
    
    mov eax, title_color
    call SetTextColor
    mov ebx, 1
    mov edx, OFFSET msg_top
    call CenterTextAtRow
    
    call DisplayAttempts
    call DisplayHangman
    call DisplayWordLines
    ret
InitializeGame ENDP

DisplayAttempts PROC
    mov eax, attempts_color
    call SetTextColor
    mov ebx, 4
    mov edx, OFFSET attempts_msg
    call CenterTextAtRow
    
    movzx eax, mistakes
    mov ebx, 6
    sub ebx, eax
    mov eax, ebx
    call WriteDec
    ret
DisplayAttempts ENDP

SelectRandomWord PROC
    pushad
    
TryAgain:
    call Randomize
    mov eax, word_count
    call RandomRange
    
    ; Check if this is the same as last word
    cmp eax, last_word_index
    je TryAgain
    
    ; Store as last used word
    mov last_word_index, eax
    
    ; Get the word pointer and copy it
    mov esi, eax
    shl esi, 2
    mov esi, word_list[esi]
    mov edi, OFFSET str_word
    
CopyLoop:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne CopyLoop
    
    popad
    ret
SelectRandomWord ENDP

GetStringLength PROC
    ; Input: ESI = string offset
    ; Output: ECX = length
    push esi
    mov ecx, 0
CountLoop:
    cmp byte ptr [esi], 0
    je DoneCount
    inc ecx
    inc esi
    jmp CountLoop
DoneCount:
    pop esi
    ret
GetStringLength ENDP

DisplayHangman PROC
    movzx eax, mistakes
    mov esi, hangman_stages[eax*4]
    mov eax, center_row
    sub eax, 8
    mov dh, al
    mov eax, center_col
    sub eax, 5
    mov dl, al
    
    pushad
    mov eax, hangman_color
    call SetTextColor
    mov bl, dl
    call Gotoxy

DisplayHangmanLoop:
    mov al, [esi]
    cmp al, 0
    je DisplayHangmanDone
    cmp al, 0Dh
    je DisplayHangmanNewLine
    call WriteChar
    jmp DisplayHangmanContinue

DisplayHangmanNewLine:
    inc esi
    cmp byte ptr [esi], 0Ah
    jne DisplayHangmanContinue
    inc esi
    inc dh
    mov dl, bl
    call Gotoxy
    jmp DisplayHangmanLoop

DisplayHangmanContinue:
    inc esi
    jmp DisplayHangmanLoop

DisplayHangmanDone:
    popad
    ret
DisplayHangman ENDP

; Generic procedure to display hangman
; Input: ESI = offset of hangman stage, EBX = row to start drawing
DisplayHangmanAt PROC
    pushad

    mov eax, hangman_color
    call SetTextColor

    ; -------- Correct column calculation (screen_width / 3 + 3) --------
    mov eax, screen_width
    mov ebx, 3            ; divisor must be EBX
    mov edx, 0
    div ebx               ; eax = screen_width / 3
    sub eax, 3            ; small offset to right
    mov dl, al            ; DL = starting column

    mov eax, center_row
    mov dh, al            ; DH = original row
    call Gotoxy           ; Go to starting position
    mov bh, dl            ; Save starting column in BH for line resets

DisplayHangmanLoop:
    mov al, [esi]
    cmp al, 0
    je DisplayHangmanDone
    
    cmp al, 0Dh
    je DisplayHangmanNewLine
    
    call WriteChar
    inc esi
    jmp DisplayHangmanLoop

DisplayHangmanNewLine:
    inc esi
    cmp byte ptr [esi], 0Ah
    jne DisplayHangmanContinue
    inc esi

    inc dh                ; move to next line
    mov dl, bh            ; reset column to original
    call Gotoxy
    jmp DisplayHangmanLoop

DisplayHangmanContinue:
    inc esi
    jmp DisplayHangmanLoop

DisplayHangmanDone:
    popad
    ret
DisplayHangmanAt ENDP


DisplayWordLines PROC
    mov eax, word_color
    call SetTextColor
    
    mov eax, center_row
    add eax, 3
    mov dh, al
    
    mov esi, OFFSET str_word
    call GetStringLength

    mov ebx, ecx
    mov eax, center_col
    sub eax, ebx
    mov word_start_col, eax
    mov dl, al
    call Gotoxy
    
    mov esi, OFFSET str_word
DisplayLoop:
    mov al, [esi]
    cmp al, 0
    je DoneDisplay
    mov al, '_'
    call WriteChar
    mov al, ' '
    call WriteChar
    inc esi
    jmp DisplayLoop
DoneDisplay:
    ret
DisplayWordLines ENDP

GameLoop PROC
GuessLoop:
    call GetPlayerInput
    call ProcessGuess
    call CheckGameStatus
    cmp al, 1
    je GameWon
    cmp al, 2
    je GameLost
    jmp GuessLoop

GameWon:
    call DisplayWinMessage
    jmp ExitGame

GameLost:
    call DisplayLoseMessage

ExitGame:
    ;call WaitForKey
    ret
GameLoop ENDP

GetPlayerInput PROC
GetInput:
    mov eax, center_row
    add eax, 5
    mov dh, al  
    mov eax, center_col
    sub eax, 20
    mov dl, al
    call Gotoxy
    
    mov ecx, 40
ClearArea:
    mov al, ' '
    call WriteChar
    loop ClearArea
    
    mov eax, prompt_color
    call SetTextColor
    mov ebx, center_row
    add ebx, 5
    mov edx, OFFSET prompt_msg
    call CenterTextAtRow
    
    call ReadChar
    
    ; Display the entered char next to the prompt
    call WriteChar
    
    cmp al, 'a'
    jb SkipConvert
    cmp al, 'z'
    ja SkipConvert
    sub al, 32
SkipConvert:
    cmp al, 'A'
    jb GetInput
    cmp al, 'Z'
    ja GetInput
    ret
GetPlayerInput ENDP

ProcessGuess PROC
    mov esi, OFFSET str_guess
    mov ecx, 26
CheckGuessed:
    cmp byte ptr [esi], 0
    je NotGuessed
    cmp [esi], al
    je AlreadyGuessed
    inc esi
    loop CheckGuessed
    
NotGuessed:
    mov esi, OFFSET str_guess
FindEmpty:
    cmp byte ptr [esi], 0
    je FoundEmpty
    inc esi
    jmp FindEmpty
FoundEmpty:
    mov [esi], al
    
    mov esi, OFFSET str_word
    mov ebx, 0
    mov ecx, 0
CheckWord:
    mov dl, [esi]
    cmp dl, 0
    je CheckDone
    cmp dl, al
    jne NotMatch
    mov ebx, 1
    push eax
    push ecx
    call RevealLetter
    pop ecx
    pop eax
NotMatch:
    inc esi
    inc ecx
    jmp CheckWord
    
CheckDone:
    mov eax, center_row
    add eax, 7
    mov dh, al
    call ClearMessageLine
    
    cmp ebx, 1
    je CorrectGuess
    
    inc mistakes
    call DisplayHangman
    call DisplayAttempts
    mov eax, wrong_color
    call SetTextColor
    mov ebx, center_row
    add ebx, 7
    mov edx, OFFSET wrong_msg
    call CenterTextAtRow
    
    mov eax, 500
    call Delay
    
    mov eax, center_row
    add eax, 7
    mov dh, al
    call ClearMessageLine
    
    mov ecx, -1
    call RevealLetter
    ret
    
CorrectGuess:
    mov eax, correct_color
    call SetTextColor
    mov ebx, center_row
    add ebx, 7
    mov edx, OFFSET correct_msg
    call CenterTextAtRow
    
    mov eax, 500
    call Delay
    
    mov eax, center_row
    add eax, 7
    mov dh, al
    call ClearMessageLine
    
    mov ecx, -1
    call RevealLetter
    ret
    
AlreadyGuessed:
    mov eax, already_color
    call SetTextColor
    mov ebx, center_row
    add ebx, 7
    mov edx, OFFSET already_guessed
    call CenterTextAtRow
    
    mov eax, 500
    call Delay
    
    mov eax, center_row
    add eax, 7
    mov dh, al
    call ClearMessageLine
    
    mov ecx, -1
    call RevealLetter
    mov al, 0
    ret
ProcessGuess ENDP

RevealLetter PROC
    pushad
    
    cmp ecx, -1
    je RedrawAll
    
    mov eax, ecx
    shl eax, 1
    mov ebx, word_start_col
    add ebx, eax
    mov dl, bl
    mov eax, center_row
    add eax, 3
    mov dh, al
    call Gotoxy

    mov esi, OFFSET str_word
    add esi, ecx
    mov al, [esi]
    mov eax, word_color
    call SetTextColor
    call WriteChar

    inc success_guess_counter
    jmp DoneReveal
    
RedrawAll:
    mov eax, word_color
    call SetTextColor
    mov esi, OFFSET str_word
    mov ecx, 0
    
RedrawLoop:
    mov al, [esi]
    cmp al, 0
    je DoneReveal
    push esi
    mov edi, OFFSET str_guess
    mov bl, al
CheckIfGuessed:
    mov dl, [edi]
    cmp dl, 0
    je NotGuessedYet
    cmp dl, bl
    je FoundGuessed
    inc edi
    jmp CheckIfGuessed
    
FoundGuessed:
    mov eax, ecx
    shl eax, 1
    mov ebx, word_start_col
    add ebx, eax
    mov dl, bl
    mov eax, center_row
    add eax, 3
    mov dh, al
    call Gotoxy
    mov al, [esi]
    call WriteChar
    
NotGuessedYet:
    pop esi
    inc esi
    inc ecx
    jmp RedrawLoop
    
DoneReveal:
    popad
    ret
RevealLetter ENDP

CheckGameStatus PROC
    mov esi, OFFSET str_word
    call GetStringLength

    mov al, success_guess_counter
    cmp al, cl
    jge Won
    cmp mistakes, 6
    jge Lost
    mov al, 0
    ret
Won:
    mov al, 1
    ret
Lost:
    mov al, 2
    ret
CheckGameStatus ENDP

DisplayWinMessage PROC
    mov eax, win_color
    call SetTextColor
    call GetLowerMidRow
    mov ebx, eax
    mov edx, OFFSET msg_won
    call CenterTextAtRow
    ret
DisplayWinMessage ENDP

DisplayLoseMessage PROC
    mov eax, lose_color
    call SetTextColor
    call GetLowerMidRow
    mov ebx, eax
    mov edx, OFFSET msg_lost
    call CenterTextAtRow
    
    mov esi, OFFSET str_word
    call GetStringLength
    
    ; Calculate row for "The word was:" message (middle of lower half + 1)
    call GetLowerMidRow
    mov dh, al
    inc dh
    mov eax, center_col
    mov ebx, LENGTHOF str_word_msg
    add ebx, ecx
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET str_word_msg
    call WriteString
    mov edx, OFFSET str_word
    call WriteString
    ret
DisplayLoseMessage ENDP

WaitForKey PROC
    mov eax, prompt_color
    call SetTextColor
    call GetLowerMidRow
    add eax, 3  ; Below win/lose messages
    mov ebx, eax
    mov edx, OFFSET msg_restart
    call CenterTextAtRow
    mov eax, 800
    call Delay
    call ReadChar
    ; Return the key in AL for the caller to check
    ret
WaitForKey ENDP

END
    
