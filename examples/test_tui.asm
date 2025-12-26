%include "../include/defines.asm"

section .data
    hello db 'Welcome to Cell TUI Library!', 0
    prompt db 'Press any key to exit...', 0
    colors_test db 'Color Test!', 0

section .text
global _start

_start:
    call cell_init
    
    call clear_screen
    call hide_cursor
    
    mov rdi, 5
    mov rsi, 20
    call set_cursor
    
    call set_color_cyan
    call set_color_bright
    
    mov rdi, hello
    call print_string
    
    mov rdi, 8
    mov rsi, 20
    call set_cursor
    
    call set_color_red
    mov rdi, colors_test
    call print_string
    
    mov rdi, 10
    mov rsi, 20
    call set_cursor
    
    call set_color_green
    call set_color_bright
    mov rdi, colors_test
    call print_string
    
    mov rdi, 12
    mov rsi, 20
    call set_cursor
    
    call set_color_yellow
    call set_color_bright
    mov rdi, prompt
    call print_string
    
    call reset_color
    call show_cursor
    
    mov rdi, 15
    mov rsi, 20
    call set_cursor
    
    sub rsp, 1
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, rsp
    mov rdx, 1
    syscall
    
    xor rdi, rdi    
    call cell_exit

extern cell_init
extern cell_exit
extern clear_screen
extern print_string
extern set_cursor
extern set_color
extern set_color_red
extern set_color_green
extern set_color_blue
extern set_color_cyan
extern set_color_yellow
extern set_color_bright
extern reset_color
extern hide_cursor
extern show_cursor
