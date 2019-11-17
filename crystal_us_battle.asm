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

SECTION "crystal_us_battle", ROM0[wTempMail]
Mail:
    db $15, $0A, $C0, $00  ; Set up ACE from RunMobileScript
    ; Generates the following at $CD52:
    ; ld l, $C5
    ; nop
    ; ret nz

    push de
    push bc
    push af

    ; Set up the warp
    ld a, 1  ; Dest warp ID
    ld c, a
    ld hl, .warp_dest
    call $22D1  ; CopyWarpData.skip+1

    ld hl, .script_stack
    ld de, wScriptStackSize
    jp $1C73  ; CopyMenuData+13 (CopyBytes bc=$10, pop all regs)

.warp_dest
    map_id MOBILE_BATTLE_ROOM

rept (wTempMailAuthor - wTempMail) - (@ - Mail)
    db "@"
endr
    db "MB@"

.script_stack
    db 3
    ; Abuse jumps to stop the script if game was not saved,
    ;  start mobile battle otherwise (select three mon, etc etc).
    ;dbw $64, $75E6  ; MobileBattleRoomConsoleScript+12
    dbw $64, $75f4  ; MobileBattleRoomConsoleScript.one_

    ; Invert wScriptVar (yes we doing script ROP now, who'd'a thunk)
    ;dbw $64, $6a08  ; LinkReceptionistScript_Battle.SelectThreeMons+3

    ; Get into the room (not entirely required but uses proper palettes for textboxes)
    dbw $25, $6C38  ; FallIntoMapScript

    ; Save the game, set up the required environment to battle (including wLinkMode)
    dbw $64, $69E6  ; LinkReceptionistScript_Battle.Mobile_TrySave

;rept (wTempMailAuthorNationaity - wTempMail) - (@ - Mail)
    ;db "@"
;endr
    ;db "@@"  ; Author Nationality
    ;dw 0  ; Author ID
    ;db 0  ; Author Species

rept (wTempMailType - wTempMail) - (@ - Mail)
    db "@"
endr
    db BLUESKY_MAIL  ; Mail Type

    ds (wTempMailEnd - wTempMail) - (@ - Mail)
