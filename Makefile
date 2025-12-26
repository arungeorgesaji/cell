ASM = nasm
ASMFLAGS = -f elf64 -g -F dwarf -Iinclude/
LD = ld
AR = ar
ARFLAGS = rcs

TARGET = libcell.a    

SRC_DIR = src
BUILD_DIR = build
INCLUDE_DIR = include

SRCS = $(wildcard $(SRC_DIR)/*.asm)
OBJS = $(patsubst $(SRC_DIR)/%.asm, $(BUILD_DIR)/%.o, $(SRCS))

all: $(TARGET)

$(TARGET): $(OBJS)
	$(AR) $(ARFLAGS) $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

clean:
	rm -rf $(BUILD_DIR) $(TARGET)

.PHONY: all clean
