.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall
main:

    jal open
    jal read
    mv s0, a1
    jal readHeader #a0 = colunas, a1 = linhas
    jal setCanvas
    jal printMatrix

readHeader:
    li a0, 0
    li a1, 0
    addi s0, s0, 3
    li t0, 3
    li t1, 0            # Contador de espaços/quebras de linhas
    li t2, 10           # Salva \n
    li t3, 32           # Salva espaço
    li t4, 0            # Flag para identificar se estamos salvando linha ou coluna
loop_rH:
    beq t0, t1, endLoop
    lbu s1, 0(s0)
    # Verificar se s1 é espaço ou \n
    beq s1, t2, nlJump
    beq s1, t3, spcJump
    # Se n for é um inteiro
    addi s1, s1, -48
    # Verificar qual numero para ser salvo
    beqz t4, saveRow
    li t5, 1
    beq t5, t4, saveLine
    addi s0, s0, 1
    j loop_rH

endLoop:
    ret

nlJump:
    addi t1, t1, 1
    addi t4, t4, 1
    addi s0, s0, 1
    j loop_rH

spcJump:
    addi t1, t1, 1
    addi t4, t4, 1
    addi s0, s0, 1
    j loop_rH

saveRow:
    mul a0, a0, t2
    add a0, a0, s1
    addi s0, s0, 1
    j loop_rH

saveLine:
    mul a1, a1, t2
    add a1, a1, s1
    addi s0, s0, 1
    j loop_rH



setCanvas:
    li a7, 2201
    ecall
    ret

printMatrix:
    mul t0, a0, a1      # Tamanho da matriz
    li t1, 0            # Count
    li t2, 255          # Alpha
    mv s1, a0           # Salvar colunas
    mv s2, a1           # Salvar linhas

loop_pM:
    bge t1, t0, endLoop
    rem a0, t1, s1      # Save X
    div a1, t1, s1      # Save Y
    lbu t3, 0(s0)       # Primeiro caracter da matriz
    li a2, 0X00000000   # Vetor de 0

    # Separando Cores
    slli s3, t3, 24
    slli s4, t3, 16
    slli s5, t3, 8

    # Setando Cores
    add a2, a2, t2
    add a2, a2, s3
    add a2, a2, s4
    add a2, a2, s5

    call setPixel
    addi t1, t1, 1
    addi s0, s0, 1
    j loop_pM


setPixel:
    li a7, 2200 # syscall setPixel (2200)
    ecall
    ret

open:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall
    ret

read:
    la a1, input_address # buffer
    li a2, 262159
    li a7, 63           # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, a2_buffer       # buffer
    li a2, 5           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

.bss

input_address: .skip 0x4000F # buffer for the whole file
a2_buffer: .skip 4

.data
input_file: .asciz "image.pgm"