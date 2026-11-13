---
title: "Lonelog: Solo Wargaming Add-on"
subtitle: "Notation for Units, Battles, and Campaigns"
author: Roberto Bisceglie
version: 1.1.0
license: CC BY-SA 4.0
lang: en
parent: Lonelog v1.7.0
requires: Core Notation (§3)
---

# Solo Wargaming Add-on

## Overview

Core Lonelog handles personal-scale play well. The Combat Add-on pushes that further into tactical encounters — individual combatants, initiative rounds, hit points. But its FAQ is explicit: mass battles, vehicle combat, and army-scale action are beyond its scope.

Wargaming sessions break that scope on almost every front. Instead of tracking one character's 12 hit points, you are tracking a unit of twelve soldiers whose morale is cracking under fire. Instead of initiative rounds lasting six seconds, you are logging turns that represent minutes of maneuvering. Instead of a single encounter, you may play out a scenario with objectives, deployment zones, a turn limit, and a campaign consequence riding on the result.

This add-on provides the notation layer that bridges those gaps. It introduces unit-level tags, battle structure blocks, a turn marker distinct from the Combat Add-on's rounds, and a campaign state block for tracking warbands and forces between sessions. The same system works at skirmish scale — ten models in a ruined city quarter — and at lance scale, where a BattleMech's armor grid is the thing being tracked.

**When core notation is enough:** A single fight that resolves in a few rolls does not need this add-on. Core Lonelog plus the Combat Add-on handles that. Reach for this add-on when you need turn-by-turn unit activation, scenario structure, casualty tracking at the unit level, or campaign progression for warbands and forces.

**When not to use:** If your wargame session is essentially one tactical encounter between individual named characters, the Combat Add-on alone is sufficient. This add-on is for sessions where the unit — not the individual — is the mechanical atom of play.

---

### What This Add-on Adds

- `[Unit:Name|×N|stats|status:state]` — Track a military unit's state through a battle. Example: `[Unit:Ironclad Rifles|×12|Morale 8|status:Fresh]`
- `[Force:Name|leader:name|units N|goal:objective]` — Optional: record overall force composition and goal. Example: `[Force:Reiklanders|leader:Captain Streng|units 3|goal:Raid]`
- `[BATTLE]` / `[/BATTLE]` — Delimit a wargame battle within a session. Example: `[BATTLE] ... [/BATTLE]`
- `Tn#` turn markers — Separate unit-scale game turns within a battle. Example: `Tn1`, `Tn2`, `Tn3`
- Location armor fields — Track mech/vehicle armor by hit location. Example: `[Unit:Atlas|Armor CT22/RT18/LT18]`
- `[CAMPAIGN]` / `[/CAMPAIGN]` — Record warband or force state between sessions. Example: `[CAMPAIGN] ... [/CAMPAIGN]`

**No new core symbols.** Unit activations use `@(Unit Name)` — the established actor attribution convention. This add-on introduces no additions to `@`, `?`, `d:`, `->`, or `=>`.

---

### Design Principles

**Units, not individuals.** A unit tag tracks aggregate state — model count, morale, status — not individual wounds. When a unit of twelve soldiers takes casualties, update the count. Individuals matter only when they have names and mechanical distinctions: a named hero, a mech pilot, a warband captain.

**Scale to complexity.** A two-unit skirmish needs less notation than a six-turn battle with eight units per side. Use only as much structure as the scenario demands. The `[BATTLE]` block is optional for quick engagements; the `[CAMPAIGN]` block is optional if you are playing a one-off.

**Campaigns as persistent state.** A wargame campaign is a series of battles connected by consequence. The `[CAMPAIGN]` block at the start and end of each session captures what has changed — casualties replaced, heroes advanced, treasure spent — so the next session begins with accurate state, not reconstructed state.

**Activation follows action.** Unit activations are actions. They use `@(Unit Name)` exactly as the Combat Add-on uses it for enemy actors in personal-scale fights. There is no new activation symbol; the question of *who acts* is the prefix, and the question of *what happens* follows from `d:`, `->`, and `=>` as normal.

---

## Part I: Practical Reference

### How a wargame session fits into a log

A wargame session typically contains one or more battles, each with a scenario (objectives, forces, special rules), several turns of activation and resolution, and a post-battle consequence block. The structure maps directly onto Lonelog's existing session and scene framework.

```
## Session 7 — The River Crossing
*Date: 2026-04-05 | Duration: 2h | Scenes: S1*

[CAMPAIGN]
[Force:Ironclad Company|leader:Colonel Vane|units 3|goal:Hold the bridge]
[Unit:Rifles|×12|Morale 8|status:Fresh]
[Unit:Cavalry|×6|Morale 7|status:Fresh]
[Unit:Artillery|×4|Morale 6|status:Fresh]
[/CAMPAIGN]

### S1 *Broken bridge, dawn*

[BATTLE]
[Scenario:Hold the Line|goal:Deny bridge 6 turns|turns 8]
[Unit:Raider Infantry|×15|Morale 6|status:Fresh|pos:road approach]
[Unit:Raider Skirmishers|×8|Morale 5|status:Fresh|pos:left flank]

Tn1
@(Raider Skirmishers) Advance through woods
@(Rifles) Hold position, volley fire
d: Shooting 2d6=9 vs TN 7 -> Hit
=> [Unit:Raider Skirmishers|×6|status:wavering]

Tn2
d: Morale 2d6=11 vs Morale 5 -> Broken
=> [Unit:Raider Skirmishers|×6|status:broken|fleeing]

[/BATTLE]
=> Bridge held. Raiders withdrew after two turns.

[CAMPAIGN]
[Unit:Rifles|×11]
[/CAMPAIGN]
```

The `[CAMPAIGN]` blocks bookend the battle: the opening block establishes entering state, the closing block records what changed.

---

### The building blocks at a glance

**Activating a unit — player's force:**

```
@ Advance the Rifles to the hedgerow
=> [Unit:Rifles|×12|pos:at hedgerow|status:Fresh]
```

**Activating a unit — opponent's force:**

```
@(Raider Cavalry) Charge the Rifles' left flank
d: Charge 2d6+2=11 vs TN 9 -> Hit
=> [Unit:Rifles|×10|status:wavering] [Unit:Raider Cavalry|×5|status:Engaged]
```

**Morale test:**

```
d: Morale Rifles 2d6=8 vs Morale 8 -> Steady
```

**Casualty update:**

```
=> [Unit:Rifles|×10|status:wavering]
```

**Turn with phase annotations:**

```
Tn3 Move:
@ Advance Rifles to the mill
@(Raider Infantry) Move to the ford

Tn3 Shoot:
@ Rifles fire on Raider Infantry
d: Shooting 2d6=7 vs TN 7 -> Partial
=> [Unit:Raider Infantry|×13|Morale 6|status:Steady]

Tn3 Combat:
@(Raider Infantry) Press the ford crossing
d: Melee 2d6+1=9 vs TN 8 -> Hit
=> [Unit:Rifles|×9|status:wavering]
```

---

## 1. Battle Structure

### The `[BATTLE]` block

The `[BATTLE]` block delimits a wargame engagement within a scene. It signals a shift into denser notation: unit tags, turn markers, activation logs. It is optional for quick fights but recommended whenever a battle runs more than two turns or involves more than two units per side.

**Format:**

```
[BATTLE]
[contents]
[/BATTLE]
```

**What goes inside a `[BATTLE]` block:**

- Scenario line (objectives, turn limit, special rules)
- Force snapshots: `[Force:]` tags if tracking overall forces
- Unit opening states: all units with their entering status
- Turn sequences: `Tn#` markers, activations, rolls, consequences, tag updates
- Mid-battle state snapshots where useful

**Opening snapshot — minimal:**

```
[BATTLE]
[Scenario:Raid|goal:Grab the loot|turns 5]
[Unit:Warband|×8|Morale 6|status:Fresh]
[Unit:Defenders|×6|Morale 7|status:Fresh]
```

**Opening snapshot — expanded:**

```
[BATTLE]
[Scenario:Wyrdstone Hunt|goal:Collect 3+ shards before opponent|turns 6|rule:Night: -1 to shooting]
[Force:Reiklanders|leader:Captain Streng|units 4]
[Force:Skaven|leader:Assassin (hidden)|units 3]

[Unit:Swordsmen|×3|Morale 7|status:Fresh|pos:deployment zone A]
[Unit:Marksmen|×2|Morale 7|status:Fresh|pos:deployment zone A]
[N:Captain Streng|WS4|Ld8|sword+pistol|Fresh]
[Unit:Skaven Night Runners|×6|Morale 5|status:Fresh|pos:deployment zone B]
[Unit:Skaven Clanrats|×4|Morale 4|status:Fresh|pos:deployment zone B]
[N:Skaven Assassin|WS5|hidden]
```

**When to close a block:** At the end of the engagement, when the scenario has resolved (objectives met, one side routed, turn limit reached). Close before writing the post-battle consequence.

**Analog format:**

```
--- BATTLE ---
[contents]
--- END BATTLE ---
```

### `Tn#` turn markers

`Tn#` marks army-scale game turns within a battle. It is explicitly distinct from the Combat Add-on's `Rd#` initiative rounds.

**`Rd#` vs `Tn#`:**

| Marker | Add-on | Scale | Duration |
|--------|--------|-------|---------|
| `Rd#` | Combat | Personal (individual initiative) | ~6 seconds game-time |
| `Tn#` | Wargaming | Unit (activation turn) | Minutes to an hour game-time |

Both can appear in the same log if a wargame session includes a personal-scale duel (see Cross-Add-on Interactions).

**Phase annotations (optional):**

Many wargame systems divide turns into phases. Annotate with a suffix when the system makes phase order meaningful:

```
Tn2 Move:
Tn2 Shoot:
Tn2 Combat:
Tn2 Morale:
```

Leave phases unannotated when activation is free-form or the system does not separate phases.

**Turn counter example:**

```
Tn1
@ Advance Rifles to hedge
@(Raiders) Move up the road

Tn2
@ Rifles fire volley
d: Shooting 2d6=10 vs TN 7 -> Hit
=> [Unit:Raiders|×13|Morale 6|status:Steady]

@(Raiders) Return fire
d: Shooting 2d6=6 vs TN 8 -> Miss

Tn3
@ Charge the raiders while they reload
d: Charge 2d6+2=12 vs TN 9 -> Hit, +1 attack
```

---

## 2. Unit Tracking

The `[Unit:]` tag is the core of this add-on. It records the mechanical state of a military unit — not a named individual, but a group acting as a single mechanical entity.

**Format:**

```
[Unit:Name|×N|stats|pos:position|status:state]
```

**Fields** — in any order. Each one says what it is, so you can skip any of them:

- `Name` — unit identifier (regiment name, unit type, or custom label)
- `×N` — model count. For an abstract size, use the `size:` category: `size:full`, `size:half`, `size:depleted`
- stats — labelled numbers: `Morale 7`, `WS3`, `Move 6`
- `pos:` — optional terrain reference: `pos:at hedge`, `pos:road>ridge`, `pos:C4`
- `status:` — current state (see status vocabulary below)

`size:`, `pos:` and `status:` are categories, so writing a new one replaces the old (core §4.1). A count, likewise, is replaced by a new count. Other values, such as skills, accumulate.

**Examples:**

```
[Unit:Ironclad Rifles|×12|Morale 8|status:Fresh]
[Unit:Skeleton Warriors|×8|Morale 4|status:Fresh|pos:at bridge]
[Unit:Cavalry Screen|×6|Morale 7|pos:at ridge|status:Engaged]
[Unit:Artillery Battery|×4|Morale 6|pos:rear|status:Pinned]
```

### Status vocabulary

| Status | Meaning |
|--------|---------|
| `Fresh` | At full effectiveness, no stress |
| `Steady` | Tested and holding; no mechanical penalty unless system specifies |
| `Wavering` | Morale threatened; one failed test from breaking |
| `Broken` | Failed morale; withdrawing or fleeing |
| `Routed` | Fully fled the field; removed from play |
| `Rallied` | Recovered from Broken; back in play but may have reduced stats |
| `Pinned` | Cannot advance; may still shoot |
| `Engaged` | In melee contact with enemy unit |
| `Exhausted` | Moved and fought; no further actions this turn |

These are defaults, written as `status:Fresh`, `status:Wavering` and so on. Your system may use different terms — substitute freely. Conditions that can stack, like `fleeing` or `stunned`, stay plain values.

### Tracking casualties

Write the new count when a unit takes casualties; it replaces the old one, and the log keeps the history:

```
[Unit:Rifles|×12|Morale 8|status:Fresh]

d: Enemy volley 2d6=8 vs TN 7 -> Hit
=> [Unit:Rifles|×10|Morale 8|status:Steady]
```

For significant losses that affect morale:

```
=> [Unit:Rifles|×8|status:wavering]
d: Morale 2d6=9 vs Morale 8 -> Steady
=> [Unit:Rifles|×8|status:Steady]
```

**Abstract size** (when counting individual models is not the point):

```
[Unit:Orc Mob|size:full|Morale 5|status:Fresh]
=> [Unit:Orc Mob|size:half|status:wavering]
=> [Unit:Orc Mob|size:depleted|status:broken]
```

### Formation states

Systems that track unit formation use a `formation:` category, so a new formation replaces the old one:

```
[Unit:Pikes|×16|Morale 7|formation:Line|status:Fresh]
[Unit:Muskets|×12|Morale 6|formation:Column|status:Marching]

@ Form square against cavalry
=> [Unit:Muskets|×12|Morale 6|formation:Square|status:Fresh]
```

Common formation labels: `Line`, `Column`, `Square`, `Skirmish`, `Wedge`, `Dispersed`.

### The `[Force:]` tag

`[Force:]` is optional. Use it when you want to record the overall composition and objective of a named force — especially in campaigns where force identity persists across sessions.

**Format:**

```
[Force:Name|leader:name|units N|goal:objective]
```

**Fields** — in any order, all optional except the name:

- `Name` — force or army name
- `leader:` — named leader, if any
- strength — a labelled number (`units 3`, `mechs 4`, `figures 6`), or a state such as `status:reduced`
- `goal:` — what this force is trying to accomplish in this battle

**Examples:**

```
[Force:Ironclad Company|leader:Colonel Vane|units 3|goal:Hold the bridge]
[Force:Jade Falcon Scout Lance|leader:Mechwarrior Roshak|mechs 4|goal:Intercept]
```

Leave `[Force:]` out entirely for one-off scenarios with no campaign context.

---

## 3. Scenario Setup

Scenarios give battles their stakes and structure: objectives, turn limits, deployment conditions, and special rules. Record these at the opening of the `[BATTLE]` block.

**Format:**

```
[Scenario:Name|goal:objective|turns N|rule:special rules]
```

**Fields:**

- `Name` — scenario title or identifier
- `goal:` — victory condition
- `turns N` — turn limit, if applicable
- `rule:` — weather, night, terrain effects, or other modifiers (optional; one `rule:` per modifier)

Fields can come in any order.

**Examples — minimal:**

```
[Scenario:Breakthrough|goal:Exit 2+ units south|turns 10]
[Scenario:Wyrdstone Hunt|goal:Collect 3 shards|turns 6]
[Scenario:Last Stand|goal:Survive 5 turns|turns 5]
```

**Examples — expanded:**

```
[Scenario:Raid on the Mill
  | goal: Destroy the mill (requires 1 turn adjacent) OR steal 2+ supply crates
  | turns 7
  | rule: Night fight, shooting -1 TN beyond 12"
  | rule: Reinforcements, defender rolls d6 each turn, arrive on 6+
]
```

**Recording victory and defeat:**

The scenario outcome goes in the `=>` line after `[/BATTLE]`:

```
[/BATTLE]
=> Victory: 2 shards collected, warband withdrew intact.
=> [Thread:Campaign for the Merchant Quarter|Advantage: Reiklanders]
```

---

## 4. Campaign Tracking

A wargame campaign is the story that connects battles. Between sessions, warbands grow (or shrink), heroes advance (or suffer lasting injuries), and forces repair, reinforce, or consolidate. The `[CAMPAIGN]` block captures this state.

### The `[CAMPAIGN]` block

Use `[CAMPAIGN]` blocks at session boundaries — once at the start of a session to establish entering state, and once at the end to record what changed.

**Format:**

```
[CAMPAIGN]
[contents]
[/CAMPAIGN]
```

**What goes inside:**

- `[Force:]` tags for named forces
- `[Unit:]` tags for units with experience or persistent state
- `[N:]` or `[PC:]` tags for named heroes, leaders, or pilots
- `[Wealth:]` for treasury, named after the force: `[Wealth:Reiklanders|Gold 50gc]` (delegates to Resource Tracking Add-on)
- Post-battle rolls and their results (injury tables, experience gains, reinforcement rolls)

**Analog format:**

```
--- CAMPAIGN ---
[contents]
--- END CAMPAIGN ---
```

### Warband progression (skirmish scale)

For games like Mordheim, Frostgrave, or Rangers of Shadow Deep, the warband is the persistent entity. Named heroes are `[N:]` or `[PC:]` tags; unnamed units are `[Unit:]` tags.

**Entering state at session start:**

```
[CAMPAIGN]
[Force:Reiklanders|leader:Captain Streng|units 5|status:Active]
[N:Captain Streng|sword+pistol|WS4|Ld8|6 XP|Fresh]
[N:Champion Aldric|halberd|WS3|Ld7|3 XP|Fresh]
[Unit:Swordsmen|×3|Exp 0|status:Fresh]
[Unit:Marksmen|×2|Exp 2|Marksman skill]
[Wealth:Reiklanders|Gold 50gc]
[/CAMPAIGN]
```

**Post-battle update:**

```
[CAMPAIGN]
tbl: Serious Injury Streng d66=22 -> Leg Wound: -1 Movement
[N:Captain Streng|Leg Wound|M-1|7 XP]
[N:Champion Aldric|4 XP]
tbl: Advance Aldric 2d6=4 -> New skill: Step Aside
[N:Champion Aldric|Step Aside|4 XP]
tbl: Exploration 3d6=7 -> 2 wyrdstone shards
=> I sell both shards. [Wealth:Reiklanders|Gold+35gc]
[Thread:The Haunted Quarter|Open]
(note: Aldric spotted something in the ruins)
[/CAMPAIGN]
```

**Permanent injuries** use the `[N:]` tag's free fields:

```
[N:Captain Streng|Old Battle Wound|-1 WS|8 XP]
[N:Sergeant Voss|Lost Eye|Shooting -1|2 XP]
```

**Hired swords and specialists** use `[Unit:]` with a count of `×1`:

```
[Unit:Dwarf Troll Slayer|×1|Exp 3|Fearless|status:Fresh]
```

### Force progression (larger scale)

For campaign wargames at company scale or above, units accumulate experience, take losses, and require reinforcement or repair.

**Opening state:**

```
[CAMPAIGN]
[Force:Wolf's Dragoons Alpha Lance|leader:Major Natasha|mechs 4|status:Full strength]
[Unit:Atlas AS7-D|Pilot: Natasha|Armor CT30/RT25/LT25|Heat 0|status:Fresh]
[Unit:Marauder MAD-3R|Pilot: Kell|Armor CT22/RT18/LT18|Heat 0|status:Fresh]
[Unit:Wolverine WVR-6R|Pilot: Torres|Armor CT16/RT14/LT14|Heat 0|status:Fresh]
[Unit:Jenner JR7-D|Pilot: Minh|Armor CT10/RT8/LT8|Heat 0|status:Fresh]
[/CAMPAIGN]
```

**Post-battle repair and status:**

```
[CAMPAIGN]
[Unit:Atlas AS7-D|Armor CT8/RT25|needs repair: CT armor]
tbl: Repair time 1d6 days=3 -> Atlas operational in 3 days
[Unit:Marauder MAD-3R|Armor CT22/RT18|status:Fresh]
[Unit:Wolverine WVR-6R|Armor CT16/RT6|needs repair: RT armor]
[Unit:Jenner JR7-D|Pilot: Minh|ejected|mech salvageable]
tbl: Pilot injury 1d6=2 -> Bruised: Minh out 2 days
[N:Minh|bruised|out 2 days]
[/CAMPAIGN]
```

---

## 5. Vehicles and Mechs

Vehicle and mech systems track armor, damage, and in many systems heat — none of which map cleanly to a hit point count. This section adapts the `[Unit:]` tag for that purpose.

### Location-based armor

For systems that track armor by hit location (Battletech, many historical naval games), use the `[Unit:]` tag with a dedicated `Armor` field listing locations in order:

**Battletech location abbreviations:**

| Code | Location |
|------|---------|
| `CT` | Center Torso |
| `RT` | Right Torso |
| `LT` | Left Torso |
| `RA` | Right Arm |
| `LA` | Left Arm |
| `RL` | Right Leg |
| `LL` | Left Leg |
| `HD` | Head |

**Format:**

```
[Unit:Name|Armor CT#/RT#/LT#/RA#/LA#/RL#/LL#|Heat 0|status:state]
```

**Examples:**

```
[Unit:Atlas AS7-D|Armor CT30/RT25/LT25/RA20/LA20/RL28/LL28|Heat 0|status:Fresh]
[Unit:Summoner Prime|Armor CT22/RT18/LT18/RA16/LA16/RL20/LL20|Heat 0|status:Fresh]
[Unit:Jenner JR7-D|Armor CT10/RT8/LT8/RA4/LA4/RL10/LL10|Heat 0|status:Fresh]
```

You do not need to list all locations if your session only tracks a subset. List what matters for your system. (The armor values in this add-on's examples are illustrative, not taken from record sheets.)

### Damage notation

Record the hit with `d:`, the hit location with `tbl:`, and the armor reduction in the tag. `old>new` (or `→`) shows the change:

```
@ Atlas fires its AC/20 at the Summoner
d: Gunnery 2d6=9 vs TN 7 -> Hit
tbl: Location 2d6=7 -> CT
=> 20 damage. [Unit:Summoner|Armor CT22>2/RT18/LT18|status:Steady]
```

Or if internal structure is breached:

```
@ Marauder fires both PPCs at Kit Fox A-1
d: Gunnery 2d6=8 vs TN 5 -> Both hit
tbl: Location 2d6=7 -> CT
tbl: Location 2d6=6 -> RT
=> 10 damage each; the CT armor is gone and the structure behind it fails. [Unit:Kit Fox A-1|Armor CT0|destroyed]
=> Pilot ejects
```

### Heat tracking

Heat is a stat field on the `[Unit:]` tag, updated each turn:

```
[Unit:Atlas AS7-D|Armor CT30/RT25|Heat 0|status:Fresh]

Tn1 Shoot:
@ Atlas fires AC/20 at Summoner
=> [Unit:Atlas|Heat+7]
@(Summoner) ER PPC return fire
=> [Unit:Summoner|Heat+15]

Tn1 Heat:
@ Atlas's 20 heat sinks shed all of it
=> [Unit:Atlas|Heat 0]
@(Summoner) Its heat sinks shed most of it
=> [Unit:Summoner|Heat 5]
```

**Heat effects** come from your system's heat scale; look them up there rather than in the log. Record the effect that applies as a status:

```
=> [Unit:Summoner|Heat 18|status:shutdown risk]
d: Shutdown avoid 2d6=5 vs 6 -> Fail
=> [Unit:Summoner|status:shutdown]
```

### Simplified vehicle tracking

For systems without location-based armor, use a single `Armor N` field:

```
[Unit:War Wagon|Armor 12|Move 4|status:Fresh]
d: Ballista fires at war wagon, 2d6=8 -> Hit, damage 1d6=4
=> [Unit:War Wagon|Armor 12>8|status:Steady]
```

Or use an abstract damage track:

```
[Unit:Tank|damage:Intact|Morale N/A|status:Fresh]
=> [Unit:Tank|damage:Damaged|Move -2]
=> [Unit:Tank|damage:Critical|movement halved, weapon offline]
=> [Unit:Tank|destroyed]
```

---

## Cross-Add-on Interactions

This add-on is standalone, but it works naturally alongside three other add-ons.

### With the Combat Add-on

Some wargames include personal-scale duels within a unit-scale battle — Mordheim heroes breaking away from their warbands to fight a named opponent, or a Battletech pilot ejecting and continuing the fight on foot. In those cases, use both add-ons in the same session.

**Key distinction:** `Tn#` markers for unit-scale turns, `Rd#` markers for personal-scale rounds. Both can appear in the same log.

| Situation | Use |
|-----------|-----|
| Unit activation, morale, casualties | Wargaming Add-on (`Tn#`, `[Unit:]`) |
| Named hero's personal duel | Combat Add-on (`Rd#`, `[F:]`) |

**Combined example — Mordheim duel within a battle:**

```
[BATTLE]
[Scenario:Wyrdstone Hunt|goal:Collect 3 shards|turns 6]
[Unit:Swordsmen|×3|Morale 7|status:Fresh]
[N:Captain Streng|WS4|Ld8|sword+pistol|Fresh]
[Unit:Skaven Night Runners|×6|Morale 5|status:Fresh]
[N:Skaven Assassin|WS5|hidden]

Tn1
@ Advance Swordsmen to center ruins
@(Night Runners) Move toward objective marker

Tn2
@(Skaven Assassin) Reveals and charges Streng — personal combat begins
[COMBAT]
[F:Skaven Assassin|WS5|Str4|2 attacks]

Rd1
@ Streng parries, counterattack
d: WS4 vs WS5 2d6=8 -> Hit
d: Wound Str3 vs T3 1d6=5 -> Wound
=> [F:Skaven Assassin|HP-1|wounded]

@(Skaven Assassin) Two attacks
d: WS5 vs WS4 2d6=7 -> 1 hit
d: Wound Str4 vs T4 1d6=3 -> No wound

Rd2
@ Press the advantage
d: WS4 vs WS5 2d6=10 -> Hit
=> [F:Skaven Assassin|knocked down]
[/COMBAT]
=> [N:Skaven Assassin|fled]

Tn3
@ Swordsmen charge the Night Runners
d: Charge 2d6+1=9 vs TN 7 -> Hit
=> [Unit:Night Runners|×4|status:wavering]
```

### With the Resource Tracking Add-on

Use the Resource Tracking Add-on for treasury, supplies, and ammunition — anything that flows in and out across sessions.

- Warband treasury — `[Wealth:Warband|Gold 45gc]`
- Campaign supplies — `[Inv:Rations — 8]`
- Ammo for special weapons — `[Inv:Blackpowder — 3]`
- Repair parts (Battletech) — `[Inv:CT Armor Pack — 2]`

### With the Dungeon Crawling Add-on

For dungeon-scenario wargames (Frostgrave vault delves, dungeon scenario maps), the Dungeon Crawling Add-on's `[R:]` room tags and exploration notation work naturally inside a `[BATTLE]` block:

```
[BATTLE]
[Scenario:The Vault|goal:Reach the chest|turns 5|rule:Unknown rooms]

[R:1|entrance|torchlit|exits:N, E]
[Unit:Warband|×6|Morale 6|status:Fresh|R:1]

Tn1
@ Move through east passage
tbl: Explore 1d6=4 -> Room 2 revealed
[R:2|collapsed hall|dark|exits:E, S|Trap: pitfall]
```

---

## System Adaptations

### Mordheim

Mordheim uses a small warband (~10–15 models) in skirmish scenarios through a ruined city. Heroes are individually tracked; units are small groups (2–5 identical warriors). The campaign is the main draw: every battle's outcome affects the warband through the serious injury table, experience advances, and exploration.

**Key mappings:**

- Hero — `[N:Name|WS|BS|S|T|W|I|A|Ld|skills|XP]`
- Henchman group — `[Unit:Name|×N|Exp N|status:state]`
- Warband — `[Force:Name|leader:name|units N|status:state]`
- Scenario — `[Scenario:Name|goal:objective|turns N|rule:special rules]`
- Serious injury — `tbl: Serious Injury d66=…`, result in the `[N:]` tag
- Exploration — `tbl: Exploration Nd6=…` (one die per surviving hero), shards sold into `[Wealth:]`
- Advance — `tbl: Advance 2d6=…`, result in the `[N:]` or `[Unit:]` tag
- Shooting, combat — `d: Hit d6=… vs 4+`, then `d: Wound d6=… vs 4+`, then `d: Injury d6=…`

**Example — full Mordheim session:**

```
[CAMPAIGN]
[Force:Reiklanders|leader:Captain Streng|units 5|XP 16]
[N:Captain Streng|WS4|BS3|S3|T3|W1|I4|A2|Ld8|6 XP|Fresh]
[N:Champion Aldric|WS3|BS3|S3|T3|W1|I3|A1|Ld7|Step Aside|4 XP|Fresh]
[Unit:Swordsmen|×3|Exp 0|status:Fresh]
[Unit:Marksmen|×2|Exp 2|Marksman skill|status:Fresh]
[Unit:Dwarf Slayer|×1|Exp 3|Fearless|status:Fresh]
[Wealth:Reiklanders|Gold 85gc]
[/CAMPAIGN]

### S1 *The Merchant Quarter — wyrdstone hunt*

[BATTLE]
[Scenario:Wyrdstone Hunt|goal:Collect 3 shards before opponent|turns 6|rule:Dusk: shooting range –6"]
[Force:Skaven|leader:Grey Seer (hidden)|units 3]
[Unit:Night Runners|×6|Morale 5|status:Fresh|pos:east deployment]
[Unit:Clanrats|×4|Morale 4|status:Fresh|pos:east deployment]
[N:Skaven Grey Seer|WS3|magic|hidden]

Tn1
@ Advance Swordsmen to center ruins
@(Aldric) Move to cover the left alley
@(Night Runners) Advance through rubble
=> [Unit:Night Runners|×6|pos:at rubble]

Tn2
@ Marksmen fire on Night Runners
d: Hit BS3 d6=5 vs 4+ -> Hit
d: Wound S3 vs T3 d6=4 vs 4+ -> Wound
d: Injury d6=6 -> Out of action
=> [Unit:Night Runners|×5|Morale 5|status:Steady]

@ Streng moves onto the first wyrdstone marker
=> Shard 1/3 collected.

@(Grey Seer) Reveals and casts Warp Lightning at Streng
d: Cast Warp Lightning 2d6=9 vs 8 -> Success
d: Wound S5 vs T3 d6=6 vs 2+ -> Wound
d: Injury d6=2 -> Knocked down
=> [N:Captain Streng|knocked down]

Tn3
@ Streng recovers, charges Grey Seer
d: Hit WS4 vs WS3 d6=5 vs 3+ -> Hit
d: Wound S3 vs T3 d6=4 vs 4+ -> Wound
=> [N:Grey Seer|W-1|wounded]

@ Aldric charges Night Runners with Swordsmen
d: Hit 3d6=5,4,2 vs 4+ -> 2 hits
d: Wound 2d6=6,4 vs 4+ -> 2 wounds
d: Injury 2d6=5,6 -> 2 out of action
=> [Unit:Night Runners|×3|status:wavering]

d: Rout test 2d6=9 vs Ld 5 -> Fail
=> [Unit:Night Runners|×3|status:broken|fleeing]

Tn4-6
@ Collect remaining shards, hold position
=> Shards 2/3 collected. Clanrats withdrew.

[/BATTLE]
=> Scenario: Draw. Only 2 shards vs 3 needed. Skaven fled but completed their objective.

[CAMPAIGN]
tbl: Serious Injury Streng d66=26 -> Chest Wound: -1 Toughness
[N:Captain Streng|Chest Wound|T 3>2|7 XP]
[N:Champion Aldric|5 XP]
tbl: Advance Swordsmen 2d6=7 -> +1 WS
[Unit:Swordsmen|×3|Exp 1|WS+1]
tbl: Exploration 3d6=11 -> 2 wyrdstone shards
=> I sell the two shards from exploration and the two from the battle. [Wealth:Reiklanders|Gold+38gc]
[Thread:The Merchant Quarter|Skaven also hunting here|Open]
[/CAMPAIGN]
```

---

### Battletech

Battletech tracks individual mechs, each with location-based armor, internal structure, heat, and a pilot. Battles are typically at lance scale (4 mechs), with turns divided into Movement, Weapons, and Heat phases.

**Key mappings:**

- Mech — `[Unit:Name|Armor CT#/.../LL#|Heat 0|status:state]`
- Pilot — `[N:Name|Piloting #|Gunnery #|status:state]`
- Lance — `[Force:Name|leader:name|mechs 4|goal:mission]`
- Initiative — `d: Initiative 2d6=N vs 2d6=N -> winner`
- Weapon attack — `d: Gunnery 2d6=N vs TN N -> Hit`, then `tbl: Location 2d6=N -> location`
- Piloting skill roll — `d: Piloting 2d6=N vs TN N -> Success`
- Heat phase — Update `Heat N` field after each turn

**Example — lance engagement:**

```
[CAMPAIGN]
[Force:Alpha Lance|leader:Major Natasha|mechs 4|status:Operational]
[Unit:Atlas AS7-D|Pilot: Natasha (G3/P4)|Armor CT30/RT25/LT25/RA20/LA20/RL28/LL28|Heat 0|status:Fresh]
[Unit:Marauder MAD-3R|Pilot: Kell (G2/P3)|Armor CT22/RT18/LT18/RA16/LA16/RL20/LL20|Heat 0|status:Fresh]
[Unit:Wolverine WVR-6R|Pilot: Torres (G3/P3)|Armor CT16/RT14/LT14/RA10/LA10/RL16/LL16|Heat 0|status:Fresh]
[Unit:Jenner JR7-D|Pilot: Minh (G3/P4)|Armor CT10/RT8/LT8/RA4/LA4/RL10/LL10|Heat 0|status:Fresh]
[/CAMPAIGN]

### S1 *Industrial wasteland, Luthien outskirts*

[BATTLE]
[Scenario:Breakthrough|goal:Exit 2+ mechs off south edge|turns 12|rule:Heavy rubble terrain: +1 TN movement]
[Force:Jade Falcon Scout Lance|leader:Mechwarrior Roshak|mechs 4]
[Unit:Summoner Prime|Pilot: Roshak (G2/P2)|Armor CT22/RT18/LT18/RA16/LA16/RL20/LL20|Heat 0|status:Fresh]
[Unit:Kit Fox A|×3|Pilot: assorted (G3/P3)|Armor CT10/RT8/LT8/RA6/LA6/RL12/LL12|Heat 0|status:Fresh]

Tn1 Move:
d: Initiative 2d6=9 vs 2d6=6 -> Alpha Lance moves second (advantage)
@(Summoner) Advance north through rubble
@(Kit Fox ×3) Fan out, east flank screening formation
@ Atlas advances north, uses rubble for cover
@ Wolverine and Jenner sprint south along road

Tn1 Shoot:
@ Atlas fires AC/20 at Summoner
d: Gunnery 2d6=9 vs TN 7 -> Hit
tbl: Location 2d6=7 -> CT
=> 20 damage.
=> [Unit:Summoner|Armor CT22>2/RT18/LT18|Heat 0|status:Steady]

@(Summoner) ER PPC at Atlas
d: Gunnery 2d6=5 vs TN 6 -> Miss

@ Marauder fires PPC×2 at Kit Fox A-1
d: Gunnery 2d6=7 vs TN 5 -> Both hit
tbl: Location 2d6=7 -> CT
tbl: Location 2d6=7 -> CT
=> 20 damage to the CT: armor gone, structure destroyed. [Unit:Kit Fox A-1|Armor CT0|destroyed]
=> The Kit Fox pilot ejects.

@(Kit Fox A-2, A-3) LRM 10 at Marauder
d: Gunnery 2d6=8, 2d6=6 vs TN 7 -> 1 hit, 1 miss
tbl: Cluster 2d6=7 -> 6 missiles
tbl: Location 2d6=9 -> RT
=> [Unit:Marauder|Armor CT22/RT12/LT18|Heat 0|status:Steady]

Tn1 Heat:
@ Atlas's heat sinks shed the 7 from the AC/20
=> [Unit:Atlas|Heat 0]
@(Summoner) Its heat sinks shed most of the 15 from the ER PPC
=> [Unit:Summoner|Heat 5]

Tn2 Move:
@ Wolverine exits south edge — breakthrough objective 1/2
@ Jenner exits south edge — breakthrough objective 2/2

[/BATTLE]
=> Breakthrough achieved. Wolverine and Jenner escaped. Atlas and Marauder provide cover; mission success.

[CAMPAIGN]
[Unit:Atlas AS7-D|Armor CT30/RT25|Heat 0|damage:Intact]
[Unit:Marauder MAD-3R|Armor CT22/RT12|needs repair RT armor]
[Unit:Wolverine WVR-6R|Armor CT16/RT14|damage:Intact]
[Unit:Kit Fox A-1|destroyed, salvageable]
tbl: Repair Marauder RT 1d6 days=2 -> back in 2 days
[Track:Operation Luthien 2/4]
[/CAMPAIGN]
```

---

### Frostgrave

Frostgrave uses a wizard, an apprentice and a handful of soldiers, with scenario treasure and light campaign rules. Every roll is a d20. Other fantasy skirmish games with small warbands map the same way.

```
[CAMPAIGN]
[Force:Sigilist Warband|leader:Sigilist Caldris|figures 6|Level 4]
[N:Caldris|Sigilist|Lv4|Will +4|Health 14|Fresh]
[N:Apprentice Voss|Apprentice|Will +2|Health 12|Fresh]
[Unit:Infantryman|×2|Exp 0|status:Fresh]
[Unit:Thug|×2|Exp 0|status:Fresh]
[Wealth:Sigilist Warband|Gold 200gc]
[/CAMPAIGN]

### S3 *Frozen ruins, midwinter*

[BATTLE]
[Scenario:The Library|goal:Find and retrieve 4 treasure tokens|turns unlimited|rule:Snow: -1 Move]
[Unit:Rival Warband|×6|Morale 6|status:Fresh|pos:north edge]

Tn1
@ Caldris moves toward central treasure, casts Leap on Voss
d: Cast Leap d20=14 vs 8 -> Success
=> Voss leaps to the east treasure token.

@ Voss picks up treasure
=> Token secured.

@(Rival Infantryman) Charges Thug A
d: Fight d20+2=9 vs Thug d20+2=15 -> Thug wins
=> 15 against armor 11: 4 damage. [Unit:Rival Infantryman|Health-4]

Tn2
@ Caldris casts Elemental Bolt at Rival Apprentice
d: Cast Elemental Bolt d20=6 vs 12 -> Fail
=> Failed by 6: Caldris takes 1 damage. [N:Caldris|Health-1]

@ Infantry advance toward second token

[/BATTLE]
=> 2 tokens secured, warband withdrew safely.

[CAMPAIGN]
[N:Caldris|Lv4>Lv5]
=> Level 5: I choose +1 Fight. [N:Caldris|Fight+1]
tbl: Survival Thug A d20=3 -> Badly wounded, misses next game
[Unit:Thug A|×1|injured|out next session]
tbl: Treasure d20=7 -> 150gc
tbl: Treasure d20=16 -> Scroll of Push
[Wealth:Sigilist Warband|Gold+150gc]
[Inv:Scroll of Push|×1]
[/CAMPAIGN]
```

---

## Best Practices

**Do: Use `[BATTLE]` for any multi-turn engagement**

```
✔ [BATTLE]
  [Scenario:Raid|goal:Escape with the chest|turns 5]
  [Unit:Warband|×8|Morale 6|status:Fresh]
  Tn1 ...
  [/BATTLE]
```

**Don't: Open a battle block for a single-roll resolution**

```
✗ [BATTLE]
  [Scenario:Bar fight]
  Rd1
  @ Hit them -> d: 2d6=9 -> Win
  [/BATTLE]
```

```
✔ @ Brawl with the guards
  d: 2d6+2=9 vs TN 7 -> Win
  => We're clear.
```

---

**Do: Update unit tags inline as state changes**

```
✔ d: Shooting 2d6=8 vs TN 7 -> Hit
  => [Unit:Raiders|×10|status:wavering]
  d: Morale 2d6=9 vs Morale 6 -> Broken
  => [Unit:Raiders|×10|status:broken|fleeing]
```

**Don't: Track individual model hit points in a unit tag**

```
✗ [Unit:Raiders|Model1:HP3,Model2:HP2,Model3:HP1,Model4:HP3...]
```

```
✔ [Unit:Raiders|×4|size:half strength|status:Steady]
```

---

**Do: Use the Combat Add-on for personal-scale duels within a battle**

```
✔ Tn3 — Captain breaks away to duel the enemy champion
  [COMBAT]
  [F:Enemy Champion|HP 8|Close]
  Rd1
  @ Strike the champion
  d: d20+5=18 vs AC 14 -> Hit
  ...
  [/COMBAT]
```

**Don't: Use `Rd#` for unit-scale turns**

```
✗ Rd1
  @(Infantry) Advance to ford
```

```
✔ Tn1
  @(Infantry) Advance to ford
```

---

**Do: Delegate financial tracking to the Resource Tracking Add-on**

```
✔ [Wealth:Warband|Gold 50gc]
  tbl: Income 2d6=9 -> 9gc
  [Wealth:Warband|Gold+9gc]
```

**Don't: Invent a new wealth tag when one already exists**

```
✗ [Treasury:50gc]
```

---

**Do: Use `[CAMPAIGN]` blocks at session boundaries**

```
✔ [CAMPAIGN]
  [Force:Warband|state before battle]
  [/CAMPAIGN]

  [BATTLE] ... [/BATTLE]

  [CAMPAIGN]
  [Force:Warband|state after battle]
  [/CAMPAIGN]
```

**Don't: Skip campaign state tracking and reconstruct it from memory next session**

---

## Quick Reference

### New Tags

- `[Unit:Name|×N|stats|status:state]` — Military unit state. Example: `[Unit:Rifles|×12|Morale 8|status:Fresh]`
- `[#Unit:Name]` — Reference to established unit. Example: `[#Unit:Rifles]`
- `[Force:Name|leader:name|units N|goal:objective]` — Overall force summary (optional). Example: `[Force:Alpha Lance|leader:Natasha|mechs 4|goal:Breakthrough]`

### `[Unit:]` Fields

| Field | Format | Example |
|-------|--------|---------|
| Size (count) | `×N` | `×12` |
| Size (abstract) | `full` / `half` / `depleted` | `half` |
| Morale | `Morale N` | `Morale 7` |
| Armor (single) | `Armor N` | `Armor 14` |
| Armor (locations) | `Armor CT#/RT#/LT#/...` | `Armor CT22/RT18/LT18` |
| Heat (Battletech) | `Heat N` | `Heat 5` |
| Experience | `Exp N` | `Exp 3` |
| Position | Named terrain or grid | `at hedge` / `C4` |
| Formation | Label | `Line` / `Square` / `Column` |
| Status | See vocabulary | `Fresh` / `Broken` |

### Unit Status Vocabulary

| Status | Meaning |
|--------|---------|
| `Fresh` | Full effectiveness |
| `Steady` | Tested and holding |
| `Wavering` | One failed test from breaking |
| `Broken` | Failed morale, withdrawing |
| `Routed` | Fled the field |
| `Rallied` | Recovered from broken |
| `Pinned` | Cannot advance |
| `Engaged` | In melee contact |
| `Exhausted` | No further actions this turn |

### Structural Blocks

| Block | Opens when | Closes when |
|-------|-----------|------------|
| `[BATTLE]` | Battle begins | Scenario resolves |
| `[CAMPAIGN]` | At session start or end | After state is recorded |

**Analog equivalents:** `--- BATTLE ---` / `--- END BATTLE ---`, `--- CAMPAIGN ---` / `--- END CAMPAIGN ---`

### Turn Markers

| Marker | Add-on | Scale |
|--------|--------|-------|
| `Tn#` | Wargaming | Unit-scale game turns |
| `Rd#` | Combat | Personal-scale initiative rounds |

### Battletech Location Codes

`CT` `RT` `LT` `RA` `LA` `RL` `LL` `HD`

### Complete Example

```
[CAMPAIGN]
[Force:Reiklanders|leader:Captain Streng|units 3|status:Active]
[N:Captain Streng|WS4|Ld8|6 XP|Fresh]
[Unit:Swordsmen|×3|Exp 0|status:Fresh]
[Wealth:Warband|Gold 50gc]
[/CAMPAIGN]

[BATTLE]
[Scenario:Raid|goal:Steal the idol|turns 5|rule:Night: –1 shooting]
[Unit:Cultists|×6|Morale 5|status:Fresh]
[N:Cult Leader|WS4|Ld7|armed|Fresh]

Tn1
@ Streng advances to ruined altar
@(Cultists) Move to intercept
@(Cult Leader) Charges Streng
d: WS4 vs WS4 2d6=9 -> Hit
=> [N:Captain Streng|HP-1]

Tn2
@ Streng counterattacks
d: WS4 vs WS4 2d6=11 -> Hit, +1 wound
=> [N:Cult Leader|knocked down]
@ Swordsmen charge cultist flank
d: WS3 vs WS3 2d6=8 -> Hit, 2 kills
=> [Unit:Cultists|×4|status:wavering]
d: Morale 1d6=6 vs Ld 5 -> Broken
=> [Unit:Cultists|×4|status:broken|fleeing]

[/BATTLE]
=> Victory. Idol secured.

[CAMPAIGN]
tbl: Injury Streng 1d6=4 -> No lasting effect
[N:Captain Streng|7 XP|Fresh]
tbl: Income 1d6=5 -> 15gc from the idol
[Wealth:Warband|Gold+15gc]
[/CAMPAIGN]
```

---

## FAQ

**Q: When should I use this add-on instead of the Combat Add-on?**  
A: Use the Combat Add-on for personal-scale fights — one character vs. one or a few named opponents, tracked hit point by hit point, initiative round by round. Use this add-on when the unit is the mechanical atom: when you track model counts rather than individual HP, when turns represent minutes rather than seconds, when scenario objectives drive the action. For games that mix both (Mordheim, warcrawl RPGs), use both add-ons in the same session.

**Q: Can I use `Rd#` for my wargame turns instead of `Tn#`?**  
A: You can, but it creates confusion if you ever mix wargaming notation with the Combat Add-on in the same log. `Rd#` has a specific meaning (personal-scale initiative round) in the established Lonelog ecosystem. `Tn#` reserves a distinct identity for unit-scale game turns.

**Q: My system doesn't have morale — do I need status vocabulary?**  
A: No. Status fields are optional. If your system doesn't track morale or unit condition, simply omit those fields from `[Unit:]` tags. `[Unit:Rifles|×12|status:Fresh]` is perfectly valid notation.

**Q: How do I handle random scenario events — traps triggering, weather changing, reinforcements arriving?**  
A: Use `d:` for a roll that decides whether something happens, `tbl:` for a roll that decides what arrives, and `=>` for the consequence. For events that simply occur without a roll, write them in prose or as a meta note: `(note: Skaven Rat Ogre arrives turn 3)`. If you play with a GM or an umpire, Partylog's `!` symbol records GM and world events: `! Reinforcements arrive on the east road`.

**Q: How do I track a large battle with 20+ units per side?**  
A: Focus your log on the units that matter most — the ones that have consequential moments, pass or fail critical morale tests, or carry the objective. Units that do nothing interesting in a turn don't need an entry. The log is a record of the meaningful, not a transcript of every activation.

**Q: How does this work in an analog notebook?**  
A: Use `--- BATTLE ---` / `--- END BATTLE ---` and `--- CAMPAIGN ---` / `--- END CAMPAIGN ---` instead of the bracket blocks. Tag syntax is identical. Turn markers (`Tn1`, `Tn2`) work as headings or margin notes. For mech armor, a small grid in the margin is faster than writing out all location values.

**Q: Can I use this add-on without any campaign tracking?**  
A: Yes. For a one-off scenario with no campaign consequence, skip `[CAMPAIGN]` blocks entirely and use just `[BATTLE]`, unit tags, and turn markers. The campaign elements are completely optional.

**Q: Do I need `[Force:]` tags?**  
A: Only if force identity is meaningful to you — usually in campaigns where force composition persists or you want to record who commanded what. For single-session battles, just list the units directly without a force wrapper.

---

## Credits & License

© 2026 Roberto Bisceglie

This add-on extends [Lonelog](https://zeruhur.itch.io/lonelog) by Roberto Bisceglie.

The Solo Wargaming Add-on was prompted by community requests to support Battletech and Mordheim session logging. The Combat Add-on's explicit note that "mass battles, vehicle combat, and chase scenes may warrant their own add-ons" provided the design mandate.

**Version History:**

- v1.1.0: Corrected the BattleTech, Mordheim and Frostgrave examples (weapon damage and heat, d66 injuries, 2d6 advances, exploration, d20 rolls); armor values marked illustrative; the heat table replaced by a pointer to your system's heat scale. Aligned with Lonelog v1.7: campaign and hit-location rolls that give content use `tbl:`; tag changes use `old>new`; unit sizes are `×N` values, never part of the name; treasury changes are written as changes (`Gold+7gc`). World events: Partylog's `!` for GM-run games.
- v1.0.0: Initial release

This work is licensed under the **Creative Commons Attribution-ShareAlike 4.0 International License**.

You are free to share and adapt this material, provided you give appropriate credit and distribute adaptations under the same license. Session logs and play records created using this add-on's notation are your own work and are not subject to this license.
