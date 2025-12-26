%include "defines.asm"

section .text
global int_to_str
global delay

int_to_str:
    push rbp
    mov rbp, rsp

    pop rbp
    ret

delay:
    push rbp
    mov rbp, rsp
    
    pop rbp
    ret
