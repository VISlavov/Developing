#include <stdio.h>
int main()
{
int i = 0x0305;
int left = 0x0305 | (1 << 13);
printf("%d", left);
return 0;
}
