IF !DEF(INC_WaitVBlank)
DEF INC_WaitVBlank = 1

; Wait for Vblank (i.e. rLY = $90). Checks that the screen is not turned off
; to prevent getting stuck in this function.
;
; @destroys af
WaitVBlankIfLCDIsOn::
    ; abort if screen is already off
    ldh a, [rLCDC]
    bit 7, a
    ret z

; Wait for Vblank (i.e. rLY = $90).
;
; @destroys af
WaitVBlank::
    wait_vblank
    ret

ENDC