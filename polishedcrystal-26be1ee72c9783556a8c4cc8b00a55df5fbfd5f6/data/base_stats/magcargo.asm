	db MAGCARGO ; 219

if DEF(FAITHFUL)
	db  60,  50, 120,  30,  90,  80
	;   hp  atk  def  spd  sat  sdf
else
	db  60,  50, 135,  30, 115, 115
	;   hp  atk  def  spd  sat  sdf
endc

	db FIRE, ROCK
	db 75 ; catch rate
if DEF(FAITHFUL)
	db 154 ; base exp
else
	db 171 ; base exp
endc
	db NO_ITEM ; item 1
	db NO_ITEM ; item 2
	db FEMALE_50 ; gender
	db 20 ; step cycles to hatch
	dn 6, 6 ; frontpic dimensions
	db MAGMA_ARMOR ; ability 1
	db FLAME_BODY ; ability 2
	db WEAK_ARMOR ; hidden ability
	db MEDIUM_FAST ; growth rate
	dn AMORPHOUS, AMORPHOUS ; egg groups

	; ev_yield
	ev_yield   0,   0,   2,   0,   0,   0
	;         hp, atk, def, spd, sat, sdf

	; tmhm
	tmhm CURSE, CALM_MIND, TOXIC, HIDDEN_POWER, SUNNY_DAY, HYPER_BEAM, LIGHT_SCREEN, PROTECT, SOLAR_BEAM, EARTHQUAKE, RETURN, DOUBLE_TEAM, REFLECT, FLAMETHROWER, SANDSTORM, FIRE_BLAST, SUBSTITUTE, FACADE, REST, ATTRACT, ROCK_SLIDE, ROCK_SMASH, ENDURE, WILL_O_WISP, EXPLOSION, GIGA_IMPACT, STONE_EDGE, BULLDOZE, STRENGTH, BODY_SLAM, DEFENSE_CURL, DOUBLE_EDGE, EARTH_POWER, ROLLOUT, SLEEP_TALK, SWAGGER
	; end
