#include <stdio.h>
int main()
{
int orig = 0x030A;
int insert = 0x0706;
int a = orig | (insert << 5);
printf("%d", a);
return 0;
}
