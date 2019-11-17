RGBASM ?= rgbasm
PYTHON3 ?= python3

MAILS := crystal_us_trade crystal_us_battle crystal_us_battle_setup

.PHONY: all
all: $(addsuffix .bin, $(MAILS))

.PHONY: clean
clean:
	rm -f $(addsuffix .bin, $(MAILS)) $(addsuffix .o, $(MAILS))

%.bin: %.o
	@echo "$(PYTHON3) -m rgbbin $<"
	@(cd rgbbin; $(PYTHON3) -m rgbbin -o ../ ../$<)

%.o: %.asm
	@echo "$(RGBASM) -o $@ $<"
	@(cd pokecrystal; $(RGBASM) -o ../$@ ../$<)
