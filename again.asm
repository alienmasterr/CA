.model small
.stack 100h
.data

not_fucked db "f $", 0Dh, 0Ah
is_check_called db 0 ; Флаг, що позначає, чи була вже викликана процедура check

file dw 0
char_buffer db 0
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
   
    mov si, offset number_buffer
    dec number_buffer_ind
    add si, number_buffer_ind
    mov [si], 0

    ; Open the file
    mov ah, 3Dh         
    mov al, 0           
    int 21h             
      
    mov [file], ax
    call read_next
    
    call calculate_average  ; Call calculate_average here
    
    call bubble_sort
    call println

    ; Close the file
    mov ah, 3Eh         
    mov bx, [file] 
    int 21h 

    jmp ending

ending:
    mov ah, 4Ch         ; DOS function to exit the program
    int 21h             ; Call DOS interrupt
    ret
main endp

; main proc
;     mov ax, @data
;     mov ds, ax
   
; mov si, offset number_buffer
;         dec number_buffer_ind
;         add si, number_buffer_ind
;         mov [si], 0


;     ; Open the file
;     mov ah, 3Dh         
;     mov al, 0           
;     int 21h             
      
;     mov [file], ax
;     call read_next
    
;     ;не заходить
; ;  ;;;;;;;;;;;;;;;;;;;;;;;
; ;     ;call check
;      mov ah, 09h
;      mov dx, offset not_fucked
;      int 21h
; ; ;;;;;;;;;;;;;;;;;;;;;;
; call convert_to_binary
; call calculate_average
; call bubble_sort
; call println


; main endp
;Read file
read_next proc
init_read_line_chars:
    xor cx, cx

read_char_loop:

    push bx;     mov bx, word ptr new_key_ind
    push cx
    mov dx, offset char_buffer

    mov ah, 3Fh         
    mov bx, 0 ;[file] 
    mov cx, 1      ;побайтово
    ;mov dx, offset char_buffer ; store read chars
    int 21h            

    pop cx
    pop bx

    or ax, ax           ; Check end
    jz file_close       ; ax = 0 -> end of file

    mov al, [char_buffer]

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
    or ax, ax   

    jnz read_next 

   
file_close:
    ;call check
    mov ah, 3Eh         
    mov bx, 0 ;[file] 
    int 21h 

    jmp ending


; ending:
;     mov ah, 4Ch         ; DOS function to exit the program
;     int 21h             ; Call DOS interrupt
;     ret
 
;main endp
read_next ENDP

check_each_char proc

    cmp char_buffer, 0Dh ;compares the current character with carriage return (CR, 0Dh). If they are not equal, it jumps to not_cr.
   
    jnz not_cr;стрибає
    
    mov is_key, 1 ;If the current character is not a carriage return, it sets the flag is_key to 1, indicating that it's part of a word.
  
    call convert_to_binary
    jmp end_char_check

not_cr:
    cmp char_buffer, 0Ah
    jnz not_lf;стрибає
    mov is_key, 1
    jmp end_char_check
not_lf:
    cmp char_buffer, 20h
    jnz not_whitespace
    mov is_key, 0
    call check_key_existance
    jmp end_char_check ;стрибає
        
not_whitespace:
    cmp is_key, 0
    jnz is_word
    mov si, offset number_buffer
    mov bx, number_buffer_ind
    add si, bx
    mov al, char_buffer
    mov [si], al
    inc number_buffer_ind
    call convert_to_binary;;;;;;;;;;----- тепер воно зайшло в конверт ту байнврі
    jmp end_char_check

is_word:
    mov si, offset single_key_buffer
    mov bx, key_buffer_ind
    add si, bx
    mov al, char_buffer
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

check_key_existance proc
    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0

    ; Заповнення масиву single_key_buffer нулями
    mov cx, 15
    mov si, offset single_key_buffer
fill_with_0:
    mov [si], 0
    inc si
    loop fill_with_0
; Перевірка наявності нових ключів
    cmp new_key_ind, 0 ;Check if new_key_ind is zero: It checks if new_key_ind is zero.
                        ;If it's zero, it implies that there are no existing keys in the keys_array,
                        ;and the procedure jumps to the add_key label to add the new key.
    jnz key_compare ;If new_key_ind is not zero, it enters a loop labeled key_compare
                    ;to compare the new key stored in single_key_buffer with the keys in the keys_array.
    jmp add_key ;стрибає
key_compare:
    mov dx, 0 ; Скидаємо dx на початкове значення перед входом у цикл
check_key:
    mov si, offset keys_array
    mov cx, new_key_ind ; Завантажуємо довжину масиву keys_array в cx
    mov bx, 0 ; Скидаємо bx на початкове значення

compare_loop:
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

go_to_the_end:
    inc dx ; Збільшуємо dx для переходу до наступного ключа
    cmp dx, new_key_ind
    jl compare_loop ; Перевіряємо, чи є ще ключі для порівняння
    cmp bx, 0
    jnz found_key
    ret

    ;new key
add_key:
        ;заходить
        mov cx, 0
        add_key_loop:
            ;добре
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
        
            inc new_key_ind ;інкризить
            mov si, offset arrays_num
            mov cx, current_ind
            shl cx, 1
            add si, cx
            mov ax, 1
            mov [si], ax
            jmp check_key_existance
found_key:

    mov current_ind, cx
    mov si, offset arrays_num
    mov cx, current_ind
    shl cx, 1
    add si, cx
    mov ax, [si]
    inc ax
    mov [si], ax

 ; Обнулення dx для перевірки наступного ключа
    mov dx, 0

    ; Повернення до перевірки інших ключів
    mov cx, current_ind  ; Відновлюємо поточний індекс
    inc dx              ; Переходимо до наступного ключа
    ;jmp check_key_existance    ; Перехід на початок циклу порівняння ключів
    call calculate_average
    ret ; Повертаємося до основного виклику check_key_existance

check_key_existance endp

calculate_average proc
; заходить
    mov cx, 0

average_loop:
; заходить
 
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

    call println
    ret
calculate_average endp
;заходить
;;;;;;;;;;;;;;;;;;;;;;;
check proc
    cmp is_check_called, 1 ; Перевіряємо, чи вже була викликана процедура check
    je end_check           ; Якщо так, просто завершуємо процедуру

    mov ah, 09h
    mov dx, offset not_fucked
    int 21h

    mov is_check_called, 1 ; Встановлюємо флаг, позначаючи, що процедура вже була викликана

end_check:
mov is_check_called, 0
    ret
check endp
;;;;;;;;;;;;;;;;;;;;;;
println proc
;call check
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
  
    jne print_key_loop;не стрибає
      ;+   
    jmp print_value

print_key_loop:
;не заходить
    int 21h
    mov dx, bx
    inc current_ind
    inc dx
    cmp dx, 16
    jnz print_keys

print_value:
;+

    mov ah, 02h
    mov dl, ' '
    int 21h
    push cx
    ;+
    call to_char
    pop cx
 ;+
    call for_neg
    mov dx, 0

value_print:
;-
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
;+
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
;+

    mov dx, 0
    mov bx, 10
    div bx
    mov si, offset single_key_buffer
    add si, cx
    add dx, '0'
    mov [si], dl
    cmp ax, 0
    ;-
    jnz continue_to_convert
    mov bx, 16
    mov number_buffer_ind, bx
    sub number_buffer_ind, cx
 ;+
    jmp reverse_number

continue_to_convert:
;-
   
    dec cx
    cmp cx, -1
    jne into_char

reverse_number:
   ;call check ;!!!!!!!!!!
;WTF!!!!!!!!!!!!!!!!!????????????
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

end main