#include <stdio.h>
int main()
{
int value1 = 794;
int value2 = 716;
int result = (value1 << 3) ^ (value2 >> 8);
printf("%d", result);
return 0;
}
