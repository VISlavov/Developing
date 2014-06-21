#include <stdio.h>
int main()
{
int value1 = 143;
int value2 = 354;
int result = (value1 << 15) | (value2 >> 8);
printf("%d", result);
return 0;
}
