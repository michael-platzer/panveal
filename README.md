# Panveal
Presentations with [Pandoc](https://pandoc.org/)
and [reveal.js](https://revealjs.com/)

## Getting Started

* Clone this repository or download the
  [Makefile](https://github.com/michael-platzer/panveal/raw/master/Makefile)
  and the
  [template file](https://github.com/michael-platzer/panveal/raw/master/template.htm).

* Make sure that [Pandoc](https://pandoc.org/) is installed.
  When building your presentation,
  the required files from [reveal.js](https://revealjs.com/)
  are automatically downloaded to the directory of your presentation.

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

## Features

### Makefile Variables

Following variables can be passed to the Makefile from the command line:

* Specify a title for your presentation:
  ```
  make TITLE="My Presentation"
  ```
  Defaults to `Panveal Presentation`.

* Specify a filename for your presentation:
  ```
  make PRES="my_pres.htm"
  ```
  Defaults to `pres.htm`.

* Use an alternative template file:
  ```
  make TEMPLATE="/path/to/my_template.htm"
  ```
  Defaults to the file `template.htm` in the same directory as the `Makefile`.

### Grouping

As already mentioned in the introduction,
slides with an identical number are grouped.
More specifically, all slides for which the part
described by the regular expression `slide_[0-9]*` is identical are grouped.

Grouped slides are placed vertically by reveal.js,
whereas non-grouped slides are organized horizontally.

### Markdown

Markdown files are converted to HTML with Pandoc.
Therefore, you may use any of
[Pandoc's Markdown extensions](https://pandoc.org/MANUAL.html#pandocs-markdown).

Some interesting extensions are:

* **Tex Math:** Anything between between two `$` characters
  will be [treated as TeX math](https://pandoc.org/MANUAL.html#math).

* [Pandoc supports adding images](https://pandoc.org/MANUAL.html#images)
  by prepending a `!` to a link:

  ```
  ![caption](/url/of/image.png)
  ```

  Pandoc also allows to
  [set HTML attributes for images](https://pandoc.org/MANUAL.html#extension-link_attributes),
  for instance to specify the width and height for an image.

As usual, raw HTML can be used within Markdown.

### Animating SVG slides

You can animate your SVG by creating multiple layers.
Use a layer's name to specify in which animation steps it shall appear.
For instance, if a layer shall be shown from steps 1 to 3,
simply name it `1-3`.
The syntax of this specification is similar to the [Latex beamer overlay
specifications](https://www.sharelatex.com/blog/2013/08/20/beamer-series-pt4.html#overlays-and-text-formatting).
