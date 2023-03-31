RSSET $D002
DEF wTempMail EQU _RS
DEF wTempMailMessage RB MAIL_MSG_LENGTH
DEF wTempMailMessageEnd RB 1
DEF wTempMailAuthor RB PLAYER_NAME_LENGTH
DEF wTempMailAuthorNationaity RW 1
DEF wTempMailAuthorID RW 1
DEF wTempMailSpecies RB 1
DEF wTempMailType RB 1
DEF wTempMailEnd EQU _RS

DEF CopyMenuData EQU $1C66
DEF CopyWarpData__skip EQU $22D0
DEF CopyName2 EQU $30D9
DEF wScriptStackSize EQU $D43C
DEF hTransferShadowOAM EQU $FF80

DEF MobileBattleRoomConsoleScript__one___BANK EQU $64
DEF MobileBattleRoomConsoleScript__one_ EQU $75F4
DEF FallIntoMapScript__BANK EQU $25
DEF FallIntoMapScript EQU $6C38
DEF LinkReceptionistScript_Trade__Mobile_TrySave__BANK EQU $64
DEF LinkReceptionistScript_Trade__Mobile_TrySave EQU $692B
DEF LinkReceptionistScript_Battle__Mobile_TrySave__BANK EQU $64
DEF LinkReceptionistScript_Battle__Mobile_TrySave EQU $69E6

MACRO dbl
    dbw \1__BANK, \1
ENDM

MACRO pad
rept \1 - @
    db "@"
endr
ENDM

MACRO link_ldhl
    ld h, HIGH(\1)
    ld l, LOW(\1)
ENDM
