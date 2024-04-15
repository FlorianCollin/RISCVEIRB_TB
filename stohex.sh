#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <file_name.s>"
    exit 1
fi

input_file="$1"
base_name="${input_file%.s}"

# Compiler le fichier .s en un fichier ELF
riscv32-unknown-elf-gcc -nostartfiles -Ttext 0 "$input_file" -o "${base_name}.elf"

# Dump du contenu du fichier ELF
/opt/riscv/bin/riscv32-unknown-elf-objdump -d "${base_name}.elf" > "${base_name}.dump"

# Convertir le fichier ELF en fichier binaire
riscv32-unknown-elf-objcopy -O binary "${base_name}.elf" "${base_name}.bin"

# Afficher le contenu binaire avec od
od -t x4 "${base_name}.bin"

# Afficher le contenu binaire avec hexdump et sauvegarder dans un fichier hex
hexdump -v -e '"0x" /4 "%08x" ",\n"' "${base_name}.bin" > "${base_name}.hex"

# Afficher le contenu du fichier hex
cat "${base_name}.hex"

