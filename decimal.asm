.model small

.data

MESSAGE DB "enter a num: $"
MESSAGE1 DB 10, 13, "the num is $"
.code

main:

    mov dl, 33

    mov ah, 02h
    int 21h 

    mov ah, 4ch
    int 21h
end main
.exit




