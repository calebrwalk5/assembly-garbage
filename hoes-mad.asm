global _start

section .data
  align 2
  str       db 'hoes mad lol', 0xA
  strLen    equ $-str
  
  section .bss
  
  section .text
            _start:
            ; code goes here
            int 0x80
