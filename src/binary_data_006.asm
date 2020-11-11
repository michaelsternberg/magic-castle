;*******************************************************************************
;*                                                                             *
;*                          M A G I C   C A S T L E                            *
;*                                                                             *
;*                                     by                                      *
;*                                                                             *
;*                                 BRUCE MAY                                   *
;*                                                                             *
;*                  for the ATARI 8-bit Home Computer System                   *
;*                                                                             *
;*                            [PAGE 6 BINARY DATA]                             *
;*                                                                             *
;*       Reverse engineered and documented assembly language source code       *
;*                                                                             *
;*                                     by                                      *
;*                                                                             *
;*                             Michael Sternberg                               *
;*                                 (@16kRAM)                                   *
;*                                                                             *
;*                               First Release                                 *
;*                                DD-MMM-YYYY                                  *
;*                                                                             *
;*                                Last Update                                  *
;*                                DD-MMM-YYYY                                  *                                                                       *
;*******************************************************************************
; da65 V2.18 - N/A
; Created:    2020-03-30 22:36:32
; Input file: ../obj/BIN00006.BIN

                .setcpu "6502"

;*******************************************************************************
;*                                                                             *
;*                             M E M O R Y   M A P                             *
;*                                                                             *
;*******************************************************************************
; 0600..06FF    Display Lists and ML/DLI routines
; 8100..815F    Scroll Up ML Routine
; 8160..81FF    Scroll Down ML Routine
; 8200..82FF    Message strings
; 8300..84FF    Void.1 map
; 8500..87FF    Title Screen
; 8800..89FF    Custom Character Set
; 8A00..8FFF    Castle maps
; 9000..9883    Room Name Table
; 9884..99B6    Object Name Table (Friends/Foes/Items)
; 

;*******************************************************************************
;*                                                                             *
;*                         S Y S T E M   S Y M B O L S                         *
;*                                                                             *
;*******************************************************************************
LOMEM           := $00CE
HIMEM           := $00CF
VDSLST          := $0200                        ; Vector for NMI Display List interrupts
SDMCTL          := $022F                        ; DMA enable
SDLSTL          := $0230                        ; Display List start addr (lo)
SDLSTH          := $0231                        ; Display List start addr (hi)

COLOR4          := $02C8                        ; Backgr & border color register

VSCROL          := $D405                        ; Vertical scroll enable
CHBASE          := $D409                        ; Character set base address
WSYNC           := $D40A                        ; Wait for horizontal sync
VCOUNT          := $D40B                        ; Vertical Line Counter

DARK_BLUE       = $90

;EXEHDR:         .byte   $FF,$FF
                .byte   $00,$06
                .byte   $FF,$06                

                .org    $0600
PAGE6:
;*******************************************************************************
;*                                                                             *
;*                                wait_vblank                                  *
;*                                                                             *
;*           Wait until CRT electron gun reaches bottom of screen              *
;*                                                                             *
;*******************************************************************************
                PLA                             ; Pop stack
:               LDA     VCOUNT                  ; Get vertical line counter
                CMP     #192/2                  ; 
                BMI     :-                      ; If less than 192, then loop
                RTS                             ; Otherwise exit.
;*******************************************************************************
;*                                U N U S E D                                  *
;*******************************************************************************
                .byte   $00,$00,$00,$00,$00,$00,$00,$00

;*******************************************************************************
;*                                                                             *
;*                                ???????????                                  *
;*                                                                             *
;*                                  ????????                                   *
;*                                                                             *
;*******************************************************************************
L0611:
                PLA                             ; Pop stack
                ; Wait for vblank
:               LDA     VCOUNT                  ; Get vertical line counter 
                CMP     #192/2                  ; 
                BMI     :-                      ; If less than 192, then loop

                PLA                             ; Pop
                PLA                             ; 
                STA     VSCROL                  ; Change Vertical Scroll Enable
                PLA                             ; 
                STA     L0685                   ; Change Display list entry
                PLA                             ; 
                STA     L0684                   ; Change Display list entry
                RTS                             ; Done

;*******************************************************************************
;*                                                                             *
;*                                  ???????                                    *
;*                                                                             *
;*                                 ?????????                                   *
;*                                                                             *
;*******************************************************************************
L0627:
                PLA                             ; 0627 68                       h

                PLA                             ; 0628 68                       h
                STA     $D0                     ; 0629 85 D0                    ..

                PLA                             ; 062B 68                       h
                STA     $CF                     ; 062C 85 CF                    ..

                PLA                             ; 062E 68                       h
                STA     $CE                     ; 062F 85 CE                    ..

                PLA                             ; 0631 68                       h
                STA     $CD                     ; 0632 85 CD                    ..

                PLA                             ; 0634 68                       h
                STA     $CC                     ; 0635 85 CC                    ..

                PLA                             ; 0637 68                       h
                SEC                             ; 0638 38                       8
                SBC     #$01                    ; 0639 E9 01                    ..
                STA     $CB                     ; 063B 85 CB                    ..

L063D:          LDA     ($CF),Y                 ; 063D B1 CF                    ..
                STA     ($CD),Y                 ; 063F 91 CD                    ..
                INY                             ; 0641 C8                       .
                BNE     :+                      ; 0642 D0 0E                    ..

                LDA     $CE                     ; 0644 A5 CE                    ..
                CLC                             ; 0646 18                       .
                ADC     #$01                    ; 0647 69 01                    i.
                STA     $CE                     ; 0649 85 CE                    ..

                LDA     $D0                     ; 064B A5 D0                    ..
                CLC                             ; 064D 18                       .
                ADC     #$01                    ; 064E 69 01                    i.
                STA     $D0                     ; 0650 85 D0                    ..

:               LDA     $CB                     ; 0652 A5 CB                    ..
                CMP     #$00                    ; 0654 C9 00                    ..
                BNE     :+                      ; 0656 D0 11                    ..
                SEC                             ; 0658 38                       8
                SBC     #$01                    ; 0659 E9 01                    ..
                STA     $CB                     ; 065B 85 CB                    ..

                LDA     $CC                     ; 065D A5 CC                    ..
                CMP     #$00                    ; 065F C9 00                    ..
                BNE     :++                     ; 0661 D0 0E                    ..
                LDA     $CB                     ; 0663 A5 CB                    ..
                CMP     #$FF                    ; 0665 C9 FF                    ..
                BEQ     L0679                   ; 0667 F0 10                    ..

:               SEC                             ; 0669 38                       8
                SBC     #$01                    ; 066A E9 01                    ..
                STA     $CB                     ; 066C 85 CB                    ..

                JMP     L063D                   ; 066E 4C 3D 06                 L=.

:               SEC                             ; 0671 38                       8
                SBC     #$01                    ; 0672 E9 01                    ..
                STA     $CC                     ; 0674 85 CC                    ..
                JMP     L063D                   ; 0676 4C 3D 06                 L=.

L0679:          RTS                             ; 0679 60                       `

;*******************************************************************************
;*                                U N U S E D                                  *
;*******************************************************************************
;L067A
                .byte   $00,$00,$00,$00,$00,$00

;*******************************************************************************
;*                     G A M E   D I S P L A Y   L I S T                       *
;*******************************************************************************
;DLIST1:
DL_GAME:
L0680:
                .byte   $70,$70,$70             ; 3x8 BLANK
                .byte   $67                     ; VSCROL MODE 7
L0684:          .byte   $E0                     ; DLI 7 BLANK       0684 E0                       .
L0685:          .byte   $8B                     ; DLI MODE b        0685 8B                       .
                .byte   $27,$27,$27,$27         ; 8xSCROLL MODE 7
                .byte   $27,$27,$27,$27
                .byte   $07                     ; MODE 7            068E 07                       .
                .byte   $C7                     ; DLI MODE 7        068F C7                       .
                .byte   $6C                     ; VSCROLL MODE c
                .byte   $9B                     ; DLI HSCROLL MODE b
                .byte   $42,$60,$9F             ; LMS $9F60 MODE 2
                .byte   $02,$02,$02             ; 3xMODE 2
                .byte   $41,$80,$06             ; JVB DL_GAME ($0680)

;*******************************************************************************
;*                                                                             *
;*                           Display List Interrupt                            *
;*                                                                             *
;*                                                                             *
;*                                                                             *
;*******************************************************************************
;L069B
DLI:
                PHA                             ; Stash A before trashing it 
                LDA     #$E0                    ; E0 -> Default char set in ROM
                STA     WSYNC                   ; Wait for horizontal sync
                STA     CHBASE                  ; Set character set to default
                PLA                             ; Restore A
                RTI                             ; Done

;*******************************************************************************
;*                                U N U S E D                                  *
;*******************************************************************************
                .byte   $00,$00,$00

;*******************************************************************************
;*                   T I T L E    D I S P L A Y   L I S T                      *
;*******************************************************************************
;L06A9
;DLIST2:
DL_TITLE:
                .byte   $70,$70,$70             ; 3x8 BLANK
                .byte   $47,$00,$85             ; LMS $8500 MODE 7
                .byte   $07,$07,$07,$07,$07     ; 5xMODE 7
                .byte   $02,$02,$02,$02,$02,$02 ; 12xMODE 2
                .byte   $02,$02,$02,$02,$02,$02
                .byte   $41,$A9,$06             ; JVB DL_TITLE ($06A9)

;*******************************************************************************
;*                                U N U S E D                                  *
;*******************************************************************************
;L06C3
                .byte   $00,$00,$00,$00,$00,$00,$00,$00
                .byte   $00,$00,$00,$00,$00,$00

;*******************************************************************************
;*                                                                             *
;*                                  loadngo                                    *
;*                                                                             *
;*                      Set display list for Title Page                        *
;*                                                                             *
;*******************************************************************************
;L06D1
                LDA     #$00                    ; Disable DMA to video (ANTIC)
                STA     SDMCTL                  ; 

                LDA     #<DL_TITLE              ; Point to Title Screen Display
                STA     SDLSTL                  ; List

                LDA     #>DL_TITLE              ; 
                STA     SDLSTH                  ; 

                LDA     #<DLI                   ; Point to Display List Interrupt
                STA     VDSLST                  ; routine

                LDA     #>DLI                   ; 
                STA     VDSLST+1                ; 

                LDA     #$22                    ; Re-enable DMA to video (ANTIC)
                STA     SDMCTL                  ; & set playfield to std width

                LDA     #DARK_BLUE + $05        ; Set playfield background
                STA     COLOR4                  ; to blue

                RTS                             ; 06F4 60                       `

;*******************************************************************************
;*                                U N U S E D                                  *
;*******************************************************************************
                .byte   $00,$00,$00,$00,$00,$00,$00,$00
                .byte   $00,$00,$00
;L0700
