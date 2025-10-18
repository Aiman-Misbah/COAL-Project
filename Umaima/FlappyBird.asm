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
gamePaused DWORD 0        ; NEW: Pause state variable
gameRestart DWORD 0

; Pipe management - now an array for multiple pipes
NUM_PIPES EQU 3
PIPE_SPACING DWORD ?  ; Distance between pipes

pipeX DWORD NUM_PIPES DUP(?)
gapTop DWORD NUM_PIPES DUP(?)
pipeScored DWORD NUM_PIPES DUP(0)   ; Scoring state for each pipe

; Bird characters
birdLine1 BYTE "(>", 0
birdLine2 BYTE ") ", 0

; Game elements
pipeChar BYTE 0DBh, 0
groundChar BYTE 0CDh, 0

; Messages
scoreMsg BYTE "Score: ",0
gameOverMsg BYTE "GAME OVER!",0
instructions BYTE "Press UP ARROW to flap",0
pauseMsg BYTE "GAME PAUSED! Press 'R' to resume", 0

replayMsg BYTE "Press R to replay or ESC to quit", 0


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


.code

; ==================== MAIN PROCEDURE ====================
FlappyBird PROC
    call InitializeScreen
    call ResetGame
    call Clrscr
    call ShowCountdown

MainLoop:
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
    mov eax, gameRestart
    cmp eax, 1
    jne QuitGame
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
    sub eax, 18
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

    cmp al, 1Bh           ; ESC = quit to menu
    je QuitToMenu

    jmp WaitResumeOrQuit

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
    mov eax, 800
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
    xor esi, esi
MovePipesLeft_Loop:
    dec DWORD PTR [pipeX + esi*4]
    inc esi
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
    mov ecx, NUM_PIPES
    xor esi, esi

PipeCollisionLoop:
    ; horizontal check: birdX+2 inside [pipeX, pipeX+pipeWidth-1] ?
    mov eax, birdX
    add eax, 2
    mov ebx, [pipeX + esi*4]
    cmp eax, ebx
    jl NextPipeNoCollision

    mov eax, birdX
    mov ebx, [pipeX + esi*4]
    add ebx, pipeWidth
    dec ebx
    cmp eax, ebx
    jge NextPipeNoCollision

    ; vertical check using gapTop[esi]
    mov eax, birdY
    mov ebx, [gapTop + esi*4]
    cmp eax, ebx
    jle HitPipe

    mov eax, birdY
    add eax, 2
    mov ebx, [gapTop + esi*4]
    add ebx, gapHeight
    cmp eax, ebx
    jge HitPipe

    jmp NextPipeNoCollision

HitPipe:
    mov gameOver, 1
    ret

NextPipeNoCollision:
    inc esi
    loop PipeCollisionLoop
    ret
CheckPipeCollision ENDP

; ==================== DRAWING ====================
DrawGame PROC
    pushad

    mov eax, gamePaused
    cmp eax, 1
    je SkipClear
    call Clrscr
SkipClear:

    call DrawUI
    call DrawBird
    call DrawPipes
    call DrawGround
    
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
    pushad
    mov eax, belowRow
    mov dh, al
    mov eax, belowCol
    sub eax, 18      ; adjust horizontally for text width
    mov dl, al
    call Gotoxy
    mov edx, OFFSET pauseMsg
    call WriteString
    popad
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
    
    call DrawGame

    ; --- Game over message ---
    mov dh, 10
    mov dl, 25
    call Gotoxy
    mov edx, OFFSET gameOverMsg
    call WriteString

    ; --- Show score ---
    mov dh, 12
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET scoreMsg
    call WriteString
    mov eax, score
    call WriteDec

    ; --- Replay / Quit instructions ---
    mov dh, 14
    mov dl, 20
    call Gotoxy
    mov edx, OFFSET replayMsg
    call WriteString

WaitKeyForRestart:
    call ReadChar
    cmp al, 'r'              ; Restart?
    je RestartGame
    cmp al, 'R'
    je RestartGame
  
    cmp al, 1Bh              ; ESC?
    je QuitGame
    jmp WaitKeyForRestart    ; Ignore anything else

RestartGame:
    mov gameRestart, 1
    ret

QuitGame:
    mov gameRestart, 0
    ret
DrawGameOver ENDP

END
