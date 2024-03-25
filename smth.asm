.model small
.stack 100h

.data
    filename db "input.txt", 0  ; Filename for input
    buffer db 6 dup(?)          ; Buffer to store input
    dec_value dw ?              ; Decimal value to convert
    binary_string db 16 dup(?)  ; Buffer to store binary string
    newline db 13, 10, '$'      ; Newline characters for printing

.code
main proc
    mov ax, @data        ; Initialize data segment
    mov ds, ax

    ; Open the file
    mov dx, offset filename
    mov ah, 3Dh           ; DOS service number for opening a file
    mov al, 0             ; Open for reading
    int 21h               ; Call DOS interrupt
    jc file_error         ; Jump if error

    ; Read the decimal value from the file
    mov bx, ax            ; Store file handle
    mov dx, offset buffer ; Buffer for reading
    mov cx, 6             ; Number of bytes to read
    mov ah, 3Fh           ; DOS service number for reading from a file
    int 21h               ; Call DOS interrupt
    jc file_error         ; Jump if error

    mov si, offset buffer ; Load address of buffer
    call atoi             ; Convert ASCII string to integer
    mov [dec_value], ax   ; Store decimal value

    ; Close the file
    mov ah, 3Eh           ; DOS service number for closing a file
    int 21h               ; Call DOS interrupt

    ; Convert decimal value to binary
    mov cx, 16            ; Counter for the loop, assuming 16-bit integer
    mov ax, [dec_value]   ; Load decimal value into AX

convert_loop:
    shr ax, 1             ; Shift the decimal value right by 1 bit
    adc bx, 0             ; Add the carry flag to BX (0 or 1)
    shl bx, 1             ; Shift BX left by 1 bit
    loop convert_loop     ; Continue the loop until CX becomes zero

    mov si, offset binary_string  ; Load address of binary string
    mov cx, 16            ; Set loop counter for printing binary string
print_loop:
    mov dl, '0'           ; Load '0' character into DL
    test bx, 00000001b    ; Test least significant bit
    jz zero_bit           ; Jump if least significant bit is 0
    mov dl, '1'           ; Load '1' character into DL
zero_bit:
    mov [si], dl          ; Store character in binary string buffer
    inc si                ; Move to next character in buffer
    shr bx, 1             ; Shift BX right by 1 bit
    loop print_loop       ; Continue loop until CX becomes zero

    ; Print binary string
    mov dx, offset binary_string  ; Load address of binary string
    mov ah, 09h                    ; Function to print string
    int 21h                        ; Call DOS interrupt

    ; Print newline
    mov dx, offset newline  ; Load newline characters
    mov ah, 09h             ; Function to print string
    int 21h                 ; Call DOS interrupt

    ; Exit program
    mov ax, 4C00h       ; Terminate program
    int 21h            ; Call DOS interrupt

file_error:
    mov dx, offset file_error_msg
    mov ah, 09h
    int 21h

    ; Exit program with error code
    mov ax, 4C01h       ; Terminate program with error code
    int 21h            ; Call DOS interrupt

main endp

atoi proc
    xor ax, ax        ; Clear AX (result)
    xor cx, cx        ; Clear CX (loop counter)
atoi_loop:
    mov dl, [si]      ; Load next character
    cmp dl, '$'       ; Check for end of string
    je atoi_done      ; If end of string, done
    sub dl, '0'       ; Convert ASCII to digit
    cmp dl, 0         ; Check if valid digit
    jl atoi_error     ; If not a valid digit, error
    cmp dl, 9
    jg atoi_error
    mov cx, ax
    mov ax, 10
    mul cx       ; Multiply current result by 10
    add ax, dx        ; Add current digit to result
    inc si            ; Move to next character
    inc cx            ; Increment loop counter
    cmp cx, 5         ; Check for max length (5 digits)
    jle atoi_loop     ; If not reached max length, continue loop
    jmp atoi_done     ; If reached max length, done
atoi_error:
    mov ax, 0         ; Set result to 0 (error)
    jmp atoi_done
atoi_done:
    ret
atoi endp

file_error_msg db "Error opening or reading file!", '$'

end main
