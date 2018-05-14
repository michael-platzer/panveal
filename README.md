# Panveal
Presentations with [Pandoc](https://pandoc.org/)
and [reveal.js](https://revealjs.com/)

## Getting Started

* Clone this repository or download the
  [Makefile](https://github.com/michael-platzer/panveal/raw/master/Makefile)
  and the
  [template file](https://github.com/michael-platzer/panveal/raw/master/template.htm).

* The slides of your presentation can be in any of the following formats:
  HTML, Markdown or SVG&ast;
  (formats with an asterisk are only linked to,
  but not embedded in the presentation).

* Each slide of your presentation must be stored in an individual file.
  All files which are covered by the wildcard pattern `slide_*`
  are part of your presentation.

* The slides will be sorted in alphabetical order and should be numbered.
  Be aware that in alphabetical order `slide_11` comes before `slide_2`,
  thus a numbering scheme like `slide_01 slide_02 slide_03 ...`
  is more appropriate.

* Slides which have an identical number are grouped. For instance in
  `slide_01 slide_02a slide_02b slide_03 ...`
  slides `slide_02a` and `slide_02b` are grouped together.

* Use the command `make` to generate your presentation.
  Use the option `-f` if the
  [Makefile](https://github.com/michael-platzer/panveal/raw/master/Makefile)
  and the
  [template file](https://github.com/michael-platzer/panveal/raw/master/template.htm)
  are located in a different directory:
  ```
  make -f /path/to/panveal/Makefile
  ```

Markdown files are converted to HTML with Pandoc
and for SVG images a slide with a reference to the SVG is added.

More specifically, all slides for which the part
described by the regular expression `slide_[0-9]*` is identical are grouped.
Grouped slides are placed vertically by reveal.js.

## Advanced functionality

### Specifying a title for your presentation

Specify a title for your presentation:
```
make TITLE="My Presentation"
```

### Animating SVG slides

You can animate your SVG by creating multiple layers.
Use a layer's name to specify in which animation steps it shall appear.
For instance, if a layer shall be shown from steps 1 to 3,
simply name it `1-3`.
The syntax of this specification is similar
to the Latex beamer overlay specifications.
