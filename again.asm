.model small
.stack 100h


.data

file_error_message db "error $"
not_fucked db "Not fucked yet $", 0Dh, 0Ah

file dw 0
current_char db 0
current_ind dw 0
new_key_ind dw 0

keys_array db 10000*16 dup(0) ;розраховано, що усі 10000 рядків матимуть ключ в 16 символів
single_key_buffer db 16 dup(0) ; максимальний розмір одного ключа
number_buffer db 16 dup(0)

isWord db 1

key_buffer_ind dw 0
value_array dw 10000 dup(0)
number_buffer_ind dw 0
arrays_num dw 3000 dup(0)

.code
main proc
    mov ax, @data
    mov ds, ax

    ;call check
    call read_next
    ;call check

    ; Open the file
    mov ah, 3Dh         
    mov al, 0           
    int 21h             
 
   ; jc file_error      
    mov [file], ax  

; Read file
read_next:

    ;call check
    mov ah, 09h
    mov dx, offset not_fucked
    int 21h

    mov ah, 3Fh         
    mov bx, [file] 
    mov cx, 1      ;побайтово
    mov dx, offset current_char ; store read chars
    int 21h            
;call check
    or ax, ax           ; Check end or error 
   ; jz file_close       ; ax = 0 -> end of file

main endp



; check proc
;     mov ah, 09h
;     mov dx, offset not_fucked
;     int 21h
; check endp


end main