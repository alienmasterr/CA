.model small
.stack 100h


.data

;file_error_message db "error $"
not_fucked db "f $", 0Dh, 0Ah

file dw 0
current_char db 0
current_ind dw 0
new_key_ind dw 0

keys_array db 10000*16 dup(0) ;розраховано, що усі 10000 рядків матимуть ключ в 16 символів
single_key_buffer db 16 dup(0) ; максимальний розмір одного ключа
number_buffer db 16 dup(0)

is_key db 1 ;флаг на 1

key_buffer_ind dw 0
value_array dw 10000 dup(0)
number_buffer_ind dw 0
arrays_num dw 3000 dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax

    ;call check
    call read_next
    ;call check
    ;call printArrays ; Print the arrays
   
    ; Open the file
    mov ah, 3Dh         
    mov al, 0           
    int 21h             
 
   ; jc file_error      
    mov [file], ax  

; Read file
read_next:

;;;;;;;;;;;;;;;;;;;;;;;;
    ;call check
    ; mov ah, 09h
    ; mov dx, offset not_fucked
    ; int 21h
;;;;;;;;;;;;;;;;;;;;;;

    mov ah, 3Fh         
    mov bx, [file] 
    mov cx, 1      ;побайтово
    mov dx, offset current_char ; store read chars
    int 21h            

    or ax, ax           ; Check end
    jz file_close       ; ax = 0 -> end of file

     ; Process the character
    push ax
    push bx
    push cx
    push dx
    call check_each_char
    pop dx
    pop cx
    pop bx
    pop ax

    jmp read_next 

file_close:
    ;call check
    mov ah, 3Eh         
    mov bx, [file] 
    int 21h 

    jmp ending


ending:
    mov ah, 4Ch         ; DOS function to exit the program
    int 21h             ; Call DOS interrupt
    ret
 
main endp

check_each_char proc

;;;;;;;;;;;;;;;;;;;;;;;;
    ; ;call check
    ; mov ah, 09h
    ; mov dx, offset not_fucked
    ; int 21h
;;;;;;;;;;;;;;;;;;;;;;
    cmp current_char, 0Dh ;compares the current character with carriage return (CR, 0Dh). If they are not equal, it jumps to not_cr.
   
    jnz not_cr;стрибає
    
    mov is_key, 1 ;If the current character is not a carriage return, it sets the flag is_key to 1, indicating that it's part of a word.
 ;;;;;;;;;;;;;;;;;;;;;;;;
    ;call check
    mov ah, 09h
    mov dx, offset not_fucked
    int 21h
;;;;;;;;;;;;;;;;;;;;;; 
  
    call convert_to_binary

    jmp end_char_check
not_cr:
 
    cmp current_char, 0Ah
    jnz not_lf;стрибає
    
    mov is_key, 1
    jmp end_char_check
not_lf:

    cmp current_char, 20h

    jnz not_whitespace

    mov is_key, 0
    call check_if_key

    jmp end_char_check ;стрибає
        
not_whitespace:
    cmp is_key, 0
    jnz is_word
    


    mov si, offset number_buffer

    mov bx, number_buffer_ind
    add si, bx
    mov al, current_char
    mov [si], al
    inc number_buffer_ind

    call convert_to_binary;;;;;;;;;;----- тепер воно зайшло в конверт ту байнврі



    jmp end_char_check
is_word:

; ;;;;;;;;;;;;;;;;;;;;;;;;
;     ;call check
;     mov ah, 09h
;     mov dx, offset not_fucked
;     int 21h
; ;;;;;;;;;;;;;;;;;;;;;;
    mov si, offset single_key_buffer
    mov bx, key_buffer_ind
    add si, bx
    mov al, current_char
    mov [si], al
    inc key_buffer_ind

end_char_check:
    ret

check_each_char endp


convert_to_binary proc
 
    xor bx, bx
    mov cx, 0

calculate:

    mov si, offset number_buffer
    add si, number_buffer_ind
    dec si
    sub si, cx
    xor ax, ax
    mov al, [si]
    cmp ax, 45
    
    jnz not_minus
    
    neg bx
    jmp end_calculation

not_minus:

    sub al, '0'
    push cx
    cmp cx, 0
    jnz not_0

    jmp end_multiplication

not_0:
    multiply_10:
    mov dx, 10
    mul dx
    dec cx
    cmp cx, 0
    jnz multiply_10

end_multiplication:

    pop cx
    add bx, ax
    inc cx
    cmp cx, number_buffer_ind
    jnz calculate

end_calculation:

    mov si, offset value_array
    mov ax, current_ind
    shl ax, 1
    add si, ax
    add bx, [si]
    mov [si], bx
    mov number_buffer_ind, 0
    mov cx, 0

add_0:

        mov si, offset number_buffer
        add si, cx
        mov [si], 0
        inc cx
        cmp cx, 9
        jnz add_0

    ret

convert_to_binary endp

check_if_key proc

    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0

    cmp new_key_ind, 0

    jnz key_compare
;;;;;;;;;;;;;;;;;;;;;;;;
    ;call check
    mov ah, 09h
    mov dx, offset not_fucked
    int 21h
;;;;;;;;;;;;;;;;;;;;;; 
    jmp add_key ;стрибає

key_compare:
;НЕ ЗАЙШЛО і добре на 1 ключі
    mov dx, 0

    check_key:
        mov si, offset keys_array
        shl cx, 4
        add si, cx
        shr cx, 4
        add si, dx
        mov al, [si]
        mov di, offset single_key_buffer
        add di, dx
        mov ah, [di]
        cmp al, ah
        jne char_not_same

        mov bx, 1
        jmp go_to_the_end

    char_not_same:
        mov bx, 0
        mov dx, 15
 go_to_the_end:
        inc dx
        cmp dx, 16
        jnz check_key

    cmp bx, 0
    jnz found_key

    inc cx
    cmp cx, new_key_ind
    jne key_compare

    ;new key
    add_key:

        mov cx, 0

        add_key_loop:

            mov si, offset single_key_buffer
            add si, cx
            mov di, offset keys_array
            mov ax, new_key_ind
            shl ax, 4
            add di, cx
            add di, ax
            mov al, [si]
            mov [di], al
            inc cx
            cmp cx, 16
      
            jnz add_key_loop
       
        mov cx, new_key_ind
        mov current_ind, cx
        inc new_key_ind

        mov si, offset arrays_num
        mov cx, current_ind
        shl cx, 1
        add si, cx
        mov ax, 1
        mov [si], ax

        jmp reached_ending;стрибає
                 

found_key:
    mov current_ind, cx

    mov si, offset arrays_num
    mov cx, current_ind
    shl cx, 1
    add si, cx
    mov ax, [si]
    inc ax
    mov [si], ax

reached_ending:

    mov key_buffer_ind, 0
    mov cx, 0

    fill_with_0:
        mov si, offset single_key_buffer
        add si, cx
        mov [si], 0
        inc cx
        cmp cx, 15
        jnz fill_with_0
    ret

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
check_if_key endp

calculate_average proc
    mov cx, 0

average_loop:
    mov si, offset value_array
    shl cx, 1
    add si, cx
    mov di, offset arrays_num
    add di, cx
    shr cx, 1
    mov ax, [si]
    mov bx, [di]
    mov dx, 0
    div bx
    mov [si], ax
    inc cx
    cmp cx, new_key_ind
    jnz average_loop

    ret
calculate_average endp

println proc
    mov cx, 0

string_builder:
    mov ax, 0
    mov current_ind, ax
    mov dx, 0
    push cx

    mov di, offset arrays_num
    shl cx, 1
    add di, cx
    mov cx, [di]

print_keys:
    mov si, offset keys_array
    mov ax, cx
    shl ax, 4
    add si, ax
    add si, current_ind

    mov ah, 02h
    mov bx, dx
    mov dl, [si]
    cmp dl, 0
    jne print_key_loop
    jmp print_value

print_key_loop:
    int 21h
    mov dx, bx
    inc current_ind
    inc dx
    cmp dx, 16
    jnz print_keys

print_value:
    mov ah, 02h
    mov dl, ' '
    int 21h

    push cx
    call to_char
    pop cx

    call for_neg
    mov dx, 0

value_print:
    mov si, offset number_buffer
    add si, dx
    mov bl, [si]

    mov ah, 02h
    push dx
    mov dl, bl
    int 21h
    pop dx

    inc dx
    cmp dx, number_buffer_ind
    jnz value_print

    mov ah, 02h
    mov dl, 0dh
    int 21h

    mov ah, 02h
    mov dl, 0ah
    int 21h

    pop cx
    inc cx
    cmp cx, new_key_ind
    jnz string_builder

    ret
println endp

to_char proc
    pop dx
    pop bx
    shl bx, 1
    mov ax, [value_array + bx]
    cmp ax, 10000
    jc positive
    neg ax

positive:
    shr bx, 1
    push bx
    push dx
    mov cx, 15

into_char:
    mov dx, 0
    mov bx, 10
    div bx
    mov si, offset single_key_buffer
    add si, cx
    add dx, '0'
    mov [si], dl
    cmp ax, 0
    jnz continue_to_convert
    mov bx, 16
    mov number_buffer_ind, bx
    sub number_buffer_ind, cx
    jmp reverse_number

continue_to_convert:
    dec cx
    cmp cx, -1
    jne into_char

reverse_number:
    mov cx, 16
    sub cx, number_buffer_ind
    mov dx, 0

reverse:
    mov si, offset single_key_buffer
    add si, cx
    mov di, offset number_buffer
    add di, dx
    mov al, [si]
    mov [di], al
    inc dx
    inc cx
    cmp cx, 16
    jnz reverse

    ret
to_char endp

for_neg proc
    mov bx, cx
    shl bx, 1
    mov ax, [value_array + bx]
    cmp ax, 10000
    jc positive
    mov ah, 02h
    mov dl, '-'
    int 21h

for_neg endp

bubble_sort proc
    pop dx
    mov cx, 0

store_pointers_in_array:
    mov di, offset arrays_num
    shl cx, 1
    add di, cx
    shr cx, 1
    mov [di], cx
    inc cx
    cmp cx, new_key_ind
    jnz store_pointers_in_array
    mov cx, word ptr new_key_ind
    dec cx

outer_loop:
    push cx
    lea si, arrays_num

inner_loop:
    mov ax, [si]
    push ax
    shl ax, 1
    add ax, offset value_array
    mov di, ax
    mov ax, [di]
    mov bx, [si + 2]
    push bx
    shl bx, 1
    add bx, offset value_array
    mov di, bx
    mov bx, [di]
    cmp ax, bx
    pop bx
    pop ax
    jl next_step
    xchg bx, ax
    mov [si], ax
    mov [si + 2], bx

next_step:
    add si, 2
    loop inner_loop
    pop cx
    loop outer_loop
    push dx
    call bubble_sort
    ret
bubble_sort endp

; check proc
;     mov ah, 09h
;     mov dx, offset not_fucked
;     int 21h
; check endp

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; printArrays proc
;     mov cx, word ptr new_key_ind ; Load the number of keys

; printLoop:
;     ; Print key
;     mov si, offset single_key_buffer
;     mov di, offset keys_array
;     mov bx, word ptr new_key_ind
;     shl bx, 4 ; Multiply by 16 (size of a key)
;     add di, bx ; Point to the current key
;     mov dx, 16 ; Key size
;     call printString

;     ; Print value
;     mov ax, [si] ; Load the value
;     call printNumber
;     call printNewLine

;     ; Move to the next key
;     add si, 16 ; Move to the next key in the buffer
;     loop printLoop

;     ret
; printArrays endp

; printString proc
;     mov ah, 09h ; Print string
;     int 21h
;     ret
; printString endp

; printNumber proc
;     ; Your code to print a number goes here
;     ret
; printNumber endp

; printNewLine proc
;     mov ah, 02h ; Print character
;     mov dl, 0Dh ; Carriage return
;     int 21h
;     mov dl, 0Ah ; Line feed
;     int 21h
;     ret
; printNewLine endp

end main