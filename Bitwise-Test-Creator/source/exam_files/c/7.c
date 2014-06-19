#include <stdio.h>
int main()
{
long value1 = 0x66006600;
long value2 = 0x2B002B00;
int result = (value1 << 3) ^ (value2 >> 16);
printf("%d", result);
return 0;
}
