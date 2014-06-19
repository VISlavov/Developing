#include <stdio.h>
int main()
{
long testValue = 0xC600C600;
int a = 0;
if (testValue & (1 << 4))
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
