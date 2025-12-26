%include "defines.asm"

section .text
global cell_init
global cell_exit

extern show_cursor
extern hide_cursor
extern reset_color
extern clear_screen

struc termios
    .c_iflag: resd 1  
    .c_oflag: resd 1    
    .c_cflag: resd 1    
    .c_lflag: resd 1    
    .c_line:  resb 1    
    .c_cc:    resb 19   
endstruc

section .bss
orig_termios: resb termios_size
termios_buffer: resb termios_size

section .data
init_error_msg: db "Failed to initialize terminal", 0xA, 0
init_error_len: equ $ - init_error_msg

section .text

cell_init:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    
    mov rax, SYS_IOCTL
    mov rdi, STDIN
    mov rsi, TCGETS
    mov rdx, orig_termios
    syscall
    
    test rax, rax
    js .init_error      
    
    mov rcx, termios_size
    mov rsi, orig_termios
    mov rdi, termios_buffer
    rep movsb
    
    and dword [termios_buffer + termios.c_lflag], ~(0000002h | 0000010h)
    
    mov byte [termios_buffer + termios.c_cc + 6], 1  
    mov byte [termios_buffer + termios.c_cc + 5], 0  
    
    mov rax, SYS_IOCTL
    mov rdi, STDIN
    mov rsi, TCSETS
    mov rdx, termios_buffer
    syscall
    
    test rax, rax
    js .init_error
    
    call hide_cursor
    call clear_screen
    
    xor rax, rax        
    jmp .done
    
.init_error:
    mov rax, SYS_WRITE
    mov rdi, STDERR
    mov rsi, init_error_msg
    mov rdx, init_error_len
    syscall
    
    mov rax, -1         
    
.done:
    pop r12
    pop rbx
    pop rbp
    ret

cell_exit:
    push rbp
    mov rbp, rsp
    push rdi            
    
    call show_cursor
    call reset_color
    
    mov rax, SYS_IOCTL
    mov rdi, STDIN
    mov rsi, TCSETS
    mov rdx, orig_termios
    syscall
    
    call clear_screen
    
    pop rdi
    mov rax, SYS_EXIT
    syscall

is_tty:
    push rbp
    mov rbp, rsp
    
    mov rax, SYS_IOCTL
    mov rdi, STDIN
    mov rsi, TCGETS
    mov rdx, orig_termios    
    syscall
    
    xor rax, rax
    test rax, rax
    setns al           
    
    pop rbp
    ret
