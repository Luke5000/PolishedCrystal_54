LancesRoom_MapScriptHeader:

.MapTriggers: db 1
	dw LancesRoomEntranceTrigger

.MapCallbacks: db 1
	dbw MAPCALLBACK_TILES, LancesRoomDoorCallback

LancesRoom_MapEventHeader:

.Warps: db 4
	warp_def 23, 4, 3, KARENS_ROOM
	warp_def 23, 5, 4, KARENS_ROOM
	warp_def 1, 4, 1, HALL_OF_FAME
	warp_def 1, 5, 2, HALL_OF_FAME

.XYTriggers: db 2
	xy_trigger 1, $5, $4, ApproachLanceFromLeftTrigger
	xy_trigger 1, $5, $5, ApproachLanceFromRightTrigger

.Signposts: db 0

.PersonEvents: db 3
	person_event SPRITE_LANCE, 3, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, LanceScript, -1
	person_event SPRITE_TEACHER, 7, 4, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_SCRIPT, 0, ObjectEvent, EVENT_LANCES_ROOM_OAK_AND_MARY
	person_event SPRITE_OAK, 7, 4, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, ObjectEvent, EVENT_LANCES_ROOM_OAK_AND_MARY

const_value set 2
	const LANCESROOM_LANCE
	const LANCESROOM_MARY
	const LANCESROOM_OAK

LancesRoomEntranceTrigger:
	priorityjump .Script
	end

.Script:
	applymovement PLAYER, WalkIntoEliteFourRoomMovement
	refreshscreen
	playsound SFX_STRENGTH
	earthquake 80
	changeblock 4, 22, $34
	reloadmappart
	closetext
	dotrigger $1
	setevent EVENT_LANCES_ROOM_ENTRANCE_CLOSED
	end

WalkIntoEliteFourRoomMovement:
	step_up
	step_up
	step_up
	step_up
	step_end

LancesRoomDoorCallback:
	checkevent EVENT_LANCES_ROOM_ENTRANCE_CLOSED
	iffalse .LanceEntranceOpen
	changeblock 4, 22, $34
.LanceEntranceOpen:
	checkevent EVENT_LANCES_ROOM_EXIT_OPEN
	iffalse .LanceExitClosed
	changeblock 4, 0, $b
.LanceExitClosed:
	return

ApproachLanceFromLeftTrigger:
	special Special_FadeOutMusic
	applymovement PLAYER, ApproachLanceFromLeftMovement
	jump LanceScript

ApproachLanceFromRightTrigger:
	special Special_FadeOutMusic
	applymovement PLAYER, ApproachLanceFromRightMovement
LanceScript:
	spriteface LANCESROOM_LANCE, LEFT
	checkcode VAR_BADGES
	if_equal 16, .Rematch
	showtext .SeenText
	winlosstext .BeatenText, 0
	setlasttalked LANCESROOM_LANCE
	loadtrainer CHAMPION, LANCE
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	showtext .AfterText
	jump .EndBattle

.Rematch:
	showtext .SeenRematchText
	winlosstext .BeatenText, 0
	setlasttalked LANCESROOM_LANCE
	loadtrainer CHAMPION, LANCE2
	startbattle
	dontrestartmapmusic
	reloadmapafterbattle
	showtext .AfterRematchText
.EndBattle:
	setevent EVENT_BEAT_CHAMPION_LANCE
	playsound SFX_ENTER_DOOR
	changeblock 4, 0, $b
	reloadmappart
	closetext
	setevent EVENT_LANCES_ROOM_ENTRANCE_CLOSED
	musicfadeout MUSIC_BEAUTY_ENCOUNTER, $10
	pause 30
	showemote EMOTE_SHOCK, LANCESROOM_LANCE, 15
	spriteface LANCESROOM_LANCE, DOWN
	pause 10
	spriteface PLAYER, DOWN
	appear LANCESROOM_MARY
	applymovement LANCESROOM_MARY, .RushInMovement
	showtext .MaryText1
	appear LANCESROOM_OAK
	applymovement LANCESROOM_OAK, .WalkInMovement
	follow LANCESROOM_MARY, LANCESROOM_OAK
	applymovement LANCESROOM_MARY, .StepAsideMovement
	stopfollow
	spriteface LANCESROOM_OAK, UP
	spriteface LANCESROOM_LANCE, LEFT
	showtext .OakSpeechText
	applymovement LANCESROOM_MARY, .ApproachPlayerMovement
	spriteface PLAYER, LEFT
	showtext .MaryText2
	applymovement LANCESROOM_LANCE, .WalkTowardExitMovement
	spriteface PLAYER, UP
	showtext .LanceLeavingText
	follow LANCESROOM_LANCE, PLAYER
	spriteface LANCESROOM_MARY, UP
	spriteface LANCESROOM_OAK, UP
	applyonemovement LANCESROOM_LANCE, step_up
	stopfollow
	playsound SFX_EXIT_BUILDING
	disappear LANCESROOM_LANCE
	applyonemovement PLAYER, step_up
	playsound SFX_EXIT_BUILDING
	disappear PLAYER
	applymovement LANCESROOM_MARY, .TryToFollowMovement
	showemote EMOTE_SHOCK, LANCESROOM_MARY, 15
	opentext
	writetext .MaryText3
	pause 30
	closetext
	applymovement LANCESROOM_MARY, .RunBackAndForthMovement
	special FadeOutPalettes
	pause 15
	warpfacing UP, HALL_OF_FAME, 4, 13
	end

.SeenText:
	text "Lance: I've been"
	line "waiting for you."

	para "<PLAYER>!"

	para "I knew that you,"
	line "with your skills,"

	para "would eventually"
	line "reach me here."

	para "There's no need"
	line "for words now."

	para "We will battle to"
	line "determine who is"

	para "the stronger of"
	line "the two of us."

	para "As the most power-"
	line "ful trainer and as"

	para "the #mon League"
	line "Champion???"

	para "I, Lance the drag-"
	line "on master, accept"
	cont "your challenge!"
	done

.BeatenText:
	text "???It's over."

	para "But it's an odd"
	line "feeling."

	para "I'm not angry that"
	line "I lost. In fact, I"
	cont "feel happy."

	para "Happy that I"
	line "witnessed the rise"

	para "of a great new"
	line "Champion!"
	done

.AfterText:
	text "???Whew."

	para "You have become"
	line "truly powerful,"
	cont "<PLAYER>."

	para "Your #mon have"
	line "responded to your"

	para "strong and up-"
	line "standing nature."

	para "As a trainer, you"
	line "will continue to"

	para "grow strong with"
	line "your #mon."
	done

.SeenRematchText:
	text "Lance: There's no"
	line "need for words"
	cont "now."

	para "We will battle to"
	line "determine who is"

	para "the stronger of"
	line "the two of us."

	para "I, Lance the drag-"
	line "on master, accept"
	cont "your challenge!"
	done

.AfterRematchText:
	text "Just as I"
	line "expected."

	para "You and your"
	line "#mon make"
	cont "quite a team."

	para "As a trainer, you"
	line "will continue to"

	para "grow strong with"
	line "your #mon."
	done

.MaryText1:
	text "Mary: Oh, no!"
	line "It's all over!"

	para "Prof.Oak, if you"
	line "weren't so slow???"
	done

.OakSpeechText:
	text "Prof.Oak: Ah,"
	line "<PLAYER>!"

	para "It's been a long"
	line "while."

	para "You certainly look"
	line "more impressive."

	para "Your conquest of"
	line "the League is just"
	cont "fantastic!"

	para "Your dedication,"
	line "trust and love for"

	para "your #mon made"
	line "this happen."

	para "Your #mon were"
	line "outstanding too."

	para "Because they be-"
	line "lieved in you as a"

	para "trainer, they per-"
	line "severed."

	para "Congratulations,"
	line "<PLAYER>!"
	done

.MaryText2:
	text "Mary: Let's inter-"
	line "view the brand new"
	cont "Champion!"
	done

.LanceLeavingText:
	text "Lance: This is"
	line "getting to be a"
	cont "bit too noisy???"

	para "<PLAYER>, could you"
	line "come with me?"
	done

.MaryText3:
	text "Mary: Oh, wait!"
	line "We haven't done"
	cont "the interview!"
	done

.RushInMovement:
	big_step_up
	big_step_up
	big_step_up
	turn_head_down
	step_end

.WalkInMovement:
	step_up
	step_up
	step_end

.StepAsideMovement:
	step_left
	turn_head_right
	step_end

.ApproachPlayerMovement:
	big_step_up
	turn_head_right
	step_end

.WalkTowardExitMovement:
	step_up
	step_left
	turn_head_down
	step_end

.TryToFollowMovement:
	step_up
	step_right
	turn_head_up
	step_end

.RunBackAndForthMovement:
	big_step_right
	big_step_right
	big_step_left
	big_step_left
	big_step_left
	big_step_right
	big_step_right
	big_step_right
	big_step_left
	big_step_left
	turn_head_up
	step_end

ApproachLanceFromLeftMovement:
	step_up
	step_up
	turn_head_right
	step_end

ApproachLanceFromRightMovement:
	step_up
	step_left
	step_up
	turn_head_right
	step_end
