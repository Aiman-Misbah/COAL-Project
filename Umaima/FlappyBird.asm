; ==================== GENERIC CONFIRMATION ====================
GenericConfirmation PROC
    ; Input: EBX = message row, EDX = confirm message offset
    ; Returns: gameRestart = 0 (quit), 1 (no), 2 (show countdown)
    pushad
    
    ; Check if we're in game over context (boxTop is set)
    mov eax, boxTop
    cmp eax, 0
    jg GameOverContext
    
    ; Normal game context - draw game screen
    call DrawGame
    jmp DisplayMessages
    
GameOverContext:
    ; Game over context - DON'T redraw, just display messages on existing screen
    ; The game over screen is already drawn, just add confirmation messages
    
DisplayMessages:
    ; Display confirmation messages
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
    ; Show quitting animation
    mov eax, boxTop
    cmp eax, 0
    jg GameOverQuit
    
    ; Normal game quit
    call DrawGame
    mov edx, OFFSET quitMsg
    call DisplayBelowMessage
    call DotAnimation
    mov gameRestart, 0
    jmp DoneConfirmation
    
GameOverQuit:
    ; Game over quit - redraw game over screen first, then show message
    call DrawGameOver
    mov ebx, boxTop
    add ebx, 10
    mov edx, OFFSET quitMsg
    call CenterText
    call DotAnimation
    mov gameRestart, 0
    jmp DoneConfirmation

ConfirmNo:
    ; Show resuming message with animation
    mov eax, boxTop
    cmp eax, 0
    jg GameOverNo
    
    ; Normal game - resume with countdown
    call DrawGame
    mov edx, OFFSET resumingMsg
    call DisplayBelowMessage
    call DotAnimation
    mov gameRestart, 2
    jmp DoneConfirmation
    
GameOverNo:
    ; Game over - just redraw the game over screen (no animation needed)
    call DrawGameOver
    mov gameRestart, 1

DoneConfirmation:
    popad
    ret
GenericConfirmation ENDP
