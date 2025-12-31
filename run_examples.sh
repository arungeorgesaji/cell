#!/bin/bash

set -e  

LINKER="ld"

while getopts "l:" opt; do
    case $opt in
        l)
            LINKER="$OPTARG"
            ;;
        *)
            echo "Usage: $0 [-l linker] <example_name>"
            echo "  -l linker: specify 'ld' or 'gcc' (default: gcc)"
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

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

if [ "$LINKER" = "ld" ]; then
    ld "$OBJ_FILE" -L. -lcell -o "$EXECUTABLE"
elif [ "$LINKER" = "gcc" ]; then
    gcc -no-pie "$OBJ_FILE" -L. -lcell -o "$EXECUTABLE"
else
    echo "Error: Invalid linker '$LINKER'. Use 'ld' or 'gcc'"
    exit 1
fi

echo "Done! Run with: ./$EXECUTABLE"

echo "Running..."
./"$EXECUTABLE"
