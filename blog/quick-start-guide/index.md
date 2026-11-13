---
title: Getting Started with Lonelog
date: 2026-03-01
categories: [tutorial]
description: A step-by-step walkthrough of the five core symbols — everything you need to log your first solo session.
---

Lonelog is designed to be picked up in under five minutes. This guide walks you through the five core symbols using a short dungeon-delve example.

## The Five Core Symbols

| Symbol | Name | Meaning |
|--------|------|---------|
| `@` | Action | Something the character attempts |
| `d:` | Dice | A mechanical roll or resolution |
| `->` | Result | The outcome of a roll or oracle query |
| `=>` | Fiction | What happens in the story |
| `?` | Oracle | A yes/no question to the oracle |

You do not need all five in every entry. Use what the moment calls for.

## A Sample Scene

Here is a complete scene logged with Lonelog:

```
### S1  Dark alley, midnight

@ Sneak past the guard
d: Stealth 4 vs TN 5  ->  Fail
=> I kick a bottle. The guard turns.
?  Does he see me clearly?
   ->  No, but...
=> He's suspicious — starts walking toward the noise.
@ Duck behind the crates
d: Stealth 6 vs TN 4  ->  Success
=> I press flat against the wall, holding my breath.
```

Notice how `d:` captures the *mechanics* and `=>` captures the *fiction*. They are always separate lines. This is the heart of Lonelog: mechanics and narrative live side by side but never bleed into each other.

## Starting a Session

Open a plain-text file or a paper notebook and write a scene header:

```
### S1  The Ruined Tower, dusk
```

That is all the structure you need. From here, log actions as they happen. Do not worry about formatting every line perfectly — the goal is speed at the table, not beauty.

## Tips for New Users

**Use `=>` liberally.** The fiction lines are the most valuable part of a log to read back later. Err on the side of more prose, not less.

**Keep `d:` lines terse.** Skill, value, target number, result. No adjectives needed.

**The oracle `?` is optional.** If your game system has a built-in yes/no oracle, use `->` to record its answer. If it does not, you can use any external oracle and record the result the same way.

## Next Steps

Once you are comfortable with the core five, explore the optional modules in the [full specification](https://lonelog.readthedocs.io): Clocks for progress tracking, Threads for narrative arcs, and NPC tags for recurring characters.
