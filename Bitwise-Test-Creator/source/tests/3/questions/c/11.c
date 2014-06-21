#include <stdio.h>
int main()
{
int value1 = 118;
int value2 = 236;
int result = (value1 << 3) ^ (value2 >> 8);
printf("%d", result);
return 0;
}
