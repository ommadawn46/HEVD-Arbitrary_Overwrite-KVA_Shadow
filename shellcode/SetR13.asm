BITS 64
global SetR13
section .text

SetR13:
    mov r13, rcx    ; Set the 1st argument to r13
    ret
