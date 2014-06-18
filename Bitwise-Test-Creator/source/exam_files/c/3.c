#include <stdio.h>
int main()
{
int orig = 0x0E06;
int insert = 0x0800;
int a = orig | (insert << 2);
int b = orig | (insert << 2);
int AND = a & b;
printf("%d", AND);
return 0;
}
