#include <stdio.h> 
float srednia_harm(float* tablica, unsigned  int  n);
int main()
{
	float arr[] = { -3.000, -1.131543, 3.6544, 100.432, 5.321, -6.00076 };
	int size = sizeof(arr) / sizeof(arr[0]); // sizeof returns size in bytes hence why we divide by sizeof 1 element (int)
	float harm_avg = srednia_harm(arr, size);
	printf("%f", harm_avg);
	return 0;
}