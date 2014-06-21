#include <stdio.h>
int main()
{
long value1 = 0xD600D600;
long value2 = 0xAB00AB00;
int result = (value1 << 13) ^ (value2 >> 2);
printf("%d", result);
return 0;
}
