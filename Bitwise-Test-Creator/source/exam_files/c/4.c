#include <stdio.h>
int main()
{
int orig = 0x0E06;
int insert = 0x0800;
int a = orig | (insert << 17);
int b = orig | (insert << 11);
int OR = a | b;
printf("%d", OR);
return 0;
}
