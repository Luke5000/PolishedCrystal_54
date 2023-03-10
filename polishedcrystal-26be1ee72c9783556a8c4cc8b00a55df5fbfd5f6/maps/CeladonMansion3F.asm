CeladonMansion3F_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 0

CeladonMansion3F_MapEventHeader:

.Warps: db 4
	warp_def 0, 0, 1, CELADON_MANSION_ROOF
	warp_def 0, 1, 2, CELADON_MANSION_2F
	warp_def 0, 6, 3, CELADON_MANSION_2F
	warp_def 0, 7, 2, CELADON_MANSION_ROOF

.XYTriggers: db 0

.Signposts: db 4
	signpost 8, 5, SIGNPOST_UP, MapCeladonMansion3FSignpost0Script
	signpost 3, 4, SIGNPOST_UP, MapCeladonMansion3FSignpost1Script
	signpost 6, 1, SIGNPOST_UP, MapCeladonMansion3FSignpost2Script
	signpost 3, 1, SIGNPOST_UP, MapCeladonMansion3FSignpost3Script

.PersonEvents: db 4
	person_event SPRITE_COOLTRAINER_M, 6, 3, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_SCRIPT, 0, CooltrainerMScript_0x71670, -1
	person_event SPRITE_GYM_GUY, 4, 3, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_COMMAND, jumptextfaceplayer, UnknownText_0x717b4, -1
	person_event SPRITE_SUPER_NERD, 7, 0, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_COMMAND, jumptextfaceplayer, UnknownText_0x71895, -1
	person_event SPRITE_FISHER, 4, 0, SPRITEMOVEDATA_STANDING_UP, 0, 2, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_COMMAND, jumptextfaceplayer, UnknownText_0x718ca, -1

CooltrainerMScript_0x71670:
	faceplayer
	opentext
	writetext UnknownText_0x716ce
	checkcode VAR_DEXCAUGHT
	if_greater_than 252, UnknownScript_0x7167e
	waitendtext

UnknownScript_0x7167e:
	buttonsound
	writetext UnknownText_0x71725
	playsound SFX_DEX_FANFARE_230_PLUS
	waitsfx
	writetext UnknownText_0x71760
	buttonsound
	special Diploma
	jumpopenedtext UnknownText_0x71763

MapCeladonMansion3FSignpost0Script:
	jumptext UnknownText_0x7190b

MapCeladonMansion3FSignpost1Script:
	jumptext UnknownText_0x71928

MapCeladonMansion3FSignpost2Script:
	jumptext UnknownText_0x71952

MapCeladonMansion3FSignpost3Script:
	jumptext UnknownText_0x71996

UnknownText_0x716ce:
	text "Is that right?"

	para "I'm the Game"
	line "Designer!"

	para "Filling up your"
	line "#dex is tough,"
	cont "but don't give up!"
	done

UnknownText_0x71725:
	text "Wow! Excellent!"
	line "You completed your"
	cont "#dex!"

	para "Congratulations!"
	done

UnknownText_0x71760:
	text "???"
	done

UnknownText_0x71763:
	text "The Graphic Artist"
	line "will print out a"
	cont "Diploma for you."

	para "You should go show"
	line "it off."
	done

UnknownText_0x717b4:
	text "I'm the Graphic"
	line "Artist."

	para "I drew you!"
	done

UnknownText_0x71895:
	text "Who, me? I'm the"
	line "Programmer."

	para "Use the Wonder"
	line "Trade Hub!"
	done

UnknownText_0x718ca:
	text "Isn't Lyra"
	line "adorable?"

	para "Jasmine's pretty"
	line "too."

	para "Oh, I love them!"
	done

UnknownText_0x7190b:
	text "GAME FREAK"
	line "Development Room"
	done

UnknownText_0x71928:
	text "It's a detailed"
	line "drawing of a"
	cont "pretty girl."
	done

UnknownText_0x71952:
	text "It's the game"
	line "program. Messing"

	para "with it could put"
	line "a bug in the game!"
	done

UnknownText_0x71996:
	text "It's crammed with"
	line "reference materi-"
	cont "als. There's even"
	cont "a # Doll."
	done
