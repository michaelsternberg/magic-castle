        .setcpu "6502"

SDMCTL          := $022F                        ; DMA enable

start:
; Disable ANTIC until TITLE SCREEN is loaded (see patch_antic_on.asm)
        .byte   $FF,$FF
        .byte   <SDMCTL,>SDMCTL
        .byte   <SDMCTL,>SDMCTL
        .byte   $00
