%include "../include/defines.asm"

section .data
    hello db 'Welcome to Cell TUI Library!', 0xA, 0
    prompt db 'Press any key...', 0xA, 0

section .text
global _start

_start:
    call cell_init
    
    call clear_screen
    
    mov rdi, hello
    call print_string
    
    mov rdi, prompt
    call print_string
    
    sub rsp, 1
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, rsp
    mov rdx, 1
    syscall
    
    xor rdi, rdi    
    call cell_exit

extern cell_init
extern cell_exit
extern clear_screen
extern print_string
