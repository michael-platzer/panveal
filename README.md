# Panveal
Presentations with [Pandoc](https://pandoc.org/)
and [reveal.js](https://revealjs.com/)

* The slides of your presentation can be either in HTML format,
  in Markdown syntax or can be SVG files.
  Markdown files are converted into HTML with Pandoc
  and for SVG images a slide with a reference to the SVG is added.

* Each slide of your presentation must be stored in an individual file.
  All files which are covered by the wildcard pattern `slide_*`
  are part of your presentation.

* Slides are sorted in alphabetical order.
  The common prefix `slide_` should be followed by a number.
  Be aware that in alphabetical order `slide_11` comes before `slide_2`.
  Therefore your numbering scheme should be something like:
  ```
  slide_01 slide_02 slide_03 ...
  ```

* Slides with ascending numbers are organized horizontally.
  Slides which have an identical number are organized vertically.
  You can use this to group slides, such as in:
  ```
  slide_01 slide_02a slide_02b slide_03 ...
  ```
  where `slide_02a` and `slide_02b` are grouped and placed vertically.
  More specifically, all slides for which the part
  described by the regular expression `slide_[0-9]*` is identical are grouped.

* Use the command `make` to generate your presentation
  and use the option `-f` to point to the `Makefile` in this repository.
  ```
  make -f /path/to/panveal/Makefile
  ```

* You might also want to specify a title for your presentation:
  ```
  make -f /path/to/panveal/Makefile TITLE="My Presentation"
  ```
