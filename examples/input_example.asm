%include "../include/defines.asm"   

section .data
    msg1 db 'Input Functions Test', 0
    msg2 db '1. Press a key (blocking)', 0
    msg3 db '2. Waiting for key (non-blocking)', 0
    msg4 db 'Press Q to quit', 0
    got_key db 'Got key: ', 0
    timeout_msg db 'Timeout - no key pressed', 0
    buffer: times 32 db 0

section .text
global _start

_start:
    call cell_init
    test rax, rax
    js .error
    
.main_loop:
    call clear_screen
    call hide_cursor
    
    mov rdi, 2
    mov rsi, 25
    call set_cursor
    call set_color_cyan
    mov rdi, msg1
    call print_string
    
    mov rdi, 5
    mov rsi, 10
    call set_cursor
    call reset_color
    mov rdi, msg2
    call print_string
    
    mov rdi, 7
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
    
    call reset_color
    call show_cursor
    
    mov rdi, 9
    mov rsi, 12
    call set_cursor
    mov rdi, .press_key_msg
    call print_string
    
    call wait_key
    
    cmp al, 'q'
    je .exit
    cmp al, 'Q'
    je .exit
    
    mov [buffer], al
    mov byte [buffer + 1], 0
    
    mov rdi, 9
    mov rsi, 35
    call set_cursor
    mov rdi, got_key
    call print_string
    mov rdi, buffer
    call print_string
    
    mov rdi, 11
    mov rsi, 12
    call set_cursor
    mov rdi, .waiting_msg
    call print_string
    
    mov rcx, 50  
.non_blocking_loop:
    call get_char_nb
    test rax, rax
    jnz .key_pressed
    
    push rcx
    mov rdi, 10000
    call delay
    pop rcx
    
    loop .non_blocking_loop
    
    mov rdi, 11
    mov rsi, 35
    call set_cursor
    mov rdi, timeout_msg
    call print_string
    jmp .continue
    
.key_pressed:
    mov [buffer], al
    mov rdi, 11
    mov rsi, 35
    call set_cursor
    mov rdi, got_key
    call print_string
    mov rdi, buffer
    call print_string
    
.continue:
    mov rdi, 23
    mov rsi, 10
    call set_cursor
    mov rdi, .continue_msg
    call print_string
    
    mov rdi, 500000  
    call delay
    
    jmp .main_loop
    
.exit:
    xor rdi, rdi
    call cell_exit
    
.error:
    mov rdi, 1
    call cell_exit

    .press_key_msg db 'Press any key: ', 0
    .waiting_msg db 'Waiting (non-blocking): ', 0
    .continue_msg db 'Continuing in 0.5 seconds...', 0

extern cell_init, cell_exit, clear_screen, set_cursor, print_string
extern set_color_cyan, set_color_yellow, reset_color
extern hide_cursor, show_cursor, wait_key, get_char_nb, delay
