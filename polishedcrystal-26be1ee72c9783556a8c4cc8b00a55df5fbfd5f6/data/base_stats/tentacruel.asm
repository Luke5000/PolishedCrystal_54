	db TENTACRUEL ; 073

	db  80,  70,  65, 100,  80, 120
	;   hp  atk  def  spd  sat  sdf

	db WATER, POISON
	db 60 ; catch rate
	db 205 ; base exp
	db NO_ITEM ; item 1
	db POISON_BARB ; item 2
	db FEMALE_50 ; gender
	db 20 ; step cycles to hatch
	dn 6, 6 ; frontpic dimensions
	db CLEAR_BODY ; ability 1
	db LIQUID_OOZE ; ability 2
	db RAIN_DISH ; hidden ability
	db SLOW ; growth rate
	dn INVERTEBRATE, INVERTEBRATE ; egg groups

	; ev_yield
	ev_yield   0,   0,   0,   0,   0,   2
	;         hp, atk, def, spd, sat, sdf

	; tmhm
	tmhm CURSE, TOXIC, HAIL, HIDDEN_POWER, ICE_BEAM, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, GIGA_DRAIN, SAFEGUARD, RETURN, DOUBLE_TEAM, SLUDGE_BOMB, SUBSTITUTE, FACADE, REST, ATTRACT, THIEF, LEECH_LIFE, SCALD, ENDURE, DAZZLINGLEAM, WATER_PULSE, POISON_JAB, GIGA_IMPACT, SWORDS_DANCE, CUT, SURF, WHIRLPOOL, WATERFALL, DOUBLE_EDGE, ICY_WIND, KNOCK_OFF, SLEEP_TALK, SWAGGER
	; end
