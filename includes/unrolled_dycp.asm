; DYCP clear - left hand version
dycp_clear_left
		lda #$00
		ldy dycp_cos_work
		sta dycp_workspace+$008+$00,y
		sta dycp_workspace+$009+$00,y
		sta dycp_workspace+$00a+$00,y
		sta dycp_workspace+$00b+$00,y
		sta dycp_workspace+$00c+$00,y
		sta dycp_workspace+$00d+$00,y
		sta dycp_workspace+$00e+$00,y
		sta dycp_workspace+$00f+$00,y

		sta dycp_workspace+$010+$00,y
		sta dycp_workspace+$011+$00,y

!set dycp_cnt=$00
!do {
		ldy dycp_cos_work+dycp_cnt+$01

		sta dycp_workspace+$008+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$009+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00a+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00b+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00c+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00d+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00e+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00f+(dycp_cnt*$60)+$30,y

		sta dycp_workspace+$010+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$011+(dycp_cnt*$60)+$30,y

		sta dycp_workspace+$008+(dycp_cnt*$60)+$60,y
		sta dycp_workspace+$009+(dycp_cnt*$60)+$60,y
		sta dycp_workspace+$00a+(dycp_cnt*$60)+$60,y
		sta dycp_workspace+$00b+(dycp_cnt*$60)+$60,y
		sta dycp_workspace+$00c+(dycp_cnt*$60)+$60,y
		sta dycp_workspace+$00d+(dycp_cnt*$60)+$60,y
		sta dycp_workspace+$00e+(dycp_cnt*$60)+$60,y
		sta dycp_workspace+$00f+(dycp_cnt*$60)+$60,y

		sta dycp_workspace+$010+(dycp_cnt*$60)+$60,y
		sta dycp_workspace+$011+(dycp_cnt*$60)+$60,y

		!set dycp_cnt=dycp_cnt+$01
} until dycp_cnt=$13

		rts

; DYCP clear - right hand version
dycp_clear_right
		lda #$00

!set dycp_cnt=$00
!do {
		ldy dycp_cos_work+dycp_cnt

		sta dycp_workspace+$008+(dycp_cnt*$60)+$00,y
		sta dycp_workspace+$009+(dycp_cnt*$60)+$00,y
		sta dycp_workspace+$00a+(dycp_cnt*$60)+$00,y
		sta dycp_workspace+$00b+(dycp_cnt*$60)+$00,y
		sta dycp_workspace+$00c+(dycp_cnt*$60)+$00,y
		sta dycp_workspace+$00d+(dycp_cnt*$60)+$00,y
		sta dycp_workspace+$00e+(dycp_cnt*$60)+$00,y
		sta dycp_workspace+$00f+(dycp_cnt*$60)+$00,y

		sta dycp_workspace+$010+(dycp_cnt*$60)+$00,y
		sta dycp_workspace+$011+(dycp_cnt*$60)+$00,y

		sta dycp_workspace+$008+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$009+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00a+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00b+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00c+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00d+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00e+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$00f+(dycp_cnt*$60)+$30,y

		sta dycp_workspace+$010+(dycp_cnt*$60)+$30,y
		sta dycp_workspace+$011+(dycp_cnt*$60)+$30,y

		!set dycp_cnt=dycp_cnt+$01
} until dycp_cnt=$13

		ldy dycp_cos_work+$13

		sta dycp_workspace+$728+$00,y
		sta dycp_workspace+$729+$00,y
		sta dycp_workspace+$72a+$00,y
		sta dycp_workspace+$72b+$00,y
		sta dycp_workspace+$72c+$00,y
		sta dycp_workspace+$72d+$00,y
		sta dycp_workspace+$72e+$00,y
		sta dycp_workspace+$72f+$00,y

		sta dycp_workspace+$730+$00,y
		sta dycp_workspace+$731+$00,y

		rts

; DYCP draw - left hand version
dycp_draw_left

		ldy dycp_cos_work
		ldx dycp_buffer
		beq *+$5c-$1e

		lda dycp_font+$001,x
		sta dycp_workspace+$008,y
		lda dycp_font+$081,x
		sta dycp_workspace+$009,y
		lda dycp_font+$101,x
		sta dycp_workspace+$00a,y
		lda dycp_font+$181,x
		sta dycp_workspace+$00b,y
		lda dycp_font+$201,x
		sta dycp_workspace+$00c,y
		lda dycp_font+$281,x
		sta dycp_workspace+$00d,y
		lda dycp_font+$301,x
		sta dycp_workspace+$00e,y
		lda dycp_font+$381,x
		sta dycp_workspace+$00f,y

		lda dycp_font+$401,x
		sta dycp_workspace+$010,y
		lda dycp_font+$481,x
		sta dycp_workspace+$011,y

!set dycp_cnt=$00
!do {
		ldy dycp_cos_work+dycp_cnt+$01
		ldx dycp_buffer+dycp_cnt+$01
		bne *+$05
		jmp *+$b7-$3c

		lda dycp_font+$000,x
		sta dycp_workspace+$008+(dycp_cnt*$60)+$30,y
		lda dycp_font+$080,x
		sta dycp_workspace+$009+(dycp_cnt*$60)+$30,y
		lda dycp_font+$100,x
		sta dycp_workspace+$00a+(dycp_cnt*$60)+$30,y
		lda dycp_font+$180,x
		sta dycp_workspace+$00b+(dycp_cnt*$60)+$30,y
		lda dycp_font+$200,x
		sta dycp_workspace+$00c+(dycp_cnt*$60)+$30,y
		lda dycp_font+$280,x
		sta dycp_workspace+$00d+(dycp_cnt*$60)+$30,y
		lda dycp_font+$300,x
		sta dycp_workspace+$00e+(dycp_cnt*$60)+$30,y
		lda dycp_font+$380,x
		sta dycp_workspace+$00f+(dycp_cnt*$60)+$30,y

		lda dycp_font+$400,x
		sta dycp_workspace+$010+(dycp_cnt*$60)+$30,y
		lda dycp_font+$480,x
		sta dycp_workspace+$011+(dycp_cnt*$60)+$30,y

		lda dycp_font+$001,x
		sta dycp_workspace+$008+(dycp_cnt*$60)+$60,y
		lda dycp_font+$081,x
		sta dycp_workspace+$009+(dycp_cnt*$60)+$60,y
		lda dycp_font+$101,x
		sta dycp_workspace+$00a+(dycp_cnt*$60)+$60,y
		lda dycp_font+$181,x
		sta dycp_workspace+$00b+(dycp_cnt*$60)+$60,y
		lda dycp_font+$201,x
		sta dycp_workspace+$00c+(dycp_cnt*$60)+$60,y
		lda dycp_font+$281,x
		sta dycp_workspace+$00d+(dycp_cnt*$60)+$60,y
		lda dycp_font+$301,x
		sta dycp_workspace+$00e+(dycp_cnt*$60)+$60,y
		lda dycp_font+$381,x
		sta dycp_workspace+$00f+(dycp_cnt*$60)+$60,y

		lda dycp_font+$401,x
		sta dycp_workspace+$010+(dycp_cnt*$60)+$60,y
		lda dycp_font+$481,x
		sta dycp_workspace+$011+(dycp_cnt*$60)+$60,y

		!set dycp_cnt=dycp_cnt+$01
} until dycp_cnt=$13

		rts

; DYCP draw - right hand version
dycp_draw_right

		!set dycp_cnt=$00
!do {
		ldy dycp_cos_work+dycp_cnt
		ldx dycp_buffer+dycp_cnt
		bne *+$05
		jmp *+$b7-$3c

		lda dycp_font+$000,x
		sta dycp_workspace+$008+(dycp_cnt*$60)+$00,y
		lda dycp_font+$080,x
		sta dycp_workspace+$009+(dycp_cnt*$60)+$00,y
		lda dycp_font+$100,x
		sta dycp_workspace+$00a+(dycp_cnt*$60)+$00,y
		lda dycp_font+$180,x
		sta dycp_workspace+$00b+(dycp_cnt*$60)+$00,y
		lda dycp_font+$200,x
		sta dycp_workspace+$00c+(dycp_cnt*$60)+$00,y
		lda dycp_font+$280,x
		sta dycp_workspace+$00d+(dycp_cnt*$60)+$00,y
		lda dycp_font+$300,x
		sta dycp_workspace+$00e+(dycp_cnt*$60)+$00,y
		lda dycp_font+$380,x
		sta dycp_workspace+$00f+(dycp_cnt*$60)+$00,y

		lda dycp_font+$400,x
		sta dycp_workspace+$010+(dycp_cnt*$60)+$00,y
		lda dycp_font+$480,x
		sta dycp_workspace+$011+(dycp_cnt*$60)+$00,y

		lda dycp_font+$001,x
		sta dycp_workspace+$008+(dycp_cnt*$60)+$30,y
		lda dycp_font+$081,x
		sta dycp_workspace+$009+(dycp_cnt*$60)+$30,y
		lda dycp_font+$101,x
		sta dycp_workspace+$00a+(dycp_cnt*$60)+$30,y
		lda dycp_font+$181,x
		sta dycp_workspace+$00b+(dycp_cnt*$60)+$30,y
		lda dycp_font+$201,x
		sta dycp_workspace+$00c+(dycp_cnt*$60)+$30,y
		lda dycp_font+$281,x
		sta dycp_workspace+$00d+(dycp_cnt*$60)+$30,y
		lda dycp_font+$301,x
		sta dycp_workspace+$00e+(dycp_cnt*$60)+$30,y
		lda dycp_font+$381,x
		sta dycp_workspace+$00f+(dycp_cnt*$60)+$30,y

		lda dycp_font+$401,x
		sta dycp_workspace+$010+(dycp_cnt*$60)+$30,y
		lda dycp_font+$481,x
		sta dycp_workspace+$011+(dycp_cnt*$60)+$30,y

		!set dycp_cnt=dycp_cnt+$01
} until dycp_cnt=$13

		ldy dycp_cos_work+$13
		ldx dycp_buffer+$13
		beq *+$5c-$1e

		lda dycp_font+$000,x
		sta dycp_workspace+$728+$00,y
		lda dycp_font+$080,x
		sta dycp_workspace+$729+$00,y
		lda dycp_font+$100,x
		sta dycp_workspace+$72a+$00,y
		lda dycp_font+$180,x
		sta dycp_workspace+$72b+$00,y
		lda dycp_font+$200,x
		sta dycp_workspace+$72c+$00,y
		lda dycp_font+$280,x
		sta dycp_workspace+$72d+$00,y
		lda dycp_font+$300,x
		sta dycp_workspace+$72e+$00,y
		lda dycp_font+$380,x
		sta dycp_workspace+$72f+$00,y

		lda dycp_font+$400,x
		sta dycp_workspace+$730+$00,y
		lda dycp_font+$480,x
		sta dycp_workspace+$731+$00,y

		rts
