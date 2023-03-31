INCLUDE "charmap.asm"
INCLUDE "macros/data.asm"
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
    ; ret
    ; ret nz

    di

    ld a, $18  ; jr n8
    ldh [hTransferShadowOAM + 0], a
    ld a, hook_ram - (hTransferShadowOAM + 2)
    ldh [hTransferShadowOAM + 1], a

    ld h, e  ; $FF
    ld l, LOW(hook_ram)
    ld de, .hook

    add $21 - (hook_ram - (hTransferShadowOAM + 2)) ; load $21 into a
    ld [hli], a  ; write "ld hl, n16" instruction
    jr .code2

; code to jump to from hTransferShadowOAM
.hook
    ; fix this value in ram
    dw $CD2A  ; Fixed into ld hl, n16 opcode
    set 5, [hl]

    ; return to hooked code
    ld a, $C4  ; patched code
    db $18  ; jr n8
    db hTransferShadowOAM + 2 - ((@ + 1) - .hook + hook_ram + 1)

    db "@"

; wTempMailAuthor
    pad wTempMailAuthor
    db "MBSetup@"

.code2
    call CopyName2
    dec de
    reti

; wTempMailType
    pad wTempMailType
    db BLUESKY_MAIL  ; Mail Type

    pad wTempMailEnd
ENDL
