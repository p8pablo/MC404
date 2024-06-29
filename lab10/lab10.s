

    .globl puts
    .globl gets
    .globl atoi
    .globl itoa
    .globl exit
    .globl recursive_tree_search




puts:
    mv     a1, a0
    li     a2, 1
loop_puts:
    lbu    t0, (a1)
    beqz   t0, endLoop_puts

    addi   a2, a2, 1
    addi   a1, a1, 1
    j      loop_puts
endLoop_puts:
    li     t0, 10
    sb     t0, (a1)
    mv     a1, a0
    li     a0, 1                       # file descriptor = 1 (stdout)
    li     a7, 64                      # syscall write (64)
    ecall
    sb     zero, (a1)
    ret
gets:
    mv     t0, a0
    mv     a1, a0
    li     a0, 0                       # file descriptor = 0 (stdin)
    li     a2, 1000000                 # size - Reads 20 bytes.
    li     a7, 63                      # syscall read (63)
    ecall
    mv     a0, t0                      # Restaura o a0
    ret

atoi:
    mv     t0, a0
    lb     t1, (t0)
    li     t2, 45
    li     t3, 1
    beq    t1, t2, negative
    j      atoiConvert

negative:
    addi   t0, t0, 1
    li     t3, -1                      # Guarda o sinal

atoiConvert:
    li     a0, 0
    li     t2, 10
loop_atoi:
    lb     t1, (t0)
    beq    t1, t2, endLoop_atoi
    beqz   t1, endLoop_atoi

    mul    a0, a0, t2
    addi   t4, t1, -48
    add    a0, a0, t4
    addi   t0, t0, 1
    j      loop_atoi
endLoop_atoi:
    mul    a0, a0, t3
    ret

itoa:
    mv     t0, a1
    li     t1, 0
    bge    zero, a0, negativeItoa
    j      itoaConvert

negativeItoa:
    li     t3, 45
    sb     t3, (t0)
    li     t3, -1
    li     t1, 1
    mul    a0, a0, t3

itoaConvert:
    mv     t2, a0
    li     t4, -1

loop_itoaCount:
    addi   t4, t4, 1
    div    t2, t2, a2
    beqz   t4, itoaConvertContinue
    j      loop_itoaCount

itoaConvertContinue:
    add    t4, t4, t1
    add    t5, a1, t2
    add    t5, t5, 1
    sb     zero, (t5)
    addi   t5, t5, -1

loop_itoaConvert:
    rem    t6, a0, a2
    addi   t6, t6, 48
    sb     t6, (t0)
    div    a0, a0, a2
    bge    t1, t2, endLoop_itoaConvert
    addi   t0, t0, -1
    addi   t2, t2, -1
    j      loop_itoaConvert
endLoop_itoaConvert:
    mv     a0, a1
    ret
exit:
    li     a0, 0
    li     a7, 93
    ecall


recursive_tree_search:
    mv     a4, sp
    li     a2, 0
    sw     ra, (sp)
    addi   sp, sp, -4
    sw     a0, (sp)
    la     ra, endRecursive

loop_recursive:
    addi   a2, a2, 1
    addi   sp, sp, -4
    sw     ra, (sp)
    lw     a0, 4(sp)

    lw     t1, 0(a0)
    beq    t1, a1, endRecursive

    lw     t2, 4(a0)
    beq    t2, zero, continueRec1
    addi   sp, sp, -4
    sw     t2, (sp)
    jal    loop_recursive

continueRec1:
    lw     a0, 4(sp)
    lw     t3, 8(a0)

    beq    t3, zero, continueRec2

    addi   sp, sp, -4
    sw     t3, (sp)
    jal    loop_recursive

continueRec2:
    lw     ra, (sp)
    addi   sp, sp, 8
    addi   a2, a2, -1

    ret

endRecursive:

    mv     sp, a4
    lw     ra, (sp)
    mv     a0, a2

    ret


