CliffCave_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 0

CliffCave_MapEventHeader:

.Warps: db 7
	warp_def 19, 7, 2, ROUTE_47
	warp_def 9, 9, 3, ROUTE_47
	warp_def 33, 7, 4, ROUTE_47
	warp_def 17, 5, 6, CLIFF_CAVE
	warp_def 17, 9, 7, CLIFF_CAVE
	warp_def 3, 5, 4, CLIFF_CAVE
	warp_def 27, 9, 5, CLIFF_CAVE

.XYTriggers: db 0

.Signposts: db 1
	signpost 9, 11, SIGNPOST_ITEM + ULTRA_BALL, EVENT_CLIFF_CAVE_HIDDEN_ULTRA_BALL

.PersonEvents: db 2
	person_event SPRITE_ROCKET, 6, 10, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, PERSONTYPE_TRAINER, 4, TrainerGruntM22, EVENT_CLEARED_YELLOW_FOREST
	person_event SPRITE_ROCKET, 33, 7, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, PERSONTYPE_COMMAND, jumptextfaceplayer, CliffCaveRocketText, EVENT_CLEARED_YELLOW_FOREST

TrainerGruntM22:
	trainer EVENT_BEAT_ROCKET_GRUNTM_22, GRUNTM, 22, GruntM22SeenText, GruntM22BeatenText, 0, GruntM22Script

GruntM22Script:
	end_if_just_battled
	jumptextfaceplayer GruntM22AfterText

GruntM22SeenText:
	text "Hey! You got past"
	line "the guards!"
	done

GruntM22BeatenText:
	text "Aieee!"
	done

GruntM22AfterText:
	text "No wonder you"
	line "were able to"
	cont "reach here."
	done

CliffCaveRocketText:
	text "Don't just wander"
	line "around during a"
	cont "Team Rocket"
	cont "operation!"
	done
