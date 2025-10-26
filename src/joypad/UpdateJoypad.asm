IF !DEF(INC_UpdateJoypad)
DEF INC_UpdateJoypad = 1

INCLUDE "src/macros.asm"

PUSHS
SECTION "joypad", HRAM

hJoypad::
    DS 1

hJoypad2::
    DS 1

POPS

; Read the joypad state and update the value stored in hJoypad
; 
; @return a the joypad state
; @destroys af, bc
UpdateJoypad::
    ; select direction keys
    ld a, $20                    
    ldh [rP1], a           

    ldh a, [rP1]
    ldh a, [rP1]
    cpl              
    and $0f          
    swap a      
    ld b, a           

    ; select buttons
    ld a, $10         
    ldh [rP1], a 
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    cpl              
    and $0f    

    or b             
    ld c, a

    ; de-select input lines
    ld a,$30         
    ldh [rP1],a 

    ldh a, [hJoypad]
    xor c            
    and c            
    ldh [hJoypad2], a     
    ld a, c           
    ldh [hJoypad], a     

    ret


ENDC
