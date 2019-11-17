INCLUDE "charmap.asm"
INCLUDE "macros/enum.asm"
INCLUDE "macros/data.asm"
INCLUDE "macros/scripts/maps.asm"
INCLUDE "constants/gfx_constants.asm"
INCLUDE "constants/text_constants.asm"
INCLUDE "constants/item_constants.asm"
INCLUDE "constants/item_data_constants.asm"
INCLUDE "constants/map_constants.asm"

RSSET $D002
wTempMail EQU _RS
wTempMailMessage RB MAIL_MSG_LENGTH
wTempMailMessageEnd RB 1
wTempMailAuthor RB PLAYER_NAME_LENGTH
wTempMailAuthorNationaity RB 2
wTempMailAuthorID RW 1
wTempMailSpecies RB 1
wTempMailType RB 1
wTempMailEnd EQU _RS

wScriptStackSize EQU $D43C

SECTION "crystal_us_trade", ROM0[wTempMail]
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
    ld hl, .warp_dest
    call $22D1  ; CopyWarpData.skip+1

    ld hl, .script_stack
    ld de, wScriptStackSize
    jp $1C73  ; CopyMenuData+13 (CopyBytes bc=$10, pop all regs)

.warp_dest
    map_id MOBILE_TRADE_ROOM

.script_stack
    db 1
    dbw $25, $6C38  ; FallIntoMapScript

rept (wTempMailAuthor - wTempMail) - (@ - Mail)
    db "@"
endr
    db "MT@"

rept (wTempMailAuthorNationaity - wTempMail) - (@ - Mail)
    db "@"
endr
    db "@@"  ; Author Nationality
    dw 0  ; Author ID
    db 0  ; Author Species
    db BLUESKY_MAIL  ; Mail Type

    ds (wTempMailEnd - wTempMail) - (@ - Mail)
