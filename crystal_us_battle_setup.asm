INCLUDE "charmap.asm"
INCLUDE "macros/enum.asm"
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

hTransferVirtualOAM EQU $FF80

SECTION "crystal_us_battle_setup", ROM0[wTempMail]
Mail:
    db $15, $0A, $C0, $00  ; Set up ACE from RunMobileScript
    ; Generates the following at $CD52:
    ; ld l, $C5
    ; nop
    ; ret nz

    push de
    push bc
    push af

    ld a, $18
    ldh [hTransferVirtualOAM + 0], a
    ld a, $6B
    ldh [hTransferVirtualOAM + 1], a

    ld hl, .hook
    ld de, $FFED
    jp $1C73  ; CopyMenuData+13 (CopyBytes bc=$10, pop all regs)

.hook
    ld a, $C4
    ld hl, $CD2A
    set 5, [hl]
    db $18, $8c  ; jr $FF82

rept (wTempMailAuthor - wTempMail) - (@ - Mail)
    db "@"
endr
    db "MBSetup@"

rept (wTempMailAuthorNationaity - wTempMail) - (@ - Mail)
    db "@"
endr
    db "@@"  ; Author Nationality
    dw 0  ; Author ID
    db 0  ; Author Species
    db BLUESKY_MAIL  ; Mail Type

    ds (wTempMailEnd - wTempMail) - (@ - Mail)
