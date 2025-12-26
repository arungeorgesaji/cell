%include "defines.asm"

section .text
global int_to_str
global delay

int_to_str:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    
    test rax, rax
    jns .positive
    
    mov byte [rdi], '-'
    inc rdi
    neg rax
    
.positive:
    mov rbx, rdi       
    mov r12, 10         
    
    test rax, rax
    jnz .convert
    mov byte [rdi], '0'
    inc rdi
    jmp .done
    
.convert:
    xor rcx, rcx        
    
.divide_loop:
    xor rdx, rdx
    div r12             
    add dl, '0'         
    push rdx            
    inc rcx
    
    test rax, rax
    jnz .divide_loop
    
.reverse:
    pop rax
    mov [rdi], al
    inc rdi
    loop .reverse
    
.done:
    mov byte [rdi], 0   
    
    pop r12
    pop rbx
    pop rbp
    ret

delay:
    push rbp
    mov rbp, rsp
    
    mov rcx, rdi

.delay_loop:
    pause
    loop .delay_loop
    
    pop rbp
    ret
