; this lib contains our dice roll and rpg calculation routines
;

; lastDice		!byte 0
d6_1					!byte 0
d6_2					!byte 0
d6_3					!byte 0
d6_4					!byte 0
d6_5					!byte 0
d6_6					!byte 0
dCount				!byte 0

; very simple rng for now, we should
genSeed			lda #$ff  ; maximum frequency value
						sta $D40E ; voice 3 frequency low byte
						sta $D40F ; voice 3 frequency high byte
						lda #$80  ; noise waveform, gate bit off
						sta $D412 ; voice 3 control register
						lda $D41B ; get random value
        		sta SEED
						rts
				
rollD6			jsr genSeed
						lda SEED				
						and #%00000111 ; 1-8
						sta LASTD6
						inc LASTD6
						lda LASTD6
						cmp #7
						bcs rollD6				
						rts

rollSuccess	lda #0						; zero out the
						sta SUCCESSROLL		; last SUCCESSROLL
						ldx #3						; we need 3d6
-						jsr rollD6
						lda SUCCESSROLL
						clc
						adc LASTD6
						sta SUCCESSROLL
						dex
						bne -
						rts
					
!zone skill
; get and calc skill - uses SKILLPRT as pointer and writes the SL to y
getSL			  ldy #2					 			; first we load the attribute value for the skill
						lda (LOB_SKILLPTR),y  ; to x
						cmp #STR					
						bne +
				   	ldx pSTR
						jmp ++
+						cmp #DEX
						bne +
						ldx pDEX
						jmp ++
+						cmp #INT
						bne +++					 ; if your skill is no STR,DEX or INT we exit routine
						ldx pINT
						
++					dey					
						lda (LOB_SKILLPTR),y ; load skill Pts
					  cmp #0
						bne +
						txa							 ; write attr value to a
						sbc #5					 ; if no point is spend the skill is defaulted = -5 Attr							
						dey							 ; set y to 0
						sta (LOB_SKILLPTR),y ; write back the SL
						rts					 ; -> rts					

+						cmp #1
						bne +
						dex							 ; SL = ATTR-1
						txa							 ; store back to a
						dey
						sta (LOB_SKILLPTR),y ; and write back the SL
						rts					 		 ; -> rts

+						cmp #2
						bne +
						txa							 ; 2 Pts = ATTR store ATTR to a
						dey
						sta (LOB_SKILLPTR),y ; and write back the SL
						rts					 		 ; -> rts		
		
+						cmp #4
						bcc +++
						
						stx COUNT
-						lsr
						lsr								; divide by 4 (2x log. shift right)
						clc
						adc COUNT							
						
						dey
						sta (LOB_SKILLPTR),y ; and write back the SL					
						
+
+++					rts											
						
newSeed 		lda SEED
        		beq doEor 			;added this
        		asl
        		bcc noEor
doEor   		eor #$1d
noEor   		sta SEED
						rts
				