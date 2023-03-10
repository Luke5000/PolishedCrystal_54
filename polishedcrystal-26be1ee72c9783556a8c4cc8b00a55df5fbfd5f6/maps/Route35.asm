Route35_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 1
	dbw MAPCALLBACK_OBJECTS, Route35RebattleBreeder

Route35_MapEventHeader:

.Warps: db 3
	warp_def 33, 9, 1, ROUTE_35_GOLDENROD_GATE
	warp_def 33, 10, 2, ROUTE_35_GOLDENROD_GATE
	warp_def 5, 3, 3, ROUTE_35_NATIONAL_PARK_GATE

.XYTriggers: db 0

.Signposts: db 2
	signpost 7, 1, SIGNPOST_JUMPTEXT, Route35SignText
	signpost 31, 11, SIGNPOST_JUMPTEXT, Route35SignText

.PersonEvents: db 12
	person_event SPRITE_YOUNGSTER, 19, 4, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_TRAINER, 2, TrainerCamperIvan, -1
	person_event SPRITE_YOUNGSTER, 20, 8, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 1, TrainerCoupleGailandeli1, -1
	person_event SPRITE_LASS, 20, 7, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 1, TrainerCoupleGailandeli2, -1
	person_event SPRITE_LASS, 26, 10, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_TRAINER, 1, TrainerPicnickerKim, -1
	person_event SPRITE_BREEDER, 29, 14, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_TRAINER, 3, TrainerBreederTheresa, -1
	person_event SPRITE_FISHER, 10, 2, SPRITEMOVEDATA_SPINCOUNTERCLOCKWISE, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_TRAINER, 2, TrainerFirebreatherWalt, -1
	person_event SPRITE_BUG_CATCHER, 7, 16, SPRITEMOVEDATA_STANDING_DOWN, 0, 2, -1, -1, (1 << 3) | PAL_OW_BROWN, PERSONTYPE_TRAINER, 3, TrainerBug_catcherArnie1, -1
	person_event SPRITE_SUPER_NERD, 10, 5, SPRITEMOVEDATA_SPINRANDOM_FAST, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 2, TrainerJugglerIrwin, -1
	person_event SPRITE_OFFICER, 6, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_SCRIPT, 0, OfficermScript_0x19ca49, -1
	cuttree_event 6, 17, EVENT_ROUTE_35_CUT_TREE
	fruittree_event 25, 2, FRUITTREE_ROUTE_35, LEPPA_BERRY
	tmhmball_event 16, 13, TM_HONE_CLAWS, EVENT_ROUTE_35_TM_HONE_CLAWS

Route35RebattleBreeder:
	clearevent EVENT_BEAT_BREEDER_THERESA
	return

TrainerBreederTheresa:
	trainer EVENT_BEAT_BREEDER_THERESA, BREEDER, THERESA, BreederTheresaSeenText, BreederTheresaBeatenText, 0, BreederTheresaScript

BreederTheresaScript:
	end_if_just_battled
	jumptextfaceplayer UnknownText_0x19cc87

TrainerJugglerIrwin:
	trainer EVENT_BEAT_JUGGLER_IRWIN, JUGGLER, IRWIN1, JugglerIrwin1SeenText, JugglerIrwin1BeatenText, 0, JugglerIrwin1Script

JugglerIrwin1Script:
	writecode VAR_CALLERID, PHONE_JUGGLER_IRWIN
	end_if_just_battled
	opentext
	checkcellnum PHONE_JUGGLER_IRWIN
	iftrue UnknownScript_0x19c90f
	checkevent EVENT_IRWIN_ASKED_FOR_PHONE_NUMBER
	iftrue UnknownScript_0x19c8ec
	writetext UnknownText_0x19cd5a
	buttonsound
	setevent EVENT_IRWIN_ASKED_FOR_PHONE_NUMBER
	scall UnknownScript_0x19c903
	jump UnknownScript_0x19c8ef

UnknownScript_0x19c8ec:
	scall UnknownScript_0x19c907
UnknownScript_0x19c8ef:
	askforphonenumber PHONE_JUGGLER_IRWIN
	if_equal $1, UnknownScript_0x19c917
	if_equal $2, UnknownScript_0x19c913
	trainertotext JUGGLER, IRWIN1, $0
	scall UnknownScript_0x19c90b
	jump UnknownScript_0x19c90f

UnknownScript_0x19c903:
	jumpstd asknumber1m
	end

UnknownScript_0x19c907:
	jumpstd asknumber2m
	end

UnknownScript_0x19c90b:
	jumpstd registerednumberm
	end

UnknownScript_0x19c90f:
	jumpstd numberacceptedm
	end

UnknownScript_0x19c913:
	jumpstd numberdeclinedm
	end

UnknownScript_0x19c917:
	jumpstd phonefullm
	end

UnknownScript_0x19c91b:
	jumpstd rematchm
	end

TrainerCamperIvan:
	trainer EVENT_BEAT_CAMPER_IVAN, CAMPER, IVAN, CamperIvanSeenText, CamperIvanBeatenText, 0, CamperIvanScript

CamperIvanScript:
	end_if_just_battled
	jumptextfaceplayer UnknownText_0x19cac4

TrainerCoupleGailandeli1:
	trainer EVENT_BEAT_COUPLE_GAIL_AND_ELI, COUPLE, GAILANDELI1, CoupleGailandeli1SeenText, CoupleGailandeli1BeatenText, 0, CoupleGailandeli1Script

CoupleGailandeli1Script:
	end_if_just_battled
	jumptextfaceplayer CoupleGailandeli1AfterText

TrainerCoupleGailandeli2:
	trainer EVENT_BEAT_COUPLE_GAIL_AND_ELI, COUPLE, GAILANDELI2, CoupleGailandeli2SeenText, CoupleGailandeli2BeatenText, 0, CoupleGailandeli2Script

CoupleGailandeli2Script:
	end_if_just_battled
	jumptextfaceplayer CoupleGailandeli2AfterText

TrainerPicnickerKim:
	trainer EVENT_BEAT_PICNICKER_KIM, PICNICKER, KIM, PicnickerKimSeenText, PicnickerKimBeatenText, 0, PicnickerKimScript

PicnickerKimScript:
	end_if_just_battled
	jumptextfaceplayer UnknownText_0x19cc21

TrainerBug_catcherArnie1:
	trainer EVENT_BEAT_BUG_CATCHER_ARNIE, BUG_CATCHER, ARNIE1, Bug_catcherArnie1SeenText, Bug_catcherArnie1BeatenText, 0, Bug_catcherArnie1Script

Bug_catcherArnie1Script:
	writecode VAR_CALLERID, PHONE_BUG_CATCHER_ARNIE
	end_if_just_battled
	opentext
	checkflag ENGINE_ARNIE
	iftrue UnknownScript_0x19c9bb
	checkflag ENGINE_YANMA_SWARM
	iftrue UnknownScript_0x19ca2f
	checkcellnum PHONE_BUG_CATCHER_ARNIE
	iftrue UnknownScript_0x19c90f
	checkevent EVENT_ARNIE_ASKED_FOR_PHONE_NUMBER
	iftrue UnknownScript_0x19c9a4
	writetext UnknownText_0x19cdf6
	buttonsound
	setevent EVENT_ARNIE_ASKED_FOR_PHONE_NUMBER
	scall UnknownScript_0x19c903
	jump UnknownScript_0x19c9a7

UnknownScript_0x19c9a4:
	scall UnknownScript_0x19c907
UnknownScript_0x19c9a7:
	askforphonenumber PHONE_BUG_CATCHER_ARNIE
	if_equal $1, UnknownScript_0x19c917
	if_equal $2, UnknownScript_0x19c913
	trainertotext BUG_CATCHER, ARNIE1, $0
	scall UnknownScript_0x19c90b
	jump UnknownScript_0x19c90f

UnknownScript_0x19c9bb:
	scall UnknownScript_0x19c91b
	winlosstext Bug_catcherArnie1BeatenText, 0
	copybytetovar wArnieFightCount
	if_equal 4, .Fight4
	if_equal 3, .Fight3
	if_equal 2, .Fight2
	if_equal 1, .Fight1
	if_equal 0, .LoadFight0
.Fight4:
	checkevent EVENT_RESTORED_POWER_TO_KANTO
	iftrue .LoadFight4
.Fight3:
	checkevent EVENT_BEAT_ELITE_FOUR
	iftrue .LoadFight3
.Fight2:
	checkflag ENGINE_FLYPOINT_BLACKTHORN
	iftrue .LoadFight2
.Fight1:
	checkflag ENGINE_FLYPOINT_LAKE_OF_RAGE
	iftrue .LoadFight1
.LoadFight0:
	loadtrainer BUG_CATCHER, ARNIE1
	startbattle
	reloadmapafterbattle
	loadvar wArnieFightCount, 1
	clearflag ENGINE_ARNIE
	end

.LoadFight1:
	loadtrainer BUG_CATCHER, ARNIE2
	startbattle
	reloadmapafterbattle
	loadvar wArnieFightCount, 2
	clearflag ENGINE_ARNIE
	end

.LoadFight2:
	loadtrainer BUG_CATCHER, ARNIE3
	startbattle
	reloadmapafterbattle
	loadvar wArnieFightCount, 3
	clearflag ENGINE_ARNIE
	end

.LoadFight3:
	loadtrainer BUG_CATCHER, ARNIE4
	startbattle
	reloadmapafterbattle
	loadvar wArnieFightCount, 4
	clearflag ENGINE_ARNIE
	end

.LoadFight4:
	loadtrainer BUG_CATCHER, ARNIE5
	startbattle
	reloadmapafterbattle
	clearflag ENGINE_ARNIE
	end

UnknownScript_0x19ca2f:
	jumpopenedtext UnknownText_0x19ce38

TrainerFirebreatherWalt:
	trainer EVENT_BEAT_FIREBREATHER_WALT, FIREBREATHER, WALT, FirebreatherWaltSeenText, FirebreatherWaltBeatenText, 0, FirebreatherWaltScript

FirebreatherWaltScript:
	end_if_just_battled
	jumptextfaceplayer UnknownText_0x19cebc

OfficermScript_0x19ca49:
	faceplayer
	opentext
	checknite
	iffalse UnknownScript_0x19ca73
	checkevent EVENT_BEAT_OFFICERM_DIRK
	iftrue UnknownScript_0x19ca6d
	special SaveMusic
	playmusic MUSIC_OFFICER_ENCOUNTER
	writetext UnknownText_0x19ceea
	waitbutton
	closetext
	winlosstext UnknownText_0x19cf06, 0
	loadtrainer OFFICERM, DIRK
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_OFFICERM_DIRK
	closetext
	end

UnknownScript_0x19ca6d:
	jumpopenedtext UnknownText_0x19cf0f

UnknownScript_0x19ca73:
	jumpopenedtext UnknownText_0x19cf56

CamperIvanSeenText:
	text "I've been getting"
	line "#mon data off"

	para "my radio. I think"
	line "I'm good."
	done

CamperIvanBeatenText:
	text "I give!"
	done

UnknownText_0x19cac4:
	text "Music on the radio"
	line "changes the moods"
	cont "of wild #mon."
	done

CoupleGailandeli1SeenText:
	text "Eli: I'm gonna"
	line "show my girlfriend"
	cont "I'm hot stuff!"
	done

CoupleGailandeli1BeatenText:
	text "Eli: I wish you'd"
	line "have lost for me???"
	done

CoupleGailandeli1AfterText:
	text "Eli: I was humili-"
	line "ated in front of"
	cont "my girlfriend???"
	done

CoupleGailandeli2SeenText:
	text "Gail: My boy-"
	line "friend's weak, so I"
	cont "can't rely on him."
	done

CoupleGailandeli2BeatenText:
	text "Gail: Oh, my!"
	line "You're so strong!"
	done

CoupleGailandeli2AfterText:
	text "Gail: I can count"
	line "on my #mon more"
	cont "than my boyfriend."
	done

PicnickerKimSeenText:
	text "Are you going to"
	line "the Gym? Me too!"
	done

PicnickerKimBeatenText:
	text "Oh. I couldn't"
	line "win???"
	done

UnknownText_0x19cc21:
	text "The Gym Badges are"
	line "pretty. I collect"
	cont "them."
	done

BreederTheresaSeenText:
	text "How do you care"
	line "for your #mon?"
	done

BreederTheresaBeatenText:
	text "Ah! You take good"
	line "care of them!"
	done

UnknownText_0x19cc87:
	text "I take my #mon"
	line "to get haircuts"

	para "in Goldenrod City,"
	line "and blessings in"
	cont "Ecruteak City."

	para "They're so happy!"
	done

JugglerIrwin1SeenText:
	text "Behold my graceful"
	line "Ball dexterity!"
	done

JugglerIrwin1BeatenText:
	text "Whew! That was a"
	line "jolt!"
	done

UnknownText_0x19cd5a:
	text "I was going to"
	line "dazzle you with my"
	cont "prize #mon."

	para "But your prowess"
	line "electrified me!"
	done

Bug_catcherArnie1SeenText:
	text "I'll go anywhere"
	line "if bug #mon"
	cont "appear there."
	done

Bug_catcherArnie1BeatenText:
	text "Huh? I shouldn't"
	line "have lost that???"
	done

UnknownText_0x19cdf6:
	text "My Venonat won me"
	line "the Bug-Catching"

	para "Contest at the"
	line "National Park."
	done

UnknownText_0x19ce38:
	text "Wow??? Look at all"
	line "those Yanma!"

	para "I'm so blown away,"
	line "I can't move."
	done

FirebreatherWaltSeenText:
	text "I'm practicing my"
	line "fire breathing."
	done

FirebreatherWaltBeatenText:
	text "Ow! I scorched the"
	line "tip of my nose!"
	done

UnknownText_0x19cebc:
	text "The #mon March"
	line "on the radio lures"
	cont "wild #mon."
	done

UnknownText_0x19ceea:
	text "Danger lurks in"
	line "the night!"
	done

UnknownText_0x19cf06:
	text "Whoops!"
	done

UnknownText_0x19cf0f:
	text "You know, night-"
	line "time is fun in its"
	cont "own ways."

	para "But don't overdo"
	line "it, OK?"
	done

UnknownText_0x19cf56:
	text "Your #mon look"
	line "pretty tough."

	para "You could go any-"
	line "where safely."
	done

Route35SignText:
	text "Route 35"
	done
