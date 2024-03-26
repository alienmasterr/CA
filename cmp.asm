.model small
.stack 100h
;запускається код з гітхаба, але лише запускається
.data
src db "Test sentence",0
lenSrc equ ($ - src)
dst db "Test sentence",0
lenDst equ ($ - dst)

.code
_main proc

; compare string lengths
mov ax, lenSrc
cmp ax, lenDst
jne notequal

; when lengths are equal execute CMPS
lea si, src
lea di, dst
mov cx, lenSrc
cld
repe cmpsb

; after CMPS, see if it ended successfully
jnz notequal

; equality things
jmp done

notequal:
; non-equality things

done:
mov ax, 4c00h
int 21h

_main endp
end _main
