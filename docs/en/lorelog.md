---
title: Lorelog
subtitle: "A Standard Notation for World Facts and Lore"
author: Roberto Bisceglie
version: 0.2.0
license: CC BY-SA 4.0
lang: en
---

## 1. Introduction

Every campaign builds a world, whether anyone plans it or not. The GM decides that the North Gate closes at dusk. A player asks what the city drinks, and the answer becomes true. An NPC tells the party that the gate is unguarded at night, and nobody remembers, three sessions later, whether that was a fact or a lie.

Lorelog is a lightweight shorthand for recording what is true about a fictional world: the facts, the rumors, the open questions, who knows what, and where each piece came from. It serves the GM keeping campaign notes, the player keeping track of what their character has learned, the solo player whose world grows out of oracle answers, and anyone who builds a setting on purpose.

### 1.1 Lorelog, Lonelog and Partylog

Lorelog is a companion to **Lonelog**, the notation for solo RPG session logging, and to **Partylog**, its version for group play. The three share the **tag grammar** for persistent elements (`[N:Name|tags]`, `[L:Name|tags]` and so on), so a play log and a lore file can sit in the same notebook or vault and stay searchable together.

They record different things. Lonelog and Partylog record **what happened**: an action, a roll, a consequence. Lorelog records **what is true**: the state of the world that play, prep and imagination have produced. A Lonelog scene says the warden took a bribe. A Lorelog line says the warden is corrupt.

**If you know Lonelog**, you already know half of Lorelog: the tags, the notes in parentheses, the random tables, the code blocks. **If you don't**, this document stands alone.

### 1.2 What Lorelog Does

Lorelog helps you:

- **Keep facts findable**, filed under the people, places and things they belong to
- **Tell facts from rumors**, so a lie an NPC told stays a lie in your notes
- **Track who knows what**, from GM secrets to what one character has heard
- **Remember where things came from**: prep, a session, a player, a table roll, a book
- **Follow changes**, telling a world that changed from a table that changed its mind
- **Keep a list of open questions**, the things nobody has decided yet

The notation is designed to be:

- **Method-agnostic:** it does not care how a fact was produced, only that it was
- **Layered:** usable as bare one-line facts or with full notes
- **Searchable:** every symbol and tag starts a line or sits in brackets
- **Format-agnostic:** it works in Markdown files and in paper notebooks

### 1.3 How to Use This Notation

This is a **toolbox, not a rulebook**. At its core are four symbols:

- `=` for a fact: this is true
- `=?` for a provisional fact: this is probably true, but not settled
- `~` for a claim: someone in the world says or believes this, and it may be false
- `?` for an open question: nobody has decided this yet

Only `=` is needed to keep lore. Everything else is optional: notes on sources and secrets, tags, entries, headers. Think in concentric circles:

- **Core Notation**: facts, plus claims and questions when you need them
- **Notes** (add as needed): where a fact came from, who knows it, when it is true
- **Elements and Structure** (for organization): tags, entries, the world header

**Start small.** Write one fact on one line. Add layers when they serve you.

**A note on licensing:** The CC BY-SA 4.0 license covers this specification. Worlds, notes, and settings you create with Lorelog are your own work. License them however you like.

### 1.4 Quick Start

```
= Something true about the world
=? Something probably true
~(Who) Something someone claims
? Something nobody has decided
```

#### Quick Start Example

```
[L:North Gate|checkpoint]
  = Closes at dusk
  = Two wardens by day
  ~(N:Ossa) Nobody guards it at night
  = The night shift is sold to smugglers (secret)
  ? Who buys the shift?
```

The tag names the place. The lines under it say what is known about it. Ossa's claim is recorded as a claim, the truth is a secret only the GM knows, and the question waits for an answer.

## 2. Digital vs Analog Formats

Lorelog works in Markdown files and in paper notebooks. The notation is identical; only the wrapping differs.

### 2.1 Digital Format (Markdown)

- **World metadata** goes in YAML front matter
- **World title** is a level 1 heading
- **Elements** (in a ledger) or **sessions** (in a log) are level 2 or 3 headings
- **Notation** goes in code blocks
- **Prose** goes between code blocks

**Always wrap notation in code blocks.** A line of `=` under a line of text turns that text into a heading in Markdown. Inside a code block, it is safe.

In a wiki or a vault with one file per element, the file is the entry: put the element's tag at the top of a code block and its facts below it.

### 2.2 Analog Format (Notebooks)

- Write headers as shown in Section 8
- Write notation directly, without code fences
- Brackets and prefixes make the page easy to scan

On paper, a small box in the margin next to each `?` line, ticked when the question is answered, turns any page into a visual list of open questions.

### 2.3 Indentation

Indented lines belong to the element on the unindented line above them (Section 5.3). Everywhere else, indentation is up to you.

## 3. Core Notation

The four core symbols start a line. Each line holds one statement about the world.

### 3.1 Facts (`=`)

The `=` symbol establishes something true about the world.

```
= The Cistern Guild owns every public well
= Winter staples are dried fish and barley
= The empire fell when its roads were abandoned to the forest
```

Keep one fact per line. If an answer has several parts, write several `=` lines. Separate facts can be tagged, changed, or retracted one by one.

A fact is true *in the world*, whoever knows it. Whether the characters know it, and how anyone found out, are separate questions, recorded in notes (Section 4).

### 3.2 Provisional Facts (`=?`)

A provisional fact is a working assumption: true for now, open to change without ceremony.

```
=? The capital sits on a river delta
=? Magic is rare, maybe one person in a thousand
```

Use it for first sketches, for prep the table has not seen yet, and for ideas you like but are not sure of. When you decide to keep a fact, write it again as `=` (Section 6.5).

### 3.3 Claims (`~`)

The `~` symbol records something said or believed inside the world: a rumor, a lie, a legend, a mistaken belief. A claim says nothing about whether it is true. Name who makes it in parentheses, the way Lonelog names who acts:

```
~(N:Ossa) Nobody guards the North Gate at night
~(Faction:Temple of the Rain) The drought is a punishment for selling water
~(dockworkers) The Guild poisons the wells it wants to close
~ The old king is still alive
```

A claim without a name is common talk: a rumor whose source nobody remembers.

Claims are where most of a player's notes live. Characters rarely learn facts directly; they hear things. Writing what they heard as `~` keeps the notes honest: when the claim turns out to be false, the record of the lie is still there, and so is the name of the liar.

The truth, when someone decides it, is a separate `=` line. The two can sit side by side:

```
~(N:Ossa) Nobody guards the North Gate at night
= The night shift is sold to smugglers (secret)
```

### 3.4 Open Questions (`?`)

The `?` symbol records something about the world that nobody has decided yet.

```
? Who buys the night shift at the North Gate?
? What do farmers eat in winter?
? Why did the old empire fall?
```

Open questions are a to-do list for the world. A GM keeps them to prep against. A player keeps them as the mysteries their character wants solved. A worldbuilder keeps them as the next thing to work on. One search for `?` at the start of a line lists them all.

In Lonelog and Partylog, `?` also asks an oracle or the GM a question, and an `->` line answers it at once. The meaning is the same: a question about the world. A question with an answer is closed; a question without one is open.

### 3.5 Struck Lines (`x`)

Nothing in a Lorelog file is erased. A line that no longer holds is **struck**: write it again with `x` in front, and say why.

```
x= The Guild founded the city
(why: clashes with the setting book, p. 12)
= The Temple of the Rain founded the city
```

- `x=` retracts a fact: it was never true after all
- `x=?` drops a provisional fact
- `x~` withdraws a claim recorded by mistake
- `x?` drops a question nobody wants answered any more

Striking is for changing your mind about the record. It is not how the world changes: a gate that burns down was still standing yesterday. Section 6 tells the two apart.

## 4. Notes

Notes go in parentheses at the end of a line, or on a line of their own, as in Lonelog. Each note starts with a label. A line can carry several notes:

```
= The night shift is sold to smugglers (via: prep) (secret)
```

Four labels describe a fact. All of them work on claims and questions too.

### 4.1 Source (`via:`)

The `via:` label records where a line came from.

```
= The North Gate closes at dusk (via: S3)
= Two wardens by day (via: prep)
= The Temple founded the city (via: book p. 12)
= Ossa has a sister in the marshes (via: Anna)
= A ruined toll tower stands at the crossroads (via: tbl Landmark d8=6)
```

Common sources:

- `S#` or `session #`: it came up in play
- `prep`: the GM decided it before play
- a name: a player or co-author proposed it
- `book`, with a page: a published setting or adventure
- `tbl`, with the roll: a random table
- `oracle`: an oracle answer in solo play

Under a session header, every line already comes from that session; `via:` is for lines whose source differs from their surroundings. Random tables work exactly as in Lonelog. A full `tbl:` line above a fact records the roll and is its source:

```
tbl: Landmark d8=6 -> Ruined toll tower
= A ruined toll tower stands at the crossroads north of the capital
```

### 4.2 Who Knows It (`known:` and `secret`)

The `known:` label records who in the game knows a line. The `secret` note is short for "only the author of these notes knows it": the GM's secret in a campaign, the hidden truth in a solo game.

```
= The night shift is sold to smugglers (secret)
= Ossa is the warden captain's nephew (known: Elara)
= The Guild poisoned the north well (known: party)
= The duke is a changeling (known: players)
```

`known:` takes character names, `party` (the characters together), `players` (the people at the table, not their characters) or any group you name. A line with no `known:` or `secret` note makes no claim about who knows it. In a GM's notes it is usually table knowledge; in a player's notes, it is what that player knows.

When a secret gets out, record it with the change rules in Section 6.4.

### 4.3 When (`when:`)

The `when:` label places a line in the world's time: a year, a season, a session, or a moment relative to another event.

```
= The North Gate burned (when: S9)
= The Guild was chartered (when: year 412)
= The wells run dry (when: every late summer)
= The empire's roads were abandoned (when: two centuries ago)
```

A fact with `when:` is true at that time and stays true of that time. Use it for history, for events of play, and for anything that repeats.

### 4.4 Other Notes

Any Lonelog note label works. Three are especially useful for lore:

```
(why: the reason for a change, retraction or decision)
(note: a comment, doubt or reminder)
(parked: an idea you want to keep, not yet part of the world)
```

`(parked: ...)` keeps an idea without making it true. It is not a fact, not a provisional fact and not a question: it is a note to yourself.

## 5. Elements and Tags

### 5.1 Tag Grammar (Shared with Lonelog)

Persistent elements use Lonelog's tag grammar, unchanged: `[Type:Name|value|value]`. Values accumulate. Updates follow the same rules:

- `[L:Harbor|walled]` adds a value
- `[L:Harbor|-walled]` removes it
- `[L:Harbor|intact>burned]` replaces one value with another
- `[L:Harbor|pop:40k]` sets a value that holds one thing at a time
- `[#L:Harbor]` refers to an element defined earlier

Because the grammar is shared, `[L:North Gate]` in a lore file and `[L:North Gate]` in a play log are the same place. A search finds both.

### 5.2 Tag Types

From Lonelog and Partylog, unchanged:

- `[N:Name]` — Named person
- `[PC:Name]` — Player character
- `[L:Name]` — Location
- `[E:Name]` — Notable event, in history or in play
- `[Thread:Name]` — Story thread
- `[Faction:Name]` — Faction, institution or group (as in Partylog)

Lorelog adds two:

- `[Term:Name]` — An in-world word, name or concept. Example: `[Term:vouch|temple license waiver]`
- `[Topic:Name]` — A subject that is not a person, place or group: a religion, a law, a magic system, a trade. Example: `[Topic:Magic|licensed|costs memory]`

Custom tag types are allowed. Declare them in the world header (Section 8.1) so readers know what they mean.

### 5.3 Entries

An **entry** files facts under the element they belong to. Write the element's tag on its own line, and indent the lines that belong to it:

```
[N:Ossa|warden|North Gate]
  = Nephew of the warden captain
  = Takes bribes (via: S4)
  ~(N:Ossa) Has never taken a coin in his life
  ? Does Ossa know about the smugglers?
```

The tag holds the element's current state in a few words. The lines below hold everything else: the details, the history, the rumors and the gaps. An entry ends at the next unindented line.

On paper, an entry is a page or a box. In a digital file, it is a heading followed by a code block. In a vault, it is a file of its own.

### 5.4 Tags Inside Lines

A fact can name the elements it touches, or update them:

```
= Ossa's sister runs the eel stall at the canal market [N:Mira|eel seller] [#L:Canal Market]
= The Guild closes the north well [L:North Well|open>closed]
```

Updating a tag inside a fact keeps the tag's state and the reason for it on the same line.

## 6. When Things Change

Lore changes all the time: the world moves, secrets get out, the table changes its mind. Lorelog records each change as a new line, so the file keeps its history.

### 6.1 The Latest Line Wins

When two lines about the same thing disagree, the later one holds. Earlier lines stay where they are, as history. This one rule covers most changes: to change something, write the new version below the old one.

### 6.2 The World Changed

If something was true and has stopped being true, the world changed. Record the new state, and say when:

```
[L:North Gate|intact>burned]
  = Closes at dusk
  = Burned in the water riot (when: S9)
  = Rebuilt in stone by the Guild (when: S12)
```

The old facts are not struck. "Closes at dusk" was true until the fire, and it is still true of that time.

### 6.3 The Table Changed Its Mind

If something turns out never to have been true, because it contradicts a better idea, a published source or something already played, strike it (Section 3.5):

```
x= The Guild founded the city
(why: the Temple founding is better for the campaign)
= The Temple of the Rain founded the city
```

A retraction is a decision about the notes, not an event in the world. Search for `x=` to see every retraction and its reason.

### 6.4 A Secret Got Out

When the characters learn something, repeat the fact with its new `known:` note and the session it came out in:

```
= The night shift is sold to smugglers (secret)
= The night shift is sold to smugglers (known: party, from S14)
```

The first line still records that it was a secret before session 14.

### 6.5 A Provisional Fact Was Settled

Write it again as `=`. If you settle it differently, strike the provisional version:

```
=? The capital sits on a river delta
= The capital sits on a river delta

=? Magic is rare
x=? Magic is rare
= Magic is common but licensed
```

### 6.6 A Claim Was Proven or Disproven

A claim is never wrong as a record: Ossa did say it. Write the truth as a fact next to the claim:

```
~(N:Ossa) Nobody guards the North Gate at night
= Two smugglers' men hold the gate at night (known: party, from S14)
```

If the claim turns out true, the fact says so: `= Nobody guards the North Gate at night`.

### 6.7 A Question Was Answered

Write the answer as a fact, right under the question if you can:

```
? Who buys the night shift?
= The Eel Brotherhood buys it, for smuggling marsh salt (via: prep)
```

On paper, tick the box next to the question. To drop a question without answering it, strike it: `x? Who buys the night shift?`.

## 7. Two Ways to Keep Lore

Lore can be written down in the order it comes up, or filed under the elements it belongs to. Most people do both.

### 7.1 The Lore Log

A **lore log** records lines in the order they come up, under session or date headers. It is the easiest form to write during or right after play, because it asks for no sorting.

```
=== Session 3 ===
= The North Gate closes at dusk [L:North Gate]
~(N:Ossa) Nobody guards it at night
? Who pays Ossa?

=== Session 4 ===
= Ossa takes bribes [N:Ossa|corrupt]
~ The Guild poisons the wells it wants to close
```

The session header is the source of every line under it.

### 7.2 The Ledger

A **ledger** is a set of entries (Section 5.3), one per element. It is the easiest form to read: everything known about the North Gate is in one place. A GM's prep notes and a setting bible are ledgers.

### 7.3 Skimming and Filing

Logs grow during play; the ledger or world bible is where you look things up. Between sessions, skim the logs and file what you find. Done after every session, it takes a few minutes.

1. **Find the lines.** Read the play logs and lore logs since your last skim, looking for lines that start with `=`, `=?`, `~`, `?` or `x`, and for tags. In a play log, also skim the `=>` consequences: some describe the world, not just the scene, and become `=` lines when you file them. In a digital file, a search for each symbol at the start of a line finds them.
2. **File each line under its element.** Copy it into the entry for the element its tag names, or the element it is clearly about, and add the session as its source. A line about several elements goes under the one it says most about, with reference tags (`[#N:Ossa]`) for the others. A tag you have not filed before starts a new entry.
3. **Apply the change rules.** If a new line disagrees with the entry, decide what happened: the world changed, the table changed its mind, a secret got out, or a claim was proven (Section 6). Record it that way, and update the entry's tag so it shows the current state.
4. **Close and open questions.** Write the answer under each question the session answered, strike the ones nobody cares about any more, and add the new ones.
5. **Mark where you stopped.** Write the last session you filed in the world header (`filed_to: S4`), or tick it on the log page, so the next skim starts there.

Not everything is lore. Actions, rolls and consequences that only tell what happened in a scene stay in the play log. An event worth remembering becomes an `[E:]` entry, or a fact with `when:`.

Skimming this part of a session 4 play log:

```
S4 *North Gate, dusk*
@ Bribe the warden
d: Persuade d6=5 vs TN 4 -> Success
=> Ossa lets me through and pockets the coin.
= Ossa takes bribes [N:Ossa|corrupt]
~(N:Ossa) The gate is never guarded after midnight
=> I slip through into the outer district.
```

files two lines and leaves the rest:

```
[N:Ossa|warden|corrupt]
  = Takes bribes (via: S4)

[L:North Gate|checkpoint]
  ~(N:Ossa) Never guarded after midnight (via: S4)
```

Ossa's claim goes under the gate, because it is about the gate. The bribe, the roll and the walk into the outer district stay in the play log.

Keep the logs. The ledger tells you what is true now; the logs tell you how you got there.

#### A World Bible in Prose

Many GMs keep their world in prose: a setting document, a wiki, a notebook with a page per place. Filing into prose works the same way, except in step 2: instead of copying the line, write it into the section it belongs to, and point the log at that section with a `§` reference if you want to find it again. Two habits keep a prose bible as honest as a ledger:

- **Keep claims as claims.** "Ossa says the gate is never guarded after midnight" is not the same as "the gate is never guarded after midnight".
- **Keep secrets in their own place.** Put them in a GM-only section or file, never in a section the players read.

You can also mix the two: prose for the overview of each element, and a code block of Lorelog lines under it for the details, sources and open questions.

### 7.4 Lore Lines in a Play Log

Lorelog lines can sit inside a Lonelog or Partylog scene. In a play log, `=>` says what happened; `=` says what is now true of the world:

```
S4 *North Gate, dusk*
@ Bribe the warden
d: Persuade d6=5 vs TN 4 -> Success
=> Ossa lets me through and pockets the coin.
= Ossa takes bribes [N:Ossa|corrupt]
~(N:Ossa) The gate is never guarded after midnight
```

The `=` and `~` lines are the ones to file into the ledger after the session (Section 7.3).

In Partylog, `!` marks a GM or world event. Lorelog has no `!`, so the two never collide.

## 8. Optional Structure

### 8.1 World Header

The world header is the cover page of your lore. Every field is optional.

**Digital (YAML front matter):**

```yaml
title: The Cistern Cities
campaign: Dry Season
system: Lonelog, solo
setting: Low fantasy, urban
pitch: A drought-stricken city where water is law and the law is for sale
readers: GM only
play_logs: logs/
filed_to: S4
custom_tags: "[Guild:] guild ranks"
start_date: 2026-09-25
last_update: 2026-11-15
```

**Analog:**

```
=== Lore: The Cistern Cities ===
[Campaign]    Dry Season
[Setting]     Low fantasy, urban
[Readers]     GM only
[Play logs]   Notebook 2
[Filed to]    S4
[Start Date]  2026-09-25
```

The `readers` field says who the file is for. A file the players never see can hold secrets freely; a shared file should hold no `secret` lines at all. The `play_logs` field points to the session logs the lore comes from, if any, and `filed_to` names the last session filed into the ledger (Section 7.3).

### 8.2 Section References (`§`)

When your world lives in a structured document, such as a setting bible, a wiki, or a template with named or numbered sections, point at its sections with `§`:

```
= The Guild charters every well (§Politics)
? Who guards the gates? (§2.3)
```

### 8.3 Sessions and Dates

Lore logs use session headers: `=== Session 3 ===` on paper, `## Session 3` in Markdown. Use the same numbers as your play log, so `via: S3` points to the same session in both. If you have no play log, date the headers instead.

## 9. Contexts

### 9.1 A GM's Campaign Notes

A GM keeps a ledger for prep and a lore log for what the table established. Prep that the table has not seen is provisional, secret, or both:

```
[Faction:Eel Brotherhood|smugglers|marsh salt]
  = Buys the North Gate night shift (secret)
  =? Their leader is Ossa's sister
  ? What do they do if the Guild finds out?
```

After each session, file the lines that came up at the table into the ledger with their session numbers (Section 7.3). A fact the players established, by asking a question or by a choice their characters made, gets a name: `(via: Anna)`.

### 9.2 A Player's Notes

A player records what their character knows, which is mostly claims:

```
[N:Ossa|warden|North Gate]
  ~(N:Ossa) Never took a coin in his life
  = Took my coin (via: S4)
  ~(N:Mira) Owes money to someone in the marshes
  ? Who is he really working for?
```

A player's notes need no `known:` notes: everything in them is what that player knows. Use `known:` when the player knows something their character does not.

### 9.3 Solo Play

In solo play, oracle answers are the main source of lore. A Lonelog session produces `=>` consequences; the ones that describe the world become `=` lines, in the play log or in the ledger afterwards (Section 7.4). Facts you decide as the author and the character has not discovered are `secret`.

### 9.4 Published Settings

When you play in a published setting, record the facts your campaign uses with page references, and mark what your table changed:

```
[L:Free City|trade port]
  = Ruled by a council of twelve (via: book p. 34)
  x= The council meets in the harbor tower (via: book p. 35)
  (why: we moved the council to the old temple in S2)
  = The council meets in the old temple (via: S2)
```

The ledger then shows at a glance where your campaign departs from the book.

### 9.5 Worldbuilding Games and Collaboration

In a game that builds a world through prompts, cards or turns, record each answer as a fact, and the prompt as a question or as its source:

```
? (prompt) A stranger arrives with news of a far-off danger. What is it?
= Traders report that the upriver dam is cracking (via: Anna)
~(Faction:Cistern Guild) The dam is sound
```

When several people build together, `via:` with each name shows who proposed each piece. Progress tags from Lonelog (`[Clock:]`, `[Track:]`, `[Timer:]`) work unchanged for games that track pressure over turns.

### 9.6 Building a World on Purpose

Worldbuilding methods give you a process: where ideas come from, how to test them, what to write next. Lorelog records what that process produces. To use a method with Lorelog, map its concepts onto the notation once, write the mapping in your world header or a note, and declare any custom labels or tags you need (Section 9.7).

As an example, here is one mapping for the Lean Worldbuilding Method (LWM):

| LWM concept | Lorelog notation |
| --- | --- |
| Queued question (Exploration Mode) | A `?` line |
| Story need (Story Mode) | A `?` line with a custom `(for: …)` note naming the chapter or session |
| Surface layer | A `=` fact |
| Tension layer | A custom `[Tension:]` tag, or a `(note: …)` |
| Ripple | Tag updates on the elements the fact touches |
| Seed keywords | `=?` provisional facts |
| Evolution Log | `x=` retractions with `(why: …)` notes |
| Tests | A `(note: test …)` line, or a custom `t:` prefix |

A method's working units, such as cycles, build sessions or phases, become headers in a lore log, in the same way sessions do.

### 9.7 Your Own Conventions

If your practice needs a new label, prefix or tag type, declare it in the world header and use it consistently. Keep the four core symbols intact. The core is what makes one person's lore readable to another.

## 10. Complete Examples

The same world, kept three ways.

### 10.1 A Lore Log

````markdown
---
title: The Cistern Cities
readers: GM only
play_logs: logs/
---

# The Cistern Cities

## Prep

```
= The Cistern Guild owns every public well [Faction:Cistern Guild|monopoly]
= District wardens enforce Guild licenses, paid per arrest
=? The Temple of the Rain buys wells in secret
= The night shift at the North Gate is sold to smugglers (secret)
? Who buys the night shift?
```

## Session 3

```
= The North Gate closes at dusk [L:North Gate|checkpoint]
~(N:Ossa) Nobody guards the gate at night
= Ossa is the warden captain's nephew (via: Anna)
```

## Session 4

```
= Ossa takes bribes [N:Ossa|corrupt]
~ The Guild poisons the wells it wants to close
= The Eel Brotherhood buys the night shift (secret)
```
````

### 10.2 The Same World as a Ledger

```
[Faction:Cistern Guild|monopoly]
  = Owns every public well (via: prep)
  = Pays district wardens per arrest (via: prep)
  ~ Poisons the wells it wants to close (via: S4)

[L:North Gate|checkpoint]
  = Closes at dusk (via: S3)
  ~(N:Ossa) Nobody guards it at night (via: S3)
  = The night shift is sold to smugglers (secret)

[N:Ossa|warden|corrupt]
  = Nephew of the warden captain (via: S3, Anna)
  = Takes bribes (via: S4)

[Faction:Eel Brotherhood|smugglers]
  = Buys the North Gate night shift (via: S4) (secret)

[Faction:Temple of the Rain]
  =? Buys wells in secret (via: prep)
```

The question from prep is gone from the ledger: session 4 answered it.

### 10.3 Analog Notebook

```
=== Lore: The Cistern Cities ===
[Readers]  GM only

[L:North Gate|checkpoint]
  = Closes at dusk (S3)
  ~(Ossa) Nobody guards it at night (S3)
  = Night shift sold to smugglers (secret)
  ? What happens if the Guild finds out?     [ ]

[N:Ossa|warden|corrupt]
  = Captain's nephew (S3, Anna)
  = Takes bribes (S4)
```

On paper, a bare session number in parentheses is short for `via:`, and a bare name inside `~(…)` is short for its `N:` tag.

## 11. Best Practices

These practices keep lore easy to read and search. None of them says how to build a world.

**Do: keep one fact per line.** Single facts can be tagged, changed or struck one at a time.

**Do: write claims as claims.** If a character said it, it is `~`, however sure it sounds. The truth goes on its own line.

**Do: strike, don't erase.** `x=` with a `(why: …)` note keeps the history of the world readable.

**Do: record the source when it is not obvious.** Six months later, `via:` is often the only way to know whether a fact came from the book, the table or your own prep.

**Do: keep secrets out of shared files.** Mark them `secret` in your own notes, and leave them out of anything the players read.

**Do: file after every session.** A short skim while the session is fresh beats a long one months later.

**Don't: copy whole scenes into your lore.** The play log holds what happened. The lore holds what is now true. Link them with session numbers.

**Don't: skip the code blocks in Markdown.** Outside them, `=` under a line of text turns that line into a heading.

## 12. Templates

### 12.1 World Header (Digital)

```yaml
title:
campaign:
system:
setting:
pitch:
readers:
play_logs:
filed_to:
custom_tags:
start_date:
last_update:
```

### 12.2 Entry

```
[Type:Name|state]
  = Fact (via: ) (known: )
  =? Provisional fact
  ~(Who) Claim
  ? Open question
```

### 12.3 Lore Log Session

```
=== Session # ===
= Fact
~(Who) Claim
? Open question
```

## Appendix A. Legend

### A.1 Core Symbols

| Symbol | Name | Meaning |
| --- | --- | --- |
| `=` | Fact | True in the world |
| `=?` | Provisional fact | True for now, not settled |
| `~` | Claim | Said or believed in the world; may be false |
| `~(Who)` | Attributed claim | A claim with its speaker or believer |
| `?` | Open question | Not decided yet |
| `x` | Strike | Before any core symbol: the line no longer holds |

### A.2 Notes

| Note | Meaning |
| --- | --- |
| `(via: …)` | Where the line came from |
| `(known: …)` | Who in the game knows it |
| `(secret)` | Only the author of the notes knows it |
| `(when: …)` | When it is true in the world |
| `(why: …)` | The reason for a change or decision |
| `(note: …)` | A comment, doubt or reminder |
| `(parked: …)` | An idea kept aside, not part of the world |

### A.3 Tags

| Tag | Element |
| --- | --- |
| `[N:]` | Named person |
| `[PC:]` | Player character |
| `[L:]` | Location |
| `[E:]` | Notable event |
| `[Thread:]` | Story thread |
| `[Faction:]` | Faction or institution |
| `[Term:]` | In-world term, name or concept |
| `[Topic:]` | Religion, law, magic system or other subject |

### A.4 Structure

| Notation | Meaning |
| --- | --- |
| A tag line with indented lines below | Entry |
| `=== Session N ===` | Lore log session (analog) |
| `§` | Section of your setting notes |

## Appendix B. FAQ

**Q: Do I need Lonelog or Partylog to use Lorelog?** A: No. Lorelog stands alone. It shares their tags so that, if you use them, play logs and lore stay searchable together.

**Q: Do I need a particular worldbuilding method?** A: No. Lorelog records facts, whatever produced them: prep, play, a table roll, a book, a method. If you follow a method, map it once (§9.6).

**Q: What is the difference between `=>` and `=`?** A: `=>` is a Lonelog consequence: something that happened in a scene. `=` is a fact: something that is now true of the world. A scene can produce both.

**Q: What is the difference between `=?` and `~`?** A: `=?` is your own unsettled idea about the world. `~` is something a character or group in the world says or believes. A player unsure about a rumor writes `~`, not `=?`.

**Q: Should I strike a fact that stopped being true?** A: No. Strike a fact only if it was never true. If the world changed, add the new state with `when:` (§6.2).

**Q: Can players and the GM share one lore file?** A: Yes, if it holds no secrets. Many groups keep a shared ledger of what the party knows and a private one for the GM.

**Q: How do I share lore with readers who do not know Lorelog?** A: Share the Quick Start (§1.4). The four symbols are enough to read most lore.

## Appendix C. Symbol Design

- **`=`** states that something is so. It reads as "is".
- **`=?`** is "is" with a doubt attached.
- **`~`** is a wave: hearsay that wavers between true and false. In logic and in speech, a tilde means "about" or "approximately".
- **`?`** is the universal sign of a question, and matches Lonelog.
- **`x`** is a strike-through you can write at the start of any line, in any font.

Apart from `?`, which means the same thing in all three notations, Lorelog shares no core symbol with Lonelog or Partylog.

## Credits and License

Copyright 2026 Roberto Bisceglie

Lorelog is a companion to Lonelog. The notation works with any way of running a game or building a world.

**Version history:**

- v 0.2.0: Redrafted as a notation for world facts and lore, for GMs and players, instead of a log of a worldbuilding process. New: claims (`~`), struck lines (`x`), `known:` and `secret` notes, `when:` notes, entries, lore logs, and a routine for filing logs into a ledger or world bible. Removed from the core: `!` needs (which collided with Partylog's `!`), friction, ripples, tests, cycles, build sessions and phases. Worldbuilding methods map onto the notation (§9.6). History uses Lonelog's `[E:]`; `[Hist:]`, `[Rule:]`, `[Tension:]`, `[Q:]` and `[Need:]` are gone.
- v 0.1.1: Aligned with Lonelog v1.7: `gen:` folded into `tbl:`; `[E:]` described as Lonelog v1.7 defines it. Factions use `[Faction:]`, as in Partylog, so they don't collide with the Combat Add-on's `[F:]` foes.
- v 0.1.0: First draft.

This work is licensed under the **Creative Commons Attribution-ShareAlike 4.0 International License**. Worlds and notes you create with Lorelog are your own work and are not subject to this license.

*Happy building.*
