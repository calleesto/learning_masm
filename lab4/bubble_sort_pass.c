#include <stdio.h> 
void bubble_sort_pass(int tabl[], int n);
int main()
{
	int arr[] = { 5, 2, 9, 1, 5, 6 };
	int size = sizeof(arr) / sizeof(arr[0]); // sizeof returns size in bytes hence why we divide by sizeof 1 element (int)
	printf("\nPrzed = ");
	for (int i = 0; i < size; i++) {
		printf("%d ", arr[i]);
	}
	bubble_sort_pass(arr, size);
	printf("\nPo = ");
	for (int i = 0; i < size; i++) {
		printf("%d ", arr[i]);
	}
	printf("\n");
	return 0;
}