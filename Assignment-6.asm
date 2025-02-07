;assignment # 6: BUBBLE SORT ONLY WORKS FOR 2 DIGIT ELEMENTS

.model small

Data_seg segment 'data'
  Numbers dw 25, 33, 42, 10, 19
  counter dw 0
  inner_counter dw 2
  newline db 10, 13, '$'
Data_seg ends

Stack_seg segment 'stack'
  dw 100 DUP(?)
Stack_seg ends

Code_seg segment 'code'
  assume cs:Code_seg, ds:Data_seg, ss:Stack_seg
main proc far
  mov ax, Data_seg
  mov ds, ax

  ; Before sorting

  mov ax, offset Numbers
  mov cx, 5
  push ax
  push cx
  call print

  mov cx, 5
  dec cx
  outerloop:
    mov bx, 0
    innerloop:
      mov ax, Numbers[bx]   
      mov dx, Numbers[bx+2]
      cmp ax, dx      ;compare element from the next one
      jle no_swap    

      ; swaping
      mov Numbers[bx], dx
      mov Numbers[bx+2], ax

      no_swap:
      add bx, 2         ; move to the next element
      cmp bx, 8        
      jl innerloop     
    loop outerloop

    ; After sorting
    mov ax, offset Numbers
    mov cx, 5
    push ax
    push cx
    call print
  

  mov ah, 04ch
  int 21h
main endp
; we take address of array and total number of element
print proc near
  mov ax, data_seg
  mov ds, ax

  mov bp, sp
  mov cx, [bp + 2] ; length of array
  mov bx, [bp + 4] ; offset address of first element
  Loopbody: 
    mov ax, [bx]   
    aam
    add ax, 3030h
    push ax
    mov dl, ah
    mov ah, 02h
    int 21h
    pop ax
    mov dl, al
    mov ah, 02h
    int 21h
    mov ah, 02h
    mov dl, ' '
    int 21h
    add bx, 2
    loop Loopbody
  mov dx, offset newline
  mov ah, 09h
  int 21h
  ret 4
print endp
code_seg ends

end main