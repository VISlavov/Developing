#include <stdio.h>
int main()
{
int value1 = 269;
int value2 = 585;
int result = (value1 << 15) ^ (value2 >> 8);
printf("%d", result);
return 0;
}
