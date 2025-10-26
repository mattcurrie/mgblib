IF !DEF(INC_PrintDecimal)
DEF INC_PrintDecimal = 1

INCLUDE "src/print/PrintCharacter.asm"

; Print an 8-bit number in decimal
;
; @param a number to print
; @destroys all
PrintDecimal::
    ld d, -1
    ld e, a
    cp 10     ; check if value is less than 10 first because we don't want a leading 0
    jr c, .units

    ld b, 100
    cp b
    jr c, .tens

.hundreds_loop:
    inc d
    sub b
    jr nc, .hundreds_loop

    add b     ; add 100 back to value
    ld e, a   ; store value in E
    ld a, "0"
    add d
    call PrintCharacter

    ld d, -1
    ld a, e   ; restore value from E
.tens:
    ld b, 10
.tens_loop:
    inc d
    sub b
    jr nc, .tens_loop

    add b    ; add 10 back to value
    ld e, a
    ld a, "0"
    add d
    call PrintCharacter

.units:
    ld a, "0"
    add e
    call PrintCharacter
    ret

ENDC