INCLUDE Irvine32.inc
.data
old_playerRow DWORD ?
old_playerCol DWORD ?

maze_gameTitle BYTE "~MINI TREASURE MAZE HUNT~",0
maze_instructions BYTE "Find the exit and collect coins (*)!",0
maze_returningMsg BYTE "Returning To Game Menu...",0
maze_proceedingMsg BYTE "Proceeding To Maze Game...",0

maze_welcomeTitle BYTE  "|-------------------------------------------------------|",0
maze_welcomeTitle2 BYTE "|             WELCOME TO MAZE TREASURE HUNT!            |",0
maze_welcomeTitle3 BYTE "|-------------------------------------------------------|",0
maze_welcomePrompt BYTE "|           Press R To Return To The Game Menu          |",0
maze_welcomePrompt2 BYTE"|                           or                          |",0
maze_welcomePrompt3 BYTE "|           Press P To Proceed To The Maze Game         |",0
maze_welcomePrompt4 BYTE "|-------------------------------------------------------|",0

mini_maze BYTE "|------------------|"  
          BYTE "|*     *    *      |"  
          BYTE "| |--| |--| |--|   |"  
          BYTE "|*     *    *      |"  
          BYTE "| |--| |--| |--|   |"  
          BYTE "|*     *    *      |"  
          BYTE "| |--| |--| |--|   |"  
          BYTE "|@                 |"  
          BYTE "|------------------|"  

mini_playerRow DWORD 7
mini_playerCol DWORD 1
mini_old_playerRow DWORD 7
mini_old_playerCol DWORD 1

mazeStartRow DWORD ?
mazeStartCol DWORD ?

gameOverLine1 BYTE "  ________                        ________                     ",0
gameOverLine2 BYTE " /  _____/_____    _____   ____   \_____  \___  __ ___________ ",0
gameOverLine3 BYTE "/   \  ___\__  \  /     \_/ __ \   /   |   \  \/ // __ \_  __ \",0
gameOverLine4 BYTE "\    \_\  \/ __ \|  Y Y  \  ___/  /    |    \   /\  ___/|  | \/",0
gameOverLine5 BYTE " \______  (____  /__|_|  /\___  > \_______  /\_/  \___  >__|   ",0
gameOverLine6 BYTE "        \/     \/      \/     \/          \/          \/       ",0

gameOverLines DWORD OFFSET gameOverLine1, OFFSET gameOverLine2, OFFSET gameOverLine3, OFFSET gameOverLine4, OFFSET gameOverLine5, OFFSET gameOverLine6
gameOverRows BYTE -8, -7, -6, -5, -4, -3

mini_positions DWORD 1,1, 1,7, 1,13, 3,1, 3,7, 3,13, 5,1, 5,7, 5,13
MINI_POS_COUNT = 9

MINI_ROWS = 9
MINI_COLS = 20

MAZE_ROWS = 15
MAZE_COLS = 18

original_maze_data BYTE "       Exit       "
         BYTE "________ _________"
         BYTE "|                |"
         BYTE "|____ _____ ___  |"
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
     BYTE "|____ _____ ___  |"
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

maze_playerRow DWORD 12
maze_playerCol DWORD 0
maze_coinsCollected DWORD 0
maze_totalCoins DWORD 6

maze_winMsg BYTE "Congratulations! You found the exit!",0
gameOverEndedMsg BYTE "Game ended - you quit the game",0
maze_statsMsg BYTE "Coins: ",0
maze_movePrompt BYTE "Use ARROW KEYS to move, Q to quit to main menu",0
maze_enterText BYTE "Enter ->",0

gameOverCoinsMsg BYTE "Coins Collected: ",0
gameOverReplayMsg BYTE "Press [R] to Play Again",0
gameOverMenuMsg BYTE "Press [M] for Main Menu",0

screenWidth DWORD ?
screenHeight DWORD ?
centerCol DWORD ?
centerRow DWORD ?


.code

MiniToScreen PROC    ; (IN: dh=row, dl=col) (OUT: dh=row, dl=col on screen)
    add dh, BYTE PTR centerRow
    sub dh, MINI_ROWS / 2
    add dh, 3

    add dl, BYTE PTR centerCol
    sub dl, MINI_COLS / 2
    ret
MiniToScreen ENDP



DrawMiniMaze PROC
    pushad
    mov eax, 14 + (black * 16)
    call SetTextColor
    mov ecx,0
mini_draw_rows:
    mov dh, cl         ; mini row index
    mov dl, 0          ; mini col start
    call MiniToScreen

    call Gotoxy
    mov edx,0
mini_draw_cols:
    mov eax,ecx
    imul eax,MINI_COLS
    add eax,edx
    mov esi,OFFSET mini_maze
    mov al,[esi+eax]
    call WriteChar
    inc edx
    cmp edx,MINI_COLS
    jb mini_draw_cols
    inc ecx
    cmp ecx,MINI_ROWS
    jb mini_draw_rows
    popad
    ret
DrawMiniMaze ENDP

DisplayCenteredText PROC
   
    mov ecx, edx
    call StrLength
    shr eax, 1
    mov edx, centerCol
    sub edx, eax

    mov dh, bl
    call Gotoxy
    mov edx, ecx
    call WriteString

    ret
DisplayCenteredText ENDP

UpdateMiniPlayer PROC
    pushad
    mov dh, BYTE PTR mini_old_playerRow
    mov dl, BYTE PTR mini_old_playerCol
    call MiniToScreen

    call Gotoxy
    mov al,' '
    call WriteChar
    
    mov dh, BYTE PTR mini_playerRow
    mov dl, BYTE PTR mini_playerCol
    call MiniToScreen

    call Gotoxy
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, "@"
    call WriteChar
    
    mov eax,mini_playerRow
    mov mini_old_playerRow,eax
    mov eax,mini_playerCol
    mov mini_old_playerCol,eax
    popad
    ret
UpdateMiniPlayer ENDP

CanMiniMoveTo PROC
    push ebx
    push esi
    cmp ecx,0
    jl mini_cannot_move
    cmp ecx,MINI_ROWS
    jge mini_cannot_move
    cmp edx,0
    jl mini_cannot_move
    cmp edx,MINI_COLS
    jge mini_cannot_move
    mov eax,ecx
    imul eax,MINI_COLS
    add eax,edx
    mov esi,OFFSET mini_maze
    mov bl,[esi+eax]
    cmp bl,'|'
    je mini_cannot_move
    cmp bl,'-'
    je mini_cannot_move
    mov eax,1
    jmp mini_move_ok
mini_cannot_move:
    mov eax,0
mini_move_ok:
    pop esi
    pop ebx
    ret
CanMiniMoveTo ENDP

MiniMoveTo PROC
    pushad
mini_move_loop:
    call UpdateMiniPlayer
    mov eax,mini_playerRow
    cmp eax,ecx
    jne mini_move_vertical
    mov eax,mini_playerCol
    cmp eax,edx
    je mini_move_done
mini_move_vertical:
    mov eax,mini_playerRow
    cmp eax,ecx
    je mini_move_horizontal
    jl mini_try_down
    push ecx
    push edx
    mov ecx,mini_playerRow
    dec ecx
    mov edx,mini_playerCol
    call CanMiniMoveTo
    pop edx
    pop ecx
    cmp eax,1
    jne mini_move_horizontal
    dec mini_playerRow
    jmp mini_moved
mini_try_down:
    push ecx
    push edx
    mov ecx,mini_playerRow
    inc ecx
    mov edx,mini_playerCol
    call CanMiniMoveTo
    pop edx
    pop ecx
    cmp eax,1
    jne mini_move_horizontal
    inc mini_playerRow
    jmp mini_moved
mini_move_horizontal:
    mov eax,mini_playerCol
    cmp eax,edx
    jl mini_try_right
    push ecx
    push edx
    mov ecx,mini_playerRow
    mov edx,mini_playerCol
    dec edx
    call CanMiniMoveTo
    pop edx
    pop ecx
    cmp eax,1
    jne mini_stuck
    dec mini_playerCol
    jmp mini_moved
mini_try_right:
    push ecx
    push edx
    mov ecx,mini_playerRow
    mov edx,mini_playerCol
    inc edx
    call CanMiniMoveTo
    pop edx
    pop ecx
    cmp eax,1
    jne mini_stuck
    inc mini_playerCol
    jmp mini_moved
mini_stuck:
    mov eax,300
    call Delay
    jmp mini_move_loop
mini_moved:
    mov eax,300
    call Delay
    jmp mini_move_loop
mini_move_done:
    popad
    ret
MiniMoveTo ENDP

CheckForExitKey PROC
    ; Check if key is 'r', 'R', 'p', or 'P'
    ; Returns: AL = original key, Zero Flag set if exit key
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
    test al, al        ; Set Zero Flag to indicate exit key
    ret
CheckForExitKey ENDP

MoveAndCheck PROC
    ; Parameters: ECX = row, EDX = col
    ; Returns: Zero Flag set if exit key was pressed
    call MiniMoveTo
    call ReadKey
    jz no_key          ; No key pressed - ZF set
    call CheckForExitKey
    jz exit_found      ; Exit key pressed - ZF set
no_key:
    test al, 1         ; Clear Zero Flag - continue
    ret
exit_found:
    test al, 0         ; Set Zero Flag - exit
    ret
MoveAndCheck ENDP

AutoMiniTraverse PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
mini_traverse_forever:
    ; Reset player position
    mov mini_playerRow, 7
    mov mini_playerCol, 1
    mov mini_old_playerRow, 7
    mov mini_old_playerCol, 1

    call DrawMiniMaze
    call UpdateMiniPlayer

    ; Move through all positions using the array
    mov esi, OFFSET mini_positions
    mov edi, MINI_POS_COUNT
    
position_loop:
    mov ecx, [esi]        ; Get row from array
    mov edx, [esi+4]      ; Get col from array
    add esi, 8            ; Move to next position pair
    
    call MoveAndCheck     ; Move to position and check for exit key
    jz exit_with_key      ; Exit if key was pressed
    
    dec edi
    jnz position_loop     ; Continue with next position

    ; Delay after completing all positions
    mov eax, 2000
    call Delay

    ; Check for exit key one more time
    call ReadKey
    jz mini_traverse_forever  ; No key, restart traversal
    
    call CheckForExitKey
    jz exit_with_key          ; Exit key pressed
    
    jmp mini_traverse_forever ; Restart traversal

exit_with_key:
    ; AL contains the key that was pressed ('r', 'R', 'p', or 'P')
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

exit_mini_traverse:
    ; Fallback exit (shouldn't normally be reached)
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
AutoMiniTraverse ENDP

Maze_WelcomeScreen PROC
    call Clrscr
    call GetMaxXY
    movzx eax, ax
    mov screenHeight, eax
    movzx edx, dx
    mov screenWidth, edx
    shr eax, 1
    mov centerRow, eax
    shr edx, 1
    mov centerCol, edx

    mov eax, black
    call SetTextColor
    call Clrscr

    mov eax, 13 + (black * 16)
    call SetTextColor
    mov bl, BYTE PTR centerRow
    sub bl, 10
    mov edx, OFFSET maze_welcomeTitle
    call DisplayCenteredText
    mov bl, BYTE PTR centerRow
    sub bl, 8
    mov edx, OFFSET maze_welcomeTitle3
    call DisplayCenteredText
    mov bl, BYTE PTR centerRow
    sub bl, 4
    mov edx, OFFSET maze_welcomePrompt4
    call DisplayCenteredText

    ; Yellow text
    mov eax, 14 + (black * 16)
    call SetTextColor
    mov bl, BYTE PTR centerRow
    sub bl, 9
    mov edx, OFFSET maze_welcomeTitle2
    call DisplayCenteredText

    ; Light Gray texts together
    mov eax, 7 + (black * 16)
    call SetTextColor
    mov bl, BYTE PTR centerRow
    sub bl, 7
    mov edx, OFFSET maze_welcomePrompt
    call DisplayCenteredText
    mov bl, BYTE PTR centerRow
    sub bl, 6
    mov edx, OFFSET maze_welcomePrompt2
    call DisplayCenteredText
    mov bl, BYTE PTR centerRow
    sub bl, 5
    mov edx, OFFSET maze_welcomePrompt3
    call DisplayCenteredText

    mov eax, white + (black * 16)
    call SetTextColor

    call AutoMiniTraverse

    cmp al, 'r'
    je maze_returnToMain
    cmp al, 'R'
    je maze_returnToMain
    cmp al, 'p'
    je maze_proceed
    cmp al, 'P'
    je maze_proceed
    ret

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
    mov eax, 0
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
    mov eax, 1
    ret
Maze_WelcomeScreen ENDP

DrawSingleTile PROC
    pushad
    mov eax, mazeStartRow
    add eax, ecx
    mov dh, al
    mov eax, mazeStartCol
    add eax, edx
    mov dl, al
    call Gotoxy
    
    mov eax, ecx
    cmp eax, maze_playerRow
    jne drawMazeTile
    mov eax, edx
    cmp eax, maze_playerCol
    jne drawMazeTile
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, '@'
    call WriteChar
    jmp drawDone
drawMazeTile:
    mov eax, white + (black * 16)
    call SetTextColor
    push ecx
    push edx
    mov eax, ecx
    imul eax, MAZE_COLS
    add eax, edx
    mov esi, OFFSET maze_data
    mov al, [esi + eax]
    call WriteChar
    pop edx
    pop ecx
drawDone:
    popad
    ret
DrawSingleTile ENDP

UpdateStatsDisplay PROC
    pushad
    ; Add color to coins display
    mov eax, 14 + (black * 16)  ; Yellow
    call SetTextColor
    mov bl, 5
    mov edx, OFFSET maze_statsMsg
    call DisplayCenteredText
    
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
    mov eax, old_playerRow
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
    call Gotoxy
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
    mov eax, mazeStartCol
    add eax, edx
    mov dl, al
    call Gotoxy
    mov eax, white + (black * 16)
    call SetTextColor
    mov al, '@'
    call WriteChar

    mov eax, maze_playerRow
    mov old_playerRow, eax
    mov eax, maze_playerCol
    mov old_playerCol, eax
updateDone:
    popad
    ret
UpdateDisplay ENDP

TreasureHuntMaze PROC
    call Maze_WelcomeScreen
    cmp eax, 0
    je maze_returnToMainMenu
    call ResetMazeGame
    call Maze_DrawMaze
    call Maze_GameLoop
maze_returnToMainMenu:
    ret
TreasureHuntMaze ENDP

ResetMazeGame PROC
    mov maze_playerRow, 12
    mov maze_playerCol, 0
    mov old_playerRow, 12
    mov old_playerCol, 0
    mov maze_coinsCollected, 0
    mov esi, OFFSET original_maze_data
    mov edi, OFFSET maze_data
    mov ecx, MAZE_ROWS * MAZE_COLS
    rep movsb
    ret
ResetMazeGame ENDP

Maze_DrawMaze PROC
    call Clrscr

    mov eax, screenHeight
    mov edx, screenWidth
    
    shr eax, 1
    sub eax, MAZE_ROWS / 2
    mov mazeStartRow, eax
    
    shr edx, 1
    sub edx, MAZE_COLS / 2
    mov mazeStartCol, edx


    ; Add colors to game display
    mov eax, 14 + (black * 16)  ; Yellow for title
    call SetTextColor
    mov bl, 1
    mov edx, OFFSET maze_gameTitle
    call DisplayCenteredText
    
    mov eax, 11 + (black * 16)  ; Cyan for instructions
    call SetTextColor
    mov bl, 3
    mov edx, OFFSET maze_instructions
    call DisplayCenteredText
    
    call UpdateStatsDisplay

    mov eax, white + (black * 16)
    call SetTextColor
    mov ecx, 0
maze_drawRows:
    mov eax, mazeStartRow
    add eax, ecx
    mov dh, al
    mov eax, mazeStartCol
    mov dl, al
    call Gotoxy
    
    mov edx, 0
maze_drawCols:
    mov eax, ecx
    cmp eax, maze_playerRow
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
    mov eax, ecx
    imul eax, MAZE_COLS
    add eax, edx
    mov esi, OFFSET maze_data
    mov al, [esi + eax]
    call WriteChar
    pop edx
    pop ecx
maze_nextCol:
    inc edx
    cmp edx, MAZE_COLS
    jb maze_drawCols
    
    inc ecx
    cmp ecx, MAZE_ROWS
    jb maze_drawRows

    mov eax, mazeStartRow
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

Maze_CheckExit PROC
    mov eax, maze_playerRow
    cmp eax, 1
    jne maze_notAtExit
    mov eax, maze_playerCol
    cmp eax, 8
    jb maze_notAtExit
    cmp eax, 10
    ja maze_notAtExit
    
    mov maze_playerRow, 0
    call UpdateDisplay
    mov eax, 1000
    call Delay
    mov eax, 1
    call ShowGameOverScreen
    mov eax, 1
    ret
maze_notAtExit:
    mov eax, 0
    ret
Maze_CheckExit ENDP

Maze_TryMove PROC
    push ecx
    push edx
    cmp ecx, 0
    jl maze_invalidMove
    cmp ecx, MAZE_ROWS
    jge maze_invalidMove
    cmp edx, 0
    jl maze_invalidMove
    cmp edx, MAZE_COLS
    jge maze_invalidMove
    
    cmp ecx, 0
    jne maze_checkWalls
    mov eax, maze_playerRow
    cmp eax, 1
    jne maze_invalidMove
    mov eax, maze_playerCol
    cmp eax, 8
    jb maze_invalidMove
    cmp eax, 10
    ja maze_invalidMove
    jmp maze_movePlayer
    
maze_checkWalls:
    mov eax, ecx
    imul eax, MAZE_COLS
    add eax, edx
    mov esi, OFFSET maze_data
    mov bl, [esi + eax]
    cmp bl, '|'
    je maze_invalidMove
    cmp bl, '_'
    je maze_invalidMove
    cmp bl, '-'
    je maze_invalidMove
    cmp bl, '*'
    jne maze_movePlayer
    mov BYTE PTR [esi + eax], ' '
    inc maze_coinsCollected
    push ecx
    push edx
    call DrawSingleTile
    call UpdateStatsDisplay
    pop edx
    pop ecx

maze_movePlayer:
    mov maze_playerRow, ecx
    mov maze_playerCol, edx
    call Maze_CheckExit
    cmp eax, 1
    je maze_returnToMenu
    call UpdateDisplay
    jmp maze_validMove
maze_returnToMenu:
    pop edx
    pop ecx
    mov eax, 1
    ret
maze_invalidMove:
    pop edx
    pop ecx
    ret
maze_validMove:
    pop edx
    pop ecx
    ret
Maze_TryMove ENDP

Maze_GameLoop PROC
maze_mainLoop:
    mov eax, 10
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
    cmp ah, 48h
    je maze_moveUp
    cmp ah, 50h
    je maze_moveDown
    cmp ah, 4Bh
    je maze_moveLeft
    cmp ah, 4Dh
    je maze_moveRight
    jmp maze_mainLoop
    
maze_moveUp:
    mov ecx, maze_playerRow
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
    call Maze_TryMove
    cmp eax, 1
    je maze_gameCompleted
    jmp maze_mainLoop

maze_quitToGameOver:
    mov eax, 0
    call ShowGameOverScreen
    ret

maze_gameCompleted:
    ret
Maze_GameLoop ENDP

ShowGameOverScreen PROC
    push eax
    
    mov eax, 500
    call Delay
    call Clrscr

    ; Add colors to game over screen
    mov eax, 12 + (black * 16)  ; Red for game over art
call SetTextColor
xor esi, esi
game_over_loop:
    mov bl, BYTE PTR centerRow
    add bl, gameOverRows[esi]
    mov edx, gameOverLines[esi * 4]
    call DisplayCenteredText
    inc esi
    cmp esi, 6
    jb game_over_loop

    pop eax
    cmp eax, 1
    jne player_quit
    
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
    mov bl, BYTE PTR centerRow
    add bl, 6
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
