CeladonUniversityLounge_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 0

CeladonUniversityLounge_MapEventHeader:

.Warps: db 2
	warp_def 11, 4, 10, CELADON_UNIVERSITY_1F
	warp_def 11, 5, 10, CELADON_UNIVERSITY_1F

.XYTriggers: db 0

.Signposts: db 3
	signpost 5, 7, SIGNPOST_JUMPTEXT, CeladonUniversityLoungeBookshelf1Text
	signpost 8, 7, SIGNPOST_READ, CeladonUniversityLoungeBookshelf2
	signpost 7, 0, SIGNPOST_RIGHT, CeladonUniversityLoungeComputer

.PersonEvents: db 6
	person_event SPRITE_COOLTRAINER_F, 8, 5, SPRITEMOVEDATA_SPINCOUNTERCLOCKWISE, 0, 0, -1, -1, (1 << 3) | PAL_OW_RED, PERSONTYPE_SCRIPT, 0, CeladonUniversityLoungeNeeshaScript, -1
	person_event SPRITE_LASS, 1, 3, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_COMMAND, jumptextfaceplayer, CeladonUniversityLoungeLassText, -1
	person_event SPRITE_RICH_BOY, 3, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_COMMAND, jumptextfaceplayer, CeladonUniversityLoungeRichBoyText, -1
	person_event SPRITE_COOLTRAINER_F, 4, 5, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_COMMAND, jumptextfaceplayer, CeladonUniversityLoungeCooltrainerfText, -1
	person_event SPRITE_SUPER_NERD, 5, 2, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_COMMAND, jumptextfaceplayer, CeladonUniversityLoungeSuper_nerd1Text, -1
	person_event SPRITE_SUPER_NERD, 8, 1, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, (1 << 3) | PAL_OW_PURPLE, PERSONTYPE_COMMAND, jumptextfaceplayer, CeladonUniversityLoungeSuper_nerd2Text, -1

const_value set 2
	const CELADONUNIVERSITYLOUNGE_NEESHA

CeladonUniversityLoungeNeeshaScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_COOLTRAINERF_NEESHA
	iftrue .Beaten
	checkevent EVENT_INTRODUCED_CELADON_FOUR
	iftrue .IntroducedCeladonFour1
	writetext .IntroText1
	jump .AfterIntro
.IntroducedCeladonFour1
	writetext .IntroText2
.AfterIntro
	yesorno
	iffalse .NoBattle
	writetext .SeenText
	waitbutton
	closetext
	winlosstext .BeatenText, 0
	setlasttalked CELADONUNIVERSITYLOUNGE_NEESHA
	loadtrainer COOLTRAINERF, NEESHA
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_COOLTRAINERF_NEESHA
	opentext
.Beaten
	setevent EVENT_INTRODUCED_CELADON_FOUR
	checkevent EVENT_BEAT_COOLTRAINERM_COREY
	iffalse .NotFinished
	checkevent EVENT_BEAT_COOLTRAINERM_RAYMOND
	iffalse .NotFinished
	checkevent EVENT_BEAT_COOLTRAINERM_FERGUS
	iffalse .NotFinished
	checkevent EVENT_GOT_CHOICE_BAND_FROM_CELADON_FOUR
	iftrue .GotItem
	writetext .AfterText2
	buttonsound
	verbosegiveitem CHOICE_BAND
	iffalse .Done
	setevent EVENT_GOT_CHOICE_BAND_FROM_CELADON_FOUR
.GotItem:
	writetext .FinalText
	waitbutton
.Done:
	closetext
	end

.NoBattle:
	jumpopenedtext .NoBattleText

.NotFinished:
	jumpopenedtext .AfterText1

.IntroText1:
	text "Hi! I'm Neesha!"
	line "I'm one of top four"

	para "trainers in Cela-"
	line "don University."

	para "We're known as the"
	line "Celadon Four!"

	para "Want me to show"
	line "you why we're so"
	cont "famous?"

	para "Then let's battle!"
	done

.IntroText2:
	text "Hi! I'm Neesha!"
	line "I'm one of the"
	cont "Celadon Four!"

	para "It looks like"
	line "you've heard of us."

	para "Then let's battle!"
	done

.NoBattleText:
	text "Not interested in"
	line "a challenge?"
	done

.SeenText:
	text "We'll blow you"
	line "away!"
	done

.BeatenText:
	text "A painful loss???"
	done

.AfterText1:
	text "You're a worthy"
	line "opponent!"

	para "But you haven't"
	line "seen everything"

	para "the Celadon Four"
	line "can do."

	para "Why don't you find"
	line "the rest of us and"
	cont "challenge them?"
	done

.AfterText2:
	text "So you beat all of"
	line "the Celadon Four???"

	para "That's so cool!"

	para "Take this as a"
	line "prize!"
	done

.FinalText:
	text "It's not often that"
	line "someone gives us"

	para "Celadon Four a"
	line "real challenge."

	para "I won't forget"
	line "you, trainer!"
	done

CeladonUniversityLoungeLassText:
	text "Next month we're"
	line "going on a trip"
	cont "to Mt.Moon."

	para "Maybe I'll see a"
	line "Clefairy!"
	done

CeladonUniversityLoungeRichBoyText:
	text "Have you ever"
	line "wondered why"

	para "Ultra Balls have"
	line "a yellow letter"
	cont "H on the top?"

	para "It's because they"
	line "were first called"
	cont "Hyper Balls!"
	done

CeladonUniversityLoungeCooltrainerfText:
	text "#mon with"
	line "reduced physical"

	para "strength instinct-"
	line "ively attempt to"
	cont "enter a # Ball."
	done

CeladonUniversityLoungeSuper_nerd1Text:
	text "What do you get if"
	line "you cross a joke"

	para "with a rhetorical"
	line "question?"

	para "????????????????????????????????????"
	done

CeladonUniversityLoungeSuper_nerd2Text:
	text "I'm writing scripts"
	line "for a game."

	para "Do not said use"
	line "asm!"
	done

CeladonUniversityLoungeBookshelf1Text:
	text "It's stuffed full"
	line "of copies of"
	cont "#mon manga!"
	done

CeladonUniversityLoungeBookshelf2:
	opentext
	writetext .Text1
	waitbutton
	checkevent EVENT_GOT_PP_MAX_IN_UNIVERSITY
	iftrue .GotItem
	verbosegiveitem PP_MAX
	iffalse .Done
	setevent EVENT_GOT_PP_MAX_IN_UNIVERSITY
.Done
	closetext
	end

.GotItem
	jumpopenedtext .Text2

.Text1:
	text "This book has a"
	line "secret compartment"

	para "where the pages"
	line "should be!"
	done

.Text2:
	text "Too bad--it's"
	line "empty."
	done

CeladonUniversityLoungeComputer:
	thistext

	text "There's a player"
	line "character running"

	para "around a 2D"
	line "Celadon City."
	done
