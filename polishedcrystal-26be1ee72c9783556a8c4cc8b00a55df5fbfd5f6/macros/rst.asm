FarCall    EQU $08
Bankswitch EQU $10
JumpTable  EQU $28
Predef     EQU $30

farcall: MACRO ; bank, address
	rst FarCall
	dbw BANK(\1), \1
	ENDM

farjp: MACRO ; bank, address
	rst FarCall
	dbw BANK(\1) | $80, \1
	ENDM
