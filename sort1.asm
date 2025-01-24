.MODEL SMALL

data_seg segment 'data'
    numbers DW 15 DUP(0)        ; Array to store 15 numbers
    count   DW 3               ; Number of elements
    prompt  DB 'Enter a number: $'
    newline DB 0DH, 0AH, '$'
    minst db "-$"
    num dw 0,0,0,0,0
    sorted_msg DB 'Sorted Numbers:$'
data_seg ends
stack_seg segment 'stack'
    dw 100 DUP(?)
stack_seg ends

code_seg segment 'code'
main proc far
    assume ds:data_seg, ss:stack_seg, cs:code_seg

    MOV AX, data_seg               ; Load the data segment
    MOV DS, AX

    ; Prompt user to input 15 numbers
    LEA SI, numbers             ; Load the address of the numbers array
    MOV CX, count               ; Loop counter for 15 numbers
INPUT_LOOP:
    LEA DX, prompt              ; Display prompt
    MOV AH, 09H
    INT 21H

    CALL READ_NUMBER            ; Read a number from the user
    MOV [SI], AX                ; Store the number in the array
    ADD SI, 2                   ; Move to the next element (2 bytes per number)
    LOOP INPUT_LOOP

    ; Sort the numbers
    LEA SI, numbers             ; Load the address of the array
    CALL SORT_ARRAY

    ; Display the sorted numbers
    LEA DX, sorted_msg          ; Display sorted message
    MOV AH, 09H
    INT 21H

    LEA SI, numbers             ; Load the address of the array
    MOV CX, count               ; Loop counter for 15 numbers
DISPLAY_LOOP:
    MOV AX, [SI]                ; Load the current number
    push ax
    call printnumber          ; Print the number
    ADD SI, 2                   ; Move to the next element
    MOV AX, [SI]                ; Load the current number
    push ax
    call printnumber          ; Print the number
    ADD SI, 2                   ; Move to the next element
    MOV AX, [SI]                ; Load the current number
    push ax
    call printnumber          ; Print the number
    ADD SI, 2                   ; Move to the next element

    ; Exit the program
    MOV AH, 4CH
    INT 21H

MAIN ENDP

; Subroutine to read a number from the user
READ_NUMBER PROC
    XOR AX, AX                  ; Clear AX
    MOV AH, 01H                 ; Function to read a character
    INT 21H                     ; Read the first digit
    SUB AL, '0'                 ; Convert ASCII to number
    MOV BL, AL                  ; Store in BL
    MOV AH, 01H
    INT 21H                     ; Read the second digit
    SUB AL, '0'
    MOV BH, AL
    MOV AX, BX                  ; Store the full number in AX
    RET
READ_NUMBER ENDP

; Subroutine to print a number
printnumber proc near
    push ax
    push bx
    push cx
    push dx
    push si
    mov bp, sp
    mov ax, [bp + 12]
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
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret 2
printnumber endp

; Subroutine to sort an array (bubble sort)
SORT_ARRAY PROC near
    MOV CX, count               ; Outer loop counter
    DEC CX                      ; CX = n - 1
OUTER_LOOP:
    MOV SI, numbers             ; Start of the array
    MOV DX, CX                  ; Inner loop counter
INNER_LOOP:
    MOV AX, [SI]                ; Load the current element
    MOV BX, [SI+2]              ; Load the next element
    CMP AX, BX                  ; Compare the two
    JLE SKIP_SWAP               ; Skip if already in order
    push bx
    mov bx, ax
    pop ax

    MOV [SI], AX                ; Store the swapped values
    MOV [SI+2], BX
SKIP_SWAP:
    ADD SI, 2                   ; Move to the next pair
    DEC DX                      ; Decrement inner loop counter
    JNZ INNER_LOOP
    DEC CX                      ; Decrement outer loop counter
    JNZ OUTER_LOOP
    RET
SORT_ARRAY ENDP
code_seg ends

END MAIN
