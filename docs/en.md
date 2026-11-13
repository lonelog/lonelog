---
title: "Lonelog"
subtitle: "A Standard Notation for Solo RPG Session Logging"
lang: en
format: html
format-links: false
---

Lonelog is a lightweight notation system for recording solo tabletop RPG sessions. It provides a standardized way to capture game mechanics, oracle questions, and narrative outcomes—keeping your session logs readable, searchable, and shareable.

## What is Lonelog?

If you've played solo RPGs, you know the challenge: you're deep in an exciting scene, dice are rolling, oracles are answering questions, and you need to capture it all without breaking the flow.

Lonelog offers a **modular shorthand** that:

- Separates mechanics from narrative
- Works across any RPG system (Ironsworn, Mythic GME, Thousand Year Old Vampire, etc.)
- Scales from quick one-shots to long campaigns
- Functions in both digital markdown files and paper notebooks

### Core Notation (5 symbols)

```
@ Player action
? Oracle question
d: Dice/mechanics roll
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

## Read the Documentation

Every page has PDF, EPUB, ODT and Markdown downloads in its sidebar.

- [Lonelog](en/lonelog.md): the core notation
- [Partylog](en/partylog.md): Lonelog for group play
- Add-ons:
  - [Combat](en/lonelog-combat-addon.md): tactical encounters
  - [Dungeon Crawling](en/lonelog-dungeon-crawling-addon.md): room state and exploration
  - [Resource Tracking](en/lonelog-resource-tracking-addon.md): inventory, supply and wealth
  - [Dice Notation](en/lonelog-dice-notation-addon.md): dice expression grammar
  - [Cards](en/lonelog-cards-addon.md): playing cards, tarot and oracle decks
  - [Solo Wargaming](en/lonelog-wargaming-addon.md): units, battles and campaigns
  - [Add-on Guidelines](en/lonelog-addon-guidelines.md) and [Template](en/lonelog-addon-template.md): write your own

Also available in [Italiano](it.md) and [Français](fr.md).

## Features

- **System-agnostic** - Works with any solo RPG system
- **Modular** - Use only what you need
- **Markdown-compatible** - Digital tools and plain text notebooks
- **Searchable** - Tags and symbols make finding past events easy
- **Shareable** - Standard notation means others can read your session logs
- **Multi-language** - Documentation available in English, Italian, and French

## Contributing

Contributions are welcome! Here's how you can help:

### Translations

Help translate Lonelog into additional languages. Use `docs/en/lonelog.md` as the source and maintain the same frontmatter structure.

### Improvements

Found a typo or unclear explanation? Open an issue or submit a pull request.

### Module Extensions

Created an optional add-on for a specific type of play? Share it with the community!

### Examples

Real session logs using Lonelog are valuable for demonstrating the notation. Consider sharing anonymized examples.

## Version History

- **v1.7.0** (Current) - Consolidation release: `d:` gives a verdict and `tbl:` gives content (`gen:` folded in), truthful comparisons, accumulating tags, `[E:]` for events, parallel storylines, meta-note labels and retcons, specification summary appendix
- **v1.6.0** - Lead/Assist `@(A > B)` and Joint Action `@(A+B)`
- **v1.5.0** - `d:` is now the preferred notation for oracle dice rolls; clarified when to use `d:`, `tbl:`, and `gen:` for oracle resolution
- **v1.4.1** - Indentation clarified as optional and a readability aid, not structural
- **v1.4.0** - `@(Name)` convention for multi-PC and companion play, promoted from the Combat Add-on
- **v1.3.0** - Tag category syntax, multi-line tag form, and roll context blocks inside `d:`
- **v1.2.0** - Add-on ecosystem introduced
- **v1.1.0** - License clarification; inline table definitions, filtered option sets, multi-line result blocks
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

