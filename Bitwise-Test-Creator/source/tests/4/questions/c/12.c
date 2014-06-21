#include <stdio.h>
int main()
{
int value1 = 362;
int value2 = 123;
int result = (value1 << 11) | (value2 >> 16);
printf("%d", result);
return 0;
}
