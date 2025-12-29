%include "defines.asm"

section .text
global str_len
global str_copy
global str_cat
global str_cmp
global str_find
global format_int
global format_hex

extern int_to_str

section .bss
format_buffer: resb 64

section .text

str_len:
    push rbp
    mov rbp, rsp
    
    xor rax, rax
    
.loop:
    cmp byte [rdi + rax], 0
    je .done
    inc rax
    jmp .loop
    
.done:
    pop rbp
    ret

str_copy:
    push rbp
    mov rbp, rsp
    push rsi
    push rdi
    
.loop:
    mov al, [rsi]
    mov [rdi], al
    test al, al
    jz .done
    inc rsi
    inc rdi
    jmp .loop
    
.done:
    pop rax             
    pop rsi
    pop rbp
    ret

str_cat:
    push rbp
    mov rbp, rsp
    push rdi
    push rsi
    
.find_end:
    cmp byte [rdi], 0
    je .copy
    inc rdi
    jmp .find_end
    
.copy:
    mov al, [rsi]
    mov [rdi], al
    test al, al
    jz .done
    inc rsi
    inc rdi
    jmp .copy
    
.done:
    pop rsi
    pop rax             
    pop rbp
    ret

str_cmp:
    push rbp
    mov rbp, rsp
    
.loop:
    mov al, [rdi]
    mov bl, [rsi]
    test al, al
    jz .check_str2
    cmp al, bl
    jne .diff
    inc rdi
    inc rsi
    jmp .loop
    
.check_str2:
    test bl, bl
    jz .equal
    mov rax, -1
    jmp .done
    
.equal:
    xor rax, rax
    jmp .done
    
.diff:
    sub al, bl
    movsx rax, al
    
.done:
    pop rbp
    ret

str_find:
    push rbp
    mov rbp, rsp
    
.loop:
    mov al, [rdi]
    test al, al
    jz .not_found
    cmp al, sil
    je .found
    inc rdi
    jmp .loop
    
.found:
    mov rax, rdi
    jmp .done
    
.not_found:
    xor rax, rax
    
.done:
    pop rbp
    ret

format_int:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    
    mov rbx, rdi        
    mov r12, 10         
    
    test rax, rax
    jns .positive
    
    mov byte [rbx], '-'
    inc rbx
    neg rax
    
.positive:
    call int_to_str
    
    mov rax, rdi        
    
    pop r12
    pop rbx
    pop rbp
    ret

format_hex:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    
    mov rbx, rdi        
    mov r12, rax        
    mov r13, 16         
    
    mov byte [rbx], '0'
    mov byte [rbx + 1], 'x'
    add rbx, 2
    
    mov rcx, 16        
    
.convert_loop:
    mov rax, r12
    and al, 0xF

    cmp al, 10
    jb .digit
    add al, 'a' - 10
    jmp .store
    
.digit:
    add al, '0'
    
.store:
    mov [rbx], al
    inc rbx

    shr r12, 4        
    dec rcx
    jnz .convert_loop
    
    mov byte [rbx], 0
    
    mov rax, rdi       
    
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
