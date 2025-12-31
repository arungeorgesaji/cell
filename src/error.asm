%include "defines.asm"

err_msgs:
    dq err_init, err_not_tty, err_ioctl, err_malloc, err_input

err_init:    db "Failed to initialize terminal", 0
err_not_tty: db "Not a terminal device", 0
err_ioctl:   db "Terminal control failed", 0
err_malloc:  db "Memory allocation failed", 0
err_input:   db "Invalid input", 0

section .bss
last_error: resq 1
error_context: resq 256  

section .text
global cell_get_last_error
global cell_get_error_string
global cell_set_error
global cell_clear_error

cell_set_error:
    push rbp
    mov rbp, rsp
    
    mov [last_error], rdi
    
    test rsi, rsi
    jz .done
    
    push rsi
    mov rdi, error_context
    mov rcx, 255
    rep movsb
    mov byte [rdi], 0
    pop rsi
    
.done:
    pop rbp
    ret

cell_get_last_error:
    mov rax, [last_error]
    ret

cell_get_error_string:
    push rbp
    mov rbp, rsp
    
    cmp rdi, 0
    jge .invalid
    
    neg rdi
    dec rdi
    cmp rdi, 5
    jae .invalid
    
    mov rax, [err_msgs + rdi*8]
    jmp .done
    
.invalid:
    mov rax, .unknown
    jmp .done
    
.unknown: db "Unknown error", 0
    
.done:
    pop rbp
    ret

cell_clear_error:
    xor rax, rax
    mov [last_error], rax
    ret
