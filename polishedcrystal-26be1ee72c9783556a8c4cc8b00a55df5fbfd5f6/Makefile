NAME := polishedcrystal
VERSION := 3.0.0-beta

TITLE := PKPCRYSTAL
MCODE := PKPC
ROMVERSION := 0x30

FILLER = 0x00

RGBASM_FLAGS =
RGBLINK_FLAGS = -n $(ROM_NAME).sym -m $(ROM_NAME).map -l contents/contents.link -p $(FILLER)
RGBFIX_FLAGS = -Cjv -t $(TITLE) -i $(MCODE) -n $(ROMVERSION) -p $(FILLER) -k 01 -l 0x33 -m 0x10 -r 3

CFLAGS = -O3 -std=c11 -Wall -Wextra -pedantic

ifeq ($(filter faithful,$(MAKECMDGOALS)),faithful)
RGBASM_FLAGS += -DFAITHFUL
endif
ifeq ($(filter nortc,$(MAKECMDGOALS)),nortc)
RGBASM_FLAGS += -DNO_RTC
endif
ifeq ($(filter monochrome,$(MAKECMDGOALS)),monochrome)
RGBASM_FLAGS += -DMONOCHROME
endif
ifeq ($(filter debug,$(MAKECMDGOALS)),debug)
RGBASM_FLAGS += -DDEBUG
endif


.SUFFIXES:
.PHONY: all clean crystal faithful nortc debug monochrome bankfree freespace compare
.SECONDEXPANSION:
.PRECIOUS: %.2bpp %.1bpp


roms_md5      = roms.md5
bank_ends_txt = contents/bank_ends.txt

PYTHON = python
CC     = gcc
RM     = rm -f
GFX    = $(PYTHON) gfx.py
LZ     = utils/lzcomp
MD5    = md5sum

includes  := $(PYTHON) utils/scan_includes.py
bank_ends := $(PYTHON) contents/bank_ends.py $(NAME)-$(VERSION)


crystal_obj := \
wram.o \
main.o \
home.o \
audio.o \
maps.o \
tilesets.o \
musicplayer.o \
engine/events.o \
engine/credits.o \
data/egg_moves.o \
data/evos_attacks.o \
data/pokedex/entries.o \
text/common_text.o \
gfx/pics.o


all: crystal

crystal: FILLER = 0x00
crystal: ROM_NAME = $(NAME)-$(VERSION)
crystal: $(NAME)-$(VERSION).gbc

faithful: crystal
nortc: crystal
monochrome: crystal
debug: crystal

bankfree: FILLER = 0xff
bankfree: ROM_NAME = $(NAME)-$(VERSION)-0xff
bankfree: $(NAME)-$(VERSION)-0xff.gbc

freespace: $(bank_ends_txt) $(roms_md5)

clean:
	$(RM) $(crystal_obj) $(wildcard $(NAME)-*.gbc) $(wildcard $(NAME)-*.map) $(wildcard $(NAME)-*.sym)

compare: crystal
	$(MD5) -c $(roms_md5)


$(LZ): $(LZ).c
	$(CC) $(CFLAGS) -o $@ $<

$(bank_ends_txt): crystal bankfree ; $(bank_ends) > $@

$(roms_md5): crystal
	$(MD5) $(NAME)-$(VERSION).gbc > $@


%.asm: ;

%.o: dep = $(shell $(includes) $(@D)/$*.asm)
%.o: %.asm $$(dep)
	rgbasm $(RGBASM_FLAGS) -o $@ $<

.gbc:
%.gbc: $(crystal_obj)
	rgblink $(RGBLINK_FLAGS) -o $@ $^
	rgbfix $(RGBFIX_FLAGS) $@

%.png: ;
%.2bpp: %.png ; $(GFX) 2bpp $<
%.1bpp: %.png ; $(GFX) 1bpp $<
%.lz: % ; $(LZ) $< $@

%.pal: %.2bpp ;
gfx/pics/%/normal.pal gfx/pics/%/bitmask.asm gfx/pics/%/frames.asm: gfx/pics/%/front.2bpp ;
%.bin: ;
%.blk: ;
%.tilemap: ;
