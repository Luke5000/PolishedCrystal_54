Route35Goldenrodgate_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 0

Route35Goldenrodgate_MapEventHeader:

.Warps: db 4
	warp_def 0, 4, 1, ROUTE_35
	warp_def 0, 5, 2, ROUTE_35
	warp_def 7, 4, 12, GOLDENROD_CITY
	warp_def 7, 5, 12, GOLDENROD_CITY

.XYTriggers: db 0

.Signposts: db 0

.PersonEvents: db 3
	person_event SPRITE_OFFICER, 4, 0, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_SCRIPT, 0, OfficerScript_0x69d37, -1
	person_event SPRITE_BREEDER, 4, 6, SPRITEMOVEDATA_WALK_UP_DOWN, 1, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_SCRIPT, 0, BreederScript_0x69dc6, -1
	person_event SPRITE_FISHER, 2, 3, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, (1 << 3) | PAL_OW_PURPLE, PERSONTYPE_COMMAND, jumptextfaceplayer, UnknownText_0x6a0cb, -1

OfficerScript_0x69d37:
	faceplayer
	opentext
	checkevent EVENT_GOT_HP_UP_FROM_RANDY
	iftrue .gothpup
	checkevent EVENT_GAVE_KENYA
	iftrue .questcomplete
	checkevent EVENT_GOT_KENYA
	iftrue .alreadyhavekenya
	writetext UnknownText_0x69ddd
	yesorno
	iffalse .refused
	writetext UnknownText_0x69e48
	buttonsound
	waitsfx
	checkcode VAR_PARTYCOUNT
	if_equal PARTY_LENGTH, .partyfull
	writetext UnknownText_0x69eb8
	playsound SFX_KEY_ITEM
	waitsfx
	givepoke FARFETCH_D, 10, NO_ITEM, 1, GiftFarfetch_dName, GiftFarfetch_dOTName
	givepokeitem GiftFarfetch_dMail
	writebyte NEST_BALL
	special SetLastPartyMonBall
	setevent EVENT_GOT_KENYA
.alreadyhavekenya
	jumpopenedtext UnknownText_0x69ed6

.partyfull
	jumpopenedtext UnknownText_0x69f56

.refused
	jumpopenedtext UnknownText_0x69f74

.questcomplete
	writetext UnknownText_0x69f8b
	buttonsound
	verbosegiveitem HP_UP
	iffalse .bagfull
	setevent EVENT_GOT_HP_UP_FROM_RANDY
.gothpup
	writetext UnknownText_0x69fd9
	waitbutton
.bagfull
	closetext
	end

GiftFarfetch_dMail:
	db   FLOWER_MAIL
	db   "Dark Cave leads"
	next "to another road@"

GiftFarfetch_dName:
	db "Kenya@"

GiftFarfetch_dOTName:
	db "Randy@"

	db 0

BreederScript_0x69dc6:
	faceplayer
	opentext
	checkevent EVENT_FOUGHT_SUDOWOODO
	iftrue .aftersudowoodo
	jumpopenedtext UnknownText_0x6a00a

.aftersudowoodo
	jumpopenedtext UnknownText_0x6a09a

UnknownText_0x69ddd:
	text "Excuse me, kid!"
	line "Can you do a guy"
	cont "a favor?"

	para "Can you take this"
	line "#mon with Mail"
	cont "to my friend?"

	para "He's on Route 31."
	done

UnknownText_0x69e48:
	text "You will? Perfect!"
	line "Thanks, kid!"

	para "My pal's a chubby"
	line "guy who snoozes"
	cont "all the time."

	para "You'll recognize"
	line "him right away!"
	done

UnknownText_0x69eb8:
	text "<PLAYER> received a"
	line "#mon with Mail."
	done

UnknownText_0x69ed6:
	text "You can read it,"
	line "but don't lose it!"
	cont "Route 31!"

	para "Oh, yeah. There"
	line "was a weird tree"
	cont "blocking the road."

	para "I wonder if it's"
	line "been cleared?"
	done

UnknownText_0x69f56:
	text "You can't carry"
	line "another #mon???"
	done

UnknownText_0x69f74:
	text "Oh??? Never mind,"
	line "then???"
	done

UnknownText_0x69f8b:
	text "Thanks, kid! You"
	line "made the delivery"
	cont "for me!"

	para "Here's something"
	line "for your trouble!"
	done

UnknownText_0x69fd9:
	text "My pal was snooz-"
	line "ing, right? Heh,"
	cont "what'd I say?"
	done

UnknownText_0x6a00a:
	text "A strange tree is"
	line "blocking the road."

	para "It wriggles around"
	line "if you talk to it."

	para "I heard it became"
	line "wild when someone"

	para "watered it with a"
	line "SquirtBottle."
	done

UnknownText_0x6a09a:
	text "I like the #mon"
	line "Lullaby they play"
	cont "on the radio."
	done

UnknownText_0x6a0cb:
	text "I wonder how many"
	line "kinds of #mon"

	para "there are in the"
	line "world."

	para "Three years ago,"
	line "Prof.Oak said that"

	para "there were 150"
	line "different kinds."
	done
