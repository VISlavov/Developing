#include <stdio.h>
int main()
{
int orig = 0x0E06;
int insert = 0x0800;
int a = orig | (insert << 8);
printf("%d", a);
return 0;
}
