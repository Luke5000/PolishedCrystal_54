	db JIGGLYPUFF ; 039

	db 115,  45,  20,  20,  45,  25
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, FAIRY
	db 170 ; catch rate
	db 76 ; base exp
	db ORAN_BERRY ; item 1
	db ORAN_BERRY ; item 2
	db FEMALE_75 ; gender
	db 10 ; step cycles to hatch
	dn 5, 5 ; frontpic dimensions
	db CUTE_CHARM ; ability 1
	db COMPETITIVE ; ability 2
if DEF(FAITHFUL)
	db FRISK ; hidden ability
else
	db SOUNDPROOF ; hidden ability
endc
	db FAST ; growth rate
	dn FAERY, FAERY ; egg groups

	; ev_yield
	ev_yield   2,   0,   0,   0,   0,   0
	;         hp, atk, def, spd, sat, sdf

	; tmhm
	tmhm DYNAMICPUNCH, CURSE, TOXIC, HIDDEN_POWER, SUNNY_DAY, ICE_BEAM, BLIZZARD, LIGHT_SCREEN, PROTECT, RAIN_DANCE, SAFEGUARD, SOLAR_BEAM, THUNDERBOLT, THUNDER, RETURN, DIG, PSYCHIC, SHADOW_BALL, DOUBLE_TEAM, REFLECT, FLAMETHROWER, FIRE_BLAST, SUBSTITUTE, FACADE, WILD_CHARGE, REST, ATTRACT, ENDURE, DAZZLINGLEAM, WATER_PULSE, FLASH, THUNDER_WAVE, STRENGTH, BODY_SLAM, COUNTER, DEFENSE_CURL, DOUBLE_EDGE, DREAM_EATER, FIRE_PUNCH, HEADBUTT, HYPER_VOICE, ICE_PUNCH, ICY_WIND, KNOCK_OFF, ROLLOUT, SEISMIC_TOSS, SLEEP_TALK, SWAGGER, THUNDERPUNCH, ZAP_CANNON
	; end
