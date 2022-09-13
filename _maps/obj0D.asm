; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_Kjd8e:	
		dc.w SME_Kjd8e_A-SME_Kjd8e, SME_Kjd8e_1A-SME_Kjd8e	
		dc.w SME_Kjd8e_25-SME_Kjd8e, SME_Kjd8e_30-SME_Kjd8e	
		dc.w SME_Kjd8e_3B-SME_Kjd8e	
SME_Kjd8e_A:	dc.b 3	
		dc.b $F0, $B, 0, 0, $E8	
		dc.b $F0, $B, 8, 0, 0	
		dc.b $10, 1, 0, $38, $FC	
SME_Kjd8e_1A:	dc.b 2	
		dc.b $F0, $F, 0, $C, $F0	
		dc.b $10, 1, 0, $38, $FC	
SME_Kjd8e_25:	dc.b 2	
		dc.b $F0, 3, 0, $1C, $FC	
		dc.b $10, 1, 8, $38, $FC	
SME_Kjd8e_30:	dc.b 2	
		dc.b $F0, $F, 8, $C, $F0	
		dc.b $10, 1, 8, $38, $FC	
SME_Kjd8e_3B:	dc.b 3	
		dc.b $F0, $B, 0, $20, $E8	
		dc.b $F0, $B, 0, $2C, 0	
		dc.b $10, 1, 0, $38, $FC	
		even