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
REVEAL_URL := https://github.com/hakimel/reveal.js/raw/master
REVEAL_JS_DIR := js
REVEAL_CSS_DIR := css

# File for reveal.js (relative paths):
REVEAL_JS := reveal.js
REVEAL_CSS := reveal.css
REVEAL_THEME := theme/white.css

# Absolute path of all files for reveal.js:
REVEAL_FILES := $(PRES_DIR)/$(REVEAL_JS) $(PRES_DIR)/$(REVEAL_CSS)         \
                $(PRES_DIR)/$(REVEAL_THEME)

# All files covered by the wildcard pattern 'slide_*' are part of the
# presentation:
SLIDES := $(sort $(wildcard slide_*))

# Convert *.md and *.svg files to temporary *.htm files:
SLIDES := $(SLIDES:%.md=.%.md.htm)
SLIDES := $(SLIDES:%.svg=.%.svg.htm)

###############################################################################
# Default target and cleanup rules:

all: $(REVEAL_FILES) $(PRES)

clean:
	rm -f $(PRES) .*.htm

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
	@sed -n '1,/.*<div class="slides">.*/p' < $< |                         \
	 sed -e 's/\$$(TITLE)/$(TITLE)/'                                       \
	     -e 's#\$$(REVEAL_CSS)#$(REVEAL_CSS)#'                             \
	     -e 's#\$$(REVEAL_THEME)#$(REVEAL_THEME)#' > $@

	@act='';                                                               \
	 num='';                                                               \
	 level='0';                                                            \
	 for next in $(SLIDES); do                                             \
	     nextnum=$$(echo $$next | sed 's/\.\?slide_\([0-9]*\).*/\1/');     \
	     if [ "$$act" != "" ]; then                                        \
	         if [ "$$nextnum" == "$$num" ]; then                           \
	             echo '        <section>' >> $@;                           \
	             level='1';                                                \
	             sed 's/^/          /' < $$act >> $@;                      \
	         elif [ "$$level" == "1" ]; then                               \
	             sed 's/^/          /' < $$act >> $@;                      \
	             echo '        </section>' >> $@;                          \
	             level='0';                                                \
	         else                                                          \
	             sed 's/^/        /' < $$act >> $@;                        \
	         fi;                                                           \
	         echo $$act;                                                   \
	     fi;                                                               \
	     act=$$next;                                                       \
	     num=$$nextnum;                                                    \
	 done;                                                                 \
	 if [ "$$act" == "" ]; then                                            \
	     echo 'Your presentation contains no slides!';                     \
	     exit 0;                                                           \
	 fi;                                                                   \
	 if [ "$$level" == "1" ]; then                                         \
	     sed 's/^/          /' < $$act >> $@;                              \
	     echo '        </section>' >> $@;                                  \
	 else                                                                  \
	     sed 's/^/        /' < $$act >> $@;                                \
	 fi;                                                                   \
	 exit 0;

	 @sed -e '1,/.*<div class="slides">.*/d'                               \
	      -e 's#\$$(REVEAL_JS)#$(REVEAL_JS)#' < $< >> $@

###############################################################################
# Converting various formats to HTML:

.%.md.htm: %.md
	pandoc -t revealjs $< -o $@

.%.svg.htm: %.svg
	@echo '<section class="svg-slide">' > $@                               \
	 echo '  <object data="$<" onload="addSVGslide(this)"></object>' >> $@ \
	 echo '  <script>' >> $@                                               \
	 echo '      if (loading_selfanims == null)' >> $@                     \
	 echo '          loading_selfanims = 1;' >> $@                         \
	 echo '      else' >> $@                                               \
	 echo '          loading_selfanims++;' >> $@                           \
	 echo '  </script>' >> $@                                              \
	 echo '</section>' >> $@
