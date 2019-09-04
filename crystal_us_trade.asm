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

SECTION "crystal_us_trade", ROM0[wTempMail]
Mail:
    db $15, $0A, $C0, $00  ; Set up ACE from RunMobileScript
    ; Generates the following at $CD52:
    ; ld l, $C5
    ; nop
    ; ret nz

    ld a, 1
    ld c, a
    ld hl, .warp_dest
    call $22D1  ; CopyWarpData.skip+1
    ld a, $25
    ld hl, $6C38  ; FallIntoMapScript
    call $261F  ; CallScript
    pop hl
    ret

.warp_dest
    map_id MOBILE_TRADE_ROOM

.end_message
rept (wTempMailAuthor - wTempMail) - (Mail.end_message - Mail)
    db "@"
endr

    db "REON Trade"

.end_author
;rept (wTempMailAuthorNationaity - wTempMail) - (Mail.end_author - Mail)
    ;db "@"
;endr
    ;db "@@"  ; Author Nationality
rept (wTempMailAuthorID - wTempMail) - (Mail.end_author - Mail)
    db "@"
endr

    dw 0  ; Author ID
    db 0  ; Author Species
    db BLUESKY_MAIL  ; Mail Type
