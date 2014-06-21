#include <stdio.h>
int main()
{
int value1 = 164;
int value2 = 653;
int result = (value1 << 15) | (value2 >> 4);
printf("%d", result);
return 0;
}
