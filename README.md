# cell

A Terminal User Interface (TUI) library written in NASM x86-64 Assembly.

This project is in early development. Documentation is currently limited - explore the source code and examples to learn how it works.

## Project Structure
- `include/` - Header files for library usage
- `src/` - Library source code
- `examples/` - Example programs demonstrating library features

## Build && Run 

To build the library use the provided Makefile(The current Makefile is configured for Linux x86-64, P.S: Feel free to use the lib put in release if you want to skip building it yourself if you are on linux x86-64):

```bash
make
```

To run an example program which I have provided in examples/, use the script `run_examples.sh`:

```bash
./run_examples.sh example_name
```

If you want run your own example, figure out the library and use `run_examples.sh` as reference to create your own script to compile and link your program with the library. 

## Requirements
- NASM assembler
- Linux x86-64 (the makefile is configured for Linux)
