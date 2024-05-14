.section .text
.globl _start
_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

main:
    # Chamada para a função read
    call read

    # Definição da saída e entrada
    la a0, input_address
    la a1, result            

    # Conversão e cálculo da raiz
    call sqrt_calc




# Definição da função read
read:
    li a0, 0                    # file descriptor = 0 (stdin)
    la a1, input_address        # buffer
    li a2, 20                   # size - Reads 20 bytes.
    li a7, 63                   # syscall read (63)
    ecall
    ret

# Definição da função write
write:
    li a0, 1              # file descriptor = 1 (stdout)
    la a1, result         # buffer
    li a2, 20             # size - Writes 20 bytes.
    li a7, 64             # syscall write (64)
    ecall
    ret

# Cálculo da Raiz de cada Número
sqrt_calc:                # Loop de calculo
    li t0, 0              # Numero de nums lidos
loop:
    # Ler um número do buffer de entrada
    li t1, 4
    beq t0, t1, loopf        # Retorna se todos numeros foram lidos

    lbu t1, 0(a0)           # Ler o primeiro caractere do número
    li t3, 10               # Valor base 10 para cálculo
    addi t1, t1, -48        # Converter ASCII para decimal        
    addi a0, a0, 1          # Avançar para o próximo caractere

    lbu t4, 0(a0)
    addi t4, t4, -48        # Converter ASCII para decimal
    mul t1, t1, t3          # Multiplicar o valor atual por 10
    add t1, t1, t4          # Adicionar ao valor atual
    addi a0, a0, 1          # Avançar para o próximo caractere

    lbu t4, 0(a0)
    addi t4, t4, -48        # Converter ASCII para decimal
    mul t1, t1, t3          # Multiplicar o valor atual por 10
    add t1, t1, t4          # Adicionar ao valor atual
    addi a0, a0, 1          # Avançar para o próximo caractere

    lbu t4, 0(a0)
    addi t4, t4, -48        # Converter ASCII para decimal
    mul t1, t1, t3          # Multiplicar o valor atual por 10
    add t1, t1, t4          # Adicionar ao valor atual
    addi t0, t0, 1          # Dar o número como lido
    addi a0, a0, 2          # Avançar para o próximo caractere, pulando o espaço

    # Calcular a raiz quadrada de t1
    call sqrt_num
    call write_num          # Escreve t2 no vetor de saida
    j loop

loopf:
    ret


sqrt_num:
    li t5, 4                    # Contador da raiz
loop_sqrt:
    mul t2, t5, t5              # Calcula o quadrado de t5
    blt t1, t2, end_loop_sqrt   # Se o quadrado for maior, entao retona a raiz anterior
    addi t5, t5, 1              # Se nao for maior adiciona um
    j loop_sqrt                 # Continua o loop
end_loop_sqrt:
    addi t5, t5, -1             # Retorna a raiz anterior
    ret

write_num:              
    li t3, 1000             # Define o divisor

    div t1, t5, t3          # Calcula o numero a ser posto na posicao
    mul t2, t1, t3          # Define o valor a ser subtraido de t5
    sub t5, t5, t2          # Atualiza o valor de t5
    addi t1, t1, 48         # Retorna para ASCII
    sb t1, 0(a1)            # Escreve no Buffer de saída
    addi a1, a1, 1          # Avança para o Próximo caracter

    li t3, 100              # Define o divisor
    div t1, t5, t3          # Calcula o numero a ser posto na posicao
    mul t2, t1, t3          # Define o valor a ser subtraido de t5
    sub t5, t5, t2          # Atualiza o valor de t5
    addi t1, t1, 48         # Retorna para ASCII
    sb t1, 0(a1)            # Escreve no Buffer de saída
    addi a1, a1, 1          # Avança para o Próximo caracter

    li t3, 10               # Define o divisor
    div t1, t5, t3          # Calcula o numero a ser posto na posicao
    mul t2, t1, t3          # Define o valor a ser subtraido de t5
    sub t5, t5, t2          # Atualiza o valor de t5
    addi t1, t1, 48         # Retorna para ASCII
    sb t1, 0(a1)            # Escreve no Buffer de saída
    addi a1, a1, 1          # Avança para o Próximo caracter

    li t3, 1                # Define o divisor
    div t1, t5, t3          # Calcula o numero a ser posto na posicao
    mul t2, t1, t3          # Define o valor a ser subtraido de t5
    sub t5, t5, t2          # Atualiza o valor de t5
    addi t1, t1, 48         # Retorna para ASCII
    sb t1, 0(a1)            # Escreve no Buffer de saída
    addi a1, a1, 1          # Avança para o Próximo caracter

    li t3, 4
    beq t0, t3, end_write_num   # Se for o último escreve um \n
    li t5, 32                   
    sb t5, 0(a1)                # Escreve um espaço
    addi a1, a1, 1          # Avança para o Próximo caracter

    ret
end_write_num:
    li t5, 10
    sb t5, 0(a1)
    call write
    ret
        



.bss

input_address: .skip 0x20  # buffer

result: .skip 0x20