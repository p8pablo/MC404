    .globl _start

_start:
    jal    main
    li     a0, 0
    li     a7, 93                 # exit
    ecall

    .text

main:
    jal    read
    jal    stringToNum            # Salva em t0 o valor de entrada
    la     s0, head_node
    jal    chooseNode             # Salva em t3 o índice desejado
    la     s0, result
    jal    saveAns

stringToNum:
    li     t0, 0                  # Armazena o número em módulo
    li     t1, 45                 # Simbolo negativo
    li     t2, 10                 # Fator multiplicativo
    lb     t3, (a1)
    beq    t3, t1, neg
    blt    t3, t1, pos

pos:
    li     t1, 1
    j      loopSTN

neg:
    li     t1, -1
    addi   a1, a1, 1
    j      loopSTN

loopSTN:
    lbu    t3, (a1)
    beq    t3, t2, endLoopSTN
    addi   t3, t3, -48
    mul    t0, t0, t2
    add    t0, t0, t3
    addi   a1, a1, 1
    j      loopSTN

endLoopSTN:
    mul    t0, t0, t1
    ret

chooseNode:
    li     t3, 0                  # Define o nó atual
loopChooseNode:
    lw     t1, (s0)               # Primeiro num do nó
    addi   s0, s0, 4
    lw     t2, (s0)               # Segundo num
    addi   s0, s0, 4
    lw     t4, (s0)               # Terceiro num

    li     s1, 0
    add    s1, s1, t1
    add    s1, s1, t2
    add    s1, s1, t4             # Soma armazenada em s1

    addi   s0, s0, 4

    beq    s1, t0, endChooseNode  # Conferir se a soma é equivalente ao número da entrada
    lw     s0, (s0)
    beqz   s0, noNode
    addi   t3, t3, 1
    j      loopChooseNode
noNode:
    li     t3, -1
    j      endChooseNode
endChooseNode:
    ret
saveAns:
    li     t2, -1
    beq    t3, t2, noNodeAns
    beqz   t3, zeroNode
    li     t4, 10
    li     t5, 100
    li     t6 , 1
loopSaveAns:
    div    t1, t3, t5
    rem    t3, t3, t5
    beqz   t1, jump
    add    t1, t1, 48
    sb     t1, (s0)
    addi   s0, s0, 1
    beq    t5, t6, endLoopSaveAns
    div    t5, t5, t4
    j      loopSaveAns
jump:
    div    t5, t5, t4
    addi   s0, s0, 1
    j      loopSaveAns

zeroNode:
    li     t1, 48
    sb     t1, (s0)
    addi   s0, s0, 1
    j      endLoopSaveAns
noNodeAns:
    li     t1, 45
    sb     t1, (s0)
    addi   s0, s0, 1
    li     t1, 49
    sb     t1, (s0)
    addi   s0, s0, 1
    j      endLoopSaveAns
endLoopSaveAns:
    li     t1, 10
    sb     t1, (s0)
    call   write



read:
    li     a0, 0
    la     a1, input_address      # buffer
    li     a2, 7
    li     a7, 63
    ecall
    ret

write:
    li     a0, 1                  # file descriptor = 1 (stdout)
    la     a1, result             # buffer
    li     a2, 8                  # size - Writes 20 bytes.
    li     a7, 64                 # syscall write (64)
    ecall
    ret


    .bss
input_address:
    .skip  8                      # buffer

result:
    .skip  8