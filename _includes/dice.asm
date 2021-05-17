; very simple rng for now, we should
; regenerate the seed frin SID noise and reuse it for further dice rolls

; lastDice		!byte 0
d6_1					!byte 0
d6_2					!byte 0
d6_3					!byte 0
d6_4					!byte 0
d6_5					!byte 0
d6_6					!byte 0
dCount				!byte 0

genSeed	lda #$ff  ; maximum frequency value
				sta $D40E ; voice 3 frequency low byte
				sta $D40F ; voice 3 frequency high byte
				lda #$80  ; noise waveform, gate bit off
				sta $D412 ; voice 3 control register
				lda $D41B ; get random value
        sta SEED
				rts
				
rollD6	jsr newSeed
				lda SEED				
				and #%00000111 ; 1-8
				sta LASTD6
				inc LASTD6
				lda LASTD6
				cmp #7
				bcs rollD6				
				rts
				
newSeed lda SEED
        beq doEor ;added this
        asl
        bcc noEor
doEor   eor #$1d
noEor   sta SEED
				rts
				