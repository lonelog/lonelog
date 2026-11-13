---
title: "Lonelog v1.7: The Consolidation Release"
date: 2026-11-13
type: devlog
tags: [lonelog, add-ons, notation, oracle, tags, update]
---

# Lonelog v1.7: The Consolidation Release

Every release from v1.0 to v1.6 added something: inline tables, add-ons, tag categories, multiple actors, oracle rolls with `d:`, Lead/Assist. Each one made sense on its own. None of them went back and checked the examples, the legend or the add-ons that relied on the old way of doing things.

When I sat down and read the spec start to finish, the drift was obvious. v1.5 told you to write oracle rolls with `d:`, and nearly every example in the document still used `-> Yes, but... (d6=4)`. `[E:Alert 2/6]` and `[Clock:Alert 2/6]` did the same job. `≤` meant "failed", which is false whenever you roll exactly the target. The FitD example called a single 6 a critical. The Fate examples had dice that didn't add up. The add-on table pointed at files that don't exist.

So v1.7 adds almost nothing new. It settles things. Most of what changed is a decision about something that was already ambiguous in real logs.

**No log becomes invalid.** Every form v1.7 retires is *deprecated*: still readable, still meaning what it meant, just no longer shown in examples. The full list is in the new Appendix E.

---

## Oracle answers: three forms, all valid

v1.5 tried to make `d:` the one way to record an oracle roll and demoted `->` to shorthand. In practice, nobody stopped writing `-> No, but... (d6=3)`, including me. It's compact and it keeps the roll. So v1.7 stops fighting it and names three equal forms:

```
d: d100=60 vs 35 -> No        full: the roll and the target matter
-> No, but... (d6=3)          compact: the roll, no target
-> No, but...                 bare: just the answer
```

And likelihood finally has one home: on the question, because it describes what you asked, not the roll.

```
? Does the guard notice me? (Unlikely)
d: d100=60 vs 35 -> No
```

For compact logs there are now standard answer codes: `Y`, `N`, `Ya`, `Yb`, `Na`, `Nb`, `Yx`, `Nx`.

## `d:` gives a verdict, `tbl:` gives content, and `gen:` is gone

This one took the most thinking. The old rule was: `tbl:` for one roll on a simple table, `gen:` for several rolls combined. But that's a rule about *how many dice*, and nobody reading a log cares how many dice you rolled. The spec itself filed the same Mythic Event roll under both prefixes.

What a reader does care about is what kind of thing came back:

- **`d:` gives a verdict.** Did it work? Is it so? Success, failure, yes, no.
- **`tbl:` gives content.** What is it? Who? What happens? A thing, a name, an event.

```
? Does the guard notice me? (Unlikely)
d: d100=60 vs 35 -> No

? What disrupts the scene?
tbl: Mythic Event
  Focus: d100=78 -> NPC Action
  Meaning: d100=34 -> Betray
```

`gen:` is folded into `tbl:`. Old logs that use it read exactly as before. One nice side effect: a `tbl:` line *without* `->` is a table definition, and one *with* `->` is a result, so a tool can tell them apart without guessing.

## Comparisons that are true

Before:

```
d: 2≤4 F
d:4≥5 F
```

After:

```
d: 2<4 -> F
d: 4<5 -> F
```

`≥` means meets or beats, `<` means falls short, and `vs` stays neutral. The comparison has to be a true statement. Outcome abbreviations always go after `->`. The `d:` line also has a standard order now, `d: [Label] <dice>[+mod]=<total> [vs <target>] -> <outcome>`, matching the Dice Notation Add-on.

## Roll context moves in front of the dice

v1.3 put roll context in brackets after the dice. The Dice Notation Add-on put individual die results in brackets in the same spot. Two features, one position, and a reader left to guess whether `[4, 4]` was a pair of dice or a pair of tags.

Before:

```
d: Investigate 2d6 [Be kind to others, Naive] = 8 -> Mixed
```

After:

```
d: Investigate +[Be kind to others, Naive] 2d6=8 -> Mixed
d: Stealth +[cover] -[injured] d6=3 vs TN 4 -> Fail
```

Brackets before the dice are context, `+` for what helps and `-` for what hinders. Brackets after the dice are results. And `against:` isn't needed any more, because `-[…]` already says it.

## Events are events, clocks are clocks

`[E:Name X/Y]` and `[Clock:Name X/Y]` were the same thing, and the core examples used them interchangeably. Now:

- `[Clock:Alert 2/6]` is the counter.
- `[E:Bridge Collapse]`, with no number, marks something notable that happened.

That gives `E:` a job nothing else does: search a campaign for `[E:` and you get its turning points.

## Tags accumulate

v1.6 offered four ways to update a tag, and two of them looked identical: was `[N:Jonah|captured]` a full restatement or an addition? Now there's one rule. A later tag adds to what's known. `-tag` removes, `old>new` replaces, `HP 6` sets a number, `HP-2` adjusts it.

```
[N:Jonah|friendly|injured]
[N:Jonah|captured]              still friendly and injured
[N:Jonah|-injured]
[N:Jonah|friendly>hostile]
```

Adding things up is right for traits and conditions, but wrong for anything that can only be one thing at a time. A room is unexplored, then cleared; it shouldn't end up both. So there's a second rule: **a value written as `category:value` replaces whatever that category held.**

```
[N:Guard|status:alert]
[N:Guard|status:unconscious]    no longer alert
[PC:Jonah|trait:+reckless]      adds one entry to a list
```

Two more rules finish the set. **Counts are values, not part of the name**: `[N:Bandits|×6]` then `[N:Bandits|×4]`, so the bandits stay the same element as their numbers drop. And **progress tags advance from the name**: `[Clock:Alert+1]`, `[Timer:Dawn-1]`. Every add-on was already writing that last one, so core now says it officially.

The same review turned up add-on tags whose fields only made sense in a fixed order: `[R:ID|status|description|exits]`, `[Unit:Name|size|stats|position|status]`. Skip a field and the rest shift. Now every value says what it is — a labelled number, a count, a category or a plain word — so the order stops mattering: `[R:3|status:cleared|library|exits:N R2, W R4]`. And tags that used to have no name, like `[Wealth:Gold 45]`, now name their owner: `[Wealth:Kael|Gold 45]`.

`>` is the ASCII form of `→`, so you don't need a special character. `#` references work for every tag type, not just NPCs. And every tag has a name, PCs included: `[PC:Alex|HP 6]`, never `[PC:HP 6]`.

## Parallel storylines

"Thread" meant two things: a `[Thread:]` story question and a `T1-S1` parallel line of play. The syntax stays, but the second one is now called a **storyline**. A storyline can declare its point-of-view character on its first scene line, so a bare `@` inside it means that character:

```
T2-S1 *City archives, same time* @(Jordan)
@ Search for lighthouse records
```

When storylines merge, you go back to plain scene numbers with a note. There's one way to do it now instead of two.

## Meta-note labels and retcons

Meta notes get a starter set of labels: `note:`, `house:`, `ruling:`, `interp:`, `retcon:`, `todo:`, `question:`, `reflection:`, `source:`, `break:`. They're suggestions, not rules; invent your own when they don't fit. The point is that two players writing about the same thing reach for the same word.

`retcon:` fills a real gap. Everyone forgets a modifier now and then, and a silent edit makes a shared log untrustworthy. Leave the original line and correct it right after:

```
d: Stealth d6=3 vs TN 4 -> Fail
(retcon: forgot +1 from cover — actually 4 vs TN 4, Success)
=> I slip past unnoticed.
```

No strike-through: Lonelog notation lives in code blocks, where formatting doesn't render anyway.

## Where symbols go

The spec never said. Now it does: in the standard form, each element starts a line. In the compact form, elements can share a line as long as each symbol has a space before it. That's all a tool needs to split `S1 @Sneak d:4<5 ->F => noise`, and it's what people were already writing. One more rule keeps it reliable: `->` marks an outcome and nothing else. It isn't an arrow for prose or tags; a change inside a tag is `old>new`.

## A specification summary, and a shorter front door

Lonelog is written as a friendly tutorial, which is right for players. But anyone building a parser had to reverse-engineer the rules from about sixty examples. The new **Appendix D** states them in two pages, with MUST / SHOULD / MAY, for tool builders and add-on authors. The tutorial stays as it is.

The history of the name and the migration from Solo TTRPG Notation moved to the new **Appendix E**, so a new reader's first page is the notation itself. Appendix A, the legend, is rebuilt to match the spec again. I fixed the system examples in §9 and cut sections that repeated each other.

The document still came out longer than v1.6: Appendix D and the deprecated-forms table add more than the cuts remove.

---

## The rest of the ecosystem

Every add-on and companion notation now targets v1.7:

- **Dice Notation Add-on v1.1.0.** Individual results go in brackets right after the expression, before `=`. Any expression with a compare point takes a space before its result (`5d10>=7 =3`). The Savage Worlds example now keeps the higher of trait die and Wild Die. The full roller grammar moves to an appendix, so the add-on starts with what solo play uses. `#` and `[ … ]` descriptions aren't used in Lonelog logs any more, because core already uses both; `//` and `/* */` remain.
- **Card Notation Add-on v1.1.0.** The biggest change outside core. Most draws give content, so they're now `tbl:`. A draw that answers yes or no stays `d:`. New: deck state with `[Deck:Main|×38|out:Qs, M16]`, hands as a `hand:` category on the character, and a stated rule that card identities always follow `=`, so `4d` (four of diamonds) can't be mistaken for dice.
- **Combat Add-on v1.2.0.** Damage gets its own line (`d: Damage 1d8=5`), tags record HP changes rather than both change and total, and `[COMBAT]` always closes. Compact rolls like `d:14≥15 Miss` are now `d:14<15 ->Miss`, the target goes in the action text (`@Slash Thug` versus `@(Thug)Slash`), roll context moves before the dice, range is a `pos:` category, group sizes are counts (`[F:Pirates|×2]`), and PC tags are named. `!` stays Partylog's: in solo play, foes act through `@(Name)`.
- **Resource Tracking v1.2.0.** Quantities are counts (`[Inv:Torch|×3]`, `[Inv:Torch|×-1]`), five shorthand forms collapse into core's rules, and purses name their owner (`[Wealth:Kael|Gold 45]`). New `owner:` and `where:` categories cover shared and stashed gear, and charges are always `charges N/M`.
- **Dungeon Crawling v1.2.0.** Room status is a `status:` category, so a cleared room is no longer also unexplored; exits are `exits:N R2, E R7 secret`; `[R:3]` is room R3 everywhere, with a `level:` category for multi-level dungeons. A new section covers exploration turns with core notation alone: the turn in the scene context, `[Timer:Torch-1]`, `d: Wandering d6=5 -> No`.
- **Solo Wargaming v1.1.0.** Unit status, formation and position are categories; `[Force:]` and `[Scenario:]` fields are labelled; campaign and hit-location rolls that give content use `tbl:`. The system examples were wrong in places and are corrected: BattleTech weapon damage and heat, Mordheim's d66 injuries, 2d6 advances and exploration, Frostgrave's d20 rolls.
- **Community Add-on Guidelines v1.2.0.** `tbl:` sits with the core symbols, and a new §1.3 lists the reserved syntax add-ons must not reuse: `#`, brackets around dice, the tag update rules and the core meta-note labels.
- **Partylog v1.1.0, Lorelog v0.1.1, Maplog v0.2.2.** The same alignment wherever they share Lonelog's notation. Partylog's `[Party:]` tag is named after the group (`[Party:Crew|Gold 150]`), its combat rounds are `Rd1` like the Combat Add-on's, Lorelog's factions become `[Faction:]` so they don't collide with Combat's `[F:]` foes, and Maplog's room examples follow the new Room tag.

The Italian and French translations will follow.

---

**Your existing logs are fine.** Nothing in v1.7 invalidates a log written for any earlier 1.x version. If you want your old logs to match the new examples, Appendix E has the full list of deprecated forms next to their current equivalents.
