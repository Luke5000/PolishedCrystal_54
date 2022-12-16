Route24_MapScriptHeader:

.MapTriggers: db 0

.MapCallbacks: db 0

Route24_MapEventHeader:

.Warps: db 0

.XYTriggers: db 0

.Signposts: db 0

.PersonEvents: db 1
	person_event SPRITE_ROCKET, 7, 8, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, 0, PERSONTYPE_TRAINER, 1, TrainerGruntM31, EVENT_ROUTE_24_ROCKET

const_value set 2
	const ROUTE24_ROCKET

TrainerGruntM31:
	trainer EVENT_BEAT_ROCKET_GRUNTM_31, GRUNTM, 31, UnknownText_0x1adc2e, UnknownText_0x1add67, 0, RocketScript_0x1adbfa

RocketScript_0x1adbfa:
	playmusic MUSIC_ROCKET_ENCOUNTER
	opentext
	writetext UnknownText_0x1addc0
	buttonsound
	special Special_FadeOutMusic
	writetext UnknownText_0x1adee1
	waitbutton
	closetext
	special Special_FadeBlackQuickly
	special Special_ReloadSpritesNoPalettes
	disappear ROUTE24_ROCKET
	setevent EVENT_LEARNED_ABOUT_MACHINE_PART
	clearevent EVENT_ROUTE_25_MISTY_BOYFRIEND
	variablesprite SPRITE_CERULEAN_CAPE_MISTY, SPRITE_MISTY
	domaptrigger CERULEAN_CAPE, $1
	pause 25
	special Special_FadeInQuickly
	playmusic MUSIC_NUGGET_BRIDGE_HGSS
	end

UnknownText_0x1adc2e:
	text "Hey, kid! Me am a"
	line "Team Rocket member"
	cont "kind of guy!"

	para "Come from another"
	line "country, a trainer"
	cont "number one, me!"

	para "Think I did, if"
	line "stop the energy,"

	para "be big panic for"
	line "here people!"

	para "Secret it is my"
	line "mission, so tell"
	cont "you I not!"

	para "But! If win you do"
	line "versus me, a man I"

	para "be and mine secret"
	line "to you I tell."

	para "Hey, kid! Battle"
	line "begin we do!"
	done

UnknownText_0x1add67:
	text "Ayieeeh! No, no,"
	line "no, believe it I"
	cont "can't!"

	para "Strong very much"
	line "be you! Match I am"
	cont "not to you!"
	done

UnknownText_0x1addc0:
	text "OK. Tell you mine"
	line "secret will I."

	para "Machine Part steal"
	line "by me, hide it I"

	para "did in Gym of the"
	line "Cerulean."

	para "Inside water put"
	line "it I did. Look for"

	para "in water center of"
	line "Gym at."

	para "But you forget me"
	line "not!"

	para "Beat you for sure"
	line "will Team Rocket."

	para "Come from Johto"
	line "will they, mine"

	para "friends, yes. Will"
	line "revenge they are."
	done

UnknownText_0x1adee1:
	text "…"

	para "You say what? Team"
	line "Rocket bye-bye a"

	para "go-go? Broken it"
	line "is says you?"

	para "Oh, no! Should I"
	line "do what now on"
	cont "from, me?"
	done
