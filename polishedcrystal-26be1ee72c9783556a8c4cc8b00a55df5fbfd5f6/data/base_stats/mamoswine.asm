	db MAMOSWINE ; 473

	db 110, 130,  80,  80,  70,  60
	;   hp  atk  def  spd  sat  sdf

	db ICE, GROUND
	db 50 ; catch rate
	db 207 ; base exp
	db RAWST_BERRY ; item 1
	db NEVERMELTICE ; item 2
	db FEMALE_50 ; gender
	db 20 ; step cycles to hatch
	dn 7, 7 ; frontpic dimensions
	db OBLIVIOUS ; ability 1
	db SNOW_CLOAK ; ability 2
	db THICK_FAT ; hidden ability
	db SLOW ; growth rate
	dn FIELD, FIELD ; egg groups

	; ev_yield
	ev_yield   0,   3,   0,   0,   0,   0
	;         hp, atk, def, spd, sat, sdf

	; tmhm
	tmhm CURSE, CALM_MIND, ROAR, TOXIC, HAIL, HIDDEN_POWER, ICE_BEAM, BLIZZARD, HYPER_BEAM, LIGHT_SCREEN, PROTECT, RAIN_DANCE, EARTHQUAKE, RETURN, DIG, DOUBLE_TEAM, REFLECT, SANDSTORM, SUBSTITUTE, FACADE, REST, ATTRACT, ROCK_SLIDE, FURY_CUTTER, ROCK_SMASH, ENDURE, AVALANCHE, GIGA_IMPACT, STONE_EDGE, BULLDOZE, STRENGTH, EARTH_POWER, HEADBUTT, ICY_WIND, IRON_HEAD, KNOCK_OFF, SLEEP_TALK, SWAGGER
	; end
