;
; CRACKERS' DEMO 5 PART
;

; Code and graphics by T.M.R/Cosine
; Music by aNdy/Cosine


; Select an output filename
		!to "cd5_part.prg",cbm


; Yank in binary data
		* = $2e00
zoom_font	!binary "data/zoom.chr"

		* = $3000
dycp_font	!binary "data/doublefont.raw"

		* = $4500
		!binary "data/bitmap.prg",,2

		* = $8000
music		!binary "data/pellucid_effluvium.bin"


; Constants: raster split positions
rstr1p		= $22
rstr2p		= $aa


; Label assignments
rn		= $b0

cos_at_1	= $b1
cos_offset_1	= $0f	; constant
cos_speed_1	= $03	; constant

scroll_x	= $b2
scroll_speed	= $b3

zoom_tmr	= $b7
zoom_char_buff	= $b8	; $5 bytes used

dycp_buffer	= $c0	; $14 bytes used
dycp_cos_work	= $d4	; $14 bytes used


dycp_workspace	= $3800
zoom_workspace	= $5c00	; starts life as logo colour data


; Add a BASIC startline
		* = $1001
		!word entry-2
		!byte $00,$00,$9e
		!text "4114"
		!byte $00,$00,$00


; Entry point at $1012
		* = $1012

entry		sei

		lda #$08
		sta $ff14

; Check for a PAL machine and skip out if not
		lda $ff07
		and #$40
		beq part_start
		jmp ntsc_skip

; Kick out the system
part_start	lda #$01
		sta $ff3f

; Set up the system for a raster interrupt
		lda #$02
		sta $ff0a
		lda #$0b
		sta $ff06

		lda #rstr1p
		sta $ff0b

; Set up IRQ and NMI vectors
		lda #<irq
		sta $fffe
		lda #>irq
		sta $ffff

		lda #<nmi
		sta $fffa
		lda #>nmi
		sta $fffb

; Bitmap data at $4000
		lda #$50
		sta $ff12

; Character set data at $3800
		lda #$3a
		sta $ff13

; Screen and border colours to black
		lda #$21
		sta $ff19
		lda #$01
		sta $ff15

; Clear the video and colour RAM
		ldx #$00
		txa
colour_reset	sta $0800,x
		sta $0900,x
		sta $0a00,x
		sta $0ae8,x
		sta $0c00,x
		sta $0d00,x
		sta $0e00,x
		sta $0ee8,x
		inx
		bne colour_reset

; Set up the logo's colour
		ldx #$00
colour_init	lda bmp_luma+$000,x
		sta $08a0,x
		lda bmp_luma+$100,x
		sta $09a0,x
		lda bmp_luma+$200,x
		sta $0aa0,x

		lda bmp_colour+$000,x
		sta $0ca0,x
		lda bmp_colour+$100,x
		sta $0da0,x
		lda bmp_colour+$200,x
		sta $0ea0,x

		inx
		bne colour_init

; Generate the DYCP work areas on screen
		ldx #$00
		lda #$01
		clc
dycp_scrn_gen	sta $0f48,x
		adc #$01
		sta $0f70,x
		adc #$01
		sta $0f98,x
		sta $0c00,x
		adc #$01
		sta $0fc0,x
		sta $0c28,x
		adc #$01
		sta $0c50,x
		adc #$01
		sta $0c78,x
		adc #$01
		inx
		cpx #$28
		bne dycp_scrn_gen

		ldx #$00
		lda #$51
dycp_col_gen	lda #$24
		sta $0800,x
		lda #$32
		sta $0828,x
		lda #$48
		sta $0850,x
		lda #$57
		sta $0878,x

		lda #$55
		sta $0b48,x
		lda #$4e
		sta $0b70,x
		lda #$34
		sta $0b98,x
		lda #$22
		sta $0bc0,x
		inx
		cpx #$27
		bne dycp_col_gen

; Zero the workspace and set up some labels
		ldx #$b0
		lda #$00
nuke_zp		sta $00,x
		inx
		bne nuke_zp

		lda #$01
		sta rn

		lda #$20
		sta zoom_tmr

; Reset the scrolling messages and their work spaces
		jsr dycp_reset

		ldx #$00
		txa
dycp_buff_clr	sta dycp_buffer,x
		inx
		cpx #$14
		bne dycp_buff_clr

		lda #$01
		sta scroll_speed

		jsr zoom_reset

		ldx #$00
		txa
zoom_buff_clr	sta zoom_workspace,x
		inx
		cpx #$c8
		bne zoom_buff_clr

; Reset music
		jsr music+$00

		cli

; Runtime loop... just waiting for space really!
main_loop	lda #$7f
		sta $fd30
		sta $ff08
		lda $ff08
		and #$10
		bne main_loop

; Shut everything down
		sei

ntsc_skip	lda #$0b
		sta $ff06

		lda #$00
		sta $ff19
		sta $ff15
		sta $ff11

		lda #$a2
		sta $ff0a
		lda #$d0
		sta $ff13

; Check for and call the linker
		lda $0500
		cmp #$ea
		beq *+5
		jmp $fff6
		jmp $0500


; Main IRQ code
irq		pha
		txa
		pha
		tay
		pha

		asl $ff09

		lda rn
		cmp #$01
		beq rout1
		jmp rout2

; Raster split 1
rout1		ldx #$03
		dex
		bne *-$01
		nop

		ldx #$3b
		lda #$88
		stx $ff06
		sta $ff07

; Clear the DYCP
		lda scroll_x
		and #$08
		beq dycp_cr
dycp_cl		jsr dycp_clear_left
		jmp dycp_cr+$03
dycp_cr		jsr dycp_clear_right

; Update the DYCP scroller
		ldx scroll_x
		inx
		inx
		cpx #$10
		beq *+$05
		jmp dycp_sx_xb

		ldx #$00
!set char_cnt=$00
!do {
		lda dycp_buffer+$01+char_cnt
		sta dycp_buffer+$00+char_cnt

		!set char_cnt=char_cnt+$01
} until char_cnt=$13

dycp_mread	lda dycp_text
		bne dycp_okay
		jsr dycp_reset
		jmp dycp_mread

dycp_okay	cmp #$20
		bne *+$04
		lda #$00
		asl
		sta dycp_buffer+$13

		inc dycp_mread+$01
		bne *+$05
		inc dycp_mread+$02

		lda cos_at_1
		clc
		adc #cos_offset_1
		sta cos_at_1

		ldx #$00
dycp_sx_xb	stx scroll_x

; Update the DYCP curve table
		lda cos_at_1
		clc
		adc #cos_speed_1
		sta cos_at_1
		tax

!set dycp_cnt=$00
!do {
		lda dycp_cosinus,x
		sta dycp_cos_work+dycp_cnt

!if dycp_cnt<$13 {
		txa
		clc
		adc #cos_offset_1
		tax
}

		!set dycp_cnt=dycp_cnt+$01
} until dycp_cnt=$14

; Render the DYCP
		lda scroll_x
		and #$08
		beq dycp_dr
dycp_dl		jsr dycp_draw_left
		jmp dycp_dr+$03
dycp_dr		jsr dycp_draw_right

; Set up for second split
		lda #rstr2p
		sta $ff0b
		lda #$02
		sta rn

		jmp fcc3


; Raster split 2
rout2		ldx #$02
		dex
		bne *-$01
		nop

		lda scroll_x
		and #$07
		eor #$87
		ldx #$1b
		sta $ff07
		stx $ff06

;		lda #$ff
;		sta $ff19

; Move the large scroller
		!set byte_cnt=$00
!do {
		lda zoom_workspace+$01+byte_cnt
		sta zoom_workspace+$00+byte_cnt

		lda zoom_workspace+$29+byte_cnt
		sta zoom_workspace+$28+byte_cnt

		lda zoom_workspace+$51+byte_cnt
		sta zoom_workspace+$50+byte_cnt

		lda zoom_workspace+$79+byte_cnt
		sta zoom_workspace+$78+byte_cnt

		lda zoom_workspace+$a1+byte_cnt
		sta zoom_workspace+$a0+byte_cnt

		!set byte_cnt=byte_cnt+$01
}until byte_cnt=$27

; Check to see if a new character is needed
		ldx zoom_tmr
		inx
		cpx #$08
		bne zoom_xb

zoom_mread	lda zoom_text
		bne zoom_okay
		jsr zoom_reset
		jmp zoom_mread

zoom_okay	sta zoom_def_copy+$01
		lda #$00
		asl zoom_def_copy+$01
		rol
		asl zoom_def_copy+$01
		rol
		asl zoom_def_copy+$01
		rol
		clc
		adc #>zoom_font
		sta zoom_def_copy+$02

		ldx #$00
zoom_def_copy	lda zoom_font,x
		sta zoom_char_buff,x
		inx
		cpx #$05
		bne zoom_def_copy

		inc zoom_mread+$01
		bne *+$05
		inc zoom_mread+$02

		ldx #$00
zoom_xb		stx zoom_tmr

; Add a new column
		ldy #$00
		asl zoom_char_buff+$00
		bcc *+$04
		ldy #$22
		sty zoom_workspace+$00+$27

		ldy #$00
		asl zoom_char_buff+$01
		bcc *+$04
		ldy #$22
		sty zoom_workspace+$28+$27

		ldy #$00
		asl zoom_char_buff+$02
		bcc *+$04
		ldy #$22
		sty zoom_workspace+$50+$27

		ldy #$00
		asl zoom_char_buff+$03
		bcc *+$04
		ldy #$22
		sty zoom_workspace+$78+$27

		ldy #$00
		asl zoom_char_buff+$04
		bcc *+$04
		ldy #$22
		sty zoom_workspace+$a0+$27

; Render the large scroller to bitmap luminance
		clc

!set byte_cnt=$00
!do {
		lda bmp_luma+$0f0+byte_cnt
		adc zoom_workspace+$00+byte_cnt
		sta $08a0+$0f0+byte_cnt

		lda bmp_luma+$118+byte_cnt
		adc zoom_workspace+$28+byte_cnt
		sta $08a0+$118+byte_cnt

		lda bmp_luma+$140+byte_cnt
		adc zoom_workspace+$50+byte_cnt
		sta $08a0+$140+byte_cnt

		lda bmp_luma+$168+byte_cnt
		adc zoom_workspace+$78+byte_cnt
		sta $08a0+$168+byte_cnt

		lda bmp_luma+$190+byte_cnt
		adc zoom_workspace+$a0+byte_cnt
		sta $08a0+$190+byte_cnt

		!set byte_cnt=byte_cnt+$01
}until byte_cnt=$28

;		lda #$00
;		sta $ff19


; Play the music
		jsr music+$03
		jsr music+$06

; Set up for first split
		lda #rstr1p
		sta $ff0b
		lda #$01
		sta rn

; Non-kernal IRQ exit point
fcc3		pla
		tay
		pla
		tax
		pla

nmi		rti


; Scroller self mod resets
dycp_reset	lda #<dycp_text
		sta dycp_mread+$01
		lda #>dycp_text
		sta dycp_mread+$02
		rts

zoom_reset	lda #<zoom_text
		sta zoom_mread+$01
		lda #>zoom_text
		sta zoom_mread+$02
		rts


		* = ((*/$100)+1)*$100

; Cosine curve for the DYCP
dycp_cosinus	!byte $24,$24,$24,$24,$24,$24,$24,$24
		!byte $24,$24,$24,$24,$24,$24,$23,$23
		!byte $23,$23,$23,$23,$22,$22,$22,$22
		!byte $22,$21,$21,$21,$21,$20,$20,$20
		!byte $1f,$1f,$1f,$1e,$1e,$1e,$1d,$1d
		!byte $1d,$1c,$1c,$1c,$1b,$1b,$1a,$1a
		!byte $1a,$19,$19,$18,$18,$18,$17,$17
		!byte $16,$16,$16,$15,$15,$14,$14,$13

		!byte $13,$13,$12,$12,$11,$11,$10,$10
		!byte $10,$0f,$0f,$0e,$0e,$0d,$0d,$0d
		!byte $0c,$0c,$0b,$0b,$0b,$0a,$0a,$0a
		!byte $09,$09,$09,$08,$08,$08,$07,$07
		!byte $07,$06,$06,$06,$05,$05,$05,$05
		!byte $04,$04,$04,$04,$04,$03,$03,$03
		!byte $03,$03,$03,$02,$02,$02,$02,$02
		!byte $02,$02,$02,$02,$02,$02,$02,$02

		!byte $02,$02,$02,$02,$02,$02,$02,$02
		!byte $02,$02,$02,$02,$02,$02,$03,$03
		!byte $03,$03,$03,$03,$04,$04,$04,$04
		!byte $04,$05,$05,$05,$06,$06,$06,$06
		!byte $07,$07,$07,$08,$08,$08,$09,$09
		!byte $09,$0a,$0a,$0a,$0b,$0b,$0c,$0c
		!byte $0c,$0d,$0d,$0e,$0e,$0e,$0f,$0f
		!byte $10,$10,$11,$11,$11,$12,$12,$13

		!byte $13,$14,$14,$14,$15,$15,$16,$16
		!byte $17,$17,$17,$18,$18,$19,$19,$19
		!byte $1a,$1a,$1b,$1b,$1b,$1c,$1c,$1c
		!byte $1d,$1d,$1e,$1e,$1e,$1f,$1f,$1f
		!byte $1f,$20,$20,$20,$21,$21,$21,$21
		!byte $22,$22,$22,$22,$22,$23,$23,$23
		!byte $23,$23,$24,$24,$24,$24,$24,$24
		!byte $24,$24,$24,$24,$24,$24,$24,$24


; Include the bitmap luminance and colour tables
		* = $4000
		!src "includes/logo_luma.asm"

		* = $5c00
		!src "includes/logo_colour.asm"


; Include the DYCP clear and render code
		* = $6000
		!src "includes/unrolled_dycp.asm"


		* = $8c00
; DYCP scroller text
dycp_text	!scr "here come the happy bunnies of cosine again, this time "
		!scr "with a contribution to   "
		!scr "--- crackers' demo 5 ---"
		!scr "     "

		!scr "code and graphics from the magic roundabout, with "
		!scr "ted warbling supplied by andy"
		!scr "     "

		!scr "so...   i'm sat here indoors on a horrifically hot day "
		!scr "typing scrolltext, mostly because it needs doing in order "
		!scr "to get this part finished but also because there is "
		!scr "air conditioning here - hot weather really isn't my "
		!scr $22,"friend",$22,".   "

		!scr "but even with the aircon running i'm still finding it "
		!scr "difficult to come up with something to write about!   "
		!scr "uk politics is a complete and utter clusterfuck "
		!scr "after the eu referendum, i haven't seen a new movie in "
		!scr "ages, telly has been quiet (although i have been watching "
		!scr "a lot of classic doctor who but that probably comes as a "
		!scr "revelation to pretty much nobody) and, although the "
		!scr "sundown party took place last weekend, i couldn't make "
		!scr "it so don't have anything to say about that either!   "

		!scr "i was hoping to compete in their oldschool demo "
		!scr "competition, but the pair of ideas i had for something to "
		!scr "build a c64 demo around didn't really offer enough "
		!scr "variety when tested and will probably end up reworked "
		!scr "as a monthly demo or two instead."
		!scr "     "

		!scr "i've just checked over at the cosine website - "
		!scr "http://cosine.org.uk/ because resisting a shameless plug "
		!scr "was never in my nature - and, rather surprisingly, it's "
		!scr "been a decade since we last released something on the "
		!scr "264 and that was 4-mat's ted storm - i suddenly feel "
		!scr "almost painfully old just thinking about that and "
		!scr "perhaps i'll have to get some more code written - not "
		!scr "having a working machine for testing makes me a little "
		!scr "nervous though, so  i'll have to go looking for a "
		!scr $22,"willing victim",$22," to make sure that what i've "
		!scr "coded will actually run."
		!scr "     "

		!scr "we got worryingly close to the wire getting this release "
		!scr "completed in time for crackers' demo 5; i dumped the "
		!scr "job of composing music in andy's lap very late in the day "
		!scr "and did less than sensible things during development "
		!scr "like drawing the logo with project one using the c64's "
		!scr "palette to represent luminance rather than colour - for a "
		!scr "while it was just shades of grey on the plus/4 until i "
		!scr "manually built a colour table in the source code!   "

		!scr "that does seem to be a regular process for me when making "
		!scr "graphics for this machine though, the dfli logo in radiant "
		!scr "was created using deluxe paint 4 on an amiga before the "
		!scr "bitmap data was hand converted and the colour tables "
		!scr "rebuilt in the assembler.   i was going to colour those "
		!scr "tiles around the logo too, but felt that the contrast "
		!scr "between the rainbow and a grey background worked better..."
		!scr "     "

		!scr "...and after that burblling, literally all inspiration for "
		!scr "text has unceremoniously deserted me.   i can't even pull "
		!scr "my usual trick of padding things out with the greetings "
		!scr "since they've got their own scroller, so we might as well "
		!scr "end here.   as always, don't forget to visit the cosine "
		!scr "website over at http://cosine.org.uk/ for more dazzling "
		!scr "displays of digital dexterity...  and dycps."
		!scr "     "

		!scr "finally, thanks to andy for working his magic with "
		!scr "knaecketraecker at such short notice and csabo for nagging "
		!scr" me so much throughout development!"
		!scr "     "

		!scr "this has been the magic roundabout of cosine, "
		!scr "disconnecting from primary host... .. .  .   ."
		!scr "            "

		!byte $00

; Zoomed scroller text
zoom_text	!scr "greetings to..."
		!scr "   "

		!scr "abyss connection - "
		!scr "arkanix labs - "
		!scr "artstate - "
		!scr "ate bit - "
		!scr "atlantis and f4cg - "
		!scr "booze design - "
		!scr "camelot - "
		!scr "censor design - "
		!scr "chorus - "
		!scr "chrome - "
		!scr "cncd - "
		!scr "cpu - "
		!scr "crescent - "
		!scr "crest - "
		!scr "covert bitops - "
		!scr "defence force - "
		!scr "dekadence - "
		!scr "desire - "
		!scr "dac - "
		!scr "dmagic - "
		!scr "dualcrew - "
		!scr "exclusive on - "
		!scr "fairlight - "
		!scr "fire - "
		!scr "focus - "
		!scr "french touch - "
		!scr "funkscientist productions - "
		!scr "genesis project - "
		!scr "gheymaid inc. - "
		!scr "hitmen - "
		!scr "hokuto force - "
		!scr "level64 - "
		!scr "maniacs of noise - "
		!scr "mayday - "
		!scr "meanteam - "
		!scr "metalvotze - "
		!scr "noname - "
		!scr "nostalgia - "
		!scr "nuance - "
		!scr "offence - "
		!scr "onslaught - "
		!scr "orb - "
		!scr "oxyron - "
		!scr "padua - "
		!scr "plush - "
		!scr "psytronik - "
		!scr "reptilia - "
		!scr "resource - "
		!scr "rgcd - "
		!scr "secure - "
		!scr "shape - "
		!scr "side b - "
		!scr "singular - "
		!scr "slash - "
		!scr "slipstream - "
		!scr "success and trc - "
		!scr "style - "
		!scr "suicyco industries - "
		!scr "taquart - "
		!scr "tempest - "
		!scr "tek - "
		!scr "triad - "
		!scr "trsi - "
		!scr "viruz - "
		!scr "vision - "
		!scr "wow - "
		!scr "wrath - "
		!scr "xenon"

		!scr "        "

		!byte $00
