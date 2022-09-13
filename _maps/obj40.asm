; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_ITBDr:	
		dc.w SME_ITBDr_E-SME_ITBDr, SME_ITBDr_23-SME_ITBDr	
		dc.w SME_ITBDr_38-SME_ITBDr, SME_ITBDr_52-SME_ITBDr	
		dc.w SME_ITBDr_58-SME_ITBDr, SME_ITBDr_5E-SME_ITBDr	
		dc.w SME_ITBDr_64-SME_ITBDr	
SME_ITBDr_E:	dc.b 4	
		dc.b $F0, $D, 0, 0, $EC	
		dc.b 0, $C, 0, 8, $EC	
		dc.b $F8, 1, 0, $C, $C	
		dc.b 8, 8, 0, $E, $F4	
SME_ITBDr_23:	dc.b 4	
		dc.b $F1, $D, 0, 0, $EC	
		dc.b 1, $C, 0, 8, $EC	
		dc.b $F9, 1, 0, $C, $C	
		dc.b 9, 8, 0, $11, $F4	
SME_ITBDr_38:	dc.b 5	
		dc.b $F0, $D, 0, 0, $EC	
		dc.b 0, $C, 0, $14, $EC	
		dc.b $F8, 1, 0, $C, $C	
		dc.b 8, 4, 0, $18, $EC	
		dc.b 8, 4, 0, $12, $FC	
SME_ITBDr_52:	dc.b 1	
		dc.b $FA, 0, 0, $1A, $10	
SME_ITBDr_58:	dc.b 1	
		dc.b $FA, 0, 0, $1B, $10	
SME_ITBDr_5E:	dc.b 1	
		dc.b $FA, 0, 0, $1C, $10	
SME_ITBDr_64:	dc.b 0	
		even