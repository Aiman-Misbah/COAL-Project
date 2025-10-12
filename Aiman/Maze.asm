INCLUDE Irvine32.inc

.data
old_playerRow DWORD ?
old_playerCol DWORD ?

maze_gameTitle BYTE "MINI TREASURE MAZE HUNT",0
maze_instructions BYTE "Use ARROW KEYS to move. Find the exit and collect coins (*)!",0
maze_instructions2 BYTE "Press Q to quit to main menu.",0
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

maze_winMsg BYTE "Congratulations! You found the exit! Coins collected: ",0
maze_quitMsg BYTE "Returning to main menu...",0
maze_statsMsg BYTE "Coins: ",0
maze_exitMsg BYTE "Exit: (top center opening)",0
maze_movePrompt BYTE "Use ARROW KEYS to move, Q to quit to main menu",0
maze_enterText BYTE "Enter ->",0

maze_centerPos DWORD ?

.code

DrawMiniMaze PROC
    pushad
    mov eax, 10 + (black * 16)
    call SetTextColor
    mov ecx,0
mini_draw_rows:
    mov dh,cl
    add dh, 13
    mov dl, 49
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

UpdateMiniPlayer PROC
    pushad
    mov dh,BYTE PTR mini_old_playerRow
    add dh, 13
    mov dl,BYTE PTR mini_old_playerCol
    add dl, 49
    call Gotoxy
    mov al,' '
    call WriteChar
    mov dh,BYTE PTR mini_playerRow
    add dh, 13
    mov dl,BYTE PTR mini_playerCol
    add dl, 49
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

AutoMiniTraverse PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
mini_traverse_forever:
    mov mini_playerRow,7
    mov mini_playerCol,1
    mov mini_old_playerRow,7
    mov mini_old_playerCol,1

    call DrawMiniMaze
    call UpdateMiniPlayer

    mov ecx,1
    mov edx,1
    call MiniMoveTo
    call ReadKey
    jz mini_check1_done
    cmp al, 'r'
    je exit_mini_traverse
    cmp al, 'R'
    je exit_mini_traverse
    cmp al, 'p'
    je exit_mini_traverse
    cmp al, 'P'
    je exit_mini_traverse
mini_check1_done:
    mov ecx,1
    mov edx,7
    call MiniMoveTo
    call ReadKey
    jz mini_check2_done
    cmp al, 'r'
    je exit_mini_traverse
    cmp al, 'R'
    je exit_mini_traverse
    cmp al, 'p'
    je exit_mini_traverse
    cmp al, 'P'
    je exit_mini_traverse
mini_check2_done:
    mov ecx,1
    mov edx,13
    call MiniMoveTo
    call ReadKey
    jz mini_check3_done
    cmp al, 'r'
    je exit_mini_traverse
    cmp al, 'R'
    je exit_mini_traverse
    cmp al, 'p'
    je exit_mini_traverse
    cmp al, 'P'
    je exit_mini_traverse
mini_check3_done:
    mov ecx,3
    mov edx,1
    call MiniMoveTo
    call ReadKey
    jz mini_check4_done
    cmp al, 'r'
    je exit_mini_traverse
    cmp al, 'R'
    je exit_mini_traverse
    cmp al, 'p'
    je exit_mini_traverse
    cmp al, 'P'
    je exit_mini_traverse
mini_check4_done:
    mov ecx,3
    mov edx,7
    call MiniMoveTo
    call ReadKey
    jz mini_check5_done
    cmp al, 'r'
    je exit_mini_traverse
    cmp al, 'R'
    je exit_mini_traverse
    cmp al, 'p'
    je exit_mini_traverse
    cmp al, 'P'
    je exit_mini_traverse
mini_check5_done:
    mov ecx,3
    mov edx,13
    call MiniMoveTo
    call ReadKey
    jz mini_check6_done
    cmp al, 'r'
    je exit_mini_traverse
    cmp al, 'R'
    je exit_mini_traverse
    cmp al, 'p'
    je exit_mini_traverse
    cmp al, 'P'
    je exit_mini_traverse
mini_check6_done:
    mov ecx,5
    mov edx,1
    call MiniMoveTo
    call ReadKey
    jz mini_check7_done
    cmp al, 'r'
    je exit_mini_traverse
    cmp al, 'R'
    je exit_mini_traverse
    cmp al, 'p'
    je exit_mini_traverse
    cmp al, 'P'
    je exit_mini_traverse
mini_check7_done:
    mov ecx,5
    mov edx,7
    call MiniMoveTo
    call ReadKey
    jz mini_check8_done
    cmp al, 'r'
    je exit_mini_traverse
    cmp al, 'R'
    je exit_mini_traverse
    cmp al, 'p'
    je exit_mini_traverse
    cmp al, 'P'
    je exit_mini_traverse
mini_check8_done:
    mov ecx,5
    mov edx,13
    call MiniMoveTo
    call ReadKey
    jz mini_check9_done
    cmp al, 'r'
    je exit_mini_traverse
    cmp al, 'R'
    je exit_mini_traverse
    cmp al, 'p'
    je exit_mini_traverse
    cmp al, 'P'
    je exit_mini_traverse
mini_check9_done:
    mov eax,2000
    call Delay

    call ReadKey
    jz mini_traverse_forever
    cmp al, 'r'
    je exit_mini_traverse
    cmp al, 'R'
    je exit_mini_traverse
    cmp al, 'p'
    je exit_mini_traverse
    cmp al, 'P'
    je exit_mini_traverse
    jmp mini_traverse_forever

exit_mini_traverse:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
AutoMiniTraverse ENDP


Maze_WelcomeScreen PROC
    call Clrscr
    mov eax, black
    call SetTextColor
    call Clrscr

    mov eax, 13 + (black * 16)
    call SetTextColor
    mov dh, 5
    mov dl, 31
    call Gotoxy
    mov edx, OFFSET maze_welcomeTitle
    call WriteString

    mov dh, 7
    mov dl, 31
    call Gotoxy
    mov edx, OFFSET maze_welcomeTitle3
    call WriteString

    mov eax, 11 + (black * 16)
    call SetTextColor
    mov dh, 6
    mov dl, 31
    call Gotoxy
    mov edx, OFFSET maze_welcomeTitle2
    call WriteString

    mov dh, 8
    mov dl, 31
    call Gotoxy
    mov edx, OFFSET maze_welcomePrompt
    mov eax, white + (black * 16)
call SetTextColor
    call WriteString

    mov dh, 11
    mov dl, 31
    call Gotoxy
    mov edx, OFFSET maze_welcomePrompt4
    call WriteString

    mov dh, 9
    mov dl, 31
    call Gotoxy
    mov edx, OFFSET maze_welcomePrompt2
    call WriteString

    mov dh, 10
    mov dl, 31
    call Gotoxy
    mov edx, OFFSET maze_welcomePrompt3
    call WriteString

    mov dh, 8
    mov dl, 49
    call Gotoxy
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov al, 'R'
    call WriteChar

    mov dh, 10
    mov dl, 49
    call Gotoxy
    mov eax, green + (black * 16)
    call SetTextColor
    mov al, 'P'
    call WriteChar

    mov eax, white + (black * 16)
    call SetTextColor

    ; --- Mini maze runs exactly as before ---
    call AutoMiniTraverse

    ; --- Now handle key press immediately ---
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
    mov dh, 23
    mov dl, 47
    call Gotoxy
    mov eax, 3 + (black * 16)
    call SetTextColor
    mov edx, OFFSET maze_returningMsg
    call WriteString
    mov eax, 1500
    call Delay
    ; Reset color back to light gray on black
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov eax, 0
    ret

maze_proceed:
    mov dh, 23
    mov dl, 47
    call Gotoxy
    mov eax, 10 + (black * 16)
    call SetTextColor
    mov edx, OFFSET maze_proceedingMsg
    call WriteString
    mov eax, 1500
    call Delay
    ; Reset color back to light gray on black
    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov eax, 1
    ret

Maze_WelcomeScreen ENDP



DrawSingleTile PROC
    pushad
    mov eax, ecx
    add eax, 8
    mov dh, al
    mov eax, maze_centerPos
    add eax, edx
    mov dl, al
    call Gotoxy
    mov eax, ecx
    cmp eax, maze_playerRow
    jne drawMazeTile
    mov eax, edx
    cmp eax, maze_playerCol
    jne drawMazeTile
    mov al, '@'
    call WriteChar
    jmp drawDone
drawMazeTile:
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
    mov dh, 4
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET maze_statsMsg
    call WriteString
    mov eax, maze_coinsCollected
    call WriteDec
    mov al, '/'
    call WriteChar
    mov eax, maze_totalCoins
    call WriteDec
    mov ecx, 15
clearStatsLine:
    mov al, ' '
    call WriteChar
    loop clearStatsLine
    mov dh, BYTE PTR MAZE_ROWS
    add dh, 9
    mov dl, 0
    call Gotoxy
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
    mov eax, ecx
    add eax, 8
    mov dh, al
    mov eax, maze_centerPos
    add eax, edx
    mov dl, al
    call Gotoxy
    mov eax, old_playerRow
    imul eax, MAZE_COLS
    add eax, old_playerCol
    mov esi, OFFSET maze_data
    mov al, [esi + eax]
    call WriteChar
    mov ecx, maze_playerRow
    mov edx, maze_playerCol
    mov eax, ecx
    add eax, 8
    mov dh, al
    mov eax, maze_centerPos
    add eax, edx
    mov dl, al
    call Gotoxy
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
    mov edx, OFFSET maze_gameTitle
    call WriteString
    call Crlf
    mov edx, OFFSET maze_instructions
    call WriteString
    call Crlf
    mov edx, OFFSET maze_instructions2
    call WriteString
    call Crlf
    call Crlf
    mov edx, OFFSET maze_statsMsg
    call WriteString
    mov eax, maze_coinsCollected
    call WriteDec
    mov al, '/'
    call WriteChar
    mov eax, maze_totalCoins
    call WriteDec
    call Crlf
    mov edx, OFFSET maze_exitMsg
    call WriteString
    call Crlf
    call Crlf
    mov eax, 80
    sub eax, MAZE_COLS
    shr eax, 1
    mov maze_centerPos, eax
    mov dh, 12
    add dh, 8
    mov eax, maze_centerPos
    sub eax, 9
    mov dl, al
    call Gotoxy
    mov edx, OFFSET maze_enterText
    call WriteString
    mov ecx, 0
maze_drawRows:
    mov dh, cl
    add dh, 8
    mov dl, BYTE PTR maze_centerPos
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
    call Crlf
    inc ecx
    cmp ecx, MAZE_ROWS
    jb maze_drawRows
    mov dh, BYTE PTR MAZE_ROWS
    add dh, 9
    mov dl, 0
    call Gotoxy
    mov edx, OFFSET maze_movePrompt
    call WriteString
    call Crlf
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
    call Clrscr
    call Maze_DrawMaze
    call Crlf
    mov edx, OFFSET maze_winMsg
    call WriteString
    mov eax, maze_coinsCollected
    call WriteDec
    mov al, '/'
    call WriteChar
    mov eax, maze_totalCoins
    call WriteDec
    call Crlf
    call ClearKeyboardBuffer
    call WaitMsg
    mov eax, 1
    ret
maze_notAtExit:
    mov eax, 0
    ret
Maze_CheckExit ENDP

ClearKeyboardBuffer PROC
clearLoop:
    call ReadKey
    jz bufferEmpty
    jmp clearLoop
bufferEmpty:
    ret
ClearKeyboardBuffer ENDP

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
    je maze_quitToMenu
    cmp al, 'Q'
    je maze_quitToMenu
    cmp al, 1Bh
    je maze_quitToMenu
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
    call Maze_TryMove
    cmp eax, 1
    je maze_quitToMenu
    jmp maze_mainLoop
maze_moveDown:
    mov ecx, maze_playerRow
    inc ecx
    mov edx, maze_playerCol
    call Maze_TryMove
    cmp eax, 1
    je maze_quitToMenu
    jmp maze_mainLoop
maze_moveLeft:
    mov ecx, maze_playerRow
    mov edx, maze_playerCol
    dec edx
    call Maze_TryMove
    cmp eax, 1
    je maze_quitToMenu
    jmp maze_mainLoop
maze_moveRight:
    mov ecx, maze_playerRow
    mov edx, maze_playerCol
    inc edx
    call Maze_TryMove
    cmp eax, 1
    je maze_quitToMenu
    jmp maze_mainLoop
maze_quitToMenu:
    call Clrscr
    mov edx, OFFSET maze_quitMsg
    call WriteString
    call Crlf
    call WaitMsg
    ret
Maze_GameLoop ENDP

END
