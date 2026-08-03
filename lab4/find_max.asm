.686 
.model flat 
 
public _szukaj4_max 
 
.code 
 
_szukaj4_max PROC 
	push  ebp  
	mov  ebp, esp  
	
	mov ecx, 0
	lea edx, [ebp+8] 
	mov eax, [edx]   

ptl:
	cmp ecx, 3
	je stop

	inc ecx
	cmp eax, [edx+ecx*4] 
	jge ptl

change_eax:
	mov eax, [edx+ecx*4]  
	jmp ptl

stop: 
	pop ebp 
	ret

_szukaj4_max ENDP 
END