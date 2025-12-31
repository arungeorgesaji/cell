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

KEY_A      equ 'a'
KEY_B      equ 'b'
KEY_C      equ 'c'
KEY_D      equ 'd'
KEY_E      equ 'e'
KEY_F      equ 'f'
KEY_G      equ 'g'
KEY_H      equ 'h'
KEY_I      equ 'i'
KEY_J      equ 'j'
KEY_K      equ 'k'
KEY_L      equ 'l'
KEY_M      equ 'm'
KEY_N      equ 'n'
KEY_O      equ 'o'
KEY_P      equ 'p'
KEY_Q      equ 'q'
KEY_R      equ 'r'
KEY_S      equ 's'
KEY_T      equ 't'
KEY_U      equ 'u'
KEY_V      equ 'v'
KEY_W      equ 'w'
KEY_X      equ 'x'
KEY_Y      equ 'y'
KEY_Z      equ 'z'

KEY_0      equ '0'
KEY_1      equ '1'
KEY_2      equ '2'
KEY_3      equ '3'
KEY_4      equ '4'
KEY_5      equ '5'
KEY_6      equ '6'
KEY_7      equ '7'
KEY_8      equ '8'
KEY_9      equ '9'

KEY_ENTER     equ 13
KEY_BACKSPACE equ 8
KEY_ESC       equ 27
KEY_SPACE     equ 32
KEY_TAB       equ 9
KEY_DEL       equ 127

KEY_UP        equ 1000
KEY_DOWN      equ 1001
KEY_RIGHT     equ 1002
KEY_LEFT      equ 1003
KEY_DELETE    equ 1004
KEY_HOME      equ 1005
KEY_END       equ 1006
KEY_PAGEUP    equ 1007
KEY_PAGEDOWN  equ 1008

KEY_F1     equ 2001
KEY_F2     equ 2002
KEY_F3     equ 2003
KEY_F4     equ 2004
KEY_F5     equ 2005
KEY_F6     equ 2006
KEY_F7     equ 2007
KEY_F8     equ 2008
KEY_F9     equ 2009
KEY_F10    equ 2010
KEY_F11    equ 2011
KEY_F12    equ 2012

MOD_NONE   equ 0
MOD_CTRL   equ 0x01
MOD_ALT    equ 0x02
MOD_SHIFT  equ 0x04

MOD_CTRL_SHIFT equ (MOD_CTRL | MOD_SHIFT)
MOD_CTRL_ALT   equ (MOD_CTRL | MOD_ALT)
MOD_ALT_SHIFT  equ (MOD_ALT | MOD_SHIFT)
