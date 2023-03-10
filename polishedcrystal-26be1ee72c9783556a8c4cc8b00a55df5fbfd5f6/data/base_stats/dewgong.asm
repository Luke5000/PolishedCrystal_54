	db DEWGONG ; 087

if DEF(FAITHFUL)
	db  90,  70,  80,  70,  70,  95
	;   hp  atk  def  spd  sat  sdf
else
	db  90,  70,  80,  70,  80,  95
	;   hp  atk  def  spd  sat  sdf
endc

	db WATER, ICE
	db 75 ; catch rate
	db 176 ; base exp
	db RAWST_BERRY ; item 1
	db NEVERMELTICE ; item 2
	db FEMALE_50 ; gender
	db 20 ; step cycles to hatch
	dn 7, 7 ; frontpic dimensions
	db THICK_FAT ; ability 1
	db HYDRATION ; ability 2
	db ICE_BODY ; hidden ability
	db MEDIUM_FAST ; growth rate
	dn AMPHIBIAN, FIELD ; egg groups

	; ev_yield
	ev_yield   0,   0,   0,   0,   0,   2
	;         hp, atk, def, spd, sat, sdf

	; tmhm
	tmhm CURSE, TOXIC, HAIL, HIDDEN_POWER, ICE_BEAM, BLIZZARD, HYPER_BEAM, PROTECT, RAIN_DANCE, SAFEGUARD, IRON_TAIL, RETURN, DOUBLE_TEAM, SUBSTITUTE, FACADE, REST, ATTRACT, THIEF, ENDURE, WATER_PULSE, AVALANCHE, GIGA_IMPACT, SURF, WHIRLPOOL, WATERFALL, AQUA_TAIL, BODY_SLAM, DOUBLE_EDGE, HEADBUTT, ICY_WIND, PAY_DAY, SLEEP_TALK, SWAGGER
	; end
