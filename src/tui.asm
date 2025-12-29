%include "defines.asm"

section .data
clear_seq:      db 0x1b, '[2J'
clear_seq_len:  equ $ - clear_seq
home_seq:       db 0x1b, '[H'
home_seq_len:   equ $ - home_seq
reset_seq:      db 0x1b, '[0m'
reset_seq_len:  equ $ - reset_seq
hide_cursor_seq: db 0x1b, '[?25l'
hide_cursor_len: equ $ - hide_cursor_seq
show_cursor_seq: db 0x1b, '[?25h'
show_cursor_len: equ $ - show_cursor_seq
query_cursor_pos: db 0x1b, '[6n'
query_cursor_len: equ $ - query_cursor_pos
far_position_seq: db 0x1b, '[999;999H'
far_position_len: equ $ - far_position_seq

section .bss
term_response: resb 32

section .text
global clear_screen
global set_cursor
global print_char
global print_string
global set_color
global set_color_red
global set_color_green
global set_color_blue
global set_color_cyan
global set_color_yellow
global set_color_bright
global reset_color
global hide_cursor
global show_cursor
global get_term_size

extern int_to_str

clear_screen:
    push rbp
    mov rbp, rsp
    
    mov rsi, clear_seq
    mov rdx, clear_seq_len
    call _print_ansi
    
    mov rsi, home_seq
    mov rdx, home_seq_len
    call _print_ansi
    
    pop rbp
    ret

set_cursor:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    
    mov r12, rdi        
    mov r13, rsi        
    
    sub rsp, 32         
    
    mov rdi, rsp      
    mov byte [rdi], 0x1b    
    mov byte [rdi + 1], '[' 
    lea rdi, [rsp + 2]
    
    mov rax, r12
    call int_to_str
    
    mov byte [rdi], ';'
    inc rdi
    
    mov rax, r13
    call int_to_str
    
    mov byte [rdi], 'H'
    inc rdi
    
    mov rsi, rsp        
    mov rdx, rdi
    sub rdx, rsi        
    
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    syscall
    
    add rsp, 32         
    
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

print_char:
    push rbp
    mov rbp, rsp
    
    sub rsp, 1
    mov [rsp], dil
    
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rsp
    mov rdx, 1
    syscall
    
    add rsp, 1
    pop rbp
    ret

print_string:
    push rbp
    mov rbp, rsp
    push rbx
    mov rbx, rdi
    
    xor rcx, rcx

.find_len:
    cmp byte [rbx + rcx], 0
    je .print_it
    inc rcx
    jmp .find_len
    
.print_it:
    test rcx, rcx
    jz .done
    
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rbx
    mov rdx, rcx
    syscall

.done:
    pop rbx
    pop rbp 
    ret

get_term_size:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push rbx
    
    mov rsi, far_position_seq
    mov rdx, far_position_len
    call _print_ansi
    
    mov rsi, query_cursor_pos
    mov rdx, query_cursor_len
    call _print_ansi
    
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, term_response
    mov rdx, 31
    syscall
    
    cmp rax, 6          
    jl .default_size
    
    mov r12, term_response
    
    add r12, 2
    
    xor rax, rax
    xor rcx, rcx
    
.parse_rows:
    movzx rcx, byte [r12]
    inc r12
    cmp cl, ';'
    je .parse_cols
    cmp cl, 0
    je .default_size
    sub cl, '0'
    cmp cl, 9
    ja .default_size     
    imul rax, 10
    add rax, rcx
    jmp .parse_rows
    
.parse_cols:
    mov r13, rax         
    xor rax, rax
    
.parse_cols_loop:
    movzx rcx, byte [r12]
    inc r12
    cmp cl, 'R'
    je .done
    cmp cl, 0
    je .default_size
    sub cl, '0'
    cmp cl, 9
    ja .default_size     
    imul rax, 10
    add rax, rcx
    jmp .parse_cols_loop
    
.default_size:
    mov r13, 24          
    mov rax, 80          
    
.done:
    mov rbx, rax         
    mov rax, r13         
    
    pop rbx
    pop r13
    pop r12
    pop rbp
    ret

set_color:
    mov eax, SYS_WRITE
    mov edi, STDOUT
    syscall
    ret

%macro DEFINE_COLOR 3
global set_color_%1
set_color_%1:
    mov rsi, %2
    mov rdx, %3
    jmp set_color
%endmacro

DEFINE_COLOR red,     COLOR_RED,     COLOR_RED_LEN
DEFINE_COLOR green,   COLOR_GREEN,   COLOR_GREEN_LEN
DEFINE_COLOR blue,    COLOR_BLUE,    COLOR_BLUE_LEN
DEFINE_COLOR cyan,    COLOR_CYAN,    COLOR_CYAN_LEN
DEFINE_COLOR yellow,  COLOR_YELLOW,  COLOR_YELLOW_LEN
DEFINE_COLOR bright,  COLOR_BRIGHT,  COLOR_BRIGHT_LEN

reset_color:
    push rbp
    mov rbp, rsp
    
    mov rsi, COLOR_RESET
    mov rdx, COLOR_RESET_LEN
    call set_color
    
    pop rbp
    ret

hide_cursor:
    push rbp
    mov rbp, rsp
    
    mov rsi, CURSOR_HIDE
    mov rdx, CURSOR_HIDE_LEN
    call set_color
    
    pop rbp
    ret

show_cursor:
    push rbp
    mov rbp, rsp
    
    mov rsi, CURSOR_SHOW
    mov rdx, CURSOR_SHOW_LEN
    call set_color
    
    pop rbp
    ret

_print_ansi:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    syscall
    ret
