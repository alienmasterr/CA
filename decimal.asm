.model small


.data

MESSAGE DB "enter a num: $"
MESSAGE1 DB 10, 13, "the num is $"
.code

_main proc
    mov dl, 33

    mov ah, 02h
    int 21h  

_main endp

main:
    mov ax, @data
    mov ds, ax

    call _main

    mov ax, 4c00h
    int 21h
end main




