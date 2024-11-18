.data
argsErrorMsg: .string "Provide 1 argument to the program"
argsErrorMsgEnd: .set len, argsErrorMsgEnd-argsErrorMsg
    .text
    .global _start
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
    cmpb $2, (%rsp)
    JNE error_on_args

    mov 16(%rsp), %rbx
    mov $0, %rcx
count_length:
    add $1, %rbx
    add $1, %rcx
    cmpb $0, (%rbx)
    JNE count_length

#for testing 
    mov $1, %rax
    mov $1, %rdi
    mov 16(%rsp), %rsi
    mov %rcx, %rdx
    syscall

    mov $60, %rax
    mov $0, %rdi
    syscall

