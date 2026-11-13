# Lonelog: Combat Add-on
Roberto Bisceglie

# Combat Add-on

## Overview

Combat is where solo play gets dense. Dice fly, hit points drop,
positions shift—and you’re running both sides. Without structure, your
log turns into a wall of text where you can’t tell who hit whom or when
things went wrong.

This add-on gives you optional notation for tactical encounters. It
layers on top of core Lonelog—using the same `@`, `d:`, `->`, `=>`
symbols—and adds just enough structure to keep fights readable without
turning your session into a spreadsheet.

Not every solo game has tactical combat. *Thousand Year Old Vampire*
doesn’t need round tracking. A *Mythic GME*-driven investigation might
resolve a bar fight in a single oracle question. If your system resolves
combat with a single roll, core notation handles it fine:

    @ Fight the bandits
    d: Combat 2d6=9 -> Strong Hit
    => I cut through them and escape into the alley.

This add-on is for everything more involved than that—games where you’re
tracking rounds, multiple combatants, ranges, and changing hit points.

------------------------------------------------------------------------

### What This Add-on Adds

- `[F:Name|stats]` — Track combatant stats and status. Example:
  `[F:Thug|HP 6|pos:Close]`
- `[COMBAT]` / `[/COMBAT]` — Delimit a tactical encounter within a
  scene. Example: `[COMBAT] ... [/COMBAT]`
- `Rd#` round markers — Separate initiative rounds within a combat
  block. Example: `Rd1`, `Rd2`, `Rd3`
- `@(Name) Action` — Attribute actions to non-PC actors. Example:
  `@(Thug A) Lunges at me`
- `Rd# Roster: [tags]` — Snapshot all combatant states at a round
  boundary. Example: `Rd3 Roster: [PC:Alex|HP 3] [F:Boss|HP 4]`

**No new core symbols.** This add-on introduces no additions to `@`,
`?`, `d:`, `->`, or `=>`.

------------------------------------------------------------------------

### Design Principles

**No new core symbols.** Combat uses `@`, `d:`, `->`, `=>` exactly as
defined in core Lonelog. New elements are structural markers and
formatting conventions only—not symbolic shortcuts.

**Scale to complexity.** A quick skirmish needs less notation than a
five-round battle with six combatants. Use only as much structure as the
encounter demands. The add-on supports both extremes.

**Actor clarity first.** The central problem of combat logging is
knowing who is doing what. Every addition here serves that goal—round
markers separate turns, the `@(Name)` prefix identifies non-PC actors,
foe tags track changing states.

------------------------------------------------------------------------

## 1. Combat Blocks

Some encounters benefit from a structural boundary that signals a change
in mode—denser notation, round-by-round tracking, mechanical state
changes. The `[COMBAT]` block provides that boundary.

**Format:**

    [COMBAT]
    ...combat notation...
    [/COMBAT]

#### 1.1 In Scene Headers

When the entire scene is a fight, place `[COMBAT]` in the scene header:

    S5 *Warehouse ambush* [COMBAT]

Close it with `[/COMBAT]` when the fight ends, like any block, even if
the scene ends at the same moment. An explicit close tells you, and any
tool reading the log, exactly where the dense notation stops.

#### 1.2 Inline During a Scene

When combat starts mid-scene, open and close the block around the
tactical section:

    S5 *Warehouse, midnight*
    @ Search the crates for evidence
    d: Investigation d6=5 vs TN 4 -> Success
    => I find shipping manifests—but hear footsteps behind me.

    [COMBAT]
    ...combat notation here...
    [/COMBAT]

    => With the thugs unconscious, I grab the manifests and run.

The `[COMBAT]` / `[/COMBAT]` delimiters let you visually separate the
tactical section from the narrative, find combat encounters when
scanning a log, and signal to future-you that denser notation follows.

#### 1.3 Analog Format

For paper notebooks, use dashed separators:

    --- COMBAT ---
    ...combat notation...
    --- END COMBAT ---

Or skip delimiters entirely—the round markers below already signal
combat.

**When to skip the block:** If combat resolves in one or two rolls, core
notation handles it without any block structure.

------------------------------------------------------------------------

## 2. Round Tracking

Discrete combat rounds get `Rd#` markers. Think of them as mini-scenes
within the fight.

**Format:**

    Rd1
    ...actions...

    Rd2
    ...actions...

**Numbering:** Start at `Rd1` each combat. Rounds are local to the
encounter, not the session.

**Example — minimal:**

    Rd1 @ Slash d:17≥12 ->Hit => [F:Thug|HP-5] @(Thug) d:9<15 ->Miss
    Rd2 @ Finish him d:20≥12 ->Hit => [F:Thug|dead]

**Example — expanded:**

    Rd1
    @ Draw sword and attack Thug A
    d: d20+5=17 vs AC 12 -> Hit
    d: Damage 1d8=5
    => [F:Thug A|HP-5|staggered]

    @(Thug A) Wild swing back
    d: d20+3=9 vs AC 15 -> Miss
    => He's off-balance—I press the advantage.

    Rd2
    @ Strike again
    d: d20+5=14 vs AC 12 -> Hit
    d: Damage 1d8=6
    => [F:Thug A|dead]

**Damage** gets its own `d:` line, with the label first:
`d: Damage 1d8=5`. In compact form, chain it after the hit:
`@Slash Thug d:17≥12 ->Hit d:Damage 1d8=5 =>[F:Thug|HP-5]`. During play,
record the change (`HP-5`); keep the total (`HP 1`) for snapshots and
round rosters, and don’t write both in one tag.

**In compact form, the target goes in the action text**: `@Slash Thug`
is me attacking the thug; `@(Thug)Slash` is the thug acting. A bare name
after `@` is never used.

**When to skip round markers:** If combat is fast (one or two rolls) or
your system doesn’t use discrete rounds, log actions sequentially
without markers.

------------------------------------------------------------------------

## 3. Tracking Combatants

Core Lonelog tracks NPCs with `[N:Name|tags]`. In combat, you often need
tighter tracking—hit points, position, status effects that change every
round. The **foe tag** `[F:Name|stats]` is a combat-specific variant
designed for this.

**Format:**

    [F:Name|stats|pos:range|conditions]

**Fields** — in any order after the name, because each one says what it
is:

- `Name` — combatant identifier; use A/B suffixes to distinguish
  individuals of the same type
- stats — labelled numbers: `HP 6`, `AC 12`, `ATK +3`; a group’s size is
  a count, `×4`
- `pos:` — range band: `pos:Close`, `pos:Medium`, `pos:Far`,
  `pos:Engaged`; or `zone:` for zone-based systems, `zone:Alley`
- conditions — plain values that can stack: `wounded`, `staggered`,
  `dead`, `fled`

`pos:` and `zone:` are categories (core §4.1), so a new position
replaces the old one. Conditions accumulate; remove one with `-`:
`[F:Thug A|-staggered]`.

#### 3.1 Individual Foes

    [F:Thug A|HP 6|pos:Close|armed]
    [F:Cultist Leader|HP 12|pos:Far|spellcaster]

Update foe tags as stats change—either on a new line or inline:

    [F:Thug A|HP 6|pos:Close]
    ...Thug A takes 3 damage...
    [F:Thug A|HP 3|pos:Close|wounded]

    ...or shorthand:
    [F:Thug A|HP-3]

#### 3.2 Grouped Foes

When individuals don’t need separate tracking, group them. Put the count
in a `×N` value, not in the name, so the group stays the same element as
it shrinks (core §4.1):

    [F:Goblins|×4|HP 3 each|pos:Close]
    ...one dies...
    [F:Goblins|×3]

Split groups when they diverge in position or status:

    [F:Pirate 1|pos:Close|wounded]
    [F:Pirate 2|pos:Medium|crossbow]

#### 3.3 Position and Movement

Track range with the `pos:` category. Common range bands:

    [F:Archer|HP 5|pos:Far]
    [F:Thug|HP 6|pos:Close]
    [F:Wolf|HP 4|pos:Engaged]

Show movement with `from>to`, the same form core Lonelog uses for any
changed value (`→` works too):

    @(Thug A) Rushes in [Far>Close]
    [F:Thug A|pos:Close]

For grid or zone-based systems:

    [F:Thug A|HP 6|zone:Alley]
    [F:Thug B|HP 4|zone:Rooftop]
    [PC:Alex|zone:Street]

**Why `[F:]` instead of `[N:]`?** `[N:]` is for persistent NPCs who
matter to your story. `[F:]` is for combatants—often disposable, defined
by mechanical stats rather than narrative tags. The distinction keeps
your NPC index clean. A recurring villain might be
`[N:Viktor|ambitious|ruthless]` in narrative scenes and gain a
`[F:Viktor|HP 15|pos:Far|armored]` when the swords come out.

**When to skip foe tags:** For simple fights (one enemy, no position
tracking), `[N:]` or naming the enemy in prose works fine. Foe tags earn
their keep when you need to track multiple combatants with changing
stats.

------------------------------------------------------------------------

## 4. Actor Actions

In normal play, `@` always means “I, the player character, do
something.” In combat, enemies and allies act too. **`@` stays as the PC
action. For other actors, prefix the action with the actor’s name in
parentheses.**

| Actor        | Format            | Example                   |
|--------------|-------------------|---------------------------|
| PC (default) | `@ Action`        | `@ Swing at Thug A`       |
| Named foe    | `@(Name) Action`  | `@(Thug A) Slash at PC`   |
| Group        | `@(Group) Action` | `@(Goblins) Swarm attack` |
| Ally NPC     | `@(Name) Action`  | `@(Jordan) Cover fire`    |

**Example — minimal:**

    Rd1
    @ Slash d:18≥12 ->Hit => [F:Thug A|HP-6|dead]
    @(Thug B) Stab d:14<15 ->Miss

**Example — expanded:**

    Rd1
    @ Draw sword and attack Thug A
    d: d20+5=18 vs AC 12 -> Hit
    d: Damage 1d8=6
    => [F:Thug A|HP-6|dead]

    @(Thug B) Lunges at me with a knife
    d: d20+3=14 vs AC 15 -> Miss
    => The knife whistles past my ear.

**Why not a new symbol for foe actions?** Because `@` already means
“action taken.” The parenthetical prefix identifies who—that’s all the
disambiguation needed. Adding a symbol (like `>>`) would break the
Lonelog principle of minimal core symbols and add one more thing to
remember mid-fight. (`!` already exists in Partylog, for GM and world
events in group play; it isn’t a foe-action symbol either.)

**Reactions and interrupts:** Log them where they happen, and say so in
the action:

    @(Alex) Riposte as a reaction
    @ Opportunity attack as he breaks away

**Shorthand for fast combats:** When speed matters more than
readability, go chronological within each round and let the foe tags
provide context:

    Rd1
    [F:Thug A|pos:Close] @(A) Slash d:14<15 ->Miss
    @ Riposte d:18≥12 ->Hit => [F:Thug A|HP-6|dead]
    [F:Thug B|pos:Close] @(B) Stab d:11<15 ->Miss

**Roll context:** When a combatant’s tags or status directly affect the
mechanics of a roll, list them before the dice using roll context (core
Lonelog §4.1.9): `+[…]` for what helps, `-[…]` for what hinders.

    @(Pirate Captain) Presses the attack
    d: -[staggered] d20+6=11 vs AC 14 -> Miss

    @ Strike at the weakened Captain
    d: +[flanking, high ground] d20+5=18 vs AC 13 -> Hit

This is most useful in tag-heavy systems (City of Mist, Fate) where
named tags mechanically modify rolls. In traditional d20 systems, the
roll line alone is usually sufficient.

------------------------------------------------------------------------

## 5. Complex Encounters

When more than two sides clash, structure matters most.

#### 5.1 Encounter Setup

Before Rd1, establish the battlefield with a combat snapshot listing all
combatants with initial positions and key stats:

    S9 *Dockside ambush* [COMBAT]
    [PC:Alex|HP 12|pos:Engaged]
    [N:Jordan|ally|HP 8|pos:Close]
    [F:Pirate Captain|HP 10|pos:Close|armed|sword]
    [F:Pirates|×2|HP 4 each|pos:Medium|armed|crossbow]
    [F:Dock Rat|HP 2|pos:Engaged|knife]

This is your combat snapshot—the state of the field when initiative
starts.

#### 5.2 Round Rosters

For fights with many combatants and fast-changing stats, open each round
with a roster line:

    Rd3 Roster: [PC:Alex|HP 3] [N:Jordan|HP 4] [F:Pirate Captain|HP 4] [F:Pirates|×1|HP 4]

This gives you a snapshot at each round without hunting back through the
log.

**Scaling tips:**

- **Group identical foes.** `[F:Pirates|×2]` beats tracking Pirate A and
  Pirate B separately—unless they’re in different positions or have
  different status.
- **Split groups when needed.** If one pirate moves and the other
  doesn’t: `[F:Pirate 1|pos:Close]` `[F:Pirate 2|pos:Medium]`.
- **Kill the tags, keep the story.** Don’t track HP for mooks if one hit
  kills them. Just note `[F:Dock Rat|dead]`.
- **Use rosters** when you have 5+ combatants or stats are changing fast
  enough that you’d lose track without a summary.

------------------------------------------------------------------------

## 6. Combat Aftermath

When combat ends, bridge back to the narrative with `=>`, update
persistent tags, and open any new threads:

    [/COMBAT]
    => Two pirates dead, the captain fled into the fog. Jordan is wounded.
    [N:Jordan|wounded|HP 4]
    [Thread:Pirate Captain's Revenge|Open]
    [PC:Alex|HP 5|Stress+1]

This reconnects the mechanical combat to your ongoing story.

**Loot and rewards:**

    => I search the bodies.
    tbl: Pirate Loot d100=67 -> Captain's sea chart
    => A map showing a hidden cove. [Track:Pirate Cove 1/4]
    [PC:Alex|gear:+Sea Chart]

------------------------------------------------------------------------

## 7. Putting It All Together

Here’s the same encounter at three levels of detail—find your comfort
zone.

#### Ultra-compact

    S9 *Dock ambush* [COMBAT]
    [PC:Alex|HP 12] [F:Pirate Captain|HP 10] [F:Pirates|×2|HP 4] [F:Dock Rat|HP 2]
    Rd1 @Slash Dock Rat d:17≥10 ->Hit =>[F:Dock Rat|dead] @(Pirate Captain)Cutlass d:19≥14 ->Hit d:Damage 1d8+2=7 =>[PC:Alex|HP-7] @(Pirates)Volley d:15,9 vs 11 ->1 Hit d:Damage 1d6=4 =>[N:Jordan|HP-4]
    Rd2 @Hit Pirate Captain d:20≥13 ->Hit d:Damage 1d8=6 =>[F:Pirate Captain|HP-6] @(Pirates)Shoot d:8<14 ->Miss @(Jordan)Shoot d:16≥11 ->Hit =>[F:Pirates|×1]
    Rd3 @Hit Pirate Captain d:15≥13 ->Hit d:Damage 1d8=2 =>[F:Pirate Captain|HP-2|fled]
    [/COMBAT] =>Captain escapes

#### Standard

    S9 *Dockside ambush* [COMBAT]
    [PC:Alex|HP 12] [N:Jordan|ally|HP 8]
    [F:Pirate Captain|HP 10|pos:Close] [F:Pirates|×2|HP 4|pos:Medium] [F:Dock Rat|HP 2|pos:Engaged]

    Rd1
    @ Slash at Dock Rat
    d: d20+4=17 vs AC 10 -> Hit => [F:Dock Rat|dead]

    @(Pirate Captain) Charges, swings cutlass [Close>Engaged]
    d: d20+6=19 vs AC 14 -> Hit
    d: Damage 1d8+2=7 => [PC:Alex|HP-7]

    @(Jordan) Crossbow at the Pirate Captain
    d: d20+3=12 vs AC 13 -> Miss

    @(Pirates) Crossbows at Jordan
    d: d20+2=15,9 vs AC 11 -> 1 Hit
    d: Damage 1d6=4 => [N:Jordan|HP-4]

    Rd2
    @ Power attack on the Pirate Captain
    d: d20+4=20 vs AC 13 -> Hit
    d: Damage 1d8=8 => [F:Pirate Captain|HP-8|wounded]

    @(Pirate Captain) Desperate slash
    d: d20+6=11 vs AC 14 -> Miss

    @(Jordan) Second shot at remaining Pirate
    d: d20+3=16 vs AC 11 -> Hit => [F:Pirates|×1]

    @(Pirates) The last one drops his crossbow and flees => [F:Pirates|×0|fled]

    Rd3
    @ Chase the Pirate Captain
    d: Athletics d6=3 vs TN 5 -> Fail
    => He leaps off the dock into a rowboat and vanishes into the fog.

    [/COMBAT]
    => Two pirates dead, one fled, Captain escaped by sea.
    [N:Jordan|wounded] [PC:Alex|HP 5|Stress+1]
    [Thread:Pirate Captain's Revenge|Open]

#### Narrative-rich

    S9 *Dockside, fog rolling in off the harbor*

    The crates provide cover, but not for long. A rat-faced man with a
    knife lunges from behind a barrel. Behind him, the Pirate Captain
    draws his cutlass with a grin. Two crossbowmen take position on the
    cargo stack.

    [COMBAT]
    [PC:Alex|HP 12|pos:Engaged] [N:Jordan|ally|HP 8|pos:Close]
    [F:Pirate Captain|HP 10|pos:Close|cutlass]
    [F:Pirates|×2|HP 4 each|pos:Medium|crossbow]
    [F:Dock Rat|HP 2|pos:Engaged|knife]

    Rd1
    @ Sidestep the Dock Rat and slash
    d: d20+4=17 vs AC 10 -> Hit
    d: Damage 1d8=5
    => The rat-faced man crumples. [F:Dock Rat|dead]

    But I've left my flank open.

    @(Pirate Captain) Charges across the dock, cutlass high [Close>Engaged]
    d: d20+6=19 vs AC 14 -> Hit
    d: Damage 1d8+2=7
    => His blade bites deep across my ribs. I stagger back. [PC:Alex|HP-7|wounded]

    PC: "Jordan—the crossbows!"

    @(Jordan) Snaps off a shot at the Pirate Captain
    d: d20+3=12 vs AC 13 -> Miss
    => The bolt sparks off a mooring chain.

    @(Pirates) Fire at Jordan from the cargo stack
    d: d20+2=15, d20+2=9 vs AC 11 -> 1 Hit, 1 Miss
    d: Damage 1d6=4
    => A bolt punches through Jordan's shoulder. [N:Jordan|HP-4|wounded]

    N (Jordan): "I'm hit—still in it!"

    Rd2
    The Captain is close, bleeding confidence. I press the advantage.

    @ Power attack on the Pirate Captain
    d: d20+4=20 vs AC 13 -> Critical Hit
    d: Damage 2d8=8
    => My sword catches him across the chest. He stumbles. [F:Pirate Captain|HP-8|staggered]

    @(Pirate Captain) Wild swing in desperation
    d: d20+6=11 vs AC 14 -> Miss
    => His cutlass sweeps wide—I duck under it.

    @(Jordan) Pivots and fires at the crossbowmen
    d: d20+3=16 vs AC 11 -> Hit
    d: Damage 1d6=5
    => One pirate tumbles off the cargo stack. [F:Pirates|×1]

    The surviving pirate drops his crossbow and bolts into the fog.
    [F:Pirates|×0|fled]

    Rd3
    @ Chase the Pirate Captain before he escapes
    d: Athletics d6=3 vs TN 5 -> Fail
    => He's too fast—vaults the dock railing and drops into a hidden
    rowboat. The fog swallows him in seconds.

    [/COMBAT]

    I press a hand to my ribs, breathing hard. Jordan limps over,
    shoulder dark with blood. The dock is quiet except for lapping water
    and the creak of ropes.

    PC (Alex): "He'll be back."
    N (Jordan): "Then we'd better be ready."

    => Two pirates dead, one fled, Captain escaped by sea.
    [N:Jordan|wounded|HP 4] [PC:Alex|HP 5|Stress+1]
    [Thread:Pirate Captain's Revenge|Open]

------------------------------------------------------------------------

## Cross-Add-on Interactions

- Tracking consumables used during combat — Combat + Resource Tracking —
  `[F:]`, `[Inv:Name|×N]`
- Combat in an explored dungeon room — Combat + Dungeon Crawling —
  `[COMBAT]`, `[R:Room|status:state]`

**Combined example — Combat + Resource Tracking:**

    S7 *Guard room* [COMBAT]
    [PC:Alex|HP 10|pos:Engaged] [Inv:Health Potion|×2]
    [F:Guards|×2|HP 5 each|pos:Close|armed]

    Rd1
    @ Strike Guard 1
    d: d20+4=19 vs AC 12 -> Hit
    d: Damage 1d8=7
    => [F:Guard 1|dead]

    @(Guard 2) Counterattack
    d: d20+3=16 vs AC 14 -> Hit
    d: Damage 1d6=4
    => [PC:Alex|HP-4]

    Rd2
    @ Drink healing potion, using my action
    => [PC:Alex|HP+4] [Inv:Health Potion|×-1]

    @(Guard 2) Retreats and raises alarm
    => [F:Guard 2|fled]

    [/COMBAT]
    => Guard room clear, one potion used, alarm raised.
    [Thread:Alarm Raised|Open]

------------------------------------------------------------------------

## System Adaptations

### D&D 5e / OSR Systems

These systems use AC, d20 attack rolls, and explicit damage dice—the
combat add-on maps naturally. Use the `vs AC #` convention in `d:` lines
and record damage on its own line: `d: Damage 1d6+2=7`.

    [F:Skeleton|HP 13|AC 13|pos:Close]

    Rd1
    @ Attack with shortsword
    d: d20+4=17 vs AC 13 -> Hit
    d: Damage 1d6+2=7
    => [F:Skeleton|HP-7|damaged]

    @(Skeleton) Claw swipe
    d: d20+4=11 vs AC 15 -> Miss

### Ironsworn / Starforged

These systems use move-based resolution without traditional initiative.
Round markers are optional—each move generates its own outcome. Focus on
move names as action labels and use foe tags for tracking enemy harm and
threat state.

    [COMBAT]
    [F:Broken|Formidable|pos:Engaged]
    [Track:Broken 0/10]

    @ Enter the Fray, facing off
    d: Enter the Fray d6+2=5 vs 6,8 -> Miss
    => Broken strikes first. Pay the Price. Foe has initiative.

    @ Face Danger, trying to deflect the incoming strike
    d: Face Danger d6+3=4 vs 7,8 -> Miss
    => Pay the Price: -3 health. Foe retains initiative.

    @ Endure Harm
    d: Endure Harm d6+3=5 vs 4,8 -> Weak Hit
    => Press on.
    [PC:Alex|health-3]

    @ Clash, foe has initiative, close quarters
    d: Clash d6+3=7 vs 5,9 -> Miss
    => I burn momentum 10 to cancel both challenge dice: Strong Hit.
    => +1 harm: 3 harm with a deadly weapon marks 3 progress. I gain the initiative.
    [Track:Broken+3]
    [PC:Alex|momentum 2]

    @ Strike, I have initiative, close quarters
    d: Strike d6+3=9 vs 2,4 -> Strong Hit
    => +1 harm: 3 more progress. I retain initiative.
    [Track:Broken 6/10]

    @ End the Fight
    d: End the Fight 6 vs 3,5 -> Strong Hit
    => Broken is no longer in the fight.
    [F:Broken|dead]
    [/COMBAT]

### Powered by the Apocalypse (PbtA)

PbtA games rarely use discrete rounds—moves resolve fiction, not turns.
Use `[COMBAT]` only for extended conflicts where tracking harm or threat
levels adds value. Log moves with their names and results as normal.

    [COMBAT]
    [F:Gang|×6|Threat 3|pos:Close]

    @ Seize by Force — throw myself into them
    d: 2d6+2=9 -> 7–9 Weak Hit
    => I take definite harm: choose one of their tags.
    [PC:Alex|harm-1] [F:Gang|Threat-1]

    [/COMBAT]

------------------------------------------------------------------------

## Best Practices

**Do: Scale notation to encounter complexity**

    ✔ Simple fight:
    @ Slash at the guard
    d: d20+4=15 vs AC 12 -> Hit
    d: Damage 1d8=5
    => He drops. Clear.

    ✔ Complex fight:
    S5 *Warehouse ambush* [COMBAT]
    [F:Captain|HP 10|pos:Close] [F:Guards|×2|HP 4 each|pos:Medium]
    Rd1
    @ Charge at Captain...

**Don’t: Over-engineer simple encounters**

    ✗ [COMBAT]
      Rd1 Roster: [PC:Alex|HP 10] [F:Guard|HP 4|pos:Close|armed|alert]
      @ Attack Guard
      d: d20+4=15 vs AC 10 -> Hit
      => [F:Guard|HP-6|dead]
      [/COMBAT]

    ✔ @ Cut down the lone guard before he can shout.
      d: d20+4=15 -> Hit
      d: Damage 1d8=6
      => Dead.

**Do: Use `@(Name)` for all non-PC actors**

    ✔ @(Thug B) Flanks me
      d: d20+3=17 vs AC 15 -> Hit
      d: Damage 1d6=4
      => [PC:Alex|HP-4]

    ✔ @(Jordan) Returns fire
      d: d20+3=14 vs AC 11 -> Hit
      => [F:Pirate 1|dead]

**Don’t: Invent new symbols for enemy actions**

In solo play, enemies act through `@(Name)` like every other actor. (`!`
is Partylog’s symbol for GM and world events in group play; it doesn’t
stand in for a foe’s action.)

    ✗ ! Thug attacks: d20+3=17 -> Hit => PC HP-4
    ✗ >> Guard lunges: d20+2=12 -> Miss

    ✔ @(Thug) Attacks
      d: d20+3=17 -> Hit => [PC:Alex|HP-4]

**Do: Update foe tags as stats change mid-encounter**

    ✔ [F:Captain|HP 10|pos:Close]
      ...after 7 damage...
      [F:Captain|HP-7|staggered]

**Don’t: Reconstruct state retroactively**

    ✗ [F:Captain|HP 10]
      ...five rounds, no updates...
      => Captain is at HP 3 somehow.

    ✔ Track changes in-round: [F:Captain|HP-7|staggered]

**Do: Write aftermath as narrative, not just tags**

    ✔ [/COMBAT]
      => Two pirates dead, one fled, the captain escaped by sea.
      Jordan is wounded but walking. I have questions about that ship.
      [N:Jordan|wounded|HP 4] [Thread:Pirate Captain's Revenge|Open]

**Don’t: End combat with only tag updates**

    ✗ [/COMBAT]
      [N:Jordan|wounded|HP 4]
      [PC:Alex|HP 5]

------------------------------------------------------------------------

## Quick Reference

### New Tags

- `[F:Name|stats]` — Track individual combatant state. Example:
  `[F:Thug A|HP 6|pos:Close|armed]`
- `[F:Name|×#|stats]` — Track a group of identical combatants. Example:
  `[F:Goblins|×3|HP 3 each|pos:Close]`
- `[F:Name|HP-#]` — Inline damage shorthand. Example: `[F:Thug A|HP-3]`
- `[F:Name|dead]` — Mark a combatant as eliminated. Example:
  `[F:Thug A|dead]`
- `[F:Name|fled]` — Mark a combatant as escaped. Example:
  `[F:Captain|fled]`

### Structural Blocks

| Block | Opens When | Closes When |
|----|----|----|
| `[COMBAT]` | Initiative is declared or combat begins | All combatants are resolved or combat ends |
| `[/COMBAT]` | — | Closes the open `[COMBAT]` block |

### Conventions

- Round marker — `Rd#`. Example: `Rd1`, `Rd2`, `Rd3`
- Actor prefix — `@(Name) Action`. Example: `@(Thug A) Slash at PC`
- Movement — `[Range>Range]`. Example: `[Far>Close]`
- Round roster — `Rd# Roster: [tags]`. Example:
  `Rd3 Roster: [PC:Alex|HP 3] [F:Boss|HP 4]`
- Initiative note — `Rd1 (init: Name #, …)`. Example:
  `Rd1 (init: Captain 18, Alex 15)`

### Complete Example

    S9 *Dockside ambush* [COMBAT]
    [PC:Alex|HP 12] [N:Jordan|ally|HP 8] [F:Pirate Captain|HP 10|pos:Close] [F:Pirates|×2|HP 4|pos:Medium]

    Rd1
    @ Slash Pirate Captain d:19≥13 ->Hit d:Damage 1d8+2=7 => [F:Pirate Captain|HP-7|staggered]
    @(Pirate Captain) Desperate swing d:11<14 ->Miss
    @(Jordan) Fires at Pirate d:16≥11 ->Hit => [F:Pirates|×1]
    @(Pirates) Last one flees => [F:Pirates|×0|fled]

    [/COMBAT]
    => Captain fled by sea. Jordan wounded. Two pirates down.
    [N:Jordan|wounded|HP 4] [Thread:Pirate Captain's Revenge|Open]

------------------------------------------------------------------------

## FAQ

**Q: When should I use this add-on instead of core notation?** A: When
combat lasts three or more rounds, when multiple combatants act each
round, or when turn order and position matter to the story. For
single-roll fights, core notation is sufficient.

**Q: Should I track initiative order?** A: Only if your system uses it
and it matters. Most solo players go in logical order (threats first,
then PC, then allies) or follow their system’s rules. To note it, use a
meta note with the `init:` label:
`Rd1 (init: Captain 18, Alex 15, Jordan 12, Pirates 8)`.

**Q: Do I need `[F:]` tags, or can I just use `[N:]`?** A: Either works.
`[F:]` is a convenience for separating combat stats from narrative NPC
tags—it keeps your NPC index cleaner in long campaigns. For simple
fights, `[N:]` is fine.

**Q: What about reactions, interrupts, or out-of-turn actions?** A: Log
them where they happen and say so in the action:
`@(Alex) Riposte as a reaction` or
`@ Opportunity attack as he breaks away`.

**Q: How do I handle area effects or multi-target attacks?** A: List the
targets and roll for each, or roll once and apply to all:

    @ Fireball targeting the three goblins
    d: Fireball 8d6=28
    d: Goblin 1 save 12<14 -> Fail
    d: Goblin 2 save 17≥14 -> Success
    d: Goblin 3 save 8<14 -> Fail
    => Two goblins incinerated. One dodged, half damage. [F:Goblins|×1|HP 2|singed]

**Q: What about vehicle combat, chase scenes, or mass battles?** A: This
add-on covers personal-scale combat. Those scenarios may warrant their
own add-ons—but the principles here (round markers, actor prefixes,
position tracking) will apply.

**Q: How does this work in an analog notebook?** A: Use `--- COMBAT ---`
and `--- END COMBAT ---` as delimiters. Round markers (`Rd1`, `Rd2`)
work as-is. For foe tags, write them in the margin or in a column beside
the round text. Update HP with strikethroughs: ~~HP 6~~ HP 3.

**Q: When should I use round rosters?** A: When you have five or more
combatants and stats are changing fast enough that you’d lose track
without a summary. For smaller fights, tracking changes inline with foe
tags is sufficient.

------------------------------------------------------------------------

## Credits & License

© 2026 Roberto Bisceglie

This add-on extends [Lonelog](https://zeruhur.itch.io/lonelog) by
Roberto Bisceglie.

Written to address clarifications raised by u/Electorcountdonut, built
upon examples contributed by u/AvernusIsAFurnace.

**Version History:**

- v 1.2.0: Damage gets its own `d: Damage` line; tags record HP changes,
  totals only in snapshots; in compact form the target is in the action
  text; `[COMBAT]` always closes; one name per foe. Aligned with Lonelog
  v1.7: range is a `pos:` category (or `zone:`), so movement replaces
  the old position; roll context before the dice, truthful comparisons
  with outcomes after `->`, named `[PC:]` tags, `[Track:]` instead of a
  counted `[E:]`, movement written `[Far>Close]` to match core’s
  `old>new`. Group sizes are `×N` values instead of part of the name.
  Ironsworn example uses the standard `d:` line. `!` is Partylog’s
  GM-event symbol, not a foe-action symbol.
- v 1.1.0: Round markers changed from `R#` to `Rd#` to avoid collision
  with `[R:]` room tags in the Dungeon Crawling Add-on
- v 1.0.0: First version

This work is licensed under the **Creative Commons
Attribution-ShareAlike 4.0 International License**.

You are free to share and adapt this material, provided you give
appropriate credit and distribute adaptations under the same license.
Session logs and play records created using this add-on’s notation are
your own work and are not subject to this license.
