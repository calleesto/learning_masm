.686
.XMM ; zezwolenie na asemblację rozkazów grupy SSE
.model flat
public _dodaj_SSE, _pierwiastek_SSE, _odwrotnosc_SSE, _int2float, _dodaj_SSE_int, _pm_jeden

.data 
ones	dd 4 dup (1.0) ; tablica czterech liczb zmiennoprzecinkowych

.code
_dodaj_SSE PROC
 push ebp
 mov ebp, esp
 push ebx
 push esi
 push edi
 mov esi, [ebp+8] ; adres pierwszej tablicy
 mov edi, [ebp+12] ; adres drugiej tablicy
 mov ebx, [ebp+16] ; adres tablicy wynikowej
; ładowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
; kowych 32-bitowych - liczby zostają pobrane z tablicy,
; której adres poczatkowy podany jest w rejestrze ESI
; interpretacja mnemonika "movups" :
; mov - operacja przesłania,
; u - unaligned (adres obszaru nie jest podzielny przez 16),
; p - packed (do rejestru ładowane są od razu cztery liczby), 
; s - short (inaczej float, liczby zmiennoprzecinkowe
; 32-bitowe)
 movups xmm5, [esi]
 movups xmm6, [edi]
; sumowanie czterech liczb zmiennoprzecinkowych zawartych
; w rejestrach xmm5 i xmm6
 addps xmm5, xmm6
 
; zapisanie wyniku sumowania w tablicy w pamięci
 movups [ebx], xmm5 
 pop edi
 pop esi
 pop ebx
 pop ebp
 ret
_dodaj_SSE ENDP
;========================================================= 
_pierwiastek_SSE PROC
 push ebp
 mov ebp, esp
 push ebx
 push esi
 mov esi, [ebp+8] ; adres pierwszej tablicy
 mov ebx, [ebp+12] ; adres tablicy wynikowej
; ładowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
; kowych 32-bitowych - liczby zostają pobrane z tablicy,
; której adres początkowy podany jest w rejestrze ESI
; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
 movups xmm6, [esi]
; obliczanie pierwiastka z czterech liczb zmiennoprzecinkowych
; znajdujących sie w rejestrze xmm6
; - wynik wpisywany jest do xmm5
 sqrtps xmm5, xmm6
 
; zapisanie wyniku sumowania w tablicy w pamięci
 movups [ebx], xmm5 
 pop esi
 pop ebx
 pop ebp
 ret
_pierwiastek_SSE ENDP

_odwrotnosc_SSE PROC
 push ebp
 mov ebp, esp
 push ebx
 push esi
 mov esi, [ebp+8]
 mov ebx, [ebp+12] 
; ladowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
; kowych 32-bitowych - liczby zostają pobrane z tablicy,
; której adres poczatkowy podany jest w rejestrze ESI 
; mnemonik "movups": zob. komentarz podany w funkcji dodaj_SSE
 movups xmm5, [esi]
; obliczanie odwrotności czterech liczb zmiennoprzecinkowych
; znajdujących się w rejestrze xmm6
; - wynik wpisywany jest do xmm5
 rcpps xmm5, xmm6
 
; zapisanie wyniku sumowania w tablicy w pamieci
 movups [ebx], xmm5 
 pop esi
 pop ebx
 pop ebp
 ret
_odwrotnosc_SSE ENDP


_dodaj_SSE_int PROC
 push ebp
 mov ebp, esp
 push ebx
 push esi
 push edi
 mov esi, [ebp+8] 
 mov edi, [ebp+12] 
 mov ebx, [ebp+16] 

 movups xmm5, [esi]
 movups xmm6, [edi]
 paddsb xmm5, xmm6

 movups [ebx], xmm5 
 pop edi
 pop esi
 pop ebx
 pop ebp
 ret
_dodaj_SSE_int ENDP


_int2float PROC
 push ebp
 mov ebp, esp
 push ebx
 push esi
 mov esi, [ebp+8] ; adres pierwszej int
 mov ebx, [ebp+12] ; adres tablicy float
 
 movups xmm5, [esi]
 cvtpi2ps xmm5, qword PTR [esi] 
 movups [ebx], xmm5 
 pop esi
 pop ebx
 pop ebp
 ret
 _int2float ENDP

 
 _pm_jeden PROC
 push ebp 
 mov ebp, esp 
 push esi

 mov esi, [ebp+8] 
 movups xmm5, [esi]
 movups xmm3, [ones]
 addsubps  xmm3, xmm5
 movups	[esi], xmm3
 pop esi
 pop ebp
 ret
 _pm_jeden ENDP

END