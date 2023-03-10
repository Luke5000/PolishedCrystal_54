Route30_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 0

Route30_MapEventHeader:

.Warps: db 2
	warp_def 39, 7, 1, ROUTE_30_BERRY_SPEECH_HOUSE
	warp_def 5, 17, 1, MR_POKEMONS_HOUSE

.XYTriggers: db 0

.Signposts: db 6
	signpost 43, 9, SIGNPOST_JUMPTEXT, Route30SignText
	signpost 29, 13, SIGNPOST_JUMPTEXT, MrPokemonsHouseDirectionsSignText
	signpost 5, 15, SIGNPOST_JUMPTEXT, MrPokemonsHouseSignText
	signpost 21, 3, SIGNPOST_JUMPTEXT, Route30TrainerTipsText
	signpost 9, 14, SIGNPOST_ITEM + POTION, EVENT_ROUTE_30_HIDDEN_POTION
	signpost 39, 5, SIGNPOST_JUMPTEXT, BerryMastersHouseSignText

.PersonEvents: db 12
	person_event SPRITE_YOUNGSTER, 26, 5, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_SCRIPT, 0, YoungsterJoey_ImportantBattleScript, EVENT_ROUTE_30_BATTLE
	person_event SPRITE_PIDGEY, 24, 5, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, (1 << 3) | PAL_OW_BROWN, PERSONTYPE_SCRIPT, 0, ObjectEvent, EVENT_ROUTE_30_BATTLE
	person_event SPRITE_RATTATA, 25, 5, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, (1 << 3) | PAL_OW_PURPLE, PERSONTYPE_SCRIPT, 0, ObjectEvent, EVENT_ROUTE_30_BATTLE
	person_event SPRITE_YOUNGSTER, 28, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 3, TrainerYoungsterJoey, EVENT_ROUTE_30_YOUNGSTER_JOEY
	person_event SPRITE_YOUNGSTER, 23, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 1, TrainerYoungsterMikey, -1
	person_event SPRITE_CHERRYGROVE_RIVAL, 7, 1, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BROWN, PERSONTYPE_TRAINER, 3, TrainerBug_catcherDon, -1
	person_event SPRITE_YOUNGSTER, 30, 7, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 1, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_SCRIPT, 0, Route30YoungsterScript, -1
	person_event SPRITE_COOLTRAINER_F, 13, 2, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, PERSONTYPE_COMMAND, jumptextfaceplayer, Route30CooltrainerFText, -1
	cuttree_event 6, 8, EVENT_ROUTE_30_CUT_TREE
	fruittree_event 39, 10, FRUITTREE_ROUTE_30_1, ORAN_BERRY
	fruittree_event 5, 11, FRUITTREE_ROUTE_30_2, PECHA_BERRY
	itemball_event 35, 8, ANTIDOTE, 1, EVENT_ROUTE_30_ANTIDOTE

const_value set 2
	const ROUTE30_YOUNGSTER1
	const ROUTE30_PIDGEY
	const ROUTE30_RATTATA

YoungsterJoey_ImportantBattleScript:
	waitsfx
	special SaveMusic
	playmusic MUSIC_JOHTO_TRAINER_BATTLE
	opentext
	writetext Text_UseTackle
	pause 30
	closetext
	playsound SFX_TACKLE
	applymovement ROUTE30_RATTATA, Route30_JoeysRattataAttacksMovement
	opentext
	faceplayer
	writetext Text_ThisIsABigBattle
	waitbutton
	spriteface ROUTE30_YOUNGSTER1, UP
	closetext
	playsound SFX_TACKLE
	applymovement ROUTE30_PIDGEY, Route30_MikeysPidgeyAttacksMovement
	special RestoreMusic
	end

TrainerYoungsterJoey:
	trainer EVENT_BEAT_YOUNGSTER_JOEY, YOUNGSTER, JOEY1, YoungsterJoey1SeenText, YoungsterJoey1BeatenText, 0, .Script

.Script:
	writecode VAR_CALLERID, PHONE_YOUNGSTER_JOEY
	end_if_just_battled
	opentext
	checkflag ENGINE_JOEY
	iftrue .Rematch
	checkcellnum PHONE_YOUNGSTER_JOEY
	iftrue .NumberAccepted
	checkevent EVENT_JOEY_ASKED_FOR_PHONE_NUMBER
	iftrue .AskAgain
	writetext YoungsterJoey1AfterText
	buttonsound
	setevent EVENT_JOEY_ASKED_FOR_PHONE_NUMBER
	scall .AskNumber1
	jump .RequestNumber

.AskAgain:
	scall .AskNumber2
.RequestNumber:
	askforphonenumber PHONE_YOUNGSTER_JOEY
	if_equal $1, .PhoneFull
	if_equal $2, .NumberDeclined
	trainertotext YOUNGSTER, JOEY1, $0
	scall .RegisteredNumber
	jump .NumberAccepted

.Rematch:
	scall .RematchStd
	winlosstext YoungsterJoey1BeatenText, 0
	copybytetovar wJoeyFightCount
	if_equal 4, .Fight4
	if_equal 3, .Fight3
	if_equal 2, .Fight2
	if_equal 1, .Fight1
	if_equal 0, .LoadFight0
.Fight4:
	checkevent EVENT_BEAT_ELITE_FOUR
	iftrue .LoadFight4
.Fight3:
	checkevent EVENT_CLEARED_RADIO_TOWER
	iftrue .LoadFight3
.Fight2:
	checkflag ENGINE_FLYPOINT_OLIVINE
	iftrue .LoadFight2
.Fight1:
	checkflag ENGINE_FLYPOINT_GOLDENROD
	iftrue .LoadFight1
.LoadFight0:
	loadtrainer YOUNGSTER, JOEY1
	startbattle
	reloadmapafterbattle
	loadvar wJoeyFightCount, 1
	clearflag ENGINE_JOEY
	end

.LoadFight1:
	loadtrainer YOUNGSTER, JOEY2
	startbattle
	reloadmapafterbattle
	loadvar wJoeyFightCount, 2
	clearflag ENGINE_JOEY
	end

.LoadFight2:
	loadtrainer YOUNGSTER, JOEY3
	startbattle
	reloadmapafterbattle
	loadvar wJoeyFightCount, 3
	clearflag ENGINE_JOEY
	end

.LoadFight3:
	loadtrainer YOUNGSTER, JOEY4
	startbattle
	reloadmapafterbattle
	loadvar wJoeyFightCount, 4
	clearflag ENGINE_JOEY
	end

.LoadFight4:
	loadtrainer YOUNGSTER, JOEY5
	startbattle
	reloadmapafterbattle
	clearflag ENGINE_JOEY
	checkevent EVENT_JOEY_HP_UP
	iftrue .GiveHPUp
	checkevent EVENT_GOT_HP_UP_FROM_JOEY
	iftrue .done
	scall .RematchGift
	verbosegiveitem HP_UP
	iffalse .PackFull
	setevent EVENT_GOT_HP_UP_FROM_JOEY
	jump .NumberAccepted

.done
	end

.GiveHPUp:
	opentext
	writetext YoungsterJoeyText_GiveHPUpAfterBattle
	waitbutton
	verbosegiveitem HP_UP
	iffalse .PackFull
	clearevent EVENT_JOEY_HP_UP
	setevent EVENT_GOT_HP_UP_FROM_JOEY
	jump .NumberAccepted

.AskNumber1:
	jumpstd asknumber1m
	end

.AskNumber2:
	jumpstd asknumber2m
	end

.RegisteredNumber:
	jumpstd registerednumberm
	end

.NumberAccepted:
	jumpstd numberacceptedm
	end

.NumberDeclined:
	jumpstd numberdeclinedm
	end

.PhoneFull:
	jumpstd phonefullm
	end

.RematchStd:
	jumpstd rematchm
	end

.PackFull:
	setevent EVENT_JOEY_HP_UP
	jumpstd packfullm
	end

.RematchGift:
	jumpstd rematchgiftm
	end

TrainerYoungsterMikey:
	trainer EVENT_BEAT_YOUNGSTER_MIKEY, YOUNGSTER, MIKEY, YoungsterMikeySeenText, YoungsterMikeyBeatenText, 0, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer YoungsterMikeyAfterText

TrainerBug_catcherDon:
	trainer EVENT_BEAT_BUG_CATCHER_DON, BUG_CATCHER, DON, Bug_catcherDonSeenText, Bug_catcherDonBeatenText, 0, .Script

.Script:
	end_if_just_battled
	jumptextfaceplayer Bug_catcherDonAfterText

Route30YoungsterScript:
	checkevent EVENT_GAVE_MYSTERY_EGG_TO_ELM
	iftrue_jumptextfaceplayer Route30YoungsterText_EveryoneIsBattling
	jumptextfaceplayer Route30YoungsterText_DirectionsToMrPokemonsHouse

Route30_JoeysRattataAttacksMovement:
	big_step_up
	big_step_down
	step_end

Route30_MikeysPidgeyAttacksMovement:
	big_step_down
	big_step_up
	step_end

Text_UseTackle:
	text "Go, Rattata!"

	para "Tackle!"
	done

Text_ThisIsABigBattle:
	text "What? This is a"
	line "big battle!"
	cont "Leave me alone!"
	done

YoungsterJoey1SeenText:
	text "I just lost, so"
	line "I'm trying to find"
	cont "more #mon."

	para "Wait! You look"
	line "weak! Come on,"
	cont "let's battle!"
	done

YoungsterJoey1BeatenText:
	text "Ack! I lost again!"
	line "Doggone it!"
	done

YoungsterJoey1AfterText:
	text "Do I have to have"
	line "more #mon in"

	para "order to battle"
	line "better?"

	para "No! I'm sticking"
	line "with this one no"
	cont "matter what!"
	done

YoungsterMikeySeenText:
	text "You're a #mon"
	line "trainer, right?"

	para "Then you have to"
	line "battle!"
	done

YoungsterMikeyBeatenText:
	text "That's strange."
	line "I won before."
	done

YoungsterMikeyAfterText:
	text "Becoming a good"
	line "trainer is really"
	cont "tough."

	para "I'm going to bat-"
	line "tle other people"
	cont "to get better."
	done

Bug_catcherDonSeenText:
	text "Instead of a bug"
	line "#mon, I found"
	cont "a trainer!"
	done

Bug_catcherDonBeatenText:
	text "Argh! You're too"
	line "strong!"
	done

Bug_catcherDonAfterText:
	text "I ran out of #"
	line "Balls while I was"
	cont "catching #mon."

	para "I should've bought"
	line "some more???"
	done

Route30YoungsterText_DirectionsToMrPokemonsHouse:
	text "Mr.#mon's"
	line "house? It's a bit"
	cont "farther ahead."
	done

Route30YoungsterText_EveryoneIsBattling:
	text "Everyone's having"
	line "fun battling!"
	cont "You should too!"
	done

Route30CooltrainerFText:
	text "I'm not a trainer."

	para "But if you look"
	line "one in the eyes,"
	cont "prepare to battle."
	done

Route30SignText:
	text "Route 30"

	para "Cherrygrove City -"
	line "Violet City"
	done

MrPokemonsHouseDirectionsSignText:
	text "Mr.#mon's House"
	line "Straight Ahead!"
	done

MrPokemonsHouseSignText:
	text "Mr.#mon's House"
	done

BerryMastersHouseSignText:
	text "Berry Master's"
	line "House"
	done

Route30TrainerTipsText:
	text "Trainer Tips"

	para "No stealing other"
	line "people's #mon!"

	para "# Balls are to"
	line "be thrown only at"
	cont "wild #mon!"
	done

YoungsterJoeyText_GiveHPUpAfterBattle:
	text "I lost again???"
	line "Gee, you're tough!"

	para "Oh yeah, I almost"
	line "forgot that I had"
	cont "to give you this."

	para "Use it to get even"
	line "tougher, OK?"

	para "I'm going to get"
	line "tougher too."
	done
