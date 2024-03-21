;НЕ ПОВНОЦІННА ПРОГРАМА, А ТІЛЬКИ МАЛЕНЬКІ РАНДОМНІ ТЕСТИ І ЧАСТИНИ ДЛЯ РОЗУМІННЯ ТРАГІЧНОСТІ СИТУАЦІЇ


;Прочитати з stdin N рядків до появи EOF (максимум 10000 рядків)
;читати посимвольно stdin (і зупинитись, коли буде EOF)

.model small
.stack 100h

.data
MAX_ROWS equ 10000 ; константа кількості рядків
MAX_KEY_LENGTH equ 16 ; константа довжини ключа
CR equ 0Dh ; каретка
LF equ 0Ah ; переведення рядка

;обробка та зберігання введених даних
input_buffer db 255 dup(?) ; створює буфер для зберігання введених даних 
                            ;кожен елемент буде байтом -- db
                            ;255 dup(?) -- місце для 255 байтів
                            ;Кожен байт буде використовуватись для зберігання одного символу введення
key_value_pair struct ;для зберігання пари "ключ-значення"
    key db MAX_KEY_LENGTH dup(?) ;масив байтів для зберігання ключа
                                ;MAX_KEY_LENGTH dup(?) -- місце для MAX_KEY_LENGTH байтів у масиві.
    value dw ? ;вказує на двобайтове значення (word), яке визначає значення, що відповідає ключу.
key_value_pair ends

unique_keys key_value_pair MAX_ROWS dup(?) ;масив для зберігання унікальних пар
                                            ;dup(?) -- створити MAX_ROWS копій у масиві.
unique_count dw 0 ;каунтер унікальних пар
                    ;dw -- двобайтове ціле число (word)
                    ;початкове значення 0

.code
main:

;загальна ініціалізація усього та виклик усіх методів
 mov ax, @data
    mov ds, ax

    call read_input
    call group ;отут буде потім якийсь метод групування
    call sort ;тут буде щось для сортування

    mov ax, 4C00h
    int 21h

read_input:
    mov bx, 0  ; stdin handle

;цей метод треба відредагувати під свою програму
;;;;;;;;;;;;;;;;;;;;;;     
read_next:
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset oneChar   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    ; do something with [oneChar]
    or ax,ax
    jnz read_next
;;;;;;;;;;;;;;;;;;;;;