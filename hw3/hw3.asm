section .bss
buf resb 20

section .data
msg_prime db " - просте число", 10
msg_notprime db " - НЕ просте число", 10

section .text
global _start

_start:
    mov rax, 0
    mov rdi, 0
    lea rsi, [buf]
    mov rdx, 20
    syscall

    lea rsi, [buf]
    xor r8, r8

.convert_input:
    movzx rax, byte [rsi]
    cmp rax, 10
    je .done_input
    sub rax, '0'
    imul r8, r8, 10
    add r8, rax
    inc rsi
    jmp .convert_input
.done_input:

    mov rdi, r8
    push r8
    mov rax, r8
    call print_num
    pop r8

    cmp r8, 2
    jl not_prime
    je prime

    mov rcx, 2
check_loop:
    mov rdx, 0
    mov rax, r8
    div rcx
    cmp rdx, 0
    je not_prime
    inc rcx
    cmp rcx, r8
    jl check_loop

prime:
    mov rsi, msg_prime
    call print_msg
    jmp exit

not_prime:
    mov rsi, msg_notprime
    call print_msg

exit:
    mov rax, 60
    xor rdi, rdi
    syscall

print_num:
    mov rax, rdi
    mov rbx, 10
    lea rcx, [buf+19]
    mov byte [rcx], 0

.convert:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rcx
    mov [rcx], dl
    test rax, rax
    jnz .convert

    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, buf+19
    sub rdx, rcx
    syscall
    ret

print_msg:
    mov rax, 1
    mov rdi, 1
.loop:
    cmp byte [rsi+rdx], 0
    je .done
    inc rdx
    jmp .loop
.done:
    syscall
    ret
