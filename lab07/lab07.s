.section .text
.globl _start
_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

main:
    # Chamada para a função read
    call read_xy
    call read_time

    # Definição da saída e entrada
    la a0, input_xy
    la a1, input_time
    la a2, result

    jal convert_xy              # Salva x em a3, y em a4
    jal convert_time            # Salva da em s1, db em s2 e dc em s3
    jal calculate_coordinates            





# Definição da função read_xy
read_xy:
    li a0, 0                    # file descriptor = 0 (stdin)
    la a1, input_xy             # buffer
    li a2, 12                   # size - Reads 20 bytes.
    li a7, 63                   # syscall read (63)
    ecall
    ret

read_time:
    li a0, 0                    # file descriptor = 0 (stdin)
    la a1, input_time           # buffer
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

convert_xy:
    li t5, 2        # Contador de nums lidos
loop_xy:
    beqz t5, loop_xy_f
    li t4, 10
    lbu t0, 0(a0)           # Le o sinal da coordenada
    addi a0, a0, 1          # Proximo caracter

    lbu t1, 0(a0)           # Le o primeiro algarismo da coordenada
    addi t1, t1, -48        # Converte ascii para int
    addi a0, a0, 1          # Proximo caracter

    lbu t2, 0(a0)           # Le o caracter atual
    addi t2, t2, -48        # Converte ascii para int
    mul t1, t1, t4          # Realiza a multiplicacao para manter o valor como esperado
    add t1, t1, t2          # Soma os valores
    addi a0, a0, 1          # Proximo caracter

    lbu t2, 0(a0)           # Le o caracter atual
    addi t2, t2, -48        # Converte ascii para int
    mul t1, t1, t4          # Realiza a multiplicacao para manter o valor como esperado
    add t1, t1, t2          # Soma os valores
    addi a0, a0, 1          # Proximo caracter

    lbu t2, 0(a0)           # Le o caracter atual
    addi t2, t2, -48        # Converte ascii para int
    mul t1, t1, t4          # Realiza a multiplicacao para manter o valor como esperado
    add t1, t1, t2          # Soma os valores
    addi a0, a0, 2          # Proximo caracter

    li t2, 0                # Flag para verificar qual numero estamos salvando
    addi t5, t5, -1 
    blt t2, t5, save_x      # Se o valor for 2 estamos salvando x
    beq t2, t5, save_y      # Se o valor for 1 estamos salvando y
    j loop_xy

loop_xy_f:
    ret

save_x:
    li a3, 0                # Salvaremos a nossa coordenada X em a3
    add a3, a3, t1      
    li t1, 45               # Valor do simbolo negativo
    beq t0, t1, negative_x
    j loop_xy

negative_x:
    li t1, 0
    sub a3, t1, a3
    j loop_xy

save_y:
    li a4, 0                # Salvaremos a nossa coordenada Y em a4
    add a4, a4, t1      
    li t1, 45               # Valor do simbolo negativo
    beq t0, t1, negative_y
    j loop_xy

negative_y:
    li t1, 0
    sub a4, t1, a4
    j loop_xy



convert_time:
    li t0, 4
loop_time:
    beqz t0, loop_time_f
    li t3, 10 
    lbu t1, 0(a1)           # Carrega o primeiro número da coordenada
    addi t1, t1, -48        # Converte ascii para int
    addi a1, a1, 1

    lbu t2, 0(a1)           # Carrega o segundo número
    addi t2, t2, -48
    mul t1, t1, t3
    add t1, t1, t2
    addi a1, a1, 1

    lbu t2, 0(a1)           # Carrega o terceiro número
    addi t2, t2, -48
    mul t1, t1, t3
    add t1, t1, t2
    addi a1, a1, 1

    lbu t2, 0(a1)           # Carrega o quarto número
    addi t2, t2, -48
    mul t1, t1, t3
    add t1, t1, t2
    addi a1, a1, 2

    li t2, 3                # Definição de qual variavel estamos salvando
    li t3, 2
    li t4, 1
    li t5, 0
    addi t0, t0, -1
    beq t0, t2, save_tr
    beq t0, t3, save_ta
    beq t0, t4, save_tb
    beq t0, t5, save_tc

    
    j loop_time
loop_time_f:
    ret
save_tr:
    li s0, 0
    add s0, s0, t1
    
    j loop_time
save_ta:
    li s1, 0                # Transforma ta em da
    li t2, 3
    li t3, 10
    add s1, s1, t1
    sub s1, s0, s1
    mul s1, s1, t2
    div s1, s1, t3
    j loop_time
save_tb:
    li s2, 0                # Transforma tb em db
    li t2, 3
    li t3, 10
    add s2, s2, t1
    sub s2, s0, s2
    mul s2, s2, t2
    div s2, s2, t3
    j loop_time
save_tc:
    li s3, 0                # Transforma tc em dc
    li t2, 3
    li t3, 10
    add s3, s3, t1
    sub s3, s0, s3
    mul s3, s3, t2
    div s3, s3, t3
    j loop_time
calculate_coordinates:
    # Calcular X de saída e escrever 
    li t4, 2
    mul t0, s1, s1          # t0 = da^2
    mul t1, s3, s3          # t1 = dc^2
    mul t2, a3, a3          # t2 = xc^2
    mul t3, a3, t4          # t3 = 2xc
    sub t5, t0, t1          # t5 = t0-t1
    add t5, t5, t2          # t5 = t0-t1+t2
    div t5, t5, t3          # t5 = (t0-t1+t2)/t3
    mv a3, t5
    # Calcular Y de saída e escrever 
    mul t0, s1, s1          # t0 = da^2
    mul t1, s2, s2          # t1 = db^2
    mul t2, a4, a4          # t2 = yb^2
    mul t3, a4, t4          # t3 = 2yb
    sub t5, t0, t1          # t5 = t0-t1
    add t5, t5, t2          # t5 = t0-t1+t2
    div t5, t5, t3          # t5 = (t0-t1+t2)/t3
    mv a4, t5
    
    
    call write_num
    ret
    
write_num:              

    # Realizar verificação de positividade
    lbu t0, 0(a2)
    blt a3, zero, write_negative_x
    bge a3, zero, write_positive_x

write_num_contx:
    li t2, 32               # Caracter espaço
    li t4, 10               # Caracter \n

    # Escreve X guardado em a3 no vetor de saída
    li t3, 1000             # Define o divisor
    div t1, a3, t3          # Valor da posição
    addi t1, t1, 48         # int para ascii
    sb t1, 0(a2)            # Escreve o Byte
    rem a3, a3, t3          # Atualiza o valor de X para o restante
    addi a2, a2, 1          # Proximo caracter

    li t3, 100              # Define o divisor
    div t1, a3, t3          # Valor da posição
    addi t1, t1, 48         # int para ascii
    sb t1, 0(a2)            # Escreve o Byte
    rem a3, a3, t3          # Atualiza o valor de X para o restante
    addi a2, a2, 1          # Proximo caracter

    li t3, 10               # Define o divisor
    div t1, a3, t3          # Valor da posição
    addi t1, t1, 48         # int para ascii
    sb t1, 0(a2)            # Escreve o Byte
    rem a3, a3, t3          # Atualiza o valor de X para o restante
    addi a2, a2, 1          # Proximo caracter

    li t3, 1                # Define o divisor
    div t1, a3, t3          # Valor da posição
    addi t1, t1, 48         # int para ascii
    sb t1, 0(a2)            # Escreve o Byte
    rem a3, a3, t3          # Atualiza o valor de X para o restante
    addi a2, a2, 1          # Proximo caracter

    sb t2, 0(a2)            # Escreve espaço
    addi a2, a2, 1

    # Realizar verificação de positividade
    blt a4, zero, write_negative_y
    bge a4, zero, write_positive_y
write_num_conty:
    # Escreve Y guardado em a4 no vetor de saída
    li t3, 1000             # Define o divisor
    div t1, a4, t3          # Valor da posição
    addi t1, t1, 48         # int para ascii
    sb t1, 0(a2)            # Escreve o Byte
    rem a4, a4, t3          # Atualiza o valor de Y para o restante
    addi a2, a2, 1          # Proximo caracter

    li t3, 100              # Define o divisor
    div t1, a4, t3          # Valor da posição
    addi t1, t1, 48         # int para ascii
    sb t1, 0(a2)            # Escreve o Byte
    rem a4, a4, t3          # Atualiza o valor de Y para o restante
    addi a2, a2, 1          # Proximo caracter

    li t3, 10               # Define o divisor
    div t1, a4, t3          # Valor da posição
    addi t1, t1, 48         # int para ascii
    sb t1, 0(a2)            # Escreve o Byte
    rem a4, a4, t3          # Atualiza o valor de Y para o restante
    addi a2, a2, 1          # Proximo caracter

    li t3, 1                # Define o divisor
    div t1, a4, t3          # Valor da posição
    addi t1, t1, 48         # int para ascii
    sb t1, 0(a2)            # Escreve o Byte
    rem a4, a4, t3          # Atualiza o valor de Y para o restante
    addi a2, a2, 1          # Proximo caracter

    sb t4, 0(a2)            # Escreve \n
    call write
    ret

    
write_negative_x:
    li t1, 45               # Simbolo negativo
    sb t1, 0(a2)            # Escreve na saída
    addi a2, a2, 1
    sub a3, zero, a3        # Pega o módulo do número
    j write_num_contx

write_positive_x:
    li t1, 43               # Simbolo positivo
    sb t1, 0(a2)            # Escreve na saída
    addi a2, a2, 1
    j write_num_contx

write_negative_y:
    li t1, 45               # Simbolo negativo
    sb t1, 0(a2)            # Escreve na saída
    addi a2, a2, 1
    sub a4, zero, a4        # Pega o módulo do número
    j write_num_conty

write_positive_y:
    li t1, 43               # Simbolo positivo
    sb t1, 0(a2)            # Escreve na saída
    addi a2, a2, 1
    j write_num_conty



.bss

input_xy: .skip 0x20  
input_time: .skip 0x20 
result: .skip 0x20