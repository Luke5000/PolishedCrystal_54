BattleTowerOutside_MapScriptHeader:

.MapTriggers: db 1
	dw BattleTowerOutsideStepDownTrigger

.MapCallbacks: db 0

BattleTowerOutside_MapEventHeader:

.Warps: db 4
	warp_def 21, 8, 3, ROUTE_40_BATTLE_TOWER_GATE
	warp_def 21, 9, 4, ROUTE_40_BATTLE_TOWER_GATE
	warp_def 9, 8, 1, BATTLE_TOWER_1F ; hole
	warp_def 9, 9, 2, BATTLE_TOWER_1F ; hole

.XYTriggers: db 2
	xy_trigger 1, $9, $8, BattleTowerOutsidePanUpTrigger1
	xy_trigger 1, $9, $9, BattleTowerOutsidePanUpTrigger2

.Signposts: db 1
	signpost 10, 10, SIGNPOST_JUMPTEXT, BattleTowerOutsideSignText

.PersonEvents: db 4
	person_event SPRITE_YOUNGSTER, 12, 6, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_COMMAND, jumptextfaceplayer, BattleTowerOutsideYoungsterText, -1
	person_event SPRITE_BEAUTY, 11, 13, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, (1 << 3) | PAL_OW_PURPLE, PERSONTYPE_COMMAND, jumptextfaceplayer, BattleTowerOutsideBeautyText, -1
	person_event SPRITE_SAILOR, 18, 12, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 1, -1, -1, 0, PERSONTYPE_COMMAND, jumptextfaceplayer, BattleTowerOutsideSailorText, -1
	person_event SPRITE_LASS, 24, 12, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_SCRIPT, 0, ObjectEvent, -1

BattleTowerOutsideStepDownTrigger:
	priorityjump .Script
	end

.Script:
	checkcode VAR_YCOORD
	if_not_equal $9, .Done
	checkcode VAR_XCOORD
	if_equal $8, .Down
	if_not_equal $9, .Done
.Down
	applyonemovement PLAYER, step_down
.Done
	dotrigger $1
	end

BattleTowerOutsidePanUpTrigger1:
	scall BattleTowerOutsidePanUpHelperScript
	warpfacing UP, BATTLE_TOWER_1F, 10, 13
	end

BattleTowerOutsidePanUpTrigger2:
	scall BattleTowerOutsidePanUpHelperScript
	warpfacing UP, BATTLE_TOWER_1F, 11, 13
	end

BattleTowerOutsidePanUpHelperScript:
	playsound SFX_EXIT_BUILDING
	applyonemovement PLAYER, hide_person
	waitsfx
	applymovement PLAYER, .PanUpMovement
	disappear PLAYER
	pause 10
	special Special_FadeOutMusic
	special FadeOutPalettes
	pause 15
	dotrigger $0
	end

.PanUpMovement:
	step_up
	step_up
	step_up
	step_up
	step_up
	step_end

BattleTowerOutsideSignText:
	text "Battle Tower"

	para "Take the Ultimate"
	line "Trainer Challenge!"
	done

BattleTowerOutsideYoungsterText:
	text "Wow, the Battle"
	line "Tower is huge!"

	para "There must be many"
	line "kinds of #mon"
	cont "in there!"
	done

BattleTowerOutsideBeautyText:
	text "You can use only"
	line "three #mon."

	para "It's so hard to"
	line "decide which three"

	para "should go into"
	line "battle???"
	done

BattleTowerOutsideSailorText:
	text "Hehehe, I snuck"
	line "out from work."

	para "I can't bail out"
	line "until I've won!"

	para "I have to win it"
	line "all. That I must!"
	done
