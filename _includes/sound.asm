;*=$0801
;; Diese Programm spielt solange einen Ton, bis eine Taste gedrückt wird.
;; Programmstart mit SYS 49152
;!basic $80d
;   ; Startadresse des Programms
;
GETIN          = $ffe4
                          ; SID-Register: (Stimme 1)
ST1_FREQ_L     = $d400    ; Frequenz (High- und Low-Byte)
ST1_FREQ_H     = $d401
ST1_WELLENFORM = $d404    ; Wellenform
ST1_ANSCHLAG   = $d405    ; Anschlag ($0. hart   - $f. weich) ; Abschwellen ($.0 hart    - $.f weich)
ST1_HALTEN     = $d406    ; Halten   ($0. stumm  - $f. laut)  ; Ausklingen  ($.0 schnell - $.f langsam)
LAUTST         = $d418    ; Bit 0-3 = Lautstärke ($00 stumm ... $0f laut)

DREIECK        = $11
SAEGEZAHN      = $21
RECHTECK       = $41
RAUSCHEN       = $81


eingabe  jsr GETIN				
         beq eingabe         ; warte auf Tastendruck
				 jsr playSfx
				 jsr playSfx
				 ;jsr soundOff
				 jmp eingabe
				
				
soundOff ldx #$00            ; Ton abschalten
         stx ST1_WELLENFORM
         stx ST1_ANSCHLAG
         stx ST1_HALTEN
         rts
				
				
playSfx  lda #$0d            ; Tonerzeugung
         sta LAUTST

         lda #$22
         sta ST1_ANSCHLAG
         lda #$03
         sta ST1_HALTEN

         lda #$1a
         sta ST1_FREQ_H
         lda #$ff
         sta ST1_FREQ_L

         lda #RAUSCHEN
         sta ST1_WELLENFORM
				 rts				