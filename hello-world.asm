org 100h

mov dx, Loop
mov ah, 9
int 21h

mov ax, 4c00h
int 21h

Loop:
  jmp msg

msg:
  db "Hello World!"
  jmp Loop
