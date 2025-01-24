.model small
data_seg segment 'data'
    input1 db 13,10,"Enter first number : $"
    input2 db 13,10,"Enter second number : $"
    st4 db 13,10,"What operation you want to perform (+ , - , * , /) : $"
    st5 db 13,10,"The result is : $"
    minst db "-$"
    erromsg db 13,10,"Division by zero is not allowed $"
    first dw 1,2,3
    second dw ?
    totaldigits dw ?
    operation db ?
    result dw 0
    num dw 0,0,0,0,0,0,0
    number1 db 0,0,0
    number2 db 0,0,0
data_seg ends

stack_seg segment 'stack'
    dw 100 DUP(?)
stack_seg ends

code_seg segment 'code'
    assume cs:code_seg, ss:stack_seg, ds:data_seg

    main proc far

    mov ax, data_seg
    mov ds, ax
;    mov bx, 0
;    mov bp, offset first
;mainloop:
;    mov dx, offset input1
;    mov ah, 09h
;    int 21h
;    mov si, offset number1
;    push ax
;    push bx
;    push cx
;    push dx
;    call read_number
;    pop dx
;    pop cx
;    pop bx
;    pop ax
;    mov si, offset number1
;    push ax
;    push bx;
;    push cx
;    push dx
;    push totaldigits
;    call convertnumber
;    mov [bp], ax
;    pop ax
;    xor ax, ax
;    pop dx
;    pop cx
;    pop bx
;    pop ax
;    inc bp
;    add bx, 2
 ;;   cmp bx, 6
 ;   jl mainloop
    mov si, offset first
    push si
    mov ax, [si]
    push ax
    call printnumber
    pop ax
    pop si
    inc si
    push si
    mov ax, [si]
    push ax
    call printnumber
    pop ax
    pop si
    inc si
    push si
    mov ax, [si]
    push ax
    call printnumber
    pop ax
    pop si
    inc si

    mov ah, 4ch
    int 21h

main endp
read_number proc near
    xor ax, ax
    mov cx, 0
    loopinput1:
        mov ah, 01h
        int 21h
        cmp al, 13           ; Check if Enter key is pressed
        je doneinput1
        cmp al, 27
        je doneinput1
        sub al, '0'          ; Convert ASCII to numeric
        cmp al, 9
        ja invalid_input     ; Reject non-numeric input
        mov [si], al
        inc si
        inc cx
        cmp cx, 3
        jl loopinput1
    doneinput1:
        mov totaldigits, cx
        ret
    invalid_input:
        ; Handle invalid input
        mov totaldigits, cx
        ret

read_number endp
convertnumber proc near
    xor ax, ax              ; Clear AX
    xor dx, dx

    mov bp, sp
    mov dx, [bp + 2]

    mov bl, 10
    mov cl, 100
    mov al, [si]
    cmp dx, 1
    je singledigit
    cmp dx, 2
    je twodigit
        
    mul cl                  ; Multiply first digit by 100
    mov dx, ax              ; Store result in DX
    xor ax, ax
    inc si
    twodigit:
        mov al, [si]
        mul bl                  ; Multiply second digit by 10
        add dx, ax              ; Add to DX
        xor ax, ax
        inc si
        mov al, [si]
        CBW
        add ax, dx              ; Add third digit
        jmp endconvertproc
    singledigit:
        CBW
    endconvertproc:
        ret

convertnumber endp

printnumber proc near
    mov dx, offset st5
    mov ah, 09h
    int 21h
    mov bp, sp
    mov ax, [bp + 2]
    cmp ax, 0
    jge positive_number
    ; Handle negative numbers
    neg ax 
    push ax
    mov dx, offset minst
    mov ah, 09h
    int 21h
    pop ax
positive_number:
    cmp ax, 10
    jl printsingle
    mov bx, 10
    xor cx, cx
    mov si, offset num
    digit_extract:
        xor dx, dx
        div bx
        add dx, '0'
        mov [si], dx
        inc si
        inc cl
        cmp ax, 0
        jnz digit_extract
    print_digits:
        dec si
        mov dx, [si]
        mov ah, 02h
        int 21h
        dec cl
        cmp cl, 0
        jne print_digits
        jmp endprintproc
    printsingle:
        add ax, '0'
        mov dx, ax
        mov ah, 02h
        int 21h

    endprintproc:
        ret
printnumber endp

code_seg ends
end main