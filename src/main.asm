%include "defines.asm"

section .text
global cell_init
global cell_exit

cell_init:
    push rbp
    mov rbp, rsp
    xor rax, rax
    pop rbp
    ret

cell_exit:
    push rbp
    mov rbp, rsp
    mov rax, SYS_EXIT
    syscall
