;підпрограма, що конвертує десяткове значення у вигляді рядка
;в бінарне представлення (слово) у доповнювальному коді 

; Підпрограма для конвертації десяткового значення у вигляді рядка в бінарне представлення (слово) у доповнювальному коді
; Приймає рядок з десятковим числом в DX, повертає бінарне представлення в AX

; .data

; .code

; decimal_top:
;     push bx
;     xor dx, dx
;     mov ;     mov bx, ax        ; Move the binary representation to BX


;такс ну запускається, але не працює
.model small
.stack 100h

.data
    dec_value dw ?      ; Variable to store decimal value
    binary_string db 32 dup(?)  ; Buffer to store binary string
    
    newline db 13, 10, '$'  ; Newline characters for printing

.code
main proc
    mov ax, @data        ; Initialize data segment
    mov ds, ax

    ; Open the file
   
    mov ax, 3D00h       ; Open file function
    int 21h            ; DOS interrupt
    jc file_error      ; Jump if error

    mov bx, ax         ; Store file handle

    ; Read decimal value from file
    mov dx, offset dec_value
    mov cx, 2          ; Number of bytes to read
    mov ah, 3Fh        ; Read from file function
    int 21h            ; DOS interrupt
    jc file_error      ; Jump if error

    ; Close the file
    mov ah, 3Eh        ; Close file function
    int 21h            ; DOS interrupt

    ; Convert decimal value to binary
    mov cx, 32           ; Counter for the loop, assuming 32-bit integer
    mov ax, [dec_value]  ; Load decimal value into AX

convert_loop:
    shr ax, 1            ; Shift the decimal value right by 1 bit
    adc bx, 0            ; Add the carry flag to BX (0 or 1)
    shl bx, 1            ; Shift BX left by 1 bit
    loop convert_loop    ; Continue the loop until CX becomes zero

    ; Print binary string
    mov si, offset binary_string  ; Load address of binary string
    mov cx, 16           ; Set loop counter for printing binary string
print_loop:
    mov dl, '0'          ; Load '0' character into DL
    test bx, 00000001b   ; Test least significant bit
    jz zero_bit          ; Jump if least significant bit is 0
    mov dl, '1'          ; Load '1' character into DL
zero_bit:
    mov [si], dl         ; Store character in binary string buffer
    inc si               ; Move to next character in buffer
    shr bx, 1            ; Shift BX right by 1 bit
    loop print_loop      ; Continue loop until CX becomes zero

    ; Print newline characters
    mov dx, offset newline  ; Load newline characters
    mov ah, 09h           ; Function to print string
    int 21h               ; Call DOS interrupt

    ; Terminate program
    mov ax, 4C00h        ; Terminate program
    int 21h

file_error:
    ; Handle file error
    mov ax, 4C01h        ; Exit with error code 1
    int 21h

main endp
end main
