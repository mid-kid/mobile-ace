RGBASM ?= rgbasm
RGBLINK ?= rgblink

MAILS := \
	crystal_us.bin \
	crystal_us_trade.bin \
	crystal_us_battle_setup.bin \
	crystal_us_battle.bin

.PHONY: all
all: $(MAILS)

.PHONY: clean
clean:
	rm -f $(MAILS) $(MAILS:.bin=.o)

crystal_us.bin: crystal_us_trade.bin
crystal_us.bin: crystal_us_battle_setup.bin
crystal_us.bin: crystal_us_battle.bin
crystal_us.bin:
	./create_mailbox.sh $^ > $@

%.bin: %.o
	$(RGBLINK) -x -o $@ $^
	@./scan_illegal.sh $@ || { rm -f $@; exit 1; }

%.o: %.asm
	$(RGBASM) -I pokecrystal -o $@ $<
