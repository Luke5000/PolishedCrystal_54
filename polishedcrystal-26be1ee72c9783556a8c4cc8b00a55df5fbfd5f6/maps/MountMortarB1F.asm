MountMortarB1F_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 0

MountMortarB1F_MapEventHeader:

.Warps: db 2
	warp_def 3, 3, 5, MOUNT_MORTAR_1F_INSIDE
	warp_def 29, 19, 7, MOUNT_MORTAR_1F_OUTSIDE

.XYTriggers: db 0

.Signposts: db 1
	signpost 6, 4, SIGNPOST_ITEM + MAX_REVIVE, EVENT_MOUNT_MORTAR_B1F_HIDDEN_MAX_REVIVE

.PersonEvents: db 8
	person_event SPRITE_POKEFAN_M, 31, 11, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BROWN, PERSONTYPE_SCRIPT, 0, MountMortarB1FHikerScript, -1
	person_event SPRITE_BLACK_BELT, 4, 16, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BROWN, PERSONTYPE_SCRIPT, 0, KiyoScript_0x7e1f6, -1
	strengthboulder_event 10, 9
	itemball_event 12, 29, HYPER_POTION, 1, EVENT_MOUNT_MORTAR_B1F_HYPER_POTION
	itemball_event 16, 4, CARBOS, 1, EVENT_MOUNT_MORTAR_B1F_CARBOS
	itemball_event 24, 34, PROTECTOR, 1, EVENT_MOUNT_MORTAR_B1F_PROTECTOR
	itemball_event 3, 32, MAX_ETHER, 1, EVENT_MOUNT_MORTAR_B1F_MAX_ETHER
	itemball_event 26, 21, PP_UP, 1, EVENT_MOUNT_MORTAR_B1F_PP_UP

MountMortarB1FHikerScript:
	faceplayer
	opentext
	checkevent EVENT_LISTENED_TO_DEFENSE_CURL_INTRO
	iftrue MountMortarB1FTutorDefenseCurlScript
	writetext MountMortarB1FHikerText
	waitbutton
	setevent EVENT_LISTENED_TO_DEFENSE_CURL_INTRO
MountMortarB1FTutorDefenseCurlScript:
	writetext Text_MountMortarB1FTutorDefenseCurl
	waitbutton
	checkitem SILVER_LEAF
	iffalse .NoSilverLeaf
	writetext Text_MountMortarB1FTutorQuestion
	yesorno
	iffalse .TutorRefused
	writebyte DEFENSE_CURL
	writetext Text_MountMortarB1FTutorClear
	special Special_MoveTutor
	if_equal $0, .TeachMove
.TutorRefused
	jumpopenedtext Text_MountMortarB1FTutorRefused

.NoSilverLeaf
	jumpopenedtext Text_MountMortarB1FTutorNoSilverLeaf

.TeachMove
	takeitem SILVER_LEAF
	jumpopenedtext Text_MountMortarB1FTutorTaught

KiyoScript_0x7e1f6:
	faceplayer
	opentext
	checkevent EVENT_GOT_TYROGUE_FROM_KIYO
	iftrue UnknownScript_0x7e231
	checkevent EVENT_BEAT_KIYO
	iftrue UnknownScript_0x7e217
	writetext UnknownText_0x7e24d
	waitbutton
	closetext
	winlosstext UnknownText_0x7e2a9, 0
	loadtrainer KARATE_KING, KIYO
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_KIYO
	opentext
UnknownScript_0x7e217:
	writetext UnknownText_0x7e2c0
	buttonsound
	waitsfx
	checkcode VAR_PARTYCOUNT
	if_equal $6, UnknownScript_0x7e237
	writetext UnknownText_0x7e355
	playsound SFX_CAUGHT_MON
	waitsfx
	givepoke TYROGUE, 10
	writebyte PREMIER_BALL
	special SetLastPartyMonBall
	setevent EVENT_GOT_TYROGUE_FROM_KIYO
UnknownScript_0x7e231:
	jumpopenedtext UnknownText_0x7e36a

UnknownScript_0x7e237:
	jumpopenedtext UnknownText_0x7e3df

MountMortarB1FHikerText:
	text "My Pokemon used"
	line "Rock Smash on a"

	para "boulder, but it"
	line "was undamaged."

	para "It turned out to"
	line "be a Geodude that"
	cont "used Defense Curl!"
	done

Text_MountMortarB1FTutorDefenseCurl:
	text "I can teach your"
	line "#mon to use"

	para "Defense Curl for"
	line "one Silver Leaf."
	done

Text_MountMortarB1FTutorNoSilverLeaf:
	text "Shucks, you don't"
	line "have a Silver"
	cont "Leaf."
	done

Text_MountMortarB1FTutorQuestion:
	text "Should I teach"
	line "your #mon"
	cont "Defense Curl?"
	done

Text_MountMortarB1FTutorRefused:
	text "I'll be right here"
	line "waiting."
	done

Text_MountMortarB1FTutorClear:
	text ""
	done

Text_MountMortarB1FTutorTaught:
	text "There! Now your"
	line "#mon can use"
	cont "Defense Curl!"
	done

UnknownText_0x7e24d:
	text "Hey!"

	para "I am the Karate"
	line "King!"

	para "I train alone here"
	line "in the dark!"

	para "You!"
	line "Battle with me!"

	para "Hwaaarggh!"
	done

UnknownText_0x7e2a9:
	text "Waaaarggh!"
	line "I'm beaten!"
	done

UnknownText_0x7e2c0:
	text "I??? I'm crushed???"

	para "My training is"
	line "still not enough???"

	para "But a loss is a"
	line "loss. I admit it."

	para "As proof that you"
	line "defeated me, I'll"

	para "give you a rare"
	line "fighting #mon."
	done

UnknownText_0x7e355:
	text "<PLAYER> received"
	line "Tyrogue."
	done

UnknownText_0x7e36a:
	text "Tyrogue is a"
	line "Fighting-type."

	para "It evolves into a"
	line "tougher #mon."

	para "Keep up the hard"
	line "work. I'll keep"
	cont "training too."

	para "Farewell!"
	done

UnknownText_0x7e3df:
	text "You have no room"
	line "in your party!"
	done
