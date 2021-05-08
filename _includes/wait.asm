wait 			lda #100
wait1			cmp $d012
					bne wait1
					inc $d020
					ldx #0
wait2 		inx
					bne wait2
					dec $d020
spacechk	lda $dc01
					cmp #$ef					
					bne wait
					rts