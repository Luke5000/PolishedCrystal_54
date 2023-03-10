HallOfFame_MapScriptHeader:

.MapTriggers: db 1
	dw HallOfFameEntranceTrigger

.MapCallbacks: db 0

HallOfFame_MapEventHeader:

.Warps: db 2
	warp_def 13, 4, 3, LANCES_ROOM
	warp_def 13, 5, 4, LANCES_ROOM

.XYTriggers: db 0

.Signposts: db 0

.PersonEvents: db 1
	person_event SPRITE_LANCE, 12, 4, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, ObjectEvent, -1

const_value set 2
	const HALLOFFAME_LANCE

HallOfFameEntranceTrigger:
	priorityjump .Script
	end

.Script:
	follow HALLOFFAME_LANCE, PLAYER
	applymovement HALLOFFAME_LANCE, .WalkUpMovement
	stopfollow
	spriteface PLAYER, RIGHT
	opentext
	writetext .LanceText1
	waitbutton
	checkcode VAR_BADGES
	if_equal 16, .CheckGoldTrophy
	checkevent EVENT_DECO_SILVER_TROPHY
	iftrue .NoTrophy
	jump .SilverTrophy
.CheckGoldTrophy
	checkevent EVENT_DECO_GOLD_TROPHY
	iftrue .NoTrophy
	jump .GoldTrophy
.SilverTrophy
	writetext .LanceTrophyText
	waitbutton
	setevent EVENT_DECO_SILVER_TROPHY
	writetext .SilverTrophyText
	playsound SFX_ITEM
	pause 60
	waitbutton
	writetext .SilverTrophySentText
	waitbutton
	jump .NoTrophy
.GoldTrophy
	writetext .LanceTrophyText
	waitbutton
	setevent EVENT_DECO_GOLD_TROPHY
	writetext .GoldTrophyText
	playsound SFX_ITEM
	pause 60
	waitbutton
	writetext .GoldTrophySentText
	waitbutton
	jump .NoTrophy
.NoTrophy
	writetext .LanceText2
	waitbutton
	closetext
	spriteface HALLOFFAME_LANCE, UP
	applyonemovement PLAYER, slow_step_up
	dotrigger $1
	pause 15
	writebyte 2 ; Machine is in the Hall of Fame
	special HealMachineAnim
	checkcode VAR_BADGES
	if_less_than 16, .NotATrueRematch
	setevent EVENT_BEAT_ELITE_FOUR_AGAIN
.NotATrueRematch
	setevent EVENT_BEAT_ELITE_FOUR
	setevent EVENT_TELEPORT_GUY
	setevent EVENT_RIVAL_SPROUT_TOWER
	setevent EVENT_OLIVINE_PORT_SPRITES_BEFORE_HALL_OF_FAME
	clearevent EVENT_OLIVINE_PORT_SPRITES_AFTER_HALL_OF_FAME
	special RespawnOneOffs
	domaptrigger SPROUT_TOWER_3F, $1
	special HealParty
	checkevent EVENT_GOT_SS_TICKET_FROM_ELM
	iftrue .SkipPhoneCall
	specialphonecall SPECIALCALL_SSTICKET
.SkipPhoneCall:
	halloffame
	end

.WalkUpMovement:
	step_up
	step_up
	step_up
	step_up
	step_up
	step_up
	step_up
	step_up
	step_right
	turn_head_left
	step_end

.LanceText1:
	text "Lance: It's been a"
	line "long time since I"
	cont "last came here."

	para "This is where we"
	line "honor the League"

	para "Champions for all"
	line "eternity."

	para "Their courageous"
	line "#mon are also"
	cont "inducted."
	done

.LanceTrophyText:
	text "Take this as a"
	line "memento of what"

	para "you accomplished"
	line "here today."
	done

.LanceText2:
	text "Here today, we"
	line "witnessed the rise"

	para "of a new League"
	line "Champion--a"

	para "trainer who feels"
	line "compassion for,"

	para "and trust toward,"
	line "all #mon."

	para "A trainer who"
	line "succeeded through"

	para "perseverance and"
	line "determination."

	para "The new League"
	line "Champion who has"

	para "all the makings"
	line "of greatness!"

	para "<PLAYER>, allow me"
	line "to register you"

	para "and your partners"
	line "as Champions!"
	done

.GoldTrophyText:
	text "<PLAYER> received"
	line "Gold Trophy."
	done

.GoldTrophySentText:
	text "Gold Trophy"
	line "was sent home."
	done

.SilverTrophyText:
	text "<PLAYER> received"
	line "Silver Trophy."
	done

.SilverTrophySentText:
	text "Silver Trophy"
	line "was sent home."
	done
