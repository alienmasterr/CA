;НЕ ПОВНОЦІННА ПРОГРАМА, А ТІЛЬКИ МАЛЕНЬКІ РАНДОМНІ ТЕСТИ І ЧАСТИНИ ДЛЯ РОЗУМІННЯ ТРАГІЧНОСТІ СИТУАЦІЇ


;Прочитати з stdin N рядків до появи EOF (максимум 10000 рядків)
;читати посимвольно stdin (і зупинитись, коли буде EOF)


read_next:
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset oneChar   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    ; do something with [oneChar]
    or ax,ax
    jnz read_next
