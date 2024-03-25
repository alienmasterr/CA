calculate_average:

    xor dx, dx          ; Clear DX (high word of 32-bit sum)
    xor ax, ax          ; Clear AX (low word of 32-bit sum)
    mov cx, keys_count  ; Load count of keys for loop
    mov si, 0           ; Start index for keys_average

average_loop:
    mov bl, [si]        ; Load current value from keys_average
    add ax, bx          ; Add current value to the sum in AX
    adc dx, 0           ; Add carry flag to the high word sum in DX
    inc si              ; Move to the next value in keys_average
    loop average_loop   ; Repeat until all values are processed


    ; At this point, the sum is in DX:AX


    ; Now, we divide the 32-bit sum by the count of keys (keys_count = 10000)
    mov bx, keys_count  ; Load count of keys
    xor dx, dx          ; Clear DX for division
    div bx              ; DX:AX / BX, result in AX


    ; AX now holds the average value