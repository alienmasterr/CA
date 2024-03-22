
;ВИВОДИло ЩОСЬ тільки не ясно що і де бере його
.model small
.stack 100h

.data
    charArray db 23 dup(0) ; Declare an array of 23 bytes

.code
start PROC
    mov ax, @data
    mov ds, ax

    ; Read 23 characters from the keyboard
    mov cx, 23 ; Set the counter to 23
    lea bx, charArray 
    readChars:
        mov ah, 01h 
        int 21h 
        mov [bx], al ; Store the character in the array
        inc bx 
        loop readChars ; Repeat until all characters have been read

    ; Write 23 characters to the console
    mov cx, 23 
    lea bx, charArray 
    writeChars:
        mov dl, [bx] ; Load the character from the array into dl
        mov ah, 02h ; Set the function number for writing a character
        int 21h 
        inc bx 
        loop writeChars ; Repeat until all characters have been written

   
    mov ax, 4c00h 
    int 21h 
start ENDP

END start