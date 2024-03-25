.model small
.stack 100h


.data
buffer_size equ 33     ; Розмір буфера
buffer db buffer_size dup(?)  ; Буфер для зберігання зчитаних символів
key_buffer db 16 dup(?) ; Buffer to hold the key
value_buffer db 6 dup(?) ; Buffer to hold the value

keys_count equ 20001   ; Максимальна кількість ключів
keys db keys_count dup(16 dup(?))  ; Масив для зберігання ключів
values db keys_count dup(0)        ; Масив для зберігання відповідних значень
keys_average dw keys_count dup(0)  ; Масив для зберігання середніх значень


.code
start PROC
    mov ax, @data       ; Ініціалізація сегмента даних
    mov ds, ax

    

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;виклики всіх функцій
    call read_file     ; Read from file
    call parse_input   ; Розбір введення
    call calculate_average   ; Обчислення середніх значень
    call bubble_sort   ; Сортування
    call write_sorted_keys  ; Виведення відсортованих ключів
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Вихід з програми
    mov ah, 4Ch         ; Функція DOS для завершення програми
    int 21h             ; Виклик переривання DOS



read_file:
    mov ah, 3Fh         ; DOS function to read from file
    mov bx, 0           ; stdin handle
    mov cx, buffer_size ; Number of bytes to read (buffer size)
    mov dx, offset buffer ; Buffer to store the read characters
    int 21h             ; Call DOS interrupt
    ret

start ENDP
end start
