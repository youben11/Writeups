[BITS 64]

global _start

_start:
call get_ip ; get adr within our code
add rax, 31 ; add offset to the flag
mov rdi, rax ; arg1 for print_string
call print_string ; print the flag at adr pointed by rdi
hlt ; stop to show the flag

get_ip:
  call next_line
  next_line:
  pop rax
  ret

print_string:
    xor rcx,rcx ; I don't know why I did this inst at that time, I was really tired
    mov rcx, 0xb8000; adr where to put character to be printed
    mov ah, 0x1f; white fonts and blue background
    
    loop_string:
    mov al, byte[rdi] ; character to be printed
    cmp al,0 ; stop when it's null byte
    je end_string
    mov WORD [rcx], ax ; copy the two byte to 0xb8000+offset in the form of (color:character)
    add rcx, 2 ; we move throught the video memory 
    inc rdi ; we move through our string
    jmp loop_string
    
    end_string:
    ret
