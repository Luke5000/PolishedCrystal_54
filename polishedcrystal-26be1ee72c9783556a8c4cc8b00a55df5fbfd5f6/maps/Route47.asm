Route47_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 1
	dbw MAPCALLBACK_TILES, Route47TileScript

Route47_MapEventHeader:

.Warps: db 6
	warp_def 21, 67, 2, CLIFF_EDGE_GATE
	warp_def 21, 53, 1, CLIFF_CAVE
	warp_def 17, 52, 2, CLIFF_CAVE
	warp_def 29, 53, 3, CLIFF_CAVE
	warp_def 23, 11, 1, QUIET_CAVE_1F
	warp_def 23, 8, 1, EMBEDDED_TOWER

.XYTriggers: db 0

.Signposts: db 4
	signpost 23, 8, SIGNPOST_JUMPTEXT, Route47SealedCaveSignText
	signpost 32, 36, SIGNPOST_JUMPTEXT, Route47QuietCaveSignText
	signpost 33, 34, SIGNPOST_ITEM + PEARL, EVENT_ROUTE_47_HIDDEN_PEARL
	signpost 28, 12, SIGNPOST_ITEM + STARDUST, EVENT_ROUTE_47_HIDDEN_STARDUST

.PersonEvents: db 15
	person_event SPRITE_POKEFAN_M, 26, 59, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, (1 << 3) | PAL_OW_BROWN, PERSONTYPE_TRAINER, 3, TrainerHikerDevin, EVENT_YELLOW_FOREST_ROCKET_TAKEOVER
	person_event SPRITE_YOUNGSTER, 24, 40, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_TRAINER, 2, TrainerCamperGrant, EVENT_YELLOW_FOREST_ROCKET_TAKEOVER
	person_event SPRITE_COOLTRAINER_M, 18, 38, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_TRAINER, 1, TrainerAceDuoThomandkae1, EVENT_YELLOW_FOREST_ROCKET_TAKEOVER
	person_event SPRITE_COOLTRAINER_F, 18, 39, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_TRAINER, 1, TrainerAceDuoThomandkae2, EVENT_YELLOW_FOREST_ROCKET_TAKEOVER
	person_event SPRITE_YOUNGSTER, 7, 27, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 1, TrainerCoupleDuffandeda1, EVENT_YELLOW_FOREST_ROCKET_TAKEOVER
	person_event SPRITE_LASS, 7, 28, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_TRAINER, 1, TrainerCoupleDuffandeda2, EVENT_YELLOW_FOREST_ROCKET_TAKEOVER
	person_event SPRITE_COWGIRL, 8, 51, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BROWN, PERSONTYPE_TRAINER, 3, TrainerCowgirlDaniela, EVENT_YELLOW_FOREST_ROCKET_TAKEOVER
	person_event SPRITE_ROCKET_GIRL, 27, 55, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_TRAINER, 4, TrainerGruntF6, EVENT_CLEARED_YELLOW_FOREST
	person_event SPRITE_ROCKET, 20, 36, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, PERSONTYPE_TRAINER, 2, TrainerGruntM23, EVENT_CLEARED_YELLOW_FOREST
	person_event SPRITE_ROCKET, 9, 30, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, 0, PERSONTYPE_TRAINER, 3, TrainerGruntM26, EVENT_CLEARED_YELLOW_FOREST
	person_event SPRITE_ROCKET_GIRL, 24, 47, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_COMMAND, jumptextfaceplayer, Route47RocketGirlText, EVENT_CLEARED_YELLOW_FOREST
	itemball_event 28, 39, REVIVE, 1, EVENT_ROUTE_47_REVIVE
	itemball_event 32, 7, MYSTIC_WATER, 1, EVENT_ROUTE_47_MYSTIC_WATER
	itemball_event 20, 31, QUICK_CLAW, 1, EVENT_ROUTE_47_QUICK_CLAW
	itemball_event 6, 7, MAX_REPEL, 1, EVENT_ROUTE_47_MAX_REPEL

Route47TileScript:
	checkevent EVENT_DOOR_OPENED_IN_RUINS_OF_ALPH
	iffalse .locked
	changeblock 8, 22, $2b
.locked
	return

TrainerHikerDevin:
	trainer EVENT_BEAT_HIKER_DEVIN, HIKER, DEVIN, HikerDevinSeenText, HikerDevinBeatenText, 0, HikerDevinScript

HikerDevinScript:
	end_if_just_battled
	jumptextfaceplayer HikerDevinAfterText

TrainerCamperGrant:
	trainer EVENT_BEAT_CAMPER_GRANT, CAMPER, GRANT, CamperGrantSeenText, CamperGrantBeatenText, 0, CamperGrantScript

CamperGrantScript:
	end_if_just_battled
	jumptextfaceplayer CamperGrantAfterText

TrainerAceDuoThomandkae1:
	trainer EVENT_BEAT_ACE_DUO_THOM_AND_KAE, ACE_DUO, THOMANDKAE1, AceDuoThomandkae1SeenText, AceDuoThomandkae1BeatenText, 0, AceDuoThomandkae1Script

AceDuoThomandkae1Script:
	end_if_just_battled
	jumptextfaceplayer AceDuoThomandkae1AfterText

TrainerAceDuoThomandkae2:
	trainer EVENT_BEAT_ACE_DUO_THOM_AND_KAE, ACE_DUO, THOMANDKAE2, AceDuoThomandkae2SeenText, AceDuoThomandkae2BeatenText, 0, AceDuoThomandkae2Script

AceDuoThomandkae2Script:
	end_if_just_battled
	jumptextfaceplayer AceDuoThomandkae2AfterText

TrainerCoupleDuffandeda1:
	trainer EVENT_BEAT_COUPLE_DUFF_AND_EDA, COUPLE, DUFFANDEDA1, CoupleDuffandeda1SeenText, CoupleDuffandeda1BeatenText, 0, CoupleDuffandeda1Script

CoupleDuffandeda1Script:
	end_if_just_battled
	jumptextfaceplayer CoupleDuffandeda1AfterText

TrainerCoupleDuffandeda2:
	trainer EVENT_BEAT_COUPLE_DUFF_AND_EDA, COUPLE, DUFFANDEDA2, CoupleDuffandeda2SeenText, CoupleDuffandeda2BeatenText, 0, CoupleDuffandeda2Script

CoupleDuffandeda2Script:
	end_if_just_battled
	jumptextfaceplayer CoupleDuffandeda2AfterText

TrainerCowgirlDaniela:
	trainer EVENT_BEAT_COWGIRL_DANIELA, COWGIRL, DANIELA, CowgirlDanielaSeenText, CowgirlDanielaBeatenText, 0, CowgirlDanielaScript

CowgirlDanielaScript:
	end_if_just_battled
	jumptextfaceplayer CowgirlDanielaAfterText

TrainerGruntF6:
	trainer EVENT_BEAT_ROCKET_GRUNTF_6, GRUNTF, 6, GruntF6SeenText, GruntF6BeatenText, 0, GruntF6Script

GruntF6Script:
	end_if_just_battled
	jumptextfaceplayer GruntF6AfterText

TrainerGruntM23:
	trainer EVENT_BEAT_ROCKET_GRUNTM_23, GRUNTM, 23, GruntM23SeenText, GruntM23BeatenText, 0, GruntM23Script

GruntM23Script:
	end_if_just_battled
	jumptextfaceplayer GruntM23AfterText

TrainerGruntM26:
	trainer EVENT_BEAT_ROCKET_GRUNTM_26, GRUNTM, 26, GruntM26SeenText, GruntM26BeatenText, 0, GruntM26Script

GruntM26Script:
	end_if_just_battled
	jumptextfaceplayer GruntM26AfterText

HikerDevinSeenText:
	text "Battles are"
	line "battles, so"
	cont "let's go!"
	done

HikerDevinBeatenText:
	text "Wah ha ha!"
	done

HikerDevinAfterText:
	text "After a battle,"
	line "you should part"
	cont "with a laugh!"
	done

CamperGrantSeenText:
	text "I'm not good with"
	line "crowds, so I'm"
	cont "camping out here"
	cont "with my #mon!"
	done

CamperGrantBeatenText:
	text "I should head"
	line "deeper into the"
	cont "mountain???"
	done

CamperGrantAfterText:
	text "See ya!"
	done

AceDuoThomandkae1SeenText:
	text "Thom: One plus one"
	line "is two. But the"

	para "two of us together"
	line "is much stronger!"
	done

AceDuoThomandkae1BeatenText:
	text "Thom: That wasn't"
	line "what I expected???"
	done

AceDuoThomandkae1AfterText:
	text "Thom: Your power"
	line "is impossible to"
	cont "predict!"
	done

AceDuoThomandkae2SeenText:
	text "Kae: The two of us"
	line "aren't just some"
	cont "boring pair!"
	done

AceDuoThomandkae2BeatenText:
	text "Kae: You're"
	line "unusual, too!"
	done

AceDuoThomandkae2AfterText:
	text "Kae: I figured you"
	line "were an ordinary"

	para "lone trainer."
	line "Boy, was I wrong!"
	done

CoupleDuffandeda1SeenText:
	text "Duff: Watching"
	line "over my girlfriend"

	para "makes my heart"
	line "soar!"
	done

CoupleDuffandeda1BeatenText:
	text "Duff: I was no"
	line "match for you???"
	done

CoupleDuffandeda1AfterText:
	text "Duff: Thank you"
	line "for the awe-"
	cont "inspiring battle!"
	done

CoupleDuffandeda2SeenText:
	text "Eda: My feelings"
	line "for my boyfriend"

	para "are as wide and"
	line "deep as the ocean."
	done

CoupleDuffandeda2BeatenText:
	text "Eda: You're really"
	line "something???"
	done

CoupleDuffandeda2AfterText:
	text "Eda: You should"
	line "find a wonderful"
	cont "partner, too."
	done

CowgirlDanielaSeenText:
	text "Hiya, cutie!"
	done

CowgirlDanielaBeatenText:
	text "Well aren't you a"
	line "feisty one?"
	done

CowgirlDanielaAfterText:
	text "Have you ever"
	line "tried to ride a"
	cont "Tauros?"
	done

GruntF6SeenText:
	text "Why should we"
	line "raise #mon like"
	cont "ordinary trainers?"

	para "We're Team Rocket!"
	done

GruntF6BeatenText:
	text "Who are you?!"
	done

GruntF6AfterText:
	text "If we treated"
	line "every single"
	cont "#mon well,"

	para "how would we"
	line "make money?"
	done

GruntM23SeenText:
	text "Aww, are you here"
	line "to save the cute"
	cont "little #mon?"
	done

GruntM23BeatenText:
	text "Ack!"
	line "You're tough!"
	done

GruntM23AfterText:
	text "It doesn't matter."
	line "You can't beat"
	cont "all of us!"
	done

GruntM26SeenText:
	text "Stop meddling with"
	line "our plans!"
	done

GruntM26BeatenText:
	text "Just leave us"
	line "alone???"
	done

GruntM26AfterText:
	text "How we treat"
	line "#mon is none"
	cont "of your business!"
	done

Route47RocketGirlText:
	text "What are you head-"
	line "ing this way for,"
	cont "you brat?"
	done

Route47SealedCaveSignText:
	text "There's a door-"
	line "shaped groove in"
	cont "the rock."
	done

Route47QuietCaveSignText:
	text "Route 47"

	para "West to"
	line "Quiet Cave"
	done
