%include "defines.asm"

section .text
global str_len
global str_copy
global str_cat
global str_cmp
global str_find
global format_int
global format_hex

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
    push rdi             
    xor rcx, rcx

.loop:
    mov al, [rsi + rcx]
    mov [rdi + rcx], al
    test al, al
    jz .done
    inc rcx
    jmp .loop

.done:
    mov rax, rcx         
    pop rdi
    pop rbp
    ret

str_cat:
    push rbp
    mov rbp, rsp
    push rdi
    push rsi

    xor rax, rax

.find_end:
    cmp byte [rdi + rax], 0
    je .found_end
    inc rax
    jmp .find_end

.found_end:
    push rdi             
    add rdi, rax         

    xor rcx, rcx

.copy_loop:
    mov al, [rsi + rcx]
    mov [rdi + rcx], al
    test al, al
    jz .copy_done
    inc rcx
    jmp .copy_loop

.copy_done:
    add rax, rcx         
    pop rdi
    pop rsi
    pop rdi
    pop rbp
    ret

str_cmp:
    push rbp
    mov rbp, rsp

.loop:
    mov al, [rdi]
    mov bl, [rsi]
    cmp al, bl
    jne .diff
    test al, al
    jz .equal
    inc rdi
    inc rsi
    jmp .loop

.equal:
    xor rax, rax
    jmp .done

.diff:
    movzx rax, al
    movzx rbx, bl
    sub rax, rbx
    
.done:
    pop rbp
    ret

str_find:
    push rbp
    mov rbp, rsp
    test rsi, rsi
    jz .needle_empty
    mov al, [rsi]
    test al, al
    jz .needle_empty    

.outer_loop:
    mov al, [rdi]
    test al, al
    jz .not_found
    push rdi
    push rsi
    mov rcx, rdi
    mov rdx, rsi

.match_loop:
    mov bl, [rdx]       
    test bl, bl         
    jz .found
    mov al, [rcx]       
    cmp al, bl
    jne .no_match
    inc rcx
    inc rdx
    jmp .match_loop

.no_match:
    pop rsi
    pop rdi
    inc rdi
    jmp .outer_loop

.needle_empty:
    mov rax, rdi        
    jmp .done

.found:
    pop rsi
    pop rdi
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
    push rdi             

    mov rbx, rdi         
    mov ecx, 10

    test eax, eax
    jns .positive
    mov byte [rbx], '-'
    inc rbx
    neg eax

.positive:
    mov rdi, rbx
    add rdi, 32          
    mov byte [rdi], 0
    dec rdi

.convert_loop:
    test eax, eax
    jz .done_convert
    xor edx, edx
    div ecx             
    add dl, '0'
    mov [rdi], dl
    dec rdi
    jmp .convert_loop

.done_convert:
    test esi, esi
    jns .copy_back
    dec rdi            

.copy_back:
    inc rdi

.copy_loop:
    mov al, [rdi]
    mov [rbx], al
    inc rbx
    inc rdi
    test al, al
    jnz .copy_loop

    pop rax              
    mov rdx, rbx
    sub rdx, rax
    dec rdx              
    mov rax, rdx         

    pop rbx
    pop rbp
    ret

format_hex:
    push rbp
    mov rbp, rsp
    push rbx
    push rdi

    mov rbx, rdi         
    mov eax, esi         

    mov word [rbx], '0x'
    add rbx, 2

    test eax, eax
    jnz .convert
    mov byte [rbx], '0'
    inc rbx
    jmp .done

.convert:
    mov rcx, 28

.extract_loop:
    mov edx, eax
    shr edx, cl
    and dl, 0xF
    cmp dl, 10
    jb .digit
    add dl, 'a' - 10
    jmp .store

.digit:
    add dl, '0'

.store:
    mov [rbx], dl
    inc rbx
    sub rcx, 4
    jns .extract_loop

    mov rdi, rbx
    sub rdi, 1

.remove_leading:
    cmp rdi, rbx
    jae .done_remove
    cmp byte [rdi], '0'
    jne .done_remove
    mov byte [rdi], 0
    dec rdi
    jmp .remove_leading

.done_remove:

    cmp byte [rbx-1], '0'
    jne .done
    cmp word [rbx-3], '0x'
    jne .done
    mov byte [rbx-1], 0    

.done:
    mov byte [rbx], 0
    pop rax                
    mov rdx, rbx
    sub rdx, rax
    dec rdx                
    mov rax, rdx

    pop rbx
    pop rbp
    ret
