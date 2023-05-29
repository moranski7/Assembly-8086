include \emu8086.inc
.model small
.stack 100h
.data
    prompt db "This program will test if a word is a palindrome.",10,13,"Please enter word:",10,13,0
    wait_msg db "Testing. Please wait...",10,13, 0
    yes_msg db "The word is a palindrom.",10,13,0
    no_msg db "The word is not a palindrom.",10,13,0
    word db 50 dup(?)
    length dw 0
.code
; Prints a message to screen
;
; Param: A string
; Return: N/A
print_msg macro msg
    lea si, msg
    call print_string
    print_msg endm 

;Gets user input and stores in variable get_string
;
;Param: N/A
;Return: N/A
get_user_input macro
    mov dx, 25
    lea di, word
    call get_string
    putc 10
    putc 13
    get_user_input endm

main proc
    mov ax, @data
    mov ds, ax
    mov es, ax
     
    print_msg prompt     ; Print prompt to screen
    get_user_input       ; Gets the user input and store in get_string
    print_msg wait_msg   ; Prints processing message to screen
    
    mov bp,sp
    push length          ;Param: Length [out]
    call get_length      ; Gets the length of the inputted string. Without the program will scan the empty cells in the variable.
    pop length           ; Stores the length
    
    push length          ; Param: Length [in] 
    call convert_lower   ; Convert any characters in the inputted string to lowercase.
    
    push length          ;Param: Length [in]
    call palindrom       ;Check if the inputted string is a palindrome. Sets the DX register to 0 if true, 1 otherwise.
    
    cmp dx, 0
    jne not_palindrom
    print_msg yes_msg
    jmp endf
    not_palindrom:print_msg no_msg
    
    endf:hlt
    main endp

; Checks the length of the inputtted by checking for a non character 0 or reaching
; 50 characters in length, whichever comes first.
;
; Param: length [out] - stores the length of the string
; Return: N/A
get_length proc
    mov bp,sp
    mov bx, 0
    mov cx, 50
    lea si, word
    for_One:mov al, [si]
        cmp al, 0
        jnz count
        jmp end_Func
        count:inc bx
        inc si
        loop for_One
        end_Func:mov [bp+2], bx
    ret
    get_length endp

; Converts any uppercase letters to lowercase letters by checking the hex value of the character.
;
; Param: Length [in] - length of the inputted string
; Return: N/A
convert_lower proc
    mov bp, sp
    mov cx, [bp+2]
    lea di, word
    for_Two:mov al, [di]
            cmp al, 61h
            jae lower_case
            add [di], 32
            lower_case:inc di
            loop for_Two
    ret 2h
    convert_lower endp

; Checks to see if the inputted string is a palindrome.
; Sets a pointer at each of the string and compares the characters at each end.
; If the chracter does not match at point sets the dx register to 1.
; 
; Param: Length [in] - Length of the inputted string
; Return: Sets DX register to 0 if all characters are the same. Sets DX register to 1 if at least one character is not the same.
palindrom proc
    mov bp,sp
    mov cx, [bp+2]  
    mov dx, 0
    lea si, word ;set si to the front of the string
    lea di, word
    add di, cx ;Set di to the end of the string
    dec di 
    for_Three:mov al, [di]
        mov bl, [si]
        cmp al, bl
        je same_letter
        mov dx, 1
        same_letter:dec di
                    inc si
                    loop for_Three
    ret 2h
    palindrom endp

DEFINE_GET_STRING
DEFINE_PRINT_STRING
end