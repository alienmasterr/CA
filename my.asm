; to_char proc
; pop dx
; pop bx; 
; shl bx,1
; mov ax, [numbers_array+bx]; 
; cmp ax, 10000
; jc positive
;     neg ax
; positive:
; shr bx, 1
; push bx
; push dx
; mov cx,15;
; convert_toChar_loop:
;     mov dx,0
;     mov bx,10
;     div bx; 
;     mov si, offset keys_buffer
;     add si, cx; 
;     add dx, '0'
;     mov [si], dl
;     cmp ax, 0
;     jnz contSetNumb
;         mov bx, 16
;         mov num_buffer_ind, bx
;         sub num_buffer_ind, cx
;         ;jmp reverse_number
;     contSetNumb:
;     dec cx
;     cmp cx, -1
;     jne convert_toChar_loop  

; reverse_number:
; mov cx, max_key_length
; sub cx, num_buffer_ind
; mov dx,0
; reverse:
;     mov si, offset keys_buffer
;     add si, cx
;     mov di, offset numbers_buffer
;     add di, dx
;     mov al,[si]
;     mov [di], al
;     inc dx
;     inc cx
;     cmp cx,16
;     jnz reverse
; ret

; to_char endp

; make_neg proc
; mov bx,cx
; shl bx,1
; mov ax, [numbers_array+bx]; 
; cmp ax, 10000
; jc positive_num
;     mov ah,02h
;     mov dl, '-'
;     int 21h
; positive_num:
; ret
; make_neg endp