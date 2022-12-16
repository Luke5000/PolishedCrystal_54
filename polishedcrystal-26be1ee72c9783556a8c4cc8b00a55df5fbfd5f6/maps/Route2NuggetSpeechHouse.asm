Route2NuggetSpeechHouse_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 0

Route2NuggetSpeechHouse_MapEventHeader:

.Warps: db 2
	warp_def 7, 2, 1, ROUTE_2_NORTH
	warp_def 7, 3, 1, ROUTE_2_NORTH

.XYTriggers: db 0

.Signposts: db 0

.PersonEvents: db 1
	person_event SPRITE_FISHER, 4, 1, SPRITEMOVEDATA_WALK_UP_DOWN, 2, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_SCRIPT, 0, FisherScript_0x9b847, -1

FisherScript_0x9b847:
	faceplayer
	opentext
	checkevent EVENT_GOT_NUGGET_FROM_GUY
	iftrue .GotItem
	writetext UnknownText_0x9b865
	buttonsound
	verbosegiveitem NUGGET
	iffalse .Done
	setevent EVENT_GOT_NUGGET_FROM_GUY
.GotItem:
	writetext UnknownText_0x9b8e5
	waitbutton
.Done:
	closetext
	end

UnknownText_0x9b865:
	text "Hi! Wow, I'm glad"
	line "to see you."

	para "You're the first"
	line "visitor I've had"
	cont "in a long time."

	para "I'm super-happy!"
	line "Let me give you a"
	cont "little present."
	done

UnknownText_0x9b8e5:
	text "That's a Nugget."

	para "I can't give you"
	line "any nuggets of"

	para "wisdom, so that'll"
	line "have to do!"
	done
