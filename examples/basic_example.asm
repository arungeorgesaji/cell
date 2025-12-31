section .data
    msg1 db 'Basic TUI Test', 0
    msg2 db 'Screen cleared successfully!', 0
    msg3 db 'Cursor positioned at (10, 20)', 0
    msg4 db 'Press any key to exit...', 0

section .text
global _start

_start:
    call cell_init
    test rax, rax
    js .error
    
    call clear_screen
    
    call hide_cursor
    
    mov rdi, 5
    mov rsi, 10
    call set_cursor
    
    call set_color_cyan
    call set_color_bright
    mov rdi, msg1
    call print_string
    
    mov rdi, 7
    mov rsi, 10
    call set_cursor
    call reset_color
    mov rdi, msg2
    call print_string
    
    mov rdi, 9
    mov rsi, 10
    call set_cursor
    mov rdi, msg3
    call print_string
    
    mov rdi, 20
    mov rsi, 10
    call set_cursor
    call set_color_yellow
    mov rdi, msg4
    call print_string
    
    call show_cursor
    call reset_color
    
    call wait_key
    
    xor rdi, rdi
    call cell_exit
    
.error:
    mov rdi, 1
    call cell_exit

extern cell_init, cell_exit, clear_screen, set_cursor, print_string
extern set_color_cyan, set_color_bright, set_color_yellow, reset_color
extern hide_cursor, show_cursor, wait_key
