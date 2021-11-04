org     100h   

mov     ax, 3
int     10h

mov     ax, 1003h
mov     bx, 1      ; enable blinking
int     10h
  
mov     dl, 0     ; column
mov     dh, 0     ; row

mov     bl, 0

jmp     next_char

next_row:
inc     dh
cmp     dh, 16
je      stop_print
mov     dl, 0

next_char:

; cursor position (dl,dh)
mov     ah, 02h
int     10h

mov     al, 'a'
mov     bh, 0
mov     cx, 1
mov     ah, 09h
int     10h

inc     bl

inc     dl
cmp     dl, 16
je      next_row
jmp     next_char

stop_print:

; cursor position (dl,dh)
mov     dl, 10  ; column
mov     dh, 5   ; row
mov     ah, 02h
int     10h

mov     al, 'x'
mov     ah, 0eh
int     10h

mov ah, 0
int 16h         ; wait for keypress

ret
