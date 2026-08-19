#include <stdio.h>
void dodaj_SSE(float*, float*, float*);
void pierwiastek_SSE(float*, float*);
void odwrotnosc_SSE(float*, float*);
void dodaj_SSE_int(int*, int*, int*);
void int2float(int* calkowite, float* zmienno_przec);
void pm_jeden(float* tabl);
int main()
{
	float tablica[4] = { 27.5,143.57,2100.0, -3.51 };
	printf("\n%f   %f   %f   %f\n", tablica[0], tablica[1], tablica[2], tablica[3]);
	pm_jeden(tablica);
	printf("\n%f   %f   %f   %f\n", tablica[0], tablica[1], tablica[2], tablica[3]);



	printf("\n\n\n\n\n\n");
	
	int a[2] = { -17, 24 };
	float result[4];
	float p[4] = { 1.0, 1.5, 2.0, 2.5 };
	float q[4] = { 0.25, -0.5, 1.0, -1.75 };
	float r[4];
	char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122, -121, 120,  121,  122,  123,  124,  125,  126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3, 3,  3,  3,  3,  3,  3,  3,  3 };
	char wynik[16];


	int2float(a, result);
	printf("\nKonwersja = %f  %f\n", result[0], result[1]);

	dodaj_SSE_int((int*)liczby_A, (int*)liczby_B, (int*)wynik);
	printf("\n%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d", wynik[0], wynik[1], wynik[2], wynik[3], wynik[4], wynik[5], wynik[6], wynik[7], wynik[8], wynik[9], wynik[10], wynik[11], wynik[12], wynik[13], wynik[14], wynik[15]);
	dodaj_SSE(p, q, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", q[0], q[1], q[2], q[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
	printf("\n\nObliczanie pierwiastka");
	pierwiastek_SSE(p, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
	printf("\n\nObliczanie odwrotności - ze względu na \
stosowanie");
	printf("\n12-bitowej mantysy obliczenia są mało dokładne");
	odwrotnosc_SSE(p, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
	return 0;
}