.data
argsErrorMsg: .string "Provide 1 argument to the program\n\0"
argsErrorMsgEnd: .set len, argsErrorMsgEnd-argsErrorMsg
float1: .single 0.3
float2: .single 0.1
controlWord: .word 0
base: .word 10
finalResult: .quad 0

.text
    .global _start
program_end:
    mov $60, %rax
    syscall
error_on_args:
    mov $1, %rax
    mov $1, %rdi
    mov $argsErrorMsg, %rsi
    mov $len, %rdx
    syscall 

    mov $60, %rax
    mov $1, %rdi
    syscall



_start:
    finit
    fstcw controlWord
    andw $0xfffa, controlWord
    fldcw controlWord

    flds float2
    flds float1
    fdivp %st(0), %st(1)
    fwait

    mov $0, %rcx #exponent of 10
    mov $0x0020, %bx

first_loop_start:
    fclex

    fld %st(0)
    frndint
    fnstsw %ax
    andw $0x0020, %ax
    jz first_loop_end
    fstp %st(0)

    fimuls base
    dec %rcx
    cmp $-10, %rcx
    jg first_loop_start

first_loop_end:
    xor %rsi, %rsi #strlen

    fistpq finalResult
    dec %rsp
    movb $'\n', (%rsp)
    inc %rsi

    cmp $0, %rcx
    jl second_loop_start
    
    dec %rsp
    movb $'0', (%rsp)
    inc %rsi

    xor %rdx, %rdx

second_loop_start:
    cmp $0, %rcx
    jge second_loop_end

    inc %rcx

    mov $10, %rdi
    mov finalResult, %rax
    xor %rdx, %rdx
    idiv %rdi
    mov %rax, finalResult

    cmp $0, %rdx
    jge is_positive
    neg %rdx

is_positive:
    dec %rsp
    movb %dl, (%rsp)
    addb $'0', (%rsp)
    inc %rsi

    jmp second_loop_start
second_loop_end:

    dec %rsp
    movb $'.', (%rsp)
    inc %rsi

third_loop_start:
    mov $10, %rdi
    mov finalResult, %rax
    xor %rdx, %rdx
    idiv %rdi

    mov %rax, finalResult
    cmp $0, %rdx
    jge is_positive_2
    neg %rdx

is_positive_2:
    dec %rsp
    mov %dl, (%rsp)
    addb $'0', (%rsp)

    inc %rsi

    cmp $0, %rax
    jnz third_loop_start

third_loop_end:

    mov $1, %rax
    mov $1, %rdi
    mov %rsi, %rdx
    mov %rsp, %rsi
    syscall





    jmp program_end
