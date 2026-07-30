.686
.model flat 
extern	__write : PROC 
extern	__read : PROC 
extern _ExitProcess@4 : PROC 
public _main 
.data 
znaki			db 12 dup (?)  
obszar			db 12 dup (?) 
dziesiec		dd 10 
dekoder			db '0123456789ABCDEF' ; these are ascii characters not numbers
leading_flag	db 0 
.code 

; what does this function do? turns unsigned binary number in eax into decimal ascii rep and prints
wyswietl_EAX PROC 
	pusha 
	mov  esi, 10  ; indeks w tablicy 'znaki' 
	mov  ebx, 10  ; dzielnik równy 10 
 
konwersja: 
	mov  edx, 0 ; clear remainder register (can also do xor edx, edx)
	div  ebx  ; divisor in ebx, result in EAX, remainder in EDX
	add  dl, 30H ; turning remainder into ascii 
	mov  znaki[esi], dl ; saving the ascii char into the array 
	dec  esi
	cmp  eax, 0  ; check if result is 0
	jne  konwersja ; go again if not zero otherwise continue to fill the rest of the array with spaces and add new line characters
wypeln: 
	;or  esi, esi ; 'or' checks if esi is 0 and sets the zero flag accordingly -- 'xor' would change esi to 0
	cmp esi, 0
	jz  wyswietl
	mov  byte PTR znaki[esi], 20H ; 20h is space in ascii 
	dec  esi   
	jmp  wypeln 
  
wyswietl: 
	mov  byte PTR znaki[0], 0AH ; 0ah is new line in ascii
	mov  byte PTR znaki[11], 0AH 
	
	; dword ptr isnt necessary here but its like adding var types in python. makes things clearer and more explicit.
	push  dword PTR 12 ; 12 chars displayed
	push  dword PTR OFFSET znaki ; address in memory of string to display
	push  dword PTR 1; device number -- 1 is screen
	call  __write   
	add  esp, 12  ; clean stack
   popa ; pops all registers that were pushed with pusha
   ret ; what does this ret do? returns to the caller of the function, in this case _main

wyswietl_EAX ENDP 

wczytaj_do_EAX	PROC 
     push ebx
	 push  dword PTR 12 
	 push  dword PTR OFFSET obszar 
	 push  dword PTR 0
	 call  __read  
	 add  esp, 12 
 

	 mov   eax, 0   
	 mov  ebx, 0
 
	pobieraj_znaki: 
	 mov  cl, obszar[ebx] ; mov dereferenced obszar into cl 
 
	 inc  ebx ; base register holds the index, counting register holds the number of loops
	 cmp  cl,10 ; 10 is enter in ascii
	 je  byl_enter

	 ; this runs if enter wassnt pressed and its an actual character
	 sub  cl, 30H ; zamiana kodu ASCII na wartość cyfry 
	 movzx ecx, cl ; movzx - move with zero extension
  
	 mul  dword PTR dziesiec ; 10 times eax -- result in eax -- mul and div use eax        
	 add  eax, ecx  
	 jmp  pobieraj_znaki 
 
	byl_enter: 
	 pop  ebx
	 ret
wczytaj_do_EAX	ENDP 

 
wyswietl_EAX_hex PROC 
	 pusha
            
	 sub  esp, 12 
	 mov  edi, esp ; edi becomes the working area on the stack 
             
	 mov  ecx, 8 ; num of loops 
	 mov  esi, 1 ; source index

	ptl3hex:    
 
	; przesunięcie cykliczne (obrót) rejestru EAX o 4 bity w lewo 
	; w szczególności, w pierwszym obiegu pętli bity nr 31 - 28 
	; rejestru EAX zostaną przesunięte na pozycje 3 - 0 
	 rol  eax, 4    
 
	; wyodrębnienie 4 najmłodszych bitów i odczytanie z tablicy 
	; 'dekoder' odpowiadającej im cyfry w zapisie szesnastkowym 
	 mov  ebx, eax ; kopiowanie EAX do EBX 
	 and  ebx, 0000000FH ; zerowanie bitów 31 - 4  rej.EBX
	 mov  dl, dekoder[ebx] ; pobranie cyfry z tablicy  
	 
	 ; if the number were looking at is 0 go to check if were still in leading space
	 ; if so add space instead of zero
	 cmp dl, 30h
	 je leading
	 mov byte PTR leading_flag, 1

leading:
	 cmp [leading_flag], 1
	 je not_leading
	 ; here we send space instead of the zero
	 mov dl, 32 ; 32 is space in ascii
not_leading:
	; przesłanie cyfry do obszaru roboczego 
	 mov  [edi][esi], dl  
 
	 inc  esi  ;inkrementacja modyfikatora 
	 loop  ptl3hex ; sterowanie pętla 
            
	; wpisanie znaku nowego wiersza przed i po cyfrach 
	 mov  byte PTR [edi][0], 10 
	 mov  byte PTR [edi][9], 10 

	; wyświetlenie przygotowanych cyfr 
	push	10 ; 8 numbers + 2 newlines
	push	edi ; address of the working area on the stack
	push	1
	call	__write
	; cleaning the stack 12 bytes for 3 pushes and 12 bytes for the working area on the stack 
	add		esp, 24
	popa  
	ret   
wyswietl_EAX_hex ENDP

 
wczytaj_do_EAX_hex  PROC 
 
	; wczytywanie liczby szesnastkowej z klawiatury – liczba po 
	; konwersji na postać binarną zostaje wpisana do rejestru EAX 
	; po wprowadzeniu ostatniej cyfry należy nacisnąć klawisz 
	; Enter 
 
	 push  ebx 
	 push  ecx 
	 push  edx 
	 push  esi 
	 push  edi 
	 push  ebp 
 
	; rezerwacja 12 bajtów na stosie przeznaczonych na tymczasowe 
	; przechowanie cyfr szesnastkowych wyświetlanej liczby 
	 sub  esp, 12 ; rezerwacja poprzez zmniejszenie ESP 
	 mov  esi, esp ; adres zarezerwowanego obszaru pamięci 
 
	 push  dword PTR 10 ; max ilość znaków wczytyw. liczby 
	 push  esi  ; adres obszaru pamięci 
	 push  dword PTR 0; numer urządzenia (0 dla klawiatury) 
	 call  __read ; odczytywanie znaków z klawiatury 
		 ; (dwa znaki podkreślenia przed read) 
	 add  esp, 12 ; usunięcie parametrów ze stosu 
 
	 mov  eax, 0 ; dotychczas uzyskany wynik 
 
	pocz_konw: 
	 mov  dl, [esi] ; pobranie kolejnego bajtu 
	 inc  esi  ; inkrementacja indeksu 
	 cmp  dl, 10 ; sprawdzenie czy naciśnięto Enter 
	 je  gotowe ; skok do końca podprogramu 
 
	; sprawdzenie czy wprowadzony znak jest cyfrą 0, 1, 2 , ..., 9 
	 cmp  dl, '0' 
	 jb  pocz_konw ; inny znak jest ignorowany 
	 cmp  dl, '9' 
	 ja  sprawdzaj_dalej 
	 sub  dl, '0' ; zamiana kodu ASCII na wartość cyfry 
	dopisz: 
	 shl  eax, 4 ; przesunięcie logiczne w lewo o 4 bity 
	 or  al, dl ; dopisanie utworzonego kodu 4-bitowego 
 
		  ; na 4 ostatnie bity rejestru EAX 
	 jmp  pocz_konw ; skok na początek pętli konwersji 
 
	; sprawdzenie czy wprowadzony znak jest cyfrą A, B, ..., F 
	sprawdzaj_dalej: 
	 cmp  dl, 'A' 
	 jb  pocz_konw  ; inny znak jest ignorowany 
	 cmp  dl, 'F' 
	 ja  sprawdzaj_dalej2 
	 sub  dl, 'A' - 10 ; wyznaczenie kodu binarnego 
	 jmp  dopisz 
 
	; sprawdzenie czy wprowadzony znak jest cyfrą a, b, ..., f 
	sprawdzaj_dalej2: 
	 cmp  dl, 'a' 
	 jb  pocz_konw   ; inny znak jest ignorowany 
	 cmp  dl, 'f' 
	 ja  pocz_konw   ; inny znak jest ignorowany 
	 sub  dl, 'a' - 10 
	 jmp  dopisz 
 
	gotowe: 
	; zwolnienie zarezerwowanego obszaru pamięci 
	 add  esp, 12 
 
	 pop  ebp 
	 pop  edi 
	 pop  esi 
	 pop  edx 
	 pop  ecx 
	 pop  ebx 
	 ret 
 
wczytaj_do_EAX_hex  ENDP 
	
_main PROC 
	;xor edx, edx ; clear edx 
	;mov ecx, 50 
	;mov eax, 1
;ptl:
;	call  wyswietl_EAX
;	inc edx
;	add eax, edx
;	dec ecx
;	jnz ptl


	;call wczytaj_do_EAX
	;cmp eax, 60000
	;jg error
	;mul eax
	;call wyswietl_EAX

;error:
	;call wczytaj_do_EAX
	;call wyswietl_EAX_hex


	call wczytaj_do_EAX_hex
	call wyswietl_EAX
	push 0 
	call _ExitProcess@4 
_main ENDP 
END 
