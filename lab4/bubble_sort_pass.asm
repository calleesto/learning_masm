.686 
.model flat 
public  _bubble_sort_pass
.code 

_bubble_sort_pass PROC
	push ebp 
	mov ebp, esp
	push ebx 

	; first parameter is the address of the array 
	; second parameter is the size of the array 

	mov ebx, [ebp+8] ; address of the array/ of its first element
	mov ecx, [ebp+12] ; size of the array
	dec ecx

ptl: ; ebx is the address of the first element
	mov eax, [ebx] ; we hold the value of the first element in eax

	cmp eax, [ebx+4] ; comapre with the next element of the array 
	jle skip
	;otherwise swap
	; we use edx as a temporary register
	mov edx, [ebx+4]
	mov [ebx], edx
	mov [ebx+4], eax

skip:
	add ebx, 4 ; move the bubble forward 
	loop ptl
	pop ebx
	pop ebp
	ret
_bubble_sort_pass ENDP
END
