%include "defines.asm"

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
