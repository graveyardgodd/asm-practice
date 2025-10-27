%define W 28
%define H 14

section .bss
    line resb W

section .data
    nl db 10

section .text
global _start

_start:
    xor rdi, rdi

row_loop:
    mov rbx, line
    xor rsi, rsi

    cmp rdi, 0
    je full_row
    cmp rdi, H-1
    je full_row
    jmp middle_row

full_row:
    mov rcx, W
fill_full:
    mov byte [rbx+rsi], '*'
    inc rsi
    dec rcx
    jnz fill_full
    jmp write_line

middle_row:
    mov r8, rdi
    shl r8, 1
    mov r9, W-1
    sub r9, r8

x_loop:
    cmp rsi, W
    jge write_line

    cmp rsi, 0
    je put_star
    cmp rsi, W-1
    je put_star
    cmp rsi, r8
    je put_star
    cmp rsi, r9
    je put_star

    mov byte [rbx+rsi], ' '
    jmp advance

put_star:
    mov byte [rbx+rsi], '*'

advance:
    inc rsi
    jmp x_loop

write_line:
    mov rax, 1
    mov rdi, 1
    mov rsi, line
    mov rdx, W
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    inc rdi
    cmp rdi, H
    jl row_loop

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
