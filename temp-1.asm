.model small
data_seg segment 'data'
    char db 'A'            ; Character to display
    row db 12              ; Initial row (Y-coordinate)
    col db 33              ; Initial column (X-coordinate)
    blank db ' '           ; Used to erase the previous character
data_seg ends

stack_seg segment 'stack'
    dw 200 DUP(?)
stack_seg ends

code_seg segment 'code'
    assume cs:code_seg, ds:data_seg, ss:stack_seg

main proc far 
    ; Initialize data segment
    mov ax, data_seg
    mov ds, ax

    mov ah, 06
    mov al, 00
    int 10h
main endp
code_seg ends
end main