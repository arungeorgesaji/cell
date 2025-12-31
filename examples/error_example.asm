%include "../include/defines.asm"   

section .data
    intro_msg       db "Error handling system test", 10, 0
    trigger_msg     db "Triggering error code ", 0
    result_prefix   db "Result: ", 0
    newline         db 10, 0

section .text
global _start

extern cell_set_error
extern cell_get_last_error
extern cell_get_error_string
extern cell_clear_error

print_string:
    push rax
    push rdi
    push rsi
    push rdx
    push rcx
    push r11
    push r8
    push r9
    push r10

    mov rsi, rdi            
    mov rdx, 0              
.count_loop:
    cmp byte [rsi + rdx], 0
    je .done_count
    inc rdx
    jmp .count_loop
.done_count:
    test rdx, rdx
    jz .exit                

    mov rax, 1              
    mov rdi, 1              
    syscall

.exit:
    pop r10
    pop r9
    pop r8
    pop r11
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

_start:
    mov rdi, intro_msg
    call print_string

    mov rdi, ERR_INIT_FAILED
    mov rsi, 0             
    call cell_set_error

    mov rdi, trigger_msg
    call print_string
    mov rdi, -1
    call print_number     

    mov rdi, result_prefix
    call print_string
    call cell_get_last_error
    mov rdi, rax
    call cell_get_error_string
    mov rdi, rax
    call print_string
    mov rdi, newline
    call print_string

    call cell_clear_error

    mov rdi, ERR_NOT_TTY
    mov rsi, 0
    call cell_set_error

    mov rdi, trigger_msg
    call print_string
    mov rdi, -2
    call print_number

    mov rdi, result_prefix
    call print_string
    call cell_get_error_string
    mov rdi, rax
    call print_string
    mov rdi, newline
    call print_string

    mov rdi, -10
    mov rsi, 0
    call cell_set_error

    mov rdi, trigger_msg
    call print_string
    mov rdi, -10
    call print_number

    mov rdi, result_prefix
    call print_string
    call cell_get_error_string
    mov rdi, rax
    call print_string
    mov rdi, newline
    call print_string

    call cell_clear_error

    mov rax, 60             
    xor rdi, rdi
    syscall

print_number:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi

    test rdi, rdi
    jns .positive

    mov rax, 1
    mov rsi, minus_sign
    mov rdx, 1
    mov rdi, 1
    syscall

    neg rdi                 

.positive:
    mov rax, rdi
    mov rbx, num_buffer + 20
    mov byte [rbx], 0       
    dec rbx

    mov rcx, 10
.convert_loop:
    xor rdx, rdx
    div rcx                 
    add dl, '0'
    mov [rbx], dl
    dec rbx
    test rax, rax
    jnz .convert_loop

    inc rbx                 
    mov rdi, rbx
    call print_string

    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

section .bss
    num_buffer resb 32

section .data
    minus_sign db '-'
