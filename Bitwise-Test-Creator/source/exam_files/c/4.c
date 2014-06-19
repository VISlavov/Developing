#include <stdio.h>
int main()
{
int orig = 0x0305;
int insert = 0x0C01;
int a = orig | (insert << 5);
int b = orig | (insert << 11);
int OR = a | b;
printf("%d", OR);
return 0;
}
