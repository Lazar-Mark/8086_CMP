org 100h 
; enter decimal
lea DX,string_enter_decimal
mov AH,09
int 21h
mov CX, 0
enter_decimal_loop:

    mov AH,01h
    int 21h
    cmp AL,13
    je enter_decimal_done
    sub AL,30h
    inc CX
    mov AH, 0
    push AX
    jmp enter_decimal_loop
 
enter_decimal_done: 
; base-10 number entered
; check how many digits it has and push them onto the stack one by one, then retrieve them and reconstruct the number
; same principle with the hex number
    
    cmp CX, 1
    je dec_one_digit
    cmp CX, 2
    je dec_two_digits
    cmp CX, 3
    je dec_three_digits
    cmp CX, 4
    je dec_four_digits
    cmp CX, 5
    jge dec_five_digits

dec_one_digit:
    pop DX
    mov a, DX
    jmp enter_hex
    
dec_two_digits:
    pop DX
    pop AX
    mul byte_ten
    add DX, AX
    mov a, DX   
    jmp enter_hex

dec_three_digits:
    pop DX
    pop AX
    mul byte_ten
    add DX, AX
    pop AX
    mul byte_ten
    mul byte_ten
    add DX, AX
    mov a, DX   
    jmp enter_hex

dec_four_digits:
    pop DX
    pop AX
    mul byte_ten
    add DX, AX
    pop AX
    mul byte_ten
    mul byte_ten
    add DX, AX
    pop AX
    mul byte_ten
    mul byte_ten
    mul word_ten
    add BX, AX
    mov a, BX
    jmp enter_hex
    
dec_five_digits:
    pop BX
    pop AX
    mul byte_ten
    add BX, AX
    pop AX
    mul byte_ten
    mul byte_ten
    add BX, AX
    pop AX
    mul byte_ten
    mul byte_ten
    mul word_ten
    add BX, AX
    pop AX
    mul byte_ten
    mul byte_ten
    mul word_ten
    mul word_ten
    add BX, AX
    mov a, BX
    jmp enter_hex
    

enter_hex:   
    mov AH, 02h
    mov DL, 10
    int 21h
    mov DL, 13
    int 21h
    lea DX, string_enter_hex
    mov AH,09h
    int 21h
    mov CX, 0; reset the counter

enter_hex_loop: 
    mov AH,01h
    int 21h
    cmp AL,13
    je after
    cmp AL,39h
    jle is_number
    jg is_not_number

is_number:
    inc CX   
    sub AL,30h
    mov AH,0; reset AH so I can push properly
    push AX

    jmp enter_hex_loop

is_not_number:
    CALL parse_letter
    inc CX   
    mov AH,0
    push AX

    jmp enter_hex_loop

after:

    ; the hex number is entered, its digits are on the stack in reverse order
    
    cmp CX, 1
    je hex_one_digit
    cmp CX, 2
    je hex_two_digits
    cmp CX, 3
    je hex_three_digits
    cmp CX, 4
    jge hex_four_digits

hex_one_digit:
    pop DX
    mov b, DX
    jmp done
    
hex_two_digits:
    pop DX
    pop AX
    mul byte_sixteen
    add DX, AX
    mov b, DX
    jmp done

hex_three_digits:
    pop DX
    pop AX
    mul byte_sixteen
    add DX, AX
    pop AX
    mul byte_sixteen
    mul byte_sixteen
    add DX, AX
    mov b, DX
    jmp done

hex_four_digits:
    pop BX
    pop AX
    mul byte_sixteen
    add BX, AX
    pop AX
    mul byte_sixteen
    mul byte_sixteen
    add BX, AX
    pop AX
    mul byte_sixteen
    mul byte_sixteen
    mul word_sixteen
    add BX, AX
    mov b, BX
    jmp done
    
done:
    mov BX, a
    mov CX, b
    mov AH, 2
    mov DL, 10
    int 21h
    mov DL, 13
    int 21h
        
check_value:

    cmp BX, CX
    je equal
    jne not_equal

equal:
    mov AH, 9
    lea DX, string_equal
    int 21h
    ret
    
not_equal: 
    mov AH, 9
    lea DX, string_not_equal
    int 21h
    

   ret


a DW 0
b DW 0
string_equal DB "The numbers are equal $" 
string_not_equal DB "The numbers are not equal $"

string_enter_decimal DB "Enter a base-10 number: $"
string_enter_hex DB "Enter a hexadecimal number: $"
byte_sixteen DB 16
word_sixteen DW 16
byte_ten DB 10
word_ten DW 10

parse_letter proc

cmp AL,"a" 
  je ten
cmp AL,"A"
  je ten
cmp AL,"b"
  je eleven
cmp AL,"B"
  je eleven
cmp AL,"c"
  je twelve
cmp AL,"C"
  je twelve
cmp AL,"d"
  je thirteen
cmp AL,"D"
  je thirteen
cmp AL,"e"
  je fourteen
cmp AL,"E"
  je fourteen
cmp AL,"f"
  je fifteen
cmp AL,"F"
  je fifteen

 ret
ten:
 mov AL,10 
 ret
eleven:
 mov AL,11
 ret
twelve:
 mov AL,12
 ret
thirteen:
 mov AL,13
 ret
fourteen:
 mov AL,14
 ret
fifteen:
 mov AL,15
 ret
