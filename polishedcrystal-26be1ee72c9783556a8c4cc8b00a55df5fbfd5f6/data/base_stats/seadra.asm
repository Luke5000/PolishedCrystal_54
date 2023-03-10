	db SEADRA ; 117

	db  55,  65,  95,  85,  95,  45
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER
	db 75 ; catch rate
	db 155 ; base exp
	db NO_ITEM ; item 1
	db DRAGON_SCALE ; item 2
	db FEMALE_50 ; gender
	db 20 ; step cycles to hatch
	dn 6, 6 ; frontpic dimensions
	db POISON_POINT ; ability 1
	db SNIPER ; ability 2
	db DAMP ; hidden ability
	db MEDIUM_FAST ; growth rate
	dn AMPHIBIAN, REPTILE ; egg groups

	; ev_yield
	ev_yield   0,   0,   1,   0,   1,   0
	;         hp, atk, def, spd, sat, sdf

	; tmhm
	tmhm CURSE, TOXIC, HAIL, HIDDEN_POWER, ICE_BEAM, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, DRAGONBREATH, RETURN, DOUBLE_TEAM, FLASH_CANNON, SWIFT, SUBSTITUTE, FACADE, REST, ATTRACT, SCALD, ENDURE, DRAGON_PULSE, WATER_PULSE, GIGA_IMPACT, SURF, WHIRLPOOL, WATERFALL, DOUBLE_EDGE, HEADBUTT, ICY_WIND, SLEEP_TALK, SWAGGER
	; end
