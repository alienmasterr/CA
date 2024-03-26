.model small
.stack 100h
;працюючий бабл сорт, який друкує результати в консоль
.data
array dw 3, 2, 6, 4, 1
count dw 5
newline db 13, 10, '$'

.code
_main proc
    mov cx, word ptr count
    dec cx  ; count-1
outerLoop:
    push cx
    lea si, array
innerLoop:
    mov ax, [si]
    cmp ax, [si+2]
    jl nextStep
    xchg [si+2], ax
    mov [si], ax
nextStep:
    add si, 2
    loop innerLoop
    pop cx
    loop outerLoop

    mov dx, offset newline
    mov ah, 09h
    int 21h

    mov cx, word ptr count
    mov si, offset array
printLoop:
    mov ax, [si]
    call print_word
    add si, 2
    loop printLoop

    mov ax, 4c00h
    int 21h
_main endp

print_word proc
    push bx
    mov bx, 10
    xor dx, dx
    div bx
    push dx
    test ax, ax
    jz no_more_digits
    call print_word
no_more_digits:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    pop bx
    ret
print_word endp

main:
    mov ax, @data
    mov ds, ax

    call _main

    mov ax, 4c00h
    int 21h
end main
