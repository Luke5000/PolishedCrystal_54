VioletGym_MapScriptHeader:

.MapTriggers: db 1
	dw VioletGymTrigger0

.MapCallbacks: db 0

VioletGym_MapEventHeader:

.Warps: db 2
	warp_def 15, 4, 2, VIOLET_CITY
	warp_def 15, 5, 2, VIOLET_CITY

.XYTriggers: db 0

.Signposts: db 2
	signpost 13, 3, SIGNPOST_READ, VioletGymStatue
	signpost 13, 6, SIGNPOST_READ, VioletGymStatue

.PersonEvents: db 5
	person_event SPRITE_GYM_GUY, 13, 4, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_SCRIPT, 0, ObjectEvent, EVENT_DARK_CAVE_FALKNER
	person_event SPRITE_FALKNER, 1, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_SCRIPT, 0, FalknerScript_0x683c2, EVENT_VIOLET_GYM_FALKNER
	person_event SPRITE_YOUNGSTER, 6, 7, SPRITEMOVEDATA_STANDING_LEFT, 0, 2, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 3, TrainerBird_keeperRod, EVENT_VIOLET_GYM_FALKNER
	person_event SPRITE_YOUNGSTER, 10, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 2, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 3, TrainerBird_keeperAbe, EVENT_VIOLET_GYM_FALKNER
	person_event SPRITE_GYM_GUY, 13, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_SCRIPT, 0, VioletGymGuyScript, EVENT_VIOLET_GYM_FALKNER

const_value set 2
	const VIOLETGYM_GYM_GUY2

VioletGymTrigger0:
	priorityjump VioletGymFalknerAwayScript
	end

VioletGymFalknerAwayScript:
	showemote EMOTE_SHOCK, VIOLETGYM_GYM_GUY2, 15
	applymovement VIOLETGYM_GYM_GUY2, VioletGymMovementData_GymGuyStepDown
	showtext VioletGymGuyFalknerAwayText
	spriteface PLAYER, DOWN
	pause 10
	special FadeOutPalettes
	playsound SFX_ENTER_DOOR
	waitsfx
	warp VIOLET_CITY, 18, 22
	end

FalknerScript_0x683c2:
	faceplayer
	opentext
	checkevent EVENT_BEAT_FALKNER
	iftrue .FightDone
	writetext UnknownText_0x68473
	waitbutton
	closetext
	winlosstext UnknownText_0x6854a, 0
	loadtrainer FALKNER, 1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_FALKNER
	opentext
	writetext UnknownText_0x685af
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_ZEPHYRBADGE
.FightDone:
	checkevent EVENT_GOT_TM31_ROOST
	iftrue .SpeechAfterTM
	setevent EVENT_BEAT_BIRD_KEEPER_ROD
	setevent EVENT_BEAT_BIRD_KEEPER_ABE
	domaptrigger ELMS_LAB, $2
	specialphonecall SPECIALCALL_ASSISTANT
	writetext UnknownText_0x685c8
	buttonsound
	verbosegivetmhm TM_ROOST
	setevent EVENT_GOT_TM31_ROOST
	jumpopenedtext UnknownText_0x68648

.SpeechAfterTM:
	jumpopenedtext UnknownText_0x68735

TrainerBird_keeperRod:
	trainer EVENT_BEAT_BIRD_KEEPER_ROD, BIRD_KEEPER, ROD, Bird_keeperRodSeenText, Bird_keeperRodBeatenText, 0, Bird_keeperRodScript

Bird_keeperRodScript:
	end_if_just_battled
	jumptextfaceplayer UnknownText_0x68837

TrainerBird_keeperAbe:
	trainer EVENT_BEAT_BIRD_KEEPER_ABE, BIRD_KEEPER, ABE, Bird_keeperAbeSeenText, Bird_keeperAbeBeatenText, 0, Bird_keeperAbeScript

Bird_keeperAbeScript:
	end_if_just_battled
	jumptextfaceplayer UnknownText_0x688c7

VioletGymGuyScript:
	checkevent EVENT_BEAT_FALKNER
	iftrue_jumptextfaceplayer VioletGymGuyWinText
	jumptextfaceplayer VioletGymGuyText

VioletGymStatue:
	trainertotext FALKNER, 1, $1
	checkflag ENGINE_ZEPHYRBADGE
	iftrue .Beaten
	jumpstd gymstatue1
.Beaten:
	checkcode VAR_BADGES
	if_greater_than 8, .LyraToo
	jumpstd gymstatue2
.LyraToo
	jumpstd gymstatue3

VioletGymMovementData_GymGuyStepDown:
	step_down
	step_end

UnknownText_0x68473:
	text "I'm Falkner, the"
	line "Violet #mon Gym"
	cont "Leader!"

	para "People say you can"
	line "clip Flying-type"

	para "#mon's wings"
	line "with a jolt of"
	cont "electricity???"

	para "I won't allow such"
	line "insults to bird"
	cont "#mon!"

	para "I'll show you the"
	line "real power of the"

	para "magnificent bird"
	line "#mon!"
	done

UnknownText_0x6854a:
	text "???Darn! My dad's"
	line "cherished bird"
	cont "#mon???"

	para "All right."
	line "Take this."

	para "It's the official"
	line "#mon League"
	cont "Zephyr Badge."
	done

UnknownText_0x685af:
	text "<PLAYER> received"
	line "the Zephyr Badge."
	done

UnknownText_0x685c8:
	text "The Zephyr Badge"
	line "enables you to"

	para "command #mon,"
	line "even traded ones,"
	cont "up to <LV>20."

	para "Here--take this"
	line "too."
	done

UnknownText_0x68648:
	text "By using a TM, a"
	line "#mon will"

	para "instantly learn a"
	line "new move."

	para "A TM can be used"
	line "as many times as"
	cont "you want."

	para "TM31 contains"
	line "Roost."

	para "It lands on the"
	line "ground to restore"
	cont "half the max HP."
	done

UnknownText_0x68735:
	text "There are #mon"
	line "Gyms in cities and"
	cont "towns ahead."

	para "You should test"
	line "your skills at"
	cont "these Gyms."

	para "I'm going to train"
	line "harder to become"

	para "the greatest bird"
	line "master!"
	done

Bird_keeperRodSeenText:
	text "The keyword is"
	line "guts!"

	para "Those here are"
	line "training night and"

	para "day to become bird"
	line "#mon masters."

	para "Come on!"
	done

Bird_keeperRodBeatenText:
	text "Gaaah!"
	done

UnknownText_0x68837:
	text "Falkner's skills"
	line "are for real!"

	para "Don't get cocky"
	line "just because you"
	cont "beat me!"
	done

Bird_keeperAbeSeenText:
	text "Let me see if you"
	line "are good enough to"
	cont "face Falkner!"
	done

Bird_keeperAbeBeatenText:
	text "This can't be"
	line "true!"
	done

UnknownText_0x688c7:
	text "This is pathetic,"
	line "losing to some"
	cont "rookie trainer???"
	done

VioletGymGuyText:
	text "Hey! I'm no train-"
	line "er but I can give"
	cont "some advice!"

	para "Believe me!"
	line "If you believe, a"

	para "championship dream"
	line "can come true."

	para "You believe?"
	line "Then listen."

	para "The Grass-type is"
	line "weak against the"

	para "Flying-type. Keep"
	line "this in mind."
	done

VioletGymGuyWinText:
	text "Nice battle! Keep"
	line "it up, and you'll"

	para "be the Champ in no"
	line "time at all!"
	done

VioletGymGuyFalknerAwayText:
	text "Hey! You can't"
	line "challenge Falkner"
	cont "right now."

	para "He's in Dark Cave"
	line "taming an Ursa-"

	para "ring that attacked"
	line "a young trainer."

	para "Come back later."
	done
