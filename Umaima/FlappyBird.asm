INCLUDE Irvine32.inc

.data
flappy_msg BYTE "Flappy Bird Game - Coming Soon!",0

.code
FlappyBird PROC
    call Clrscr
    mov edx, OFFSET flappy_msg
    call WriteString
    call Crlf
    call WaitMsg
    ret
FlappyBird ENDP

END
