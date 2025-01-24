.model tiny
.code
org 100h
start:
jmp codepart
    oldvect dd(?)

codepart:
    mov ax, 0
    mov es, ax
    mov ax, es:[8h * 4]
    mov word ptr cs: oldvect, ax
    mov ax, es:[8h *4 + 2]
    mov word ptr cs: oldvect[2], ax
    mov ax, offset myproc
    mov es:[8h * 4], ax
    mov es: [8h * 4 + 2], cs 
    mov ah, 31h
    mov al, 0
    mov dx, 100h
    int 21H
myproc proc far
    push ax
    push es
    mov ax, 0b800h
    mov es, ax
    mov byte ptr es:[0],'a'
    mov byte ptr es:[1],07H
    mov byte ptr es:[2],'b'
    mov byte ptr es:[3],07H
    mov byte ptr es:[4],'d'
    mov byte ptr es:[5],07h
    mov byte ptr es:[6],'u'
    mov byte ptr es:[7],07H
    mov byte ptr es:[8],'l'
    mov byte ptr es:[9],07h
    mov byte ptr es:[10],'m'
    mov byte ptr es:[11],07h
    mov byte ptr es:[12],'a'
    mov byte ptr es:[13],07h
    mov byte ptr es:[14],'j'
    mov byte ptr es:[15],07h
    mov byte ptr es:[16],'i'
    mov byte ptr es:[17],07h
    mov byte ptr es:[18],'d'
    mov byte ptr es:[19],07h
    pop es
    pop ax
    jmp dword ptr cs:oldvect

myproc endp


end start

