%define SYS_READ   0
%define SYS_WRITE  1
%define SYS_OPEN   2
%define SYS_CLOSE  3
%define SYS_EXIT   60

%define STDIN  0
%define STDOUT 1
%define STDERR 2

%define TCGETS     0x5401
%define TCSETS     0x5402

%define COLOR_RESET    "\\x1b[0m"
%define COLOR_BLACK    "\\x1b[30m"
%define COLOR_RED      "\\x1b[31m"
%define COLOR_GREEN    "\\x1b[32m"
%define COLOR_YELLOW   "\\x1b[33m"
%define COLOR_BLUE     "\\x1b[34m"
%define COLOR_MAGENTA  "\\x1b[35m"
%define COLOR_CYAN     "\\x1b[36m"
%define COLOR_WHITE    "\\x1b[37m"
