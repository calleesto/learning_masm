#include <stdio.h> 
extern __int64 _suma_siedmiu_liczb(__int64  v1, __int64  v2, __int64 v3, __int64  v4, __int64  v5, __int64  v6, __int64  v7);

int main()
{
    __int64 v1, v2, v3, v4, v5, v6, v7;

	printf("Podaj 7 liczb calkowitych: ");
	scanf_s("%I64d %I64d %I64d %I64d %I64d %I64d %I64d", &v1, &v2, &v3, &v4, &v5, &v6, &v7);

    __int64 suma = 0;

    suma = _suma_siedmiu_liczb(v1, v2, v3, v4, v5, v6, v7);
    printf("\nSuma siedmiu liczb wynosi %I64d\n", suma); // 21
    return 0;
}