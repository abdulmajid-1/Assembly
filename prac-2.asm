data_seg segment 'data'
    first db (?)       ; Store first character
    second db (?)      ; Store second character
    st1 db 13,10,"Enter a digit: ",'$'
    result dw (?)
data_seg ends

stack_seg segment 'stack'
    dw 100 DUP(?)
stack_seg ends

code_seg segment 'code'
    assume cs:code_seg, ss:stack_seg, ds:data_seg

main proc far
    ; Initialize data segment
    mov ax, data_seg
    mov ds, ax

    ; Print prompt
    mov dx, offset st1
    mov ah, 09h
    int 21h

    ; Get first input
    mov ah, 01h
    int 21h
    mov first, al     ; Store first character

    ; Print prompt again
    mov dx, offset st1
    mov ah, 09h
    int 21h

    ; Get second input
    mov ah, 01h
    int 21h
    mov second, al    ; Store second character

    add al, first
    AAA
    add ax, 3030h

;    mov cl, al
    mov result, ax
    ; Output high nibble
    mov dl, ah
    mov ah, 02h
    int 21h

    ; Output low nibble
    mov dl, cl
    mov ah, 02h
    int 21h

    ; Terminate program
    mov ah, 4Ch
    int 21h
main endp
code_seg ends
end main
