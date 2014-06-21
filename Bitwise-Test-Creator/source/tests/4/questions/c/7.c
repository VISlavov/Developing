#include <stdio.h>
int main()
{
long value1 = 0xDA00DA00;
long value2 = 0x1B001B00;
int result = (value1 << 9) ^ (value2 >> 16);
printf("%d", result);
return 0;
}
