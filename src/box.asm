; Not working right now
%include "defines.asm"

section .text
global draw_box
global draw_hline
global draw_vline
global fill_rect

extern set_cursor
extern print_char

section .data
box_chars:
    .tl: db 0xe2, 0x94, 0x8c  
    .tr: db 0xe2, 0x94, 0x90  
    .bl: db 0xe2, 0x94, 0x94  
    .br: db 0xe2, 0x94, 0x98  
    .h:  db 0xe2, 0x94, 0x80  
    .v:  db 0xe2, 0x94, 0x82  

ascii_box_chars:
    .tl: db '+'
    .tr: db '+'
    .bl: db '+'
    .br: db '+'
    .h:  db '-'
    .v:  db '|'

section .text

draw_box:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    mov r12, rdi        
    mov r13, rsi        
    mov r14, rdx        
    mov r15, rcx        
    
    mov rdi, r12
    mov rsi, r13
    call set_cursor
    
    mov dil, 0xe2       
    call print_char
    mov dil, 0x94
    call print_char
    mov dil, 0x8c
    call print_char
    
    mov rcx, r14
    sub rcx, 2
    jle .draw_sides_loop
    
.top_line:
    mov dil, 0xe2
    call print_char
    mov dil, 0x94
    call print_char
    mov dil, 0x80
    call print_char
    loop .top_line
    
    mov dil, 0xe2
    call print_char
    mov dil, 0x94
    call print_char
    mov dil, 0x90
    call print_char
    
    mov rbx, r15
    sub rbx, 2
    jle .draw_bottom
    
.draw_sides_loop:
    inc r12
    
    mov rdi, r12
    mov rsi, r13
    call set_cursor
    
    mov dil, 0xe2
    call print_char
    mov dil, 0x94
    call print_char
    mov dil, 0x82
    call print_char
    
    mov rdi, r12
    mov rax, r13
    add rax, r14
    dec rax
    mov rsi, rax
    call set_cursor
    
    mov dil, 0xe2
    call print_char
    mov dil, 0x94
    call print_char
    mov dil, 0x82
    call print_char
    
    dec rbx
    jnz .draw_sides_loop
    
.draw_bottom:
    inc r12
    
    mov rdi, r12
    mov rsi, r13
    call set_cursor
    
    mov dil, 0xe2
    call print_char
    mov dil, 0x94
    call print_char
    mov dil, 0x94
    call print_char
    
    mov rcx, r14
    sub rcx, 2
    jle .bottom_right
    
.bottom_line:
    mov dil, 0xe2
    call print_char
    mov dil, 0x94
    call print_char
    mov dil, 0x80
    call print_char
    loop .bottom_line
    
.bottom_right:
    mov dil, 0xe2
    call print_char
    mov dil, 0x94
    call print_char
    mov dil, 0x98
    call print_char
    
.done:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

    align 16

draw_hline:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    
    mov r12, rdi        
    mov r13, rsi        
    mov rbx, rdx        
    
    mov rdi, r12
    mov rsi, r13
    call set_cursor
    
    test rcx, rcx
    jnz .char_set
    mov rcx, '-'
    
.char_set:
.draw_loop:
    mov dil, cl
    call print_char
    dec rbx
    jnz .draw_loop
    
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

    align 16

draw_vline:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    
    mov r12, rdi       
    mov r13, rsi        
    mov rbx, rdx        
    
    test rcx, rcx
    jnz .char_set
    mov rcx, '|'
    
.char_set:
.draw_loop:
    mov rdi, r12
    mov rsi, r13
    call set_cursor
    
    mov dil, cl
    call print_char
    
    inc r12
    dec rbx
    jnz .draw_loop
    
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

    align 16

fill_rect:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    mov r12, rdi        
    mov r13, rsi        
    mov r14, rdx        
    mov r15, rcx        
    mov rbx, r8         
    
.row_loop:
    mov rdi, r12
    mov rsi, r13
    call set_cursor
    
    mov rcx, r14

.col_loop:
    mov dil, bl
    call print_char
    loop .col_loop
    
    inc r12
    dec r15
    jnz .row_loop
    
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
