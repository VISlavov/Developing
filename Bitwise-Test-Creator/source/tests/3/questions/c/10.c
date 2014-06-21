#include <stdio.h>
int main()
{
long testValue = 0x6A006A00;
int a = 0;
int result = 0;
if ( (result = testValue & testValue ^ testValue | (1 << 8)) )
{
	a = 1;
}
else
{
	a = 2;
}
printf("[%d; %d]", a, result);
return 0;
}
