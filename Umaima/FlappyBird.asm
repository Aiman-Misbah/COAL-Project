; =============================
; FLAPPY BIRD (Dynamic Screen)
; Author: 24K-0501
; =============================

INCLUDE Irvine32.inc

.data
; ==================== GAME VARIABLES ====================
birdX DWORD ?
birdY DWORD ?
gapHeight DWORD 8
score DWORD 0
gameOver DWORD 0
gameRestart DWORD 0

; Pipe management - now an array for multiple pipes
NUM_PIPES EQU 3
PIPE_SPACING DWORD ?  ; Distance between pipes

pipeX DWORD NUM_PIPES DUP(?)
gapTop DWORD NUM_PIPES DUP(?)
pipeScored DWORD NUM_PIPES DUP(0)   ; Scoring state for each pipe

; FLAPPY BIRD Block Art (using ASCII 219 for blocks)


blk EQU 219
spc EQU 32
trc EQU 187
tlc EQU 201
blc EQU 200
brc EQU 188
vl EQU 186
hl EQU 205


FLAPPY_ROW1_P1 BYTE blk,blk,blk,blk,blk,blk,blk,trc,   blk,blk,trc,spc,spc,spc,spc,spc,spc,	blk,blk,blk,blk,blk,trc,spc,		blk,blk,blk,blk,blk,blk,trc,spc,	blk,blk,blk,blk,blk,blk,trc,spc,0
FLAPPY_ROW1_P2 BYTE blk,blk,trc,spc,spc,spc,blk,blk,trc,0
FLAPPY_ROW2_P1 BYTE blk,blk,tlc,hl,hl,hl,hl,brc,       blk,blk,vl,spc,spc,spc,spc,spc,         blk,blk,tlc,hl,hl,blk,blk,trc,	blk,blk,tlc,hl,hl,blk,blk,trc,		blk,blk,tlc,hl,hl,blk,blk,trc,0
FLAPPY_ROW2_P2 BYTE spc,blk,blk,trc,spc,blk,blk,tlc,brc,0
FLAPPY_ROW3_P1 BYTE blk,blk,blk,blk,blk,trc,spc,spc,   blk,blk,vl,spc,spc,spc,spc,spc,         blk,blk,blk,blk,blk,blk,blk,vl,	blk,blk,blk,blk,blk,blk,tlc,brc,	blk,blk,blk,blk,blk,blk,tlc,brc,spc,0
FLAPPY_ROW3_P2 BYTE spc,blk,blk,blk,blk,tlc,brc,spc,0
FLAPPY_ROW4_P1 BYTE blk,blk,tlc,hl,hl,brc,spc,spc,     blk,blk,vl,spc,spc,spc,spc,spc,         blk,blk,tlc,hl,hl,blk,blk,vl,	blk,blk,tlc,hl,hl,hl,brc,spc,		blk,blk,tlc,hl,hl,hl,brc,spc,spc,spc,0
FLAPPY_ROW4_P2 BYTE spc,blk,blk,tlc,brc,spc,spc,0
FLAPPY_ROW5_P1 BYTE blk,blk,vl,spc,spc,spc,spc,spc,    blk,blk,blk,blk,blk,blk,blk,trc,        blk,blk,vl,spc,spc,blk,blk,vl,	blk,blk,vl,spc,spc,spc,spc,spc,		blk,blk,vl,spc,spc,spc,spc,spc,spc,spc,spc,0
FLAPPY_ROW5_P2 BYTE blk,blk,vl,spc,spc,spc,0
FLAPPY_ROW6_P1 BYTE blc,hl,brc,spc,spc,spc,spc,spc,    blc,hl,hl,hl,hl,hl,hl,brc,              blc,hl,brc,spc,spc,blc,hl,brc,	blc,hl,brc,spc,spc,spc,spc,spc,		blc,hl,brc,spc,spc,spc,spc,spc,spc,spc,0
FLAPPY_ROW6_P2 BYTE spc,blc,hl,brc,spc,spc,spc,0

BIRD_ROW1   BYTE spc,spc,spc,spc,blk,blk,blk,blk,blk,blk,trc,spc,	blk,blk,trc,	blk,blk,blk,blk,blk,blk,trc,spc,	blk,blk,blk,blk,blk,blk,trc,spc,spc,0
BIRD_ROW2   BYTE spc,spc,spc,spc,blk,blk,tlc,hl,hl,blk,blk,trc,		blk,blk,vl,		blk,blk,tlc,hl,hl,blk,blk,trc,		blk,blk,tlc,hl,hl,blk,blk,trc,spc,0
BIRD_ROW3   BYTE spc,spc,spc,spc,blk,blk,blk,blk,blk,blk,tlc,brc,	blk,blk,vl,		blk,blk,blk,blk,blk,blk,tlc,brc,	blk,blk,vl,spc,spc,spc,blk,blk,trc,0
BIRD_ROW4   BYTE spc,spc,spc,spc,blk,blk,tlc,hl,hl,blk,blk,trc,		blk,blk,vl,		blk,blk,tlc,hl,hl,blk,blk,trc,		blk,blk,vl,spc,spc,blk,blk,tlc,brc,0
BIRD_ROW5   BYTE spc,spc,spc,spc,blk,blk,blk,blk,blk,blk,tlc,brc,	blk,blk,vl,		blk,blk,vl,spc,spc,blk,blk,vl,		blk,blk,blk,blk,blk,blk,tlc,brc,spc,0
BIRD_ROW6   BYTE spc,spc,spc,spc,blc,hl,hl,hl,hl,hl,brc,spc, 		blc,hl,brc,		blc,hl,brc,spc,spc,blc,hl,brc,		blc,hl,hl,hl,hl,hl,brc,spc,spc,0




taglineMsg  BYTE "Tap, Flap, and Dodge - Can You Beat Gravity?",0
instruct1   BYTE "Press UP ARROW to flap your wings!",0
instruct2   BYTE "P  to pause   |   R  to resume   |   BACKSPACE to quit",0
instruct3   BYTE "Avoid those pipes... they really don't like you!",0
instruct4   BYTE "Stay calm. Stay steady. Stay flappy.",0
instruct5   BYTE "Press P to Start your flight!",0
instruct6   BYTE "Press BACKSPACE if you wish to return to the menu", 0

quitMsg BYTE "Returning to Menu ",0
startMsg BYTE "Starting Game ",0
restartMsg BYTE "Restarting Game ",0

; Confirmation messages
confirmQuitMsg BYTE "Are you sure you want to quit? (Y/N)",0
yesNoMsg BYTE "Press Y for Yes, N for No",0
resumingMsg BYTE "Resuming game ",0


centerCol   DWORD ?
centerRow   DWORD ?


; Bird characters
birdLine1 BYTE "(>", 0
birdLine2 BYTE ") ", 0

; Game elements
pipeChar BYTE 0DBh, 0



; Messages
scoreMsg BYTE "Score: ",0
gameOverMsg BYTE "GAME OVER!",0
instructions BYTE "--FLAPPY BIRD--",0
pauseMsg BYTE "GAME PAUSED! Press 'R' to resume or 'BACKSPACE' to quit", 0

replayMsg BYTE "Press R to replay or BACKSPACE to quit", 0


; Screen dimensions (set at runtime)
screenWidth DWORD ?
screenHeight DWORD ?
pipeWidth DWORD 2
playableTop DWORD 2
playableBottom DWORD ?

readyMsg BYTE "READY?",0
countdown3 BYTE "~3~",0
countdown2 BYTE "~2~",0  
countdown1 BYTE "~1~",0
goMsg BYTE "GO!",0

belowRow DWORD ?
belowCol DWORD ?


boxTop      DWORD ?
boxLeft     DWORD ?
boxWidth    DWORD ?
boxHeight   DWORD ?
boxRight    DWORD ?
boxBottom   DWORD ?


.code

; ==================== MAIN PROCEDURE ====================
FlappyBird PROC
    call InitializeScreen
    call ShowWelcomeScreen
    cmp gameRestart, 0
    je QuitGame
    call ResetGame
    call Clrscr
    call ShowCountdown

MainLoop:
    ; Delay between frames
    mov eax, 100
    call Delay

    ; Read key (non-blocking)
    call ReadKey
    jz NoInput

    ; BACKSPACE to quit
    cmp al, 08h
    je ConfirmQuit

    ; Pause handling
    cmp al, 'p'
    je DoPause
    cmp al, 'P'
    je DoPause

    ; Flap (UP arrow)
    cmp ax, 4800h
    je Flap

NoInput:
    call ApplyGravityToBird
    call CheckGroundCollision
    call CheckPipeCollision
    mov eax, gameOver
    cmp eax, 1
    je GameOverScreen

    call MovePipesLeft
    call CheckPipeReset
    call CheckScore

    call DrawGame
    jmp MainLoop

ConfirmQuit:
    call ShowQuitConfirmation
    cmp gameRestart, 0
    je QuitGame
    cmp gameRestart, 2    ; Check if we need to show countdown
    je ShowCountdownAndResume
    jmp MainLoop          ; User chose No, continue game

ShowCountdownAndResume:
    call Clrscr
    call ShowCountdown
    jmp MainLoop


Flap:
    call HandleFlap
    jmp NoInput

DoPause:
    call PauseGame           ; PauseGame will set gameRestart=0 if ESC pressed
    mov eax, gameRestart
    cmp eax, 0
    je QuitGame              ; if pause requested quit, behave like ESC in main loop
    jmp MainLoop


GameOverScreen:
    call DrawGameOver

WaitForReplayOrQuit:
    call ReadChar

    cmp al, 'r'
    je RestartAfterGameOver
    cmp al, 'R'
    je RestartAfterGameOver

    cmp al, 08h             ; BACKSPACE = ask for confirmation
    je AskQuitConfirmation

    jmp WaitForReplayOrQuit

AskQuitConfirmation:
    call ShowGameOverQuitConfirmation  ; handles Y/N inside itself

    mov eax, gameRestart
    cmp eax, 0
    je QuitGame             ; user confirmed quit

    cmp eax, 1
    je WaitForReplayOrQuit  ; user chose No, return to game-over screen

    jmp WaitForReplayOrQuit


RestartAfterGameOver:
     mov eax, boxTop
    add eax, 10    ; Position below the replay message (row 8)
    mov dh, al
    mov eax, boxLeft
    add eax, boxRight
    shr eax, 1
    mov ebx, LENGTHOF restartMsg
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET restartMsg
    call WriteString
    call DotAnimation
    call ResetGame
    call Clrscr
    call ShowCountdown
    jmp MainLoop


QuitGame:
    ret
FlappyBird ENDP


PauseGame PROC
    pushad

    ; === Show pause message ===
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    mov ebx, LENGTHOF pauseMsg
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET pauseMsg
    call WriteString

    ; Default: assume resume unless ESC pressed
    mov gameRestart, 1

WaitResumeOrQuit:
    call ReadChar

    cmp al, 'r'           ; Resume?
    je ResumePause
    cmp al, 'R'
    je ResumePause

    cmp al, 08h           ; BACKSPACE = quit to menu
    je ConfirmQuitInPause

    jmp WaitResumeOrQuit

ConfirmQuitInPause:
    call ShowQuitConfirmation
    cmp gameRestart, 0
    je QuitToMenu
    cmp gameRestart, 2    ; Check if we need to show countdown
    je ShowCountdownFromPause
    ; If we get here, something went wrong - just resume
    call Clrscr
    call ShowCountdown
    popad
    ret

ShowCountdownFromPause:
    call Clrscr
    call ShowCountdown
    popad
    ret

; === Resume the game with countdown ===
ResumePause:
    call Clrscr
    call ShowCountdown
    popad
    ret

; === Quit game back to menu (set flag and return) ===
QuitToMenu:
    mov gameRestart, 0    ; tell caller: quit to menu
    popad
    ret
PauseGame ENDP

; message = OFFSET string, row = DH, col = DL
; will print message and animate 3 dots
DotAnimation PROC
    ; animate three dots
    mov ecx, 3
    mov eax, 300        ; 300ms delay
    call Delay
    
DotLoop:
    ; Write a dot character directly
    mov al, '.'         ; Use period character
    call WriteChar
    
    mov eax, 300        ; 300ms delay between dots
    call Delay
    
    loop DotLoop
    
    mov eax, 300        ; 300ms delay after last dot
    call Delay
    
    ret
DotAnimation ENDP

CenterText PROC
     ; Input: EBX = row, EDX = message offset
    ; Centers text AND writes it (all in one)
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
    mov edx, centerCol
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
CenterText ENDP

ShowWelcomeScreen PROC
    pushad
    call Clrscr

    ; ===== Set colors =====
    mov eax, yellow + (black * 16)
    call SetTextColor

    ; ===== Calculate screen center =====
    mov eax, screenWidth
    shr eax, 1
    mov centerCol, eax

    mov eax, playableTop
    add eax, playableBottom
    shr eax, 1
    mov centerRow, eax



    ; ==========================================================
    ;                   Display Fun Welcome Text
    ; ==========================================================

    ; --- Title ---
    ; --- Display FLAPPY ---
    mov dh, BYTE PTR centerRow
    sub dh, 8
    mov eax, centerCol
    mov ebx, LENGTHOF FLAPPY_ROW1_P1
    shr ebx, 1
    sub eax, 43  ; Half the width of FLAPPY text
    mov dl, al
    call Gotoxy
    mov edx, OFFSET FLAPPY_ROW1_P1
    call WriteString
    mov edx, OFFSET FLAPPY_ROW1_P2
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 7
    mov eax, centerCol
    sub eax, 43
    mov dl, al
    call Gotoxy
    mov edx, OFFSET FLAPPY_ROW2_P1
    call WriteString
    mov edx, OFFSET FLAPPY_ROW2_P2
    call WriteString



    mov dh, BYTE PTR centerRow
    sub dh, 6
    mov eax, centerCol
    sub eax, 43
    mov dl, al
    call Gotoxy
    mov edx, OFFSET FLAPPY_ROW3_P1
    call WriteString
    mov edx, OFFSET FLAPPY_ROW3_P2
    call WriteString


    mov dh, BYTE PTR centerRow
    sub dh, 5
    mov eax, centerCol
    sub eax, 43
    mov dl, al
    call Gotoxy
    mov edx, OFFSET FLAPPY_ROW4_P1
    call WriteString
    mov edx, OFFSET FLAPPY_ROW4_P2
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 4
    mov eax, centerCol
    sub eax, 43
    mov dl, al
    call Gotoxy
    mov edx, OFFSET FLAPPY_ROW5_P1
    call WriteString
    mov edx, OFFSET FLAPPY_ROW5_P2
    call WriteString


    mov dh, BYTE PTR centerRow
    sub dh, 3
    mov eax, centerCol
    sub eax, 43
    mov dl, al
    call Gotoxy
    mov edx, OFFSET FLAPPY_ROW6_P1
    call WriteString
    mov edx, OFFSET FLAPPY_ROW6_P2
    call WriteString

    ; --- Display BIRD ---
    mov dh, BYTE PTR centerRow
    sub dh, 8
    mov eax, centerCol
    add eax, 10  ; Position BIRD to the right of FLAPPY
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW1
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 7
    mov eax, centerCol
    add eax, 10
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW2
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 6
    mov eax, centerCol
    add eax, 10
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW3
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 5
    mov eax, centerCol
    add eax, 10
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW4
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 4
    mov eax, centerCol
    add eax, 10
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW5
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 3
    mov eax, centerCol
    add eax, 10
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW6
    call WriteString

       ; --- Tagline ---
    mov ebx, centerRow
    mov edx, OFFSET taglineMsg
    call CenterText


    ; --- Instructions ---
    mov ebx, centerRow
    add ebx, 4
    mov edx, OFFSET instruct1
    call CenterText

    inc ebx
    mov edx, OFFSET instruct2
    call CenterText

    inc ebx
    mov edx, OFFSET instruct3
    call CenterText

    inc ebx
    mov edx, OFFSET instruct4
    call CenterText

    add ebx, 2
    mov edx, OFFSET instruct5
    call CenterText

    inc ebx
    mov edx, OFFSET instruct6
    call CenterText

    ; ==========================================================
    ;                     Wait for User Input
    ; ==========================================================
WaitKey:
    call ReadChar
    cmp al, 'P'
    je StartGameAnim
    cmp al, 'p'
    je StartGameAnim
    cmp al, 8              ; Backspace
    je QuitToMenuAnim
    jmp WaitKey

; === Start game animation & delay ===
StartGameAnim:
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    mov dl, al
    sub dl, 10              ; adjust horizontal
    call Gotoxy
    mov edx, OFFSET startMsg    ; or "Starting Game"
    call WriteString
    call DotAnimation
    mov gameRestart, 1
    jmp Done

; === Quit to menu animation & delay ===
QuitToMenuAnim:
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    mov dl, al
    sub dl, 12              ; adjust horizontal
    call Gotoxy
    mov edx, OFFSET quitMsg   ; define: "Returning to Menu"
    call WriteString
    call DotAnimation
    mov gameRestart, 0
    jmp Done

Done:
    ; ===== Reset color before returning =====
    mov eax, white + (black * 16)
    call SetTextColor

    popad
    ret
ShowWelcomeScreen ENDP


; ==================== QUIT CONFIRMATION ====================
ShowQuitConfirmation PROC
    pushad
    
    ; Redraw the game to clear any messages
    call DrawGame
    
    ; Use the below area for messages (below ground)
        mov ebx, belowRow
    mov edx, OFFSET confirmQuitMsg
    call CenterText

    
    ; Second line for Yes/No instructions
    mov ebx, belowRow
    inc ebx
    mov edx, OFFSET yesNoMsg
    call CenterText


WaitConfirmation:
    call ReadChar
    
    cmp al, 'y'           ; Yes, quit
    je ConfirmYes
    cmp al, 'Y'
    je ConfirmYes
    
    cmp al, 'n'           ; No, don't quit
    je ConfirmNo
    cmp al, 'N'
    je ConfirmNo
    
    jmp WaitConfirmation

ConfirmYes:
    ; Show quitting animation in below area
    call DrawGame
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    mov ebx, LENGTHOF quitMsg
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET quitMsg
    call WriteString
    call DotAnimation
    
    mov gameRestart, 0    ; Signal to quit
    jmp DoneConfirmation

ConfirmNo:
    ; Show resuming message with animation
    call DrawGame  ; Clear the confirmation screen first
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    mov ebx, LENGTHOF resumingMsg
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET resumingMsg
    call WriteString
    call DotAnimation
    
    ; Set flag to indicate we need to show countdown
    mov gameRestart, 2    ; New flag value: 2 = show countdown then resume

DoneConfirmation:
    popad
    ret
ShowQuitConfirmation ENDP

; ==================== GAME OVER QUIT CONFIRMATION ====================
ShowGameOverQuitConfirmation PROC
    pushad
    
    ; Show confirmation message within game over screen (not in below area)
        mov ebx, boxTop
    add ebx, 9
    mov edx, OFFSET confirmQuitMsg
    call CenterText

    
    mov ebx, boxTop
    add ebx, 10
    mov edx, OFFSET yesNoMsg
    call CenterText




WaitConfirmation:
    call ReadChar
    
    cmp al, 'y'           ; Yes, quit
    je ConfirmYes
    cmp al, 'Y'
    je ConfirmYes
    
    cmp al, 'n'           ; No, don't quit
    je ConfirmNo
    cmp al, 'N'
    je ConfirmNo
    
    jmp WaitConfirmation

ConfirmYes:
    call DrawGameOver
    mov eax, boxTop
    add eax, 10
    mov dh, al
    mov eax, boxLeft
    add eax, boxRight
    shr eax, 1
    mov ebx, LENGTHOF quitMsg
    shr ebx, 1
    sub eax, ebx
    mov dl, al
    call Gotoxy
    mov edx, OFFSET quitMsg
    call WriteString
    call DotAnimation
    
    mov gameRestart, 0    ; Signal to quit
    jmp DoneConfirmation

ConfirmNo:
    ; For No, just redraw the game over screen (messages will be cleared by redraw)
    call DrawGameOver
    mov gameRestart, 1    ; Signal to continue

DoneConfirmation:
    popad
    ret
ShowGameOverQuitConfirmation ENDP

; ==================== COUNTDOWN DISPLAY ====================
ShowCountdown PROC
    pushad

    ; ===== READY? =====
    call DrawGame
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    sub eax, 3                  ; adjust for text width ("READY?")
    mov dl, al
    call Gotoxy
    mov edx, OFFSET readyMsg
    call WriteString
    mov eax, 1000
    call Delay

    ; ===== 3 =====
    call DrawGame
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    mov dl, al
    call Gotoxy
    mov edx, OFFSET countdown3
    call WriteString
    mov eax, 600
    call Delay

    ; ===== 2 =====
    call DrawGame
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    mov dl, al
    call Gotoxy
    mov edx, OFFSET countdown2
    call WriteString
    mov eax, 600
    call Delay

    ; ===== 1 =====
    call DrawGame
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    mov dl, al
    call Gotoxy
    mov edx, OFFSET countdown1
    call WriteString
    mov eax, 600
    call Delay

    ; ===== GO! =====
    call DrawGame
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    sub eax, 1
    mov dl, al
    call Gotoxy
    mov edx, OFFSET goMsg
    call WriteString
    mov eax, 700
    call Delay

    popad
    ret
ShowCountdown ENDP

; ==================== INITIALIZATION ====================
InitializeScreen PROC
    call GetMaxXY
    movzx eax, ax         ; rows (height)
    mov screenHeight, eax
    movzx edx, dx         ; columns (width)
    mov screenWidth, edx

    ; Set playableBottom = 80% of screen height
    mov eax, screenHeight
    mov edx, 0
    imul eax, 80
    mov ecx, 100
    div ecx
    mov playableBottom, eax

    ; ===== Calculate reusable center position (below ground) =====
    mov eax, screenHeight
    dec eax                     ; last visible row
    sub eax, playableBottom     ; height below ground
    shr eax, 1                  ; half = middle of area
    add eax, playableBottom
    add eax, 1
    mov belowRow, eax

    mov eax, screenWidth
    shr eax, 1
    mov belowCol, eax

        ; === Calculate pipe spacing dynamically (33% of screen width) ===
    mov eax, screenWidth
    mov edx, 0
    imul eax, 33
    mov ecx, 100
    div ecx
    mov PIPE_SPACING, eax



    ret
InitializeScreen ENDP


; ==================== GAME SETUP ====================
ResetGame PROC
    mov gameOver, 0
    mov score, 0

    ; Bird horizontal position = 30% screen width
    mov eax, screenWidth
    mov edx, 0
    imul eax, 25
    mov ecx, 100
    div ecx             ; (MASM-friendly: div expects ecx in some assemblers; if your assembler needs different pattern, keep original)
    ; If your assembler doesn't support div with ecx like that, keep your original arithmetic.
    ; For safety: we'll use classic approach:
    mov eax, screenWidth
    mov edx, 0
    imul eax, 25
    mov ecx, 100
    div ecx
    mov birdX, eax

    ; Bird vertical position = 50% of playable area
    mov eax, playableBottom
    sub eax, playableTop
    shr eax, 1
    add eax, playableTop
    mov birdY, eax

    ; Initialize pipes: set X positions spaced by PIPE_SPACING, set gaps and scored flags
    mov ecx, NUM_PIPES
    xor esi, esi             ; index = 0

InitPipeLoop:
    ; pipeX[esi] = 50% screen width + spacing * index
    mov eax, screenWidth
    shr eax, 1        ; divide by 2 -> 50%
    mov ebx, esi
    imul ebx, PIPE_SPACING
    add eax, ebx
    mov [pipeX + esi*4], eax


    ; random gapTop for this pipe
    push esi                 ; preserve index if RandomRange uses registers (optional)
    call RandomRangeGapForReset
    pop esi
    mov [gapTop + esi*4], eax

    ; reset scored flag
    mov DWORD PTR [pipeScored + esi*4], 0

    inc esi
    loop InitPipeLoop

    ret
ResetGame ENDP

; helper that returns gap top in EAX (uses playableTop/playableBottom)
RandomRangeGapForReset PROC
    mov eax, playableBottom
    sub eax, playableTop
    sub eax, 10
    call RandomRange
    add eax, playableTop
    ; ensure minimum distance from bird if needed (optional)
    cmp eax, birdY
    jl ok
    add eax, 3

ok:
    ret
RandomRangeGapForReset ENDP

; ==================== BIRD PHYSICS ====================
HandleFlap PROC
    sub birdY, 2               ; flap up
    mov eax, playableTop
    cmp birdY, eax      ; check ceiling
    jl SetToTop
    jmp DoneFlap
SetToTop:
    mov birdY, eax      ; clamp to ceiling
    dec birdY
DoneFlap:

    ret
HandleFlap ENDP

ApplyGravityToBird PROC
    add birdY, 1
    mov eax, playableBottom
    cmp birdY, eax
    jle DoneGravity
    mov birdY, eax
DoneGravity:
    
    ret
ApplyGravityToBird ENDP

; ==================== PIPE MANAGEMENT ====================
MovePipesLeft PROC
    mov ecx, NUM_PIPES
    mov esi, OFFSET pipeX
MovePipesLeft_Loop:
    dec DWORD PTR [esi]
    add esi, 4
    loop MovePipesLeft_Loop
    ret
MovePipesLeft ENDP

CheckPipeReset PROC
    mov ecx, NUM_PIPES
    xor esi, esi

PipeResetLoop:
    mov eax, [pipeX + esi*4]
    cmp eax, 0
    jg NextPipeNoReset

    ; Find rightmost pipe X to position this one after it
    ; We'll scan array to find max X
    mov edi, 0
    xor ebx, ebx            ; ebx will hold max
    mov edx, 0
    mov edx, NUM_PIPES
    dec edx
FindRightmost:
    mov eax, [pipeX + edx*4]
    cmp eax, ebx
    jle NotGreater
    mov ebx, eax
NotGreater:
    dec edx
    jns FindRightmost

    ; ebx = rightmost pipe X
    add ebx, PIPE_SPACING
    mov [pipeX + esi*4], ebx

    ; reset scored flag
    mov DWORD PTR [pipeScored + esi*4], 0

    ; new gap
    push esi
    call RandomRangeGapForReset
    pop esi
    mov [gapTop + esi*4], eax

NextPipeNoReset:
    inc esi
    loop PipeResetLoop
    ret
CheckPipeReset ENDP



CheckScore PROC
    mov ecx, NUM_PIPES
    xor esi, esi

ScoreLoop:
    mov eax, birdX
    mov ebx, [pipeX + esi*4]
    add ebx, pipeWidth
    cmp eax, ebx
    jl ScoreSkip

    mov eax, [pipeScored + esi*4]
    cmp eax, 1
    je ScoreSkip

    inc score
    mov DWORD PTR [pipeScored + esi*4], 1

ScoreSkip:
    inc esi
    loop ScoreLoop
    ret
CheckScore ENDP




; ==================== COLLISION ====================
CheckGroundCollision PROC
    mov eax, birdY
    add eax, 2
    cmp eax, playableBottom
    jle NoGround
    mov gameOver, 1
NoGround:
    ret
CheckGroundCollision ENDP

CheckPipeCollision PROC
    mov ecx, NUM_PIPES
    xor esi, esi

PipeCollisionLoop:
    ; ===== Horizontal check =====
    ; birdX+2 inside [pipeX, pipeX+pipeWidth-1] ?
    mov eax, birdX
    add eax, 2
    mov ebx, [pipeX + esi*4]
    cmp eax, ebx
    jl NextPipeNoCollision        ; bird left of pipe

    mov eax, birdX
    mov ebx, [pipeX + esi*4]
    add ebx, pipeWidth
    dec ebx
    cmp eax, ebx
    jge NextPipeNoCollision       ; bird right of pipe

    ; ===== Vertical check =====
    ; Special case: if gap starts at playableTop, allow ceiling flight
    mov eax, [gapTop + esi*4]
    cmp eax, playableTop
    je SkipTopCheck               ; skip top collision if gap touches ceiling

    ; normal top collision check
    mov eax, birdY
    mov ebx, [gapTop + esi*4]
    cmp eax, ebx
    jl HitPipe                    ; bird above gap ? hit

SkipTopCheck:
    ; bottom collision check
    mov eax, birdY
    add eax, 2                    ; bird’s bottom (bird height = 3)
    mov ebx, [gapTop + esi*4]
    add ebx, gapHeight
    cmp eax, ebx
    jge HitPipe                    ; bird below gap ? hit

NextPipeNoCollision:
    inc esi
    loop PipeCollisionLoop
    ret

HitPipe:
    mov gameOver, 1
    ret
CheckPipeCollision ENDP

; ==================== DRAWING ====================
DrawGame PROC
    pushad
    call Clrscr
    call DrawUI
    call DrawBird
    call DrawPipes
    call DrawGround
   
    popad
    ret
DrawGame ENDP



DrawUI PROC
    ; Draw score
    mov dh, 0
    mov dl, 2
    call Gotoxy
    mov edx, OFFSET scoreMsg
    call WriteString
    mov eax, score
    call WriteDec

    ; Draw instructions
    mov ebx, 0
    mov edx, OFFSET instructions
    call CenterText

    ; Draw separator line below UI
    mov eax, playableTop
    dec eax
    mov dh, al
    mov dl, 0
    call Gotoxy
    mov ecx, screenWidth
    mov al, 0CDh           ; ? line
DrawSeparator:
    call WriteChar
    loop DrawSeparator

    ret
DrawUI ENDP

DrawBird PROC
    mov eax, yellow + (black * 16)
    call SetTextColor

    mov eax, birdY
    mov dh, al
    mov eax, birdX
    mov dl, al
    call Gotoxy
    mov edx, OFFSET birdLine1
    call WriteString

    mov eax, birdY
    mov dh, al
    inc dh
    mov eax, birdX
    mov dl, al
    call Gotoxy
    mov edx, OFFSET birdLine2
    call WriteString

    mov eax, white + (black * 16)
    call SetTextColor
    ret
DrawBird ENDP

DrawPipes PROC
    pushad

    mov eax, white + (black * 16)
    call SetTextColor

    mov ecx, NUM_PIPES
    xor esi, esi

DrawPipes_Loop:
    mov eax, [pipeX + esi*4] 
    inc eax
    mov ebx, screenWidth
    cmp eax, ebx
    jge SkipThisPipe      ; skip if off screen right

    ; ===== Draw top section =====
    mov eax, playableTop
TopLoop:
    mov ebx, [gapTop + esi*4]
    cmp eax, ebx
    jge DoneTop
    push eax              ; save current row
    push esi
    mov dh, al            ; row
    mov dl, BYTE PTR [pipeX + esi*4]  ; column start
    call DrawSinglePipeSegment
    pop esi
    pop eax
    inc eax
    jmp TopLoop
DoneTop:

    ; ===== Draw bottom section =====
    mov eax, [gapTop + esi*4]
    add eax, gapHeight
BottomLoop:
    cmp eax, playableBottom
    jge SkipThisPipe
    push eax
    push esi
    mov dh, al
    mov dl, BYTE PTR [pipeX + esi*4]
    call DrawSinglePipeSegment
    pop esi
    pop eax
    inc eax
    jmp BottomLoop

SkipThisPipe:
    inc esi
    loop DrawPipes_Loop

    popad
    ret
DrawPipes ENDP


DrawSinglePipeSegment PROC
    pushad
    mov eax, [pipeX + esi*4]
    mov dl, al
    mov ecx, pipeWidth
DrawSinglePipeSeg_Loop:
    push ecx
    push edx
    call Gotoxy
    mov edx, OFFSET pipeChar
    call WriteString
    pop edx
    inc dl
    pop ecx
    loop DrawSinglePipeSeg_Loop
    popad
    ret
DrawSinglePipeSegment ENDP

DrawGround PROC
    mov eax, brown + (black * 16)
    call SetTextColor

    mov eax, playableBottom
    mov dh, al
    mov dl, 0
    call Gotoxy
    mov ecx, screenWidth
    mov al, '='
DrawGroundLine:
    call WriteChar
    loop DrawGroundLine

    mov eax, white + (black * 16)
    call SetTextColor
    ret
DrawGround ENDP


DrawGameOver PROC
    pushad

    ;=============================
    ;  Setup + Dimensions
    ;=============================
    mov eax, screenWidth
    mov ebx, 60
    imul eax, ebx
    cdq
    mov ebx, 100
    idiv ebx
    mov boxWidth, eax         ; 60% of screen width

    mov eax, screenHeight
    mov ebx, 40
    imul eax, ebx
    cdq
    mov ebx, 100
    idiv ebx
    mov boxHeight, eax        ; 40% of screen height

    ; calculate top-left corner
    mov eax, screenWidth
    sub eax, boxWidth
    shr eax, 1
    mov boxLeft, eax

    mov eax, screenHeight
    sub eax, boxHeight
    shr eax, 1
    mov boxTop, eax

    ; bottom/right edges
    mov eax, boxTop
    add eax, boxHeight
    mov boxBottom, eax
    mov eax, boxLeft
    add eax, boxWidth
    mov boxRight, eax

    ;=============================
    ;  Fill Box Background (black)
    ;=============================
    mov eax, black + (black * 16)
    call SetTextColor

    mov ecx, boxHeight
    ; sub ecx, 2                ; leave border rows alone
    mov dh, BYTE PTR boxTop
FillRowLoop:
        inc dh                ; move to next row (inside box)
        cmp dh, BYTE PTR boxBottom
        jge DoneFill
        mov dl, BYTE PTR boxLeft
        inc dl                ; inside box, skip left border
        mov ebx, boxWidth
        ; sub ebx, 2            ; skip right border
    FillColLoop:
        call Gotoxy
        mov al, ' '           ; space = black fill
        call WriteChar
        inc dl
        dec ebx
        jnz FillColLoop
        loop FillRowLoop
DoneFill:


    ; ===== Set border color =====
mov eax, white + (black * 16)
call SetTextColor

; --- Draw Top Border ---
mov dh, BYTE PTR boxTop
mov dl, BYTE PTR boxLeft
call Gotoxy
mov al, '='
call WriteChar

mov ecx, boxWidth
sub ecx, 2
TopLine:
    mov al, '='
    call WriteChar
    loop TopLine
mov al, '='
call WriteChar

; --- Draw Sides (clean double-bar look) ---
mov ecx, boxHeight
sub ecx, 1
mov dh, BYTE PTR boxTop
SideLoop:
    inc dh                        ; move down one row
    
    ; Left border
    mov dl, BYTE PTR boxLeft
    call Gotoxy
    mov al, '|'
    call WriteChar
    mov al, '|'
    call WriteChar

    ; Right border
    mov dl, BYTE PTR boxRight
    sub dl, 1                     ; shift slightly left to fit inside box
    call Gotoxy
    mov al, '|'
    call WriteChar
    mov al, '|'
    call WriteChar

    loop SideLoop


; --- Draw Bottom Border ---
mov dh, BYTE PTR boxBottom
mov dl, BYTE PTR boxLeft
call Gotoxy
mov al, '='
call WriteChar

mov ecx, boxWidth
sub ecx, 2
BottomLine:
    mov al, '='
    call WriteChar
    loop BottomLine
mov al, '='
call WriteChar


    ;=============================
    ;  Centered Text Inside Box
    ;=============================
    mov eax, yellow + (black * 16)
    call SetTextColor

    ; Calculate message start positions
        mov ebx, boxTop
    add ebx, 2
    mov edx, OFFSET gameOverMsg
    call CenterText

    ; For score, we need special handling since we write the number too
    mov ebx, boxTop
    add ebx, 5
    mov edx, OFFSET scoreMsg
    call CenterText
    mov eax, score
    call WriteDec

    mov ebx, boxTop
    add ebx, 7
    mov edx, OFFSET replayMsg
    call CenterText


    popad
    ret
DrawGameOver ENDP


END
