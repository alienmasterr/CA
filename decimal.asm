.model small

.data

MESSAGE DB "enter a num: $"
MESSAGE1 DB 10, 13, "the num is $"
.code
;переведення десяткового значення в аскі
main:
    mov dl, 100

    mov ah, 02h
    int 21h 

    mov ah, 4ch
    int 21h
end main
.exit




