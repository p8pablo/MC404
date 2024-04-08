#include <stdio.h>
#include <string.h>
long exponential(int base, int exp)
{
  if (exp == 0)
  {
    return 1;
  }
  else if (exp % 2)
  {
    return base * exponential(base, exp - 1);
  }
  else
  {
    int temp = exponential(base, exp / 2);
    return temp * temp;
  }
}

int intToString(long num, char *string, int inicio) // TODO
{
  int i = inicio;
  while (num > 0)
  {
    string[i] = (num % 10) + '0';
    num = num / 10;
    i++;
  }

  string[i] = '\0';

  int ini = inicio, fim = i - 1;
  while (ini < fim)
  {

    char temp = string[ini];
    string[ini] = string[fim];
    string[fim] = temp;

    ini++;
    fim--;
  }
  return i;
}

long hexToDec(char *hex, char *dec, int size)
{
  int k = size;
  long num = 0;
  for (int i = 2; hex[i] != '\0'; i++)
  {
    if (hex[i] > '0' && hex[i] <= '9')
    {
      num += ((hex[i] - '0') * (exponential(16, k)));
    }
    else if (hex[i] >= 'a' && hex[i] <= 'f')
    {
      num += ((hex[i] - 'a' + 10) * (exponential(16, k)));
    }
    else if (hex[i] >= 'A' && hex[i] <= 'F')
    {
      num += ((hex[i] - 'A' + 10) * (exponential(16, k)));
    }
    k--;
  }

  return num;
}

int decConverter(long num, int base, char *base_string)
{
  int i = 2;
  while (num > 0)
  {
    if (num % base > 9)
    {
      base_string[i] = (num % base) + 'a' - 10;
    }
    else
    {
      base_string[i] = (num % base) + '0';
    }
    
    num = num / base;
    i++;
  }
  base_string[i] = '\0';
  int start = 2;
  int end = i - 1;
  while (start < end)
  {

    char temp = base_string[start];
    base_string[start] = base_string[end];
    base_string[end] = temp;

    start++;
    end--;
  }

  return i - 1;
}
void reverseEndianess(char *bin, char *bin_endianess, int size)
{
  char temp[33];
  for (int i = 0; i < 32; i++)
  {
    temp[i] = '0';
  }
  temp[32] = '\0';
  int k = size;

  for (int i = 31; i >= 0; i--)
  {
    temp[i] = bin[k];
    k--;
  }

  // reverse
  int j = 24;
  for (int i = 0; i < 32; i++)
  {
    if (i == 8)
    {
      j = 16;
    }
    else if (i == 16)
    {
      j = 8;
    }
    else if (i == 24)
    {
      j = 0;
    }
    if (temp[i] == '1')
    {
      bin_endianess[j] = temp[i];
    }
    j++;
  }
  
}

long binToDec(char *bin, char *dec)
{
  long num = 0;
  int exp = 31;
  for (int i = 0; bin[i] != '\0'; i++)
  {
    if (bin[i] == '1')
    {
      num += exponential(2, exp - i);
    }
  }
  intToString(num, dec, 0);
  return num;
}
long bin2complement(char *bin, char *bin_2comp, int size)
{
  int k = size;
  for (int i = 31; i >= 0; i--)
  {
    if (bin[k] == '1')
    {
      bin_2comp[i] = bin[k];
    }
    k--;
  }
  for (int i = 0; i < 32; i++)
  {
    if (bin_2comp[i] == '1')
    {
      bin_2comp[i] = '0';
    }
    else if (bin_2comp[i] == '0')
    {
      bin_2comp[i] = '1';
    }
  }
  char dec[20];
  long decimal = binToDec(bin_2comp, dec);
  decimal += 1;
  int count = 0;
  for (int i = 2; i < 34; i++)
  {
    bin[i] = bin_2comp[count];
    count ++;
  }
  bin[34] = '\0';
  decConverter(decimal, 2, bin);
  return decimal;
  
}

#define STDIN_FD 0
#define STDOUT_FD 1

int main()
{
  char str[20] = "0x80000000";
  //int n = read(STDIN_FD, str, 20);
  char bin[35];
  char bin_endianess[33];
  for (int i = 0; i < 32; i++)
  {
    bin_endianess[i] = '0';
  }
  bin_endianess[32] = '\0';
  char dec[32];
  char dec_endianess[32];
  char hex[32];
  char oc[35];
  bin[0] = '0';
  bin[1] = 'b';
  hex[0] = '0';
  hex[1] = 'x';
  oc[0] = '0';
  oc[1] = 'o';
  long decimal = 0;
  int bin_size = 0;
  int dec_size = 0;
  int dec_en_size = 0;
  int hex_size = 0;
  int oc_size = 0;

  // algoritmo
  if (str[1] == 'x')
  { // entrada hex
    hex_size = 0;
    for (int i = 0; str[i] != '\0'; i++)
    {
      hex[i] = str[i];
      hex_size++;
    }
    hex_size = hex_size - 3;
    decimal = hexToDec(hex, dec, hex_size);
    bin_size = decConverter(decimal, 2, bin);
    oc_size = decConverter(decimal, 8, oc);

    if (bin[2] == '1' && bin_size == 33)
    {
      dec[0] = '-';
      dec_size = intToString(decimal, dec, 1);
    }
    else
    {
      dec_size = intToString(decimal, dec, 0);
    }

    reverseEndianess(bin, bin_endianess, bin_size);
    binToDec(bin_endianess, dec_endianess);
    for (int i = 0; dec_endianess[i] != '\0'; i++)
    {
      dec_en_size ++;
    }
    dec_en_size ++;
    
  }
  else if (str[0] == '-') // entrada dec neg
  {

    for (int i = 1; str[i] != '\0'; i++)
    {
      decimal = (decimal * 10) + (str[i] - '0');
    }
    for (int i = 0; str[i] != '\0'; i++)
    {
      dec[i] = str[i];
      dec_size ++;
    }
    dec_size ++;

    bin_size = decConverter(decimal, 2, bin);
    char bin_2comp[33];
    for (int i = 0; i < 32; i++)
    {
      bin_2comp[i] = '0';
    }
    bin_2comp[32] = '\0';
    decimal = bin2complement(bin, bin_2comp, bin_size);
    bin_size = 33;

    oc_size = decConverter(decimal, 8, oc);
    hex_size = decConverter(decimal, 16, hex);
    

    reverseEndianess(bin, bin_endianess, bin_size);
    binToDec(bin_endianess, dec_endianess);
    for (int i = 0; dec_endianess[i] != '\0'; i++)
    {
      dec_en_size ++;
    }
    dec_en_size ++;
    

    // calcular bin -> transformar em complemento de 2 -> atualizar int decimal
  }
  else
  { // entrada dec pos
    for (int i = 0; str[i] != '\0'; i++)
    {
      dec[i] = str[i];
      decimal = (decimal * 10) + (str[i] - '0');
      dec_size ++;
    }
    dec_size++;
    bin_size = decConverter(decimal, 2, bin);
    oc_size = decConverter(decimal, 8, oc);
    hex_size = decConverter(decimal, 16, hex);
    reverseEndianess(bin, bin_endianess, bin_size);
    binToDec(bin_endianess, dec_endianess);
    for (int i = 0; dec_endianess[i] != '\0'; i++)
    {
      dec_en_size ++;
    }
    dec_en_size ++;

  }
  printf("essa é minha entrada %s\n", str);
  printf("%s %d\n", bin, bin_size);
  printf("%s %d\n", dec, dec_size);
  printf("%s %d\n", dec_endianess, dec_en_size);
  printf("%s %d\n", hex, hex_size);
  printf("%s %d\n", oc, oc_size);

  
  return 0;
}