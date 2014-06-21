#include <stdio.h>
int main()
{
int orig = 0x030A;
int insert = 0x0706;
int a = orig | (insert << 9);
int b = orig | (insert << 5);
int OR = a | b;
printf("%d", OR);
return 0;
}
