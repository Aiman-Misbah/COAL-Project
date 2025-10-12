INCLUDE Irvine32.inc

.data
hangman_msg BYTE "Hangman Game - Coming Soon!",0

.code
Hangman PROC
    call Clrscr
    mov edx, OFFSET hangman_msg
    call WriteString
    call Crlf
    call WaitMsg
    ret
Hangman ENDP

END
