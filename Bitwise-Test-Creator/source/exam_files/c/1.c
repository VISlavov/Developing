#include <stdio.h>
int main()
{
int orig = 0x0305;
int insert = 0x0C01;
int a = orig | (insert << 2);
printf("%d", a);
return 0;
}
