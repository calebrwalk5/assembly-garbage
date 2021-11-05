section .bss
number resb 4
 
section .data
fizz: db "fizz"
buzz: db "buzz"
newLine: db 10
 
section .text
global _start
 
_start:
  mov rax, 1
  loop:
    push rax
    call fizzBuzz
    pop rax
    inc rax
    cmp rax, 100
    jle loop
 
  mov rax, 60
  mov rdi, 0
  syscall
 
fizzBuzz:
  mov r10, rax
  mov r15, 0
  checkFizz:
    xor rdx, rdx
    mov rbx, 3
    div rbx
    cmp rdx, 0
    jne checkBuzz
    mov r15, 1
    mov rsi, fizz
    mov rdx, 4
    mov rax, 1
    mov rdi, 1
    syscall
  checkBuzz:
    mov rax, r10
    xor rdx, rdx
    mov rbx, 5
    div rbx
    cmp rdx, 0
    jne finishLine
    mov r15, 1
    mov rsi, buzz
    mov rdx, 4
    mov rax, 1
    mov rdi, 1
    syscall
  finishLine:
    cmp r15, 1
    je nextLine
    mov rax, r10
    call printNum
    ret
    nextLine:
      mov rsi, newLine
      mov rdx, 1
      mov rax, 1
      mov rdi, 1
      syscall
      ret
 
printNum:
  cmp rax, 100
  jl lessThanHundred
  mov byte [number], 49
  mov byte [number + 1], 48
  mov byte [number + 2], 48
  mov rdx, 3
  jmp print
 
  lessThanHundred:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add rdx, 48
    cmp rax, 0
    je lessThanTen
    add rax, 48
    mov byte [number], al
    mov byte [number + 1], dl
    mov rdx, 2
    jmp print
 
  lessThanTen:
    mov byte [number], dl
    mov rdx, 1
  print:
    mov byte [number + rdx], 10
    inc rdx
    mov rax, 1
    mov rdi, 1
    mov rsi, number
    syscall
  ret
