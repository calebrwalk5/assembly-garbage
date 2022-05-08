; snake written in nasm assembly 
; how to run:
; nasm -fbin snake.asm -o snake && qemu-system-i386 snake

%DEFINE EMPTY 0b0000_0000
%DEFINE SNAKE 0b0000_0001
%DEFINE FRUIT 0b0000_0010
%DEFINE EATEN 0b0000_0100
%DEFINE WRECK 0b0000_1000
%DEFINE DIRUP 0b0001_0000
%DEFINE DIRDO 0b0010_0000
%DEFINE DIRLE 0b0100_0000
%DEFINE DIRRI 0b1000_0000
%define map(i) byte [es:i]
%define head word [es:1024]
%define tail word [es:1026]
%define fpos word [es:1028]
%define ftim word [es:1030]
%define rand word [es:1032]

init:
    .segments
        mov ax, 0x07C0
        mov ds, ax
        mov ax, 0x7E00
        mov es, ax
        mov ax, 0xA000
        mov gs, ax
        mov ax, 0
        mov fs, ax
    .psuedorandom
        mov ah, 0
        int 0x1A
        mov rand, dx
    .display
        mov ah, 0x00
        mov al, 0x13
        mov ran, dx
    .quit
        mov [fs:0x08*4], word timer
		mov [fs:0x08*4+2], ds
		mov [fs:0x09*4], word keyboard
		mov [fs:0x09*4+2], ds

main:
    hlt
    jmp main ; loop :D

psuedorandom:
    mov ax, rand
    mov dx, 7993
    mov cx, 9781
    mul dx
    add ax, cx
    mov rand, ax
    ret

movement: 
    mov cl, map(si)
	mov ax, si
	mov dl, 32
	div dl
	test cl, DIRUP
	jz $+4
	dec al
	test cl, DIRDO
	jz $+4
	inc al
	test cl, DIRLE
	jz $+4
	dec ah
	test cl, DIRRI
	jz $+4
	inc ah
	and al, 31
	and ah, 31
	movzx di, al
	rol di, 5
	movzx cx, ah
	add di,cx
	ret

keyboard:
    in al, 0x60
    mov bx, head
    mov ah, map(bx)
    cmp al, 0x39
    jne, $+12
    mov cx, 1032
    mov al, 0
    mov di, 0
    rep stosb
    and ah, 0x0F
	cmp al, 0x48
	jne $+5
	or ah, DIRUP
	cmp al, 0x50
	jne $+5
	or ah, DIRDO
	cmp al, 0x4b
	jne $+5
	or ah, DIRLE
	cmp al, 0x4d
	jne $+5
	or ah, DIRRI
	test ah, 0xF0
	jz $+4
	mov map(bx), ah
	mov al, 0x61
	out 0x20, al
	iret

timer: 
    .tick_clock:
        int 0x70
    .move_head:
        move si, head
        call movement
        move ah, map(di)
        mov al, map(si)
        tesxt al, WRECK
        jz $+3
        iret
        test ah, SNAKE|EATEN
        jz $+7
        mov map(si), WRECK
        iret
        test ah, FRUIT
        jz $+20
        mov ftim, 0
        mov fpos, -1
        mov bl, EATEN
        jmp $+4
        mov bl, SNAKE
        and al, 0xF0
        or bl, al
        mov map(di), bl
        mov head, di
    .move_tail:
        mov si, tail
		call movement
		mov al, map(si)
		test al, SNAKE
		jz $+11
		mov map(si), EMPTY
		mov tail, di
		jnz $+9
		and al, 0xF0
		or al, SNAKE
		mov map(si), al
	.move_fruit:
		cmp ftim, 0
		jne $+42
		mov bx, fpos
		mov map(bx), EMPTY
		call psuedorandom
		mov bx, ax
		and bx, 1023
		cmp map(bx), EMPTY
		jne $-13
		mov map(bx), FRUIT
		mov fpos, bx
		mov ftim, 64
		dec ftim
	.redraw:
		mov cx, 0
		mov ax, cx
		mov dl, 32
		div dl
		mov bx, ax
		movzx ax, bl
		add ax, 9
		mov dx, 320
		mul dx
		movzx dx, bh
		add ax, dx
		add ax, 24
		mov dx, 4
		mul dx
		mov di, cx
		mov dl, map(di)
		and dl, 0x0F
		cmp dl, EMPTY
		jne $+8
		mov ebx, 0x02020202
		cmp dl, SNAKE
		jne $+8
		mov ebx, 0x01010101
		cmp dl, FRUIT
		jne $+8
		mov ebx, 0x04040404
		cmp dl, EATEN
		jne $+8
		mov ebx, 0x05050505
		mov di, ax
		mov [gs:di],ebx
		add di, 320
		mov [gs:di],ebx
		add di, 320
		mov [gs:di],ebx
		add di, 320
		mov [gs:di],ebx
		inc cx
		cmp cx, 1024
		jne .redraw+3
	iret

times 510-($-$$) db 0
dw 0AA55h
