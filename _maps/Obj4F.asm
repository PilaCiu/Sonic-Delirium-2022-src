;===============================================================================
; Object 4F - Splats
; Ported by Iso Kilo, animation handling by cadevero
;===============================================================================
Obj4F:  ; Standard object index initialization
        moveq   #0,d0   ; Clear d0 (Quicker than a clr command)
        move.b  $24(a0),d0      ; Load routine counter into d0
        move.w  Obj4F_Index(pc,d0),d1   ; Load routine index with program counter+d0 into d1
        jmp     Obj4F_Index(pc,d1)      ; Jump to the routine index with program counter+d1

;-------------------------------------------------------------------------------
Obj4F_Index:
        dc.w    Obj4F_Init-Obj4F_Index  ; Object initialization
        dc.w    Obj4F_Action-Obj4F_Index        ; Bouncing and turning
        dc.w    Obj4F_Bounce2-Obj4F_Index       ; Handles bouncing animation
;-------------------------------------------------------------------------------
Obj4F_Init:
        move.l  #Map_Obj4F,4(a0)        ; Load mappings
        move.w  #$448,2(a0)     ; VRAM settings
        move.b  #4,1(a0)        ; Render settings
        move.b  #4,$18(a0)      ; Sprite priority
        move.b  #$15,$19(a0)    ; Action width
        move.b  #$13,$16(a0)    ; Vertical hitbox (Divided by 2)
        move.b  #$B,$17(a0)     ; Horizontal hitbox (Divided by 2)
        move.b  #$C,$20(a0)
        addq.b  #2,$24(a0)      ; Obj4F_Action
        move.b  #$40,$26(a0)
        move.w  #$FF00,$10(a0)  ; X Speed
        move.w  #$100,$12(a0)   ; Y Speed
        rts                                                            
;-------------------------------------------------------------------------------
Obj4F_Action:
        bsr     ObjectFall      ; Falling routine
        bsr     Obj4F_ChkLeftWall       ; Collision checking
        bra     MarkObjGone

Obj4F_ChkLeftWall:
        moveq   #0,d3   ; Clear d3
        move.b  $19(a0),d3      ; Load sprite width into d3
        tst.w   $10(a0) ; Check if X speed is positive
        bpl.s   Obj4F_ChkRightWall      ; If so, branch and check for the right wall
        neg.w   d3      ; Negate sprite width (To turn it around)
        bsr     ObjHitWallLeft  ; Check for the left wall
        tst.w   d1      ; Check if Splats is touching a wall
        bmi.s   Obj4F_TurnAround        ; If so, branch and turn it around
        move.w  8(a0),d1
        subi.w  #$C,d1
        bgt.s   Obj4F_Bounce
        bra.s   Obj4F_TurnAround        ; Branch to the turn around routine

Obj4F_ChkRightWall:
        bsr     ObjHitWallRight ; Check for the right wall
        tst.w   d1      ; Check if Splats is touching a wall
        bmi.s   Obj4F_TurnAround        ; If so, branch and turn it around
        move.w  ($FFFFF72A).w,d1        ; Load right side boundary into d1
        subi.w  #$C,d1  ; Subtract $C from right side boundary
        sub.w   8(a0),d1        ; Subtract X position from right side boundary
        bgt.s   Obj4F_Bounce    ; If X position is greater than the result, bounce

Obj4F_TurnAround:
        add.w   d1,8(a0)
        neg.w   $10(a0) ; Negate X speed
        bchg    #0,$22(a0)      ; Flip left/right status
        bchg    #0,1(a0)        ; Flip mirrored bit in render flag

Obj4F_Bounce:
        bsr.w   ObjHitFloor     ; Check if Splats is touching the floor
        tst.w   d1
        bpl.s   @return ; If not, branch
        add.w   d1,$C(a0)
        move.w  #$FA00,$12(a0)
        addq.b  #2,$24(a0) ; Make sure it only executes Obj4F_Bounce2 next frame
        rts

Obj4F_Bounce2:
        move.b  #1,$1A(a0) ; Switch to frame 1
        move.b  #$1C,$1E(a0) ; Set counter to frame 0
        subq.b  #2,$24(a0) ; Go back to regular routine
        jmp     DisplaySprite   ; Display art

@return:
        rts     ; Return

;===============================================================================
; Splats Mappings
;===============================================================================

Map_Obj4F:
        include "_maps\Obj4F.asm"
