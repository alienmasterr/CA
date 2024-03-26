.model small
.stack 100h


.data

file_error_message db "error $"
not_fucked db "f $", 0Dh, 0Ah

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

    call check
    call read_next
    call check
    ;call printArrays ; Print the arrays
   
    ; Open the file
    mov ah, 3Dh         
    mov al, 0           
    int 21h             
 
   ; jc file_error      
    mov [file], ax  

; Read file
read_next:

;;;;;;;;;;;;;;;;;;;;;;;;
    call check
;;;;;;;;;;;;;;;;;;;;;;

    mov ah, 3Fh         
    mov bx, [file] 
    mov cx, 1      ;побайтово
    mov dx, offset current_char ; store read chars
    int 21h            

    or ax, ax           ; Check end or error 
    jz file_close       ; ax = 0 -> end of file

     ; Process the character
    push ax
    push bx
    push cx
    push dx
    call procChar
    pop dx
    pop cx
    pop bx
    pop ax


    jmp read_next 

file_close:
    call check
    mov ah, 3Eh         
    mov bx, [file] 
    int 21h 

    jmp ending


ending:
    mov ah, 4Ch         ; DOS function to exit the program
    int 21h             ; Call DOS interrupt
    ret
 

main endp

procChar proc

    cmp current_char, 0Dh
    jnz notCR
    mov isWord, 1
    ;call trnInNum
    jmp endProc
notCR:
    cmp current_char, 0Ah
    jnz notLF
    mov isWord, 1
    jmp endProc
notLF:
    cmp current_char, 20h
    jnz notSpace
    mov isWord, 0
    ;call checkKey
    jmp endProc
notSpace:
    cmp isWord, 0
    jnz itsWord
    mov si, offset number_buffer
    mov bx, number_buffer_ind
    add si, bx
    mov al, current_char
    mov [si], al
    inc number_buffer_ind
    jmp endProc
itsWord:
    mov si, offset single_key_buffer
    mov bx, key_buffer_ind
    add si, bx
    mov al, current_char
    mov [si], al
    inc key_buffer_ind
endProc:
    ret
procChar endp


check proc
    mov ah, 09h
    mov dx, offset not_fucked
    int 21h
check endp

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
printArrays proc
    mov cx, word ptr new_key_ind ; Load the number of keys

printLoop:
    ; Print key
    mov si, offset single_key_buffer
    mov di, offset keys_array
    mov bx, word ptr new_key_ind
    shl bx, 4 ; Multiply by 16 (size of a key)
    add di, bx ; Point to the current key
    mov dx, 16 ; Key size
    call printString

    ; Print value
    mov ax, [si] ; Load the value
    call printNumber
    call printNewLine

    ; Move to the next key
    add si, 16 ; Move to the next key in the buffer
    loop printLoop

    ret
printArrays endp

printString proc
    mov ah, 09h ; Print string
    int 21h
    ret
printString endp

printNumber proc
    ; Your code to print a number goes here
    ret
printNumber endp

printNewLine proc
    mov ah, 02h ; Print character
    mov dl, 0Dh ; Carriage return
    int 21h
    mov dl, 0Ah ; Line feed
    int 21h
    ret
printNewLine endp

end main