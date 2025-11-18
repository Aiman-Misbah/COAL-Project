INCLUDE Irvine32.inc

.data
maze_gameTitle BYTE "~MINI TREASURE MAZE HUNT~",0       ;game ki screen wale msgs
maze_instructions BYTE "Find the exit and collect coins (*)!",0
maze_returningMsg BYTE "Returning To Game Menu...",0
maze_proceedingMsg BYTE "Proceeding To Maze Game...",0

;welcome screen k msgs
maze_welcomeTitle BYTE  "|-------------------------------------------------------|",0
maze_welcomeTitle2 BYTE "|             WELCOME TO MAZE TREASURE HUNT!            |",0
maze_welcomeTitle3 BYTE "|-------------------------------------------------------|",0
maze_welcomePrompt BYTE "|           Press R To Return To The Game Menu          |",0
maze_welcomePrompt2 BYTE"|                           or                          |",0
maze_welcomePrompt3 BYTE "|           Press P To Proceed To The Maze Game         |",0
maze_welcomePrompt4 BYTE "|-------------------------------------------------------|",0

mini_maze BYTE "|------------------|"   ;welcome screen ki animation keliye
          BYTE "|*     *    *      |"  
          BYTE "| |--| |--| |--|   |"  
          BYTE "|*     *    *      |"  
          BYTE "| |--| |--| |--|   |"  
          BYTE "|*     *    *      |"  
          BYTE "| |--| |--| |--|   |"  
          BYTE "|@                 |"  
          BYTE "|------------------|"  

mini_playerRow DWORD 7       ;current pos of the player (in animation)
mini_playerCol DWORD 1      ;relative to the maze
mini_old_playerRow DWORD 7      ;poorani pos
mini_old_playerCol DWORD 1

mazeStartRow DWORD ?        ;starting pos (screen size k hisaab se)
mazeStartCol DWORD ?

gameOverLine1 BYTE "  ________                        ________                     ",0
gameOverLine2 BYTE " /  _____/_____    _____   ____   \_____  \___  __ ___________ ",0
gameOverLine3 BYTE "/   \  ___\__  \  /     \_/ __ \   /   |   \  \/ // __ \_  __ \",0
gameOverLine4 BYTE "\    \_\  \/ __ \|  Y Y  \  ___/  /    |    \   /\  ___/|  | \/",0
gameOverLine5 BYTE " \______  (____  /__|_|  /\___  > \_______  /\_/  \___  >__|   ",0
gameOverLine6 BYTE "        \/     \/      \/     \/          \/          \/       ",0

gameOverLines DWORD gameOverLine1, gameOverLine2, gameOverLine3, gameOverLine4, gameOverLine5, gameOverLine6
gameOverRows BYTE -8, -7, -6, -5, -4, -3    ;relative to the center

;coordinates of all the coins in the mini maze
mini_positions DWORD 1,1, 1,7, 1,12, 3,1, 3,7, 3,12, 5,1, 5,7, 5,12
MINI_POS_COUNT = 9  ;no. of coins

MINI_ROWS = 9       ;dimension of animation wala
MINI_COLS = 20

MAZE_ROWS = 15      ;dimension of real wala
MAZE_COLS = 18

original_maze_data BYTE "       Exit       "
         BYTE "________ _________"
         BYTE "|                |"
         BYTE "|____ _____ ___  |"      ;for resetting the maze (wrna restart krne par full reset nhi ho rha tha)
         BYTE "|*|            | |"
         BYTE "| |   |--      |*|"
         BYTE "| | __|    ___ | |"
         BYTE "| |      *     | |"
         BYTE "| | __   __  __| |"
         BYTE "| |  *   |*      |"
         BYTE "| |   __ |__ | __|"
         BYTE "| |      |   |   |"
         BYTE "    __  __     __|"
         BYTE "|           *    |"
         BYTE "------------------"


maze_data BYTE "       Exit       "
     BYTE "________ _________"
     BYTE "|                |"
     BYTE "|____ _____ ___  |"      ;working wala maze (jo game k doraan modify hoga)
     BYTE "|*|            | |"
     BYTE "| |   |--      |*|"
     BYTE "| | __|    ___ | |"
     BYTE "| |      *     | |"
     BYTE "| | __   __  __| |"
     BYTE "| |  *   |*      |"
     BYTE "| |   __ |__ | __|"
     BYTE "| |      |   |   |"
     BYTE "    __  __     __|"
     BYTE "|           *    |"
     BYTE "------------------"

old_playerRow DWORD ?   ;previous positions of the player for update (clearing)
old_playerCol DWORD ?
maze_playerRow DWORD 12     ;player ki position in the real maze
maze_playerCol DWORD 0
maze_coinsCollected DWORD 0     ;coin ka counter
maze_totalCoins DWORD 6

;game over ki screen wale msgs and instructions of the game
maze_winMsg BYTE "Congratulations! You found the exit!",0
gameOverEndedMsg BYTE "Game ended - you quit the game",0
maze_statsMsg BYTE "Coins: ",0
gameOverCoinsMsg BYTE "Coins Collected: ",0
gameOverReplayMsg BYTE "Press [R] to Play Again",0
gameOverMenuMsg BYTE "Press [M] for Main Menu",0
maze_movePrompt BYTE "Use ARROW KEYS to move, Q to quit to main menu",0
maze_enterText BYTE "Enter ->",0

screenWidth DWORD ?     ;screen k dimensions and center wali cheezein
screenHeight DWORD ?
centerCol DWORD ?
centerRow DWORD ?


.code
MiniToScreen PROC    ; (IN: dh=row, dl=col - relative) (OUT: dh=row, dl=col on screen)
    add dh, BYTE PTR centerRow
    sub dh, MINI_ROWS / 2
    add dh, 3               ;bcoz of the msgs

    add dl, BYTE PTR centerCol
    sub dl, MINI_COLS / 2
    ret
MiniToScreen ENDP

DrawMiniMaze PROC
    mov eax, 14 + (black * 16)  ;maze in yellow colour
    call SetTextColor
    mov ecx,0           ;starting from first row of mini maze
mini_draw_rows:
    mov dh, cl         ; mini row index
    mov dl, 0          ; mini col start
    call MiniToScreen   ;relative coordinates as input and exact as output
    call Gotoxy

    mov edx,0           ;starting from first col of mini maze
mini_draw_cols:
    mov eax,ecx         ;eax = current row
    imul eax,MINI_COLS  ;multiplying with total cols per row and adding current col
    add eax,edx
    mov esi,OFFSET mini_maze
    mov al,[esi+eax]
    call WriteChar      ;wo wala char is printed
    inc edx
    cmp edx,MINI_COLS
    jb mini_draw_cols   ;if any col left print those
    inc ecx
    cmp ecx,MINI_ROWS   ;if any rows left print those
    jb mini_draw_rows
    ret
DrawMiniMaze ENDP

DisplayCenteredText PROC    ;input: edx=row and edx=message offset
    mov ecx, edx        ;saving offset
    call StrLength      ;length in eax
    shr eax, 1          ;half of length
    mov edx, centerCol
    sub edx, eax
    mov dh, bl
    call Gotoxy
    mov edx, ecx        ;restoring offset
    call WriteString
    ret
DisplayCenteredText ENDP

UpdateMiniPlayer PROC
    pushad
    mov dh, BYTE PTR mini_old_playerRow
    mov dl, BYTE PTR mini_old_playerCol
    call MiniToScreen       ;relative coordinates as input and exact as output
    call Gotoxy
    mov al,' '              ;erasing the player's char from the previous pos
    call WriteChar
    
    mov dh, BYTE PTR mini_playerRow     ;printing it at the new pos
    mov dl, BYTE PTR mini_playerCol
    call MiniToScreen
    call Gotoxy
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, "@"
    call WriteChar
    
    mov eax,mini_playerRow          ;updating the previous relative coordinates
    mov mini_old_playerRow,eax
    mov eax,mini_playerCol
    mov mini_old_playerCol,eax
    popad
    ret
UpdateMiniPlayer ENDP

CanMiniMoveTo PROC      ;input: ecx=row     edx=col
    push ebx            ;output: eax=1(can move) / 0(can't movw)
    push esi
    cmp ecx,0               ;checking for out of bounds
    jl mini_cannot_move
    cmp ecx,MINI_ROWS
    jge mini_cannot_move

    cmp edx,0
    jl mini_cannot_move
    cmp edx,MINI_COLS
    jge mini_cannot_move

    mov eax,ecx             ;same thing jo pehle bhi ki thi
    imul eax,MINI_COLS
    add eax,edx
    mov esi,OFFSET mini_maze
    mov bl,[esi+eax]
    cmp bl,'|'              ;agar wahaan wall hai to can't move
    je mini_cannot_move
    cmp bl,'-'
    je mini_cannot_move
    mov eax,1               ;if valid then eax = 1 means can move there
    jmp mini_move_ok
mini_cannot_move:
    mov eax,0               ;wrna eax=0
mini_move_ok:
    pop esi
    pop ebx
    ret
CanMiniMoveTo ENDP

MiniMoveTo PROC         ;input: ecx=target row and edx=target col
    pushad
mini_move_loop:
    call UpdateMiniPlayer   ;update player's current pos

    mov eax,mini_playerRow
    cmp eax,ecx                 ;comparing current with target - first row
    jne mini_move_vertical      ;if not there yet continue vertical movement
    mov eax,mini_playerCol      ;same with col
    cmp eax,edx
    je mini_move_done           ;if already there then it is done

mini_move_vertical:
    mov eax,mini_playerRow      ;comparing current and target rows again
    cmp eax,ecx
    je mini_move_horizontal     ;if same then do horizontal
    jl mini_try_down            ;if current is oopar than the target then go down wrna up
    push ecx                    ;saving target coordinates
    push edx
    mov ecx,mini_playerRow      ;checking if the player can move up
    dec ecx
    mov edx,mini_playerCol
    call CanMiniMoveTo          ;ecx mein row and edx mein col
    pop edx                     ;eax mein output - 1 means can move and 0 means can't
    pop ecx                     ;restoring target coordinates
    cmp eax,1
    jne mini_move_horizontal    ;if can't move up try horizontal
    dec mini_playerRow          ;updating row for moving up
    jmp mini_moved              ;movement hogyi
mini_try_down:
    push ecx
    push edx
    mov ecx,mini_playerRow      ;same for checking down movement
    inc ecx
    mov edx,mini_playerCol
    call CanMiniMoveTo
    pop edx
    pop ecx
    cmp eax,1
    jne mini_move_horizontal
    inc mini_playerRow
    jmp mini_moved              ;movement hogyi
mini_move_horizontal:
    mov eax,mini_playerCol      ;now col wise
    cmp eax,edx                 ;comparing current with target
    jl mini_try_right           ;if current is left of target move right
    push ecx
    push edx                    ;wrna try left
    mov ecx,mini_playerRow
    mov edx,mini_playerCol
    dec edx
    call CanMiniMoveTo          ;returns in eax 1 or 0
    pop edx
    pop ecx
    cmp eax,1
    dec mini_playerCol          ;updating col for movving left
    jmp mini_moved
mini_try_right:
    push ecx                    ;same for right movement
    push edx
    mov ecx,mini_playerRow
    mov edx,mini_playerCol
    inc edx
    call CanMiniMoveTo
    pop edx
    pop ecx
    cmp eax,1
    inc mini_playerCol

mini_moved:                 ;har movement k baad thora delay then next
    mov eax,300
    call Delay
    jmp mini_move_loop
mini_move_done:
    popad
    ret
MiniMoveTo ENDP

CheckForExitKey PROC
    ;input in al - Check if key is 'r', 'R', 'p', or 'P'
    ; Returns:Zero Flag - 1 if exit key and 0 if not
    cmp al, 'r'
    je exit_key_found
    cmp al, 'R'
    je exit_key_found  
    cmp al, 'p'
    je exit_key_found
    cmp al, 'P'
    je exit_key_found
    ret                ; ZF not set - not exit key
exit_key_found:
    cmp al, al        ; Set Zero Flag to indicate exit key
    ret
CheckForExitKey ENDP

MoveAndCheck PROC
    ; Parameters: ECX = target row, EDX = target col
    ; Returns: Zero Flag set if exit key was pressed
    call MiniMoveTo     ;ecx mein target row and edx mein target col
    call ReadKey
    jz no_key          ; No key pressed - ZF set
    call CheckForExitKey    ;setting or clearing zf flag
    jz exit_found      ; Exit key pressed - ZF set
no_key:
    or al, 1         ; Clear Zero Flag - continue
    ret
exit_found:
    test al, 0         ; Set Zero Flag - exit
    ret
MoveAndCheck ENDP

AutoMiniTraverse PROC       ;output: al (konsi key is pressed)
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
mini_traverse_forever:
    mov mini_playerRow, 7       ;resetting player pos after every animation
    mov mini_playerCol, 1
    mov mini_old_playerRow, 7
    mov mini_old_playerCol, 1

    call DrawMiniMaze

    mov esi, OFFSET mini_positions  ;looping through all the coordinates of the coins
    mov edi, MINI_POS_COUNT         ;total coins
    
position_loop:
    mov ecx, [esi]        ; Get row from array
    mov edx, [esi+4]      ; Get col from array
    add esi, 8            ; Move to next coordinate
    
    call MoveAndCheck     ;ecx and edx has target coordinates and output in zf - if 1 valid key is pressed
    jz exit_with_key      ; Exit if key was pressed
    dec edi
    jnz position_loop     ; Continue with next position

    mov eax, 2000         ;delay after every animation
    call Delay

    call ReadKey
    jz mini_traverse_forever  ; No key, restart traversal
    
    call CheckForExitKey
    jz exit_with_key          ; Exit key pressed
    
    jmp mini_traverse_forever ; Restart traversal

exit_with_key:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

AutoMiniTraverse ENDP

Maze_WelcomeScreen PROC     ;output: eax=0 (return) / 1 (proceed)
    call Clrscr
    call GetMaxXY           ;setting screen size relating cheezein
    movzx eax, ax
    mov screenHeight, eax
    movzx edx, dx
    mov screenWidth, edx
    shr eax, 1
    mov centerRow, eax
    shr edx, 1
    mov centerCol, edx

    mov eax, 13 + (black * 16)      ;light magenta for ----
    call SetTextColor
    mov bl, BYTE PTR centerRow
    sub bl, 10
    mov edx, OFFSET maze_welcomeTitle
    call DisplayCenteredText        ;ebx mein row and edx mein offset
    add bl, 2
    mov edx, OFFSET maze_welcomeTitle3
    call DisplayCenteredText
    add bl, 4
    mov edx, OFFSET maze_welcomePrompt4
    call DisplayCenteredText

    mov eax, 14 + (black * 16)      ;yellow for title
    call SetTextColor
    mov bl, BYTE PTR centerRow
    sub bl, 9
    mov edx, OFFSET maze_welcomeTitle2
    call DisplayCenteredText

    mov eax, 7 + (black * 16)       ;light gray for instructions
    call SetTextColor
    add bl, 2
    mov edx, OFFSET maze_welcomePrompt
    call DisplayCenteredText
    inc bl
    mov edx, OFFSET maze_welcomePrompt2
    call DisplayCenteredText
    inc bl
    mov edx, OFFSET maze_welcomePrompt3
    call DisplayCenteredText

    mov eax, white + (black * 16)
    call SetTextColor

    call AutoMiniTraverse       ;al mein konsi key is pressed as output

    cmp al, 'r'
    je maze_returnToMain
    cmp al, 'R'
    je maze_returnToMain
    cmp al, 'p'
    je maze_proceed
    cmp al, 'P'
    je maze_proceed

maze_returnToMain:
    mov bl, BYTE PTR centerRow
    add bl, 10
    mov eax, 11 + (black * 16)  ; Cyan
    call SetTextColor
    mov edx, OFFSET maze_returningMsg
    call DisplayCenteredText
    mov eax, 800
    call Delay
    mov eax, white + (black * 16)
    call SetTextColor
    mov eax, 0              ;0 means back to main menu
    ret

maze_proceed:
    mov bl, BYTE PTR centerRow
    add bl, 10
    mov eax, 10 + (black * 16)  ; Green
    call SetTextColor
    mov edx, OFFSET maze_proceedingMsg
    call DisplayCenteredText
    mov eax, 800
    call Delay
    mov eax, 1          ;1 means proceed to the game
    ret
Maze_WelcomeScreen ENDP

UpdateStatsDisplay PROC
    pushad
    mov eax, 14 + (black * 16)      ;Yellow
    call SetTextColor
    mov bl, 5
    mov edx, OFFSET maze_statsMsg
    call DisplayCenteredText        ;ebx mein row and edx mein offset
    
    mov eax, maze_coinsCollected
    call WriteDec
    mov al, '/'
    call WriteChar
    mov eax, maze_totalCoins
    call WriteDec
    
    popad
    ret
UpdateStatsDisplay ENDP

UpdateDisplay PROC
    pushad
    mov eax, old_playerRow      ;if player is at the previous position still to kuch nhi krna
    cmp eax, maze_playerRow
    jne positionsChanged
    mov eax, old_playerCol
    cmp eax, maze_playerCol
    je updateDone

positionsChanged:
    mov ecx, old_playerRow
    mov edx, old_playerCol
    mov eax, mazeStartRow
    add eax, ecx
    mov dh, al
    mov eax, mazeStartCol
    add eax, edx
    mov dl, al
    call Gotoxy             ;go to the previous position and draw the maze char
    mov eax, white + (black * 16)
    call SetTextColor
    mov eax, old_playerRow 
    imul eax, MAZE_COLS
    add eax, old_playerCol
    mov esi, OFFSET maze_data
    mov al, [esi + eax]
    call WriteChar

    mov ecx, maze_playerRow
    mov edx, maze_playerCol
    mov eax, mazeStartRow
    add eax, ecx
    mov dh, al
    mov eax, mazeStartCol       ;printing player char at the current pos
    add eax, edx
    mov dl, al
    call Gotoxy
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, '@'
    call WriteChar

    mov eax, maze_playerRow     ;upddating previous pos
    mov old_playerRow, eax
    mov eax, maze_playerCol
    mov old_playerCol, eax
updateDone:
    popad
    ret
UpdateDisplay ENDP

TreasureHuntMaze PROC
    call Maze_WelcomeScreen     ;eax mein output - 0 means waapis main and 1 means game khelna hai
    cmp eax, 0
    je maze_returnToMainMenu
    call ResetMazeGame          ;game khelna hai to ye sb krna hoga
    call Maze_DrawMaze
    call Maze_GameLoop
maze_returnToMainMenu:
    ret
TreasureHuntMaze ENDP

ResetMazeGame PROC
    mov maze_playerRow, 12      ;resetting the player's starting pos after every game
    mov maze_playerCol, 0
    mov old_playerRow, 12
    mov old_playerCol, 0
    mov maze_coinsCollected, 0
    mov esi, OFFSET original_maze_data
    mov edi, OFFSET maze_data
    mov ecx, MAZE_ROWS * MAZE_COLS      ;total character count (bytes)
    rep movsb                           ;copy taht many bytes from esi to edi
    ret
ResetMazeGame ENDP

Maze_DrawMaze PROC
    call Clrscr

    mov eax, centerRow          ;calculating where to start drawing the maze
    sub eax, MAZE_ROWS / 2
    mov mazeStartRow, eax
    
    mov edx, centerCol
    sub edx, MAZE_COLS / 2
    mov mazeStartCol, edx

    mov eax, 14 + (black * 16)  ; Yellow for title
    call SetTextColor
    mov bl, 1
    mov edx, OFFSET maze_gameTitle
    call DisplayCenteredText        ;ebx mein row and edx mein offset
    
    mov eax, 11 + (black * 16)  ; Cyan for instructions
    call SetTextColor
    mov bl, 3
    mov edx, OFFSET maze_instructions
    call DisplayCenteredText
    
    call UpdateStatsDisplay

    mov eax, white + (black * 16)
    call SetTextColor

    mov ecx, 0          ;starting from row 0 of maze
maze_drawRows:
    mov eax, mazeStartRow
    add eax, ecx                ;adding for exact row (for every row)
    mov dh, al
    mov eax, mazeStartCol
    mov dl, al
    call Gotoxy
    
    mov edx, 0          ;starting from col 0 of maze
maze_drawCols:
    mov eax, ecx                ;current row
    cmp eax, maze_playerRow     ;if player is on this coordinate, print @
    jne maze_notPlayer
    mov eax, edx
    cmp eax, maze_playerCol
    jne maze_notPlayer
    mov al, '@'
    call WriteChar
    jmp maze_nextCol

maze_notPlayer:
    push ecx
    push edx
    mov eax, ecx                ;eax = current row
    imul eax, MAZE_COLS         ;multiplying by total col per row
    add eax, edx                ;adding current col
    mov esi, OFFSET maze_data
    mov al, [esi + eax]         ;wo wala char is printed
    call WriteChar
    pop edx
    pop ecx
maze_nextCol:
    inc edx                 ;next col if any left
    cmp edx, MAZE_COLS
    jb maze_drawCols
    
    inc ecx                 ;next row if any left
    cmp ecx, MAZE_ROWS
    jb maze_drawRows

    mov eax, mazeStartRow       ;printing Enter -> to the left of the maze by the enterance
    add eax, 12
    mov dh, al
    mov eax, mazeStartCol
    sub eax, 9
    mov dl, al
    call Gotoxy
    mov eax, 7 + (black * 16)  ; Light Gray
    call SetTextColor
    mov edx, OFFSET maze_enterText  
    call WriteString

    mov eax, 13 + (black * 16)  ; Magenta for controls
    call SetTextColor
    mov eax, screenHeight
    sub eax, 5
    mov bl, al
    mov edx, OFFSET maze_movePrompt
    call DisplayCenteredText

    ret
Maze_DrawMaze ENDP

Maze_CheckExit PROC             ;output: eax=1 (at exit) / 0 (not yet)
    mov eax, maze_playerRow
    cmp eax, 1                  ;checking if the player is 1 row below below EXIT
    jne maze_notAtExit
    mov eax, maze_playerCol
    cmp eax, 8                  ;left boundary wall
    jb maze_notAtExit
    cmp eax, 10                 ;right boundary wall
    ja maze_notAtExit
    
    mov maze_playerRow, 0       ;move player to the first row of maze
    call UpdateDisplay
    mov eax, 1000
    call Delay
    mov eax, 1                  ;1 means player won
    call ShowGameOverScreen
    mov eax, 1                  ;1 means exit reached
    ret
maze_notAtExit:
    mov eax, 0                  ;0 means not yet
    ret
Maze_CheckExit ENDP

Maze_TryMove PROC       ;input: ecx=target row and edx=target col
    push ecx            ;output: eax=1(game complete) / 0 (continue)
    push edx
    cmp ecx, 0              ;checking if target row is out of bounds
    jl nope_and_bye         ;<0 or >=MAZE_ROWS      invalid
    cmp ecx, MAZE_ROWS
    jge nope_and_bye 
    cmp edx, 0              ;same with col
    jl nope_and_bye 
    cmp edx, MAZE_COLS
    jge nope_and_bye 
    
    cmp ecx, 0                  ;for exit
    jne maze_checkWalls
    mov eax, maze_playerRow     ;if player is not at the second row it is invalid
    cmp eax, 1
    jne nope_and_bye 
    mov eax, maze_playerCol     ;opening keliye bhi
    cmp eax, 9
    jne nope_and_bye 
    
maze_checkWalls:
    mov eax, ecx            ;eax = target row
    imul eax, MAZE_COLS     ;wohi cheez to get character
    add eax, edx
    mov esi, OFFSET maze_data
    mov bl, [esi + eax]
    cmp bl, '|'             ;checking the inside walls
    je nope_and_bye 
    cmp bl, '_'
    je nope_and_bye 
    cmp bl, '-'
    je nope_and_bye 
    cmp bl, '*'             ;if coin mila then erase that coin
    jne maze_movePlayer
    mov BYTE PTR [esi + eax], ' '
    inc maze_coinsCollected         ;increment the coin counter

    call UpdateStatsDisplay     ;draw the tile with space now and update the coin counter display

maze_movePlayer:                ;update player pos
    mov maze_playerRow, ecx
    mov maze_playerCol, edx
    call Maze_CheckExit         ;output in eax 1 means at exit and 0 means not yet
    cmp eax, 1                  ;player won - game complete (exit pr pohunch gaye)
    je nope_and_bye             ;abhi exit pr nhi pohunche
    call UpdateDisplay          ;redrawing the player's char at new pls
    jmp nope_and_bye 

nope_and_bye:
    pop edx
    pop ecx
    ret
Maze_TryMove ENDP

Maze_GameLoop PROC
maze_mainLoop:
    mov eax, 10             ;har movement k baad thora sa delay
    call Delay
    call ReadKey
    jz maze_mainLoop
    cmp al, 0
    je maze_extendedKey
    cmp al, 'q'
    je maze_quitToGameOver
    cmp al, 'Q'
    je maze_quitToGameOver
    jmp maze_mainLoop
    
maze_extendedKey:
    cmp ah, 48h             ;up
    je maze_moveUp
    cmp ah, 50h             ;down
    je maze_moveDown
    cmp ah, 4Bh             ;left
    je maze_moveLeft
    cmp ah, 4Dh             ;right
    je maze_moveRight
    jmp maze_mainLoop
    
maze_moveUp:
    mov ecx, maze_playerRow     ;update pos accordingly
    dec ecx
    mov edx, maze_playerCol
    jmp try_move

maze_moveDown:
    mov ecx, maze_playerRow
    inc ecx
    mov edx, maze_playerCol
    jmp try_move

maze_moveLeft:
    mov ecx, maze_playerRow
    mov edx, maze_playerCol
    dec edx
    jmp try_move

maze_moveRight:
    mov ecx, maze_playerRow
    mov edx, maze_playerCol
    inc edx

try_move:
    call Maze_TryMove       ;ecx and edx mein target coordinates
    cmp eax, 1              ;eax mein output: 1 means game complete and 0 means continue
    je maze_gameCompleted
    jmp maze_mainLoop

maze_quitToGameOver:
    mov eax, 0                  ;input in eax  - 1 means won and 0 means quit
    call ShowGameOverScreen     ;output in eax (0 means return to main)
    ret

maze_gameCompleted:
    ret
Maze_GameLoop ENDP

ShowGameOverScreen PROC     ;input: eax=1 (won) / 0(quit)
    push eax
    mov eax, 500
    call Delay
    call Clrscr

    mov eax, 12 + (black * 16)  ; Red for game over title
    call SetTextColor
    mov esi, 0
game_over_loop:
    mov bl, BYTE PTR centerRow
    add bl, gameOverRows[esi]       ;it has offset according to the center row
    mov edx, gameOverLines[esi * 4]
    call DisplayCenteredText        ;ebx mein row and edx mein offset
    inc esi
    cmp esi, 6
    jb game_over_loop

    pop eax
    cmp eax, 1          ;1 means win
    jne player_quit     ;wrna quit
    
    mov eax, 10 + (black * 16)  ; Green for win message
    call SetTextColor
    mov bl, BYTE PTR centerRow
    add bl, 1
    mov edx, OFFSET maze_winMsg
    call DisplayCenteredText
    jmp display_coins
    
player_quit:
    mov eax, 14 + (black * 16)  ; Yellow for quit message
    call SetTextColor
    mov bl, BYTE PTR centerRow
    add bl, 1
    mov edx, OFFSET gameOverEndedMsg
    call DisplayCenteredText

display_coins:
    mov eax, 7 + (black * 16)  ; Light Gray for coins
    call SetTextColor
    mov bl, BYTE PTR centerRow
    add bl, 3
    mov edx, OFFSET gameOverCoinsMsg
    call DisplayCenteredText
    
    mov eax, maze_coinsCollected
    call WriteDec
    mov al, '/'
    call WriteChar
    mov eax, maze_totalCoins
    call WriteDec

    mov eax, 11 + (black * 16)  ; Cyan for replay option
    call SetTextColor
    mov bl, BYTE PTR centerRow
    add bl, 5
    mov edx, OFFSET gameOverReplayMsg
    call DisplayCenteredText

    mov eax, 14 + (black * 16)  ; Yellow for menu option
    call SetTextColor
    inc bl
    mov edx, OFFSET gameOverMenuMsg
    call DisplayCenteredText


game_over_input:
    call ReadChar
    cmp al, 'r'
    je replay_game
    cmp al, 'R'
    je replay_game
    cmp al, 'm'
    je back_to_menu
    cmp al, 'M'
    je back_to_menu
    jmp game_over_input

replay_game:
    mov eax, white + (black * 16)
    call SetTextColor
    mov eax, 500
    call delay
    call ResetMazeGame
    call Maze_DrawMaze
    call Maze_GameLoop
    ret

back_to_menu:
    mov eax, 500
    call delay
    call Clrscr
    mov eax, white + (black * 16)
    call SetTextColor
    mov eax, 0
    ret
ShowGameOverScreen ENDP

END
