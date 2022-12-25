; x86 assembly code for Grandpa, from Caleb
message db "Merry Christmas, Grandpa!", 0

mov ah, 0x0e  
; set the function number for the "teletype output" function
mov si, message
; move the message to the source index register

; tell the BIOS to print the message to the screen
print_loop:
    lodsb ; load the next character
    cmp al, 0  ; check for the end of the message, i used 0 to mark the end
    je done  ; jump to done if the program reached the end
    int 0x10  ; BIOS interrupt
    jmp print_loop  ; jump back to the loop

done:
    ret
