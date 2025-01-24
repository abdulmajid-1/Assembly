data_seg segment 'data'
    A dw 2
    B dw 4
    C dw 5

data_seg ends

stack_seg segment 'stack'
    dw 100 DUP(?)
stack_seg ends

code_seg segment 'code'
    assume cs:code_seg, ss:stack_seg, ds:data_seg

main proc far
    mov ax, data_seg
    mov ds, ax
    mov ax, A
    mov bx, B
    mov si, offset C
    call Addition
    mov ax, B
    mov bx, C
    mov si, offset A
    call Addition
    mov dx, C
    mov ah, 02
    int 21h

    mov dx, A
    mov ah, 02
    int 21h

    
    ; Terminate program
    mov ah, 4Ch
    int 21h
main endp
Addition proc near
    add ax, bx
    mov [si], ax
    ret
Addition endp
code_seg ends
end main
