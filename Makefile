RGBASM ?= rgbasm
RGBLINK ?= rgblink

MAILS := crystal_us_trade crystal_us_battle crystal_us_battle_setup

.PHONY: all
all: $(addsuffix .bin, $(MAILS))

.PHONY: clean
clean:
	rm -f $(addsuffix .bin, $(MAILS)) $(addsuffix .o, $(MAILS))

%.bin: %.o
	$(RGBLINK) -x -o $@ $^

%.o: %.asm
	$(RGBASM) -I pokecrystal -o $@ $<
