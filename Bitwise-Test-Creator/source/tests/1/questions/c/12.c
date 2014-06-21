#include <stdio.h>
int main()
{
int value1 = 830;
int value2 = 897;
int result = (value1 << 11) | (value2 >> 8);
printf("%d", result);
return 0;
}
