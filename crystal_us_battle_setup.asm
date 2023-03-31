INCLUDE "charmap.asm"
INCLUDE "macros/const.asm"
INCLUDE "macros/gfx.asm"
INCLUDE "constants/gfx_constants.asm"
INCLUDE "constants/item_data_constants.asm"
INCLUDE "constants/move_constants.asm"
INCLUDE "constants/text_constants.asm"
INCLUDE "constants/item_constants.asm"

INCLUDE "defs.inc"

SECTION "crystal_us_battle_setup", ROM0
LOAD "crystal_us_battle_setup ram", WRAMX[wTempMail]
Mail:
    db $15, $0A, $C0, $00  ; Set up ACE from RunMobileScript
    ; Generates the following at $CD52:
    ; ld l, $C5
    ; nop
    ; ret nz

    push de
    push bc
    push af

    ld a, $18  ; jr n8
    ldh [hTransferVirtualOAM + 0], a
    ld a, $6B  ; $FFED
    ldh [hTransferVirtualOAM + 1], a

    ld hl, .hook
    ld de, $FFED
    jp CopyMenuData+13  ; CopyBytes bc=$10, pop all regs

.hook
    ld a, $C4
    ld hl, $CD2A
    set 5, [hl]
    db $18, $8c  ; jr $FF82

; wTempMailAuthor
    pad wTempMailAuthor
    db "MBSetup@"

; wTempMailAuthorNationaity
    pad wTempMailAuthorNationaity
    db "@@"  ; Author Nationality
    dw 0  ; Author ID
    db 0  ; Author Species
    db BLUESKY_MAIL  ; Mail Type

    pad wTempMailEnd
ENDL
