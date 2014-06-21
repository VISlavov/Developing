#include <stdio.h>
int main()
{
long value1 = 0x6D006D00;
long value2 = 0x2F002F00;
int result = (value1 << 15) ^ (value2 >> 16);
printf("%d", result);
return 0;
}
