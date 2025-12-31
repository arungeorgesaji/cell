extern cell_init, cell_exit, clear_screen, set_cursor, print_string, print_char
extern set_color_cyan, set_color_yellow, reset_color
extern hide_cursor, show_cursor, wait_key
extern str_len, str_copy, str_cat, str_cmp, str_find, format_int, format_hex, int_to_str

section .data
    title db 'String Functions Test', 0
    prompt db 'Press any key to exit', 0
    newline db 13, 10, 0  
    buffer: times 128 db 0

section .text
global _start

_start:
    call cell_init
    test rax, rax
    js .error
    
    call clear_screen
    call hide_cursor
    
    mov rdi, 1
    mov rsi, 25
    call set_cursor
    call set_color_cyan
    mov rdi, title
    call print_string
    call reset_color
    
    mov rdi, 3
    mov rsi, 10
    call set_cursor
    mov rdi, .len_test
    call print_string
    
    mov rdi, .test_str
    call str_len
    
    mov rdi, buffer
    call int_to_str
    
    mov rdi, buffer
    call print_string
    
    mov rdi, 5
    mov rsi, 10
    call set_cursor
    mov rdi, .copy_test
    call print_string
    
    mov rdi, buffer
    mov rsi, .test_str
    call str_copy
    
    mov rdi, buffer
    call print_string
    
    mov rdi, 7
    mov rsi, 10
    call set_cursor
    mov rdi, .cat_test
    call print_string
    
    mov rdi, buffer
    mov rcx, 128
    xor al, al
    rep stosb
    
    mov rdi, buffer
    mov rsi, .test_str
    call str_copy
    
    mov rdi, buffer
    mov rsi, .append_str
    call str_cat
    
    mov rdi, buffer
    call print_string
    
    mov rdi, 9
    mov rsi, 10
    call set_cursor
    mov rdi, .cmp_test
    call print_string
    
    mov rdi, .str1
    mov rsi, .str2
    call str_cmp
    
    cmp rax, 0
    jz .equal
    jl .less
    jmp .greater
    
.equal:
    mov rdi, .equal_msg
    jmp .print_cmp
    
.less:
    mov rdi, .less_msg
    jmp .print_cmp
    
.greater:
    mov rdi, .greater_msg
    
.print_cmp:
    call print_string
    
    mov rdi, 11
    mov rsi, 10
    call set_cursor
    mov rdi, .int_test
    call print_string
    
    mov rdi, buffer
    mov rcx, 128
    xor al, al
    rep stosb
    
    mov rax, -123456789
    mov rdi, buffer
    call format_int
    
    mov rdi, buffer
    call print_string
    
    mov rdi, 13
    mov rsi, 10
    call set_cursor
    mov rdi, .hex_test
    call print_string
    
    mov rdi, buffer
    mov rcx, 128
    xor al, al
    rep stosb
    
    mov rsi, 0xCAFEBABE
    mov rdi, buffer
    call format_hex
    
    mov rdi, buffer
    call print_string
    
    mov rdi, 15
    mov rsi, 10
    call set_cursor
    mov rdi, .find_test
    call print_string
    
    mov rdi, .test_str
    mov rsi, .find_char
    call str_find
    
    test rax, rax
    jz .not_found

    push rax
    
    mov rdi, .found_msg
    call print_string

    pop rax
    
    mov dil, [rax]
    call print_char
    
    mov rdi, newline
    call print_string
    
    jmp .after_find
    
.not_found:
    mov rdi, .not_found_msg
    call print_string
    
    mov rdi, newline
    call print_string
    
.after_find:
    mov rdi, buffer
    mov rcx, 128
    xor al, al
    rep stosb
    
    mov rdi, 17  
    mov rsi, 10
    call set_cursor
    
    call set_color_yellow
    mov rdi, prompt
    call print_string
    call reset_color
    
    call show_cursor
    
    call wait_key
    
    xor rdi, rdi
    call cell_exit
    
.error:
    mov rdi, 1
    call cell_exit

section .data
    .test_str db 'Hello World!', 0
    .append_str db ' - Appended', 0
    .str1 db 'apple', 0
    .str2 db 'banana', 0
    
    .len_test db 'Length of "Hello World!": ', 0
    .copy_test db 'Copy: ', 0
    .cat_test db 'Concatenate: ', 0
    .cmp_test db 'Compare "apple" to "banana": ', 0
    .int_test db 'Format -123456789: ', 0
    .hex_test db 'Format 0xCAFEBABE: ', 0
    .find_test db 'Find "W" in "Hello World!": ', 0
    .find_char db 'W', 0
    
    .equal_msg db 'equal', 0
    .less_msg db 'less', 0
    .greater_msg db 'greater', 0
    .found_msg db 'found: ', 0
    .not_found_msg db 'not found', 0
