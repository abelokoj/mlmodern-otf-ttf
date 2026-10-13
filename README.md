# MLModern for Typst: OTF, TTF, and a matching math font

MLModern converted from Type 1 to OpenType and TrueType, plus a math companion
named `MLModern Math` in Regular and Bold. Everything is provided in both
formats, as two complete parallel folders.

Sources, all from TeX Live 2026 (checked against the SHA-512 values in its
package database):

- Text fonts: MLModern 1.2 (Daniel Benjamin Miller, 2021), built on Latin Modern
  by B. Jackowski and J. M. Nowacki. The 92 Type 1 source files are
  byte-identical to those in TeX Live 2023.
- Math fonts: New Computer Modern Math 8.1.1 (Antonis Tsolomitis).

## Quick start

```typst
#set text(font: "MLModern", size: 12pt)
#show math.equation: set text(font: "MLModern Math")
```

```bash
typst compile --font-path otf doc.typ     # OpenType set
typst compile --font-path ttf doc.typ     # TrueType set
```

The show rule is required. See "Why the show rule is unavoidable" below.

## Contents

| Folder | Contents |
| --- | --- |
| `otf/` | 17 OpenType files: 15 text and glyph faces, plus `MLModern Math` Regular and Bold. Preferred: keeps the original cubic outlines. |
| `ttf/` | The same 17 faces as TrueType (quadratic outlines). For software that rejects CFF outlines. |
| `source/` | The two unmodified New CM Math files the math fonts were made from. Provenance only; do not install. |

Families (each present in both `otf/` and `ttf/`):

| Family | Faces |
| --- | --- |
| `MLModern` | Regular, Italic, Bold, Bold Italic |
| `MLModern Sans` | Regular, Italic, Bold, Bold Italic |
| `MLModern Mono` | Regular, Italic |
| `MLModern Math` | Regular, Bold (the working math font) |
| `MLModern Math Letters` | Regular, Bold (glyphs only, see below) |
| `MLModern Math Symbols` | Regular, Bold (glyphs only, see below) |
| `MLModern Math Extension` | Regular (glyphs only, see below) |

Bold comes from the bold-extended (`bx`) faces, which is what LaTeX uses as the
standard bold for this family. The italic faces of `MLModern Sans` come from
MLModern's oblique cuts.

## Kerning and ligatures

The eight proportional text faces (`MLModern` and `MLModern Sans`, each in
Regular, Italic, Bold, Bold Italic) have kerning and the five standard `f`
ligatures (`ff`, `fi`, `fl`, `ffi`, `ffl`), in both formats. The Type 1 source
files carry no such data, because TeX keeps it in `.tfm` files; it was taken
from those. Typst applies both by default (`kerning` and `ligatures` on).

| Face | Kern pairs | Ligatures |
| --- | --- | --- |
| `MLModern` Regular | 2,484 | 5 |
| `MLModern` Italic | 3,716 | 5 |
| `MLModern` Bold | 2,477 | 5 |
| `MLModern` Bold Italic | 3,709 | 5 |
| `MLModern Sans` (all four faces) | 2,255 each | 5 |
| `MLModern Mono` (both faces) | none | none |

Source: the `ec-mlm*10.tfm` files of TeX Live 2026, with character codes mapped
to glyph names by Latin Modern's `lm-ec.enc` (same release). Every one of the
TFM kern pairs was kept; kern values are the TFM values on a 1000-unit em.

**Only the five `f` ligatures are included.** The TFM files hold ten more
ligature rules, but they are TeX typing conventions: `--` to en dash, `---` to
em dash, `<<` and `>>` to guillemets, `` !` `` and `` ?` `` to inverted marks,
`''` and `,,` and ` `` ` to quotation marks. As OpenType ligatures they would
silently rewrite literal text, such as `<<` in code, and Typst already does
smart dashes and quotes itself. They were left out deliberately. The mono faces
have no kerning, and their only ligature rules are those typing conventions, so
they are unchanged. The `MLModern Math Letters/Symbols/Extension` faces are
unchanged too.

Checks: the TFM widths matched the converted glyph advances for 100% of
characters in all ten faces (this validates the TFM-to-glyph mapping). Shaping
with HarfBuzz, 42,652 of 42,652 testable pairs gave exactly the glyph width plus
the TFM kern, in all 16 fonts; 160 pairs (ten per face) have no unique Unicode
mapping and could not be tested that way. In Typst, measured text widths matched
an independent calculation from the TFM data to within 0.0002 pt, for both
formats. Turn either off with `#set text(kerning: false)` or
`#set text(ligatures: false)`.

## The math font

`MLModern Math` is New Computer Modern Math 8.1.1 with only its names changed.
Regular is made from the Book weight, Bold from the Bold weight.

| Face | Source | Glyphs | Unicode codepoints |
| --- | --- | --- | --- |
| `MLModern Math` Regular (400) | `NewCMMath-Book` | 8,598 | 4,883 |
| `MLModern Math` Bold (700) | `NewCMMath-Bold` | 8,582 | 4,970 |

OpenType files, checked against the sources: every glyph outline, the `MATH`
table, GSUB, GPOS, GDEF, hmtx, and the `cmap` mappings are unchanged.

### The TrueType math fonts

The TrueType files were made from the OpenType files by converting cubic
outlines to quadratic ones. Only the outline tables changed. `MATH`, `GSUB`,
`GPOS`, `GDEF`, `OS/2`, `cmap`, and `name` are byte-identical to the OpenType
files, the glyph order is unchanged, and advance widths are identical.

Quadratic curves approximate cubic ones. The conversion used a 0.5-unit
tolerance on a 1000-unit em. Re-measuring the 40 worst glyphs per font with
fine curve sampling gave a maximum outline distance of 0.94 units (Regular) and
0.83 units (Bold), under 0.1% of the em. The remaining glyphs were measured only
coarsely. In Typst, a page of mixed math set with the OpenType and TrueType
versions differs in height by 0.006 pt. In rare cases a thin rule can land on a
different pixel row in a rendered image.

Upstream's Bold has two zero-area single-point contours in `braceright.ex`.
TrueType cannot store these, so they are absent from the TrueType file. The
drawn shape is identical.

### One metadata correction

Upstream marks `NewCMMath-Bold` as a Regular face (`fsSelection` has the REGULAR
bit set and `macStyle` is 0). In `MLModernMath-Bold` these are set to Bold
(`fsSelection` 0x00a0, `macStyle` 1) so applications that group faces into
family styles link it correctly. Nothing else differs.

### Identical to Typst's built-in math font

Typst 0.15.1 bundles New Computer Modern Math 8.1.1. Extracting the glyphs that
Typst embeds and comparing outlines gave 16 of 16 identical for each weight,
including glyphs redrawn since version 5.11 (script capitals, the empty set,
subset symbols). `MLModern Math` Regular matches Typst's Book weight and Bold
matches its Bold.

### How the weights behave

| You write | Face used |
| --- | --- |
| an ordinary equation | Regular |
| an equation inside `#strong[...]` | Bold |
| an equation inside a heading | Regular |
| `bold(x)` in math | Regular (uses the math-bold letter shapes inside the font) |
| `#show math.equation: set text(weight: 700)` | Bold |

This matches what Typst's own default math font does in each case. Setting the
weight with `#text(weight: 700, $...$)` on an existing equation does not select
Bold; use the show rule.

### Weight compared with MLModern text

Vertical stem thickness of the letter I, measured two ways (Typst renders and
FreeType renders of the font files), as a share of MLModern Regular:

| Font | Stem thickness |
| --- | --- |
| MLModern Math Regular | 87 to 89% |
| MLModern Regular (text) | 100% |
| MLModern Math Bold | 132 to 133% |
| MLModern Bold (text) | 149 to 150% |

Math will look slightly lighter than the text. Regular is the closest single
match; Bold overshoots by more than Regular undershoots. This measures vertical
stems only, not hairlines or overall colour.

Upstream also uses thinner fraction rules in Bold (40) than in Book (48), and a
heavier radical rule (70). In a bold equation the fraction bar therefore looks
light next to the heavy letters. This is upstream design, not an artifact of the
rename.

## Why the show rule is unavoidable

It is tempting to rename the math font into the `MLModern` family itself, hoping
`#set text(font: "MLModern")` would then cover math too. This was tested and it
does not work.

Typst resolves a face within a family along the weight, style, and stretch axes.
There is no "math" axis. When both `MLModern-Regular` and a math face claim
Regular/400/Normal, Typst picks the text face and never inspects the family for
`MATH` capability. Tested two ways:

- Renaming a math font into family `MLModern` and setting only `#set text(font: "MLModern")`: the math font was ignored. Verified by renaming FiraMath (sans-serif, unmistakable) into the family; math still rendered serif.
- Adding `#show math.equation: set text(font: "MLModern")`: Typst selected `MLModern-Regular` and emitted `warning: current font is not designed for math`.

A distinct family name plus a show rule is the only arrangement that works.
That is what `MLModern Math` provides.

## You may not need the math files

Because Typst's bundled math font has identical outlines (see above), the
renamed font does not change a single glyph. It gives you a name that reads
consistently in your source and insulation from a future change to Typst's
default. If neither matters to you, skip the two `MLModernMath-*` files.

## The `MLModern Math Letters/Symbols/Extension` families are not math fonts

These three families hold MLModern's own math glyphs, converted from the
original Type 1 files. They cannot typeset math in Typst.

Typst requires an OpenType `MATH` table: the constants, italic corrections, and
extensible-delimiter assemblies that math layout depends on. Type 1 fonts have
no such table, because TeX kept that data in separate `.tfm` metric files.
Converting outlines cannot manufacture it. Pointing a math show rule at one of
these produces `warning: current font is not designed for math`.

They cover about 230 Unicode codepoints and contain no blackboard bold, fraktur,
script, or bold-italic alphabets (LaTeX supplied blackboard bold from the AMS
font MSBM10). TeX Live 2026 still ships MLModern 1.2 with 92 Type 1 files and no
OpenType or TrueType files, so no upstream OpenType release exists yet.

These faces are included only so the glyphs are reachable as ordinary text.

## Text TrueType fonts: one correction

An earlier release of the text TrueType files had an OS/2 table without the
x-height and cap-height fields. Typst sizes lines from cap height, so documents
set in those files came out taller than with the OpenType files (5.5 pt on a
test page). The fields are now present and both formats lay out identically.

## Installing

Install the OpenType set or the TrueType set, not both. They carry identical
family names, so installing both produces duplicate entries.

**Linux**

```bash
mkdir -p ~/.local/share/fonts/mlmodern
cp otf/*.otf ~/.local/share/fonts/mlmodern/
fc-cache -f
```

**Windows / macOS**: select all the files in `otf/` (or `ttf/`), then Install
(Windows) or open in Font Book (macOS). Do not install `source/`.

To keep the font list short, install only the `MLModern`, `MLModern Sans`,
`MLModern Mono`, and `MLModern Math` files and skip the three glyph-only
families.

Once installed system-wide, the `--font-path` flag is no longer needed.

## Licensing

MLModern is under the LaTeX Project Public License 1.3c. New Computer Modern
Math is under the GUST Font License 1.0, which is itself governed by the LPPL
1.3c. (Only `NewCM10-Regular`, the Uncial, and the Devanagari fonts are under
the GPL with font exception; none of those are included here.)

The GUST Font License requests, but does not legally require, that derived fonts
be renamed and accompanied by a manifest. The fonts here are renamed and
`MANIFEST-mlmodern.txt` lists what each file was made from. The LPPL asks that a
modified work be identifiable as such, which the copyright strings and the
manifest record.
