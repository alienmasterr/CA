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

parse_input:
    mov si, offset buffer     ; Початок буфера
    mov di, offset keys       ; Початок масиву ключів

    ; Код для завантаження адреси масиву значень (values)
    xor dx, dx               ; Обнуляємо старшу частину адреси
    mov bx, offset values    ; Молодша частина адреси !!!!!!!!!!!!!!!!!!!!!!!!А ЯКЩО DX

    ; Тест на переповнення під час додавання
    mov ax, 7FFFh            ; Перше 16-бітне число
    add ax, 0FFFh            ; Додавання другого 16-бітного числа
    jc overflow_detected     ; Перевірка флагу переповнення (JC - перенос зараховано)

    ; Обчислення середнього
    xor dx, dx               ; Обнуляємо старшу частину результату
    mov ax, 7FFFh            ; Перше 16-бітне число
    add ax, 7FFFh            ; Додавання другого 16-бітного числа
    adc dx, 0                ; Перенос зі старшої частини
    jc overflow_detected_avg ; Перевірка флагу переповнення (JC - перенос зараховано)

    ; Тут можна продовжити виконання програми з отриманим результатом
    ; можна зберегти результат в якийсь реєстр

    ret

overflow_detected:
    ; Обробка переповнення при додаванні
    ; Наприклад, можна вивести повідомлення про переповнення
    mov ax, 0              ; Ставимо в регістр AX значення 0, яке буде позначати помилку
    jmp end_parse_input    ; Перехід до кінця процедури

overflow_detected_avg:
    ; Обробка переповнення при обчисленні середнього
    ; Наприклад, можна вивести повідомлення про переповнення
    mov ax, 0              ; Ставимо в регістр AX значення 0, яке буде позначати помилку
    jmp end_parse_input    ; Перехід до кінця процедури

end_parse_input:
    ret

parse_loop:
    ; Зчитування ключа
    mov cx, 16         ; Максимальна довжина ключа
    call read_key      ; Процедура для зчитування ключа
    mov byte ptr [di], 0  ; Додавання завершуючого нуля до ключа
    inc di             ; Перехід до наступного елемента в масиві ключів


    ; Пропуск пробілу
    mov al, byte ptr [si]
    cmp al, ' '
    jne skip_whitespace
    inc si

skip_whitespace:
   
    ; Зчитування значення
    mov cx, 5          ; Максимальна довжина значення
    call read_value    ; Процедура для зчитування значення
    mov byte ptr [bx], 0  ; Додавання завершуючого нуля до значення
    inc bx             ; Перехід до наступного елемента в масиві значень


    ; Пропуск пробілу
    mov al, byte ptr [si]
    cmp al, ' '
    jne skip_whitespace2
    inc si

skip_whitespace2:


    ; Перевірка кінця рядка
    mov al, byte ptr [si]
    cmp al, 0Dh
    je next_line
    cmp al, 0Ah
    je next_line
    jmp parse_loop   ; Перехід до наступного символу

next_line:
    inc si            ; Пропуск символу переведення рядка
    mov al, byte ptr [si]
    cmp al, 0Ah      ; Перевірка на наступний символ переведення рядка
    je end_of_input  ; Якщо кінець введення
    inc si           ; Пропуск 0Dh
    jmp parse_loop  ; Перехід до наступного рядка


end_of_input:
    ret

read_key:
    xor cx, cx         ; CX = 0
read_key_loop:
    mov al, byte ptr [si]  ; Зчитування символу
    cmp al, ' '        ; Перевірка на пробіл
    je end_read_key    ; Якщо зустрівся пробіл, кінець ключа
    cmp al, 0Dh        ; Перевірка на кінець рядка
    je end_read_key
    cmp al, 0Ah        ; Перевірка на кінець рядка
    je end_read_key
    mov byte ptr [di], al  ; Запис символу у масив ключів
    inc di             ; Перехід до наступного елемента масиву
    inc si             ; Перехід до наступного символу
    inc cx             ; Збільшення лічильника символів ключа
    cmp cx, 16         ; Перевірка на максимальну довжину ключа
    je end_read_key
    jmp read_key_loop  ; Перехід до наступного символу

end_read_key:
    ret


read_file:
    mov ah, 3Fh         ; DOS function to read from file
    mov bx, 0           ; stdin handle
    mov cx, buffer_size ; Number of bytes to read (buffer size)
    mov dx, offset buffer ; Buffer to store the read characters
    int 21h             ; Call DOS interrupt
    ret

start ENDP
end start
