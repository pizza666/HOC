!source "_includes\system_const.asm"
!source "_includes\const_scrcodes.asm"
*=$801
!basic main

!zone zeropages
; zero Pages
LOB_DATA				= $92		; data lobyte in ZP
HIB_DATA				= $93   ; data hibyte in ZP
LOB_SCREEN			= $94 	; screen/color lobyte in ZP
HIB_SCREEN			= $95   ; screen/color hibyte in ZP
CHARDATA_W			= $96   ; data width in ZP
CHARDATA_H			= $fb   ; data hight in ZP

; rng and dice
SEED						= $02
SUCCESSROLL 		= $05
LASTD6					= $06
LOB_SKILLPTR	  = $17
HIB_SKILLPTR		= $18

; math
COUNT						= $52

; text/strings
LOB_TXTPTR			= $03
HIB_TXTPTR			= $04

!zone consts
; attributes
STR 						= 1
DEX 						= 2
INT 						= 3	
	
; ui const
UIWIDTH					= 40
UIHIGHT					= 25
UIPOS						= SCREEN
UICPOS					= SCREENCOLOR

; left menu
LMOFFSET				= $8b
LEFTMENUPOS			= SCREEN+LMOFFSET
LEFTMENUCOLOR		= SCREENCOLOR+LMOFFSET

; map const
MAPWIDTH				= 20
MAPHIGHT				= 12
W							  = 175				;normal wall
S								= 35				;normal floor/sky (space)		
MAPPOS 					= LEFTMENUPOS
MAPCOLOR				= LEFTMENUCOLOR
NORTH						= %10001000 ; $88 - 136
EAST						= %01000100 ; $44 - 68
SOUTH						= %00100010 ; $22 - 34
WEST						= %00010001 ; $11 - 17

; sprites
SPR_RAM			 		= 832
SPR_CURSOR			= 13

; sprites - weapons
WPNSPRTX				= 140
WPNSPRTX2				= 110
WPNSPRTY				= 128

ICON_NORTH			= $ab
ICON_EAST				= ICON_NORTH+1
ICON_SOUTH			= ICON_NORTH+2
ICON_WEST				= ICON_NORTH+3

; compass
COMPASSPOS			= SCREEN+$2e2
COMPASSNORTH		= SCREEN+$293
COMPASSEAST			= SCREEN+$30f
COMPASSSOUTH		= SCREEN+$383
COMPASSWEST			= SCREEN+$307

; canvas offsets
CANVASPOS				= SCREEN
CANVASCPOS			= SCREENCOLOR
HORIZONPOS			= CANVASPOS
HORIZONCPOS			= CANVASCPOS

; walls
W0POS						= CANVASPOS
W0CPOS					= CANVASCPOS
W1POS 					= CANVASPOS+$28
W1CPOS 					= CANVASCPOS+$28
W2POS 					= CANVASPOS+$a0
W2CPOS 					= CANVASCPOS+$a0
W3POS						= CANVASPOS+$f0
W3CPOS					= CANVASCPOS+$f0
E0POS						= CANVASPOS+$11
E0CPOS					= CANVASCPOS+$11
E1POS 					= CANVASPOS+$36
E1CPOS 					= CANVASCPOS+$36
E2POS						= CANVASPOS+$ac
E2CPOS				  = CANVASCPOS+$ac
E3POS 					= CANVASPOS+$fc
E3CPOS 					= CANVASCPOS+$fc
N1POS						= CANVASPOS+$29
N1CPOS					= CANVASCPOS+$29
N2POS						= CANVASPOS+$a4
N2CPOS					= CANVASCPOS+$a4
N3POS						= CANVASPOS+$f6
N3CPOS					= CANVASCPOS+$f6
BACKGROUNDCOLOR	= COLOR_DARKGREY
BORDERCOLOR			= COLOR_BLACK

; debug
DEBUGPOS				= SCREEN+$3c0

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

									lda #BORDERCOLOR
									sta VIC_BORDERCOLOR
									lda #BACKGROUNDCOLOR
									sta VIC_BACKGROUNDCOLOR
									jsr clearScreen

									lda #$18									; use charset at $2000
									sta VIC_MEMSETUP	
									; activate multicolor
									lda #16
									ora $d016
									sta $d016
									lda #12
						  		sta $d022
									lda #15
									sta $d023
									
									jsr genSeed
									jsr drawUi
									jsr getFov
									jsr initCanvas
								
!zone initSprites
	
 									lda #3
 									sta VIC_SPRITEACTIVE
 									lda #3
 									sta VIC_SPRITEMULTICOLOR
	
									jsr loadSword

!zone gameloop							
gameloop									; start the game loop
wait 					lda #43
wait1					cmp $d012
							bne wait1
							;inc $d020
							ldx #0
wait2 				inx
							bne wait2
							;dec $d020
							; TODO refactor the key loop with lsr maybe								
						
!zone inputLoops

							lda #KEYROW_8				; #8
key_1					sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_2					
							
key_2					lda KEYCOLS
							and #8
							bne key_Q		
							
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
							jsr loadAxe				
							
key_W					lda KEYCOLS
							and #2
							bne key_A
							jsr playSfx
							jsr movePlayerF
							jsr setDirection
							jsr getFov
							jsr drawHorizon
							jsr initCanvas
							jsr stopSidV1			
key_A					lda KEYCOLS
							and #4
							bne key_4
							jsr initCanvas
							jsr movePlayerW				
key_4					lda KEYCOLS
							and #8
							bne key_S						
							jsr loadSword	
							
key_S					lda #KEYROW_2	
							sta KEYROWS
							lda KEYCOLS
							and #32
							bne key_E							
							jsr playSfx
							jsr movePlayerB
							jsr setDirection
							jsr getFov
							jsr drawHorizon
							jsr initCanvas
							jsr stopSidV1
key_E					lda KEYCOLS
							and #64			
							bne key_5
							lda pd	; rotate player right
							lsr
							ror pd
							jsr setDirection
							jsr getFov
							jsr initCanvas		
key_5					lda #KEYROW_3			; # 3
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_D
							jsr loadBow
key_D					lda KEYCOLS
							and #4
							bne key_6
							jsr initCanvas
							jsr movePlayerE
key_6					lda KEYCOLS
							and #8
							bne key_c
							jsr debugDice							
key_c					lda KEYCOLS
							and #16
							bne key_t	
				      jsr drawCharScr
key_t					lda KEYCOLS
							and #64
							bne key_7
key_7					lda #KEYROW_4			; #4
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_8				
							jsr debugSuccessRoll		
key_8					lda KEYCOLS
							and #8
							bne key_B						
							jsr initCanvas
key_B					lda KEYCOLS
							and #16
							bne key_9																	
key_9					lda #KEYROW_5		; #5
							sta KEYROWS
							lda KEYCOLS
							and #1
							bne key_m	
							inc psSwords+1
							lda #<psSwords
							sta LOB_SKILLPTR
							lda #>psSwords
							sta HIB_SKILLPTR
							jsr getSL
							jsr drawSkillScr
key_m 				lda KEYCOLS
							and #16
					    bne key_k																
							;jsr setDirection
							;jsr getFov
							jsr initCanvas
							;jsr drawHorizon
							jsr drawMap
							jsr drawPlayer
key_k					lda KEYCOLS
							and #32
							bne +	
							lda #<psSwords
							sta LOB_SKILLPTR
							lda #>psSwords
							sta HIB_SKILLPTR
							jsr getSL
							jsr drawSkillScr					
+							jsr printdebugs
gameloopEnd		jmp gameloop
							
						
!zone debug							
printdebugs		jsr clearValues						
							
							lda px						; player x debug
							sta value
							jsr printdec
							lda resultstr								
							sta DEBUGPOS+3
							lda resultstr+1
							sta DEBUGPOS+2
							lda resultstr+2
							sta DEBUGPOS+1
							lda #S_X
							sta DEBUGPOS
						
							jsr clearValues

							lda py					  ; player y debug
							sta value
							jsr printdec
							lda resultstr								
							sta DEBUGPOS+8
							lda resultstr+1
							sta DEBUGPOS+7
							lda resultstr+2
							sta DEBUGPOS+6
							lda #S_Y
							sta DEBUGPOS+5
							
							jsr clearValues						
							
							lda pd						; player direction debug
							sta value
							jsr printdec
							lda resultstr								
							sta DEBUGPOS+13
							lda resultstr+1
							sta DEBUGPOS+12
							lda resultstr+2
							sta DEBUGPOS+11
							lda #S_D
							sta DEBUGPOS+10
							rts	

debugDice			jsr clearValues

							jsr rollD6			
							lda LASTD6
							sta value
							jsr printdec
							lda resultstr
							sta DEBUGPOS+16
							lda resultstr+1
							sta DEBUGPOS+15
						
							lda LASTD6
							cmp #1
							bne +
							inc d6_1
							lda d6_1
							sta value
							jsr printdec
							lda resultstr
							sta DEBUGPOS+20
							lda resultstr+1
							sta DEBUGPOS+19
							jsr clearValues															
							
+							lda LASTD6
							cmp #2
							bne +
							inc d6_2	
							lda d6_2
							sta value
							jsr printdec
							lda resultstr
							sta DEBUGPOS+23
							lda resultstr+1
							sta DEBUGPOS+22
							jsr clearValues
							
+							lda LASTD6
							cmp #3
							bne +
							inc d6_3	
							lda d6_3
							sta value
							jsr printdec
							lda resultstr
							sta DEBUGPOS+26
							lda resultstr+1
							sta DEBUGPOS+25
						  jsr clearValues	

+							lda LASTD6
							cmp #4
							bne +
							inc d6_4	
							lda d6_4
							sta value
							jsr printdec
							lda resultstr
							sta DEBUGPOS+29
							lda resultstr+1
							sta DEBUGPOS+28
						  jsr clearValues					

+							lda LASTD6
							cmp #5
							bne +
							inc d6_5
							lda d6_5
							sta value
							jsr printdec
							lda resultstr
							sta DEBUGPOS+32
							lda resultstr+1
							sta DEBUGPOS+31
						  jsr clearValues	
							
+							lda LASTD6
							cmp #6
							bne +
							inc d6_6	
							lda d6_6
							sta value
							jsr printdec
							lda resultstr
							sta DEBUGPOS+35
							lda resultstr+1
							sta DEBUGPOS+34
						  jsr clearValues


+							inc dCount	
							lda dCount
							sta value
							jsr printdec
							lda resultstr
							sta DEBUGPOS+38
							lda resultstr+1
							sta DEBUGPOS+37
						  jsr clearValues							
							
+							jsr clearValues
							rts

debugSuccessRoll	jsr clearValues
									jsr rollSuccess			
									lda SUCCESSROLL
									sta value
									jsr printdec
									lda resultstr
									sta DEBUGPOS+16
									lda resultstr+1
									sta DEBUGPOS+15
									rts							
						

!zone varsPlayer
; pos and direction on map
px						!byte 12,0,0,0				; player x coordinate
py						!byte 4,0,0,0				; player y coordinate
pd						!byte %10001000			; player direction
pIco					!byte	ICON_NORTH		; which icon to use for the player on map
; attr
pLvl					!byte 1
pName					!scr "pizza     "
pSTR				  !byte 10
pDEX				  !byte 10
pINT					!byte 10
; armor, health and mana
pAC						!byte 0
pHP						!byte 50
pMP						!byte 40

; skills 						SL,Pts,Atr
psSwords 			!byte 0, 0,	 DEX

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

!zone subLeftMenu

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
							jsr clearValues
							rts
							
drawCharScr		lda #20
							sta CHARDATA_W
							lda #12
							sta CHARDATA_H
							lda #<datCharScr
							sta LOB_DATA
							lda #>datCharScr
							sta HIB_DATA
							lda #<LEFTMENUPOS
							sta LOB_SCREEN
							lda #>LEFTMENUPOS
							sta HIB_SCREEN							
							jsr drawChars
							
							; print the vars
							jsr clearValues
							
							lda pLvl							; print LVL
							sta value
							jsr printdec
							lda resultstr
							sta LEFTMENUPOS+127
							lda resultstr+1
							sta LEFTMENUPOS+126

							lda pSTR							; print STR
							sta value
							jsr printdec
							lda resultstr
							sta LEFTMENUPOS+167
							lda resultstr+1
							sta LEFTMENUPOS+166

							lda pDEX							; print DEX
							sta value
							jsr printdec
							lda resultstr
							sta LEFTMENUPOS+207
							lda resultstr+1
							sta LEFTMENUPOS+206
							
							lda pINT							; print INT
							sta value
							jsr printdec
							lda resultstr
							sta LEFTMENUPOS+247
							lda resultstr+1
							sta LEFTMENUPOS+246
							
							rts
							
drawSkillScr	lda #20
 							sta CHARDATA_W
 							lda #12
 							sta CHARDATA_H
 							lda #<datSkillScr
 							sta LOB_DATA
 							lda #>datSkillScr
 							sta HIB_DATA
 							lda #<LEFTMENUPOS
 							sta LOB_SCREEN
 							lda #>LEFTMENUPOS
 							sta HIB_SCREEN							
 							jsr drawChars
 							jsr clearValues
 							
							; print the vars
							jsr clearValues
							lda psSwords+1				; skill Pts
							sta value
							jsr printdec
							lda resultstr
							sta LEFTMENUPOS+138
							lda resultstr+1
							sta LEFTMENUPOS+137
							
							; print the vars
							jsr clearValues
							lda psSwords					; skill SL
							sta value
							jsr printdec
							lda resultstr
							sta LEFTMENUPOS+135
							lda resultstr+1
							sta LEFTMENUPOS+134
 							
 							rts								

; fov -  directions are pd based
!zone subsFov
						
getFov				lda pd					; get direction and jsr the correct direction FOV routine
							cmp #NORTH
							bne +
							jsr getFovNorth
+							lda pd
							cmp #EAST
							bne +
							jsr getFovEast
+							lda pd
							cmp #SOUTH
							bne +
							jsr getFovSouth
+							lda pd
							cmp #WEST
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

; these are our FOV registers			
fov
w3 !byte $20
e3 !byte $20
n3 !byte $20
w2 !byte $20
e2 !byte $20
n2 !byte $20
w1 !byte $20
e1 !byte $20
n1 !byte $20	
w0 !byte $20
e0 !byte $20

!zone canvas
initCanvas		jsr drawHorizon

+							lda w3
							cmp #W
							bne +
							jsr drawW3
+							lda e3
							cmp #W
							bne +
							jsr drawE3
+							lda n3
							cmp #W
							bne +
							jsr drawN3
							
+							lda w2
							cmp #W
							bne +
							jsr drawW2
+							lda e2
							cmp #W
							bne +
							jsr drawE2
+							lda n2
							cmp #W
							bne +
							jsr drawN2
							
+							lda w1
							cmp #W
							bne +
							jsr drawW1
+							lda e1
							cmp #W
							bne +
							jsr drawE1
+							lda n1
							cmp #W
							bne +
							jsr drawN1
							
+							lda w0
							cmp #W
							bne +
							jsr drawW0
+							lda e0
							cmp #W
							bne +
							jsr drawE0												
+							rts
	
!zone subsMovePlayer
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

movePlayerB		lda pd
							cmp #NORTH
							bne +
							jsr movePlayerS
+							cmp #EAST
							bne +
							jsr movePlayerW
+							cmp #SOUTH
							bne +
							jsr movePlayerN
+							cmp #WEST
							bne +
							jsr movePlayerE						
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

!zone subsCanvas
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
							lda #3
							sta CHARDATA_H
							lda #<datW3C
							sta LOB_DATA				
							lda #>datW3C										
							sta HIB_DATA				
							lda #<W3CPOS										
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
							lda #3
							sta CHARDATA_H
							lda #<datN3C
							sta LOB_DATA				
							lda #>datN3C									
							sta HIB_DATA				
							lda #<N3CPOS									
							sta LOB_SCREEN			
							lda #>N3CPOS										
							sta HIB_SCREEN
							jsr drawChars
							rts
							
drawE3				lda #6
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
							lda #3
							sta CHARDATA_H
							lda #<datE3C
							sta LOB_DATA				
							lda #>datE3C								
							sta HIB_DATA				
							lda #<E3CPOS								
							sta LOB_SCREEN			
							lda #>E3CPOS								
							sta HIB_SCREEN
							jsr drawChars
							rts	
							
drawW2				lda #6
							sta CHARDATA_W
							lda #7
							sta CHARDATA_H
							lda #<datW2
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
							lda #<datW2C
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
							lda #<datE2
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
							lda #<datE2C
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
							lda #<datW1
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
							lda #<datW1C
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
							lda #<datE1
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
							lda #<datE1C
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
							lda #<datHorizon
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
							lda #<datHorizonC
							sta LOB_DATA				
							lda #>datHorizonC					
							sta HIB_DATA				
							lda #<HORIZONCPOS					
							sta LOB_SCREEN			
							lda #>HORIZONCPOS					
							sta HIB_SCREEN
							jsr drawChars
							rts					
							

!zone subsSprites

loadWeaponSprite	ldy #192
									dey
-									lda (LOB_DATA),y
 									sta (LOB_SCREEN),y								
 									dey		
 									bne -	
									lda #1
									sta VIC_SPRITEMULTICOLOR0									
 									lda #15
									sta VIC_SPRITEMULTICOLOR1
								 	ldy #64	
									rts

activateSprite0 	stx VIC_SPRITE0COLOR
 									lda #WPNSPRTX
 									sta VIC_SPRITE0X
 									lda #WPNSPRTY
 									sta VIC_SPRITE0Y
									lda VIC_SPRITEDOUBLEHEIGHT
									ora #%00000001
									sta VIC_SPRITEDOUBLEHEIGHT
									rts
									
activateSprite1 	stx VIC_SPRITE1COLOR
 									lda #WPNSPRTX
 									sta VIC_SPRITE1X
 									lda #WPNSPRTY
 									sta VIC_SPRITE1Y
									lda VIC_SPRITEDOUBLEHEIGHT
									ora #%00000010
									sta VIC_SPRITEDOUBLEHEIGHT
									rts									

activateSprite2 	stx VIC_SPRITE2COLOR
 									lda #70
 									sta VIC_SPRITE2X
 									lda #100
 									sta VIC_SPRITE2Y
									lda VIC_SPRITEDOUBLEHEIGHT
									ora #%00000100
									sta VIC_SPRITEDOUBLEHEIGHT
									lda VIC_SPRITEDOUBLEWIDTH
									ora #%00000100
									sta VIC_SPRITEDOUBLEWIDTH
									rts						
											
									
loadSword					lda #<spriteSword
									sta LOB_DATA
									lda #>spriteSword
									sta HIB_DATA
									lda #<SPR_RAM
									sta LOB_SCREEN
									lda #>SPR_RAM
									sta HIB_SCREEN
									ldx #COLOR_GREY	
									jsr activateSprite1			
									jsr loadWeaponSprite
									
									lda #13
 									sta SPRITEPOINTER1
									lda #%10
									sta VIC_SPRITEACTIVE
									rts
									
loadAxe						lda #<spriteAxe
									sta LOB_DATA
									lda #>spriteAxe
									sta HIB_DATA
									lda #<SPR_RAM
									sta LOB_SCREEN
									lda #>SPR_RAM
									sta HIB_SCREEN
									jsr loadWeaponSprite
									ldx #COLOR_BROWN
									jsr activateSprite1									
									lda #13
 									sta SPRITEPOINTER1
									lda #%10
									sta VIC_SPRITEACTIVE
									
									rts	
									
loadBow						lda #<spriteBow
									sta LOB_DATA
									lda #>spriteBow
									sta HIB_DATA
									lda #<SPR_RAM
									sta LOB_SCREEN
									lda #>SPR_RAM
									sta HIB_SCREEN
									jsr loadWeaponSprite
									ldx #COLOR_BROWN
									jsr activateSprite1
									ldx #COLOR_PINK	
									jsr activateSprite0
									
									lda #15
 									sta SPRITEPOINTER0
									lda #13
 									sta SPRITEPOINTER1
									
									lda #%11
									sta VIC_SPRITEACTIVE
									
									rts	
									

!zone subsUi

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

!zone subsText
printScrText	ldy #0
-							lda (LOB_TXTPTR),y
							cmp #0
							beq +
							sta (LOB_SCREEN),y
							iny
							jmp -
+							rts
						
!zone subsClearing
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
!zone subsMath
printdec			jsr hex2dec			
        			ldx #9
l1      			lda result,x
        			bne l2
        			;dex             ; skip leading zeros
        			bne l1
l2      			lda result,x
        			ora #$30
							;clc
							;adc #S_0							
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
resultstr		!scr "0000000000"					

!zone dataMaps
	  					!byte W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W	
  						!byte W,W,W,W,W,W,S,W,W,W,W,W,W,W,W,W,W,W,W,W	
							;
map						!byte W,W,W,W,W,W,S,W,W,W,W,W,W,W,W,W,W,W,W,W
							!byte W,S,W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W
							!byte W,S,W,S,S,S,S,S,S,S,W,W,S,W,S,S,W,S,S,W
							!byte W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W,W,W,W
							!byte W,S,S,W,S,W,W,W,S,S,W,W,S,W,S,S,S,S,S,W
							!byte W,S,S,S,S,W,S,W,S,S,S,S,S,S,S,S,S,S,S,W
							!byte W,S,S,S,S,W,S,W,S,S,S,S,S,S,S,S,W,W,W,W
							!byte W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W,W,W,W
							!byte W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W,W,W,W
							!byte W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W
							!byte W,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,W
							!byte W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W,W
!zone dataUi
datUi				!media "assets\uiMc.charscreen",char,0,0,40,25
datUiC			!media "assets\uiMc.charscreen",color,0,0,40,25	
						
!zone dataCharsets
*=$2000
charSet			!media "assets\uiMc.charscreen",charset

*=$3000
!zone dataCanvas
datHorizon  !media "assets\uiMc.charscreen",char,0,0,18,15
datHorizonC !media "assets\uiMc.charscreen",color,0,0,18,15
datW0				!media "assets\dungeon0mc.charscreen",char,38,10,1,15
datW0C			!media "assets\dungeon0mc.charscreen",color,38,10,1,15
datW1				!media "assets\dungeon0mc.charscreen",char,30,12,4,13
datW1C			!media "assets\dungeon0mc.charscreen",color,30,12,4,13
datW2				!media "assets\dungeon0mc.charscreen",char,0,18,6,7
datW2C			!media "assets\dungeon0mc.charscreen",color,0,18,6,7
datE1				!media "assets\dungeon0mc.charscreen",char,34,12,4,13
datE1C			!media "assets\dungeon0mc.charscreen",color,34,12,4,13
datE0				!media "assets\dungeon0mc.charscreen",char,39,10,1,15
datE0C			!media "assets\dungeon0mc.charscreen",color,39,10,1,15
datE2				!media "assets\dungeon0mc.charscreen",char,6,18,6,7
datE2C			!media "assets\dungeon0mc.charscreen",color,6,18,6,7
datN2				!media "assets\dungeon0mc.charscreen",char,8,18,10,7
datN2C			!media "assets\dungeon0mc.charscreen",color,8,18,10,7
datN1				!media "assets\dungeon0mc.charscreen",char,0,0,16,13
datN1C			!media "assets\dungeon0mc.charscreen",color,0,0,16,13
datW3				!media "assets\dungeon0mc.charscreen",char,0,15,6,3
datW3C			!media "assets\dungeon0mc.charscreen",color,0,15,6,3
datN3				!media "assets\dungeon0mc.charscreen",char,6,15,6,3
datN3C			!media "assets\dungeon0mc.charscreen",color,6,15,6,3
datE3				!media "assets\dungeon0mc.charscreen",char,12,15,6,3
datE3C			!media "assets\dungeon0mc.charscreen",color,12,15,6,3					

!zone dataSprites
spriteSword 	!media "assets\weapons.spriteproject",sprite,0,2
spriteAxe			!media "assets\weapons.spriteproject",sprite,2,2
spriteBow			!media "assets\weapons.spriteproject",sprite,4,4
!zone dataText
datCharScr  !scr "                    "
						!scr " name               "
						!scr " '''''''''''''''''' "
						!scr " lvl     ^ xp 00000 "
						!scr " str     ^    00000 "
						!scr " dex     ^          "
						!scr " int     ^          "
						!scr "         ^          "
						!scr " ac   00 ^          "
						!scr " hp  000 ^          "
						!scr " mp  000 ^          "
						!scr "                    "
						
datSkillScr !scr "                    "
						!scr " skills       sl pt "
						!scr " '''''''''''''''''' "
						!scr " swords             "
						!scr "                    "
						!scr "                    "
						!scr "                    "
						!scr "                    "
						!scr "                    "
						!scr "                    "
						!scr "                    "
						!scr "                    "
					
!zone subsExternal
!source "_includes\sound.asm"
!source "_includes\dice.asm"
