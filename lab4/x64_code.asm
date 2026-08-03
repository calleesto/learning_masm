 
public _suma_siedmiu_liczb 
 
.code 
 
_suma_siedmiu_liczb PROC 
		; w momencie wejscia do funkcji parametr 5 jest pod [rsp+40] (8 slad, 32 shadow space)
	; teoria 64 bitowa
	; pierwsze 4 parametry przez rcx rdx r8 r9 potem stos
	

	xor rax, rax 
	add rax, rcx
	add rax, rdx
	add rax, r8
	add rax, r9 
	add rax, [rsp + 40]
	add rax, [rsp + 48]
	add rax, [rsp + 56]

	ret 
_suma_siedmiu_liczb ENDP 
END