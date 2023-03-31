INCLUDE "charmap.asm"
INCLUDE "macros/const.asm"
INCLUDE "macros/data.asm"
INCLUDE "macros/gfx.asm"
INCLUDE "macros/scripts/maps.asm"
INCLUDE "constants/gfx_constants.asm"
INCLUDE "constants/item_data_constants.asm"
INCLUDE "constants/map_constants.asm"
INCLUDE "constants/move_constants.asm"
INCLUDE "constants/text_constants.asm"
INCLUDE "constants/item_constants.asm"

INCLUDE "defs.inc"

SECTION "crystal_us_trade", ROM0
LOAD "crystal_us_trade ram", WRAMX[wTempMail]
Mail:
    db $15, $0A, $C0, $00  ; Set up ACE from RunMobileScript
    ; Generates the following at $CD52:
    ; ld l, $C5
    ; nop
    ; ret nz

    push de
    push bc
    push af

    ld a, 1
    ld c, a
    link_ldhl .warp_dest
    call CopyWarpData__skip+1

    link_ldhl .script_stack
    ld de, wScriptStackSize
    jp CopyMenuData+13 ; CopyBytes bc=$10, pop all regs

.warp_dest
    map_id MOBILE_TRADE_ROOM

.script_stack
    db 1
    dbl FallIntoMapScript

; wTempMailAuthor
    pad wTempMailAuthor
    db "MT@"

; wTempMailAuthorNationaity
    pad wTempMailAuthorNationaity
    db "@@"  ; Author Nationality
    dw 0  ; Author ID
    db 0  ; Author Species
    db BLUESKY_MAIL  ; Mail Type

    pad wTempMailEnd
ENDL
