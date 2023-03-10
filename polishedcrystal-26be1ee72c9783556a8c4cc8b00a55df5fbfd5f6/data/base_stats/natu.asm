	db NATU ; 177

	db  40,  50,  45,  70,  70,  45
	;   hp  atk  def  spd  sat  sdf

	db PSYCHIC, FLYING
	db 190 ; catch rate
	db 73 ; base exp
	db NO_ITEM ; item 1
	db NO_ITEM ; item 2
	db FEMALE_50 ; gender
	db 20 ; step cycles to hatch
	dn 5, 5 ; frontpic dimensions
	db SYNCHRONIZE ; ability 1
	db EARLY_BIRD ; ability 2
	db MAGIC_BOUNCE ; hidden ability
	db MEDIUM_FAST ; growth rate
	dn AVIAN, AVIAN ; egg groups

	; ev_yield
	ev_yield   0,   0,   0,   0,   1,   0
	;         hp, atk, def, spd, sat, sdf

	; tmhm
	tmhm CURSE, CALM_MIND, TOXIC, HIDDEN_POWER, SUNNY_DAY, LIGHT_SCREEN, PROTECT, RAIN_DANCE, GIGA_DRAIN, SOLAR_BEAM, RETURN, PSYCHIC, SHADOW_BALL, ROOST, DOUBLE_TEAM, REFLECT, SWIFT, AERIAL_ACE, SUBSTITUTE, FACADE, REST, ATTRACT, THIEF, STEEL_WING, ENDURE, DAZZLINGLEAM, U_TURN, FLASH, THUNDER_WAVE, DOUBLE_EDGE, DREAM_EATER, SKILL_SWAP, SLEEP_TALK, SUCKER_PUNCH, SWAGGER, TRICK, ZEN_HEADBUTT
	; end
