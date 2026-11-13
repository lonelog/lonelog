# Lonelog

**A Standard Notation for Solo RPG Session Logging**

[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

Lonelog is a lightweight notation system for recording solo tabletop RPG sessions. It provides a standardized way to capture game mechanics, oracle questions, and narrative outcomes—keeping your session logs readable, searchable, and shareable.

## What is Lonelog?

If you've played solo RPGs, you know the challenge: you're deep in an exciting scene, dice are rolling, oracles are answering questions, and you need to capture it all without breaking the flow.

Lonelog offers a **modular shorthand** that:

- Separates mechanics from narrative
- Works across any RPG system (Ironsworn, Mythic GME, Thousand Year Old Vampire, etc.)
- Scales from quick one-shots to long campaigns
- Functions in both digital markdown files and paper notebooks

### Core Notation (5 symbols, plus `tbl:` for random content)

```
@ Player action
? Oracle question
d: Roll or rule that gives a verdict
-> Result/answer
=> Consequence/outcome
```

### Quick Example

```
S1 *Dark alley, midnight*
@ Sneak past the guard
d: Stealth 4 vs TN 5 -> Fail
=> The guard spots me and shouts an alarm

? Does backup arrive? (Likely)
-> Yes, and they have dogs
=> I need to run—fast
```

That's the entire core system. Everything else (scenes, threads, progress clocks, etc.) is optional.

## Available Documentation

Read Lonelog online at **[lonelog.org](https://lonelog.org)**. Every page there has PDF, EPUB, ODT and Markdown downloads, and each [release](https://github.com/lonelog/lonelog/releases) carries a zip of the English core and add-ons.

- **English**: [Lonelog](https://lonelog.org/docs/en/lonelog.html), [Partylog](https://lonelog.org/docs/en/partylog.html) and all add-ons
- **Italiano**: [Lonelog](https://lonelog.org/docs/it/lonelog-it.html)
- **Français**: [Lonelog](https://lonelog.org/docs/fr/lonelog-fr.html) and five add-ons

### Optional Add-ons

Extended notation for specific gameplay needs:

- [Combat Add-on](docs/en/lonelog-combat-addon.md) - Tactical encounter notation
- [Dungeon Crawling Add-on](docs/en/lonelog-dungeon-crawling-addon.md) - Exploration notation
- [Resource Tracking Add-on](docs/en/lonelog-resource-tracking-addon.md) - Inventory and supplies
- [Dice Notation Add-on](docs/en/lonelog-dice-notation-addon.md) - Dice expression grammar
- [Card Notation Add-on](docs/en/lonelog-cards-addon.md) - Playing cards, tarot and oracle decks
- [Solo Wargaming Add-on](docs/en/lonelog-wargaming-addon.md) - Units, battles and campaigns
- [Add-on Guidelines](docs/en/lonelog-addon-guidelines.md) - How to write your own add-on
- [Add-on Template](docs/en/lonelog-addon-template.md) - Starter template

## Features

- **System-agnostic** - Works with any solo RPG system
- **Modular** - Use only what you need
- **Markdown-compatible** - Digital tools and plain text notebooks
- **Searchable** - Tags and symbols make finding past events easy
- **Shareable** - Standard notation means others can read your session logs
- **Multi-language** - Documentation available in English, Italian, and French

## Building the Website

This repository is a [Quarto](https://quarto.org/) website. One render builds lonelog.org and every document's PDF (via Typst), EPUB, ODT and Markdown download into `_site/`.

Install Quarto (1.8 or later):

- **Windows**: `choco install quarto` (via Chocolatey)
- **macOS**: `brew install quarto`
- **Linux**: Download from [quarto.org](https://quarto.org/docs/get-started/)

```bash
quarto preview                                  # live preview of the whole site
quarto render                                   # build everything into _site/
quarto render docs/en/lonelog.md                # one document, all formats
quarto render docs/en/lonelog.md --to typst     # one document, PDF only
```

`_site/` is not committed. GitHub Actions builds and publishes it:

- **Push to `main`** publishes the website (`.github/workflows/publish.yml`): it pushes `_site/` to the `gh-pages` branch of [lonelog/lonelog.github.io](https://github.com/lonelog/lonelog.github.io), the org Pages repo that serves lonelog.org.
- **A `v*` tag** renders everything and attaches a zip of the English core and add-ons (PDF, EPUB, ODT, MD), plus the PDFs, to a GitHub Release. It can also push files to itch.io (`.github/workflows/release.yml`, targets in `.github/itch-targets.json`).

## Project Structure

```
/
├── _quarto.yml            # Website config: navbar, per-language sidebars, theme
├── index.qmd              # Home page (lonelog.org)
├── blog/                  # Blog and devlog: one folder per post (blog/<slug>/index.md)
├── docs/
│   ├── en.md, it.md, fr.md  # Language landing pages
│   ├── assets/            # PDF cover images
│   ├── en/                # English documents (+ _metadata.yml: download formats)
│   ├── it/                # Italian translation
│   └── fr/                # French translation and add-ons
├── _extensions/           # Typst template and pagebreak filter
├── assets/                # Site styles, banner, and the fonts the PDFs embed
├── .github/               # Publish and release workflows, itch.io targets
├── .readthedocs/          # Redirect page served by the old Read the Docs projects
├── proposals/             # Design proposals
└── legacy/                # Previous versions
```

## Contributing

Contributions are welcome! Here's how you can help:

### Translations

Help translate Lonelog into additional languages. Use `docs/en/lonelog.md` as the source and maintain the same frontmatter structure.

### Improvements

Found a typo or unclear explanation? Open an issue or submit a pull request.

### Add-ons

Created an optional add-on for a specific type of play? Share it with the community!

### Examples

Real session logs using Lonelog are valuable for demonstrating the notation. Consider sharing anonymized examples.

## Version History

- **v1.7.0** (Current) - Consolidation release: `d:` gives a verdict and `tbl:` gives content (`gen:` folded in), truthful comparisons, tags that accumulate with `category:value` states and `×N` counts, `[E:]` for events, parallel storylines, meta-note labels and retcons, specification summary appendix. Add-ons and companion notations aligned.
- **v1.6.0** - Lead/Assist `@(A > B)` and Joint Action `@(A+B)`
- **v1.5.0** - `d:` is the preferred notation for oracle dice rolls
- **v1.4.0** - `@(Name)` convention for multi-PC and companion play
- **v1.3.0** - Tag categories, multi-line tags, roll context
- **v1.2.0** - Add-on ecosystem introduced
- **v1.1.0** - Licensing and inline definitions
- **v1.0.0** - Renamed from "Solo TTRPG Notation" to "Lonelog"

## License

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

You are free to:

- **Share** - Copy and redistribute the material
- **Adapt** - Remix, transform, and build upon the material

Under the following terms:

- **Attribution** - Give appropriate credit
- **ShareAlike** - Distribute under the same license

## Author

**Roberto Bisceglie**

## Community

- Share your session logs with the `#lonelog` hashtag
- Ask questions or suggest improvements via GitHub Issues
- Join discussions about solo RPG notation and best practices

## Acknowledgments

Thanks to the solo RPG community for feedback, suggestions, and real-world usage that shaped this notation system from its origins as "Solo TTRPG Notation" to Lonelog v1.0.0.

---

*Made with [Quarto](https://quarto.org/) • Styled with [Typst](https://typst.app/)*
