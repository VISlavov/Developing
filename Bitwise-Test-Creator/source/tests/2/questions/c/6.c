#include <stdio.h>
int main()
{
int i = 0x030A;
int left = 0x030A | (1 << 5);
printf("%d", left);
return 0;
}
