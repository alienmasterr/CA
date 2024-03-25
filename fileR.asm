.model small
.stack 100h

.data
buffer_size equ 29     ; Define the size of the buffer
buffer db buffer_size dup(?)  ; Define a buffer to hold the read characters
key_buffer db 16 dup(?) ; Buffer to hold the key
value_buffer db 6 dup(?) ; Buffer to hold the value

.code
start PROC
    mov ax, @data       ; Initialize data segment
    mov ds, ax

    call read_file     ; Read from file
    call process_buffer  ; Process the read content
    ; Exit program
    mov ah, 4Ch         ; DOS function to terminate program
    int 21h             ; Call DOS interrupt
start ENDP

read_file:
    mov ah, 3Fh         ; DOS function to read from file
    mov bx, 0           ; stdin handle
    mov cx, buffer_size ; Number of bytes to read (buffer size)
    mov dx, offset buffer ; Buffer to store the read characters
    int 21h             ; Call DOS interrupt
    ret

process_buffer:
    mov si, offset buffer ; Set SI to point to buffer
    next_line:
        call read_key_value ; Read key and value from buffer
        cmp byte ptr [si], 0 ; Check for end of buffer
        je end_process_buffer
        add si, 2 ; Move to the next line
    jmp next_line
    end_process_buffer:
    ret

read_key_value:
    mov di, offset key_buffer ; Set DI to point to key_buffer
    mov cx, 16 ; Maximum length of key
    read_key:
        lodsb ; Load byte from SI into AL, and increment SI
        cmp al, ' ' ; Check for space
        je end_read_key ; If space, end of key
        stosb ; Store AL into DI, and increment DI
    loop read_key
    end_read_key:
    mov byte ptr [di], 0 ; Null terminate key
    mov di, offset value_buffer ; Set DI to point to value_buffer
    mov cx, 6 ; Maximum length of value
    read_value:
        lodsb ; Load byte from SI into AL, and increment SI
        cmp al, 13 ; Check for carriage return
        je end_read_value ; If carriage return, end of value
        stosb ; Store AL into DI, and increment DI
    loop read_value
    end_read_value:
    mov byte ptr [di], 0 ; Null terminate value
    call convert_to_binary ; Convert value to binary
    ret

convert_to_binary:
    xor ax, ax ; Clear AX
    mov si, offset value_buffer ; Set SI to point to value_buffer
    mov di, offset key_buffer ; Set DI to point to key_buffer
    next_digit:
        lodsb ; Load byte from SI into AL, and increment SI
        cmp al, 0 ; Check for null terminator
        je end_convert_to_binary ; If null terminator, end of value
        sub al, '0' ; Convert character to integer
        ; Assuming AX contains the value to be multiplied by 10

mov bx, ax    ; Save the original value of AX
add ax, ax    ; Multiply by 2
add ax, ax    ; Multiply by 4
add ax, ax    ; Multiply by 8
add ax, bx    ; Add the original value to get the result of multiplying by 10
        add ax, ax ; Multiply existing value by 10
        add ax, ax ; Multiply existing value by 10
        add ax, di ; Add current digit to value
    jmp next_digit
    end_convert_to_binary:
    ; AX now contains binary representation of value
    ret

end start

