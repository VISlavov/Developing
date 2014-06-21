#include <stdio.h>
int main()
{
long testValue = 0x6A006A00;
int a = 0;
if (testValue & (1 << 2))
{
	a = 1;
}
else
{
	a = 2;
}
printf("%d", a);
return 0;
}
