MAKEFILES = $(wildcard */Makefile)
LANGUAGES = $(MAKEFILES:%/Makefile=%)
TESTDATA  = data/huwikisource-latest-pages-meta-current.xml

TIME = /usr/bin/time
TIMEFORMAT = "%e__%U__%M"

all: $(LANGUAGES:%=build_%)

clean: $(LANGUAGES:%=clean_%)

rebuild: clean all

run: $(LANGUAGES=%:build_%) $(LANGUAGES:%=run_%)



build_%:
	@echo building \"$*\"
	@make -s -C $* build
	@echo finished building \"$*\"

clean_%:
	@echo cleaning \"$*\"
	@make -s -C $* clean

run_%:
	@echo running \"$*\"
	@cat $(TESTDATA) | $(TIME) -f $(TIMEFORMAT) make -s -C $* run > /dev/null
	@echo finished running \"$*\"
