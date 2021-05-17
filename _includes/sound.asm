; sfx					
				
playSfx  lda #$0d
         sta SID_VOLUME

         lda #$22
         sta SID_VOICE1_ATACK_DECAY
         lda #$03
         sta SID_VOICE1_SUSTAIN_RELEASE

         lda #$1a
         sta SID_VOICE1_FREQ_MSB
         lda #$ff
         sta SID_VOICE1_FREQ_LSB

         lda #SID_WAVE_WHITENOISE
         sta SID_VOICE1_WAVEFORM
				 rts					
			
stopSidV1 ldx #$00            ; Ton abschalten
         	stx SID_VOICE1_WAVEFORM
         	stx SID_VOICE1_ATACK_DECAY
         	stx SID_VOICE1_SUSTAIN_RELEASE
         	rts	
