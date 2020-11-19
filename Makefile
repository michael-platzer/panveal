###############################################################################
#
#            Panveal  --  Presentations with Pandoc and reveal.js
#
###############################################################################

# Panveal Makefile
# Michael Platzer <michael.platzer@tuwien.ac.at>

SHELL := /bin/bash

# By default, the template file is assumed to be in the same directory as the
# Makefile:
MKFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TEMPLATE ?= $(MKFILE_DIR)/template.htm

# Default presentation name and output path:
TITLE ?= Panveal Presentation
PRES ?= pres.htm
PRES_DIR := $(dir $(abspath $(PRES)))

# Base URL for reveal.js files and sub-directories for *.js and *.css files:
REVEAL_URL := https://raw.githubusercontent.com/hakimel/reveal.js/ffadcc8502
REVEAL_JS_DIR := dist
REVEAL_CSS_DIR := dist

# File for reveal.js (relative paths):
REVEAL_JS := reveal.js
REVEAL_CSS := reveal.css
REVEAL_THEME := theme/white.css

# Absolute path of all files for reveal.js:
REVEAL_FILES := $(PRES_DIR)/$(REVEAL_JS) $(PRES_DIR)/$(REVEAL_CSS)         \
                $(PRES_DIR)/$(REVEAL_THEME)

# All files covered by the wildcard pattern 'slide_*' and which have a filename
# extension corresponding to any of the accepted input formats are part of the
# presentation:
SLIDES := $(sort $(wildcard slide_*))
SLIDES := $(filter %.htm %.html %.md %.svg %.pdf,$(SLIDES))

# Convert *.md, *.svg and *.pdf files to temporary *.htm files:
SLIDES := $(SLIDES:%.md=.%.md.htm)
SLIDES := $(SLIDES:%.svg=.%.svg.htm)
SLIDES := $(SLIDES:%.pdf=.%.pdf.htm)

###############################################################################
# Default target and cleanup rules:

all: $(REVEAL_FILES) $(PRES)

clean:
	rm -f $(PRES) .*.htm .*.svg

###############################################################################
# Downloading reveal.js:

$(PRES_DIR)/$(REVEAL_JS):
	wget -nv -O $@ $(REVEAL_URL)/$(REVEAL_JS_DIR)/$(REVEAL_JS)

$(PRES_DIR)/$(REVEAL_CSS):
	wget -nv -O $@ $(REVEAL_URL)/$(REVEAL_CSS_DIR)/$(REVEAL_CSS)

$(PRES_DIR)/$(REVEAL_THEME):
	mkdir theme
	wget -nv -O $@ $(REVEAL_URL)/$(REVEAL_CSS_DIR)/$(REVEAL_THEME)

###############################################################################
# Building the presentation file:

$(PRES): $(TEMPLATE) $(SLIDES)
	@sed -n '1,/.*<div class="slides" id="slides">.*/p' < $< |             \
	 sed -e 's/\$$(TITLE)/$(TITLE)/'                                       \
	     -e 's#\$$(REVEAL_CSS)#$(REVEAL_CSS)#'                             \
	     -e 's#\$$(REVEAL_THEME)#$(REVEAL_THEME)#' > $@

	@act='';                                                               \
	 num='';                                                               \
	 level='0';                                                            \
	 for next in $(SLIDES); do                                             \
	     nextnum=$$(echo $$next | sed 's/\.\?slide_\([0-9]*\).*/\1/');     \
	     if [ "$$act" != "" ]; then                                        \
	         echo '' >> $@;                                                \
	         if [ "$$nextnum" == "$$num" ]; then                           \
	             if [ "$$level" != "1" ]; then                             \
	                 echo '        <section>' >> $@;                       \
	                 level='1';                                            \
	             fi;                                                       \
	             sed 's/^/          /' < $$act >> $@;                      \
	         elif [ "$$level" == "1" ]; then                               \
	             sed 's/^/          /' < $$act >> $@;                      \
	             echo '        </section>' >> $@;                          \
	             level='0';                                                \
	         else                                                          \
	             sed 's/^/        /' < $$act >> $@;                        \
	         fi;                                                           \
	     fi;                                                               \
	     act=$$next;                                                       \
	     num=$$nextnum;                                                    \
	 done;                                                                 \
	 echo '' >> $@;                                                        \
	 if [ "$$act" == "" ]; then                                            \
	     echo 'Your presentation contains no slides!';                     \
	 elif [ "$$level" == "1" ]; then                                       \
	     sed 's/^/          /' < $$act >> $@;                              \
	     echo '        </section>' >> $@;                                  \
	 else                                                                  \
	     sed 's/^/        /' < $$act >> $@;                                \
	 fi;                                                                   \
	 echo '' >> $@;

	@sed -e '1,/.*<div class="slides" id="slides">.*/d'                    \
	     -e 's#\$$(REVEAL_JS)#$(REVEAL_JS)#' < $< >> $@

###############################################################################
# Converting various formats to HTML:

.%.md.htm: %.md
	@echo '<section class="slide level1"><!-- Markdown slide -->' > $@;    \
	 pandoc -t revealjs --slide-level=2 $< >> $@;                          \
	 echo '</section>' >> $@;

.%.svg.htm: %.svg
	@echo '<section class="svg-slide"><!-- SVG slide -->' > $@;            \
	 cat "$<" | sed '1d; s/^/  /' >> $@;                                   \
	 echo '</section>' >> $@;

.%.pdf.htm: %.pdf
	@echo '<section><!-- PDF slide -->' >> $@;                             \
	 echo '  <div class="stretch" style="position: relative;">' >> $@;     \
	 pgcnt=$$(pdfinfo "$<" | grep Pages | awk '{print $$2}');              \
	 for pgnum in $$(seq 1 $$pgcnt); do                                    \
	     pdftocairo -f $$pgnum -l $$pgnum -svg "$<" ".$<.$$pgnum.svg"      \
	                                                         > /dev/null;  \
	     if [ "$$pgnum" == "1" ]; then                                     \
	         echo -n '    <div ' >> $@;                                    \
	     elif [ "$$pgnum" == "$$pgcnt" ]; then                             \
	         echo -n '    <div class="fragment fade-in" ' >> $@;           \
	     else                                                              \
	         echo -n '    <div class="fragment current-visible" ' >> $@;   \
	     fi;                                                               \
	     echo -n 'style="transition: none; position: absolute; ' >> $@;    \
	     echo 'width: 100%; height: 100%;">' >> $@;                        \
	     echo -n '      <object style=' >> $@;                             \
	     echo -n '"width: 100%; height: 100%; object-fit: contain;"' >> $@;\
	     echo -e " data=\".$<.$$pgnum.svg\"></object>" >> $@;              \
	     echo '    </div>' >> $@;                                          \
	     pgnum=$$((pgnum+1));                                              \
	 done;                                                                 \
	 echo '  </div>' >> $@;                                                \
	 echo '</section>' >> $@;
