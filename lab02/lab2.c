/* Functions 
*/
int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n){
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code){
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

/* Calculadora */

char buffer[6];

int main(){
    int tamanho = read(0 ,(void*)buffer, 6);
    char s1 = buffer[0];
    char op = buffer[2];
    char s2 = buffer[4];
    int resultado = 0;
    
    /* Operações */
    if (op == '+')
    {
        int n1 = s1-'0';
        int n2 = s2-'0';
        resultado = n1+n2;
        buffer[0] = ' ';
        buffer[1] = ' ';
        buffer[2] = resultado+'0';
        buffer[3] = ' ';
        buffer[4] = ' ';
        write(1, (void*)buffer, tamanho);
    }
    else if (op == '-')
    {
        int n1 = s1-'0';
        int n2 = s2-'0';
        resultado = n1-n2;
        buffer[0] = ' ';
        buffer[1] = ' ';
        buffer[2] = resultado+'0';
        buffer[3] = ' ';
        buffer[4] = ' ';
        write(1, (void*)buffer, tamanho);
    }
    else if (op == '*')
    {
        int n1 = s1-'0';
        int n2 = s2-'0';
        resultado = n1*n2;
        buffer[0] = ' ';
        buffer[1] = ' ';
        buffer[2] = resultado+'0';
        buffer[3] = ' ';
        buffer[4] = ' ';
        write(1, (void*)buffer, tamanho);
    }

    return 0;
    
    //TODO
    /*Ainda falta acertar como a sa[ida vai funcionar (estou fazendo operações com char e no final o print ta saindo
    errado!) creio que só tem esse erro de implementação*/
}