	db AMPHAROS ; 181

if DEF(FAITHFUL)
	db  90,  75,  85,  55, 115,  90
	;   hp  atk  def  spd  sat  sdf
else
	db  90,  75,  85,  45, 125,  90
	;   hp  atk  def  spd  sat  sdf
endc

if DEF(FAITHFUL)
	db ELECTRIC, ELECTRIC
	db 45 ; catch rate
	db 194 ; base exp
else
	db ELECTRIC, DRAGON
	db 40 ; catch rate
	db 204 ; base exp
endc
	db NO_ITEM ; item 1
	db NO_ITEM ; item 2
	db FEMALE_50 ; gender
	db 20 ; step cycles to hatch
	dn 7, 7 ; frontpic dimensions
	db STATIC ; ability 1
	db STATIC ; ability 2
	db MOLD_BREAKER ; hidden ability
	db MEDIUM_SLOW ; growth rate
	dn MONSTER, FIELD ; egg groups

	; ev_yield
	ev_yield   0,   0,   0,   0,   3,   0
	;         hp, atk, def, spd, sat, sdf

	; tmhm
	tmhm DYNAMICPUNCH, CURSE, TOXIC, HIDDEN_POWER, HYPER_BEAM, LIGHT_SCREEN, PROTECT, RAIN_DANCE, SAFEGUARD, DRAGONBREATH, IRON_TAIL, THUNDERBOLT, THUNDER, RETURN, DOUBLE_TEAM, FLASH_CANNON, SWIFT, SUBSTITUTE, FACADE, WILD_CHARGE, REST, ATTRACT, ROCK_SMASH, FOCUS_BLAST, ENDURE, DRAGON_PULSE, GIGA_IMPACT, FLASH, VOLT_SWITCH, THUNDER_WAVE, BULLDOZE, STRENGTH, BODY_SLAM, COUNTER, DEFENSE_CURL, DOUBLE_EDGE, FIRE_PUNCH, HEADBUTT, SEISMIC_TOSS, SLEEP_TALK, SWAGGER, THUNDERPUNCH, ZAP_CANNON
	; end
