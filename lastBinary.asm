.model small
.stack 100h

.data
    number_buffer db "12345", 0  ; Decimal number as a string
    result_buffer db 16 dup(0)   ; Buffer to store the binary result

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Call the convert_to_binary procedure
    call convert_to_binary

    ; Print the result
    mov ah, 02h          ; DOS function to print a string
    mov dx, offset result_buffer  ; Load the offset of the result buffer
    int 21h              ; Call DOS interrupt

    ; Exit the program
    mov ah, 4Ch          ; DOS function to exit the program
    int 21h              ; Call DOS interrupt

main endp

convert_to_binary proc
    ; Your convert_to_binary implementation goes here
    xor bx, bx
    mov cx, 0

calculate:
    mov si, offset number_buffer
    add si, number_buffer_ind
    dec si
    sub si, cx
    xor ax, ax
    mov al, [si]
    cmp ax, 45
    jnz not_minus
    neg bx
    jmp end_calculation

not_minus:
    sub al, '0'
    push cx
    cmp cx, 0
    jnz not_0
    jmp end_multiplication

not_0:
    multiply_10:
    mov dx, 10
    mul dx
    dec cx
    cmp cx, 0
    jnz multiply_10

end_multiplication:
    pop cx
    add bx, ax
    inc cx
    cmp cx, number_buffer_ind
    jnz calculate

end_calculation:
    mov si, offset result_buffer
    mov ax, bx
    mov cx, 16  ; Assuming 16-bit binary representation
    print_binary:
        shl ax, 1  ; Shift the most significant bit into the carry flag
        jc set_bit  ; If carry flag is set, the bit was 1
        mov byte ptr [si], '0'  ; Set the bit to '0'
        jmp next_bit
        set_bit:
            mov byte ptr [si], '1'  ; Set the bit to '1'
        next_bit:
            inc si  ; Move to the next character in the result buffer
        loop print_binary  ; Continue until all bits are printed

    mov byte ptr [si], '$'  ; Null-terminate the result buffer

    ret
convert_to_binary endp

end main
