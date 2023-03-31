INCLUDE "charmap.asm"
INCLUDE "macros/const.asm"
INCLUDE "macros/gfx.asm"
INCLUDE "constants/gfx_constants.asm"
INCLUDE "constants/item_data_constants.asm"
INCLUDE "constants/move_constants.asm"
INCLUDE "constants/text_constants.asm"
INCLUDE "constants/item_constants.asm"

INCLUDE "defs.inc"

DEF hook_ram EQU $FFED

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
    ld a, hook_ram - (hTransferVirtualOAM + 2)
    ldh [hTransferVirtualOAM + 1], a

    ld hl, .hook
    ld de, hook_ram
    jp CopyMenuData+13  ; CopyBytes bc=$10, pop all regs

.hook
    ; fix this value in ram
    ld hl, $CD2A
    set 5, [hl]

    ; return to hooked code
    ld a, $C4  ; patched code
    db $18  ; jr n8
    db hTransferVirtualOAM + 2 - (hook_ram + (@ - .hook) + 1)

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
