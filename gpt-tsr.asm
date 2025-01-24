.model tiny
.code
org 100h
start:
    jmp codepart
oldvect dd ?             ; Space to store the old interrupt vector

codepart:
    ; Save the old interrupt vector for interrupt 08h
    mov ax, 0
    mov es, ax
    mov ax, es:[8h * 4]  ; Get the old offset
    mov word ptr cs:oldvect, ax
    mov ax, es:[8h * 4 + 2] ; Get the old segment
    mov word ptr cs:oldvect[2], ax

    ; Install the new interrupt handler
    mov ax, offset myproc
    mov es:[8h * 4], ax
    mov es:[8h * 4 + 2], cs 

    ; Terminate and Stay Resident
    mov ah, 31h          ; DOS TSR function
    mov al, 0            ; Return code
    mov dx, 100h         ; Keep 256 bytes resident
    int 21h

myproc proc far           ; Interrupt Service Routine
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es
    pushf                ; Save flags

    ; Custom logic to display characters on the screen
    mov ax, 0b800h       ; Video memory segment for text mode
    mov es, ax
    mov di, 0            ; Start at the first character cell
    mov byte ptr es:[di], 'a'
    mov byte ptr es:[di+1], 07h
    mov byte ptr es:[di+2], 'b'
    mov byte ptr es:[di+3], 07h
    mov byte ptr es:[di+4], 'd'
    mov byte ptr es:[di+5], 07H
    mov byte ptr es:[di+6], 'u'
    mov byte ptr es:[di+7], 07h
    mov byte ptr es:[di+8], 'l'
    mov byte ptr es:[di+9], 07h
    mov byte ptr es:[di+10], ' '
    mov byte ptr es:[di+11], 07h
    mov byte ptr es:[di+12], 'm'
    mov byte ptr es:[di+13], 07h
    mov byte ptr es:[di+14], 'a'
    mov byte ptr es:[di+15], 07h
    mov byte ptr es:[di+16], 'j'
    mov byte ptr es:[di+17], 07h
    mov byte ptr es:[di+18], 'i'
    mov byte ptr es:[di+19], 07h
    mov byte ptr es:[di+20], 'd'

    ; Add more characters as needed
    ; ...

    ; Call the original interrupt handler
    popf                 ; Restore flags
    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    jmp dword ptr cs:oldvect ; Jump to the original handler

myproc endp
end start
