INCLUDE Irvine32.inc

.data
; Game variables - now scaled based on screen size
birdY DWORD ?
birdX DWORD ?
gravity DWORD 1
flapStrength DWORD 2
gameOver BYTE 0
score DWORD 0
frameCount BYTE 0
gamePaused BYTE 0
needsRedraw BYTE 1  ; New flag to track when screen needs redrawing

; Pipe variables - now scaled based on screen size
pipe1X DWORD ?
pipe1GapY DWORD ?
pipe2X DWORD ?
pipe2GapY DWORD ?

; Track which pipes have been scored
pipe1Scored BYTE 0
pipe2Scored BYTE 0

; FIX 1: Complete bird characters
birdTop BYTE '(', 0
birdMiddle BYTE '>', 0
birdBottom BYTE ')', 0

pipeChar BYTE 0DBh, 0
groundChar BYTE 0CDh, 0

; Messages
scoreMsg BYTE "Score: ", 0
gameOverMsg BYTE "GAME OVER! Press any key to return to menu", 0
instructions BYTE "Press UP ARROW to flap, P to pause", 0
pauseMsg BYTE "GAME PAUSED - Press R to resume", 0

; Screen dimensions and scaling
screenWidth DWORD ?
screenHeight DWORD ?

; Constants for message area
MSG_AREA_HEIGHT = 2  ; Reserve 2 rows for messages at the top

.code

FlappyBird PROC
    call ResetFlappyBird
    call FlappyBird_GameLoop
    ret
FlappyBird ENDP

ResetFlappyBird PROC
    ; Get screen dimensions first
    call GetMaxXY
    movzx eax, dl
    mov screenWidth, eax
    movzx eax, dh
    mov screenHeight, eax
    
    ; Ensure minimum screen size to avoid division issues
    cmp screenWidth, 60
    jae WidthOK
    mov screenWidth, 60
WidthOK:
    cmp screenHeight, 24
    jae HeightOK
    mov screenHeight, 24
HeightOK:

    ; SIMPLE SCALING: Use percentages instead of division
    ; Bird starts at 20% of screen width, 50% of playable area height
    mov eax, screenWidth
    mov ebx, 20
    mul ebx
    mov ebx, 100
    div ebx
    mov birdX, eax
    
    ; Adjust bird Y for message area - start in middle of playable area
    mov eax, screenHeight
    sub eax, MSG_AREA_HEIGHT  ; Subtract message area
    mov ebx, 50
    mul ebx
    mov ebx, 100
    div ebx
    add eax, MSG_AREA_HEIGHT  ; Add message area offset
    mov birdY, eax
    
    ; Pipes start at 40% and 80% of screen width
    mov eax, screenWidth
    mov ebx, 40
    mul ebx
    mov ebx, 100
    div ebx
    mov pipe1X, eax
    
    mov eax, screenWidth
    mov ebx, 80
    mul ebx
    mov ebx, 100
    div ebx
    mov pipe2X, eax
    
    ; Reset game state
    mov gameOver, 0
    mov gamePaused, 0
    mov needsRedraw, 1
    mov score, 0
    mov frameCount, 0
    mov pipe1Scored, 0
    mov pipe2Scored, 0
    
    call Randomize
    mov eax, OFFSET pipe1GapY  ; Pass pointer to pipe1GapY
    call RandomizePipe
    mov eax, OFFSET pipe2GapY  ; Pass pointer to pipe2GapY  
    call RandomizePipe
    ret
ResetFlappyBird ENDP

FlappyBird_GameLoop PROC
GameLoop:
    ; Check if game is paused
    cmp gamePaused, 1
    je PausedLoop
    
    ; Normal game loop
    inc frameCount
    call CheckInput
    
    ; Apply gravity
    mov eax, gravity
    add birdY, eax

    ; FIX: Limit bird from going above ceiling
    mov eax, birdY
    cmp eax, MSG_AREA_HEIGHT  ; MSG_AREA_HEIGHT = 2
    jge NoCeilingLimit       ; If birdY >= 2, no need to limit
    mov eax, MSG_AREA_HEIGHT  ; Limit bird to minimum Y position
    mov birdY, eax
NoCeilingLimit:
    
    call UpdatePipes
    call UpdateScore
    call CheckCollisions
    cmp gameOver, 1
    je ExitGame
    
    ; Always redraw during normal gameplay
    mov needsRedraw, 1
    call DrawGame
    mov eax, 100
    call Delay
    jmp GameLoop

PausedLoop:
    ; Game is paused - just check input
    call CheckInput
    cmp gameOver, 1
    je ExitGame
    
    ; Only redraw when first entering pause state
    cmp needsRedraw, 1
    jne SkipPauseRedraw
    
    ; Draw the game screen once when pausing
    call DrawGame
    call DrawPauseMessage
    mov needsRedraw, 0  ; Don't redraw again until we resume
    
SkipPauseRedraw:
    mov eax, 50  ; Shorter delay for more responsive input during pause
    call Delay
    jmp GameLoop
    
ExitGame:
    call ShowGameOver
    ret
FlappyBird_GameLoop ENDP

CheckInput PROC
    call ReadKey
    jz NoInput
    
    cmp ax, 4800h   ; UP ARROW key
    je DoFlap
    cmp al, 'p'     ; P key - pause
    je TogglePause
    cmp al, 'P'     ; P key (uppercase) - pause
    je TogglePause
    cmp al, 'r'     ; R key - resume
    je ResumeGame
    cmp al, 'R'     ; R key (uppercase) - resume
    je ResumeGame
    cmp al, 'q'     ; Q key
    je QuitToMenu
    cmp al, 'Q'     ; Q key (uppercase)
    je QuitToMenu
    jmp NoInput
    
DoFlap:
    mov eax, flapStrength
    sub birdY, eax
    jmp NoInput

TogglePause:
    ; Only pause if game is not already paused
    cmp gamePaused, 0
    jne NoInput
    mov gamePaused, 1
    mov needsRedraw, 1  ; Force redraw when pausing
    jmp NoInput

ResumeGame:
    ; Only resume if game is paused
    cmp gamePaused, 1
    jne NoInput
    mov gamePaused, 0
    mov needsRedraw, 1  ; Force redraw when resuming
    jmp NoInput
    
QuitToMenu:
    mov gameOver, 1
    
NoInput:
    ret
CheckInput ENDP

DrawPauseMessage PROC
    ; Draw pause message below the ground
    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    ; Position message at the bottom of the screen
    mov eax, screenHeight
    mov dh, al
    mov dl, 0
    call Gotoxy
    
    ; Clear the line first
    mov ecx, screenWidth
    cmp ecx, 300
    jbe ClearLineOK
    mov ecx, 300
ClearLineOK:
    mov al, ' '
ClearLine:
    call WriteChar
    loop ClearLine
    
    ; Now draw the pause message centered
    mov eax, screenHeight
    mov dh, al
    mov eax, screenWidth
    sub eax, 30  ; Length of pause message
    shr eax, 1   ; Divide by 2 to center
    mov dl, al
    call Gotoxy
    
    mov edx, OFFSET pauseMsg
    call WriteString
    
    ; Reset text color
    mov eax, white + (black * 16)
    call SetTextColor
    ret
DrawPauseMessage ENDP

UpdatePipes PROC
    ; Don't update pipes if game is paused
    cmp gamePaused, 1
    je SkipPipeUpdate
    
    mov al, frameCount
    and al, 1
    jnz SkipMove
    
    ; Move pipes left
    dec pipe1X
    dec pipe2X
    
SkipMove:
    ; Reset pipes when they go off left side
    cmp pipe1X, 0
    jg CheckPipe2Reset
    
    ; Reset pipe1 to right side
    mov eax, screenWidth
    mov pipe1X, eax
    mov eax, OFFSET pipe1GapY  ; Pass pointer to pipe1GapY
    call RandomizePipe
    mov pipe1Scored, 0
    
CheckPipe2Reset:
    cmp pipe2X, 0
    jg Done
    
    ; Reset pipe2 to right side
    mov eax, screenWidth
    mov pipe2X, eax
    mov eax, OFFSET pipe2GapY  ; Pass pointer to pipe2GapY
    call RandomizePipe
    mov pipe2Scored, 0
    
SkipPipeUpdate:
Done:
    ret
UpdatePipes ENDP

; Reusable procedure to randomize pipe gap position
; Parameters: pointer to pipeGapY in EAX
RandomizePipe PROC
    push eax
    push ebx
    push ecx

    mov ebx, eax
    
    ; Simple random gap position (avoid edges and message area)
    mov ecx, screenHeight
    sub ecx, MSG_AREA_HEIGHT  ; Subtract message area
    sub ecx, 15               ; Leave margin for ground and ceiling
    mov eax, ecx              ; Max value for RandomRange
    call RandomRange
    add eax, 5                ; Minimum position
    add eax, MSG_AREA_HEIGHT  ; Add message area offset
    
    ; Store result in the pipeGapY variable (pointer is in stack)
   mov [ebx], eax           ; Store the random gap position
    
    pop ecx
    pop ebx
    pop eax
    ret
RandomizePipe ENDP

UpdateScore PROC
    ; Don't update score if game is paused
    cmp gamePaused, 1
    je SkipScoreUpdate
    
    ; Check if bird passed pipe1 (birdX > pipe1X + some offset)
    mov eax, pipe1X
    add eax, 3  ; Add small offset so we score when bird is past the pipe, not when it touches it
    cmp birdX, eax
    jle CheckPipe2Score  ; Bird hasn't passed pipe1 yet
    
    ; Bird has passed pipe1, check if we already scored it
    cmp pipe1Scored, 0
    jne CheckPipe2Score  ; Already scored this pipe
    mov pipe1Scored, 1
    inc score
    jmp DoneScoring
    
CheckPipe2Score:
    ; Check if bird passed pipe2
    mov eax, pipe2X
    add eax, 3  ; Add small offset
    cmp birdX, eax
    jle DoneScoring  ; Bird hasn't passed pipe2 yet
    
    ; Bird has passed pipe2, check if we already scored it
    cmp pipe2Scored, 0
    jne DoneScoring  ; Already scored this pipe
    mov pipe2Scored, 1
    inc score
    
SkipScoreUpdate:
DoneScoring:
    ret
UpdateScore ENDP

CheckCollisions PROC
    ; Don't check collisions if game is paused
    cmp gamePaused, 1
    je SkipCollisionCheck
    
    ; Ground collision at bottom of screen
    mov eax, birdY
    add eax, 2  ; Check bottom of the bird (3 rows tall)
    cmp eax, screenHeight
    jl CheckPipes  ; Skip ceiling check - go straight to pipe collision
    mov gameOver, 1
    ret
    
CheckPipes:
    ; Check collision with pipe1
    mov esi, pipe1X
    mov edi, pipe1GapY
    call CheckSinglePipeCollision
    cmp gameOver, 1
    je NoCollision  ; If collision with pipe1, exit
    
    ; Check collision with pipe2
    mov esi, pipe2X
    mov edi, pipe2GapY
    call CheckSinglePipeCollision
    
SkipCollisionCheck:
NoCollision:
    ret
CheckCollisions ENDP

; Reusable procedure to check collision with a single pipe
; Parameters: pipeX in ESI, pipeGapY in EDI
CheckSinglePipeCollision PROC
    ; Check horizontal proximity to pipe
    mov eax, esi      ; pipeX
    sub eax, birdX    ; pipeX - birdX
    cmp eax, 3
    jg NoPipeCollision  ; Bird is too far right
    cmp eax, -1       ; Bird is 2 characters wide
    jl NoPipeCollision  ; Bird is too far left
    
    ; Check vertical collision with pipe gap
    mov eax, birdY
    cmp eax, edi      ; Compare birdY with pipeGapY
    jl PipeCollision  ; Above gap - collision
    
    mov eax, birdY
    add eax, 2        ; Bottom of bird
    mov ebx, edi
    add ebx, 8        ; Gap size
    cmp eax, ebx
    jg PipeCollision  ; Below gap - collision
    
    jmp NoPipeCollision
    
PipeCollision:
    mov gameOver, 1
    
NoPipeCollision:
    ret
CheckSinglePipeCollision ENDP

DrawGame PROC
    call Clrscr
    


    ; Draw score (top left - in message area)
    mov dl, 5
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET scoreMsg
    call WriteString
    mov eax, score
    call WriteDec
    
    ; Draw instructions (top right - in message area)
    mov eax, screenWidth
    sub eax, 35
    cmp eax, 255
    jbe InstXOK
    mov eax, 255
InstXOK:
    mov dl, al
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET instructions
    call WriteString
    
    ; Draw separator line between message area and game area
    mov dh, MSG_AREA_HEIGHT - 1  ; Row just below messages
    mov dl, 0
    call Gotoxy
    mov ecx, screenWidth
    cmp ecx, 300
    jbe SepWidthOK
    mov ecx, 300
SepWidthOK:
    mov al, '-'
DrawSeparator:
    call WriteChar
    loop DrawSeparator
    
    ; FIX 1: Draw complete bird (3 parts)
    mov eax, yellow + (black * 16)
    call SetTextColor
    call DrawMiniBird
    
    ; Draw pipes
    mov eax, white + (black * 16)
    call SetTextColor
    call DrawPipes
    
    ; FIX 2: Draw ground at bottom of screen (adjusted for message area)
    mov eax, brown + (black * 16)
    call SetTextColor
    mov eax, screenHeight
    dec eax  ; Ground at bottom row
    cmp eax, 255
    jbe GroundYOK
    mov eax, 255
GroundYOK:
    mov dh, al
    mov dl, 0
    call Gotoxy
    
    mov ecx, screenWidth
    cmp ecx, 300
    jbe GroundWidthOK
    mov ecx, 300
GroundWidthOK:
DrawGround:
    mov edx, OFFSET groundChar
    call WriteString
    loop DrawGround
    
    mov eax, white + (black * 16)
    call SetTextColor
    ret
DrawGame ENDP

; FIX 1: Complete bird drawing procedure
DrawMiniBird PROC
    ; Draw top of bird: (
    mov eax, birdX
    cmp eax, 255
    jbe BirdX1OK
    mov eax, 255
BirdX1OK:
    mov dl, al
    
    mov eax, birdY
    cmp eax, 255
    jbe BirdY1OK
    mov eax, 255
BirdY1OK:
    mov dh, al
    
    call Gotoxy
    mov edx, OFFSET birdTop
    call WriteString
    
    ; Draw middle of bird: >
    mov eax, birdX
    add eax, 1
    cmp eax, 255
    jbe BirdX2OK
    mov eax, 255
BirdX2OK:
    mov dl, al
    
    mov eax, birdY
    cmp eax, 255
    jbe BirdY2OK
    mov eax, 255
BirdY2OK:
    mov dh, al
    
    call Gotoxy
    mov edx, OFFSET birdMiddle
    call WriteString
    
    ; Draw bottom of bird: )
    mov eax, birdX
    cmp eax, 255
    jbe BirdX3OK
    mov eax, 255
BirdX3OK:
    mov dl, al
    
    mov eax, birdY
    add eax, 1
    cmp eax, 255
    jbe BirdY3OK
    mov eax, 255
BirdY3OK:
    mov dh, al
    
    call Gotoxy
    mov edx, OFFSET birdBottom
    call WriteString
    
    ret
DrawMiniBird ENDP

; Reusable procedure to draw a single pipe
; Parameters: pipeX in ESI, pipeGapY in EDI  
DrawSinglePipe PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Calculate where to stop drawing pipes (1 row above ground)
    mov ecx, screenHeight
    sub ecx, 2
    
    cmp ecx, 100
    jbe PipeHeightOK
    mov ecx, 100
PipeHeightOK:
    
    mov eax, MSG_AREA_HEIGHT  ; Start drawing after message area
    
DrawPipeLoop:
    push ecx
    push eax
    
    ; Check if this row is in the pipe gap
    cmp eax, edi
    jl DrawPipe
    mov ebx, edi
    add ebx, 8
    cmp eax, ebx
    jg DrawPipe
    jmp SkipPipe
    
DrawPipe:
    ; Set coordinates for Gotoxy - EXACT COPY OF YOUR WORKING CODE
    mov ebx, esi  ; pipeX
    cmp ebx, 255
    jbe PipeXOK
    mov ebx, 255
PipeXOK:
    mov dl, bl
    
    mov ebx, eax  ; current row
    cmp ebx, 255
    jbe PipeYOK
    mov ebx, 255
PipeYOK:
    mov dh, bl
    
    call Gotoxy
    mov edx, OFFSET pipeChar
    call WriteString
    
SkipPipe:
    pop eax
    pop ecx
    inc eax
    loop DrawPipeLoop
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
DrawSinglePipe ENDP

DrawPipes PROC
    ; Draw pipe 1 using reusable procedure
    mov esi, pipe1X
    mov edi, pipe1GapY
    call DrawSinglePipe
    
    ; Draw pipe 2 using reusable procedure  
    mov esi, pipe2X
    mov edi, pipe2GapY
    call DrawSinglePipe
    
    ret
DrawPipes ENDP

ShowGameOver PROC
    call Clrscr
    ; Center game over message
    mov eax, screenWidth
    sub eax, 40
    shr eax, 1
    cmp eax, 255
    jbe GameOverXOK
    mov eax, 255
GameOverXOK:
    mov dl, al
    mov eax, screenHeight
    sub eax, 5
    shr eax, 1
    cmp eax, 255
    jbe GameOverYOK
    mov eax, 255
GameOverYOK:
    mov dh, al
    call Gotoxy
    mov edx, OFFSET gameOverMsg
    call WriteString
    
    ; Center score - FIX: use EAX for DWORD score
    mov eax, screenWidth
    sub eax, 20
    shr eax, 1
    cmp eax, 255
    jbe ScoreXOK
    mov eax, 255
ScoreXOK:
    mov dl, al
    inc dh
    call Gotoxy
    mov edx, OFFSET scoreMsg
    call WriteString
    mov eax, score  ; Load DWORD score into EAX
    call WriteDec   ; This will write the DWORD value correctly
    
    call ReadChar
    ret
ShowGameOver ENDP

END
