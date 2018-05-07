# Panveal
Presentations with [Pandoc](https://pandoc.org/)
and [reveal.js](https://revealjs.com/)

* Copy the files `Makefile` and `template.htm`
  to the directory where you wish to create your presentation.

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

* Use the command `make` to generate your presentation.
  You might want to specify a title:
```
make TITLE="My Presentation"
```
