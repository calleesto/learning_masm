.686
.model flat
public _srednia_harm

.code

_srednia_harm PROC
    finit

    fldz

    mov edx, [esp+4]   

    ; arr[0]
    fld dword ptr [edx]         ; ST(0) = x, ST(1) = sum
    fld1                        ; ST(0) = 1, ST(1) = x, ST(2) = sum
    fdivrp st(1), st(0)         ; ST(0) = 1/x, ST(1) = sum
    faddp st(1), st(0)          ; ST(0) = sum + 1/x

    ; arr[1]
    add edx, 4
    fld dword ptr [edx]
    fld1
    fdivrp st(1), st(0)
    faddp st(1), st(0)

    ; arr[2]
    add edx, 4
    fld dword ptr [edx]
    fld1
    fdivrp st(1), st(0)
    faddp st(1), st(0)

    ; arr[3]
    add edx, 4
    fld dword ptr [edx]
    fld1
    fdivrp st(1), st(0)
    faddp st(1), st(0)

    ; arr[4]
    add edx, 4
    fld dword ptr [edx]
    fld1
    fdivrp st(1), st(0)
    faddp st(1), st(0)

    ; arr[5]
    add edx, 4
    fld dword ptr [edx]
    fld1
    fdivrp st(1), st(0)
    faddp st(1), st(0)

    ; ST(0) = 1/arr1 + 1/arr2 + ... + 1/arr6

    fild dword ptr [esp+8]      ; ST(0) = n, ST(1) = sum
    fdivrp st(1), st(0)         ; ST(0) = n / sum

    ret

_srednia_harm ENDP
END