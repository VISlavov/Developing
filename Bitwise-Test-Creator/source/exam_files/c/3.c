#include <stdio.h>
int main()
{
int orig = 0x0305;
int insert = 0x0C01;
int a = orig | (insert << 8);
int b = orig | (insert << 8);
int AND = a & b;
printf("%d", AND);
return 0;
}
