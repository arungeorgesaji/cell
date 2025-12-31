; Work in progress 
%include "defines.asm"

section .data
struc KeyBinding
    .key:       resw 1
    .modifiers: resb 1
    .command:   resq 1
    .data:      resq 1
    .next:      resq 1
endstruc

section .bss
key_bindings: resq 1

section .text
global kb_bind_key
global kb_unbind_key
global kb_handle_input
global kb_get_binding

extern malloc
extern free

kb_bind_key:
    push rbp
    mov rbp, rsp
    
    mov rdi, KeyBinding_size
    call malloc
    test rax, rax
    jz .failed
    
    mov [rax + KeyBinding.key], di
    mov [rax + KeyBinding.modifiers], sil
    mov [rax + KeyBinding.command], rdx
    mov [rax + KeyBinding.data], rcx
    
    mov rcx, [key_bindings]
    mov [rax + KeyBinding.next], rcx
    mov [key_bindings], rax
    
    mov rax, 1
    jmp .done
    
.failed:
    xor rax, rax
    
.done:
    pop rbp
    ret

kb_handle_input:
    push rbp
    mov rbp, rsp
    push rbx
    
    mov rbx, rdi
    mov rdx, rsi  
    
    mov rax, [key_bindings]
    
.search_loop:
    test rax, rax
    jz .not_found
    
    cmp bx, [rax + KeyBinding.key]
    jne .next
    
    mov cl, [rax + KeyBinding.modifiers]
    cmp cl, dl
    jne .next
    
    mov rdi, [rax + KeyBinding.data]
    call [rax + KeyBinding.command]
    
    mov rax, 1
    jmp .done
    
.next:
    mov rax, [rax + KeyBinding.next]
    jmp .search_loop
    
.not_found:
    xor rax, rax
    
.done:
    pop rbx
    pop rbp
    ret
