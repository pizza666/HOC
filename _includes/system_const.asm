!zone Farben
;*******************************************************************************
;*** Farben                                                                  ***
;*******************************************************************************
COLOR_BLACK         = $00           ;schwarz
COLOR_WHITE         = $01           ;weiß
COLOR_RED           = $02           ;rot
COLOR_CYAN          = $03           ;türkis
COLOR_PURPLE        = $04           ;lila
COLOR_GREEN         = $05           ;grün
COLOR_BLUE          = $06           ;blau
COLOR_YELLOW        = $07           ;gelb
COLOR_ORANGE        = $08           ;orange
COLOR_BROWN         = $09           ;braun
COLOR_PINK          = $0a           ;rosa
COLOR_DARKGREY      = $0b           ;dunkelgrau
COLOR_GREY          = $0c           ;grau
COLOR_LIGHTGREEN    = $0d           ;hellgrün
COLOR_LIGHTBLUE     = $0e           ;hellblau
COLOR_LIGHTGREY     = $0f           ;hellgrau

!zone Vic
;*******************************************************************************
;*** VIC-II Register  -  ANFANG                                              ***
;*******************************************************************************
VIC_SPRITE0X        = $d000         ;(00) X-Position von Sprite 0
VIC_SPRITE0Y        = $d001         ;(01) Y-Position von Sprite 0
VIC_SPRITE1X        = $d002         ;(02) X-Position von Sprite 1
VIC_SPRITE1Y        = $d003         ;(03) Y-Position von Sprite 1
VIC_SPRITE2X        = $d004         ;(04) X-Position von Sprite 2
VIC_SPRITE2Y        = $d005         ;(05) Y-Position von Sprite 2
VIC_SPRITE3X        = $d006         ;(06) X-Position von Sprite 3
VIC_SPRITE3Y        = $d007         ;(07) Y-Position von Sprite 3
VIC_SPRITE4X        = $d008         ;(08) X-Position von Sprite 4
VIC_SPRITE4Y        = $d009         ;(09) Y-Position von Sprite 4
VIC_SPRITE5X        = $d00a         ;(10) X-Position von Sprite 5
VIC_SPRITE5Y        = $d00b         ;(11) Y-Position von Sprite 5
VIC_SPRITE6X        = $d00c         ;(12) X-Position von Sprite 6
VIC_SPRITE6Y        = $d00d         ;(13) Y-Position von Sprite 6
VIC_SPRITE7X        = $d00e         ;(14) X-Position von Sprite 7
VIC_SPRITE7Y        = $d00f         ;(15) Y-Position von Sprite 7
VIC_SPRITESMAXX     = $d010         ;(16) Höhstes BIT der jeweiligen X-Position
                                    ;        da der BS 320 Punkte breit ist reicht
                                    ;        ein BYTE für die X-Position nicht aus!
                                    ;        Daher wird hier das 9. Bit der X-Pos
                                    ;        gespeichert. BIT-Nr. (0-7) = Sprite-Nr.
VIC_CONTROLREG1     = $d011         ;(17) Kontrollregister 1
                                    ;     BIT   7: 9. BIT von VICRASTERROWPOS ($D012)
                                    ;           6: Extended Color Modus
                                    ;           5: Bitmapmodus
                                    ;           4: Bildausgabe an/aus (erst mit
                                    ;              Beginn des nächsten Bildes)
                                    ;           3: 25 oder 24-Zeilenmodus
                                    ;         2-0: Rasterzeilen-Offset, vom oben
VIC_RASTERROWPOS    = $d012         ;(18) lesen    : Aktuelle Rasterzeile
                                    ;     schreiben: Rasterzeile für IRQ setzen
                                    ;     ACHTUNG: Auch BIT-8 in $D011 beachten!
VIC_SPRITEACTIVE    = $d015         ;(21) Bestimmt welche Sprites sichtbar sind
                                    ;        Bit-Nr. = Sprite-Nr.
VIC_SPRITEDOUBLEHEIGHT=$d017        ;(23) Doppelte Höhe der Sprites
                                    ;        Bit-Nr. = Sprite-Nr.
VIC_MEMSETUP				= $d018					; memory setup register für character und screen mem																	
VIC_IRQSTATUS       = $d019         ;(25) aktuell aufgetretene Interrupts vom VIC-II
                                    ;     lesen: 1 = IRQ aufgetreten
                                    ;     BIT   7: IRQ aufgetreten, welcher es
                                    ;              genau ist, steht in den BITs 3-0
                                    ;         6-4: unbenutzt
                                    ;           3: IRQ von Lichtgriffel (Lightpen)
                                    ;           2:         Sprite-Sprite-Kollision
                                    ;           1:         Sprite-Hintergrund-Kollision
                                    ;           0:         Rasterzeile
                                    ;    schreiben: Ein verarbeiteter IRQ muss mit
                                    ;               einer 1 im jeweiligen BIT
                                    ;               bestätigt werden! Dadurch wird
                                    ;               dieser IRQ gelöscht!!
VIC_IRQMASK         = $d01a         ;(26) Interrupt-Maske, IRQ freigeben / erlauben
                                    ;     BIT 7-4: unbenutzt
                                    ;           3: Lichtgriffel (Lightpen)
                                    ;           2: Sprite-Sprite-Kollision
                                    ;           1: Sprite-Hintergrund-Kollision
                                    ;           0: Rasterzeile
                                    ;
VIC_SPRITEDEEP      = $d01b         ;(27) Legt fest ob ein Sprite vor oder hinter
                                    ;        dem Hintergrund erscheinen soll.
                                    ;        Bit = 1: Hintergrund vor dem Sprite
                                    ;        Bit-Nr. = Sprite-Nr.
VIC_SPRITEMULTICOLOR= $d01c         ;(28) Bit = 1: MultiColor Sprite
                                    ;        Bit-Nr. = Sprite-Nr.
VIC_SPRITEDOUBLEWIDTH= $d01d        ;(29) Bit = 1: Doppelte Breite des Sprites
                                    ;        Bit-Nr. = Sprite-Nr.
VIC_SPRITESPRITECOLL= $d01e         ;(30) Bit = 1: Kollision zweier Sprites
                                    ;        Bit-Nr. = Sprite-Nr.
                                    ;        Der Inhalt wird beim Lesen gelöscht!!
VIC_SPRITEBACKGROUNDCOLL=$d01f      ;(31) Bit = 1: Sprite / Hintergrund Kollision
                                    ;        Bit-Nr. = Sprite-Nr.
                                    ;        Der Inhalt wird beim Lesen gelöscht!
VIC_BORDERCOLOR     = $d020         ;(32) Bildschirmrandfarbe
VIC_BACKGROUNDCOLOR = $d021         ;(33) Hintergrundfarbe
VIC_SPRITEMULTICOLOR0= $d025        ;(37) Spritefarbe 0 im Multicolormodus
VIC_SPRITEMULTICOLOR1= $d026        ;(38) Spritefarbe 1 im Multicolormodus
VIC_SPRITE0COLOR    = $d027         ;(39) Farbe von Sprite 0
VIC_SPRITE1COLOR    = $d028         ;(40) Farbe von Sprite 1
VIC_SPRITE2COLOR    = $d029         ;(41) Farbe von Sprite 2
VIC_SPRITE3COLOR    = $d02a         ;(42) Farbe von Sprite 3
VIC_SPRITE4COLOR    = $d02b         ;(43) Farbe von Sprite 4
VIC_SPRITE5COLOR    = $d02c         ;(44) Farbe von Sprite 5
VIC_SPRITE6COLOR    = $d02d         ;(45) Farbe von Sprite 6
VIC_SPRITE7COLOR    = $d02e         ;(46) Farbe von Sprite 7
;*******************************************************************************
;*** VIC-II Register  -  ENDE                                                ***
;*******************************************************************************

!zone CIA
;*******************************************************************************
;*** Die CIA Register  -  ANFANG                                             ***
;*******************************************************************************
;*******************************************************************************
;*** CIA1:
;*** $dc00-$dcff: IRQ, Datasette, Tastatur, Joystick, Paddles, Userport      ***
;*******************************************************************************
CIA1_A              = $dc00         ;Basisadresse des CIA1-A
CIA1_DATAPORT_A     = CIA1_A        ;(00) Dataport-A | 0=aktiv; 1=nicht aktiv!!!!
                                    ;     Tastaturmatrix: lesen/schreiben
                                    ;                     BIT 7-0: Spalten (s. Matrix)
                                    ;     Joystick Port-2:lesen
                                    ;                     BIT 7-5: unbenutzt
                                    ;                           4: Feuerknopf
                                    ;                           3: runter
                                    ;                           2: hoch
                                    ;                           1: rechts
                                    ;                           0: links
                                    ;     Paddles       : lesen
                                    ;                     BIT   7: Paddles B
                                    ;                           6: Paddles A
                                    ;                         5-4: unbenutzt
                                    ;                         3-2: Feuerknöpfe
                                    ;                         1-0: unbenutzt
CIA1_DATAPORT_B     = $dc01         ;(01) Dataport-B CIA1
                                    ;     Tastaturmatrix: lesen/schreiben
                                    ;                     BIT 7-0: Zeilen (s. Matrix)
                                    ;     Joystick Port-1:lesen
                                    ;                     BIT 7-5: unbenutzt
                                    ;                           4: Feuerknopf
                                    ;                           3: runter
                                    ;                           2: hoch
                                    ;                           1: rechts
                                    ;                           0: links
                                    ;     Lightpen      : lesen
                                    ;                     BIT 7-5: unbenutzt
                                    ;                           4: 'Feuer'-Knopf
                                    ;                         3-0: unbenutzt
                                    ;     Timer         : lesen
                                    ;                     BIT   7: Timer B Umschalten
                                    ;                              Impulsausgang
                                    ;                              (s. Reg. 15 BIT 2)
                                    ;                     BIT   6: Timer A Umschalten
                                    ;                              Impulsausgang
                                    ;                              (s. Reg. 14 BIT 2)
                                    ;                         5-0: unbenutzt
CIA1_DATADIR_A      = $dc02         ;(02) Datenrichtung für Dataport-A
                                    ;     lesen/schreiben
                                    ;     BIT 7-0: 0 = Eingang NUR lesen
                                    ;              1 = Ausgang lesen und schreiben
CIA1_DATADIR_B      = $dc03         ;(03) Datenrichtung für Dataport-B
                                    ;     lesen/schreiben
                                    ;     BIT 7-0: 0 = Eingang NUR lesen
                                    ;              1 = Ausgang lesen und schreiben
CIA1_TIMER_A_LOBY   = $dc04         ;(04) Timer-A LOW BYTE
                                    ;     lesen:     aktuelles LOW BYTE
                                    ;     schreiben: LOW BYTE setzen (Latch)
CIA1_TIMER_A_HIBY   = $dc05         ;(05) Timer-A HIGH BYTE
                                    ;     lesen:     aktuelles HIGH BYTE
                                    ;     schreiben: HIGH BYTE setzen (Latch)
CIA1_TIMER_B_LOBY   = $dc06         ;(06) Timer-B LOW BYTE
                                    ;     lesen:     aktuelles LOW BYTE
                                    ;     schreiben: LOW BYTE setzen (Latch)
CIA1_TIMER_B_HIBY   = $dc07         ;(07) Timer-B HIGH BYTE
                                    ;     lesen:     aktuelles HIGH BYTE
                                    ;     schreiben: HIGH BYTE setzen (Latch)
                                    ;
                                    ;     Für die folgende Echtzeituhr ist Register 15
                                    ;     BIT 7 wichtig, wenn geschrieben wird!!
                                    ;         = 0:  Zeit setzen
                                    ;         = 1: Alarm setzen
CIA1_CLOCK_TENTH    = $dc08         ;(08) Echtzeituhr zehntel Sekunden
                                    ;     lesen: zehntel Sek. im BCD-Format (0-9)
                                    ;     BIT 7-4: immer 0
                                    ;         3-0: zehntel als BCD
                                    ;     schreiben: Alarm oder Zeit abhängig
                                    ;                von Register 15 BIT 7
                                    ;     BIT 7-4: unbenutzt
                                    ;         3-0: Alarm oder Zeit als BCD
CIA1_CLOCK_SECONDS  = $dc09         ;(09) Echtzeituhr Sekunden
                                    ;     lesen: Seunden im BCD-Format
                                    ;     BIT   7: immer 0
                                    ;         6-4: Zehnerstelle als BCD (0-5)
                                    ;         3-0: Einerstelle  als BCD (0-9)
                                    ;     schreiben: Alarm oder Zeit abhängig
                                    ;                von Register 15 BIT 7
                                    ;     BIT   7: unbenutzt
                                    ;         6-4: Zehnerstelle als BCD (0-5)
                                    ;         3-0: Einerstelle  als BCD (0-9)
CIA1_CLOCK_MINUTES  = $dc0a         ;(10) Echtzeituhr Minuten
                                    ;     lesen: Minuten im BCD-Format
                                    ;     BIT   7: immer 0
                                    ;         6-4: Zehnerstelle als BCD (0-5)
                                    ;         3-0: Einerstelle  als BCD (0-9)
                                    ;     schreiben: Alarm oder Zeit abhängig
                                    ;                von Register 15 BIT 7
                                    ;     BIT   7: unbenutzt
                                    ;         6-4: Zehnerstelle als BCD (0-5)
                                    ;         3-0: Einerstelle  als BCD (0-9)
CIA1_CLOCK_HOURS    = $dc0b         ;(11) Echtzeituhr Stunden
                                    ;     lesen: Stunden im BCD-Format
                                    ;     BIT   7: 0 = AM / 1 = PM
                                    ;         6-4: Zehnerstelle als BCD (0-1)
                                    ;         3-0: Einerstelle  als BCD (0-9)
                                    ;     Beim lesen werden die Timer-Register
                                    ;     eingefrohren, bis $DC08 gelesen wurde!
                                    ;     Der TIMER läuft aber weiter!
                                    ;
                                    ;     schreiben: Alarm oder Zeit abhängig
                                    ;                von Register 15 BIT 7
                                    ;     BIT   7: 0 = AM / 1 = PM
                                    ;         6-4: Zehnerstelle als BCD (0-1)
                                    ;         3-0: Einerstelle  als BCD (0-9)
                                    ;     Beim Schreiben wird der TIMER gestoppt,
                                    ;     bis $DC08 geschrieben wurde.
CIA1_SERIRAL_WRITE  = $dc0c         ;(12) Wird über den Seriellenport (SP-Pin)
                                    ;     bitweise geschrieben / gelesen.
CIA1_IRQCONTROL     = $dc0d         ;(13) Interrupt-Kontroll & Statusregister
                                    ;     lesen: IRQ-Quelle
                                    ;     BIT   7: Ist ein Interrupt aufgetreten?
                                    ;         6-5: immer 0
                                    ;           4: Handshake (FLAG-Pin)
                                    ;           3: CIA1_SERIRAL_WRITE abgearbeitet
                                    ;           2: Alarmzeit erreicht
                                    ;           1: Unterlauf Timer B
                                    ;           0:           Timer A
                                    ;     Die BITs werden durchs Lesen gelöscht!
                                    ;     schreiben: IRQ-Quelle erlauben/freigeben
                                    ;     BIT   7: 1 = ALLE gesetzten BITs auf 1
                                    ;              0 =                BITs auf 0
                                    ;         6-5: unbenutzt
                                    ;           4: Handshake (FLAG) IRQ
                                    ;           3: CIA1_SERIRAL_WRITE IRQ
                                    ;           2: Alarmzeit-IRQ
                                    ;           1: Timer B Unterlauf-IRQ
                                    ;           0: Timer A Unterlauf-IRQ
CIA1_TIMER_A_CONTROL= $dc0e         ;(14) Kontrollregister für Timer A
                                    ;     lesen/schreiben
                                    ;     BIT 7: Echtzeituhr 60Hz (0) / 50Hz(1)
                                    ;         6: Richtung für CIA1_SERIRAL_WRITE
                                    ;            0 = lesen / 1 = schreiben
                                    ;         5: Timer über Systemfrequenz (0) oder
                                    ;            CNT vom Userport (1) takten
                                    ;         4: 1 = Latch in Timer übertragen
                                    ;                nur einmalig setzen
                                    ;         3: Timer endlos (0) oder einmalig (1)
                                    ;         2: Beinflusst bei einem Timer-Unterlauf
                                    ;            BIT 6 in CIA1_DATAPORT_A
                                    ;            (0) = BIT 6 invertieren
                                    ;            (1) =       für einen Takt auf HIGH
                                    ;         1: Unterlauf in BIT 6 in CIA1_DATAPORT_A
                                    ;            anzeigen (1)
                                    ;         0: STOP Timer (0) / Start Timer (1)
CIA1_TIMER_B_CONTROL= $dc0f         ;(15) Kontrollregister für Timer B
                                    ;     lesen/schreiben
                                    ;     BIT   7: (0) Uhrzeit oder (1) Alarm setzen
                                    ;         6-5: Wie den Timer takten?
                                    ;              %00 = Systemfrequenz
                                    ;              %01 = CNT vom Userport
                                    ;              %10 = Unterlauf von Timer A
                                    ;              %11 = Unterlauf von Timer A, wenn CNT
                                    ;         4: 1 = Latch in Timer übertragen
                                    ;                nur einmalig setzen
                                    ;             3: Timer endlos (0) oder einmalig (1)
                                    ;         2: Beinflusst bei einem Timer-Unterlauf
                                    ;            BIT 7 in CIA1_DATAPORT_B
                                    ;            (0) = BIT 7 invertieren
                                    ;            (1) =       für einen Takt auf HIGH
                                    ;         1: Unterlauf in BIT 7 in CIA1_DATAPORT_B
                                    ;            anzeigen (1)
                                    ;         0: STOP Timer (0) / Start Timer (1)
;                     $DC10         ;
;                   - $DCFF         ; Wiederholung der obigen sechzehn Register



!zone SID
;*******************************************************************************
;*** Die SID Register  -  ANFANG                                             ***
;*******************************************************************************
SID_BASE            = $d400         ;(Nr) Basisadresse des SID_BASE
SID_VOICE1_FREQ_MSB = $d401         ;(01) 1. Stimme: High-Byte der Frequenz
SID_VOICE1_WAVEFORM = $d404         ;(04) 1. Stimme: Wellenform
SID_SUSTAIN_RELEASE = $d406         ;(06) BIT 7-4: Anschlag (sustain)
                                    ;         3-0: Abschwellen (release)
SID_VOLUME          = $d418         ;(24) BIT   7: 3. Stimme Filtermodus AUS
                                    ;           6:   -''-    Hochpass
                                    ;           5:   -''-    Bandpass
                                    ;           4:   -''-    Tiefpass
                                    ;         3-0: Lautstärke

SID_WAVE_TRIANGLE   = $11           ;Wellenform: Dreieck
SID_WAVE_SAWTOOTH   = $21           ;Wellenform: Sägezahn
SID_WAVE_PULSE      = $41           ;Wellenform: Rechteck
SID_WAVE_WHITENOISE = $81           ;Wellenform: Rauschen
;*******************************************************************************
;*** Die SID Register  -  ENDE                                               ***
;*******************************************************************************



!zone Generic
;*** Feste Adresse (Jumptable, Kernal, usw.)
JT_IRQVECTOR        = $0314 ;/ 15   ;Adresse im RAM für den IRQ-Vector
JT_GETIN            = $ffe4         ;Kernalfunktion: Zeichen lesen
ROM_IRQFUNCTION     = $ea31         ;Standard IRQ-Routine
SCNKEY  						= $ff9f   			;scan keyboard - kernal routine
PLOT 								= $fff0					;set cursor position
PRINT 							= $ffd2					;print to screen
SCREEN							= $0400					;default screen ram
SCREENCOLOR					= $d800					;color ram
IRQ_VECTOR_LO				= $0314
IRQ_VECTOR_HI				= $0315
