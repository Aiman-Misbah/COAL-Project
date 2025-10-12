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
instructions BYTE "Press SPACE to flap", 0

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
    mov score, 0
    mov frameCount, 0
    mov pipe1Scored, 0
    mov pipe2Scored, 0
    
    call Randomize
    call RandomizePipe1
    call RandomizePipe2
    ret
ResetFlappyBird ENDP

FlappyBird_GameLoop PROC
GameLoop:
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
    
    call DrawGame
    mov eax, 100
    call Delay
    jmp GameLoop
    
ExitGame:
    call ShowGameOver
    ret
FlappyBird_GameLoop ENDP

CheckInput PROC
    call ReadKey
    jz NoInput
    
    cmp al, ' '
    je DoFlap
    cmp ax, 4800h
    je DoFlap
    cmp al, 'q'
    je QuitToMenu
    cmp al, 'Q'
    je QuitToMenu
    jmp NoInput
    
DoFlap:
    mov eax, flapStrength
    sub birdY, eax

    mov eax, birdY
    cmp eax, MSG_AREA_HEIGHT-1
    jge FlapNoCeilingLimit
    mov eax, MSG_AREA_HEIGHT-1
    mov birdY, eax

FlapNoCeilingLimit:
    jmp NoInput
    
QuitToMenu:
    mov gameOver, 1
    
NoInput:
    ret
CheckInput ENDP

UpdatePipes PROC
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
    call RandomizePipe1
    mov pipe1Scored, 0
    
CheckPipe2Reset:
    cmp pipe2X, 0
    jg Done
    
    ; Reset pipe2 to right side
    mov eax, screenWidth
    mov pipe2X, eax
    call RandomizePipe2
    mov pipe2Scored, 0
    
Done:
    ret
UpdatePipes ENDP

RandomizePipe1 PROC
    ; Simple random gap position (avoid edges and message area)
    mov eax, screenHeight
    sub eax, MSG_AREA_HEIGHT  ; Subtract message area
    sub eax, 15  ; Leave margin for ground and ceiling
    call RandomRange
    add eax, 5   ; Minimum position
    add eax, MSG_AREA_HEIGHT  ; Add message area offset
    mov pipe1GapY, eax
    ret
RandomizePipe1 ENDP

RandomizePipe2 PROC
    mov eax, screenHeight
    sub eax, MSG_AREA_HEIGHT  ; Subtract message area
    sub eax, 15
    call RandomRange
    add eax, 5
    add eax, MSG_AREA_HEIGHT  ; Add message area offset
    mov pipe2GapY, eax
    ret
RandomizePipe2 ENDP

UpdateScore PROC
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
    
DoneScoring:
    ret
UpdateScore ENDP

CheckCollisions PROC
    ; FIX 2: Ground collision at bottom of screen
    mov eax, birdY
    add eax, 2  ; Check bottom of the bird (3 rows tall)
    cmp eax, screenHeight
    jl CheckPipe1  ; Skip ceiling check - go straight to pipe collision
    mov gameOver, 1
    ret
    
CheckPipe1:
    ; FIX 3: Better pipe collision detection
    ; Check horizontal proximity to pipe1
    mov eax, pipe1X
    sub eax, birdX
    cmp eax, 3
    jg CheckPipe2
    cmp eax, -1  ; Bird is 2 characters wide
    jl CheckPipe2
    
    ; Check vertical collision with pipe1 gap
    mov eax, birdY
    cmp eax, pipe1GapY
    jl Collision        ; Above gap - collision
    
    mov eax, birdY
    add eax, 2          ; Bottom of bird
    mov ebx, pipe1GapY
    add ebx, 8          ; Gap size
    cmp eax, ebx
    jg Collision        ; Below gap - collision
    jmp NoCollision
    
CheckPipe2:
    ; Check horizontal proximity to pipe2
    mov eax, pipe2X
    sub eax, birdX
    cmp eax, 3
    jg NoCollision
    cmp eax, -1
    jl NoCollision
    
    mov eax, birdY
    cmp eax, pipe2GapY
    jl Collision
    
    mov eax, birdY
    add eax, 2
    mov ebx, pipe2GapY
    add ebx, 8
    cmp eax, ebx
    jg Collision
    jmp NoCollision
    
Collision:
    mov gameOver, 1
    
NoCollision:
    ret
CheckCollisions ENDP

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
    sub eax, 30
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

DrawPipes PROC
    ; FIX 3: Draw pipes with proper bounds to avoid overlap and respect message area
    ; Draw pipe 1 (stop 1 row above ground and start after message area)
    mov ecx, screenHeight
    sub ecx, 2  ; Stop 1 row above ground (screenHeight-1 is ground, screenHeight-2 is last pipe row)
    cmp ecx, 100
    jbe PipeHeightOK1
    mov ecx, 100
PipeHeightOK1:
    mov eax, MSG_AREA_HEIGHT  ; Start drawing after message area
    
DrawPipe1Loop:
    push ecx
    push eax
    
    ; Check if this row is in the pipe gap
    cmp eax, pipe1GapY
    jl DrawPipe1
    mov ebx, pipe1GapY
    add ebx, 8
    cmp eax, ebx
    jg DrawPipe1
    jmp SkipPipe1
    
DrawPipe1:
    mov ebx, pipe1X
    cmp ebx, 255
    jbe Pipe1XOK
    mov ebx, 255
Pipe1XOK:
    mov dl, bl
    
    mov ebx, eax
    cmp ebx, 255
    jbe Pipe1YOK
    mov ebx, 255
Pipe1YOK:
    mov dh, bl
    
    call Gotoxy
    mov edx, OFFSET pipeChar
    call WriteString
    
SkipPipe1:
    pop eax
    pop ecx
    inc eax
    loop DrawPipe1Loop
    
    ; Draw pipe 2 (stop 1 row above ground and start after message area)
    mov ecx, screenHeight
    sub ecx, 2  ; Stop 1 row above ground
    cmp ecx, 100
    jbe PipeHeightOK2
    mov ecx, 100
PipeHeightOK2:
    mov eax, MSG_AREA_HEIGHT  ; Start drawing after message area
    
DrawPipe2Loop:
    push ecx
    push eax
    
    cmp eax, pipe2GapY
    jl DrawPipe2
    mov ebx, pipe2GapY
    add ebx, 8
    cmp eax, ebx
    jg DrawPipe2
    jmp SkipPipe2
    
DrawPipe2:
    mov ebx, pipe2X
    cmp ebx, 255
    jbe Pipe2XOK
    mov ebx, 255
Pipe2XOK:
    mov dl, bl
    
    mov ebx, eax
    cmp ebx, 255
    jbe Pipe2YOK
    mov ebx, 255
Pipe2YOK:
    mov dh, bl
    
    call Gotoxy
    mov edx, OFFSET pipeChar
    call WriteString
    
SkipPipe2:
    pop eax
    pop ecx
    inc eax
    loop DrawPipe2Loop
    
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
