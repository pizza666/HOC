!source "_includes\system_const.asm"
!source "_includes\const_scrcodes.asm"
*=$801
!basic main

!zone constants
; fov vector
FOVCOUNTER			= $02
FOVLO						= $05
FOVHI						= $06


; Zero Pages
LOB_DATA				= $40		; data lobyte in ZP
HIB_DATA				= $41   ; data hibyte in ZP
LOB_SCREEN			= $fb 	; screen/color lobyte in ZP
HIB_SCREEN			= $fc   ; screen/color hibyte in ZP
CHARDATA_W			= $a7   ; data width in ZP
CHARDATA_H			= $a8   ; data hight in ZP

; TODO we could store px py pd here

; ui const
UIWIDTH					= 40
UIHIGHT					= 25
UIPOS						= SCREEN
UICPOS					= SCREENCOLOR

; map const
MAPWIDTH				= 17
MAPHIGHT				= 11
W							  = $d6		;normal wall
S								= $20		;normal floor/sky (space)
MAPOFFSET				= $b5		
MAPPOS 					= SCREEN+MAPOFFSET
MAPCOLOR				= SCREENCOLOR+MAPOFFSET
NORTH						= %10001000 ; $88 - 136
EAST						= %01000100 ; $44 - 68
SOUTH						= %00100010 ; $22 - 34
WEST						= %00010001 ; $11 - 17
ICON_NORTH			= 28
ICON_EAST				= 29
ICON_SOUTH			= 30
ICON_WEST				= 31

; compass
COMPASSPOS			= SCREEN+$2e2
COMPASSNORTH		= SCREEN+$293
COMPASSEAST			= SCREEN+$30e
COMPASSSOUTH		= SCREEN+$3ab
COMPASSWEST			= SCREEN+$308

; wall offsets
W0POS						= SCREEN+$29
W0CPOS					= SCREENCOLOR+$29
W1POS 					= SCREEN+$51
W1CPOS 					= SCREENCOLOR+$51
W2POS 					= SCREEN+$c9
W2CPOS 					= SCREENCOLOR+$c9
W3POS						= SCREEN+$119
W3CPOS					= SCREENCOLOR+$119
E0POS						= SCREEN+$3a
E0CPOS					= SCREENCOLOR+$3a
E1POS 					= SCREEN+$5f
E1CPOS 					= SCREENCOLOR+$5f
E2POS						= SCREEN+$d5
E2CPOS				  = SCREENCOLOR+$d5
E3POS 						= SCREEN+$125
E3CPOS 					= SCREENCOLOR+$125
N1POS						= SCREEN+$52
N1CPOS					= SCREENCOLOR+$52
N2POS						= SCREEN+$cd
N2CPOS					= SCREENCOLOR+$cd
N3POS						= SCREEN+$11f
N3CPOS					= SCREENCOLOR+$11f


HORIZONPOS			= SCREEN+$29
HORIZONCPOS			= SCREENCOLOR+$29

; sprites
SPR_RAM			 		= 832
SPR_CURSOR			= 13

; keyboard
KEYROWS 				=	$dc00			; peek
KEYCOLS					= $dc01 		; poke
 														;+----+---------+-------------------------------------------------------------------------------------------------------+
 														;|    |         |                                Peek from $dc01 (code in paranthesis):                                 |
 														;|row:| $dc00:  +------------+------------+------------+------------+------------+------------+------------+------------+
 														;|    |         | 128  BIT 7 | 64 BIT 6   | 32 BIT 5   | 16 BIT 4   | 8  BIT 3   | 4  BIT 2   | 2  BIT 1   | 1  BIT 0   |
 														;+----+---------+------------+------------+------------+------------+------------+------------+------------+------------+
KEYROW_1				= %11111110 ; (254/$fe) 		| DOWN  ($  )|   F5  ($  )|   F3  ($  )|   F1  ($  )|   F7  ($  )| RIGHT ($  )| RETURN($  )|DELETE ($  )|
KEYROW_2				= %11111101	; (253/$fd)     |LEFT-SH($  )|   e   ($05)|   s   ($13)|   z   ($1a)|   4   ($34)|   a   ($01)|   w   ($17)|   3   ($33)|
KEYROW_3				= %11111011 ; (251/$fb)     |   x   ($18)|   t   ($14)|   f   ($06)|   c   ($03)|   6   ($36)|   d   ($04)|   r   ($12)|   5   ($35)|
KEYROW_4				= %11110111 ; (247/$f7)     |   v   ($16)|   u   ($15)|   h   ($08)|   b   ($02)|   8   ($38)|   g   ($07)|   y   ($19)|   7   ($37)|
KEYROW_5				= %11101111 ; (239/$ef)     |   n   ($0e)|   o   ($0f)|   k   ($0b)|   m   ($0d)|   0   ($30)|   j   ($0a)|   i   ($09)|   9   ($39)|
KEYROW_6				= %11011111 ; (223/$df)     |   ,   ($2c)|   @   ($00)|   :   ($3a)|   .   ($2e)|   -   ($2d)|   l   ($0c)|   p   ($10)|   +   ($2b)|
KEYROW_7				= %10111111 ; (191/$bf)     |   /   ($2f)|   ^   ($1e)|   =   ($3d)|RGHT-SH($  )|  HOME ($  )|   ;   ($3b)|   *   ($2a)|   £   ($1c)|
KEYROW_8				= %01111111 ; (127/$7f)     | STOP  ($  )|   q   ($11)|COMMODR($  )| SPACE ($20)|   2   ($32)|CONTROL($  )|  <-   ($1f)|   1   ($31)|
														;+----+---------+------------+------------+------------+------------+------------+------------+------------+------------+

main
!zone initScreen
									lda #COLOR_BLACK
									sta VIC_BORDERCOLOR
									sta VIC_BACKGROUNDCOLOR
									jsr clearScreen

									lda #$18									; use charset at $2000
									sta VIC_MEMSETUP	
									; activate multicolor
									; lda #16
									; ora $d016
									; sta $d016
									; lda #09
						  		; sta $d022
									; lda #06
									; sta $d023
							
									jsr drawUi
									;jsr drawMap;
									jsr getFov
									jsr initCanvas
!zone initSprites
	
 									lda #SPR_CURSOR
 									sta SPRITEPOINTER0
 									lda #1
 									sta VIC_SPRITEACTIVE
 									lda #1
 									sta VIC_SPRITEMULTICOLOR 									
									
									ldx #62
sprCursorLoad			lda spriteTiles,x
 									sta SPR_RAM,x								
 									dex		
 									bne sprCursorLoad									
 									lda #6
 									sta VIC_SPRITE0COLOR
 									lda #12
 									sta VIC_SPRITEMULTICOLOR0
 									lda #14
 									sta VIC_SPRITEMULTICOLOR1			
 									lda #100
 									sta VIC_SPRITE0X
 									lda #100
 									sta VIC_SPRITE0Y

!zone gameloop							
gameloop									; start the game loop
wait 							lda #80
wait1							cmp $d012
							bne wait1
;							inc $d020
;							ldx #255
;wait2 				dex
;							bne wait2
;							dec $d020
							; TODO refactor the key loop with lsr maybe								
						
!zone inputLoops


							jsr getJoy2

movesprite		ldx dx
							stx VIC_SPRITE0X
							ldy dy
							sty VIC_SPRITE0Y

	
							lda #KEYROW_8				; #8
key_1					sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_2		
							lda #$31
							sta SCREEN+$65																										
key_2					lda KEYCOLS
							and #8
							bne key_Q					
							lda #$32
							sta SCREEN+$65
key_Q					lda KEYCOLS
							and #64			
							bne key_3
							lda pd		; rotate player left
							asl
							rol pd
							jsr setDirection
							jsr getFov
							jsr drawHorizon
							jsr initCanvas											
key_3					lda #KEYROW_2				; #2
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_W						
							lda #$33
							sta SCREEN+$65
							jsr initCanvas	
key_W					lda KEYCOLS
							and #2
							bne key_A
							jsr movePlayerF
							jsr setDirection
							jsr getFov
							jsr drawHorizon
							jsr initCanvas					
key_A					lda KEYCOLS
							and #4
							bne key_4
							jsr initCanvas
							jsr movePlayerW
							jsr drawMap
							jsr drawPlayer						
key_4					lda KEYCOLS
							and #8
							bne key_S						
							jsr initCanvas
key_S					lda KEYCOLS
							and #32
							bne key_E							
							jsr initCanvas
							jsr movePlayerS
							jsr drawMap
							jsr drawPlayer
key_E					lda KEYCOLS
							and #64			
							bne key_5
							lda pd	; rotate player right
							lsr
							ror pd
							jsr setDirection
							jsr getFov
							jsr initCanvas
							jsr drawMap
							jsr drawPlayer			
key_5					lda #KEYROW_3			; # 3
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_D						
							jsr initCanvas
key_D					lda KEYCOLS
							and #4
							bne key_6
							jsr initCanvas
							jsr movePlayerE
							jsr drawMap
							jsr drawPlayer
key_6					lda KEYCOLS
							and #8
							bne key_7					
							jsr initCanvas	
key_7					lda #KEYROW_4			; #4
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_8				
							jsr initCanvas
key_8					lda KEYCOLS
							and #8
							bne key_B						
							jsr initCanvas
key_B					lda KEYCOLS
							and #16
							bne key_9						
							jsr initCanvas												
key_9					lda #KEYROW_5		; #5
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_0																
							jsr initCanvas									
key_0					lda KEYCOLS
							and #8
					    bne +																
							jsr initCanvas
							lda #2
							sta px
							sta py
							jsr drawMap
							jsr drawPlayer
+							
gameloopEnd		jmp gameloop
							
						
!zone debug							
printdebugs		jsr clearValues						
							lda py					   ; player y debug
							sta value
							jsr printdec
							lda resultstr								
							sta SCREEN+$6f
							lda resultstr+1
							sta SCREEN+$6e
							lda resultstr+2
							sta SCREEN+$6d
							lda #$19
							sta SCREEN+$6c
							
							jsr clearValues
							
							lda px						; player x debug
							sta value
							jsr printdec
							lda resultstr								
							sta SCREEN+$6a
							lda resultstr+1
							sta SCREEN+$69
							lda resultstr+2
							sta SCREEN+$68
							lda #$18
							sta SCREEN+$67
						
							jsr clearValues
							
							lda pd						; player x debug
							sta value
							jsr printdec
							lda resultstr								
							sta SCREEN+$74
							lda resultstr+1
							sta SCREEN+$73
							lda resultstr+2
							sta SCREEN+$72
							lda #$04
							sta SCREEN+$71
							rts	
														
							
						

!zone vars
; #  variables go here
; ######################################

ceilingColor	!byte	COLOR_DARKGREY
floorColor		!byte COLOR_BLUE
px						!byte 4,0,0,0				; player x coordinate
py						!byte 7,0,0,0				; player y coordinate
pd						!byte %10001000			; player direction
pIco					!byte	ICON_NORTH		; which icon to use for the player on map

!zone inputRoutines
dx						!byte 250,0
dy						!byte 100
fire0 				!byte 0							

getJoy2				;lda $dc00
         			;sta $02			 	
up       			lda #%00000001
         			bit $dc00
         			bne down      	
         			dec dy      		
down     			lda #%00000010
				 			bit $dc00
         			bne left
         			inc dy
left     			lda #%00000100
         			bit $dc00
         			bne right
         			dec dx
				 			bne right
				 			lda #1
				 			eor $d010
				 			sta $d010
right    			lda #%00001000
         			bit $dc00
         			bne fire
         			inc dx
				 			bne fire
				 			lda #1
				 			eor $d010
				 			sta $d010				
fire 		 			lda #%00010000
         			bit $dc00
         			bne end
end						rts

!zone subRoutines
; #  sub routines here
; ######################################

; rotating and moving
drawMap				lda #MAPWIDTH
							sta CHARDATA_W
							lda #MAPHIGHT
							sta CHARDATA_H
							lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
							lda #<MAPPOS				; get low byte of the mappos (screen ram w/ offset)
							sta LOB_SCREEN			; store in zpage
							lda #>MAPPOS				; same for...
							sta HIB_SCREEN
							jsr drawChars
							jsr drawPlayer
							rts

; fov -  directions are pd based

!zone fovRoutines

; these are our FOV registers			
fov
w3 !byte 0
e3 !byte 0
n3 !byte 0
w2 !byte 0
e2 !byte 0
n2 !byte 0
w1 !byte 0
e1 !byte 0
n1 !byte 0	
w0 !byte 0
e0 !byte 0
						
getFov				lda pd					; get direction and jsr the correct direction FOV routine
							cmp #NORTH
							bne +
							jsr getFovNorth
+							cmp #EAST
							bne +
							jsr getFovEast
+							cmp #SOUTH
							bne +
							jsr getFovSouth
+							cmp #WEST
							bne +
							jsr getFovWest					
+							rts

getFovNorth		lda #<map						; 		E3 N3 E3
							sta LOB_DATA				; 		E2 N2	E2
							lda #>map						; 		E1 N1	E1
							sta HIB_DATA				;     E0 PL E0
							ldy py
							dey
							beq +++							; py-1 is 0? were in the first row skip the row loop		
							dey
							beq ++							; py-1 is 0? were in the first row skip the row loop		
							dey
							beq +			
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bne -
							; 3 rows in front of the player
+							ldy px						; load the player x
							lda (LOB_DATA),y
							sta n3						; N3
							sta COMPASSPOS+1
														
							ldy px						
							iny								
							lda (LOB_DATA),y
							sta e3						; E3
							sta COMPASSPOS+2
							
							ldy px						
							dey								
							lda (LOB_DATA),y
							sta w3						; W3
							sta COMPASSPOS
							; next row
							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							; 2 rows in front of the player
++						ldy px						; load the player x
							lda (LOB_DATA),y
							sta n2						; N2
							sta COMPASSPOS+41
														
							ldy px						
							iny								
							lda (LOB_DATA),y
							sta e2						; E2
							sta COMPASSPOS+42
							
							ldy px						
							dey								
							lda (LOB_DATA),y
							sta w2						; W2
							sta COMPASSPOS+40
							; next row
							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							; 1 rows in front of the player
+++ 					ldy px						; load the player x
							lda (LOB_DATA),y
							sta n1						; N1
							sta COMPASSPOS+81
														
							ldy px						
							iny								
							lda (LOB_DATA),y
							sta e1						; E1
							sta COMPASSPOS+82
							
							ldy px						
							dey								
							lda (LOB_DATA),y
							sta w1						; W2
							sta COMPASSPOS+80
							; next row
							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							; row with player

++++ 					ldy px						
							iny								
							lda (LOB_DATA),y
							sta e0						; E0
							sta COMPASSPOS+122
							
							ldy px						
							dey								
							lda (LOB_DATA),y
							sta w0						; W0
							sta COMPASSPOS+120
							
							; draw compass directions
							lda #S_N
							sta COMPASSNORTH
							lda #S_E
							sta COMPASSEAST
							lda #S_S
							sta COMPASSSOUTH
							lda #S_W
							sta COMPASSWEST
							
							rts							


getFovEast		lda #<map												; 		E3 N3 E3
							sta LOB_DATA				; 		E2 N2	E2
							lda #>map						; 		E1 N1	E1
							sta HIB_DATA				;     E0 PL E0
							ldy py
							dey
							beq +									; py-1 is 0? were in the first row skip the row loop						
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bne -
							; 1 rows in above of the player													
+							ldy px							; W0								
							lda (LOB_DATA),y
							sta w0
							sta COMPASSPOS+120
							iny							
							lda (LOB_DATA),y
							sta w1
							sta COMPASSPOS+80
							iny							
							lda (LOB_DATA),y							
							sta w2
							sta COMPASSPOS+40
							iny							
							lda (LOB_DATA),y
							sta w3
							sta COMPASSPOS	
							
							; next row
							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							
							; row with the player											
							ldy px							; W0								
							iny							
							lda (LOB_DATA),y
							sta n1
							sta COMPASSPOS+81
							iny							
							lda (LOB_DATA),y							
							sta n2
							sta COMPASSPOS+41
							iny							
							lda (LOB_DATA),y
							sta n3
							sta COMPASSPOS+1	
							
							; next row
							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							
							; row below the player
							ldy px																						
							lda (LOB_DATA),y
							sta e0
							sta COMPASSPOS+122
							iny							
							lda (LOB_DATA),y							
							sta e1
							sta COMPASSPOS+82
							iny							
							lda (LOB_DATA),y
							sta e2
							sta COMPASSPOS+42		
							iny							
							lda (LOB_DATA),y
							sta e3
							sta COMPASSPOS+2
							
							; draw compass directions
							lda #S_E
							sta COMPASSNORTH
							lda #S_S
							sta COMPASSEAST
							lda #S_W
							sta COMPASSSOUTH
							lda #S_N
							sta COMPASSWEST
							
+++						rts
							
							
getFovSouth		lda #<map						; 		E0 PL W0						
							sta LOB_DATA				; 		E1 N1	W1			
							lda #>map						; 		E2 N2	W2		
							sta HIB_DATA				;     E3 N3 W3
							ldy py			
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey						
							bne -							
							; row 0 with the player
++++ 					ldy px							; PL (N0)
							lda #$13						
							sta COMPASSNORTH														
							ldy px							; W0
							iny								
							lda (LOB_DATA),y
							sta w0							
							sta COMPASSPOS+120							
							ldy px							; E0					
							dey								
							lda (LOB_DATA),y
							sta e0						
							sta COMPASSPOS+122
							; next row
							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA					
							; row 1 below the player
							ldy px							; N1
							lda (LOB_DATA),y
							sta COMPASSPOS+81
							sta n1

							ldy px							; W1				
							iny								
							lda (LOB_DATA),y
							sta w1														
							sta COMPASSPOS+80		
							ldy px							; E1
							dey								
							lda (LOB_DATA),y
							sta e1							
							sta COMPASSPOS+82						
							; next row
							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA					
							; row 2 below the player
							ldy px							; N2
							lda (LOB_DATA),y
							sta COMPASSPOS+41
							sta n2
							ldy px							; W2	
							iny								
							lda (LOB_DATA),y
							sta w2														
							sta COMPASSPOS+40				
							ldy px							; E2
							dey								
							lda (LOB_DATA),y
							sta e2							
							sta COMPASSPOS+42			
							; next row
							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA					
							; row 3 below the player
							ldy px							; N3							
							lda (LOB_DATA),y
							sta COMPASSPOS+1
							sta n3														
							ldy px							; W3						
							iny								
							lda (LOB_DATA),y
							sta w3														
							sta COMPASSPOS								
							ldy px							; E3						
							dey								
							lda (LOB_DATA),y
							sta e3							
							sta COMPASSPOS+2	
	
							; draw compass directions
							lda #S_S
							sta COMPASSNORTH
							lda #S_W
							sta COMPASSEAST
							lda #S_N
							sta COMPASSSOUTH
							lda #S_E
							sta COMPASSWEST						
							rts
							
getFovWest		lda #<map																	; 		E3 N3 E3
							sta LOB_DATA				; 		E2 N2	E2
							lda #>map						; 		E1 N1	E1
							sta HIB_DATA				;     E0 PL E0
							ldy py
							dey
							beq +									; py-1 is 0? were in the first row skip the row loop						
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bne -
							
							; 1 rows in above of the player													
+							ldy px							; east walls								
							lda (LOB_DATA),y
							sta e0
							sta COMPASSPOS+122
							dey
							lda (LOB_DATA),y
							sta e1
							sta COMPASSPOS+82	
							dey							
							lda (LOB_DATA),y							
							sta e2
							sta COMPASSPOS+42	
							dey							
							lda (LOB_DATA),y
							sta e3
							sta COMPASSPOS+2	
							
							; next row
+							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA							
							
							ldy px															
							dey							
							lda (LOB_DATA),y
							sta n1
							sta COMPASSPOS+81
							dey							
							lda (LOB_DATA),y							
							sta n2
							sta COMPASSPOS+41
							dey							
							lda (LOB_DATA),y
							sta n3
							sta COMPASSPOS+1	
							
							; next row
							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							
							; row below the player
							ldy px																						
							lda (LOB_DATA),y
							sta w0
							sta COMPASSPOS+120
							dey							
							lda (LOB_DATA),y							
							sta w1
							sta COMPASSPOS+80
							dey							
							lda (LOB_DATA),y
							sta w2
							sta COMPASSPOS+40			
							dey							
							lda (LOB_DATA),y
							sta w3
							sta COMPASSPOS		
							
							; draw compass directions
							lda #S_W
							sta COMPASSNORTH
							lda #S_N
							sta COMPASSEAST
							lda #S_E
							sta COMPASSSOUTH
							lda #S_S
							sta COMPASSWEST
					
+++						rts
					
							
setDirection	lda pd						; sets the player icon based on the pd value
							cmp #NORTH
							bne +
							ldx #ICON_NORTH
							stx pIco
+							cmp #EAST
							bne +
							ldx #ICON_EAST
							stx pIco
+							cmp #SOUTH
							bne +
							ldx #ICON_SOUTH
							stx pIco
+							cmp #WEST
							bne +
							ldx #ICON_WEST
							stx pIco
+							rts

						
!zone canvas

initCanvas		;jsr drawHorizon
							lda #<fov
							sta FOVLO
							lda #>fov
							sta FOVHI
							
							ldy #0
							sty FOVCOUNTER			
							lda (FOVLO),y
							cmp #W
							bne +
							;jsr drawW3
+							inc FOVCOUNTER
							ldy FOVCOUNTER									
							lda (FOVLO),y
							cmp #W
							bne +
							jsr drawE3
+							inc FOVCOUNTER
							ldy FOVCOUNTER						
							lda (FOVLO),y
							cmp #W
							bne +
							jsr drawN3
+							inc FOVCOUNTER
							ldy FOVCOUNTER									
							lda (FOVLO),y
							cmp #W
							bne +
							jsr drawW2
+							inc FOVCOUNTER
							ldy FOVCOUNTER								
							lda (FOVLO),y
							cmp #W
							bne +
							jsr drawE2
+							inc FOVCOUNTER
							ldy FOVCOUNTER									
							lda (FOVLO),y
							cmp #W
							bne +
							jsr drawN2
+							inc FOVCOUNTER
							ldy FOVCOUNTER									
							lda (FOVLO),y
							cmp #W
							bne +
							jsr drawW1
+							inc FOVCOUNTER
							ldy FOVCOUNTER									
							lda (FOVLO),y
							cmp #W
							bne +
							jsr drawE1
+							inc FOVCOUNTER
							ldy FOVCOUNTER									
							lda (FOVLO),y
							cmp #W
							bne +
							jsr drawN1
+							inc FOVCOUNTER
							ldy FOVCOUNTER									
							lda (FOVLO),y
							cmp #W
							bne +
							jsr drawW0
+							inc FOVCOUNTER
							ldy FOVCOUNTER									
							lda (FOVLO),y
							cmp #W
							bne +
							jsr drawE0												
+							rts

!zone movePlayer
movePlayerF		lda pd							; move player forward in pd (player direction) TODO maybe cycle optimization needed
							cmp #NORTH
							bne +
							jsr movePlayerN
+							cmp #EAST
							bne +
							jsr movePlayerE
+							cmp #SOUTH
							bne +
							jsr movePlayerS
+							cmp #WEST
							bne +
							jsr movePlayerW
+							rts

							
movePlayerE		lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
							ldy py
							dey
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bpl -						
							ldy px
							iny
							lda (LOB_DATA),y
							cmp #W
							beq +
							inc px
+							rts

movePlayerW		lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
							ldy py
							dey
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bpl -							
							ldy px
							dey
							lda (LOB_DATA),y
							cmp #W
							beq +
							dec px
+							rts

movePlayerN		lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
							ldy py
							dey
							beq +								; px-1 is 0? skip the row loop
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bne -									
+							ldy px
							lda (LOB_DATA),y
							cmp #W
							beq +
							dec py
+							rts


movePlayerS		lda #<map						; get low byte of the map
							sta LOB_DATA				; store in zpage
							lda #>map						; same for
							sta HIB_DATA				; highbyte
							ldy py
							;iny
-							lda LOB_DATA
							clc
							adc #MAPWIDTH
							sta LOB_DATA
							lda HIB_DATA
							adc #0
							sta HIB_DATA
							dey
							bpl -					
							ldy px
							lda (LOB_DATA),y
							cmp #W
							beq +
							inc py
+							rts							
													
drawPlayer		lda #<MAPPOS				; we set our position back to the actuial map position
							sta LOB_SCREEN			;
							lda #>MAPPOS				;
							sta HIB_SCREEN

							ldy py							; we load the player y position
-							lda LOB_SCREEN		
							clc									
							adc #40							; add 40 ( screen row has 40 chars/bytes)
							sta LOB_SCREEN							
							lda HIB_SCREEN      ; carry is not clear
 							adc #0              ; we add it to the high byte of the screen
 							sta HIB_SCREEN      ; and store it
							dey
							bne -												; at the end we should have the y position in first row
							ldy px							; now we load x	
							lda pIco						; player icon
							sta (LOB_SCREEN),y
							rts

drawChars			ldx #0							; x = 0 for our row number
							dec CHARDATA_W
--						ldy CHARDATA_W			; y = mapwidth-1 is the last byte of a map data row
- 						lda (LOB_DATA),y		; store the data indirect addressed with y
						  sta (LOB_SCREEN),y  ; in the screen position
							dey									; decrement y
							bpl -								; is y still positive branch to -							
							
							lda LOB_SCREEN			; were done with the row and load the low byte of the screen
							clc									; clear the carry
							adc #40							; add 40 ( screen row has 40 chars/bytes)
							sta LOB_SCREEN							
							lda HIB_SCREEN      ; carry is not clear
 							adc #0              ; we add it to the high byte of the screen
 							sta HIB_SCREEN      ; and store it
							
							lda LOB_DATA
							clc
							adc CHARDATA_W			; next row
							sta LOB_DATA
							inc LOB_DATA
							lda HIB_DATA        ; carry is not clear
 							adc #0
							sta HIB_DATA
							inx
							cpx CHARDATA_H
							bne --
							rts
		

!zone drawCanvas						; single routines for drawing walls, floor and ceiling
drawW3				lda #6
							sta CHARDATA_W
							lda #3
							sta CHARDATA_H
							lda #<datW3
							sta LOB_DATA				
							lda #>datW3					
							sta HIB_DATA				
							lda #<W3POS					
							sta LOB_SCREEN			
							lda #>W3POS					
							sta HIB_SCREEN
							jsr drawChars
							lda #6
							sta CHARDATA_W
							lda #7
							sta CHARDATA_H
							lda #<datW3C
							sta LOB_DATA				
							lda #>datW3C										
							sta HIB_DATA				
							lda #<W2CPOS									
							sta LOB_SCREEN			
							lda #>W3CPOS											
							sta HIB_SCREEN
							jsr drawChars
							rts

							
drawN3				lda #6
							sta CHARDATA_W
							lda #3
							sta CHARDATA_H
							lda #<datN3
							sta LOB_DATA				
							lda #>datN3					
							sta HIB_DATA				
							lda #<N3POS					
							sta LOB_SCREEN			
							lda #>N3POS					
							sta HIB_SCREEN
							jsr drawChars
							lda #6
							sta CHARDATA_W
							lda #7
							sta CHARDATA_H
							lda #<datN3C
							sta LOB_DATA				
							lda #>datN3C									
							sta HIB_DATA				
							lda #<N2CPOS								
							sta LOB_SCREEN			
							lda #>N3CPOS										
							sta HIB_SCREEN
							jsr drawChars
							rts
							
drawE3					lda #6
							sta CHARDATA_W
							lda #3
							sta CHARDATA_H
							lda #<datE3
							sta LOB_DATA				
							lda #>datE3					
							sta HIB_DATA				
							lda #<E3POS					
							sta LOB_SCREEN			
							lda #>E3POS					
							sta HIB_SCREEN
							jsr drawChars
							lda #6
							sta CHARDATA_W
							lda #7
							sta CHARDATA_H
							lda #<datE3C
							sta LOB_DATA				
							lda #>datE3C								
							sta HIB_DATA				
							lda #<E2CPOS							
							sta LOB_SCREEN			
							lda #>E3CPOS								
							sta HIB_SCREEN
							jsr drawChars
							rts	
							
drawW2				lda #6
							sta CHARDATA_W
							lda #7
							sta CHARDATA_H
							lda #<datW2					; W1 chars
							sta LOB_DATA				
							lda #>datW2					
							sta HIB_DATA				
							lda #<W2POS					
							sta LOB_SCREEN			
							lda #>W2POS					
							sta HIB_SCREEN
							jsr drawChars
							lda #6
							sta CHARDATA_W
							lda #7
							sta CHARDATA_H
							lda #<datW2C					; W1 color
							sta LOB_DATA				
							lda #>datW2C						
							sta HIB_DATA				
							lda #<W2CPOS						
							sta LOB_SCREEN			
							lda #>W2CPOS						
							sta HIB_SCREEN
							jsr drawChars
							rts						
							
drawE2				lda #6
							sta CHARDATA_W
							lda #7
							sta CHARDATA_H
							lda #<datE2					; W1 chars
							sta LOB_DATA				
							lda #>datE2					
							sta HIB_DATA				
							lda #<E2POS					
							sta LOB_SCREEN			
							lda #>E2POS					
							sta HIB_SCREEN
							jsr drawChars
							lda #6
							sta CHARDATA_W
							lda #7
							sta CHARDATA_H
							lda #<datE2C						; W1 color
							sta LOB_DATA				
							lda #>datE2C							
							sta HIB_DATA				
							lda #<E2CPOS							
							sta LOB_SCREEN			
							lda #>E2CPOS							
							sta HIB_SCREEN
							jsr drawChars
							rts				

drawN2				lda #10
							sta CHARDATA_W
							lda #7
							sta CHARDATA_H
							lda #<datN2		
							sta LOB_DATA				
							lda #>datN2					
							sta HIB_DATA				
							lda #<N2POS					
							sta LOB_SCREEN			
							lda #>N2POS					
							sta HIB_SCREEN
							jsr drawChars
							lda #10
							sta CHARDATA_W
							lda #7
							sta CHARDATA_H
							lda #<datN2C		
							sta LOB_DATA				
							lda #>datN2C								
							sta HIB_DATA				
							lda #<N2CPOS								
							sta LOB_SCREEN			
							lda #>N2CPOS								
							sta HIB_SCREEN
							jsr drawChars
							rts	
							
drawN1				lda #16
							sta CHARDATA_W
							lda #13
							sta CHARDATA_H
							lda #<datN1
							sta LOB_DATA				
							lda #>datN1					
							sta HIB_DATA				
							lda #<N1POS					
							sta LOB_SCREEN			
							lda #>N1POS					
							sta HIB_SCREEN
							jsr drawChars
							lda #16
							sta CHARDATA_W
							lda #13
							sta CHARDATA_H
							lda #<datN1C
							sta LOB_DATA				
							lda #>datN1C						
							sta HIB_DATA				
							lda #<N1CPOS						
							sta LOB_SCREEN			
							lda #>N1CPOS						
							sta HIB_SCREEN
							jsr drawChars
							rts					

drawW0				lda #1
							sta CHARDATA_W
							lda #15
							sta CHARDATA_H
							lda #<datW0
							sta LOB_DATA				
							lda #>datW0					
							sta HIB_DATA				
							lda #<W0POS					
							sta LOB_SCREEN			
							lda #>W0POS					
							sta HIB_SCREEN
							jsr drawChars
							lda #1
							sta CHARDATA_W
							lda #15
							sta CHARDATA_H
							lda #<datW0C			
							sta LOB_DATA				
							lda #>datW0C						
							sta HIB_DATA				
							lda #<W0CPOS						
							sta LOB_SCREEN			
							lda #>W0CPOS						
							sta HIB_SCREEN
							jsr drawChars
							rts					
							
drawE0				lda #1
							sta CHARDATA_W
							lda #15
							sta CHARDATA_H
							lda #<datE0					
							sta LOB_DATA				
							lda #>datE0					
							sta HIB_DATA				
							lda #<E0POS					
							sta LOB_SCREEN			
							lda #>E0POS						
							sta HIB_SCREEN
							jsr drawChars
							
							lda #1
							sta CHARDATA_W
							lda #15
							sta CHARDATA_H
							lda #<datE0C					
							sta LOB_DATA				
							lda #>datE0C					
							sta HIB_DATA				
							lda #<E0CPOS
							sta LOB_SCREEN			
							lda #>E0CPOS
							sta HIB_SCREEN
							jsr drawChars
							rts									

drawW1				lda #4
							sta CHARDATA_W
							lda #13
							sta CHARDATA_H
							lda #<datW1					; W1 chars
							sta LOB_DATA				
							lda #>datW1					
							sta HIB_DATA				
							lda #<W1POS					
							sta LOB_SCREEN			
							lda #>W1POS					
							sta HIB_SCREEN
							jsr drawChars
							lda #4
							sta CHARDATA_W
							lda #13
							sta CHARDATA_H
							lda #<datW1C				; W1 color
							sta LOB_DATA				
							lda #>datW1C					
							sta HIB_DATA				
							lda #<W1CPOS					
							sta LOB_SCREEN			
							lda #>W1CPOS					
							sta HIB_SCREEN
							jsr drawChars
							rts

drawE1				lda #4
							sta CHARDATA_W
							lda #13
							sta CHARDATA_H
							lda #<datE1					; E1 chars
							sta LOB_DATA				
							lda #>datE1					
							sta HIB_DATA				
							lda #<E1POS					
							sta LOB_SCREEN			
							lda #>E1POS					
							sta HIB_SCREEN
							jsr drawChars
							lda #4
							sta CHARDATA_W
							lda #13
							sta CHARDATA_H
							lda #<datE1C				; E1 color
							sta LOB_DATA				
							lda #>datE1C						
							sta HIB_DATA				
							lda #<E1CPOS						
							sta LOB_SCREEN			
							lda #>E1CPOS						
							sta HIB_SCREEN
							jsr drawChars
							rts																						
							
drawHorizon		lda #18
							sta CHARDATA_W
							lda #15
							sta CHARDATA_H
							lda #<datHorizon				; HORIZON chars
							sta LOB_DATA				
							lda #>datHorizon					
							sta HIB_DATA				
							lda #<HORIZONPOS					
							sta LOB_SCREEN			
							lda #>HORIZONPOS					
							sta HIB_SCREEN
							jsr drawChars
							lda #18
							sta CHARDATA_W
							lda #15
							sta CHARDATA_H
							lda #<datHorizonC				; HORIZON color
							sta LOB_DATA				
							lda #>datHorizonC					
							sta HIB_DATA				
							lda #<HORIZONCPOS					
							sta LOB_SCREEN			
							lda #>HORIZONCPOS					
							sta HIB_SCREEN
							jsr drawChars
							rts					
							
!zone UI

drawUi				lda #40
							sta CHARDATA_W
							lda #25
							sta CHARDATA_H
							lda #<datUi				; UI chars
							sta LOB_DATA				
							lda #>datUi					
							sta HIB_DATA				
							lda #<UIPOS					
							sta LOB_SCREEN			
							lda #>UIPOS					
							sta HIB_SCREEN
							jsr drawChars
							lda #40
							sta CHARDATA_W
							lda #25
							sta CHARDATA_H
							lda #<datUiC				; UI color
							sta LOB_DATA				
							lda #>datUiC					
							sta HIB_DATA				
							lda #<UICPOS					
							sta LOB_SCREEN			
							lda #>UICPOS					
							sta HIB_SCREEN
							jsr drawChars
							rts
				
						
!zone clearingRoutines						
clearScreen		lda #147
							jsr PRINT
							rts
					
clearValues		lda #$30
							sta resultstr
							sta resultstr+1
							sta resultstr+2
							sta result
							lda #0
							sta value
							sta value+1
							sta value+2
							sta result
							sta result+1
							sta result+2
							rts							
!zone math							
printdec			jsr hex2dec			
        			ldx #9
l1      			lda result,x
        			bne l2
        			dex             ; skip leading zeros
        			bne l1
l2      			lda result,x
        			ora #$30							
							; insert other print routine here
        			sta resultstr,x										
        			dex
        			bpl l2
        			rts
        		  ; converts 10 digits (32 bit values have max. 10 decimal digits)
hex2dec       ldx #0
l3      		  jsr div10
        		  sta result,x
        		  inx
        		  cpx #10
        		  bne l3
        		  rts
       			  ; divides a 32 bit value by 10
       			  ; remainder is returned in akku
div10         ldy #32         ; 32 bits
           	  lda #0
           	  clc
l4         	  rol
           	  cmp #10
           	  bcc skip
           	  sbc #10
skip       	  rol value
           	  rol value+1
           	  rol value+2
           	  rol value+3
           	  dey
           	  bpl l4
           	  rts				

value   		!byte 0,0,0,0
result  		!byte 0,0,0,0,0,0,0,0,0,0
resultstr		!text "00000000"			

!zone mapData
map						!byte W,W,W,W,W,W,S,W,W,W,W,W,W,W,W,W,W
							!byte W,S,W,S,S,S,S,S,S,S,S,S,S,S,S,S,W
							!byte W,S,W,S,S,S,S,S,S,S,W,W,S,W,S,S,W
							!byte W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W
							!byte W,S,S,W,S,W,W,W,S,S,W,W,S,W,S,S,W
							!byte W,S,S,S,S,W,S,W,S,S,W,W,S,W,S,S,W
							!byte W,S,S,S,S,W,S,W,S,S,S,S,S,S,S,S,W
							!byte W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W
							!byte W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W
							!byte W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W
							!byte W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W
						
!zone uiData	; TODO we should shrink this down...2k is too much for the ui .. and we dont need the blanks
datUi				!media "assets\ui.charscreen",char,0,0,40,25
datUiC			!media "assets\ui.charscreen",color,0,0,40,25						

!align 63,0
spriteTiles
 !media "assets\cursor.spriteproject",sprite,0,1

*=$2000
!media "assets\dungeon0.charscreen",CHARSET

*=$2801
!zone canvasData
datHorizon  !media "assets\ui.charscreen",char,1,1,18,15																	
datHorizonC !media "assets\ui.charscreen",color,1,1,18,15
datW0				!media "assets\dungeon0.charscreen",char,38,10,1,15
datW0C			!media "assets\dungeon0.charscreen",color,38,10,1,15
datW1				!media "assets\dungeon0.charscreen",char,30,12,4,13
datW1C			!media "assets\dungeon0.charscreen",color,30,12,4,13
datW2				!media "assets\dungeon0.charscreen",char,0,18,6,7
datW2C			!media "assets\dungeon0.charscreen",color,0,18,6,7
datE1				!media "assets\dungeon0.charscreen",char,34,12,4,13
datE1C			!media "assets\dungeon0.charscreen",color,34,12,4,13
datE0				!media "assets\dungeon0.charscreen",char,39,10,1,15
datE0C			!media "assets\dungeon0.charscreen",color,39,10,1,15
datE2				!media "assets\dungeon0.charscreen",char,6,18,6,7
datE2C			!media "assets\dungeon0.charscreen",color,6,18,6,7
datN2				!media "assets\dungeon0.charscreen",char,12,18,10,7
datN2C			!media "assets\dungeon0.charscreen",color,12,18,10,7
datN1				!media "assets\dungeon0.charscreen",char,0,0,16,13
datN1C			!media "assets\dungeon0.charscreen",color,0,0,16,13

datW3				!media "assets\dungeon0.charscreen",char,0,15,6,3
datW3C			!media "assets\dungeon0.charscreen",color,0,15,6,3
datN3				!media "assets\dungeon0.charscreen",char,6,15,6,3
datN3C			!media "assets\dungeon0.charscreen",color,6,15,6,3		
datE3				!media "assets\dungeon0.charscreen",char,12,15,6,3
datE3C				!media "assets\dungeon0.charscreen",color,12,15,6,3
