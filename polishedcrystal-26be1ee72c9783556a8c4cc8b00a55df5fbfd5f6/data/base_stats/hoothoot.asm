	db HOOTHOOT ; 163

	db  60,  30,  30,  50,  36,  56
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, FLYING
	db 255 ; catch rate
	db 58 ; base exp
	db NO_ITEM ; item 1
	db NO_ITEM ; item 2
	db FEMALE_50 ; gender
	db 15 ; step cycles to hatch
	dn 5, 5 ; frontpic dimensions
	db INSOMNIA ; ability 1
	db KEEN_EYE ; ability 2
	db TINTED_LENS ; hidden ability
	db MEDIUM_FAST ; growth rate
	dn AVIAN, AVIAN ; egg groups

	; ev_yield
	ev_yield   1,   0,   0,   0,   0,   0
	;         hp, atk, def, spd, sat, sdf

	; tmhm
	tmhm CURSE, CALM_MIND, TOXIC, HIDDEN_POWER, SUNNY_DAY, PROTECT, RAIN_DANCE, RETURN, PSYCHIC, SHADOW_BALL, ROOST, DOUBLE_TEAM, REFLECT, SWIFT, AERIAL_ACE, SUBSTITUTE, FACADE, REST, ATTRACT, THIEF, STEEL_WING, ENDURE, FLASH, FLY, DOUBLE_EDGE, DREAM_EATER, HYPER_VOICE, SLEEP_TALK, SWAGGER, ZEN_HEADBUTT
	; end
