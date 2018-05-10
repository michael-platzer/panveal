SHELL := /bin/bash

MKFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TEMPLATE := $(MKFILE_DIR)/template.htm

REVEAL_JS := reveal.js
REVEAL_CSS := reveal.css
REVEAL_THEMES := theme/white.css

PRES = pres.htm

SLIDES := $(sort $(wildcard slide_*))
SLIDES := $(SLIDES:%.md=.%.md.htm)
SLIDES := $(SLIDES:%.svg=.%.svg.htm)

all: $(REVEAL_JS) $(REVEAL_CSS) $(REVEAL_THEMES) $(PRES)

$(REVEAL_JS):
	wget -nv https://github.com/hakimel/reveal.js/raw/master/js/reveal.js

$(REVEAL_CSS):
	wget -nv https://github.com/hakimel/reveal.js/raw/master/css/reveal.css

$(REVEAL_THEMES):
	mkdir theme
	wget -nv -O $@ https://github.com/hakimel/reveal.js/raw/master/css/$@

$(PRES): $(TEMPLATE) $(SLIDES)
	@sed -n '1,/.*<div class="slides">.*/p' < $< | sed 's/\$$(TITLE)/$(TITLE)/' > $@

	@act='';                                                                  \
	 num='';                                                                  \
	 level='0';                                                               \
	 for next in $(SLIDES); do                                                \
	     nextnum=$$(echo $$next | sed 's/\.\?slide_\([0-9]*\).*/\1/');        \
	     if [ "$$act" != "" ]; then                                           \
	         if [ "$$nextnum" == "$$num" ]; then                              \
	             echo '        <section>' >> $@;                              \
	             level='1';                                                   \
	             sed 's/^/          /' < $$act >> $@;                         \
	         elif [ "$$level" == "1" ]; then                                  \
	             sed 's/^/          /' < $$act >> $@;                         \
	             echo '        </section>' >> $@;                             \
	             level='0';                                                   \
	         else                                                             \
	             sed 's/^/        /' < $$act >> $@;                           \
	         fi;                                                              \
	         echo $$act;                                                      \
	     fi;                                                                  \
	     act=$$next;                                                          \
	     num=$$nextnum;                                                       \
	 done;                                                                    \
	 if [ "$$act" == "" ]; then                                               \
	     echo 'Your presentation contains no slides!';                        \
	     exit 0;                                                              \
	 fi;                                                                      \
	 if [ "$$level" == "1" ]; then                                            \
	     sed 's/^/          /' < $$act >> $@;                                 \
	     echo '        </section>' >> $@;                                     \
	 else                                                                     \
	     sed 's/^/        /' < $$act >> $@;                                   \
	 fi;                                                                      \
	 exit 0;

	 @sed -e '1,/.*<div class="slides">.*/d' -e 's/\$$(REVEAL_JS)/$(REVEAL_JS)/' < $< >> $@

.%.md.htm: %.md
	pandoc -t revealjs $< -o $@

.%.svg.htm: %.svg
	@echo '<section class="svg-slide">' > $@
	@echo '  <object data="$<" onload="addSVGslide(this)"></object>' >> $@
	@echo '  <script>' >> $@
	@echo '      if (loading_selfanims == null)' >> $@
	@echo '          loading_selfanims = 1;' >> $@
	@echo '      else' >> $@
	@echo '          loading_selfanims++;' >> $@
	@echo '  </script>' >> $@
	@echo '</section>' >> $@

clean:
	rm -f $(PRES) .*.htm
