#include <stdio.h>
int main()
{
int value1 = 911;
int value2 = 482;
int result = (value1 << 5) ^ (value2 >> 8);
printf("%d", result);
return 0;
}
