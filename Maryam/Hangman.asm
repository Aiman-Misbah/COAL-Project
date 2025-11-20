INCLUDE Irvine32.inc

.data
;all the characters used for drawing the hangman (double line)
spc EQU 32      ;space
trc EQU 187     ;top right corner
tlc EQU 201     ;top left corner
vl EQU 186      ;vertical line
hl EQU 205      ;horizontal line
t_up EQU 202    ;ulta T

screen_width DWORD ?    ;screen dimensions and center wali cheezein
screen_height DWORD ?
center_col DWORD ?
center_row DWORD ?
word_start_col DWORD ?  ;starting col for words (jo guess honge)

;each stage of hangman
hangman0 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,t_up,hl,hl,hl,hl,hl,hl,hl,0

hangman1 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,t_up,hl,hl,hl,hl,hl,hl,hl,0

hangman2 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,t_up,hl,hl,hl,hl,hl,hl,hl,0

hangman3 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/","|",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,t_up,hl,hl,hl,hl,hl,hl,hl,0

hangman4 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/","|","\",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,t_up,hl,hl,hl,hl,hl,hl,hl,0

hangman5 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/","|","\",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,t_up,hl,hl,hl,hl,hl,hl,hl,0

hangman6 BYTE spc,spc,tlc,hl,hl,hl,hl,hl,trc,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,vl,0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"O",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/","|","\",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,spc,"|",0dh,0ah
         BYTE spc,spc,vl,spc,spc,spc,spc,"/"," ","\",0dh,0ah
         BYTE spc,spc,vl,spc,0dh,0ah
         BYTE hl,hl,t_up,hl,hl,hl,hl,hl,hl,hl,0

hangman_stages DWORD hangman0, hangman1, hangman2, hangman3, hangman4, hangman5, hangman6

; Welcome screen title and msgs
welcome_title1 BYTE " _  _   __   __ _   ___  _  _   __   __ _ ",0
welcome_title2 BYTE "/ )( \ / _\ (  ( \ / __)( \/ ) / _\ (  ( \",0
welcome_title3 BYTE ") __ (/    \/    /( (_ \/ \/ \/    \/    /",0
welcome_title4 BYTE "\_)(_/\_/\_/\_)__) \___/\_)(_/\_/\_/\_)__)",0
welcome_msg1   BYTE "WELCOME, BRAVE GUESSER!",0
welcome_msg2   BYTE "Ready to save a virtual life?",0
welcome_msg3   BYTE "Guess the word before the stick figure meets its doom!",0
menu_option1   BYTE "[1] - PLAY GAME",0
menu_option2   BYTE "[2] - INSTRUCTIONS",0
menu_option3   BYTE "[3] - RETURN TO MAIN MENU",0

;instruction screen k msgs
instructions1  BYTE "=== HOW TO PLAY ===",0
instructions2  BYTE "1. Guess letters one at a time",0
instructions3  BYTE "2. Each wrong guess adds a body part to the hangman",0
instructions4  BYTE "3. 6 wrong guesses and... GAME OVER!",0
instructions5  BYTE "4. Guess all letters correctly to WIN!",0
press_key_msg  BYTE "Press BACKSPACE to go back",0

mistakes BYTE 0     ;counts number of incorrect guesses
success_guess_counter BYTE 0    ;correct guesses
str_guess BYTE 26 DUP(0)    ;all the letters that have been guessed

word1 BYTE "COMPUTER",0     ;word bank
word2 BYTE "PROGRAMMING",0
word3 BYTE "LANGUAGE",0
word4 BYTE "ASSEMBLY",0
word5 BYTE "PROCESSOR",0
word6 BYTE "MEMORY",0
word7 BYTE "KEYBOARD",0
word8 BYTE "SOFTWARE",0

word_list DWORD word1, word2, word3, word4, word5, word6, word7, word8
word_count = 8

str_word BYTE 20 DUP(0)     ;buffer to store currently selected word
str_word_msg BYTE "The word was: ",0    ;in case player guess na krpaaya then that word will be shown

last_word_index DWORD -1    ;taake same word consecutively na aajaye

;all the msgs
msg_restart     BYTE "Press [R] to Replay or [M] for Menu",0
msg_won         BYTE "CONGRATULATIONS! YOU WON!",0
msg_lost        BYTE "GAME OVER! YOU LOSE!",0
already_guessed BYTE "ALREADY GUESSED!",0
msg_top         BYTE "=== HANGMAN GAME ===",0
prompt_msg      BYTE "Enter your guess: ",0
wrong_msg       BYTE "Incorrect! Try again.",0
correct_msg     BYTE "Correct guess!",0
attempts_msg    BYTE "Lives remaining: ",0
hint_msg        BYTE "Hint: It is related to Computer Science",0

;all the colours beng used
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
    call InitializeScreenForSize    ;setting the dimensions and center wali cheezein
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

GetLowerMidRow PROC         ;ouput: eax = calculated row
    mov eax, center_row     
    add eax, screen_height
    shr eax, 1
    ret
GetLowerMidRow ENDP

CenterTextAtRow PROC
    ; Input: EBX = row, EDX = message offset
    pushad
    mov ecx, edx    ;saving bcoz edx will be modified
    
    call StrLength      ; length in eax
    shr eax, 1          ; half of length
    
    mov edx, center_col
    sub edx, eax
    mov dl, dl          ; column in dl
    mov dh, bl          ; row in dh
    
    call Gotoxy
    mov edx, ecx        ; restore message offset
    call WriteString
    
    popad
    ret
CenterTextAtRow ENDP

DisplayWelcomeScreen PROC
    mov eax, welcome_color  ;displaying the welcome title msgs and hangman
    call SetTextColor
    
    mov ebx, center_row
    sub ebx, 12
    mov edx, OFFSET welcome_title1
    call CenterTextAtRow    ;ebx mein row and edx mein msg offset
  
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


    mov esi, OFFSET hangman2
    call DisplayHangmanAt       ;esi mein offset and ebx mein row


HangmanDone:
    ret
DisplayWelcomeScreen ENDP

DisplayMenuOptions PROC
    mov eax, menu_color     ;displaying the options a bit to the right bcoz of the hangman
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
    call Clrscr                 ;Displaying instructions in the center and the prompt to go back thora sa to the right bcoz of the hangman
    mov eax, instructions_color
    call SetTextColor
    
    mov ebx, center_row
    sub ebx, 12
    mov edx, OFFSET instructions1
    call CenterTextAtRow        ;ebx mein row and edx mein offset

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

    mov esi, OFFSET hangman6
    call DisplayHangmanAt       ;esi mein offset and ebx mein row

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

WaitForBackspace:
    call ReadChar
    cmp al, 08h         ;backspace press check nhi to keep on waiting 
    jne WaitForBackspace

    mov eax, 800        ;hogya to go back
    call Delay
    ret
DisplayInstructions ENDP

PlayHangmanGame PROC
GameReplayLoop:
    call Clrscr
    call InitializeScreenForSize    ;setting size related things
    call InitializeGame         ;resetting game related things
    call GameLoop

WaitForChoice:       ;after game over wali cheez
    call WaitForKey  ;Returns choice in AL
    cmp al, 'R'
    je GameReplayLoop
    cmp al, 'r'
    je GameReplayLoop
    cmp al, 'M'
    je ReturnToMenu
    cmp al, 'm'
    je ReturnToMenu
    jmp WaitForChoice  ;Invalid key, wait again

ReturnToMenu:
    ret
PlayHangmanGame ENDP

InitializeScreenForSize PROC
    call GetMaxXY           ;calculating the dimensions and center wali cheezein
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

ClearMessageLine PROC   ;takes dh = row as input
    mov dl, 0
    call Gotoxy
    mov ecx, screen_width
ClearLoop:              ;poori ki poori row is cleared
    mov al, ' '
    call WriteChar
    loop ClearLoop
    ret
ClearMessageLine ENDP


InitializeGame PROC
    mov mistakes, 0
    mov success_guess_counter, 0
    
    mov ecx, 26             ;emptyting the string that holds already guessed letter for new game
    mov esi, OFFSET str_guess
    mov al, 0
ClearGuess:
    mov [esi], al
    inc esi
    loop ClearGuess
    
    call SelectRandomWord
    
    mov eax, title_color    ;displaying everything the title, attempts hangman and word blanks
    call SetTextColor
    mov ebx, 1
    mov edx, OFFSET msg_top
    call CenterTextAtRow    ;ebx mein row and edx mein offset
    
    call DisplayAttempts
    call DisplayHangman
    call DisplayWordLines
    ret
InitializeGame ENDP

DisplayAttempts PROC
    mov eax, attempts_color     ;setting colour and printing the msg for remaining attempts
    call SetTextColor
    mov ebx, 4
    mov edx, OFFSET attempts_msg
    call CenterTextAtRow
   
    movzx ebx, mistakes     ;calculating remaining lives and printing it 
    mov eax, 6
    sub eax, ebx
    call WriteDec

    mov eax, yellow + (black*16)
    call SetTextColor
    mov ebx, 6
    mov edx, OFFSET hint_msg
    call CenterTextAtRow
    ret
DisplayAttempts ENDP

SelectRandomWord PROC
    
TryAgain:
    call Randomize
    mov eax, word_count     ;any random valid index 
    call RandomRange
    cmp eax, last_word_index    ;if it is the same as the previous one choose another one
    je TryAgain
    
    mov last_word_index, eax    ;updating the last one used
    
    mov esi, eax        ;using it as index and multiplying by 4 bcoz of DWORD
    shl esi, 2
    mov esi, word_list[esi]
    mov edi, OFFSET str_word
    
CopyLoop:
    mov al, [esi]       ;storing it as the selected word
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne CopyLoop

    ret
SelectRandomWord ENDP

GetStringLength PROC
    ; Input: esi = string offset
    ; Output: ecx = length
    mov ecx, 0      ;counting number of letters in the word
CountLoop:
    cmp byte ptr [esi], 0
    je DoneCount
    inc ecx
    inc esi
    jmp CountLoop
DoneCount:
    ret
GetStringLength ENDP

DisplayHangman PROC
    movzx eax, mistakes     ;jitni mistakes uske hisaab se stage
    mov esi, hangman_stages[eax*4]
    mov eax, center_row     ;center se thora sa oopar and to the left
    sub eax, 7
    mov dh, al
    mov eax, center_col
    sub eax, 5
    mov dl, al
    
    mov eax, hangman_color
    call SetTextColor
    mov bl, dl          ;saving starting col taake baar baar na calculate krna pre
    call Gotoxy

DisplayHangmanLoop:
    mov al, [esi]
    cmp al, 0           ;poora hangman display krdia hai
    je DisplayHangmanDone
    cmp al, 0Dh             ;aik line hogyi (0D means carriage return)
    je DisplayHangmanNewLine
    call WriteChar          ;abhi nhi hui
    jmp DisplayHangmanContinue

DisplayHangmanNewLine:
    inc esi             ;skip the 0Dh
    cmp byte ptr [esi], 0Ah     ;if it is 0A skip it as well and print next wala char wrna abhi row complete nhi hui
    jne DisplayHangmanContinue
    inc esi
    inc dh
    mov dl, bl          ;resetting col to starting
    call Gotoxy
    jmp DisplayHangmanLoop

DisplayHangmanContinue:     ;continue printing the row
    inc esi
    jmp DisplayHangmanLoop

DisplayHangmanDone:     ;hogya
    ret
DisplayHangman ENDP

DisplayHangmanAt PROC   ;only for the welcome screen wale
    pushad      ; Input: ESI = offset of hangman stage, EBX = row to start drawing

    mov eax, hangman_color
    call SetTextColor

    mov eax, screen_width
    mov ebx, 3
    mov edx, 0
    div ebx               ;1/3rd of the screen width
    sub eax, 3            ;a little to the left
    mov dl, al

    mov eax, center_row
    mov dh, al
    call Gotoxy           ; Go to starting position
    mov bh, dl          ; saving starting column in BH for line resets

DisplayHangmanLoop:     ;same jo DisplayHangman mein hua tha wohi
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
    mov dl, bh            ; reset column to starting col
    call Gotoxy
    jmp DisplayHangmanLoop

DisplayHangmanContinue:
    inc esi
    jmp DisplayHangmanLoop

DisplayHangmanDone:
    popad
    ret
DisplayHangmanAt ENDP


DisplayWordLines PROC       ;jo bhi selected word hai uske dashes
    mov eax, word_color
    call SetTextColor
    
    mov eax, center_row     ;center se thora neeche
    add eax, 3
    mov dh, al
    
    mov esi, OFFSET str_word
    call GetStringLength    ;gives length in ecx - esi mein offset

    mov ebx, ecx
    mov eax, center_col     ;yahaan /2 krne ki zaroorat nhi bcoz already 2 times ziada hai bcoz of the spaces
    sub eax, ebx
    mov word_start_col, eax
    mov dl, al
    call Gotoxy
    
    mov esi, OFFSET str_word    ;ecx to set hai hi
DisplayLoop:        ;jitne letters utne blanks
    mov al, [esi]
    cmp al, 0
    je DoneDisplay
    mov al, '_'
    call WriteChar  ;aik col chor kr blank taake acha lage
    mov al, ' '
    call WriteChar
    inc esi
    jmp DisplayLoop
DoneDisplay:
    ret
DisplayWordLines ENDP

GameLoop PROC
GuessLoop:
    call GetPlayerInput     ;player ne konsa letter enter kia hai (upper case) in al
    call ProcessGuess       ;letter check and update wala saara kaam
    call CheckGameStatus    ;checking if the player has won or lost or not yet - output in al (1,2,0)
    cmp al, 1
    je GameWon      ;1 means won
    cmp al, 2
    je GameLost     ;2 means lost
    jmp GuessLoop

GameWon:
    call DisplayWinMessage      ;unke hisaab se msgs
    jmp ExitGame

GameLost:
    call DisplayLoseMessage

ExitGame:
    ret
GameLoop ENDP

GetPlayerInput PROC     ;ouput: eax = upper case letter (jo bhi player ne enter kia hai)
GetInput:
    mov eax, center_row
    add eax, 5
    mov dh, al              ;takes dh as input (for row)
    call ClearMessageLine       ;keeps on immediately clearing if invalid input
    
    mov eax, prompt_color       ;printing the prompt and the letter chosen
    call SetTextColor
    mov ebx, center_row
    add ebx, 5
    mov edx, OFFSET prompt_msg
    call CenterTextAtRow        ;ebx mein row and edx mein offset
    
    call ReadChar
    call WriteChar
    
    cmp al, 'a'
    jb SkipConvert
    cmp al, 'z'         ;if a lower case letter is entered convert it a upper case
    ja SkipConvert
    sub al, 32
SkipConvert:
    cmp al, 'A'     ;if not even that wait for input again
    jb GetInput
    cmp al, 'Z'
    ja GetInput
    ret
GetPlayerInput ENDP

ProcessGuess PROC
    mov esi, OFFSET str_guess   ;load the already guessed characters
    mov ecx, 26
CheckGuessed:
    cmp byte ptr [esi], 0   ;if it in empty then it hasn't been guessed technically
    je NotGuessed
    cmp [esi], al           ;al has the current letter from GetPlayerINput PROC
    je AlreadyGuessed       ;check if it is already guessed or not from the whole string 
    inc esi
    loop CheckGuessed
    
NotGuessed:
    mov [esi], al 
    mov esi, OFFSET str_word    ;now looping through the selected word for that letter
    mov ebx, 0               ;flag for found or not found
    mov ecx, 0

CheckWord:
    mov dl, [esi]
    cmp dl, 0       ;end of word reached
    je CheckDone
    cmp dl, al      ;if matched flag = 1
    jne NotMatch
    mov ebx, 1
    call RevealLetter   ;reveal that letter from the blank
NotMatch:               ;it takes ecx as input (letter found pos = ecx)
    inc esi
    inc ecx
    jmp CheckWord
    
CheckDone:
    cmp ebx, 1
    je CorrectGuess
    
    inc mistakes            ;ghalat guess kia
    call DisplayHangman     ;update konsa hangman display krna hai
    call DisplayAttempts    ;update remaining lives
    mov eax, wrong_color
    call SetTextColor
    mov ebx, center_row
    add ebx, 7
    mov edx, OFFSET wrong_msg   ;appropriate msg
    call CenterTextAtRow
    
    mov eax, 500            ;thora sa ruk kr erase that
    call Delay
    
    mov eax, center_row
    add eax, 7
    mov dh, al
    call ClearMessageLine   ;dh as inpur (row)
    
    ret
    
CorrectGuess:
    mov eax, correct_color      ;same here as well
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
    
    ret
    
AlreadyGuessed:                 ;and here too
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
    
    mov al, 0
    ret
ProcessGuess ENDP

RevealLetter PROC
    pushad      ;takes ecx mein input (which letter at which position found)

    mov eax, ecx
    shl eax, 1              ;bcoz of spaces
    mov ebx, word_start_col
    add ebx, eax            ;correct col on the screen
    mov dl, bl
    mov eax, center_row     ;center se thora neeche
    add eax, 3
    mov dh, al
    call Gotoxy

    mov eax, word_color
    call SetTextColor
    mov esi, OFFSET str_word
    add esi, ecx                ;letter pos 
    mov al, [esi]               ;jo letter correctly guess kia hai that is printed
    call WriteChar

    inc success_guess_counter   ;incrementing the no of correctly guessed letters

    popad
    ret
RevealLetter ENDP

CheckGameStatus PROC            ;output: al = 0(continue), 1(won), 2(lost)
    mov esi, OFFSET str_word
    call GetStringLength        ;comparing length and how many correctly guess krliye hain
                                ;length in ecx
    mov al, success_guess_counter
    cmp al, cl              
    jge Won             ;if equal won wrna comparing mistakes with total lives (checkign if lost)
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
    call GetLowerMidRow         ;getting center row of the lower half in eax
    mov ebx, eax
    mov edx, OFFSET msg_won
    call CenterTextAtRow        ;printing win msg
    ret
DisplayWinMessage ENDP

DisplayLoseMessage PROC
    mov eax, lose_color
    call SetTextColor
    call GetLowerMidRow         ;getting row in eax
    mov ebx, eax
    mov edx, OFFSET msg_lost    ;same with lost msg
    call CenterTextAtRow
    
    mov esi, OFFSET str_word    ;getting length of the word in ecx
    call GetStringLength
    
    call GetLowerMidRow
    mov dh, al
    inc dh                  ;printing the word msg in the row below lost msg with the word
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

WaitForKey PROC         ;ouput key in al (r/m - case insensitive)
    mov eax, prompt_color
    call SetTextColor
    call GetLowerMidRow      ;getting row in eax
    add eax, 3      ;Below win/lose messages
    mov ebx, eax
    mov edx, OFFSET msg_restart     ;r or m wala msg
    call CenterTextAtRow
    mov eax, 800
    call Delay
    call ReadChar
    ret
WaitForKey ENDP

END  
