.model small
.stack 100h
; Редагує кількість виведених байтів
.data
buffer_size equ 10    ; Define the size of the buffer
buffer db buffer_size dup(?)  ; Define a buffer to hold the read characters

.code
start PROC
    mov ax, @data       ; Initialize data segment
    mov ds, ax

    call read_file     ; Read from file
    call write_buffer  ; Write the read content to stdout

    ; Exit program
    mov ah, 4Ch         ; DOS function to terminate program
    int 21h             ; Call DOS interrupt

read_file:
    mov ah, 3Fh         ; DOS function to read from file
    mov bx, 0           ; stdin handle
    mov cx, buffer_size ; Number of bytes to read (buffer size)
    mov dx, offset buffer ; Buffer to store the read characters
    int 21h             ; Call DOS interrupt
    ret

write_buffer:
    mov ah, 40h         ; DOS function to write to file
    mov bx, 1           ; stdout handle
    mov cx, buffer_size ; Number of bytes to write (buffer size)
    mov dx, offset buffer ; Buffer containing the characters to write
    int 21h             ; Call DOS interrupt
    ret

start ENDP
end start
