%include "defines.asm"

section .text
global get_char
global get_char_nb
global wait_key
global kbhit

section .bss
input_buffer: resb 1

section .text

get_char:
    push rbp
    mov rbp, rsp
    
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, input_buffer
    mov rdx, 1
    syscall
    
    cmp rax, 1
    jl .error
    movzx rax, byte [input_buffer]
    jmp .done

.error:
    mov rax, -1
    
.done:
    pop rbp
    ret

get_char_nb:
    push rbp
    mov rbp, rsp
    
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, input_buffer
    mov rdx, 1
    syscall
    
    cmp rax, 0
    je .no_input
    cmp rax, 1
    jl .error
    
    movzx rax, byte [input_buffer]
    jmp .done

.no_input:
    xor rax, rax
    jmp .done
    
.error:
    mov rax, -1
    
.done:
    pop rbp
    ret

wait_key:
    push rbp
    mov rbp, rsp

.wait:
    call get_char
    cmp rax, -1
    je .wait
    
    pop rbp
    ret

kbhit:
    push rbp
    mov rbp, rsp
    
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, input_buffer
    mov rdx, 1
    syscall
    
    cmp rax, 1
    jge .has_key
    
    xor rax, rax
    jmp .done

.has_key:
    mov rax, 1

.done:
    pop rbp
    ret
