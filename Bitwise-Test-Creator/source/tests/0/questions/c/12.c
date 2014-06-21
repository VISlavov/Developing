#include <stdio.h>
int main()
{
int value1 = 600;
int value2 = 450;
int result = (value1 << 9) | (value2 >> 2);
printf("%d", result);
return 0;
}
