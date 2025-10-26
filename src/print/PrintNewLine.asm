IF !DEF(INC_PrintNewLine)
DEF INC_PrintNewLine = 1

INCLUDE "src/macros.asm"

PUSHS
SECTION "print_cursor", WRAM0

wPrintCursorAddress::
    DS 2

wPrintScrolling::
    DS 1

POPS

; Advance cursor to point to the start of a new line
; 
; @destroys af, bc, hl
PrintNewLine::
    ld hl, wPrintCursorAddress
    ld a, [hl]
    or (32 - 1)
    inc a
    ld [hl], a

    ; check for zero flag because carry is not set by `inc a`
    jr nz, .scroll_check

    ; LSB overflowed so need to increment MSB
    inc hl
    inc [hl]
    ld a, [hl]

    ; check if we need to wrap around
    cp $9c
    jr z, .wrap_around  
    cp $a0
    jr nz, .no_wrap
.wrap_around::
    sub 4
    ld [hl], a

.no_wrap::
    ; restore hl's value to wPrintCursorAddress
    dec hl

.scroll_check:
    ld a, [wPrintScrolling]
    or a
    jr nz, .scrolling

    ; check if need to start scrolling yet
    ld hl, wPrintCursorAddress + 1
    ld a, [hl-]
    and 3     ; $9a & 3 == 2, $9e & 3 == 2. we scroll at $9a60 and $9e60
    cp 2
    ret nz

    ld a, [hl]
    cp $60
    ret nz

    ; reached $9a60/$9e60, so set wPrintScrolling to 1
    ld a, 1
    ld [wPrintScrolling], a

    
.scrolling:
    ; expects HL = wPrintCursorAddress

    ; load address from wPrintCursorAddress
    ld a, [hl+]
    ld h, [hl]
    ld l, a

    ; erase the next line with spaces
    ld c, 20
    ld b, " "   ; use B because wait_vram_accessible destroys A

.erase_loop:
    wait_vram_accessible
    ld [hl], b
    inc hl
    dec c
    jr nz, .erase_loop

    ; scroll up the new blank line into view
    ldh a, [rSCY]
    add 8
    ldh [rSCY], a

    ret

ENDC