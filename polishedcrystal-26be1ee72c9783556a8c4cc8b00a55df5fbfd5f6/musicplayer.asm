; Written by Sanqui
; https://github.com/froggestspirit/CrystalComplete/blob/master/misc/musicplayer.asm

INCLUDE "includes.asm"


SECTION "Music Player Graphics", ROMX

MusicTestGFX:
INCBIN "gfx/music_player/music_test.2bpp"
PianoGFX:
INCBIN "gfx/music_player/piano.2bpp"
NotesGFX:
INCBIN "gfx/music_player/note_lines.2bpp"
WaveformsGFX:
INCBIN "gfx/music_player/waveforms.2bpp"


SECTION "Music Player", ROMX

jrbutton: macro
; assumes hl == hJoyPressed
	ld a, [hl]
	and \1
	jr nz, \2
endm

jpbutton: macro
; assumes hl == hJoyPressed
	ld a, [hl]
	and \1
	jp nz, \2
endm

jrheldbutton: macro
; assumes hl == hJoyDown
	ld a, [TextDelayFrames]
	and a
	jr nz, \3
	ld a, [hl]
	and \1
	jr z, \3
	ld a, \4
	ld [TextDelayFrames], a
	jr \2
\3:
endm

jpheldbutton: macro
; assumes hl == hJoyDown
	ld a, [TextDelayFrames]
	and a
	jr nz, \3
	ld a, [hl]
	and \1
	jr z, \3
	ld a, \4
	ld [TextDelayFrames], a
	jp \2
\3:
endm

MusicPlayerPals:
if !DEF(MONOCHROME)
	RGB 02, 03, 04
	RGB 02, 03, 04
	RGB 10, 12, 14
	RGB 26, 28, 30
else
	RGB_MONOCHROME_BLACK
	RGB_MONOCHROME_BLACK
	RGB_MONOCHROME_DARK
	RGB_MONOCHROME_WHITE
endc

MusicPlayerNotePals:
if !DEF(MONOCHROME)
	RGB 02, 03, 04 ; bg
	RGB 07, 31, 07 ; green
	RGB 07, 07, 31 ; blue
	RGB 31, 07, 07 ; red
else
	RGB_MONOCHROME_BLACK
	RGB_MONOCHROME_WHITE
	RGB_MONOCHROME_DARK
	RGB_MONOCHROME_LIGHT
endc

MusicPlayer::
	di
	call DoubleSpeed
	xor a
	ld [rIF], a
	ld a, $f
	ld [rIE], a
	ei

	call ClearTileMap

; Load palette
	ld a, [rSVBK]
	push af
	ld a, 5
	ld [rSVBK], a

	ld hl, MusicPlayerPals
	ld de, BGPals
	ld bc, 1 palettes
	call CopyBytes

	ld hl, MusicPlayerNotePals
	ld de, OBPals
	ld bc, 1 palettes
	call CopyBytes

	pop af
	ld [rSVBK], a

	ld a, 1
	ld [hCGBPalUpdate], a

	; refresh top two portions
	xor a
	ld [hBGMapThird], a
	call DelayFrame

; Load graphics
	ld de, MusicTestGFX
	lb bc, BANK(MusicTestGFX), 13
	ld hl, VTiles0 tile $d9
	call Request2bpp

	ld de, PianoGFX
	lb bc, BANK(PianoGFX), 32
	ld hl, VTiles2
	call Request2bpp

	ld de, NotesGFX
	lb bc, BANK(NotesGFX), $80
	ld hl, VTiles0
	call Request2bpp

; Prerender all waveforms
;	xor a
;.waveform_loop:
;	push af
;	call RenderWaveform
;	pop af
;	inc a
;	cp NUM_WAVEFORMS
;	jr nz, .waveform_loop

; Rendered waveforms would have difficulty filling their integrals with
; the dark hue. TPP Crystal dealt with this by doubling their width.
; Here we just use a static image.
	ld de, WaveformsGFX
	lb bc, BANK(WaveformsGFX), NUM_WAVEFORMS * 2
	ld hl, VTiles2 tile $40
	call Request2bpp

	call DelayFrame

; Clear sprites
	ld hl, rLCDC
	set 7, [hl]
	ei

	call ClearSprites

; Initialize MusicPlayerWRAM
	ld hl, MusicPlayerWRAM
	ld bc, MusicPlayerWRAMEnd - MusicPlayerWRAM
	xor a
	call ByteFill

; Clear wMPNotes
	ld a, [rSVBK]
	push af
	ld a, BANK(wMPNotes)
	ld [rSVBK], a

	xor a
	ld hl, wMPNotes
	ld bc, 4 * 256
	call ByteFill

	pop af
	ld [rSVBK], a
; fallthrough

RenderMusicPlayer:
	ld bc, SCREEN_WIDTH * MP_HUD_HEIGHT
	ld hl, MPTilemap
	decoord 0, PIANO_ROLL_HEIGHT
	call CopyBytes

	ld bc, 4 * 3
	ld hl, NoteOAM
	ld de, Sprites
	call CopyBytes
	call DelayFrame
	xor a
	ld [hOAMUpdate], a ; we will manually do it in LCD interrupt

	ld hl, wChannelSelectorSwitches
	ld a, NUM_MUSIC_CHANS - 1
.ch_label_loop:
	ld [wChannelSelector], a
	ld a, [hli]
	push hl
	call DrawChannelLabel
	pop hl
	ld a, [wChannelSelector]
	dec a
	cp -1
	jr nz, .ch_label_loop

	call DelayFrame

	ld a, [rSVBK]
	ld [hMPBuffer], a

	ld a, [wSongSelection]
	; let's see if a song is currently selected
	cp NUM_SONGS
	jr nc, .bad_selection
	and a
	jr nz, _RedrawMusicPlayer
.bad_selection
	ld a, MUSIC_MAIN_MENU
; fallthrough

_RedrawMusicPlayer:
	ld [wSongSelection], a
	ld a, -1
	ld [wChannelSelector], a
	call DrawPianoRollOverlay
; fallthrough

MusicPlayerLoop:
	ld a, $4
	ld [rSVBK], a

	call MPUpdateUIAndGetJoypad
	ld hl, hJoyDown
	jrheldbutton D_UP, .up, .no_up, 12
	jrheldbutton D_DOWN, .down, .no_down, 12
	jrheldbutton D_LEFT, .left, .no_left, 12
	jrheldbutton D_RIGHT, .right, .no_right, 12
	ld hl, hJoyPressed
	jrbutton A_BUTTON, .a
	jrbutton B_BUTTON, .b
	jrbutton START, .start
	jpbutton SELECT, .select

	; prioritize refreshing the note display
	ld a, 2
	ld [hBGMapThird], a
	jr MusicPlayerLoop

.up:
; previous song
	ld a, [wSongSelection]
	dec a
	jp nz, _RedrawMusicPlayer
	ld a, NUM_SONGS - 1
	jp _RedrawMusicPlayer

.down:
; next song
	ld a, [wSongSelection]
	inc a
	cp NUM_SONGS
	jp nz, _RedrawMusicPlayer
	ld a, 1
	jp _RedrawMusicPlayer

.left:
; 10 songs back
	ld a, [wSongSelection]
	sub MP_LIST_PAGE_SKIP
	jr z, .zerofix
	cp NUM_SONGS
	jp c, _RedrawMusicPlayer
.zerofix
	ld a, NUM_SONGS - 1
	jp _RedrawMusicPlayer

.right:
; 10 songs ahead
	ld a, [wSongSelection]
	add MP_LIST_PAGE_SKIP
	cp NUM_SONGS
	jp c, _RedrawMusicPlayer
	ld a, 1
	jp _RedrawMusicPlayer

.a:
; restart playing song
	ld a, [wSongSelection]
	ld e, a
	ld d, 0
	farcall PlayMusic2
	ld hl, wChLastNotes
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	inc a
	ld hl, wNoteEnded
	ld [hli], a
	ld [hli], a
	ld [hl], a
	jp MusicPlayerLoop

.b:
; exit music player
	xor a
	ld [hMPState], a
	ld [hVBlank], a
	ld a, [hMPBuffer]
	ld [rSVBK], a
	call ClearSprites
	ld hl, rLCDC
	res 2, [hl] ; 8x8 sprites
	di
	call NormalSpeed
	xor a
	ld [rIF], a
	ld a, $f
	ld [rIE], a
	ei
	ret

.start:
; open song selector
	xor a
	ld [hMPState], a
	ld a, [hMPBuffer]
	ld [rSVBK], a
	call SongSelector
	jp RenderMusicPlayer

.select:
	xor a
	ld [wChannelSelector], a
	hlcoord 3, MP_HUD_TOP
	ld a, "???"
	ld [hl], a
; fallthrough

SongEditor:
	call MPUpdateUIAndGetJoypad
	ld hl, hJoyDown
	jrheldbutton D_UP, .up, .no_up, 10
	jpheldbutton D_DOWN, .down, .no_down, 10
	ld hl, hJoyPressed
	jrbutton D_LEFT, .left
	jrbutton D_RIGHT, .right
	jrbutton A_BUTTON, .a
	jpbutton START, .start
	jpbutton SELECT | B_BUTTON, .select_b

	; prioritize refreshing the note display
	ld a, 2
	ld [hBGMapThird], a
	jr SongEditor

.left:
; previous editable field
	call ClearChannelSelector
	ld a, [wChannelSelector]
	dec a
	cp -1
	jr nz, .no_underflow
	ld a, NUM_MP_EDIT_FIELDS - 1 ; MP_EDIT_TEMPO
.no_underflow
	ld [wChannelSelector], a
	call DrawChannelSelector
	jr SongEditor

.right:
; next editable field
	call ClearChannelSelector
	ld a, [wChannelSelector]
	inc a
	cp NUM_MP_EDIT_FIELDS
	jr nz, .no_overflow
	xor a ; ld a, MP_EDIT_CH1
.no_overflow
	ld [wChannelSelector], a
	call DrawChannelSelector
	jp SongEditor

.a:
; for pitch: nothing
; for tempo: enter tempo adjustment mode
; otherwise: toggle editable field
	ld a, [wChannelSelector]
	cp MP_EDIT_PITCH
	jp z, SongEditor
	cp MP_EDIT_TEMPO
	jp z, AdjustTempo
	ld c, a
	ld b, 0
	ld hl, wChannelSelectorSwitches
	add hl, bc
	ld a, [hl]
	xor 1
	ld [hl], a
	call DrawChannelLabel
	jp SongEditor

.up:
; for ch1/ch2: next duty cycle
; for wave: next waveform
; for noise: next noise set
; for pitch: increase pitch transposition
	ld a, [wChannelSelector]
	ld hl, .up_jumptable
	rst JumpTable
	jp SongEditor

.up_jumptable
	dw .up_ch1_2 ; MP_EDIT_CH1
	dw .up_ch1_2 ; MP_EDIT_CH2
	dw .up_wave  ; MP_EDIT_WAVE
	dw .up_noise ; MP_EDIT_NOISE
	dw .up_pitch ; MP_EDIT_PITCH
	dw .return   ; MP_EDIT_TEMPO

.down:
; for ch1/ch2: previous duty cycle
; for wave: previous waveform
; for noise: previous noise set
; for pitch: decrease pitch transposition
	ld a, [wChannelSelector]
	ld hl, .down_jumptable
	rst JumpTable
	jp SongEditor

.down_jumptable:
	dw .down_ch1_2 ; MP_EDIT_CH1
	dw .down_ch1_2 ; MP_EDIT_CH2
	dw .down_wave  ; MP_EDIT_WAVE
	dw .down_noise ; MP_EDIT_NOISE
	dw .down_pitch ; MP_EDIT_PITCH
	dw .return     ; MP_EDIT_TEMPO

.start:
; toggle piano roll info overlay
	ld hl, wSongInfoSwitch
	ld a, [hl]
	xor 1
	ld [hl], a
	call DrawPianoRollOverlay
	jp SongEditor

.select_b:
; exit song editor
	call ClearChannelSelector
	xor a ; ld a, MP_EDIT_CH1
	ld [wChannelSelector], a
	call DrawPitchTransposition
	call DrawTempoAdjustment
	jp MusicPlayerLoop

.up_ch1_2:
; next duty cycle
	ld a, [wChannelSelector]
	ld [wTmpCh], a
	call GetDutyCycleAddr
	ld a, [hl]
	lb bc, %11000000, %01000000
	and b
	cp b
	ld a, [hl]
	jr nz, .no_ch1_2_overflow
	and %00111111
	sub c
.no_ch1_2_overflow
	add c
	jr .change_ch1_2

.down_ch1_2:
; previous duty cycle
	ld a, [wChannelSelector]
	ld [wTmpCh], a
	call GetDutyCycleAddr
	ld a, [hl]
	lb bc, %11000000, %01000000
	and b
	and a
	ld a, [hl]
	jr nz, .no_ch1_2_underflow
	add c
	and %00111111
.no_ch1_2_underflow
	sub c
.change_ch1_2:
	ld [hl], a
	ld [wCurTrackDuty], a
	ret

.up_wave:
; next waveform
	ld a, [Channel3Intensity]
	and $f
	inc a
	cp NUM_WAVEFORMS
	jr nz, .change_wave
	xor a
	jr .change_wave

.down_wave:
; previous waveform
	ld a, [Channel3Intensity]
	and $f
	dec a
	cp -1
	jr nz, .change_wave
	ld a, NUM_WAVEFORMS - 1
.change_wave:
	ld b, a
	ld a, [Channel3Intensity]
	and $f0
	or b
	ld [Channel3Intensity], a
	ld [wCurTrackIntensity], a
	farcall ReloadWaveform
	ret

.up_noise:
; next noise set
	ld a, [MusicNoiseSampleSet]
	inc a
	cp NUM_NOISE_SETS
	jr nz, .change_noise
	xor a
	jr .change_noise

.down_noise:
; previous noise set
	ld a, [MusicNoiseSampleSet]
	dec a
	cp -1
	jr nz, .change_noise
	ld a, NUM_NOISE_SETS - 1
.change_noise:
	ld [MusicNoiseSampleSet], a
.return:
	ret

.up_pitch:
; increase pitch transposition
	ld a, [wPitchTransposition]
	inc a
	cp MAX_PITCH_TRANSPOSITION + 1
	jr nz, .change_pitch
	ld a, -MAX_PITCH_TRANSPOSITION
	jr .change_pitch

.down_pitch:
; decrease pitch transposition
	ld a, [wPitchTransposition]
	dec a
	cp -(MAX_PITCH_TRANSPOSITION + 1)
	jr nz, .change_pitch
	ld a, MAX_PITCH_TRANSPOSITION
.change_pitch:
	ld [wPitchTransposition], a
	call DrawPitchTransposition
	; refresh top two portions
	xor a
	ld [hBGMapThird], a
	jp DelayFrame

AdjustTempo:
	ld a, 1
	ld [wAdjustingTempo], a
	ld a, [wTempoAdjustment]
	ld [wTmpValue], a

	call DrawChannelSelector
	; refresh top two portions
	xor a
	ld [hBGMapThird], a
	call DelayFrame

.loop:
	call MPUpdateUIAndGetJoypad
	ld hl, hJoyDown
	jrheldbutton D_UP, .up, .no_up, 6
	jrheldbutton D_DOWN, .down, .no_down, 6
	jrheldbutton D_RIGHT, .right, .no_right, 18
	jrheldbutton D_LEFT, .left, .no_left, 18
	ld hl, hJoyPressed
	jrbutton A_BUTTON, .a
	jrbutton B_BUTTON, .b
	jrbutton START, .start

	; prioritize refreshing the note display
	ld a, 2
	ld [hBGMapThird], a
	jr .loop

.up:
; increase tempo adjustment
	ld a, [wTempoAdjustment]
	inc a
	cp MAX_TEMPO_ADJUSTMENT + 1
	jr nz, .change_tempo
	ld a, -MAX_TEMPO_ADJUSTMENT
	jr .change_tempo

.down:
; decrease tempo adjustment
	ld a, [wTempoAdjustment]
	dec a
	cp -(MAX_TEMPO_ADJUSTMENT + 1)
	jr nz, .change_tempo
	ld a, MAX_TEMPO_ADJUSTMENT
	jr .change_tempo

.right:
; increase tempo adjustment by 10
	ld a, [wTempoAdjustment]
	cp MAX_TEMPO_ADJUSTMENT - 10 + 1
	jr c, .no_overflow_right
	cp -MAX_TEMPO_ADJUSTMENT
	jr nc, .no_overflow_right
	ld a, MAX_TEMPO_ADJUSTMENT - 10
.no_overflow_right
	add 10
	jr .change_tempo

.left:
; decrease tempo adjustment by 10
	ld a, [wTempoAdjustment]
	cp MAX_TEMPO_ADJUSTMENT + 1
	jr c, .no_underflow_left
	cp -(MAX_TEMPO_ADJUSTMENT - 10)
	jr nc, .no_underflow_left
	ld a, -(MAX_TEMPO_ADJUSTMENT - 10)
.no_underflow_left
	sub 10
.change_tempo:
	ld [wTempoAdjustment], a
	call DrawTempoAdjustment
	; refresh top two portions
	xor a
	ld [hBGMapThird], a
	call DelayFrame
	jp .loop

.a:
; apply tempo adjustment and exit tempo adjustment mode
	ld a, [wSongSelection]
	ld e, a
	ld d, 0
	farcall PlayMusic2
	jr .exit

.b:
; discard adjustment and exit tempo adjustment mode
	ld a, [wTmpValue]
	ld [wTempoAdjustment], a
.exit:
	xor a
	ld [wAdjustingTempo], a
	call DrawChannelSelector
	call DrawTempoAdjustment
	; refresh top two portions
	xor a
	ld [hBGMapThird], a
	call DelayFrame
	jp SongEditor

.start:
; toggle piano roll info overlay
	ld hl, wSongInfoSwitch
	ld a, [hl]
	xor 1
	ld [hl], a
	call DrawPianoRollOverlay
	jp .loop

DrawPianoRollOverlay:
	; if this takes too long, don't let the user see blank fields blink in
	; disable copying the map during vblank
	ld a, 2
	ld [hVBlank], a

	ld a, " "
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH * PIANO_ROLL_HEIGHT
	call ByteFill

	call DrawSongInfo
	call DrawChannelSelector

	ld a, 5
	ld [hVBlank], a

	; refresh top two portions
	xor a
	ld [hBGMapThird], a
	jp DelayFrame

DrawPitchTransposition:
	hlcoord 15, 1
	ld de, _EmptyPitchOrTempo
	call PlaceString
	ld a, [wChannelSelector]
	cp MP_EDIT_PITCH
	ld a, [wPitchTransposition]
	jr z, .continue
	and a
	ret z
.continue
	ld [hl], "P"
	bit 7, a
	jr nz, .negative
	ld de, wPitchTransposition
	ld a, "+"
	jr .printnum
.negative
	xor $ff
	inc a
	ld de, wTmpValue
	ld [de], a
	ld a, "-"
.printnum
	hlcoord 16, 1
	ld [hli], a
	lb bc, PRINTNUM_RIGHTALIGN | 1, 2
	jp PrintNum

DrawTempoAdjustment:
	hlcoord 15, 2
	ld de, _EmptyPitchOrTempo
	call PlaceString
	ld a, [wChannelSelector]
	cp MP_EDIT_TEMPO
	ld a, [wTempoAdjustment]
	jr z, .continue
	and a
	ret z
.continue
	ld [hl], "T"
	bit 7, a
	jr nz, .negative
	ld de, wTempoAdjustment
	ld a, "+"
	jr .printnum
.negative
	xor $ff
	inc a
	ld de, wTmpValue
	ld [de], a
	ld a, "-"
.printnum
	hlcoord 16, 2
	ld [hli], a
	lb bc, PRINTNUM_RIGHTALIGN | 1, 3
	jp PrintNum

_EmptyPitchOrTempo: db "     @"

DrawChannelSelector:
	call DrawPitchTransposition
	call DrawTempoAdjustment
	ld a, [wChannelSelector]
	cp -1
	ret z
	cp MP_EDIT_PITCH
	jr z, .pitch
	cp MP_EDIT_TEMPO
	jr z, .tempo
	call _LocateChannelSelector
	ld [hl], "???"
	ret

.pitch:
	hlcoord 14, 1
	jr .draw
.tempo:
	hlcoord 14, 2
.draw
	ld a, [wAdjustingTempo]
	and a
	ld a, "???"
	jr z, .ok
	ld a, "???"
.ok
	ld [hl], a
	ret

ClearChannelSelector:
	ld a, [wChannelSelector]
	cp MP_EDIT_PITCH
	jr z, .pitch
	cp MP_EDIT_TEMPO
	jr z, .tempo
	call _LocateChannelSelector
	ld [hl], $1e
	call DrawPitchTransposition
	jr DrawTempoAdjustment

.pitch:
	hlcoord 14, 1
	jr .clear
.tempo:
	hlcoord 14, 2
.clear
	ld [hl], " "
	ret

_LocateChannelSelector:
	ld c, 5
	call SimpleMultiply
	hlcoord 3, MP_HUD_TOP
	add l
	ld l, a
	ret nc
	inc h
	ret

DrawChannelLabel:
	and a
	jr nz, .off
	ld de, ChannelsOnTilemaps
	jr .draw
.off
	ld de, ChannelsOffTilemaps
.draw
	ld a, [wChannelSelector]
	ld l, a
	ld h, 0
	add hl
	add l
	ld l, a
	add hl, de
	push hl

	hlcoord 0, MP_HUD_TOP
	ld a, [wChannelSelector]
	ld c, 5
	call SimpleMultiply
	ld e, a
	ld d, 0
	add hl, de
	push hl
	pop de
	pop hl
rept 3
	ld a, [hli]
	ld [de], a
	inc de
endr
	ret

DrawChData:
	hlcoord 0, MP_HUD_TOP + 1
.loop:
	ld [wTmpCh], a
	call _DrawCh1_2_3
	inc a
	ld de, 2
	add hl, de
	cp CHAN4
	jr c, .loop

	; channel 4
	hlcoord 18, MP_HUD_TOP + 1
	ld a, [MusicNoiseSampleSet]
	add $f6
	ld [hl], a

	hlcoord 17, MP_HUD_TOP + 2
	ld a, [wChannelSelectorSwitches + CHAN4]
	and a
	jr nz, .blank_hit
	ld a, [wNoiseHit]
	and a
	jr z, .blank_hit
	ld a, $e1
	jr .got_hit
.blank_hit
	ld a, " "
.got_hit
	ld [hl], a
	xor a
	ld [wNoiseHit], a
	ret

_DrawCh1_2_3:
	push af
	push hl
	call CheckChannelOn
	ld a, 0
	ld hl, NoteNames
	jr c, .blank_note_name
	call GetPitchAddr
	ld a, [hl]
	ld hl, NoteNames
	call GetNthString
.blank_note_name
	ld e, l
	ld d, h
	pop hl
	push hl
	call PlaceString
	call GetOctaveAddr
	ld d, [hl]
	ld a, "8"
	sub d
	pop hl
	inc hl
	inc hl
	ld [hli], a

	ld a, [wTmpCh]
	cp CHAN3
	jr nc, .no_duty_cycle
	push hl
	ld de, SCREEN_WIDTH
	add hl, de
	push hl
	call GetDutyCycleAddr
	ld a, [hl]
	pop hl
	and %11000000
	swap a
	srl a
	srl a
	add $e2
	ld [hl], a
	pop hl

.no_duty_cycle
	push hl
	dec hl
	dec hl
	dec hl
	ld a, $d9
	ld de, SCREEN_WIDTH
	add hl, de
	ld [hli], a
	ld [hld], a

	push hl
	call CheckChannelOn
	pop hl
	ld a, 0 ; not xor a; preserve carry flag
	jr c, .blank_volume
	push hl
	call GetPitchAddr
	ld a, [hl]
	and a
	pop hl
	ld a, 0 ; not xor a; preserve carry flag
	jr z, .blank_volume
	push hl
	call GetIntensityAddr
	ld a, [hl]
	pop hl
.blank_volume
	and $f
	srl a
	add $d9
	ld [hli], a
	ld [hld], a
	ld a, [wTmpCh]
	cp 2
	jr nz, .finish

	hlcoord 12, MP_HUD_TOP + 2
	; pick the waveform
	ld a, [Channel3Intensity]
	and $f
	sla a
	add $40
	ld [hli], a
	inc a
	ld [hl], a

.finish:
	pop hl
	pop af
	ret

;RenderWaveform:
;	ld [wRenderedWaveform], a
;	ld l, a
;	ld h, 0
;	; hl << 4
;	; each wavepattern is $f bytes long
;	; so seeking is done in $10s
;rept 4
;	add hl, hl
;endr
;	ld de, WaveSamples
;	add hl, de
;	; load wavepattern into wWaveformTmp
;	ld de, wWaveformTmp
;	ld bc, 16
;	ld a, BANK(WaveSamples)
;	call FarCopyBytes ; copy bc bytes from a:hl to de
;
;	ld hl, TempMPWaveform
;	ld bc, 2 tiles
;	xor a
;	call ByteFill
;
;	ld hl, TempMPWaveform
;	ld de, wWaveformTmp
;	ld b, 1
;
;.loop:
;	ld a, [de]
;	push de
;
;	swap a
;	and %1110
;	xor %1110
;	ld c, a
;	add l
;	ld l, a
;	jr nc, .nc
;	inc h
;.nc
;	ld a, b
;	and $7
;	ld d, a
;	; c = row
;	; b = (d) = column
;	ld a, $1
;.rotate_a
;	rrc a
;	dec d
;	jr nz, .rotate_a
;	or [hl]
;	ld [hli], a
;	ld [hl], a
;
;	pop de
;	inc de
;	inc b
;	ld a, b
;	cp TILE_WIDTH * 2 + 1
;	jr z, .done
;	cp TILE_WIDTH + 1
;	jr nc, .tile2
;	ld hl, TempMPWaveform
;	jr .loop
;.tile2
;	ld hl, TempMPWaveform + 1 tiles
;	jr .loop
;
;.done
;	ld hl, VTiles2 tile $40
;	ld a, [wRenderedWaveform]
;	swap a
;	sla a
;	ld l, a
;	jr nc, .got_hl
;	inc h
;.got_hl
;	lb bc, 0, 2
;	ld de, TempMPWaveform
;	call Request2bpp
;	ret

DrawNotes:
	xor a ; ld a, CHAN1
	ld [wTmpCh], a
	call DrawNote
	call CheckForVolumeBarReset
	ld a, CHAN2
	ld [wTmpCh], a
	call DrawNote
	call CheckForVolumeBarReset
	ld a, CHAN3
	ld [wTmpCh], a
	call DrawNote
	call CheckForVolumeBarReset

	ld a, [rSVBK]
	push af
	ld a, 4
	ld [rSVBK], a
	ld a, [hMPState]
	inc a
	ld [hMPState], a
	cp PIANO_ROLL_HEIGHT_PX + 1 + 1
	jr c, .skip
	ld a, 1
	ld [hMPState], a
.skip
	dec a
	push af
	call .CopyNotes
	pop af
	add PIANO_ROLL_HEIGHT_PX
	call nc, .CopyNotes
	pop af
	ld [rSVBK], a
	ret

.CopyNotes:
	ld bc, 4
	ld hl, wMPNotes
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wPitchesTmp
	jp CopyBytes

CheckEndedNote:
; Check that the current channel is actually playing a note.

; Rests count as ends.
	call GetIntensityAddr
	ld a, [hl]
	and a
	jr z, _NoteEnded
; fallthrough

CheckNoteDuration:
	ld a, [wTmpCh]
	ld bc, Channel2 - Channel1

; Note duration
	ld hl, Channel1NoteDuration
	call AddNTimes
	ld a, [hl]
	cp 2
	jr c, _NoteEnded
; fallthrough

CheckChannelOn:
; Channel on/off flag
	ld a, [wTmpCh]
	ld bc, Channel2 - Channel1
	ld hl, Channel1Flags
	call AddNTimes
	bit SOUND_CHANNEL_ON, [hl]
	jr z, _NoteEnded

; Rest flag
; Note flags are wiped after each
; note is read, so this is pointless.
	ld a, [wTmpCh]
	ld hl, Channel1NoteFlags
	call AddNTimes
	bit SOUND_REST, [hl]
	jr nz, _NoteEnded

; Do an IO check too if the note's envelope is 0
; and not ramping up since the game handles rest
; notes by temporarily write 0 to hi nibble of NRx2
	ld a, [wTmpCh]
	cp 2
	jr nz, .notch3 ; NR32 does something different
	ld a, [rNR32]
	and $60
	jr z, _NoteEnded ; 0% volume
	jr .still_going

.notch3
	ld bc, 5
	ld hl, rNR12
	call AddNTimes
	ld a, [hl]
	ld b, a
	and $f0
	jr nz, .still_going
	ld a, b
	bit 3, a
	jr z, _NoteEnded ; ramping down
	and $7
	jr z, _NoteEnded ; no ramping
.still_going
	and a
	ret

_NoteEnded:
	scf
	ret

DrawNote:
	call CheckChannelOn
	jr c, _WriteBlankNote
	call GetPitchAddr
	ld a, [hl]
	and a
	jr z, _WriteBlankNote ; rest
	inc hl
	ld a, [hld] ; octave
	ld c, 14
	call SimpleMultiply
	add [hl] ; pitch
	ld b, a
	ld hl, wChLastNotes
	ld a, [wTmpCh]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	cp b
	jr z, DrawLongerNote
DrawChangedNote:
	ld [hl], b
	call SetVisualIntensity
DrawNewNote:
	call GetPitchAddr
	push hl
	inc hl
	ld a, [hl]
	xor $f ; octaves are in reverse order
	sub $8
	ld bc, 28
	ld hl, 8
	call AddNTimes
	ld b, l
	pop hl
	ld a, [hl]
	dec a
	ld hl, .Pitchels
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	add b
	ld c, a
	jr WriteNotePitch

.Pitchels:
	db 1, 3, 5, 7, 9, 13, 15, 17, 19, 21, 23, 25, 27

DrawLongerNote:
	ld a,[wTmpCh]
	ld hl, Channel1Intensity
	ld bc, Channel2 - Channel1
	call AddNTimes
	ld a, [hl]
	and $f
	cp $9
	jr nc, .fading_up
	call CheckEndedNote
	jr c, _WriteBlankNote
	jr DrawNewNote

.fading_up
	call CheckNoteDuration
	jr c, _WriteBlankNote
	jr DrawNewNote

_WriteBlankNote:
	xor a
	ld c, a

WriteNotePitch:
	ld hl, wPitchesTmp
	ld a, [wTmpCh]
	ld e, a
	ld d, 0
	add hl, de
	ld a, c
	ld [hl], a
	ret

CheckForVolumeBarReset:
	call CheckNoteDuration
	jr c, .note_ended ; not a new note, but this note just ended!
	ld hl, wNoteEnded
	ld a, [wTmpCh]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	and a
	ret z ; also not a new note
	xor a ; new note!
	ld [hl], a
	ret

.note_ended:
	ld hl, wNoteEnded
	ld a, [wTmpCh]
	ld e, a
	ld d, 0
	add hl, de
	ld a, 1
	ld [hl], a
	ld hl, wChLastNotes
	add hl, de
	xor a
	ld [hl], a
	ret

SetVisualIntensity:
	ld a,[wTmpCh]
	ld hl, Channel1Pitch
	ld bc, Channel2 - Channel1
	call AddNTimes
	ld a, [hl]
	and a
	jr z, .skip
	ld a,[wTmpCh]
	ld hl, Channel1Intensity
	ld bc, Channel2 - Channel1
	push af
	call AddNTimes
	pop af
	cp 2
	jr z, .wave_channel
	ld a, [hl]
	ld e, a
	swap a
	and $f
	ld d, a
	ld a, [wTmpCh]
	ld hl, wC1Vol
	ld bc, 2
	call AddNTimes
	ld a, d
	ldi [hl], a
	ld a, e
	and $f
	ld e, a
	swap a
	or e
	and $f7
	ld [hl], a
	ret

.wave_channel:
	ld a, [hl]
	and $f0
	cp $10
	jr z, .full
	cp $20
	jr z, .half
	cp $30
	jr z, .quarter
	xor a
	jr .set_wave_vol
.full
	ld a, $f
	jr .set_wave_vol
.half
	ld a, $7
	jr .set_wave_vol
.quarter
	ld a, $3
.set_wave_vol
	ld hl, wC3Vol
	ld [hl], a
	ret

.skip:
	ld a, [wTmpCh]
	ld hl, wC1Vol
	ld bc, 2
	call AddNTimes
	xor a
	ld [hli], a
	ld [hl], a
	ret

UpdateVisualIntensity:
	ld c, 4
	ld hl, wVolTimer
	ld a, [hl]
	sub 60
	ld [hl], a
	ret nc
	add 64
	ldi [hl], a
.update_channels:
	inc hl
	ld a, [hld]
	ld b, a
	and $7f
	jr z, .next_channel
	ld a, b
	dec a
	ld b, a
	and $f
	jr z, .change_envelope
	inc hl
	jr .done_ch
.change_envelope
	ld a, b
	swap a
	or b
	and $f7
	ld b, a
	ld a, [hl]
	bit 7, b
	jr nz, .increase
	dec a
	bit 7, a
	jr z, .done_inc
	xor a
	jr .done_inc
.increase
	inc a
	bit 4, a
	jr z, .done_inc
	ld a, $f
.done_inc
	ld [hli], a
.done_ch:
	ld a, b
	ld [hld], a
.next_channel
	inc hl
	inc hl
	dec c
	ret z
	ld a, c
	cp 2
	jr z, .next_channel
	jr .update_channels

AddNoteToOld:
	push hl
	ld a, [wNumNoteLines]
	add a
	add a
	ld c, a
	ld b, 0
	ld hl, Sprites + 3 * 4
	add hl, bc
	push hl
	pop de
	pop hl
rept 3
	ld a, [hli]
	ld [de], a
	inc de
endr
	ld a, [hl]
	ld [de], a

	ld a, [wNumNoteLines]
	inc a
	cp $25
	jr nz, .finish
	xor a
.finish
	ld [wNumNoteLines], a
	ret

GetPitchAddr:
	ld hl, Channel1Pitch
	jr _GetChannelMemberAddr

GetOctaveAddr:
	ld hl, Channel1Octave
	jr _GetChannelMemberAddr

GetDutyCycleAddr:
	ld hl, Channel1DutyCycle
_GetChannelMemberAddr:
	ld a, [wTmpCh]
	ld bc, Channel2 - Channel1
	jp AddNTimes

GetIntensityAddr:
	ld a, [wTmpCh]
	ld hl, wC1Vol
	ld bc, 2
	jp AddNTimes

GetSongInfo:
	ld a, [wSongSelection]
	ld b, a
	ld c, 0
	ld hl, SongInfo
.loop:
	ld a, [hl]
	cp -1
	jr z, .no_name
	inc c
	ld a, c
	cp b
	jr z, .found
.loop2:
	ld a, [hli]
	cp "@"
	jr z, .nextline
	jr .loop2
.found
	xor a
	ret
.nextline
rept 3
	inc hl
endr
	jr .loop

.no_name:
	scf
	ret

DrawSongInfo:
	ld a, [wSongSelection]
	call GetSongInfo
	ret c ; no data

	ld a, [wSongInfoSwitch]
	and a
	jr z, .info
	hlcoord 0, 1
	jr DrawSongID

.info:
	call GetSongTitle
	hlcoord 0, 3
	call PlaceString
	inc de

	push de
	call GetSongOrigin
	hlcoord 0, 1
	push de
	call DrawSongID
	pop de
	inc hl
	call PlaceString
	pop de
	inc de

	push de
	call GetSongArtist
	hlcoord 0, 7
	call PlaceString
	pop de
	inc de

	push de
	call GetSongArtist2
	hlcoord 0, 10
	call PlaceString
	pop de
	ret

DrawSongID:
	ld a, "<SHARP>"
	ld [hli], a
	ld a, [wSongSelection]
	cp 10
	jr c, .print_digit
	lb bc, 1, 2
	cp 100
	jr c, .print_id
	lb bc, 1, 3
.print_id
	ld de, wSongSelection
	jp PrintNum

.print_digit
	add "0"
	ld [hli], a
	ret

GetSongOrigin:
	ld a, [de]
	ld hl, SongOrigins
	call GetNthString
GetSongTitle:
	push hl
	pop de
	ret

GetSongArtist:
	ld a, [de]
	ld hl, SongArtists
	call GetNthString
	push hl
	ld de, .Composer
	hlcoord 0, 6
	call PlaceString
	pop de
	ret

.Composer:
	db "Composer:@"

GetSongArtist2:
	ld a, [de]
	ld hl, SongArtists
	call GetNthString
	push hl
	ld a, [hl]
	cp "@"
	jr z, .finish
	ld de, .Arranger
	hlcoord 0, 9
	call PlaceString
.finish
	pop de
	ret

.Arranger:
	db "Arranger:@"

SongSelector:
	hlcoord 0, 0
	ld a, " "
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	call ByteFill
	call ClearSprites

	hlcoord 0, 0
	lb bc, SCREEN_HEIGHT - 2, SCREEN_WIDTH - 2
	call TextBox

	hlcoord 0, MP_LIST_CURSOR_Y
	ld [hl], "???"
	ld a, [wSongSelection]
	ld [wSelectorTop], a ; backup, in case of B button
	cp MP_LIST_CURSOR_Y
	jr nc, .ok
	add NUM_SONGS - 1
.ok
	sub MP_LIST_CURSOR_Y - 1
	ld [wSongSelection], a
	call UpdateSelectorNames

.loop:
	call DelayFrame
	call MPGetJoypad
	ld hl, hJoyDown
	jrheldbutton D_UP, .up, .no_up, 6
	jrheldbutton D_DOWN, .down, .no_down, 6
	jrheldbutton D_LEFT, .left, .no_left, 18
	jrheldbutton D_RIGHT, .right, .no_right, 18
	ld hl, hJoyPressed
	jrbutton A_BUTTON, .a
	jrbutton START | B_BUTTON, .start_b
	jr .loop

.a:
; select song
	ld a, [wSongSelection]
	cp NUM_SONGS - MP_LIST_CURSOR_Y + 1
	jr c, .no_overflow
	sub NUM_SONGS - MP_LIST_CURSOR_Y
	jr .got_song
.no_overflow
	add MP_LIST_CURSOR_Y - 1
.got_song
	ld [wSongSelection], a
	ld e, a
	ld d, 0
	farcall PlayMusic2
	ret

.up
; previous song
	ld a, [wSongSelection]
	dec a
	jr nz, .no_underflow_up
	ld a, NUM_SONGS - 1
.no_underflow_up
	ld [wSongSelection], a
	call UpdateSelectorNames
	jp .loop

.down:
; next song
	ld a, [wSongSelection]
	inc a
	cp NUM_SONGS
	jr nz, .no_overflow_down
	ld a, 1
.no_overflow_down
	ld [wSongSelection], a
	call UpdateSelectorNames
	jp .loop

.left:
; 10 songs back
	ld a, [wSongSelection]
	cp MP_LIST_PAGE_SKIP + 1
	jr nc, .no_underflow_left
	add NUM_SONGS - 1
.no_underflow_left
	sub MP_LIST_PAGE_SKIP
	ld [wSongSelection], a
	call UpdateSelectorNames
	jp .loop

.right:
; 10 songs ahead
	ld a, [wSongSelection]
	cp NUM_SONGS - MP_LIST_PAGE_SKIP
	jr c, .no_overflow_right
	sub NUM_SONGS - 1
.no_overflow_right
	add MP_LIST_PAGE_SKIP
	ld [wSongSelection], a
	call UpdateSelectorNames
	jp .loop

.start_b:
; exit song selector
	ld a, [wSelectorTop]
	ld [wSongSelection], a
	ret

UpdateSelectorNames:
	call GetSongInfo
	ld a, [wSongSelection]
	ld c, a
	ld b, 0
	push hl
	pop de
.loop:
	hlcoord 1, 1
	ld a, c
	ld [wSelectorCur], a
	push bc
	ld a, b
	ld bc, SCREEN_WIDTH
	call AddNTimes
	call MPLPlaceString
rept 4
	inc de
endr
	pop bc
	inc b
	inc c
	ld a, c
	cp NUM_SONGS
	jr c, .noOverflow
	ld c, 1
	ld de, SongInfo
.noOverflow
	ld a, b
	cp 16 ; songs per page
	jr nz, .loop
	ret

MPUpdateUIAndGetJoypad:
	call UpdateVisualIntensity
	call DelayFrame
	call DrawChData
	call DrawNotes
MPGetJoypad:
	ld a, [TextDelayFrames]
	and a
	jr z, .ok2
	dec a
	ld [TextDelayFrames], a
.ok2
	jp GetJoypad

MPLPlaceString:
	push hl
	ld a, " "
	ld hl, StringBuffer2
	ld bc, 3
	call ByteFill
	ld hl, StringBuffer2
	push de
	ld de, wSelectorCur
	lb bc, 1, 3
	call PrintNum
	pop de
	ld [hl], " "
	inc hl
	ld b, 0
.loop:
	ld a, [de]
	ld [hl], a
	cp "@"
	jr nz, .next
	ld [hl], " "
	dec de
.next
	inc hl
	inc de
	inc b
	ld a, b
	cp 14
	jr c, .loop
	ld a, [de]
	cp "@"
	jr nz, .not_end
	ld [hl], a
	jr .last
.not_end
	dec hl
	ld [hl], "???"
	inc hl
	ld [hl], "@"
.loop2:
	inc de
	ld a, [de]
	cp "@"
	jr nz, .loop2
.last:
	pop hl
	push de
	ld de, StringBuffer2
	call PlaceString
	pop de
	ret

NoteNames:
	db "- @"
	db "C @"
	db "C<SHARP>@"
	db "D @"
	db "D<SHARP>@"
	db "E @"
	db "F @"
	db "F<SHARP>@"
	db "G @"
	db "G<SHARP>@"
	db "A @"
	db "A<SHARP>@"
	db "B @"
	db "--@"

MPTilemap:
db $00, $01, $02, $03, $04, $05, $06, $00, $01, $02, $03, $04, $05, $06, $00, $01, $02, $03, $04, $05
db $07, $08, $09, $1e, $1d, $07, $08, $0a, $1e, $1d, $0b, $0c, $0d, $1e, $1d, $0e, $0f, $10, $1e, $1e
db "    ", $1f, "    ", $1f, "    ", $1f, $1b, $1c, "   "
db "    ", $1f, "    ", $1f, "    ", $1f, "     "

ChannelsOnTilemaps:
	db $07, $08, $09
	db $07, $08, $0a
	db $0b, $0c, $0d
	db $0e, $0f, $10

ChannelsOffTilemaps:
	db $11, $12, $13
	db $11, $12, $14
	db $15, $16, $17
	db $18, $19, $1a

NoteOAM:
	; y, x, tile id, OAM attributes
	db 0, 0, $20, BEHIND_BG
	db 0, 0, $40, BEHIND_BG
	db 0, 0, $60, BEHIND_BG

SongInfo:
	; title, origin, composer, additional credits
	db "Opening@", ORIGIN_C, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Title Screen@", ORIGIN_C, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Main Menu@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "New Bark Town@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA_GO_ICHINOSE, COMPOSER_NONE
	db "Mom@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Elm's Lab@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Lyra Appears@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Rival@", ORIGIN_XY, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Lyra Departs@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Route 29@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Vs.Johto Wild@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Vs.Johto Wild Night@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Victory! Wild@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Cherrygrove City@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Follow Me!@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Pok??mon Center@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Heal Pok??mon@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Captured Pok??mon@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Spotted! Youngster@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Vs.Johto Trainer@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Victory! Trainer@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Route 30@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Violet City@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Sprout Tower@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Spotted! Sage@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Pok?? Mart@", ORIGIN_HGSS, COMPOSER_GO_ICHINOSE, COMPOSER_FROGGESTSPIRIT
	db "Union Cave@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Ruins of Alph@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Unown Radio@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Azalea Town@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Spotted! Team Rocket@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Vs.Team Rocket@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Route 34@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Rival Appears@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Vs.Rival@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Rival Departs@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Evolution@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Goldenrod City@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Pok??Com Center@", ORIGIN_C, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Gym@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Vs.Johto Gym Leader@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Final Pok??mon@", ORIGIN_BW, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Victory! Gym Leader@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Pok??mon Channel@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Buena's Password@", ORIGIN_C, COMPOSER_MORIKAZU_AOKI, COMPOSER_NONE
	db "Game Corner@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Bicycle@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Spotted! Lass@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "National Park@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Bug-Catching Contest@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Bug-Catching ContestRanking@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Ecruteak City@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Dance Theater@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Spotted! Kimono Girl@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Burned Tower@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Eusine Appears@", ORIGIN_C, COMPOSER_MORIKAZU_AOKI, COMPOSER_NONE
	db "Prof.Oak's Pok??mon   Talk@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Route 38@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Pok??mon March@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Olivine Lighthouse@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Surfing@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Cianwood City@", ORIGIN_HGSS, COMPOSER_GO_ICHINOSE, COMPOSER_MMMMMM
	db "Route 47@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Jessie & James      Appear@", ORIGIN_Y, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Safari Zone Gate@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Surfing Pikachu@", ORIGIN_Y, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Route 42@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Stark Mountain@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Rocket Radio@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Rocket Hideout@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Spotted! Pok??maniac@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Radio Tower Occu-   pied!@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Ice Path@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Dragon's Den@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Clair@", ORIGIN_C, COMPOSER_MORIKAZU_AOKI, COMPOSER_NONE
	db "Route 4@", ORIGIN_BW, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Bell Tower@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Vs.Suicune@", ORIGIN_C, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Route 26@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Indigo Plateau@", ORIGIN_RB, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Victory Road@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Indigo Plateau@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Vs.Elite Four@", ORIGIN_SM, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Champion@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Hall of Fame@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "S.S.Aqua@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Vermilion City@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Vs.Kanto Gym Leader@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Lavender Town@", ORIGIN_RB, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Pok??mon Tower@", ORIGIN_RB, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Lavender Town@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA_GO_ICHINOSE, COMPOSER_NONE
	db "Vs.Kanto Wild@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Cerulean City@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Route 24@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Magnet Train@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Black City@", ORIGIN_BW, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Pok??mon Lullaby@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Celadon City@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Game Corner@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Canalave City@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Bicycle@", ORIGIN_XY, COMPOSER_JUNICHI_MASUDA, COMPOSER_SHANTYTOWN
	db "Route 11@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Pok?? Flute@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Route 209@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Route 210@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Route 225@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Diglett's Cave@", ORIGIN_RB, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Viridian Forest@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA_GO_ICHINOSE, COMPOSER_NONE
	db "Spotted! Hiker@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Pewter City@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Route 3@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Spotted! Officer@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Mt.Moon@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Mt.Moon Square@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Route 1@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Pallet Town@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Prof.Oak Appears@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Spotted! Beauty@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Vs.Kanto Trainer@", ORIGIN_GS, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Cinnabar Island@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Cinnabar Mansion@", ORIGIN_RB, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Vs.Trainer@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Eterna Forest@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Mt.Chimney@", ORIGIN_RSE, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Mt.Pyre@", ORIGIN_RSE, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Battle Tower@", ORIGIN_C, COMPOSER_MORIKAZU_AOKI, COMPOSER_NONE
	db "Battle Tower Lobby@", ORIGIN_C, COMPOSER_MORIKAZU_AOKI, COMPOSER_NONE
	db "Vs.Trainer@", ORIGIN_BW, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Frontier Brain@", ORIGIN_RSE, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Zinnia Appears@", ORIGIN_ORAS, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Route 205@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Vs.Wild@", ORIGIN_SM, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Sunyshore City@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Vs.Trainer@", ORIGIN_SM, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Route 203@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "White Treehollow@", ORIGIN_B2W2, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Laverre City@", ORIGIN_XY, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Route 101@", ORIGIN_RSE, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Dewford Town@", ORIGIN_RSE, COMPOSER_JUNICHI_MASUDA, COMPOSER_SHANTYTOWN
	db "Oreburgh Gate@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Route 12@", ORIGIN_BW, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Road to Reversal    Mountain@", ORIGIN_B2W2, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Zinnia@", ORIGIN_ORAS, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Wally Appears@", ORIGIN_ORAS, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Wally@", ORIGIN_ORAS, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Spiky-Eared Pichu@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Mother Beast@", ORIGIN_SM, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Frost Cavern@", ORIGIN_XY, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Power Plant@", ORIGIN_XY, COMPOSER_JUNICHI_MASUDA, COMPOSER_SHANTYTOWN
	db "Reversal Mountain@", ORIGIN_B2W2, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Meteor Falls@", ORIGIN_RSE, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Lugia's Song@", ORIGIN_M02, COMPOSER_JUNICHI_MASUDA, COMPOSER_PUM
	db "Vs.Lugia@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_PIGU
	db "Summoning Dance@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Ho-Oh@", ORIGIN_HGSS, COMPOSER_JUNICHI_MASUDA, COMPOSER_PIGU
	db "Cerulean Cave@", ORIGIN_RB, COMPOSER_JUNICHI_MASUDA, COMPOSER_NONE
	db "Abandoned Ship@", ORIGIN_RSE, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Kanto Legend@", ORIGIN_XY, COMPOSER_JUNICHI_MASUDA, COMPOSER_GACT_PIGU
	db "Vs.Gym Leader@", ORIGIN_RSE, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Gym Leader@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_PUM
	db "Vs.Gym Leader@", ORIGIN_BW, COMPOSER_JUNICHI_MASUDA, COMPOSER_PUM
	db "Vs.Gym Leader@", ORIGIN_XY, COMPOSER_JUNICHI_MASUDA, COMPOSER_PUM
	db "Vs.Elite Four@", ORIGIN_BW, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Celestial Tower@", ORIGIN_BW, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Champion@", ORIGIN_RSE, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Mt.Coronet@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Champion@", ORIGIN_DPPT, COMPOSER_JUNICHI_MASUDA, COMPOSER_FROGGESTSPIRIT
	db "Vs.World Champion-  ship Finals@", ORIGIN_BW, COMPOSER_JUNICHI_MASUDA, COMPOSER_PIGU_PIKALAXALT
	db "Vs.Champion@", ORIGIN_B2W2, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Credits@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Post-Credits@", ORIGIN_GS, COMPOSER_GO_ICHINOSE, COMPOSER_NONE
	db "Title@", ORIGIN_XY, COMPOSER_JUNICHI_MASUDA, COMPOSER_SHANTYTOWN
	db "Marine Tube@", ORIGIN_B2W2, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Legendary@", ORIGIN_XY, COMPOSER_JUNICHI_MASUDA, COMPOSER_MMMMMM
	db "Vs.Naljo Wild@", ORIGIN_PRISM, COMPOSER_LEVUSBEVUS, COMPOSER_FROGGESTSPIRIT
	db "Vs.Naljo Trainer@", ORIGIN_PRISM, COMPOSER_GACT, COMPOSER_NOTFROGGESTSPIRIT
	db "Vs.Naljo Leader@", ORIGIN_PRISM, COMPOSER_GRONNOC, COMPOSER_FROGGESTSPIRIT
	db "Vs.Palette Ranger@", ORIGIN_PRISM, COMPOSER_CAT333POKEMON, COMPOSER_NOTFROGGESTSPIRIT
	db -1

SongOrigins:
	db "R/B@"
	db "Y@"
	db "G/S@"
	db "C@"
	db "R/S/E@"
	db "FR/LG@"
	db "D/P/Pt@"
	db "HG/SS@"
	db "B/W@"
	db "B2/W2@"
	db "X/Y@"
	db "OR/AS@"
	db "S/M@"
	db "M02@"
	db "Prism@"

SongArtists:
	db "@"
	db "Junichi Masuda@"
	db "Go Ichinose@"
	db "Junichi Masuda,     Go Ichinose@"
	db "Morikazu Aoki@"
	db "Ichiro Shimakura@"
	db "Shota Kageyama@"
	db "FroggestSpirit@"
	db "Mmmmmm@"
	db "Pum@"
	db "ShantyTown@"
	db "Pigu@"
	db "Pigu, PikalaxALT@"
	db "GACT, Pigu@"
	db "LevusBevus@"
	db "GACT@"
	db "GRonnoc@"
	db "Cat333Pokemon@"
	db "NotFroggestSpirit@"
