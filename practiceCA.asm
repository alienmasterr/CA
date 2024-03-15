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

read_next:
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset oneChar   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    ; do something with [oneChar]
    or ax,ax
    jnz read_next
