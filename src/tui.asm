%include "defines.asm"

section .text
global clear_screen
global set_cursor
global print_char
global print_string

clear_screen:
    push rbp
    mov rbp, rsp
    
    mov rsi, clear_seq
    mov rdx, clear_seq_len
    call _print_ansi
    
    mov rsi, home_seq
    mov rdx, home_seq_len
    call _print_ansi
    
    pop rbp
    ret

set_cursor:
    push rbp
    mov rbp, rsp
    push rdi
    push rsi
    
    pop rsi
    pop rdi
    pop rbp
    ret

print_char:
    push rbp
    mov rbp, rsp
    
    sub rsp, 1
    mov [rsp], dil
    
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rsp
    mov rdx, 1
    syscall
    
    add rsp, 1
    pop rbp
    ret

print_string:
    push rbp
    mov rbp, rsp
    push rbx
    mov rbx, rdi
    
    xor rcx, rcx

.find_len:
    cmp byte [rbx + rcx], 0
    je .print_it
    inc rcx
    jmp .find_len
    
.print_it:
    test rcx, rcx
    jz .done
    
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rbx
    mov rdx, rcx
    syscall
    
.done:
    pop rbx
    pop rbp
    ret

_print_ansi:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    syscall
    ret

section .data
clear_seq:      db 0x1b, '[2J'
clear_seq_len:  equ $ - clear_seq
home_seq:       db 0x1b, '[H'
home_seq_len:   equ $ - home_seq
