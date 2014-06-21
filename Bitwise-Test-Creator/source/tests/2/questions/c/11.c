#include <stdio.h>
int main()
{
int value1 = 853;
int value2 = 236;
int result = (value1 << 9) ^ (value2 >> 2);
printf("%d", result);
return 0;
}
