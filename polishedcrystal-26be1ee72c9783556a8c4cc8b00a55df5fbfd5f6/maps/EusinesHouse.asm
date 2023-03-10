EusinesHouse_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 0

EusinesHouse_MapEventHeader:

.Warps: db 2
	warp_def 7, 2, 14, CELADON_CITY
	warp_def 7, 3, 14, CELADON_CITY

.XYTriggers: db 0

.Signposts: db 0

.PersonEvents: db 2
	person_event SPRITE_EUSINE, 3, 2, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, CeladonEusine, EVENT_SET_WHEN_FOUGHT_HO_OH
	person_event SPRITE_GRAMPS, 3, 5, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, (1 << 3) | PAL_OW_BROWN, PERSONTYPE_SCRIPT, 0, EusinesHouseGrampsScript, -1

const_value set 2
	const EUSINESHOUSE_EUSINE

CeladonEusine:
	faceplayer
	opentext
	writetext CeladonEusineText1
	buttonsound
	special SpecialBeastsCheck
	iftrue .HoOh
	writetext EusineNoBeastsText
	waitbutton
	closetext
	writebyte RAIKOU
	special SpecialMonCheck
	iftrue .OwnRaikou
	showtext EusineShowsRaikouText
	refreshscreen
	pokepic RAIKOU
	cry RAIKOU
	waitbutton
	closepokepic
	writebyte RAIKOU
	special SpecialSeenMon
.OwnRaikou
	writebyte ENTEI
	special SpecialMonCheck
	iftrue .OwnEntei
	showtext EusineShowsEnteiText
	refreshscreen
	pokepic ENTEI
	cry ENTEI
	waitbutton
	closepokepic
	writebyte ENTEI
	special SpecialSeenMon
.OwnEntei
	writebyte SUICUNE
	special SpecialMonCheck
	iftrue .OwnSuicune
	showtext EusineShowsSuicuneText
	refreshscreen
	pokepic SUICUNE
	cry SUICUNE
	waitbutton
	closepokepic
	writebyte SUICUNE
	special SpecialSeenMon
.OwnSuicune
	jumptext EusineQuestHintText

.HoOh:
	writetext EusineLeavesCeladonText
	waitbutton
	closetext
	checkcode VAR_FACING
	if_not_equal UP, .PathClear
	applymovement PLAYER, .PlayerStepsAsideMovement
.PathClear:
	applymovement EUSINESHOUSE_EUSINE, .EusineLeavesMovement
	disappear EUSINESHOUSE_EUSINE
	playsound SFX_EXIT_BUILDING
	waitsfx
	end

.PlayerStepsAsideMovement:
	step_left
	turn_head_right
	step_end

.EusineLeavesMovement:
	step_down
	step_down
	step_down
	step_down
	step_end

EusinesHouseGrampsScript:
	checkevent EVENT_SET_WHEN_FOUGHT_HO_OH
	iftrue_jumptextfaceplayer EusinesHouseGrampsText2
	jumptextfaceplayer EusinesHouseGrampsText1

CeladonEusineText1:
	text "Eusine: Hi!"

	para "I'm back visiting"
	line "my hometown."

	para "It's been quite a"
	line "while."
	done

EusineLeavesCeladonText:
	text "<PLAYER>, have you"
	line "heard?"

	para "There have been"
	line "fresh rumors of a"

	para "rainbow-colored"
	line "#mon appearing"
	cont "at Bell Tower."

	para "I've just had my"
	line "party healed, so"

	para "now I'm headed to"
	line "Ecruteak."

	para "I'll be seeing"
	line "you, <PLAYER>!"
	done

EusineNoBeastsText:
	text "Oh, by the way,"
	line "<PLAYER>."

	para "Have you caught"
	line "the legendary"
	cont "beast #mon?"

	para "??????????????????"

	para "OK???"

	para "Let me give you"
	line "my research notes."
	done

EusineShowsRaikouText:
	text "This is Raikou:"
	done

EusineShowsEnteiText:
	text "This is Entei:"
	done

EusineShowsSuicuneText:
	text "This, of course,"
	line "is Suicune:"
	done

EusineQuestHintText:
	text "If you catch even"
	line "one, I hope that"
	cont "you'll inform me."

	para "I'm counting on"
	line "you, <PLAYER>!"
	done

EusinesHouseGrampsText1:
	text "My grandson came"
	line "home!"
	cont "I'm overjoyed!"
	done

EusinesHouseGrampsText2:
	text "My grandson Eusine"
	line "is in Johto,"

	para "searching far and"
	line "wide for Suicune."

	para "I taught him all"
	line "about the legend-"
	cont "ary #mon!"
	done
