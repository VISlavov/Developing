#include <stdio.h>
int main()
{
long value1 = 0xF100F100;
long value2 = 0x01000100;
int result = (value1 << 3) ^ (value2 >> 16);
printf("%d", result);
return 0;
}
