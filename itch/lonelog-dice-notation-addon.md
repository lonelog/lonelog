---
title: "Lonelog: Dice Notation Add-on"
tagline: "A Standard Grammar for Recording Dice Expressions"
url: https://lonelog.itch.io/lonelog-dice-notation-addon
---

**`2d6+3`, `4d6dl1`, `{4d6, 2d8}k2`.** Core Lonelog marks a roll with `d:` and leaves what goes inside to you. That freedom works until you share a log, or a tool tries to read it.

The **Dice Notation Add-on** defines one standard grammar for dice expressions. It builds on the notation most players already use and on the specification of the open-source rpg-dice-roller library, extended for Lonelog's `d:` lines.

## What it covers

- **Standard expressions** with modifiers and math: `d: Attack 2d6+3=9 -> Hit`
- **Keep, drop and exploding dice**, dice pools, and Fudge/Fate dice
- **Roll descriptions** attached inline: `d: 4d6dl1 // Ability score=14`
- **Group rolls** evaluated together: `d: {4d6, 2d8}k2=11`

No new tags and no new core symbols: it only standardizes what goes inside `d:`.

## Who it's for

- Players who share logs and want every roll to be unambiguous
- Developers building tools that read or render Lonelog
- Anyone playing systems with complex dice mechanics

Simple expressions like `d6` or `2d10+3` are already valid. Complexity is opt-in.

## Requires

[Lonelog](https://lonelog.itch.io/lonelog), the core notation. Like every add-on, it's optional: use it when your game needs it.

## Read online

The full add-on is free to read at [lonelog.org](https://lonelog.org/docs/en/lonelog-dice-notation-addon.html). The downloads here are the same text in PDF, EPUB and ODT.

Licensed CC BY-SA 4.0.
