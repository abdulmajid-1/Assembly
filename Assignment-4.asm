model small

data_seg segment 'data'
  character db 'A'
  blank_character db ' '
  row db 12
  col db 38
  is_row_end db 0
  is_col_end db 0
data_seg ends


stack_seg segment 'stack'
  dw 100 DUP(?)
stack_seg ends

code_seg segment 'code'
  assume cs:code_seg, ds:data_seg, ss:stack_seg
main proc far

  mov ax, data_seg
  mov ds, ax

  ; clearing the screen
  mov al, 25 
  mov bh, 07h
  mov cx, 0000h 
  mov dx, 184Fh 
  mov ah, 06h
  int 10h 

  mov bh, 0 
  mov dh, row 
  mov dl, col 
  mov ah, 02 
  int 10h 


  mov dl, [character]
  mov ah, 02
  int 21h

  ; Delay 
  
  mov ax, 40H 
  mov es, ax 

  character_loop:
    mov dx, es:[6Ch] 
    mov cx, es:[6Eh] 
    
      
    
    add dx, 2 
    adc cx, 0 
  
    delay:
      mov ax, es:[6Ch] 
      mov bx, es:[6Eh] 
      cmp bx, cx 
      jl delay 
      je delay_next 
      jmp delay_end
  
      delay_next:
        cmp ax, dx 
        jl delay 
      
      delay_end:
        mov bh, 0 
        mov dh, row 
        mov dl, col 
        mov ah, 02 
        int 10h 
        
        mov dl, [blank_character]
        mov ah, 02
        int 21h

        cmp is_col_end, 1
        jne inc_col

        dec col
        jmp check_for_row

        inc_col:
          inc col

        check_for_row:
        cmp is_row_end, 1 
        jne inc_row
        
        dec row 
        jmp action

        inc_row:
          inc row
          jmp action

      
        action: 

          mov bh, 0 
          mov dh, row 
          mov dl, col 
          mov ah, 02 
          int 10h 


          mov dl, [character]
          mov ah, 02
          int 21h


        cmp row, 24
        je update_row_1

        cmp row, 0
        je update_row_0

        cmp col, 79
        je update_col_1

        cmp col, 0
        je update_col_0


        jmp character_loop

        update_col_1: 
          mov is_col_end, 1
          jmp character_loop

        update_col_0: 
          mov is_col_end, 0
          jmp character_loop

        update_row_0:
          mov is_row_end, 0
          jmp character_loop

        update_row_1: 
          mov is_row_end, 1
          jmp character_loop


exit_program:

  mov ah, 04ch
  int 21h

main endp
code_seg ends
end main
