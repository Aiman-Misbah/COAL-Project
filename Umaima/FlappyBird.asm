; =============================
; FLAPPY BIRD (Dynamic Screen)
; Author: 24K-0501
; =============================

INCLUDE Irvine32.inc

.data
; ==================== GAME VARIABLES ====================
birdX DWORD ?
birdY DWORD ?
pipeX DWORD ?
gapTop DWORD ?
gapHeight DWORD 8
score DWORD 0
gameOver DWORD 0
gamePaused DWORD 0        ; NEW: Pause state variable
pipeScored DWORD 0   ; 0 = not yet scored, 1 = already scored


; Bird characters
birdLine1 BYTE " (>", 0
birdLine2 BYTE " ) ", 0

; Game elements
pipeChar BYTE 0DBh, 0
groundChar BYTE 0CDh, 0

; Messages
scoreMsg BYTE "Score: ",0
gameOverMsg BYTE "GAME OVER! Press any key to continue...",0
instructions BYTE "Press UP ARROW to flap",0
pauseMsg BYTE "GAME PAUSED! Press 'R' to resume", 0

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

.code

; ==================== MAIN PROCEDURE ====================
FlappyBird PROC
    call InitializeScreen
    call ResetGame
    call Clrscr
    
    ; Countdown before game starts
    call ShowCountdown

gameLoop:
    ; Delay between frames
    mov eax, 80
    call Delay

    ; Read key (non-blocking)
    call ReadKey
    jz NoInput

    ; ESC to quit
    cmp al, 1Bh
    je QuitGame

    ; Pause handling
    cmp al, 'p'
    je DoPause
    cmp al, 'P'
    je DoPause

    ; Flap (UP arrow)
    cmp ax, 4800h
    je Flap

NoInput:
    ; Apply gravity, collisions, etc.
    call ApplyGravityToBird
    call CheckCollision
    mov eax, gameOver
    cmp eax, 1
    je GameOverScreen

    call MovePipesLeft
    call CheckPipeReset
    call CheckScore
    mov eax, 10
    call Delay

    call DrawGame
    jmp gameLoop

Flap:
    call HandleFlap
    jmp NoInput

; ---------------- PAUSE ----------------
DoPause:
    mov gamePaused, 1
    call DrawGame  ; Show pause message
    
PauseLoop:
    mov eax, 50
    call Delay
    call ReadKey
    cmp al, 'r'
    je UnpauseGame
    cmp al, 'R'
    je UnpauseGame
    jmp PauseLoop

UnpauseGame:
    mov gamePaused, 0
    ; Show countdown after unpause
    call ShowCountdown
    jmp gameLoop

GameOverScreen:
    call DrawGameOver

QuitGame:
    ret
FlappyBird ENDP

; ==================== FANCY COUNTDOWN PROCEDURE ====================

; ==================== COUNTDOWN DISPLAY ====================
ShowCountdown PROC
    pushad

    ; --- READY? ---
    mov ecx, 1                ; blink twice
ReadyBlink:
    push ecx
    call DrawGame
    mov eax, playableBottom
    add eax, 2                ; 2 lines below ground
    mov dh, al
    mov eax, screenWidth
    shr eax, 1
    sub eax, 3
    mov dl, al
    call Gotoxy
    mov edx, OFFSET readyMsg
    call WriteString
    mov eax, 300
    call Delay

    ; Clear line (overwrite with spaces)
    mov dh, al
    mov eax, screenWidth
    shr eax, 1
    sub eax, 3
    mov dl, al
    mov ecx, 6
ClearReady:
    mov al, ' '
    call WriteChar
    loop ClearReady

    mov eax, 250
    call Delay
    pop ecx
    loop ReadyBlink

    ; Show READY? steady
    call DrawGame
    mov eax, playableBottom
    add eax, 2
    mov dh, al
    mov eax, screenWidth
    shr eax, 1
    sub eax, 3
    mov dl, al
    call Gotoxy
    mov edx, OFFSET readyMsg
    call WriteString
    mov eax, 600
    call Delay


    ; --- COUNTDOWN: 3 ---
    call DrawGame
    mov eax, playableBottom
    add eax, 2
    mov dh, al
    mov eax, screenWidth
    shr eax, 1
    mov dl, al
    call Gotoxy
    mov edx, OFFSET countdown3
    call WriteString
    mov eax, 600
    call Delay

    ; --- COUNTDOWN: 2 ---
    call DrawGame
    mov eax, playableBottom
    add eax, 2
    mov dh, al
    mov eax, screenWidth
    shr eax, 1
    mov dl, al
    call Gotoxy
    mov edx, OFFSET countdown2
    call WriteString
    mov eax, 600
    call Delay

    ; --- COUNTDOWN: 1 ---
    call DrawGame
    mov eax, playableBottom
    add eax, 2
    mov dh, al
    mov eax, screenWidth
    shr eax, 1
    mov dl, al
    call Gotoxy
    mov edx, OFFSET countdown1
    call WriteString
    mov eax, 600
    call Delay

    ; --- GO! ---
    call DrawGame
    mov eax, playableBottom
    add eax, 2
    mov dh, al
    mov eax, screenWidth
    shr eax, 1
    sub eax, 1
    mov dl, al
    call Gotoxy
    mov edx, OFFSET goMsg
    call WriteString
    mov eax, 600
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

    ret
InitializeScreen ENDP


; ==================== GAME SETUP ====================
ResetGame PROC
    mov gameOver, 0
    mov gamePaused, 0     ; NEW: Reset pause state
    mov score, 0
    ; Bird horizontal position = 30% screen width
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

    ; Pipe horizontal position = right edge - 5
    mov eax, screenWidth
    sub eax, 5
    mov pipeX, eax

    call RandomizeGapPosition
    ret
ResetGame ENDP

RandomizeGapPosition PROC
    mov eax, playableBottom
    sub eax, playableTop
    sub eax, 10
    call RandomRange
    add eax, playableTop

    ; Ensure gap is at least 3 rows away from birdY
    cmp eax, birdY
    jl okGap
    add eax, 3
okGap:
    mov gapTop, eax
    ret
RandomizeGapPosition ENDP

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
    dec pipeX
    ret
MovePipesLeft ENDP

CheckPipeReset PROC
    mov eax, pipeX
    cmp eax, 0
    jg NoReset

    mov eax, screenWidth
    sub eax, 5
    mov pipeX, eax

    ; Reset score flag for the new pipe
    mov pipeScored, 0

    call RandomizeGapPosition
NoReset:
    ret
CheckPipeReset ENDP

CheckScore PROC
    ; Check if bird has passed the pipe AND pipe has not been scored yet
    mov eax, birdX
    mov ebx, pipeX
    add ebx, pipeWidth        ; pipe right edge
    cmp eax, ebx
    jl NotPassed              ; bird hasn't passed yet

    mov eax, pipeScored
    cmp eax, 1
    je NotPassed              ; already scored

    ; Increment score
    inc score
    mov pipeScored, 1

NotPassed:
    ret
CheckScore ENDP




; ==================== COLLISION ====================
CheckCollision PROC
    call CheckGroundCollision
    call CheckPipeCollision
    ret
CheckCollision ENDP

CheckGroundCollision PROC
    mov eax, birdY
    add eax, 2
    cmp eax, playableBottom
    jl NoGround
    mov gameOver, 1
NoGround:
    ret
CheckGroundCollision ENDP

CheckPipeCollision PROC
    ; Check if birdX is within pipeX .. pipeX+pipeWidth-1
    mov eax, birdX
    add eax, 3
    mov ebx, pipeX
    cmp eax, ebx
    jl NoPipe        ; bird left of pipe, no collision
    
    mov eax, birdX
    mov ebx, pipeX
    add ebx, pipeWidth
    dec ebx
    cmp eax, ebx
    jge NoPipe       ; bird right of pipe, no collision

    mov eax, birdY
    dec eax
    cmp eax, gapTop
    jl Hit
    
    mov eax, birdY
    add eax, 3
    mov ebx, gapTop
    add ebx, gapHeight
    cmp eax, ebx
    jg Hit
    jmp NoPipe

Hit:
    mov gameOver, 1
NoPipe:
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
    
    ; Draw pause message if game is paused
    mov eax, gamePaused
    cmp eax, 1
    jne SkipPauseMessage
    call DrawPauseMessage
SkipPauseMessage:
    
    popad
    ret
DrawGame ENDP

; Procedure to draw pause message
DrawPauseMessage PROC
    mov eax, white + (black * 16)
    call SetTextColor
    
    ; Calculate position for pause message (below ground, centered)
    mov eax, playableBottom
    add eax, 2                    ; 2 rows below ground
    mov dh, al
    mov eax, screenWidth
    sub eax, 30                   ; Message length is about 30
    shr eax, 1                    ; Divide by 2 to center
    mov dl, al
    call Gotoxy
    
    mov edx, OFFSET pauseMsg
    call WriteString
    
    mov eax, white + (black * 16)
    call SetTextColor
    ret
DrawPauseMessage ENDP

DrawUI PROC
    ; Draw score
    mov dh, 0
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET scoreMsg
    call WriteString
    mov eax, score
    call WriteDec

    ; Draw instructions
    mov dh, 0
    mov dl, 45
    call Gotoxy
    mov edx, OFFSET instructions
    call WriteString

    ; Draw separator line below UI
    mov eax, playableTop
    dec eax
    mov dh, al
    mov dl, 0
    call Gotoxy
    mov ecx, screenWidth
    mov al, 0CDh           ; ═ line
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
    mov eax, white + (black * 16)
    call SetTextColor

    mov ecx, gapTop
    sub ecx, playableTop
    jle NoTopPipe
    mov eax, playableTop
    mov dh, al
DrawTopPipe:
    push ecx
    push edx
    call DrawSinglePipe
    pop edx
    inc dh
    pop ecx
    loop DrawTopPipe
NoTopPipe:

    mov eax, gapTop
    add eax, gapHeight
    mov ebx, playableBottom
    sub ebx, eax
    jle NoBottom
    mov dh, al
    mov ecx, ebx
DrawBottom:
    push ecx
    push edx
    call DrawSinglePipe
    pop edx
    inc dh
    pop ecx
    loop DrawBottom
NoBottom:
    ret
DrawPipes ENDP

DrawSinglePipe PROC
    mov eax, pipeX
    mov dl, al
    mov ecx, pipeWidth
DrawPipeSeg:
    push ecx
    push edx
    call Gotoxy
    mov edx, OFFSET pipeChar
    call WriteString
    pop edx
    inc dl
    pop ecx
    loop DrawPipeSeg
    ret
DrawSinglePipe ENDP

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
    call DrawGame

    mov dh, 10
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET gameOverMsg
    call WriteString

    mov dh, 12
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET scoreMsg
    call WriteString
    mov eax, score
    call WriteDec

loooping:
    call ReadChar
    jmp loooping
    ret
DrawGameOver ENDP

END
