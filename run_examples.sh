#!/bin/bash

set -e  

if [ $# -ne 1 ]; then
    echo "Error: Please provide exactly one argument: the example name"
    echo "Usage: $0 <example_name>"
    echo "Available examples: $(ls examples/*.asm | xargs -n1 basename | sed 's/\.asm$//' | tr '\n' ' ')"
    exit 1
fi

EXAMPLE_NAME="$1"
SRC_FILE="examples/${EXAMPLE_NAME}.asm"
OBJ_FILE="build/${EXAMPLE_NAME}.o"
EXECUTABLE="example"  

if [ ! -f "$SRC_FILE" ]; then
    echo "Error: Example source not found: $SRC_FILE"
    echo "Make sure the file examples/${EXAMPLE_NAME}.asm exists"
    exit 1
fi

echo "Assembling $SRC_FILE ..."
nasm -f elf64 -Iinclude/ "$SRC_FILE" -o "$OBJ_FILE"

echo "Linking with libcell.a to produce $EXECUTABLE ..."
ld "$OBJ_FILE" -L. -lcell -o "$EXECUTABLE"

echo "Done! Run with: ./$EXECUTABLE"

echo "Running..."
./"$EXECUTABLE"
