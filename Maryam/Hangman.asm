include Irvine32.inc

.data
; Word list - using individual strings instead of one big array
word1 byte "PYTHON",0
word2 byte "ASSEMBLY",0
word3 byte "PROGRAM",0
word4 byte "COMPUTER",0
word5 byte "LANGUAGE",0

word_list dword offset word1, offset word2, offset word3, offset word4, offset word5
word_count = 5

; Game variables
secret_word byte 20 dup(?)       ; Current secret word
display_word byte 20 dup(?)      ; Word display with blanks
guessed_letters byte 26 dup(0)   ; Track guessed letters (A-Z)
attempts_left dword 6            ; Wrong guesses allowed
word_length dword ?              ; Length of current word

; Messages
welcome_msg byte "Welcome to Hangman!",0
word_length_msg byte "The word has ",0
letters_msg byte " letters.",0
attempts_msg byte "Attempts remaining: ",0
guess_prompt byte "Guess a letter (A-Z): ",0
correct_msg byte "Good guess!",0
wrong_msg byte "Wrong guess!",0
win_msg byte "Congratulations! You won! The word was: ",0
lose_msg byte "Game over! The word was: ",0
already_guessed_msg byte "You already guessed that letter!",0
invalid_msg byte "Please enter a single letter A-Z!",0

; Hangman ASCII art
hangman0 byte "   ___",0dh,0ah
         byte "  |   |",0dh,0ah
         byte "  |   ",0dh,0ah
         byte "  |   ",0dh,0ah
         byte "  |   ",0dh,0ah
         byte "__|__",0

hangman1 byte "   ___",0dh,0ah
         byte "  |   |",0dh,0ah
         byte "  |   O",0dh,0ah
         byte "  |   ",0dh,0ah
         byte "  |   ",0dh,0ah
         byte "__|__",0

hangman2 byte "   ___",0dh,0ah
         byte "  |   |",0dh,0ah
         byte "  |   O",0dh,0ah
         byte "  |   |",0dh,0ah
         byte "  |   ",0dh,0ah
         byte "__|__",0

hangman3 byte "   ___",0dh,0ah
         byte "  |   |",0dh,0ah
         byte "  |   O",0dh,0ah
         byte "  |  /|",0dh,0ah
         byte "  |   ",0dh,0ah
         byte "__|__",0

hangman4 byte "   ___",0dh,0ah
         byte "  |   |",0dh,0ah
         byte "  |   O",0dh,0ah
         byte "  |  /|\",0dh,0ah
         byte "  |   ",0dh,0ah
         byte "__|__",0

hangman5 byte "   ___",0dh,0ah
         byte "  |   |",0dh,0ah
         byte "  |   O",0dh,0ah
         byte "  |  /|\",0dh,0ah
         byte "  |  / ",0dh,0ah
         byte "__|__",0

hangman6 byte "   ___",0dh,0ah
         byte "  |   |",0dh,0ah
         byte "  |   O",0dh,0ah
         byte "  |  /|\",0dh,0ah
         byte "  |  / \",0dh,0ah
         byte "__|__",0

hangman_art dword offset hangman0, offset hangman1, offset hangman2, offset hangman3, 
                   offset hangman4, offset hangman5, offset hangman6

.code
main proc
    call Randomize          ; Initialize random seed
    
game_loop:
    ; Initialize game
    call InitializeGame
    
    ; Main game loop
    game_main_loop:
        call DisplayGameState
        call GetPlayerGuess
        call ProcessGuess
        call CheckGameStatus
        cmp eax, 0          ; 0 = continue, 1 = win, 2 = lose
        jne game_end
        jmp game_main_loop
    
    game_end:
        ; Ask to play again
        call Crlf
        call WaitMsg
        
    invoke ExitProcess, 0
main endp

InitializeGame proc
    ; Select random word
    call SelectRandomWord
    
    ; Initialize display word with underscores
    mov ecx, word_length
    mov esi, 0
    init_display:
        mov display_word[esi], '_'
        inc esi
    loop init_display
    mov byte ptr display_word[esi], 0  ; Null terminate
    
    ; Clear guessed letters
    mov ecx, 26
    mov esi, 0
    clear_guessed:
        mov guessed_letters[esi], 0
        inc esi
    loop clear_guessed
    
    ; Reset attempts
    mov attempts_left, 6
    
    ; Display welcome message
    mov edx, offset welcome_msg
    call WriteString
    call Crlf
    
    ; Display word length
    mov edx, offset word_length_msg
    call WriteString
    mov eax, word_length
    call WriteDec
    mov edx, offset letters_msg
    call WriteString
    call Crlf
    call Crlf
    
    ret
InitializeGame endp

SelectRandomWord proc
    ; Get random index (0 to word_count-1)
    mov eax, word_count
    call RandomRange     ; EAX = 0 to word_count-1
    
    ; Get pointer to selected word
    mov esi, eax
    shl esi, 2          ; Multiply by 4 (dword size)
    mov esi, word_list[esi]  ; ESI points to selected word
    
    ; Calculate word length and copy to secret_word
    mov edi, offset secret_word
    mov ecx, 0
    copy_word:
        mov al, [esi]
        cmp al, 0
        je copy_done
        mov [edi], al
        inc esi
        inc edi
        inc ecx
        jmp copy_word
    
    copy_done:
    mov byte ptr [edi], 0    ; Null terminate
    mov word_length, ecx
    
    ret
SelectRandomWord endp

DisplayGameState proc
    call Clrscr
    
    ; Display hangman
    mov eax, 6
    sub eax, attempts_left    ; Wrong guesses so far
    mov esi, eax
    shl esi, 2               ; Multiply by 4 (dword size)
    mov edx, hangman_art[esi]
    call WriteString
    call Crlf
    
    ; Display word with spaces
    mov esi, offset display_word
    display_letters:
        mov al, [esi]
        cmp al, 0
        je display_done
        call WriteChar
        mov al, ' '
        call WriteChar
        inc esi
        jmp display_letters
    display_done:
    call Crlf
    call Crlf
    
    ; Display attempts remaining
    mov edx, offset attempts_msg
    call WriteString
    mov eax, attempts_left
    call WriteDec
    call Crlf
    
    ret
DisplayGameState endp

GetPlayerGuess proc
    guess_again:
        mov edx, offset guess_prompt
        call WriteString
        
        call ReadChar         ; Read character (in AL)
        call WriteChar        ; Echo the character
        call Crlf
        
        ; Convert to uppercase
        cmp al, 'a'
        jb not_lowercase
        cmp al, 'z'
        ja not_lowercase
        sub al, 32           ; Convert to uppercase
        
    not_lowercase:
        ; Validate input (A-Z)
        cmp al, 'A'
        jb invalid_input
        cmp al, 'Z'
        ja invalid_input
        
        ; Check if already guessed
        movzx ebx, al
        sub ebx, 'A'         ; Convert to index (0-25)
        cmp guessed_letters[ebx], 1
        je already_guessed
        
        ; Mark as guessed and return
        mov guessed_letters[ebx], 1
        ret
        
    invalid_input:
        mov edx, offset invalid_msg
        call WriteString
        call Crlf
        jmp guess_again
        
    already_guessed:
        mov edx, offset already_guessed_msg
        call WriteString
        call Crlf
        jmp guess_again
        
GetPlayerGuess endp

ProcessGuess proc
    ; AL contains the guessed letter
    push eax
    
    mov esi, offset secret_word
    mov edi, offset display_word
    mov ecx, word_length
    mov ebx, 0              ; Track if guess was correct
    
    check_letter:
        mov al, [esi]
        pop edx
        push edx
        cmp al, dl
        jne not_match
        
        ; Match found - reveal letter in display
        mov [edi], dl
        mov ebx, 1          ; Mark as correct guess
        
    not_match:
        inc esi
        inc edi
        loop check_letter
    
    pop eax ; Clean up stack
    
    ; Update attempts if wrong guess
    cmp ebx, 1
    je correct_guess
    
    ; Wrong guess
    dec attempts_left
    mov edx, offset wrong_msg
    call WriteString
    call Crlf
    call WaitMsg  ; Pause to see the message
    ret
    
    correct_guess:
        mov edx, offset correct_msg
        call WriteString
        call Crlf
        call WaitMsg  ; Pause to see the message
        ret
        
ProcessGuess endp

CheckGameStatus proc
    ; Check if player won (all letters guessed)
    mov esi, offset display_word
    mov ecx, word_length
    check_win:
        cmp byte ptr [esi], '_'
        je not_won_yet
        inc esi
        loop check_win
    
    ; Player won
    call Clrscr
    mov edx, offset win_msg
    call WriteString
    mov edx, offset secret_word
    call WriteString
    call Crlf
    mov eax, 1      ; Return win status
    ret
    
not_won_yet:
    ; Check if player lost
    cmp attempts_left, 0
    jg game_continues
    
    ; Player lost
    call Clrscr
    mov edx, offset lose_msg
    call WriteString
    mov edx, offset secret_word
    call WriteString
    call Crlf
    mov eax, 2      ; Return lose status
    ret
    
game_continues:
    mov eax, 0      ; Return continue status
    ret
    
CheckGameStatus endp

end main
