MAKEFILES = $(wildcard */Makefile)
LANGUAGES = $(MAKEFILES:%/Makefile=%)
TESTDATA  = data/huwikisource-latest-pages-meta-current.xml

TIME = /usr/bin/time
TIMEFORMAT = "%e__%U__%M"

all: $(LANGUAGES:%=build_%)
	scripts/build.sh # Fallback for languages not yet having a Makefile

clean: $(LANGUAGES:%=clean_%)

rebuild: clean all

run: $(LANGUAGES=%:build_%) $(LANGUAGES:%=run_%)



build_%:
	make -C $* build

clean_%:
	make -C $* clean

run_%:
	@echo running \"$*\"
	@cat $(TESTDATA) | $(TIME) -f $(TIMEFORMAT) make -s -C $* run > /dev/null
