; wczytywanie i wyświetlanie tekstu wielkimi literami 
; (inne znaki się nie zmieniają) 
.686 
.model flat 
extern  _ExitProcess@4 : PROC 
extern  __write : PROC ; (dwa znaki podkreślenia) 
extern  __read  : PROC ; (dwa znaki podkreślenia) 
extern	_MessageBoxA@16 : PROC
extern	_MessageBoxW@16 : PROC
public  _main 
.data 
tekst_pocz		db 10, 'Proszę napisać jakiś tekst ' 
				db 'i nacisnac Enter', 10 
koniec_t		db ? 
magazyn			db 80 dup (?), 0
magazyn_utf		dw 80 dup (?), 0
nowa_linia		db 10 	
liczba_znakow	dd ? 
w1250_title		db	'Tekst w kodowaniu Windows-1250', 0
utf16_title		dw	'T','e','k','s','t',' ','w',' ','U','T','F','-','1','6', 0


.code 
_main	PROC 
; write welcome text
		mov     ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz) 
		push    ecx 
		push    OFFSET tekst_pocz
		push    1 
		call    __write 
		add     esp, 12 


; read text from keyboard 
		push    80 ; char limit
		push    OFFSET magazyn ; store here 
		push    0  ; keyboard
		call    __read
		add     esp, 12
	
		; __read counts the number of characters read and stores in eax	
		mov     liczba_znakow, eax 
		mov     ecx, eax 
		mov     esi, 0  
		mov		edi, 0

; here we need to read magazyn and convert it to utf-8 and store it in magazyn_utf
convert: 
		; load magazyn into dl 
		; movz dl to ax
		; next
		mov		dl, magazyn[esi]
		movzx	ax, dl
		mov		magazyn_utf[edi], ax ; scaled by two since its a word array
		inc		esi
		add		edi, 2
		dec		ecx
		jnz		convert


		mov     ecx, liczba_znakow
		mov     ebx, 0 

; this loop checks whether the current character is NOT A ASCII LETTER between below lower case a or above z in ascii value
loop_1250:	mov     dl, magazyn[ebx] ; pobranie kolejnego znaku
		cmp     dl, 'a' ; ascii value of letter a
		jb      polish_check_cp1250   ; skok, gdy znak nie wymaga zamiany 
		cmp     dl, 'z' ; ascii value of letter z
		ja      polish_check_cp1250   ; skok, gdy znak nie wymaga zamiany 
		sub     dl, 20H ; zamiana na wielkie litery 
		mov     magazyn[ebx], dl 

		jmp		next_1250
; odesłanie znaku do pamięci 

polish_check_cp1250: 
		cmp		dl, 185 ; lowercase a with ogonek
		je		twenty
		cmp		dl, 230 ; lowercase c with acute
		je		thirty_two
		cmp		dl, 234 ; lowercase e with ogonek
		je		thirty_two
		cmp		dl, 179 ; lowercase l with stroke
		je		sixteen
		cmp		dl, 241 ; lowercase n with acute
		je		thirty_two
		cmp		dl, 243 ; lowercase o with acute
		je		thirty_two
		cmp		dl, 156 ; lowercase s with acute
		je		sixteen
		cmp		dl, 159 ; lowercase z with acute
		je		sixteen
		cmp		dl, 191 ; lowercase z with dot above
		je		sixteen
		jmp		next_1250

twenty:
		sub		dl, 20
		mov     magazyn[ebx], dl 
		jmp		next_1250
thirty_two:
		sub		dl, 32
		mov     magazyn[ebx], dl 
		jmp		next_1250
sixteen:
		sub		dl, 16
		mov     magazyn[ebx], dl 
		jmp		next_1250

next_1250:  
		inc     ebx     
		dec		ecx
		jnz		loop_1250


		mov     ecx, liczba_znakow
		mov     ebx, 0 

loop_utf16:
		mov     dx, magazyn_utf[ebx*2] 
		cmp     dx, 'a' 
		jb      polish_check_utf16 
		cmp     dx, 'z' 
		ja      polish_check_utf16
		sub     dx, 20H 
		mov     magazyn_utf[ebx*2], dx 

		jmp		next_utf16

polish_check_utf16: 
		cmp		dx, 00b9h ; lowercase a with ogonek
		je		a_ogonek
		cmp		dx, 00e6h ; lowercase c with acute
		je		c_acute
		cmp		dx, 00eah ; lowercase e with ogonek
		je		e_ogonek
		cmp		dx, 00b3h ; lowercase l with stroke
		je		l_stroke
		cmp		dx, 00f1h ; lowercase n with acute
		je		n_acute
		cmp		dx, 00f3h ; lowercase o with acute
		je		o_acute
		cmp		dx, 009ch ; lowercase s with acute
		je		s_acute
		cmp		dx, 009fh ; lowercase z with acute
		je		z_acute
		cmp		dx, 00bfh ; lowercase z with dot above
		je		z_dot

		jmp		next_utf16

a_ogonek:
		mov     magazyn_utf[ebx*2], 0104H
		jmp		next_utf16
c_acute:
		mov     magazyn_utf[ebx*2], 0106H
		jmp		next_utf16
e_ogonek:
		mov     magazyn_utf[ebx*2], 0118H
		jmp		next_utf16
l_stroke:
		mov     magazyn_utf[ebx*2], 0141H
		jmp		next_utf16
n_acute:
		mov     magazyn_utf[ebx*2], 0143H
		jmp		next_utf16
o_acute:
		mov     magazyn_utf[ebx*2], 00d3H
		jmp		next_utf16
s_acute:
		mov     magazyn_utf[ebx*2], 015aH
		jmp		next_utf16
z_acute:
		mov     magazyn_utf[ebx*2], 0179H
		jmp		next_utf16
z_dot:
		mov     magazyn_utf[ebx*2], 017bH
		jmp		next_utf16

next_utf16:  
		inc     ebx     
		dec		ecx
		jnz		loop_utf16	



; wyświetlenie przekształconego tekstu 
		;push    liczba_znakow 
		;push    OFFSET magazyn 
		;push    1 
		;call    __write  ; wyświetlenie przekształconego tekstu



		push	0
		push	OFFSET w1250_title
		push	OFFSET magazyn
		push	0
		call	_MessageBoxA@16

		push	0
		push	OFFSET utf16_title
		push	OFFSET magazyn_utf
		push	0
		call	_MessageBoxW@16


		;add     esp, 12  ; usuniecie parametrów ze stosu 
		push    0 
		call    _ExitProcess@4      ; zakończenie programu 
_main	ENDP
END 