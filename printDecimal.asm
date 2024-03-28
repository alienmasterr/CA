.model small
.stack 100h

.data
.code
start PROC
    mov ax, @data       ; Initialize data segment
    mov ds, ax

    call printWordAtDx

    ; Exit program
    mov ah, 4Ch         ; DOS function to terminate program
    int 21h

start ENDP

printWordAtDx proc
prepare_print:

    mov si, dx;mov dx, offset char_buffer ; store read chars
    mov ax, [si] ; Load the value
    mov si, offset numStr + 5 + 1
    mov bx, 10

converLoop:
    dec si
    xor dx, dx
    div bx
    add dl, '0'
    mov [si], dl

    test ax, ax
    jnz convertLoop

print_decimal:
    mov dx, si
    mov ah, 09h
    int 21h

printWordAtDx ENDP
start end