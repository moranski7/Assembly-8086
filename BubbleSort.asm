include \emu8086.inc
.model small
.stack 100h
.data
    prompt_init db "Please enter 5 numbers. Press enter after each number.",10,13,0
    proc_msg db "Performing Bubble sort...",10,13,0
    arr_content db "arr: ",0
    arr db 5 dup(?)
        len=($-arr)
    test_arr db 17, 2, 9, 5, 1
    swap db 0
.code
; Prints a message to screen
;
; Param: A string
; Return: N/A
print_msg macro msg
    lea si, msg
    call print_string
    print_msg endm

proc main
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    print_msg prompt_init
    push len
    call get_numbers  ; Get 5 numbers from user.
    
    push len
    call print_arr ; Print arr to console
    print_msg proc_msg
    push len
    call bubble_sort ;Sort the numbers in the array using Bubble sort
    push len
    call print_arr ; Print arr to console
    hlt
    main endp

; Get 5 numbers from user
; 
; Param: length [in]    - Length of array being filled
; Return: N/A
get_numbers proc
    mov bp,sp
    lea di, arr
    mov cx, [bp+2]
    for_One: mov bx, cx         ; save cx position as scan_num overwrites cx
             call scan_num
             putc 10
             putc 13
             mov [di], cx       ; Stores user input
             inc di
             mov cx, bx         ; restores cx
             loop for_One
    ret 2h
    get_numbers endp

; Print content of arr to console
;
; Param: length [in]    - Length of the array being printed.
; Return: N/A
print_arr proc
    mov bp, sp
    print_msg arr_content
    lea si, arr 
    mov cx, [bp+2]
    for_two: mov ah,0
             mov al, [si]
             call print_num
             putc " "
             inc si
             loop for_two
    putc 10
    putc 13
    ret 2h
    print_arr endp 

; Sorts an array of numbers from smallest to largest, left to right
;
; Param: length [in]    - Length of array being sorted
; Return: N/A
bubble_sort proc
    mov bp, sp
    sort: lea di, arr
          mov swap, 0   ; reset flag
          mov cx, [bp+2]
          dec cx
          forSort:mov al, [di]
                  mov ah, [di]+1
                  cmp al, ah
                  jna continue
                  mov bl,al  ; temp = a[i]
                  mov al,ah  ; a[i] = a[i+1]
                  mov ah,bl  ; a[i+1] = a[i]
                  mov swap, 1 ;set flag
                  continue:mov [di],al  
                           mov [di]+1,ah
                           inc di
                  loop forSort
           cmp swap, 1
           je sort
    ret 2h
    bubble_sort endp

DEFINE_PRINT_STRING
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
end