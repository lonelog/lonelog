# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Quarto website** for **Lonelog**, a standard notation system for solo RPG session logging. One render builds the site published at https://lonelog.org and, for every document, PDF (via Typst), EPUB, ODT and Markdown downloads, in English, Italian and French.

## Building

There is one Quarto project, at the repo root (`_quarto.yml`, `type: website`). Run commands from the root. Output goes to `_site/`, which is not committed.

```bash
quarto preview                               # live preview of the whole site
quarto render                                # everything, into _site/
quarto render docs/en/lonelog.md             # one document, all its formats
quarto render docs/en/lonelog.md --to typst  # one document, PDF only
```

### Publishing and releases

- **Website**: `.github/workflows/publish.yml` renders on every push to `main` and pushes `_site/` to the `gh-pages` branch of `lonelog/lonelog.github.io` (credentials from an org-owned GitHub App: variable `PAGES_APP_ID`, secret `PAGES_APP_PRIVATE_KEY`; the org policy blocks deploy keys). That org repo serves lonelog.org, because project repos in an org can only be served under `lonelog.github.io/<repo>`. Its `gh-pages` branch is overwritten on every publish: never edit it by hand. Its `main` holds the retired Eleventy site. The domain comes from the `cname:` input of the workflow, not from a file here. This repo has no `gh-pages` branch.
- **Release**: `.github/workflows/release.yml` runs on `v*` tags. It renders, then attaches `lonelog-en-<tag>.zip` (`lonelog*` PDF/EPUB/ODT/MD: core and add-ons, not Partylog) and those PDFs to a GitHub Release. `RELEASE_LANGS` in the workflow adds IT/FR once their translations reach parity.
- **itch.io**: the same workflow pushes files with butler when the repo variable `ITCH_PUSH=true` and the secret `BUTLER_API_KEY` are set. `.github/itch-targets.json` maps each file to an itch game and channel.
- Both workflows share `.github/actions/render` (Quarto 1.8.26 plus an emoji font).
- **Read the Docs** (`lonelog`, `lonelog-it`, `lonelog-fr`) only serves `.readthedocs/redirect.html`, which sends old Docsify URLs to the same page on lonelog.org.

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

Separate notations that share Lonelog's symbols: **`partylog.md`** (group play; adds `!` for GM and world events), **`lorelog.md`** (worldbuilding logs) and **`maplog.md`** (drawing maps during play). Lorelog and Maplog are drafts: the `render:` list in the root `_quarto.yml` excludes them, so they stay off the site and out of releases until their status changes.

### Site pages

- **`index.qmd`** - Home page of lonelog.org
- **`docs/en.md`, `docs/it.md`, `docs/fr.md`** - Language landing pages (HTML only; they sit outside the language folders so they get no downloads)
- **`blog/<slug>/index.md`** - Blog posts and devlogs. The folder name is the URL (`lonelog.org/blog/<slug>/`). Front matter: `title`, `date`, `categories` (`devlog`, `tutorial`, `announcement`), `description`. Don't repeat the title as an H1.

### Devlog

Release notes are blog posts with `categories: [devlog]`: one post per release cycle, in `blog/<slug>/index.md`.

### Language Variants

Each document renders next to its HTML page, in `_site/docs/<lang>/`: `<name>.pdf`, `.epub`, `.odt` and `<name>-gfm.md` (the release zip renames it to `<name>.md`).

## Architecture

### Quarto Configuration

- **`_quarto.yml`** - The website: render list (drafts excluded), navbar, one sidebar per language (`en`, `it`, `fr`; a page gets the sidebar that lists it), footer, and the HTML theme (`assets/custom.scss`, mirroring the Typst palette).
- **`docs/<lang>/_metadata.yml`** - Applies to every document in that folder: HTML plus Typst, EPUB, ODT and GFM, the `pagebreak.lua` filter, the cover images (`docs/assets/`) and `font-paths: assets/fonts`. **The three copies are identical; keep them in sync.** Quarto ignores `metadata-files` there, and a page cannot switch off formats a `_metadata.yml` adds.
- **`assets/format-links-top.html`** - Moves each page's download links to the top of the right sidebar and relabels "Typst" as "PDF".
- **Fonts**: `assets/fonts/` holds static Montserrat and Lora (OFL), so PDFs look the same locally and in CI. Code uses Consolas where installed, otherwise DejaVu Sans Mono (bundled with Typst).
- **Adding a document**: put it in `docs/<lang>/`, add it to that language's sidebar in `_quarto.yml` (and to the navbar Add-ons menu if it's an English add-on), and to `.github/itch-targets.json` if it goes to itch.io.

### Custom Typst Templates

Located in `_extensions/`:

1. **`typst-template.typ`** - Main template defining the `worldbuilders()` function
   - Defines color palette and fonts (Montserrat, Lora, Consolas with a DejaVu Sans Mono fallback)
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

Every document under `docs/<lang>/` produces:

1. **HTML** - The page on lonelog.org
2. **PDF** - Via Typst, print-ready (half-letter, KDP-compatible)
3. **EPUB** - E-book format with TOC
4. **ODT** - OpenDocument format for word processor editing
5. **Markdown** - GitHub-flavored export

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
