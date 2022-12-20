IF !DEF(INC_LCDC)
INC_LCDC = 1

INCLUDE "src/display/WaitVBlank.asm"

; Turns the LCD on
;
; @destroys hl
MACRO lcd_on
    ld hl, rLCDC
    set 7, [hl]
    ENDM


; Turns the LCD off. Does NOT wait until Vblank
;
; @destroys hl
MACRO lcd_off_unsafe
    ld hl, rLCDC
    res 7, [hl]
    ENDM


; Turns off the LCD.
; If the LCD is already disabled then there is no operation.
; If the LCD is enabled then waits until VBlank.
;
; @destroys a, hl
LcdOffSafe::
    ; return if the screen is already off
    ld hl, rLCDC
    bit 7, [hl]
    ret z

    ; wait for vblank first before turning off
    call WaitVBlank

    res 7, [hl]
    ret


; Sets the window map to be read from $9800-$9bff
;
; @destroys hl
MACRO win_map_9800
    ld hl, rLCDC
    res 6, [hl]
    ENDM
    

; Sets the window map to be read from $9c00-$9fff
;
; @destroys hl
MACRO win_map_9c00
    ld hl, rLCDC
    set 6, [hl]
    ENDM


; Disables the window
;
; @destroys hl
MACRO disable_window
    ld hl, rLCDC
    res 5, [hl]
    ENDM


; Enables the window
;
; @destroys hl
MACRO enable_window
    ld hl, rLCDC
    set 5, [hl]
    ENDM


; Set the background and window to access the 
; $8800-$97ff region for tile data.
;
; @destroys hl
MACRO bg_tile_data_8800
    ld hl, rLCDC
    res 4, [hl]
    ENDM


; Set the background and window to access the 
; $8000-$8fff region (same as sprites) for tile data.
;
; @destroys hl
MACRO bg_tile_data_8000
    ld hl, rLCDC
    set 4, [hl]
    ENDM


; Set the background map to be read from $9800-$9bff
;
; @destroys hl
MACRO bg_map_9800
    ld hl, rLCDC
    res 3, [hl]
    ENDM


; Set the background map to be read from $9c00-$9fff
;
; @destroys hl
MACRO bg_map_9c00
    ld hl, rLCDC
    set 3, [hl]
    ENDM


; Set the sprite height to 8 pixels 
;
; @destroys hl
MACRO sprite_height_8px
    ld hl, rLCDC
    res 2, [hl]
    ENDM


; Set the sprite size to 8x16 pixels 
;
; @destroys hl
MACRO sprite_height_16px
    ld hl, rLCDC
    set 2, [hl]
    ENDM


; Disable sprites
;
; @destroys hl
MACRO disable_sprites
    ld hl, rLCDC
    res 1, [hl]
    ENDM


; Enable sprites
;
; @destroys hl
MACRO enable_sprites
    ld hl, rLCDC
    set 1, [hl]
    ENDM


; Disable background (non-CGB only)
;
; @destroys hl
MACRO disable_bg
    ld hl, rLCDC
    res 0, [hl]
    ENDM


; Enable background (non-CGB only)
;
; @destroys hl
MACRO enable_bg
    ld hl, rLCDC
    set 0, [hl]
    ENDM


ENDC