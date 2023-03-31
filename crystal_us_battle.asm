INCLUDE "charmap.asm"
INCLUDE "macros/const.asm"
INCLUDE "macros/data.asm"
INCLUDE "macros/gfx.asm"
INCLUDE "macros/scripts/maps.asm"
INCLUDE "constants/gfx_constants.asm"
INCLUDE "constants/item_data_constants.asm"
INCLUDE "constants/map_constants.asm"
INCLUDE "constants/text_constants.asm"
INCLUDE "constants/move_constants.asm"
INCLUDE "constants/item_constants.asm"

INCLUDE "defs.inc"

SECTION "crystal_us_battle", ROM0
LOAD "crystal_us_battle ram", WRAMX[wTempMail]
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
    link_ldhl .warp_dest
    call CopyWarpData__skip+1

    link_ldhl .script_stack
    ld de, wScriptStackSize
    jp CopyMenuData+13  ; CopyBytes bc=$10, pop all regs

.warp_dest
    map_id MOBILE_BATTLE_ROOM

; wTempMailAuthor
    pad wTempMailAuthor
    db "MB@"

.script_stack
    db 3
    ; Abuse jumps to stop the script if game was not saved,
    ;  start mobile battle otherwise (select three mon, etc etc).
    ;dbw $64, $75E6  ; MobileBattleRoomConsoleScript+12
    dbl MobileBattleRoomConsoleScript__one_

    ; Invert wScriptVar (yes we doing script ROP now, who'd'a thunk)
    ;dbw $64, $6a08  ; LinkReceptionistScript_Battle.SelectThreeMons+3

    ; Get into the room (not entirely required but uses proper palettes for textboxes)
    dbl FallIntoMapScript

    ; Save the game, set up the required environment to battle (including wLinkMode)
    dbl LinkReceptionistScript_Battle__Mobile_TrySave

; wTempMailType
    pad wTempMailType
    db BLUESKY_MAIL  ; Mail Type

    pad wTempMailEnd
ENDL
