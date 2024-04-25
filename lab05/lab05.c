int read(int __fd, const void *__buf, int __n)
{
  int ret_val;
  __asm__ __volatile__(
      "mv a0, %1           # file descriptor\n"
      "mv a1, %2           # buffer \n"
      "mv a2, %3           # size \n"
      "li a7, 63           # syscall write code (63) \n"
      "ecall               # invoke syscall \n"
      "mv %0, a0           # move return value to ret_val\n"
      : "=r"(ret_val)                   // Output list
      : "r"(__fd), "r"(__buf), "r"(__n) // Input list
      : "a0", "a1", "a2", "a7");
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
      "mv a0, %0           # file descriptor\n"
      "mv a1, %1           # buffer \n"
      "mv a2, %2           # size \n"
      "li a7, 64           # syscall write (64) \n"
      "ecall"
      :                                 // Output list
      : "r"(__fd), "r"(__buf), "r"(__n) // Input list
      : "a0", "a1", "a2", "a7");
}

void exit(int code)
{
  __asm__ __volatile__(
      "mv a0, %0           # return code\n"
      "li a7, 93           # syscall exit (64) \n"
      "ecall"
      :           // Output list
      : "r"(code) // Input list
      : "a0", "a7");
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}
int abs(int num){
  if(num >= 0){
    return num;
  }
  else
  {
    return 0 - num;
  }
  
}
void print(int x)
{

  char s[33];
  s[32] = '\n';
  for (int i = 31; i >= 0; i--)
  {
    s[i] = (x&1) +'0';
    x = x>>1;
  }
  write(1, s, 33);
}

void intToHex(int soma, char *saida)
{
  int comparador_4bit = 15;
  int valor = 0;
  int i = 9;
  while (i > 1)
  {
    valor = soma&comparador_4bit;
    if (valor % 16 > 9)
    {
      saida[i] = (valor % 16) + 'A' - 10;
    }
    else
    {
      saida[i] = (valor % 16) + '0';
    }
    i--;
    soma = soma >> 4;
  }
}

int main()
{
  int val1 = 0, val2 = 0, val3 = 0, val4 = 0, val5 = 0;
  int soma = 0;
  int shift = 0;
  char entrada[30];
  char saida[11];
  saida[0] = '0';
  saida[1] = 'x';
  saida[10] = '\n';
  read(0, entrada, 30);
  char signal = ' ';
  for (int i = 0; i < 30; i++)
  {
    if (i < 5)
    {
      if (i == 0)
      {
        signal = entrada[i];
      }
      else
      {
        val1 = (val1 * 10) + (entrada[i] - '0');
      }
    }
    if (signal == '-' && i == 5)
    {
      val1 = 0 - val1;
    }
    if (i > 5 && i < 11)
    {
      if (i == 6)
      {
        signal = entrada[i];
      }
      else
      {
        val2 = (val2 * 10) + (entrada[i] - '0');
      }
    }
    if (signal == '-' && i == 11)
    {
      val2 = 0 - val2;
    }
    if (i > 11 && i < 17)
    {
      if (i == 12)
      {
        signal = entrada[i];
      }
      else
      {
        val3 = (val3 * 10) + (entrada[i] - '0');
      }
    }
    if (signal == '-' && i == 17)
    {
      val3 = 0 - val3;
    }
    if (i > 17 && i < 23)
    {
      if (i == 18)
      {
        signal = entrada[i];
      }
      else
      {
        val4 = (val4 * 10) + (entrada[i] - '0');
       
      }
    }
    if (signal == '-' && i == 23)
    {
      val4 = 0 - val4;
    }
    if (i > 23 && i < 29)
    {
      if (i == 24)
      {
        signal = entrada[i];
      }
      else
      {
        val5 = (val5 * 10) + (entrada[i] - '0');
      }
    }
    if (signal == '-' && i == 29)
    {
      val5 = 0 - val5;
    }
  }

  soma += val1 & 31;
  shift += 5;

  
  val2 = val2 & 127;
  val2 = val2 << shift;
  soma += val2;
  shift += 7;
  

  val3 = val3 & 511;
  val3 = val3 << shift;
  soma += val3;
  shift += 9;
  

  val4 = val4 & 15;
  val4 = val4 << shift;
  soma += val4;
  shift += 4; 
  

  val5 = val5 & 127;
  val5 = val5 << shift;
  soma += val5;
  

  intToHex(soma, saida);
  write(1, saida, 11);
}
