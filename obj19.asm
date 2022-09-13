; ---------------------------------------------------------------------------
; Object 19 - GHZ rolling ball
; ---------------------------------------------------------------------------

Obj19:
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	Ob19_Index(pc,d0.w),d1
		jsr	Ob19_Index(pc,d1.w)
		move.w	8(a0),d0
		andi.w	#$FF80,d0
		move.w	($FFFFF700).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0
		cmpi.w	#$280,d0
		bhi.w	DeleteObject
		rts
; ===========================================================================
Ob19_Index:	dc.w Ob19_Main-Ob19_Index
		dc.w Ob19_Waiting-Ob19_Index
		dc.w Ob19_Moving-Ob19_Index
; ===========================================================================
Ob19_Main:
		; Increment routine
		addq.b	#2,$24(a0) ; Ob19_Waiting
		
		; Initialize graphics, and other properties
		move.l	#Map_Obj48,4(a0)
		move.w	#$43AA,2(a0)
		move.b	#4,1(a0)
		move.b	#20,$19(a0)
		move.b	#5,$18(a0)
		
		; Initialize collision size
		move.b	#9,$17(a0)
		move.b	#24,$16(a0)
		
Ob19_Waiting:
		; Line up with floor
		jsr	(ObjHitFloor).l
		add.w	d1,$C(a0)
		
		; Check if Sonic is to the right of us yet, and start moving if so
		move.w	($FFFFD008).w,d0
		cmp.w	8(a0),d0
		blt.s	@left
		addq.b	#2,$24(a0) ; Ob19_Moving
		move.w	#$80,$14(a0)
		
@left:
		; Act as solid
		move.w	8(a0),d4
		bsr.w	Ob19_Animate
		bra.s	Ob19_Solid
		
; ===========================================================================
Ob19_Moving:
		; Remember our original x-position for solid stuff
		move.w	8(a0),d4
		
		; Get pushed by floor below us
		jsr		(Ob19_RollRepel).l
		
		; Set our velocity from our inertia and angle
		move.b	$26(a0),d0
		jsr	(CalcSine).l
		muls.w	$14(a0),d1
		asr.l	#8,d1
		move.w	d1,$10(a0)
		muls.w	$14(a0),d0
		asr.l	#8,d0
		move.w	d0,$12(a0)
		
		jsr		(SpeedToPos).l
		
		; Collision
		bsr.s	Ob19_Animate
		bsr.s	Ob19_Collide
		
; = Player collision routine ================================================
Ob19_Solid: ; d4 must be our x-position before moving
		; Object solidity
		move.w	#34,d1 ; Add 10, Sonic's width
		move.w	#24,d2
		move.w	#24,d3
		jsr	SolidObject
		
		; Draw and unload once off-screen
		bra.w	DisplaySprite
			
; = Level collision routine =================================================
Ob19_Collide:
		; Remember d4
		move.w	d4,-(sp)
		
		; Check for floor collision
		jsr	(loc_14602).l
		
@nofall:
		; Restore d4
		move.w	(sp)+,d4
		rts

; = Slope gravity speed =====================================================
Ob19_RollRepel:
		move.b	$26(a0),d0
		jsr	(CalcSine).l
		muls.w	#$30,d0
		asr.l	#8,d0
		add.w	d0,$14(a0)
		rts
		
; = Animation routine =======================================================
			even
Ob19_AnimN: dc.b 1, 1, 1
			even
Ob19_AnimR:	dc.b 1, 2, 3
			even
Ob19_AnimL:	dc.b 3, 2, 1
			even

Ob19_Animate:
		; Wait for next frame
		subq.b	#1,$1E(a0)	; subtract 1 from frame duration
		bpl.s	@postanimate		; if time remains, branch to post animate
		
		; Get our speed factor
		move.w	$14(a0),d0
		bmi.s	@nonegspeed
		neg.w	d0
@nonegspeed:
		addi.w	#$400,d0
		bpl.s	@nocap
		moveq	#0,d0
@nocap:
	
		; Apply to our frame duration
		lsr.w	#7,d0
		move.b	d0,$1E(a0)
	
		; Go to next frame
		addi.b	#1,$1B(a0)
		cmpi.b	#3,$1B(a0)
		blt.s	@postanimate
		move.w	#0,$1B(a0)
@postanimate:
		
		; Get our appropriate animation
		tst.w	$14(a0)
		beq.s	@still
		bmi.s	@left
		lea	(Ob19_AnimR).l,a1
		bra.s	@loadframe
@left:
		lea	(Ob19_AnimL).l,a1
		bra.s	@loadframe
@still:
		lea	(Ob19_AnimN).l,a1
		
@loadframe:
		; Copy our animation frame
		moveq	#0,d0
		move.b	$1B(a0),d0
		move.b	(a1,d0.w),$1A(a0)
		
		; Check if we should blink
		btst	#0,($FFFFFE0F).w
		beq.s	@noblink
		move.b	#0,$1A(a0)
@noblink:
		rts
		