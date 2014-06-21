#include <stdio.h>
int main()
{
int orig = 0x030A;
int insert = 0x0706;
int a = orig | (insert << 8);
int b = orig | (insert << 4);
int AND = a & b;
printf("%d", AND);
return 0;
}
