SRC     = src
OBJ     = obj
CFG		= cfg
DIST    = dist
UTIL    = util
REL     = releases
ATR     = $(REL)/"Magic Castle (1983)(May, Bruce)(US)[BASIC].atr"

.PHONY: clean run

dist: $(DIST)/MC $(DIST)/AUTORUN.SYS
	dir2atr -b Dos20 720 $(ATR) $(DIST) 

$(DIST)/MC: $(DIST)/MC.TXT
	atari800 -xl -basic -playback $(UTIL)/enter_save.rec cfg/Dos20s.atr -H1 dist/

$(DIST)/MC.TXT: $(SRC)/mc.txt $(UTIL)/ascii2atascii
	$(UTIL)/ascii2atascii $(SRC)/mc.txt > $(DIST)/MC.TXT

$(UTIL)/ascii2atascii:
	make -C $(UTIL) ascii2atascii

#$(CFG)/dist.md5: $(DIST)/AUTORUN.SYS $(DIST)/MC $(DIST)/MC.TXT
#	md5sum $(DIST)/AUTORUN.SYS $(DIST)/MC $(DIST)/MC.TXT > $(CFG)/dist.md5

# Merge together 4 binary chunks into single autoloading binary
$(DIST)/AUTORUN.SYS: $(OBJ)/patch_antic_off.bin $(OBJ)/binary_data_006.bin $(OBJ)/binary_data_129.bin $(OBJ)/patch_antic_on.bin
	cat $(OBJ)/patch_antic_off.bin $(OBJ)/binary_data_006.bin $(OBJ)/binary_data_129.bin $(OBJ)/patch_antic_on.bin > $(DIST)/AUTORUN.SYS

$(OBJ)/patch_antic_off.o: $(SRC)/patch_antic_off.asm
	ca65 -o $@ $< -l $(OBJ)/patch_antic_off.lst

$(OBJ)/patch_antic_on.o: $(SRC)/patch_antic_on.asm
	ca65 -o $@ $< -l $(OBJ)/patch_antic_on.lst

$(OBJ)/binary_data_006.o: $(SRC)/binary_data_006.asm
	ca65 -o $@ $< -l $(OBJ)/binary_data_006.lst

$(OBJ)/binary_data_129.o: $(SRC)/binary_data_129.asm
	ca65 -o $@ $< -l $(OBJ)/binary_data_129.lst

$(OBJ)/patch_antic_off.bin: $(OBJ)/patch_antic_off.o
	#ld65 -D__SYSTEM_CHECK__=0 -D__AUTOSTART__=1 -o $@ -C $(CFG)/patch_antic_off.cfg $<
	ld65 -D__SYSTEM_CHECK__=0 -D__AUTOSTART__=1 -o $@ -C $(CFG)/atari-asm-xex.cfg $<

$(OBJ)/patch_antic_on.bin: $(OBJ)/patch_antic_on.o
	#ld65 -D__SYSTEM_CHECK__=0 -D__AUTOSTART__=1 -o $@ -C $(CFG)/patch_antic_on.cfg $<
	ld65 -D__SYSTEM_CHECK__=0 -D__AUTOSTART__=1 -o $@ -C $(CFG)/atari-asm-xex.cfg $<

# Disable injecting system memory check code and auto start trailer
$(OBJ)/binary_data_006.bin: $(CFG)/atari-asm-xex.cfg $(OBJ)/binary_data_006.o
	ld65 -D__SYSTEM_CHECK__=0 -D__AUTOSTART__=1 -o $@ -C $(CFG)/atari-asm-xex.cfg $(OBJ)/binary_data_006.o
	#sha1sum -c $(CFG)/binary_data_006.sha1

# Disable injecting system memory check code and auto start trailer
$(OBJ)/binary_data_129.bin: $(CFG)/atari-asm-xex.cfg $(OBJ)/binary_data_129.o
	ld65 -D__SYSTEM_CHECK__=0 -D__AUTOSTART__=1 -o $@ -C $(CFG)/atari-asm-xex.cfg $(OBJ)/binary_data_129.o
	#sha1sum -c $(CFG)/binary_data_129.sha1

$(OBJ)/binary_data_%.o: $(SRC)binary_data_%.asm
	ca65 -o $@ $< -l $(OBJ)/binary_data_%.lst

$(OBJ)/binary_data.bin: $(SRC)/binary_data.txt
	perl $(UTIL)/binary_data_to_raw.pl -i $(SRC)/binary_data.txt -o $(OBJ)/binary_data.bin

clean:
	rm -f $(OBJ)/*.lst $(OBJ)/*.o $(OBJ).bin $(UTIL)/ascii2atascii $(DIST)/MC.TXT $(DIST)/MC

run:
	atari800 -xl -basic $(ATR)
