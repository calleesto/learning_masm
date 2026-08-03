 .686 
.model flat 
public  _odejmij_jeden
.code 
 
_odejmij_jeden PROC 
     push  ebp  
     mov  ebp,esp 
     push  ebx
 
    ; the clue here is that the parameter in c is the address of an address so we gotta dereference it twice
     mov   ebx, [ebp+8] ; we have the address of the address in ebx
     mov   ebx, [ebx]    ; dereference it to get the actual address of the variable
     dec   dword PTR [ebx] 

     pop  ebx 
     pop  ebp 
     ret 
_odejmij_jeden ENDP 
END