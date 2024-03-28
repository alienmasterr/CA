.model small
.stack 100h

.data
.code
start PROC
    mov ax, @data       ; Initialize data segment
    mov ds, ax

    call read_file     ; Read from file
    call write_buffer  ; Write the read content to stdout

    ; Exit program
    mov ah, 4Ch         ; DOS function to terminate program
    int 21h

start ENDP

readLineChars proc
save_regs:-
init_read_line_chars:
    xor cx, cx

read_char_loop:
    cmp cx, lineLength-1
    jae end_read_line_chars

    push bx;     mov bx, word ptr new_key_ind
    push cx
    mov dx, offset charBuffer
    mov ah, 3Fh
    mov bx, 0
    mov cx, 1
    int 21h
    pop cx
    pop bx

    or ax, ax
    jz finalize_input

    mov al, [charBuffer]

readLineChars ENDP

end start