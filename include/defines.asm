SYS_READ    equ 0
SYS_WRITE   equ 1
SYS_OPEN    equ 2
SYS_CLOSE   equ 3
SYS_IOCTL   equ 16
SYS_EXIT    equ 60

STDIN       equ 0
STDOUT      equ 1
STDERR      equ 2

TCGETS      equ 0x5401
TCSETS      equ 0x5402

ICANON equ 2
ECHO   equ 8

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

ERR_INIT_FAILED     equ -1
ERR_NOT_TTY         equ -2
ERR_IOCTL_FAILED    equ -3
ERR_MALLOC_FAILED   equ -4
ERR_INVALID_INPUT   equ -5
