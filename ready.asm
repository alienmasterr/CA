.model small
.stack 100h

.data
char db 0 ;знак, який читаємо з файлу 
starting_ind dw 0;для масивів
next_ind dw 0;для масивів
keys_array db 10000*16 dup(0);розраховано, що усі 10000 рядків матимуть ключ в 16 символів
keys_buffer db 16 dup(0)
helping_key_ind dw 0
not_numeric db 1
numbers_array dw 10000 dup(0)
numbers_buffer db 16 dup(0)
num_buffer_ind dw 0 ;вказує на індекс, де буде збережено наступне число у буфері
keys_number dw 8000 dup(0) ;масив для зберігання кількості кожного ключа
                           ;(повинно бути 10000, але на більшому ламається)
max_key_length dw 16

.code
main proc
    mov ax, @data
    mov ds, ax  ; Ініціалізація реєстру сегмента даних


read_next:
    mov ah, 3Fh
    mov bx, 0  
    mov cx, 1   
    mov dx, offset char  ; Вказівник на буфер для зберігання прочитаного символу
    int 21h   
   
    push ax  ; Збереження прочитаного символу

    call check_each_char 

    pop ax ;потрібно відновити значення регістра AX

    or ax,ax ; Перевірка, чи досягнуто кінця файлу Якщо AX не рівний нулю, файл не закінчився

    jnz read_next

;відповідає за обробку даних після їх зчитування з файлу та збереження у буфері numbers_buffer
    mov si, offset numbers_buffer ;Завантаження в регістр SI адреси початку буфера numbers_buffer

    dec num_buffer_ind ;індекс -1, щоб перейти до наст числа

    add si, num_buffer_ind ;Додавання значення numberInd до адреси початку буфера numbers_buffer. 
                           ;Це переміщує адресу вказівника SI до місця в буфері, де буде збережено наступне число.

    mov word ptr [si],0 
                        ;"очищення" місця в буфері, де буде збережено наступне число, поч знач за замовчуванням
   
    call to_num ;Перетворює символи, збережені в буфері number, в числове значення.

 call average_calculator   
 call bubble_sort
 call println

finish:
mov ax, 4C00h
    int 21h

main endp

                     ;зберігає символи або в буфері keys_buffer, або в буфері numbers_buffer залежно від поточного режиму (not_numeric флага).
check_each_char proc ;перевіряє, чи є символ символом переводу каретки (0Dh), символом нового рядка (0Ah) або пробілом (20h)
 
  
    cmp char,0Dh ; Перевірка, чи символ возврату каретки
    jnz not_cr ; ні -- стрибаємо

    cmp not_numeric,0 
    ;????? jne
    jnz end_check_each_char

    mov not_numeric,1
    call to_num

    jmp end_check_each_char

    not_cr:
        cmp char,0Ah
        jnz not_lf


    cmp not_numeric,0
    jnz end_check_each_char
    mov not_numeric,1
    call to_num
    jmp end_check_each_char
    
    not_lf:
        cmp char,20h
        jnz not_whitespace

    mov not_numeric,0
    call search_for_key
    jmp end_check_each_char

    not_whitespace:
        cmp not_numeric, 0
        jnz found_a_key
      
        mov si, offset numbers_buffer
        mov bx, num_buffer_ind
        add si, bx
        mov al, char
        mov [si], al
        inc num_buffer_ind
        jmp end_check_each_char

found_a_key:
        mov si, offset keys_buffer
        mov bx, helping_key_ind 
        add si, bx
        mov al, char
        mov [si], al
        inc helping_key_ind 
      

end_check_each_char:
    ret
 check_each_char endp   


            ;до масиву numbers_array.
            ;зберігається в масиві, а потім буфер скидається
to_num PROC
    xor bx, bx
    mov cx, 0

to_binary_from_ascii:
    ; Convert ASCII characters to numerical values and accumulate in BX
    mov si, offset numbers_buffer
    add si, num_buffer_ind
    dec si
    sub si, cx

    xor ax, ax
    mov al, [si]

    cmp al, 45
    jnz not_negative
        neg bx
        jmp finished_conversion

    not_negative:
        sub al, '0'

    push cx
    cmp cx, 0
    jnz not_zero
    jmp stop_conversion

    not_zero:
        ten_multiplication:
            mov dx, 10
            mul dx
            dec cx
            cmp cx, 0
            jnz ten_multiplication

    stop_conversion:
    pop cx
    add bx, ax

    inc cx
    cmp cx, num_buffer_ind
    jnz to_binary_from_ascii

    finished_conversion:
    ; Update the value in the numbers_array
    mov si, offset numbers_array
    mov ax, starting_ind
    shl ax, 1
    add si, ax
    add bx, [si]
    mov [si], bx

    ; Reset buffers and counters
    mov num_buffer_ind, 0
    mov cx, 0

    ; Set the contents of numbers_buffer to zeroes
    array_to_zeroes:
        mov si, offset numbers_buffer
        add si, cx
        mov word ptr [si], 0
        inc cx
        cmp cx, 9
        jnz array_to_zeroes

    ret
to_num ENDP


search_for_key proc ;Перевіряє, чи вже існує поточне слово (збережене в keys_buffer) в масиві keys_array
                    ;Якщо воно існує, збільшує кількість в масиві keys_number, що відповідає цьому ключу.
                    ;Якщо ні, то додає слово до масиву keys та встановлює його кількість на 1 в масиві keys_number.
    mov ax,0
    mov bx, 0; 
    mov cx, 0
    mov dx,0

    cmp next_ind,0
    jnz identify_key
jmp add_key  
    identify_key:
    mov dx,0
        check_key_existance:
        mov si, offset keys_array
        shl cx, 4
        add si, cx
        shr cx,4
        add si, dx; 
        mov al,[si]; 
        mov di, offset keys_buffer
        add di,dx
        mov ah, [di]; 
        cmp al,ah
        jne not_same
            mov bx,1; 
            jmp length_check
            not_same:
                mov bx,0; 
                mov dx, 15; 
        length_check:
            inc dx
            cmp dx,max_key_length
            jnz check_key_existance
     
    cmp bx,0
    jnz found_the_key 
    inc cx
    cmp cx, next_ind
    jne identify_key

    mov cx, 0  ; 
    add_key:
    
   ;
    mov di, offset keys_array   
    mov ax,  next_ind

     mov si, offset keys_buffer   ; 
    add si, cx


   
    add di,cx

     shl ax,4 

    add di, ax ;
    
    mov al, [si]
    mov [di], al 
    inc cx
    cmp cx, max_key_length
    jnz add_key
    mov cx, next_ind
    mov starting_ind,cx
    inc next_ind
   
    mov si, offset keys_number
    mov cx, starting_ind
    shl cx,1
    add si, cx
    mov ax,1
    mov [si],ax
    jmp go_to_end;

found_the_key:
  
    mov starting_ind,cx

    mov si, offset keys_number
    mov cx, starting_ind
    shl cx,1
    add si, cx
    mov ax, [si]
    inc ax
    mov [si],ax

go_to_end:
    mov helping_key_ind,0
    mov cx,0
  add_zeroes:
    mov si, offset keys_buffer
    add si, cx
    mov word ptr [si],0
    inc cx
    cmp cx,15
    jnz add_zeroes  
    ret


search_for_key endp

;;;;;
average_calculator proc

mov cx,0;
average_calculator_loop:
mov si, offset numbers_array
shl cx,1
add si,cx; 

mov di, offset keys_number
add di, cx;
shr cx,1
mov ax, [si]; 
mov bx, [di]; 
mov dx,0
div bx; 
mov [si], ax; 
inc cx
cmp cx, next_ind
jnz average_calculator_loop

ret
average_calculator endp

;;;;;

println proc
mov cx,0
string_builder:
mov ax,0
mov starting_ind,ax
mov dx,0
push cx
    mov di, offset keys_number
    shl cx,1
    add di,cx;
    mov cx, [di]
    print_keys:
    mov si, offset keys_array
    mov ax,0
    mov ax, cx; 
    shl ax, 4; 
    add si, ax
    add si, starting_ind

    mov ah, 02h
    mov bx,dx; 
    mov dl, [si]
    cmp dl, 0 

    jne continue_print
        jmp next_line
    continue_print:
    int 21h
    mov dx,bx
    inc starting_ind
    inc dx
    cmp dx, 16
    jnz print_keys
next_line:

    mov ah, 02h
mov dl, 0dh
int 21h
 mov ah, 02h
mov dl, 0ah
int 21h

pop cx
inc cx
cmp cx, next_ind
jnz string_builder

ret
println endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;sort +

bubble_sort proc
pop dx; 

xor cx, cx

bubble_sort_loop:
 
    mov di, offset keys_number
    shl cx,1
    add di,cx
    shr cx,1    
    mov [di],cx;
    inc cx
    cmp cx, next_ind
    jnz bubble_sort_loop

mov cx, word ptr next_ind
    dec cx  ;
outer_loop:
    push cx
    lea si, keys_number
inner_loop:
    mov ax, [si];
    push ax; 
    shl ax,1; 
    add ax,offset numbers_array;
    mov di, ax
    mov ax, [di]
    mov bx, [si+2];
    push bx; 
    shl bx,1; 
    add bx,offset numbers_array
   mov di, bx
    mov bx, [di]
    cmp ax, bx;
    pop bx
    pop ax
    jg next_step
    xchg bx, ax
    mov [si], ax
    MOV [si+2],bx
next_step:
    add si, 2
    loop inner_loop
    pop cx
    loop outer_loop
push dx
ret
bubble_sort endp
end main