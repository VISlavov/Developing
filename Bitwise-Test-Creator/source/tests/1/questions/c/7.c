#include <stdio.h>
int main()
{
long value1 = 0x64006400;
long value2 = 0x39003900;
int result = (value1 << 17) ^ (value2 >> 8);
printf("%d", result);
return 0;
}
