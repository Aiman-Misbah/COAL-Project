INCLUDE Irvine32.inc

.data
birdX DWORD ?       ;ye dono are for bird ki position
birdY DWORD ?       ;x means col (horizontally) and y means row (vertically)
gapHeight DWORD 8   ;yaani pipes k beech ka gap jismein se bird jaayegi
score DWORD 0       ;increments 1 if successfully passed pipes k beech se
gameOver DWORD 0    ;flag   0 = game chal rha hai       1 = game over
gameRestart DWORD 0 ;flag for restart/start from the beginning  1 = restart the game and vice versa

NUM_PIPES EQU 3     ;for the array of pipes - aik saath screen par 3 pipes aayenge
PIPE_SPACING DWORD ?  ;Distance between pipes

pipeX DWORD NUM_PIPES DUP(?)        ;cols for the 3 pipes being displayed
gapTop DWORD NUM_PIPES DUP(?)       ;top of the gap - yaani end of the top half of the pipe (vertical position) - different for all pipes
pipeScored DWORD NUM_PIPES DUP(0)   ;bird ne us pipe ko pass kia hai ya nhi 1=passed and vice versa

;characters for drawing the title for the welcome screen

blk EQU 219     ;a solid block
spc EQU 32      ;space
trc EQU 187     ;top right corner (ye saare corners and lines are double)
tlc EQU 201     ;top left corner
blc EQU 200     ;bottom left corner
brc EQU 188     ;bottom right corner
vl EQU 186      ;vertical line
hl EQU 205      ;horizontal line

;title - different parts bcoz of statement too complex error
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

;saare instructions on the welcome screen
taglineMsg  BYTE "Tap, Flap, and Dodge - Can You Beat Gravity?",0
instruct1   BYTE "Press UP ARROW to flap your wings!",0
instruct2   BYTE "P  to pause   |   R  to resume   |   BACKSPACE to quit",0
instruct3   BYTE "Avoid those pipes... they really don't like you!",0
instruct4   BYTE "Stay calm. Stay steady. Stay flappy.",0
instruct5   BYTE "Press P to Start your flight!",0
instruct6   BYTE "Press BACKSPACE if you wish to return to the menu", 0

;action wale msgs
quitMsg BYTE "Returning to Menu ",0
startMsg BYTE "Starting Game ",0
restartMsg BYTE "Restarting Game ",0
confirmQuitMsg BYTE "Are you sure you want to quit? (Y/N)",0
yesNoMsg BYTE "Press Y for Yes, N for No",0
resumingMsg BYTE "Resuming game ",0

; Bird characters
birdLine1 BYTE "(>", 0
birdLine2 BYTE ") ", 0

;pipe ka character is the block character
pipeChar BYTE blk, 0

;mazeed msgs
scoreMsg BYTE "Score: ",0
gameOverMsg BYTE "GAME OVER!",0
instructions BYTE "--FLAPPY BIRD--",0
pauseMsg BYTE "GAME PAUSED! Press 'R' to resume or 'BACKSPACE' to quit", 0
replayMsg BYTE "Press R to replay or BACKSPACE to quit", 0

;screen k dimensions and center wali cheezein
screenWidth DWORD ?
screenHeight DWORD ?
centerCol   DWORD ?
centerRow   DWORD ?

pipeWidth DWORD 2       ;pipe ki width is 2 mtlb is block characters
playableTop DWORD 2     ;the khelne wala area is starting from row 2 - row 0 is for the msgs and row 1 is for like the boundary
playableBottom DWORD ?  ;that is calculated bcoz ground position varies according to the screen size

readyMsg BYTE " READY?",0    ;countdown k msgs
countdown3 BYTE "   3   ",0
countdown2 BYTE "   2   ",0  
countdown1 BYTE "   1   ",0
goMsg BYTE "  GO!  ",0

belowRow DWORD ?    ;center of the area below the ground
belowCol DWORD ?

;game over k box ki cheezein
boxTop      DWORD ?
boxLeft     DWORD ?
boxWidth    DWORD ?
boxHeight   DWORD ?
boxRight    DWORD ?
boxBottom   DWORD ?


.code
FlappyBird PROC
    call InitializeScreen
    call ShowWelcomeScreen
    cmp gameRestart, 0      ;agar game start nhi krna to back to menu wrna to the game
    je QuitGame
    call ResetGame          ;initializing the game

    mov eax, white + (black * 16)
    call SetTextColor

    call ShowCountdown

MainLoop:
    ; Delay between frames kionke iske baghair boht tez jaa rha tha
    mov eax, 80
    call Delay

    call ReadKey        ;not ReadChar bcoz we are not stopping for input agar koi input nhi to continue as usual
    jz NoInput

    cmp al, 08h         ;08h for backspace
    je ConfirmQuit
    cmp al, 'p'         ;dono cases are handled - P and p
    je DoPause
    cmp al, 'P'
    je DoPause
    cmp ax, 4800h       ;4800 is for up arrow key
    je Flap

NoInput:
    call ApplyGravityToBird     ;bird ko normally to giraana hi hai
    call CheckGroundCollision   ;ground collision kr liye
    call CheckPipeCollision     ;pipe collision keliye
    mov eax, gameOver
    cmp eax, 1
    je GameOverScreen

    call MovePipesLeft      ;moving pipes to the left 1 col
    call CheckPipeReset     ;checking if that pipe has been passed
    call CheckScore         ;updating score if that pipe has been passed

    call DrawGame       ;ab saari changes k baad draw again
    jmp MainLoop

ConfirmQuit:
    mov ebx, belowRow
    mov edx, OFFSET confirmQuitMsg
    call GenericConfirmation
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
    call HandleFlap     ;bird ki movement - har baar arrow key press krne par
    jmp NoInput

DoPause:
    call PauseGame           ; PauseGame will set gameRestart=0 if ESC pressed
    mov eax, gameRestart
    cmp eax, 0
    je QuitGame              ; if pause requested quit, behave like ESC in main loop
    jmp MainLoop

GameOverScreen:
    call DrawGameOver       ;game over ka box

WaitForReplayOrQuit:        ;after game over kia krna hai
    call ReadChar
    cmp al, 'r'
    je RestartAfterGameOver
    cmp al, 'R'
    je RestartAfterGameOver
    cmp al, 08h                 ; BACKSPACE = ask for confirmation
    je AskQuitConfirmation
    jmp WaitForReplayOrQuit     ;invalid input pr kuch nhi krega

AskQuitConfirmation:
    mov ebx, boxTop
    add ebx, 9
    mov edx, OFFSET confirmQuitMsg
    call GenericConfirmation  ; handles yes no wali cheezein inside itself

    mov eax, gameRestart
    cmp eax, 0
    je QuitGame             ;0 mtlb quit
    cmp eax, 1
    je WaitForReplayOrQuit  ; user chose No, return to game-over screen


RestartAfterGameOver:
    mov ebx, boxTop             ;displaying rstarting game
    add ebx, 10             
    mov edx, OFFSET restartMsg
    call CenterText
    call DotAnimation
    call ResetGame
    call Clrscr
    call ShowCountdown
    jmp MainLoop


QuitGame:
    mov eax, white + (black * 16)
    call SetTextColor
    ret
FlappyBird ENDP


PauseGame PROC
    pushad
    mov edx, OFFSET pauseMsg    ;msgs in the below area
    call DisplayBelowMessage

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
    mov ebx, belowRow
    mov edx, OFFSET confirmQuitMsg
    call GenericConfirmation
    cmp gameRestart, 0          ;if it is 0 then it means quit
    je QuitToMenu

ResumePause:                    ;wrna 2 hoga kionke since it is not game over it won't be 1
    call Clrscr
    call ShowCountdown
    popad
    ret

QuitToMenu:
    mov gameRestart, 0    ;game restart nhi krna (yahaan we are taking it as resume)
    popad
    ret
PauseGame ENDP


DotAnimation PROC
    ; message = OFFSET string, row = DH, col = DL
    mov ecx, 3              ;ye saari cheezein to pehle se hi set hain - dots will appear infront of the text
    mov eax, 300        ; thora sa delay
    call Delay
    
DotLoop:
    mov al, '.'         ;print har dot with a little delay in between
    call WriteChar
    
    mov eax, 300        ; 300ms delay between dots
    call Delay
    
    loop DotLoop
    
    mov eax, 300        ;animation khatam hone k baad bhi thora sa delay
    call Delay
    
    ret
DotAnimation ENDP

DisplayBelowMessage PROC

    mov ebx, edx        ; Input: edx = message offset
    call StrLength      ; length in eax
    shr eax, 1          ; divide by 2
    mov ecx, belowCol
    sub ecx, eax        ; centerCol - (length/2)
    mov eax, belowRow   ;center row is center of below area
    mov dh, al          ; cursor setting
    mov dl, cl          
    call Gotoxy

    mov edx, ebx
    call WriteString
    
    ret
DisplayBelowMessage ENDP

CenterText PROC
    push ebx        ;Input: EBX = row, EDX = message offset
    push edx
    
    mov ecx, edx        ;taake wapis mil ske
    
    call StrLength      ; eax = length
    shr eax, 1          ; half
    
    mov edx, centerCol  ;calculating center position for printing
    sub edx, eax
    mov dh, bl          ; row in dh - dl mein to aahi gaya na
    
    call Gotoxy
    mov edx, ecx        ; restoring the text message offset
    call WriteString
    
    pop edx
    pop ebx
    ret
CenterText ENDP

ShowWelcomeScreen PROC
    call Clrscr

    mov eax, screenWidth    ;screen center wali cheezein for welcome screen
    shr eax, 1
    mov centerCol, eax

    mov eax, playableTop        ;using playable area for the center row bcoz poori screen jb kr rhe the to wo boht neeche hojaa rha tha
    add eax, playableBottom     ;and isliye bhi kionke action msgs are below-area wise
    shr eax, 1
    mov centerRow, eax


    mov dh, BYTE PTR centerRow      ;Displaying the FLAPPY BIRD title
    sub dh, 8                       ;center se thora oopar
    mov eax, centerCol                 
    sub eax, 43  ;Half the width of FLAPPY text      ;starting col
    mov dl, al
    call Gotoxy
    mov edx, OFFSET FLAPPY_ROW1_P1
    call WriteString
    mov edx, OFFSET FLAPPY_ROW1_P2
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 7                   ;incrementing rows 
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

    mov dh, BYTE PTR centerRow      ;now displaying the BIRD
    sub dh, 8                       ;same row as the top of FLAPPY
    mov eax, centerCol
    add eax, 8                 ;thora right of the FLAPPY
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW1
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 7
    mov eax, centerCol
    add eax, 8
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW2
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 6
    mov eax, centerCol
    add eax, 8
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW3
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 5
    mov eax, centerCol
    add eax, 8
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW4
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 4
    mov eax, centerCol
    add eax, 8
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW5
    call WriteString

    mov dh, BYTE PTR centerRow
    sub dh, 3
    mov eax, centerCol
    add eax, 8
    mov dl, al
    call Gotoxy
    mov edx, OFFSET BIRD_ROW6
    call WriteString

    mov ebx, centerRow      ;now all the msgs and instructions
    inc ebx
    mov edx, OFFSET taglineMsg
    call CenterText

    mov eax, yellow + (black * 16)  ;yellow for the instructions
    call SetTextColor

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

    mov eax, brown + (black * 16)   ;kuch in brown
    call SetTextColor

    add ebx, 2
    mov edx, OFFSET instruct5
    call CenterText

    inc ebx
    mov edx, OFFSET instruct6
    call CenterText

    mov eax, yellow + (black * 16)  ;acion msg in yellow
    call SetTextColor

WaitKey:
    call ReadChar       ;action based on konsi key is pressed
    cmp al, 'P'
    je StartGameAnim
    cmp al, 'p'
    je StartGameAnim
    cmp al, 08h              ;08 represents BACKSPACE
    je QuitToMenuAnim
    jmp WaitKey

StartGameAnim:
    mov edx, OFFSET startMsg    ;relevant msg is shown in the below area with dot animation 
    call DisplayBelowMessage
    call DotAnimation
    mov gameRestart, 1          ;since game is starting from the beginning restart is 1
    jmp Done


QuitToMenuAnim:
    mov edx, OFFSET quitMsg
    call DisplayBelowMessage
    call DotAnimation
    mov gameRestart, 0          ;waapis menu p jaa rhe hain not starting so it is 0
    jmp Done

Done:
    mov eax, white + (black * 16)
    call SetTextColor

    ret
ShowWelcomeScreen ENDP

GenericConfirmation PROC
    ; Input: ebx = message konsi row mein print hoga, edx = confirm message offset
    ; Returns: gameRestart = 0 (quit), 1 (no - only for game over), 2 (show countdown)
    
    mov eax, boxTop     ;if boxTop is not calculated then msgs will be shown in below area wrna screen k center mein
    cmp eax, 0
    jg DisplayMessages
    
    call DrawGame       ;taake pause msg mit jaaye
    
DisplayMessages:
    call CenterText
    inc ebx
    mov edx, OFFSET yesNoMsg
    call CenterText

WaitConfirmation:
    call ReadChar
    cmp al, 'y'
    je ConfirmYes
    cmp al, 'Y'
    je ConfirmYes
    cmp al, 'n'
    je ConfirmNo  
    cmp al, 'N'
    je ConfirmNo
    jmp WaitConfirmation

ConfirmYes:
    mov eax, boxTop     ;wohi cheez ab yes and no keliye krenge
    cmp eax, 0
    jg GameOverQuit
    
    call DrawGame
    mov edx, OFFSET quitMsg
    call DisplayBelowMessage
    call DotAnimation
    mov gameRestart, 0
    jmp DoneConfirmation
    
GameOverQuit:
    call DrawGameOver
    mov ebx, boxTop
    add ebx, 10
    mov edx, OFFSET quitMsg
    call CenterText
    call DotAnimation
    mov gameRestart, 0
    jmp DoneConfirmation

ConfirmNo:
    mov eax, boxTop
    cmp eax, 0
    jg GameOverNo
    
    call DrawGame
    mov edx, OFFSET resumingMsg
    call DisplayBelowMessage
    call DotAnimation
    mov gameRestart, 2
    jmp DoneConfirmation
    
GameOverNo:
    call DrawGameOver   ;if no bs game over ki screen dobara draw ho jayegi
    mov gameRestart, 1

DoneConfirmation:
    ret
GenericConfirmation ENDP

ShowCountdown PROC

    mov eax, white + (black * 16)
    call SetTextColor
    
    call DrawGame               ;Drawing the game first
    mov edx, OFFSET readyMsg    ;Displaying the messages in the below area
    call DisplayBelowMessage
    mov eax, 1000
    call Delay

    mov edx, OFFSET countdown3
    call DisplayBelowMessage
    mov eax, 600
    call Delay

    mov edx, OFFSET countdown2
    call DisplayBelowMessage
    mov eax, 600
    call Delay

    mov edx, OFFSET countdown1
    call DisplayBelowMessage
    mov eax, 600
    call Delay

    mov edx, OFFSET goMsg
    call DisplayBelowMessage
    mov eax, 700
    call Delay

    ret
ShowCountdown ENDP

InitializeScreen PROC     ;sets the screen size and bottom of the p;ayable area
    call GetMaxXY
    movzx eax, ax         ;ax = rows
    mov screenHeight, eax
    movzx edx, dx         ;dx = columns
    mov screenWidth, edx

    mov eax, screenHeight   ;playable bottom is at 80% of the screen height
    mov edx, 0
    imul eax, 80
    mov ecx, 100
    div ecx
    mov playableBottom, eax

    mov eax, screenHeight       ;calculating the center of the below-ground area 
    dec eax                     ;last row
    sub eax, playableBottom     ;top of that area se minus
    shr eax, 1                  ;half = middle of area
    add eax, playableBottom     ;utna neeche
    add eax, 1
    mov belowRow, eax

    mov eax, screenWidth
    shr eax, 1
    mov belowCol, eax

   
    mov eax, screenWidth    ;calculating the distance between pipes
    mov edx, 0              ;since there are three and even distance hona chahye that's why we are keeping them 33% of the screen apart
    imul eax, 33
    mov ecx, 100
    div ecx
    mov PIPE_SPACING, eax
    
    ret
InitializeScreen ENDP

ResetGame PROC
    mov gameOver, 0     ;game is running
    mov score, 0        ;score is initialized

    mov boxTop,0        ;wrna box baar baar draw ho rha tha

    mov eax, white + (black*16)
    call SetTextColor

    mov eax, screenWidth     ; Bird horizontal position = 25% screen width
    mov edx, 0
    imul eax, 25
    mov ecx, 100
    div ecx             
    mov birdX, eax

    mov eax, playableBottom     ;Bird vertical position = 50% of playable area
    sub eax, playableTop
    shr eax, 1
    add eax, playableTop
    mov birdY, eax

    mov ecx, NUM_PIPES     ;loop k thru we'll draw the pipes (3)
    mov esi, 0             ; index = 0

InitPipeLoop:
    ; pipeX[esi] = 50% screen width + spacing * index
    mov eax, screenWidth
    shr eax, 1          ;half
    mov ebx, esi        ;copying index
    imul ebx, PIPE_SPACING  ;multiplying with spacing taake col pata chal ske of each pipe
    add eax, ebx            ;adding offset to the centerCol - the pipe drawing is starting from the center of the screen
    mov [pipeX + esi*4], eax    ;storing the col pos of each pipe 

    call RandomRangeGapForReset ;random position for gap - result in eax
    mov [gapTop + esi*4], eax

    mov DWORD PTR [pipeScored + esi*4], 0   ;pipe hasn't been passed yet

    inc esi
    loop InitPipeLoop

    ret
ResetGame ENDP

RandomRangeGapForReset PROC
    mov eax, playableBottom     ;eax = random gap position - starting pos
    sub eax, playableTop        ;any col between the playable area
    sub eax, 10                 ;bcoz we don't want the gap to be outside the playable area
    call RandomRange            
    add eax, playableTop
    ret
RandomRangeGapForReset ENDP

HandleFlap PROC
    sub birdY, 2           ;bird is naturally falling 1 row and flap par it is moving up 2 rows
    mov eax, playableTop    ;taake jhatke na khaaye
    cmp birdY, eax      ; check ceiling
    jl SetToTop
    jmp DoneFlap
SetToTop:
    mov birdY, eax      ; clamp to ceiling taake ussey agay na jaye
    dec birdY
DoneFlap:
    ret
HandleFlap ENDP

ApplyGravityToBird PROC
    add birdY, 1            ;incrementing the bird's vertical pos
    mov eax, playableBottom
    cmp birdY, eax          
    jle DoneGravity         ;agar ground ko hit nhi kia to theek 
    mov birdY, eax          ;wrna bring it back to the ground
DoneGravity:   
    ret
ApplyGravityToBird ENDP

MovePipesLeft PROC          ;pipe ki movement 
    mov ecx, NUM_PIPES
    mov esi, OFFSET pipeX
MovePipesLeft_Loop:
    dec DWORD PTR [esi]         ;moving each pipe 1 col to the left
    add esi, 4
    loop MovePipesLeft_Loop
    ret
MovePipesLeft ENDP

CheckPipeReset PROC
    mov ecx, NUM_PIPES
    mov esi, 0

PipeResetLoop:
    mov eax, [pipeX + esi*4]
    cmp eax, 0          ;pipe screen se nikla to nhi from the left side
    jg NextPipeNoReset

    mov ebx, 0            ; ebx will hold max col
    mov edx, NUM_PIPES
    dec edx
FindRightmost:
    mov eax, [pipeX + edx*4]    ;we are comparing with each pipe ka col to find out konsa right-most pr hai and screen pr visible bhi hai
    cmp eax, ebx
    jle NotGreater      ;abhi nhi mila - move onto the next pipe
    mov ebx, eax        ;that will be the new max
NotGreater:
    dec edx
    jns FindRightmost   ;ye tb tk chalega jb tk edx is not -1

    add ebx, PIPE_SPACING       ;adding the distance from the right-most
    mov [pipeX + esi*4], ebx    ;storing it as the new pipe ka col

    ; reset scored flag kionke usey abhi paas nhi kia
    mov DWORD PTR [pipeScored + esi*4], 0

    call RandomRangeGapForReset ;calculating new gap pos for it and storing it
    mov [gapTop + esi*4], eax

NextPipeNoReset:
    inc esi
    loop PipeResetLoop
    ret
CheckPipeReset ENDP


CheckScore PROC
    mov ecx, NUM_PIPES
    mov esi, 0

ScoreLoop:
    mov eax, birdX
    mov ebx, [pipeX + esi*4]
    add ebx, pipeWidth
    cmp eax, ebx        ;if bird is to the left of pipe ka right, no increment
    jl ScoreSkip        ;mtlb bird has not fully passed the pipe yet

    mov eax, [pipeScored + esi*4] 
    cmp eax, 1      ;agar pipe ko paas kr chuka hai and uska increment bhi ho chuka hai then don't do it again
    je ScoreSkip    ;wrna phir har baar usey check kr rha tha and increment kr rha tha in the main loop

    inc score       ;now increment 1
    mov DWORD PTR [pipeScored + esi*4], 1   ;that pipe has been passed

ScoreSkip:
    inc esi
    loop ScoreLoop
    ret
CheckScore ENDP

CheckGroundCollision PROC
    mov eax, birdY
    add eax, 2              ;checking the bottom of the bird (bird is of rows)
    cmp eax, playableBottom
    jle NoGround            ;not touching
    mov gameOver, 1         ;game over
NoGround:
    ret
CheckGroundCollision ENDP

CheckPipeCollision PROC
    mov ecx, NUM_PIPES
    mov esi, 0

PipeCollisionLoop:
    mov eax, birdX          
    add eax, 2
    mov ebx, [pipeX + esi*4]
    cmp eax, ebx
    jl NextPipeNoCollision        ; bird left of pipe and not touching pipe

    mov eax, birdX
    mov ebx, [pipeX + esi*4]
    add ebx, pipeWidth
    dec ebx
    cmp eax, ebx
    jge NextPipeNoCollision       ; bird right of pipe and not touching pipe

    ; Vertical check 
    ; Special case: if gap starts at playableTop, allow bird to hit the ceiling 
    mov eax, [gapTop + esi*4]
    cmp eax, playableTop
    je SkipTopCheck               ;skip krdo bcoz it is allowed

    ; normal top collision check
    mov eax, birdY
    mov ebx, [gapTop + esi*4]
    cmp eax, ebx
    jl HitPipe                    ; bird above gap ? hit

SkipTopCheck:
    ; bottom collision check
    mov eax, birdY
    add eax, 2                    ; bird’s bottom k neeche wala hissa
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

;main drawing PROC jo baar baar call hoga
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
    mov dh, 0   ;Prints the score in the top left corner
    mov dl, 2
    call Gotoxy
    mov edx, OFFSET scoreMsg
    call WriteString
    mov eax, score
    call WriteDec

    mov ebx, 0      ;prints --FLAPPY BIRD-- in the center of the top row
    mov edx, OFFSET instructions
    call CenterText

    mov eax, playableTop    ;playable area k oopar aik separator line
    dec eax
    mov dh, al
    mov dl, 0
    call Gotoxy
    mov ecx, screenWidth
    mov al, '='          
DrawSeparator:
    call WriteChar
    loop DrawSeparator

    ret
DrawUI ENDP

DrawBird PROC
    mov eax, yellow + (black * 16)  ;bird is in yellow
    call SetTextColor

    mov eax, birdY      ;bird ki starting pos we have already calculated in ResetGame
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
    mov ecx, NUM_PIPES
    mov esi, 0
DrawPipes_Loop:
    mov eax, [pipeX + esi*4] ;checking pipe's col
    inc eax
    mov ebx, screenWidth
    cmp eax, ebx
    jge SkipThisPipe      ; skip if off screen ka right side
    cmp eax, 0
    jl SkipThisPipe       ; skipp if off screen ka left

    mov eax, playableTop
TopLoop:                        ;Drawing top half of the pipe
    mov ebx, [gapTop + esi*4]
    cmp eax, ebx
    jge DoneTop          ;gap tk pohunch gaye to top part is done
    mov dh, al            ; row
    mov dl, BYTE PTR [pipeX + esi*4]  ; column start
    call DrawSinglePipeSegment        ;Draws 2 block characters
    inc eax
    jmp TopLoop

DoneTop:
    mov eax, [gapTop + esi*4]   ;Drawing the bottom half
    add eax, gapHeight          ;gap ki starting row mein add the gapHeight (abhi it is 8)
BottomLoop:
    cmp eax, playableBottom     ;bottom tk phunch gaya hai to this is done
    jge SkipThisPipe            ;skip mein and done mein aik hi kaam ho rha hai
    mov dh, al
    mov dl, BYTE PTR [pipeX + esi*4]
    call DrawSinglePipeSegment
    inc eax
    jmp BottomLoop

SkipThisPipe:
    inc esi
    loop DrawPipes_Loop

    ret
DrawPipes ENDP


DrawSinglePipeSegment PROC
    pushad
    mov eax, [pipeX + esi*4]
    mov dl, al
    mov ecx, pipeWidth
DrawSinglePipeSeg_Loop:
    push edx
    call Gotoxy
    mov edx, OFFSET pipeChar
    call WriteString
    pop edx
    inc dl
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

    mov eax, screenWidth    ;setting up the game over box
    mov ebx, 60             ;width will be 60% of the screen ki width
    imul eax, ebx
    cdq
    mov ebx, 100
    idiv ebx
    mov boxWidth, eax         

    mov eax, screenHeight       
    mov ebx, 40
    imul eax, ebx
    cdq
    mov ebx, 100
    idiv ebx
    mov boxHeight, eax        ; height is 40% of screen height

    mov eax, screenWidth    ;calculating the left col 
    sub eax, boxWidth
    shr eax, 1              ;2 isliye kionke aik right and aik left isliye half lia hai
    mov boxLeft, eax

    mov eax, screenHeight   ;similarly for the top of the box
    sub eax, boxHeight
    shr eax, 1
    mov boxTop, eax

    mov eax, boxTop     ;baaki dono corners bhi set krdiye
    add eax, boxHeight
    mov boxBottom, eax
    mov eax, boxLeft
    add eax, boxWidth
    mov boxRight, eax


    mov eax, black + (black * 16)   ;box ka background colour is black so we need to print spaces jo k back se likhe jaayeinge
    call SetTextColor

    mov ecx, boxHeight          ;printing row wise and incrementing column
    mov dh, BYTE PTR boxTop
FillColLoop:
        inc dh                      ;starting from one row below the top (for border) - and incrementing row after every loop
        cmp dh, BYTE PTR boxBottom  
        jge DoneFill                ;full neeche tk pohunch gaye to ho gya
        mov dl, BYTE PTR boxLeft
        inc dl                      ;same here as well - skip left border
        mov ebx, boxWidth
        call Gotoxy
    FillRowLoop:
        mov al, ' '           ; space = black fill
        call WriteChar
        dec ebx
        jnz FillRowLoop
        loop FillColLoop

DoneFill:
    mov eax, white + (black * 16)
    call SetTextColor

    mov dh, BYTE PTR boxTop     ;drawing the top border of the box
    mov dl, BYTE PTR boxLeft
    call Gotoxy
    mov al, '='

    mov ecx, boxWidth
TopLine:
    call WriteChar
    loop TopLine

    mov ecx, boxHeight      ;excluding the top+bottom rows
    sub ecx, 1              ;only 1 not 2 because loop k ander inital increment bhi hai
    mov dh, BYTE PTR boxTop
SideLoop:
    inc dh                       ;left side
    mov dl, BYTE PTR boxLeft
    call Gotoxy
    mov al, '|'
    call WriteChar
    mov al, '|'
    call WriteChar

    mov dl, BYTE PTR boxRight       ;right side
    sub dl, 1                     ; shift slightly left to fit inside box
    call Gotoxy
    mov al, '|'
    call WriteChar
    mov al, '|'
    call WriteChar

    loop SideLoop


    mov dh, BYTE PTR boxBottom  ;bottom row
    mov dl, BYTE PTR boxLeft
    call Gotoxy
    mov al, '='

    mov ecx, boxWidth
    BottomLine:
        call WriteChar
        loop BottomLine


    mov eax, yellow + (black * 16)  ;text inside box will be in yellow
    call SetTextColor

    mov ebx, boxTop             ;game over ka title will be closer to the top but horzontally in the center
    add ebx, 2
    mov edx, OFFSET gameOverMsg
    call CenterText

    mov ebx, boxTop             ;baaki sb phit normally print hoga
    add ebx, 5
    mov edx, OFFSET scoreMsg
    call CenterText
    mov eax, score
    call WriteDec

    mov ebx, boxTop
    add ebx, 7
    mov edx, OFFSET replayMsg
    call CenterText

    ret
DrawGameOver ENDP
END
