Route4_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 0

Route4_MapEventHeader:

.Warps: db 1
	warp_def 5, 2, 8, MOUNT_MOON_B1F

.XYTriggers: db 0

.Signposts: db 2
	signpost 7, 5, SIGNPOST_JUMPTEXT, MtMoonSignText
	signpost 3, 18, SIGNPOST_ITEM + ULTRA_BALL, EVENT_ROUTE_4_HIDDEN_ULTRA_BALL

.PersonEvents: db 9
	person_event SPRITE_YOUNGSTER, 3, 49, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 5, TrainerYoungsterOliver, -1
	person_event SPRITE_LASS, 11, 36, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 5, TrainerLassJennifer, -1
	person_event SPRITE_YOUNGSTER, 9, 25, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 3, TrainerBird_keeperHank, -1
	person_event SPRITE_LASS, 8, 10, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_TRAINER, 5, TrainerPicnickerHope, -1
	person_event SPRITE_LASS, 6, 33, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_TRAINER, 4, TrainerPicnickerSharon, -1
	itemball_event 3, 40, HP_UP, 1, EVENT_ROUTE_4_HP_UP
	person_event SPRITE_SUPER_NERD, 3, 17, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_SCRIPT, 0, Route4SuperNerd1Script, -1
	person_event SPRITE_SUPER_NERD, 3, 20, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_SCRIPT, 0, Route4SuperNerd2Script, -1
	person_event SPRITE_COOLTRAINER_M, 4, 66, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_SCRIPT, 0, ObjectEvent, EVENT_BEAT_BLUE

TrainerYoungsterOliver:
	trainer EVENT_BEAT_YOUNGSTER_OLIVER, YOUNGSTER, OLIVER, YoungsterOliverSeenText, YoungsterOliverBeatenText, 0, YoungsterOliverScript

YoungsterOliverScript:
	end_if_just_battled
	jumptextfaceplayer YoungsterOliverAfterText

TrainerLassJennifer:
	trainer EVENT_BEAT_LASS_JENNIFER, LASS, JENNIFER, LassJenniferSeenText, LassJenniferBeatenText, 0, LassJenniferScript

LassJenniferScript:
	end_if_just_battled
	jumptextfaceplayer LassJenniferAfterText

TrainerBird_keeperHank:
	trainer EVENT_BEAT_BIRD_KEEPER_HANK, BIRD_KEEPER, HANK, Bird_keeperHankSeenText, Bird_keeperHankBeatenText, 0, Bird_keeperHankScript

Bird_keeperHankScript:
	end_if_just_battled
	jumptextfaceplayer UnknownText_0x1ae258

TrainerPicnickerHope:
	trainer EVENT_BEAT_PICNICKER_HOPE, PICNICKER, HOPE, PicnickerHopeSeenText, PicnickerHopeBeatenText, 0, PicnickerHopeScript

PicnickerHopeScript:
	end_if_just_battled
	jumptextfaceplayer UnknownText_0x1ae320

TrainerPicnickerSharon:
	trainer EVENT_BEAT_PICNICKER_SHARON, PICNICKER, SHARON, PicnickerSharonSeenText, PicnickerSharonBeatenText, 0, PicnickerSharonScript

PicnickerSharonScript:
	end_if_just_battled
	jumptextfaceplayer UnknownText_0x1ae369

Route4SuperNerd1Script:
	faceplayer
	opentext
	checkevent EVENT_LISTENED_TO_IRON_HEAD_INTRO
	iftrue Route4TutorIronHeadScript
	writetext Route4SuperNerd1Text
	waitbutton
	setevent EVENT_LISTENED_TO_IRON_HEAD_INTRO
Route4TutorIronHeadScript:
	writetext Text_Route4TutorIronHead
	waitbutton
	checkitem SILVER_LEAF
	iffalse .NoSilverLeaf
	writetext Text_Route4Tutor1Question
	yesorno
	iffalse .TutorRefused
	writebyte IRON_HEAD
	writetext Text_Route4TutorsClear
	special Special_MoveTutor
	if_equal $0, .TeachMove
.TutorRefused
	jumpopenedtext Text_Route4Tutor1Refused

.NoSilverLeaf
	jumpopenedtext Text_Route4TutorsNoSilverLeaf

.TeachMove
	takeitem SILVER_LEAF
	jumpopenedtext Text_Route4Tutor1Taught

Route4SuperNerd2Script:
	faceplayer
	opentext
	checkevent EVENT_LISTENED_TO_AQUA_TAIL_INTRO
	iftrue Route4TutorAquaTailScript
	writetext Route4SuperNerd2Text
	waitbutton
	setevent EVENT_LISTENED_TO_AQUA_TAIL_INTRO
Route4TutorAquaTailScript:
	writetext Text_Route4TutorAquaTail
	waitbutton
	checkitem SILVER_LEAF
	iffalse .NoSilverLeaf
	writetext Text_Route4Tutor2Question
	yesorno
	iffalse .TutorRefused
	writebyte AQUA_TAIL
	writetext Text_Route4TutorsClear
	special Special_MoveTutor
	if_equal $0, .TeachMove
.TutorRefused
	jumpopenedtext Text_Route4Tutor2Refused

.NoSilverLeaf
	jumpopenedtext Text_Route4TutorsNoSilverLeaf

.TeachMove
	takeitem SILVER_LEAF
	jumpopenedtext Text_Route4Tutor2Taught

YoungsterOliverSeenText:
	text "Hi! What's your"
	line "name? Where are"
	cont "you going?"
	done

YoungsterOliverBeatenText:
	text "I was just"
	line "asking???"
	done

YoungsterOliverAfterText:
	text "People say that"
	line "I ask too many"
	cont "questions, but"

	para "that's what kids"
	line "do, right?"
	done

LassJenniferSeenText:
	text "I battle every"
	line "chance I get,"

	para "just to spend time"
	line "with my #mon."
	done

LassJenniferBeatenText:
	text "Wheeee!"
	done

LassJenniferAfterText:
	text "#mon are so"
	line "much fun."
	cont "Don't you agree?"
	done

Bird_keeperHankSeenText:
	text "I'm raising my"
	line "#mon. Want to"
	cont "battle with me?"
	done

Bird_keeperHankBeatenText:
	text "Ack! I lost that"
	line "one???"
	done

UnknownText_0x1ae258:
	text "If you have a"
	line "specific #mon"

	para "that you want to"
	line "raise, put it out"

	para "first, then switch"
	line "it right away."

	para "That's how to do"
	line "it."
	done

PicnickerHopeSeenText:
	text "I have a feeling"
	line "that I can win."

	para "Let's see if I'm"
	line "right!"
	done

PicnickerHopeBeatenText:
	text "Aww, you are too"
	line "strong."
	done

UnknownText_0x1ae320:
	text "I heard Clefairy"
	line "appear at Mt.Moon."

	para "But where could"
	line "they be?"
	done

PicnickerSharonSeenText:
	text "Um???"
	line "I???"
	done

PicnickerSharonBeatenText:
	text "???"
	done

UnknownText_0x1ae369:
	text "??????I'll go train"
	line "some more???"
	done

Route4SuperNerd1Text:
	text "#mon with tough"
	line "heads are best!"

	para "Rhydon, Marowak,"
	line "Golem!"

	para "Don't you agree?"
	done

Route4SuperNerd2Text:
	text "#mon with long"
	line "tails are best!"

	para "Gyarados, Golduck,"
	line "Blastoise!"

	para "Don't you agree?"
	done

Text_Route4TutorIronHead:
	text "If you give me a"
	line "Silver Leaf, I'll"

	para "teach your #mon"
	line "to use Iron Head!"
	done

Text_Route4TutorAquaTail:
	text "If you give me a"
	line "Silver Leaf, I'll"

	para "teach your #mon"
	line "to use Aqua Tail!"
	done

Text_Route4TutorsNoSilverLeaf:
	text "But you don't have"
	line "a Silver Leaf."
	done

Text_Route4Tutor1Question:
	text "Should I teach"
	line "your #mon"
	cont "Iron Head?"
	done

Text_Route4Tutor2Question:
	text "Should I teach"
	line "your #mon"
	cont "Aqua Tail?"
	done

Text_Route4Tutor1Refused:
	text "But it's better"
	line "than Aqua Tail!"
	done

Text_Route4Tutor2Refused:
	text "But it's better"
	line "than Iron Head!"
	done

Text_Route4TutorsClear:
	text ""
	done

Text_Route4Tutor1Taught:
	text "Now your #mon"
	line "knows how to use"
	cont "Iron Head!"
	done

Text_Route4Tutor2Taught:
	text "Now your #mon"
	line "knows how to use"
	cont "Aqua Tail!"
	done

MtMoonSignText:
	text "Mt.Moon"
	line "Tunnel Entrance"
	done
