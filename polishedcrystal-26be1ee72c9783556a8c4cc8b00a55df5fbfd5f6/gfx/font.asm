FontNormal:
INCBIN "gfx/font/normal.1bpp"
FontNarrow:
INCBIN "gfx/font/narrow.1bpp"
FontBold:
INCBIN "gfx/font/bold.1bpp"
FontItalic:
INCBIN "gfx/font/italic.1bpp"
FontSerif:
INCBIN "gfx/font/serif.1bpp"
FontUnown:
INCBIN "gfx/font/unown.1bpp"
FontCommon:
INCBIN "gfx/font/common.1bpp"

Frames: ; f8800
INCBIN "gfx/frames/1.1bpp"
INCBIN "gfx/frames/2.1bpp"
INCBIN "gfx/frames/3.1bpp"
INCBIN "gfx/frames/4.1bpp"
INCBIN "gfx/frames/5.1bpp"
INCBIN "gfx/frames/6.1bpp"
INCBIN "gfx/frames/7.1bpp"
INCBIN "gfx/frames/8.1bpp"
INCBIN "gfx/frames/9.1bpp"
; f89b0

; Various misc graphics here.

BattleExtrasGFX:
INCBIN "gfx/battle/extras.2bpp"

GFX_Stats: ; f89b0
INCBIN "gfx/stats/stats.2bpp"
; f8ac0

StatusIconGFX:
INCBIN "gfx/battle/status.2bpp"

EnemyStatusIconGFX:
INCBIN "gfx/battle/status-enemy.2bpp"

TypeIconGFX:
INCBIN "gfx/battle/types.2bpp"

CategoryIconGFX:
INCBIN "gfx/battle/categories.2bpp"

TownMapGFX: ; f8ba0
INCBIN "gfx/pokegear/town_map.2bpp.lz"
; f8ea4

JohtoKantoGFX:
INCBIN "gfx/pokegear/johto-kanto.2bpp"

TextBoxSpaceGFX: ; f9204
INCBIN "gfx/frames/space.1bpp"
; f9214

MapEntryFrameGFX: ; f9344
INCBIN "gfx/frames/map_entry_sign.2bpp"
; f9424

_LoadStandardFont:: ; fb449
	call LoadStandardFontPointer
	ld d, h
	ld e, l
	ld hl, VTiles1
	lb bc, BANK(FontNormal), $80
	ld a, [rLCDC]
	bit 7, a
	jr z, .one
	call Get1bpp_2
	jr .ok
.one
	call Copy1bpp
.ok
	ld de, FontCommon
	ld hl, VTiles1 tile ("★" - $80) ; first common font character
	lb bc, BANK(FontCommon), $d
	ld a, [rLCDC]
	bit 7, a
	jp z, Copy1bpp
	jp Get1bpp_2
; fb48a

LoadStandardFontPointer::
	ld hl, .FontPointers
	ld a, [Options2]
	and FONT_MASK
	ld d, 0
	ld e, a
rept 2
	add hl, de
endr
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld h, d
	ld l, e
	ret

.FontPointers:
	dw FontNormal
	dw FontNarrow
	dw FontBold
	dw FontItalic
	dw FontSerif
	dw FontUnown
	dw FontNormal
	dw FontNormal

_LoadFontsBattleExtra:: ; fb4be
	ld de, BattleExtrasGFX
	ld hl, VTiles2 tile $5f
	lb bc, BANK(BattleExtrasGFX), 26
	call Get2bpp_2
; fb4cc

LoadFrame:: ; fb4cc
	ld a, [TextBoxFrame]
	ld bc, TILES_PER_FRAME * LEN_1BPP_TILE
	ld hl, Frames
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, VTiles2 tile $79
	lb bc, BANK(Frames), TILES_PER_FRAME
	call Get1bpp_2
	ld hl, VTiles2 tile $7f
	ld de, TextBoxSpaceGFX
	lb bc, BANK(TextBoxSpaceGFX), 1
	jp Get1bpp_2
; fb4f2

LoadBattleFontsHPBar: ; fb4f2
	call _LoadFontsBattleExtra

LoadStatusIcons: ; fb50d
	call LoadPlayerStatusIcon
	call LoadEnemyStatusIcon
	jp InstantReloadPaletteHack
; fb53e

LoadPlayerStatusIcon:
	push de
	ld a, [PlayerSubStatus2]
	ld de, BattleMonStatus
	farcall GetStatusConditionIndex
	ld hl, StatusIconGFX
	ld de, 2 tiles
.loop
	and a
	jr z, .done
	add hl, de
	dec a
	jr .loop
.done
	ld d, h
	ld e, l
	ld hl, VTiles2 tile $55
	lb bc, BANK(StatusIconGFX), 2
	call Request2bpp
	farcall LoadPlayerStatusIconPalette
	pop de
	ret

LoadEnemyStatusIcon:
	push de
	ld a, [EnemySubStatus2]
	ld de, EnemyMonStatus
	farcall GetStatusConditionIndex
	ld hl, EnemyStatusIconGFX
	ld de, 2 tiles
.loop
	and a
	jr z, .done
	add hl, de
	dec a
	jr .loop
.done
	ld d, h
	ld e, l
	ld hl, VTiles2 tile $57
	lb bc, BANK(EnemyStatusIconGFX), 2
	call Request2bpp
	farcall LoadEnemyStatusIconPalette
	pop de
	ret

InstantReloadPaletteHack:
; Hack to make the palette load instantly
	ld a, [rSVBK]
	push af
	push de
	ld a, $5 ; gfx
	ld [rSVBK], a
; copy & reorder bg pal buffer
	ld hl, BGPals + 5 palettes ; to
	ld de, UnknBGPals + 5 palettes ; from
; order
	ld a, [rBGP]
	ld b, a
; 1 pal
	ld c, 1
	call CopyPals
; request pal update
	ld a, 1
	ld [hCGBPalUpdate], a
	pop de
	pop af
	ld [rSVBK], a
	ret

LoadStatsScreenGFX: ; fb53e
	call _LoadFontsBattleExtra

LoadStatsGFX: ; fb571
	ld de, GFX_Stats
	ld hl, VTiles2 tile $31
	lb bc, BANK(GFX_Stats), 14
	jp Get2bpp_2
; fb57e
