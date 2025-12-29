%include "../include/defines.asm"

section .data
    title db 'Box Drawing Test', 0
    prompt db 'Press any key to continue, Q to quit', 0

section .text
global _start

_start:
    call cell_init
    test rax, rax
    js .error
    
.main_loop:
    call clear_screen
    call hide_cursor
    
    mov rdi, 1
    mov rsi, 30
    call set_cursor
    call set_color_cyan
    call set_color_bright
    mov rdi, title
    call print_string
    
    call reset_color
    
    mov rdi, 3
    mov rsi, 10
    mov rdx, 20
    mov rcx, 5
    call draw_box
    
    mov rdi, 3
    mov rsi, 40
    mov rdx, 30
    mov rcx, 8
    call draw_box
    
    mov rdi, 10
    mov rsi, 15
    mov rdx, 25
    mov rcx, 6
    mov r8, '#'
    call fill_rect
    
    mov rdi, 12
    mov rsi, 45
    mov rdx, 20
    mov rcx, '='
    call draw_hline
    
    mov rdi, 5
    mov rsi, 60
    mov rdx, 10
    mov rcx, '|'
    call draw_vline
    
    mov rdi, 15
    mov rsi, 20
    mov rdx, 40
    mov rcx, 10
    call draw_box
    
    mov rdi, 17
    mov rsi, 22
    mov rdx, 36
    mov rcx, 6
    call draw_box
    
    mov rdi, 4
    mov rsi, 12
    call set_cursor
    mov rdi, .box1_text
    call print_string
    
    mov rdi, 4
    mov rsi, 42
    call set_cursor
    mov rdi, .box2_text
    call print_string
    
    mov rdi, 19
    mov rsi, 22
    call set_cursor
    mov rdi, .nested_text
    call print_string
    
    mov rdi, 24
    mov rsi, 20
    call set_cursor
    call set_color_yellow
    mov rdi, prompt
    call print_string
    
    call reset_color
    call show_cursor
    
    call wait_key
    
    cmp al, 'q'
    je .exit
    cmp al, 'Q'
    je .exit
    
    jmp .main_loop
    
.exit:
    xor rdi, rdi
    call cell_exit
    
.error:
    mov rdi, 1
    call cell_exit

    .box1_text db 'Small Box', 0
    .box2_text db 'Medium Box', 0
    .nested_text db 'Nested Boxes', 0

extern cell_init, cell_exit, clear_screen, set_cursor, print_string
extern set_color_cyan, set_color_bright, set_color_yellow, reset_color
extern hide_cursor, show_cursor, wait_key
extern draw_box, fill_rect, draw_hline, draw_vline
