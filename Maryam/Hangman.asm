INCLUDE Irvine32.inc

.data
; Hangman visual stages (larger ASCII art)

blk EQU 219
spc EQU 32
trc EQU 187
tlc EQU 201
blc EQU 200
brc EQU 188
vl EQU 186
hl EQU 205

blk EQU 219
spc EQU 32
trc EQU 187
tlc EQU 201
blc EQU 200
brc EQU 188
vl EQU 186
hl EQU 205

hangman0 BYTE spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,blc,hl,hl,hl,hl,hl,hl,0

hangman1 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,blc,hl,hl,hl,hl,hl,hl,0

hangman2 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,blc,hl,hl,hl,hl,hl,hl,0

hangman3 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/","|",0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,blc,hl,hl,hl,hl,hl,hl,0

hangman4 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,"/","|","\",0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,blc,hl,hl,hl,hl,hl,hl,0

hangman5 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,"/","|","\",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/",0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,blc,hl,hl,hl,hl,hl,hl,0

hangman6 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,"/","|","\",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,"/"," ","\",0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,blc,hl,hl,hl,hl,hl,hl,0
hangman_stages DWORD hangman0, hangman1, hangman2, hangman3, hangman4, hangman5, hangman6

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

str_word BYTE 20 DUP(0)  ; Buffer for current word

; Messages
msg_restart     BYTE "PRESS ANY KEY TO CONTINUE",0
msg_won         BYTE "CONGRATULATIONS! YOU WON!",0
msg_lost        BYTE "GAME OVER! YOU LOSE!",0
already_guessed BYTE "ALREADY GUESSED!",0
invalid_char    BYTE "INVALID CHARACTER!",0
msg_top         BYTE "=== HANGMAN GAME ===",0
prompt_msg      BYTE "Enter your guess: ",0
wrong_msg       BYTE "Incorrect! Try again.",0
correct_msg     BYTE "Correct guess!",0
attempts_msg    BYTE "Lives remaining: ",0

; Alphabet for validation
alphabet_validation BYTE "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
str_guess BYTE 26 DUP(0)

; Colors - More varied colors
title_color     DWORD lightcyan + (blue * 16)
hangman_color   DWORD white + (black * 16)
word_color      DWORD yellow + (black * 16)
prompt_color    DWORD lightgreen + (black * 16)
correct_color   DWORD lightgreen + (black * 16)
wrong_color     DWORD lightred + (black * 16)
win_color       DWORD lightmagenta + (black * 16)
lose_color      DWORD lightred + (black * 16)
attempts_color  DWORD lightblue + (black * 16)
already_color   DWORD brown + (black * 16)

.code
Hangman PROC
    call Clrscr
    call InitializeGame
    call GameLoop
    ret
Hangman ENDP

InitializeGame PROC
    mov mistakes, 0
    mov success_guess_counter, 0
    
    ; Initialize guessed letters
    mov ecx, 26
    mov esi, OFFSET str_guess
    mov al, 0
ClearGuess:
    mov [esi], al
    inc esi
    loop ClearGuess
    
    ; Select random word
    call SelectRandomWord
    
    ; Display game title - centered with color
    mov eax, title_color
    call SetTextColor
    mov dh, 1
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET msg_top
    call WriteString
    
    ; Display attempts counter
    call DisplayAttempts
    
    ; Display initial hangman - centered
    call DisplayHangman
    call DisplayWordLines
    ret
InitializeGame ENDP

DisplayAttempts PROC
    mov eax, attempts_color  ; Changed to blue
    call SetTextColor
    mov dh, 3
    mov dl, 32
    call Gotoxy
    mov edx, OFFSET attempts_msg
    call WriteString
    
    ; Calculate attempts left
    movzx eax, mistakes
    mov ebx, 6
    sub ebx, eax
    mov eax, ebx
    call WriteDec
    ret
DisplayAttempts ENDP

SelectRandomWord PROC
    ; Get random number between 0 and word_count-1
    mov eax, word_count
    call RandomRange
    
    ; Get pointer to selected word
    mov esi, eax
    shl esi, 2  ; Multiply by 4 (DWORD size)
    mov esi, word_list[esi]
    
    ; Copy word to str_word buffer
    mov edi, OFFSET str_word
CopyLoop:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne CopyLoop
    
    ret
SelectRandomWord ENDP

DisplayHangman PROC
    pushad

    mov eax, hangman_color
    call SetTextColor

    ; ========== Calculate start position ==========
    mov dh, 5            ; top row where hangman starts
    mov dl, 40           ; center X column (adjust 40 if needed)
    call Gotoxy

    ; ========== Get correct hangman stage ==========
    movzx eax, mistakes
    mov esi, hangman_stages[eax*4] ; pointer to stage string

NextChar:
    mov al, [esi]
    cmp al, 0
    je Done

    cmp al, 0Dh
    je NewLine
    call WriteChar
    jmp Continue

NewLine:
    ; Skip CR LF
    inc esi
    mov al, [esi]
    cmp al, 0Ah
    jne Continue
    inc esi

    ; Move to next row center
    inc dh
    mov dl, 40
    call Gotoxy
    jmp Continue

Continue:
    inc esi
    jmp NextChar

Done:
    popad
    ret
DisplayHangman ENDP


DisplayWordLines PROC
    mov eax, word_color
    call SetTextColor
    ; Center the word below the hangman with gap
    mov dh, 15  ; Increased gap from 14 to 15
    mov dl, 34
    call Gotoxy
    
    mov esi, OFFSET str_word
DisplayLoop:
    mov al, [esi]
    cmp al, 0
    je DoneDisplay
    cmp al, ' '
    je ShowSpace
    mov al, '_'
    call WriteChar
    mov al, ' '
    call WriteChar
    jmp NextChar
ShowSpace:
    mov al, ' '
    call WriteChar
    call WriteChar
NextChar:
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
    call WaitForKey
    ret
GameLoop ENDP

GetPlayerInput PROC
    ; Clear message area - centered below everything with gaps
    mov dh, 17  ; Increased gap from 16 to 17
    mov dl, 30
    call Gotoxy
    mov ecx, 40
ClearArea:
    mov al, ' '
    call WriteChar
    loop ClearArea
    
    ; Display prompt - centered below everything
    mov eax, prompt_color
    call SetTextColor
    mov dh, 17  ; Increased gap from 16 to 17
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET prompt_msg
    call WriteString
    
    call ReadChar
    call WriteChar
    call Crlf
    
    ; Convert to uppercase
    cmp al, 'a'
    jb NotLower
    cmp al, 'z'
    ja NotLower
    sub al, 32
NotLower:
    ret
GetPlayerInput ENDP

ProcessGuess PROC
    ; Check if already guessed
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
    ; Add to guessed letters
    mov esi, OFFSET str_guess
FindEmpty:
    cmp byte ptr [esi], 0
    je FoundEmpty
    inc esi
    jmp FindEmpty
FoundEmpty:
    mov [esi], al
    
    ; Check if letter is in word
    mov esi, OFFSET str_word
    mov ebx, 0 ; found flag
    mov ecx, 0 ; position counter
CheckWord:
    mov dl, [esi]
    cmp dl, 0
    je CheckDone
    cmp dl, al
    jne NotMatch
    mov ebx, 1 ; found
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
    ; Display message - centered below everything with gaps
    mov dh, 18  ; Increased gap from 17 to 18
    mov dl, 30
    call Gotoxy
    mov ecx, 40
ClearMsg:
    mov al, ' '
    call WriteChar
    loop ClearMsg
    
    mov dh, 18  ; Increased gap from 17 to 18
    mov dl, 30
    call Gotoxy
    
    cmp ebx, 1
    je CorrectGuess
    
    ; Wrong guess - update hangman visual and attempts
    inc mistakes
    call DisplayHangman  ; Update the visual
    call DisplayAttempts ; Update attempts counter
    mov eax, wrong_color
    call SetTextColor
    mov edx, OFFSET wrong_msg
    call WriteString
    ret

CorrectGuess:
    mov eax, correct_color
    call SetTextColor
    mov edx, OFFSET correct_msg
    call WriteString
    ret

AlreadyGuessed:
    mov eax, already_color  ; Changed to brown
    call SetTextColor
    mov dh, 18  ; Increased gap from 17 to 18
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET already_guessed
    call WriteString
    mov eax, 1000
    call Delay
    mov al, 0 ; Return invalid to retry
    ret
ProcessGuess ENDP

RevealLetter PROC
    ; ecx has position in word
    pushad
    
    ; Calculate screen position (centered)
    mov eax, ecx
    mov ebx, 2
    mul ebx
    add eax, 34  ; Centered starting point
    
    mov dl, al
    mov dh, 15 ; row (increased from 14 to 15)
    call Gotoxy
    
    ; Get the actual letter from str_word
    mov esi, OFFSET str_word
    add esi, ecx
    mov al, [esi]
    call WriteChar
    
    inc success_guess_counter
    popad
    ret
RevealLetter ENDP

CheckGameStatus PROC
    ; Check if won (all letters guessed)
    mov esi, OFFSET str_word
    mov ecx, 0
CountLetters:
    mov al, [esi]
    cmp al, 0
    je DoneCount
    cmp al, ' '
    je Skip
    inc ecx
Skip:
    inc esi
    jmp CountLetters
DoneCount:
    
    mov al, success_guess_counter
    cmp al, cl
    jge Won
    
    ; Check if lost
    cmp mistakes, 6
    jge Lost
    
    mov al, 0 ; Continue
    ret

Won:
    mov al, 1 ; Won
    ret

Lost:
    mov al, 2 ; Lost
    ret
CheckGameStatus ENDP

DisplayWinMessage PROC
    mov eax, win_color
    call SetTextColor
    ; Centered win message with gap
    mov dh, 20  ; Increased gap from 18 to 20
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET msg_won
    call WriteString
    ret
DisplayWinMessage ENDP

DisplayLoseMessage PROC
    mov eax, lose_color
    call SetTextColor
    ; Centered lose message with gap
    mov dh, 20  ; Increased gap from 18 to 20
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET msg_lost
    call WriteString
    
    ; Reveal the word - centered with gap
    mov dh, 21  ; Increased gap from 19 to 21
    mov dl, 32
    call Gotoxy
    mov edx, OFFSET str_word
    call WriteString
    ret
DisplayLoseMessage ENDP

WaitForKey PROC
    mov eax, prompt_color
    call SetTextColor
    ; Centered restart message with gap
    mov dh, 23  ; Increased gap from 21 to 23
    mov dl, 28
    call Gotoxy
    mov edx, OFFSET msg_restart
    call WriteString
    call ReadChar
    ret
WaitForKey ENDP

END
