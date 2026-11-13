# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Quarto documentation project** for **Lonelog** — a standard notation system for solo RPG session logging. The project generates multi-format documentation (PDF, EPUB, ODT, Typst) in multiple languages (English, French, Italian).

## Building the Documentation

Each language is its own Quarto project in `docs/<lang>/`, with its own `_quarto.yml`. Run the commands below from that folder. Output goes to `output/<lang>/`, which is committed and packaged by the release workflow (`.github/workflows/release.yml`, triggered by `v.*` tags).

### Build Individual Files

To render a specific document in all configured formats:

```bash
cd docs/en && quarto render lonelog.md
cd docs/it && quarto render lonelog-it.md
cd docs/fr && quarto render lonelog-fr.md
```

To render a specific document to a single format:

```bash
quarto render lonelog.md --to typst
quarto render lonelog.md --to pdf
quarto render lonelog.md --to epub
quarto render lonelog.md --to odt
```

### Preview in Development

To preview with live reload during editing:

```bash
quarto preview lonelog.md
```

### Build All Documents

To render all documents in the project:

```bash
quarto render
```

## File Structure and Naming Conventions

### Core Documentation Files

- **`docs/en/lonelog.md`** - Main English documentation (the source for translations)
- **`docs/it/lonelog-it.md`** - Italian translation
- **`docs/fr/lonelog-fr.md`** - French translation (FR also translates some add-ons, with an `-fr` suffix)

### Add-on Files

Add-ons extend the core notation for one kind of play. All live in `docs/en/`:

- **`lonelog-combat-addon.md`** - Tactical combat
- **`lonelog-dungeon-crawling-addon.md`** - Room state and dungeon exploration
- **`lonelog-resource-tracking-addon.md`** - Inventory, supply and wealth
- **`lonelog-dice-notation-addon.md`** - Dice expression grammar
- **`lonelog-cards-addon.md`** - Playing cards, tarot, oracle decks
- **`lonelog-wargaming-addon.md`** - Units, battles and campaigns
- **`lonelog-addon-guidelines.md`** / **`lonelog-addon-template.md`** - Rules and a starter file for add-on authors

Each add-on's frontmatter has `parent: Lonelog vX.Y.Z` (currently v1.7.0) and `requires:`.

### Companion Notations

Separate notations that share Lonelog's symbols: **`partylog.md`** (group play; adds `!` for GM and world events), **`lorelog.md`** (worldbuilding logs) and **`maplog.md`** (drawing maps during play).

### Devlog

Release notes live in the repo root as `devlog-YYYY-MM-DD-<slug>.md`, one file per release cycle.

### Language Variants

Each language variant produces its own set of output files:
- `lonelog.pdf`, `lonelog.epub`, `lonelog.odt`, `lonelog.typ`
- `lonelog-it.pdf`, `lonelog-it.epub`, `lonelog-it.odt`, `lonelog-it.typ`
- `lonelog-fr.pdf`, `lonelog-fr.epub`, `lonelog-fr.odt`, `lonelog-fr.typ`

## Architecture

### Quarto Configuration (`_quarto.yml`)

The project uses a shared configuration file that defines:
- **Filters**: `pagebreak.lua` converts `---` to Typst pagebreaks
- **Cover images**: `logo.png` and `by-sa.png` (CC license stamp)
- **Format-specific settings**: Typst, HTML, and EPUB configurations
- **Custom templates**: Typst template partials for styling

### Custom Typst Templates

Located in `_extensions/`:

1. **`typst-template.typ`** - Main template defining the `worldbuilders()` function
   - Defines color palette and fonts (Montserrat, Lora, Consolas)
   - Handles multi-language TOC titles
   - Creates custom cover pages with logo and license
   - Formats headings, tables, code blocks, and quotes
   - Sets page dimensions to half-letter (5.5" × 8.5") for KDP publishing

2. **`typst-show.typ`** - Pandoc template partial that maps Quarto metadata to Typst template parameters

3. **`pagebreak.lua`** - Lua filter that converts horizontal rules (`---`) to `#pagebreak()` in Typst output

### Frontmatter Metadata

Each main document uses YAML frontmatter with these key fields:

```yaml
---
title: Lonelog
subtitle: "A Standard Notation for Solo RPG Session Logging"
author: Roberto Bisceglie
version: 1.0.0
license: CC BY-SA 4.0
lang: en  # or 'it', 'fr'
---
```

The language field (`lang`) controls:
- Text language settings in generated output
- TOC title localization (Contents, Sommario, Table des matières)
- Region-specific typography settings

### Output Formats

The project generates four output formats:

1. **Typst** (`.typ`) - Primary format, kept with `keep-typ: true` for debugging
2. **PDF** - Generated from Typst for print-ready output (KDP-compatible)
3. **EPUB** - E-book format with TOC
4. **ODT** - OpenDocument format for word processor editing

## Design System

### Typography

- **Titles**: Montserrat (Black 32pt for cover, Bold 16pt for headings)
- **Body**: Lora Medium 11pt
- **Code**: Consolas 11pt

### Color Palette

- **Text**: `#000000` (black)
- **Subtitles**: `#666666` (gray)
- **Code Text**: `#585260` (purple-gray)
- **Code Background**: `#efecf4` (light purple)
- **Inline Code**: `#188038` (green)

### Page Layout

- **Format**: Half-letter (5.5" × 8.5")
- **Margins**: 1.5cm top/left/right, 1.8cm bottom
- **Footer descent**: 0.25" (KDP requirement for page numbers)

## Working with Translations

When adding or updating translations:

1. **Maintain frontmatter consistency**: Ensure all three language files have matching structure (version, license, etc.)
2. **Update the `lang` field**: Set to `en`, `it`, or `fr` to ensure proper localization
3. **Test all formats**: Verify that PDF, EPUB, and ODT outputs render correctly for each language
4. **Check TOC titles**: The template automatically localizes TOC titles based on the `lang` field

## Working with Add-ons

Add-ons are standalone documents that extend the core notation. Follow `docs/en/lonelog-addon-guidelines.md`. In short:

1. **Use descriptive titles**: e.g., "Lonelog: Combat Add-on"
2. **Reference parent**: `parent: Lonelog v1.7.0`; when core changes, bump it and the add-on's own version, and add a version-history line
3. **Extend, don't replace**: no new symbols that clash with `@`, `?`, `d:`, `tbl:`, `->`, `=>` or Partylog's `!`
4. **Follow core's tag rules**: counts are `×N` values, one-at-a-time states are `category:value`, fields don't depend on order, owned things are named after the owner
5. **Keep them optional**: add-ons should be independently useful and not required for core notation

## Writing Conventions

- **Never put tags inside Markdown table cells.** A tag contains `|`; escaping it as `\|` works on GitHub, but Pandoc prints the backslash in PDF/EPUB. Use a list instead.
- **Keep explanations out of code blocks.** Notation examples should contain only notation; put commentary in prose, a list or a table.
- **No log may become invalid.** Retired forms are deprecated but stay readable; list them in core Appendix E.3.

## Legacy Files

The `legacy/` directory contains previous versions of the notation documentation. These files are preserved for historical reference but are not actively maintained.
