IF !DEF(INC_macros)
INC_macros = 1 


; Wait until LY is a specified value
;
; @param \1 the LY value to wait for
; @destroys af
MACRO wait_ly
.loop\@:
    ldh a, [rLY]
    cp \1
    jr nz, .loop\@
    ENDM


; Waits for vblank (i.e. rLY == $90)
; 
; @destroys af
MACRO wait_vblank
    wait_ly $90
    ENDM


; Wait until VRAM is safe to read/write. STAT mode 0 (H-blank) or 1 (V-blank) 
;
; @destroys af
MACRO wait_vram_accessible
.loop\@:
    ldh a, [rSTAT]
    and STATF_BUSY
    jr nz, .loop\@
    ENDM


; Enable GameBoy Color (CGB) mode
; Sets byte at address $0143 in the header to $80
MACRO enable_cgb_mode
PUSHS
SECTION "cgb-mode", ROM0[$143]
    db $80
POPS
    ENDM


; Genrate a 15-bit colour from 
;
; @param \1 red (0 - 31)
; @param \2 green (0 - 31)
; @param \3 blue (0 - 31)
MACRO rgb
    dw (\1 + (\2 << 5) + \3 << 10)
    ENDM


; Generate some nops
; @param \1 the number of nops to generate
MACRO nops
    REPT \1
    nop
    ENDR
    ENDM


ENDC


