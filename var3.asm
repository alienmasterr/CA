.model small
.stack 100h


.data
buffer_size equ 33     ; Розмір буфера
buffer db buffer_size dup(?)  ; Буфер для зберігання зчитаних символів
key_buffer db 16 dup(?) ; Buffer to hold the key
value_buffer db 6 dup(?) ; Buffer to hold the value

keys_count equ 1000   ; Максимальна кількість ключів
keys db keys_count dup(16 dup(?))  ; Масив для зберігання ключів
values db keys_count dup(0)        ; Масив для зберігання відповідних значень
keys_average dw keys_count dup(0)  ; Масив для зберігання середніх значень


.code
start PROC
    mov ax, @data    
    mov ds, ax
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;виклики всіх функцій
    call read_file     
    call parse_input   ; Розбір введення
    call calculate_average   
    call bubble_sort   
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
    mov bx, offset values    ; Молодша частина адреси !!!!!!!!!!!!!!!!!!!!!!!

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

    ; Тут можна продовжити з отриманим результатом
    ; можна зберегти результат в якийсь реєстр

    ret

overflow_detected:
    ; Обробка переповнення при додаванні
  
    mov ax, 0              ;  AX  0,  помилка
    jmp end_parse_input    ; Перехід до кінця процедури

overflow_detected_avg:
    ; Обробка переповнення при обчисленні середнього
    
    mov ax, 0              ; в  AX  0,  помилка
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

read_value:
    xor cx, cx         ; CX = 0
read_value_loop:
    mov al, byte ptr [si]  ; Зчитування символу
    cmp al, ' '        ; Перевірка на пробіл
    je end_read_value    ; Якщо зустрівся пробіл, кінець значення
    cmp al, 0Dh        ; Перевірка на кінець рядка
    je end_read_value
    cmp al, 0Ah        ; Перевірка на кінець рядка
    je end_read_value
    mov byte ptr [bx], al  ; Запис символу у масив значень
    inc bx             ; Перехід до наступного елемента масиву
    inc si             ; Перехід до наступного символу
    inc cx             ; Збільшення лічильника символів значення
    cmp cx, 5         ; Перевірка на максимальну довжину значення
    je end_read_value
    jmp read_value_loop  ; Перехід до наступного символу

end_read_value:
    ret

calculate_average:
call decimal_to_binary  ; Виклик підпрограми для конвертування середнього значення у бінарний код
    xor dx, dx          ; Clear DX (high word of 32-bit sum)
    xor ax, ax          ; Clear AX (low word of 32-bit sum)
    mov cx, keys_count  ; Load count of keys for loop
    mov si, 0           ; Start index for keys_average
;;;;;;;;;;;;;;;;;;

    ret

; Підпрограма для конвертування десяткового значення у вигляді рядка в бінарне представлення у доповнювальному коді
decimal_to_binary:
    push ax             ; зберегти регістр AX
    push bx             ; зберегти регістр BX
    push cx             ; зберегти регістр CX
    push dx             ; зберегти регістр DX
    
    mov bx, 10          ; база десяткової системи числення
    xor cx, cx          ; CX = 0 (лічильник розрядів)
    mov dx, 0           ; обнулення DX (результуюче число)
    
digit_loop:
    xor dx, dx          ; обнулення DX перед кожним діленням
    div bx              ; ділення AX на 10, результат у DX (остача) та AX (ціла частина)
    push dx             ; зберегти остачу у стеку
    inc cx              ; збільшення лічильника розрядів
    test ax, ax         ; перевірка, чи AX ще містить значення
    jnz digit_loop      ; якщо є ще цифри, повторення
    
print_digits:
    pop dx              ; витягнути цифру зі стеку
    add dl, '0'         ; перетворення числа у символ
    mov ah, 0           ; AH = 0 (функція DOS для виведення символа)
    int 21h             ; виклик переривання DOS
    loop print_digits   ; виведення всіх цифр
    
    pop dx              ; відновлення регістра DX
    pop cx              ; відновлення регістра CX
    pop bx              ; відновлення регістра BX
    pop ax              ; відновлення регістра AX
    ret                 ; повернення з підпрограми
;;;;;;;;;;;;;;;;;;;;
; Підпрограма для порівняння двох рядків
compare_strings:
    push si             ; зберегти регістр SI
    push di             ; зберегти регістр DI
    
    mov si, ax          ; завантажити адресу першого рядка у SI
    mov di, bx          ; завантажити адресу другого рядка у DI
    
compare_loop:
    mov al, [si]        ; завантажити символ з першого рядка у AL
    mov ah, [di]        ; завантажити символ з другого рядка у AH
    cmp al, ah          ; порівняти символи
    jne end_compare     ; якщо символи не рівні, завершити порівняння
    cmp al, 0           ; перевірити, чи досягнуто кінця рядків
    je strings_equal    ; якщо так, рядки рівні
    
    inc si              ; перейти до наступного символу першого рядка
    inc di              ; перейти до наступного символу другого рядка
    jmp compare_loop   ; повторити порівняння
    
strings_equal:
    xor ax, ax          ; обнулити регістр AX (результат порівняння, рядки рівні)
    jmp end_compare     ; завершити порівняння
    
end_compare:
    pop di              ; відновити регістр DI
    pop si              ; відновити регістр SI
    ret                 ; повернення з підпрограми

average_loop:
    mov bl, [si]        ; Load current value from keys_average
    add ax, bx          ; Add current value to the sum in AX
    adc dx, 0           ; Add carry flag to the high word sum in DX
    inc si              ; Move to the next value in keys_average
    loop average_loop   ; Repeat until all values are processed

    ; At this point, the sum is in DX:AX

    ; Now, we divide the 32-bit sum by the count of keys (keys_count = 10000)
    mov bx, keys_count  ; Load count of keys
    xor dx, dx          ; Clear DX for division
    div bx              ; DX:AX / BX, result in AX

    ; AX now holds the average value

    search_values_for_current_key:
    mov si, dx               ; Store the address in dx into si

    cmp byte ptr [si], bl   ; Compare the current key with the key in the array
    jne next_key            ; If keys don't match, jump to the next key
    add ax, word ptr [di]   ; Add the corresponding value to the sum
    inc cx                  ; Increment the counter for the number of values

next_key:
    inc dx                ; Перехід до наступного ключа у масиві ключів
    inc di                ; Перехід до наступного значення у масиві значень
    cmp dx, offset keys + keys_count ; Перевірка на кінець масиву ключів
    jne search_values_for_current_key ; Якщо не кінець масиву, продовження пошуку
    cmp cx, 0            ; Перевірка чи були знайдені значення для поточного ключа
    je no_values_found   ; Якщо значень не знайдено, перехід до наступного ключа
    cwd                  ; Розширення AX до DX:AX для ділення
    idiv cx              ; Ділення суми на кількість значень
    mov [bx], ax         ; Зберігання середнього значення в масиві середніх значень
no_values_found:
    inc si               ; Перехід до наступного ключа у масиві ключів
    inc bx               ; Перехід до наступного значення у масиві середніх значень
    cmp si, offset keys + keys_count ; Перевірка на кінець масиву ключів
    jne average_loop       ; Якщо не кінець масиву, продовження обчислень
    ret


bubble_sort:
    mov si, offset keys_average  ; Початок масиву середніх значень
    mov cx, keys_count            ; Кількість ключів для сортування
outer_loop:
    mov di, si            ; Початок поточного проходження
    mov bx, cx            ; Зберігання кількості порівнянь
inner_loop:
    mov ax, [di]          ; Завантаження першого значення
    mov dx, [di + 2]      ; Завантаження другого значення
    cmp ax, dx            ; Порівняння
    jge skip_swap         ; Перехід, якщо поточний елемент менший або рівний наступному
    xchg ax, dx           ; Обмін значень
    mov [di], ax          ; Зберігання першого значення
    mov [di + 2], dx      ; Зберігання другого значення
skip_swap:
    add di, 4             ; Перехід до наступної пари значень
    dec bx                ; Зменшення лічильника порівнянь
    jnz inner_loop        ; Перехід, якщо не кінець внутрішнього циклу
    dec cx                ; Зменшення лічильника ключів
    jnz outer_loop        ; Перехід, якщо не кінець зовнішнього циклу
    ret

write_sorted_keys:
    mov si, offset keys_average  ; Початок масиву середніх значень
    mov cx, keys_count            ; Кількість ключів для виведення
write_loop:
    mov ax, [si]          ; Завантаження середнього значення
    call write_number     ; Виведення середнього значення
    mov dl, ' '           ; Пробіл між середнім значенням та ключем
    mov ah, 2             ; Функція DOS для виведення символа
    int 21h               ; Виклик переривання DOS
    mov si, offset keys  ; Початок масиву ключів
    call write_string    ; Виведення ключа
    mov dl, 0Dh           ; Символ переведення рядка
    mov ah, 2             ; Функція DOS для виведення символа
    int 21h               ; В
call write_sorted_keys      
call write_loop
    ; mov ax, [si]          ; Завантаження середнього значення
    ; call write_number     ; Виведення середнього значення
    ; mov dl, ' '           ; Пробіл між середнім значенням та ключем
    ; mov ah, 2             ; Функція DOS для виведення символа
    ; int 21h               ; Виклик переривання DOS
    ; mov si, offset keys  ; Початок масиву ключів
    ; call write_string    ; Виведення ключа
    ; mov dl, 0Dh           ; Символ переведення рядка
    ; mov ah, 2             ; Функція DOS для виведення символа
    ; int 21h  
                 ; Виклик переривання DOS
    mov dl, 0Ah           ; Символ переведення рядка
    mov ah, 2             ; Функція DOS для виведення символа
    int 21h               ; Виклик переривання DOS
    add si, 2             ; Перехід до наступного середнього значення
    loop write_loop       ; Повторення виведення для наступного ключа
    ret


write_number:
    push ax               ; Збереження регістра AX
    mov bx, 10            ; База десяткової системи числення
    xor cx, cx            ; CX = 0 (лічильник цифр)
    mov dx, 0             ; Обнулення DX (результуючого числа)
    call digit_loop
    pop dx                ; Витягування цифри зі стеку
    add dl, '0'           ; Перетворення числа у символ
    mov ah, 2             ; Функція DOS для виведення символа
    int 21h               ; Виклик переривання DOS
    loop print_digit     ; Виведення всіх цифр
    pop ax                ; Відновлення регістра AX
    ret

print_digit:
    pop dx            ; Витягнути останню цифру зі стеку
    add dl, '0'       ; Перетворити число у символ
    mov ah, 2         ; Функція DOS для виведення символу
    int 21h           ; Виклик переривання DOS
    dec cx            ; Зменшення лічильника циклу
    jnz print_digit  ; Повторення, якщо ще є цифри для виведення
    ret               ; Повернення з підпрограми

write_string:
    mov ah, 9             ; Функція DOS для виведення рядка
    int 21h               ; Виклик переривання DOS
    ret

read_file:
    mov ah, 3Fh         ; DOS function to read from file
    mov bx, 0           ; stdin handle
    mov cx, buffer_size ; Number of bytes to read (buffer size)
    mov dx, offset buffer ; Buffer to store the read characters
    int 21h             ; Call DOS interrupt
    ret

end_program:
    mov ah, 4Ch         ; Функція DOS для завершення програми
    int 21h             ; Виклик переривання DOS
    ret                 ; Повернення з підпрограми


    ; Завершення програми
    jmp end_program

start ENDP
end start
