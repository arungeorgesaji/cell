%define SYS_READ   0
%define SYS_WRITE  1
%define SYS_OPEN   2
%define SYS_CLOSE  3
%define SYS_EXIT   60
%define SYS_IOCTL   16

%define STDIN  0
%define STDOUT 1
%define STDERR 2

%define TCGETS     0x5401
%define TCSETS     0x5402

%define ICANON  0000002h   
%define ECHO    0000010h

%define ESC     0x1b
%define CSI     '['
%define CLEAR   '2J'
%define HOME    'H'

COLOR_RESET:      db 0x1b, '[0m'
COLOR_BLACK:      db 0x1b, '[30m'
COLOR_RED:        db 0x1b, '[31m'
COLOR_GREEN:      db 0x1b, '[32m'
COLOR_YELLOW:     db 0x1b, '[33m'
COLOR_BLUE:       db 0x1b, '[34m'
COLOR_MAGENTA:    db 0x1b, '[35m'
COLOR_CYAN:       db 0x1b, '[36m'
COLOR_WHITE:      db 0x1b, '[37m'
COLOR_BRIGHT:     db 0x1b, '[1m'

BG_BLACK:         db 0x1b, '[40m'
BG_RED:           db 0x1b, '[41m'
BG_GREEN:         db 0x1b, '[42m'
BG_YELLOW:        db 0x1b, '[43m'
BG_BLUE:          db 0x1b, '[44m'
BG_MAGENTA:       db 0x1b, '[45m'
BG_CYAN:          db 0x1b, '[46m'
BG_WHITE:         db 0x1b, '[47m'

CURSOR_HIDE:      db 0x1b, '[?25l'
CURSOR_SHOW:      db 0x1b, '[?25h'

COLOR_RESET_LEN   equ 4
COLOR_BLACK_LEN   equ 5
COLOR_RED_LEN     equ 5
COLOR_GREEN_LEN   equ 5
COLOR_YELLOW_LEN  equ 5
COLOR_BLUE_LEN    equ 5
COLOR_MAGENTA_LEN equ 5
COLOR_CYAN_LEN    equ 5
COLOR_WHITE_LEN   equ 5
COLOR_BRIGHT_LEN  equ 4
CURSOR_HIDE_LEN   equ 6
CURSOR_SHOW_LEN   equ 6
