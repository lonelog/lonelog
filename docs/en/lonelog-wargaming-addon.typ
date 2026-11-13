// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)
// 0. DEFINE HELPER FUNCTIONS (accessible from markdown)
// These must be defined BEFORE the template function

// Color Palette - Solo RPG Notation
#let color-black = rgb("#000000")
#let color-subtitle = rgb("#666666")
#let color-code-text = rgb("#585260")
#let color-code-bg = rgb("#efecf4")
#let color-inline-code = rgb("#188038")
#let color-white = rgb("#FFFFFF")

// Font System
#let font-title = "Montserrat"
#let font-body = "Lora"
#let font-code = "Consolas"

// Multilingual TOC titles
#let toc-titles = (
  "en": "Contents",
  "fr": "Table des matières",
  "de": "Inhaltsverzeichnis",
  "es": "Índice",
  "it": "Sommario",
  "pt": "Sumário",
  "nl": "Inhoud",
  "pl": "Spis treści",
  "ru": "Содержание",
  "ja": "目次",
  "zh": "目录",
)

// Custom callout box function
#let callout(title: none, body) = {
  v(0.8em)
  rect(
    width: 100%,
    //fill: color-code-bg,
    stroke: 0.5pt + color-subtitle,
    radius: 2pt,
    inset: (x: 12pt, y: 10pt)
  )[
    #if title != none {
      text(
        font: font-title,
        size: 10pt,
        weight: "semibold",
        fill: color-black
      )[#title]
      v(0.4em)
    }
    #set text(size: 11pt, fill: color-black, font: font-body)
    #body
  ]
  v(0.8em)
}

// 1. DEFINE THE TEMPLATE FUNCTION
// This function takes all the metadata Quarto sends
#let worldbuilders(
  title: none,
  subtitle: none,
  version: none,
  authors: none,
  date: none,
  abstract: none,
  cols: 1,
  margin: (x: 1.5cm, y: 1.5cm),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: (),
  fontsize: 11pt,
  section-numbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  logo-image: none,      // Path to logo image
  license-image: none,   // Path to CC license stamp
  doc, // This is the actual content (body)
) = {

  // 2. CONFIGURATION
  // Colors and fonts are defined globally above, accessible here via closure

  // Half-letter format (5.5 x 8.5 in) with margins for KDP
  set page(
    width: 5.5in,
    height: 8.5in,
    margin: (top: 1.5cm, bottom: 1.8cm, left: 1.5cm, right: 1.5cm),
    fill: color-white
  )

  // SANITIZE LANGUAGE INPUT
  // Simple fallback: if lang is none or empty, use "en"
  let safe-lang = if lang == none or lang == "" { "en" } else { lang }
  let safe-region = if region == none or region == "" { "US" } else { region }


  // Apply text settings - Body text: Lora Medium 11pt
  set text(
    font: font-body,
    size: 11pt,
    weight: "medium",
    fill: color-black,
    lang: safe-lang,
    region: safe-region
  )

  // Paragraph settings
  set par(
    leading: 0.65em,
    justify: true,
    linebreaks: "simple"
  )

  // 3. CUSTOM SHOW RULES - Heading Hierarchy
  // Note: Markdown ## becomes Typst level 1, ### becomes level 2, etc.

  // HEADING LEVEL 1 (markdown ##) - Montserrat Bold 16pt, black
  show heading.where(level: 1): it => {
    v(1.5em)
    set text(
      font: font-title,
      size: 16pt,
      weight: "bold",
      fill: color-black
    )
    it
    v(0.8em)
  }

  // HEADING LEVEL 2 (markdown ###) - Montserrat Semi Bold 14pt, black
  show heading.where(level: 2): it => {
    v(1em)
    set text(
      font: font-title,
      size: 14pt,
      weight: "semibold",
      fill: color-black
    )
    it
    v(0.5em)
  }

  // HEADING LEVEL 3 (markdown ####) - Montserrat Semi Bold 12pt, black
  show heading.where(level: 3): it => {
    v(0.8em)
    set text(
      font: font-title,
      size: 12pt,
      weight: "semibold",
      fill: color-black
    )
    it
    v(0.4em)
  }
  
  // Table styling
  set table(
    stroke: (x, y) => {
      if y == 0 {
        (bottom: 0.5pt + color-subtitle)  // Underline header
      } else {
        none
      }
    },
    fill: (col, row) => {
      if row == 0 {
        none  // Headers no background
      } else if calc.odd(row) {
        color-code-bg  // Alternating rows
      } else {
        none
      }
    },
    inset: (x: 8pt, y: 6pt)
  )

  // Header cells - Montserrat
  show table.cell.where(y: 0): set text(
    font: font-title,
    size: 10pt,
    weight: "semibold",
    fill: color-black
  )

  // Body cells - Lora
  show table.cell: set text(
    font: font-body,
    size: 10pt,
    fill: color-black
  )

  show figure.where(kind: table): set block(
    width: 100%,
    breakable: true
  )

  // Code block styling - Consolas 11pt, #585260 text, #efecf4 background
  show raw.where(block: true): it => {
    set text(
      font: font-code,
      size: 11pt,
      fill: color-code-text
    )
    block(
      width: 100%,
      //fill: color-code-bg,
      inset: 10pt,
      radius: 2pt,
      it
    )
  }

  // Inline code styling - Consolas 11pt, #188038 highlight
  show raw.where(block: false): it => {
    text(
      font: font-code,
      size: 11pt,
      fill: color-inline-code
    )[#it]
  }

  // Block Quote Styling
  show quote.where(block: true): it => {
    set text(
      font: font-body,
      style: "italic",
      size: 10pt,
      fill: color-subtitle
    )
    set par(leading: 0.65em)
    v(1em)
    pad(left: 1.5em, right: 1.5em)[#it.body]
    v(1em)
  }

  // 4. COVER PAGE
  if title != none {
    set page(
      numbering: none,
      footer: none,
      fill: color-white,
      margin: 1.5cm
    )

    // Everything aligned right
    align(right)[
      #v(5cm)
      // Logo
      #if logo-image != none {
        v(0.5cm)
        image(logo-image, width: 60%)
        v(-0.5em)
      } else {
        v(3cm)
      }

      // Main title - Montserrat Black 26pt, black (no extra space)
      #text(
        font: font-title,
        size: 32pt,
        weight: "black",
        fill: color-black
      )[#title]

      #v(0.5em)

      // Subtitle - Montserrat Semi Bold 12pt, #666666
      #if subtitle != none {
        text(
          font: font-title,
          size: 11pt,
          weight: "semibold",
          fill: color-subtitle
        )[#subtitle]
      }

      #v(0.3em)

      // Version with "Version" prefix
      #if version != none {
        text(
          font: font-title,
          size: 11pt,
          weight: "medium",
          fill: color-subtitle
        )[Version #version]
      }
    ]

    // CC License stamp at the bottom
    if license-image != none {
      place(
        bottom + center,
        dy: -1.5cm,
        image(license-image, width: 25%)
      )
    }

    pagebreak(weak: true, to: "odd")
  }

  // 5. TABLE OF CONTENTS
  if toc {
    set page(
      numbering: "i",
      fill: color-white,
      // KDP requires 0.25" (6.35mm) minimum from edge EXCLUDING page numbers
      // Bottom margin = 0.25" safe zone + ~11pt for page number + spacing to content
      margin: (top: 1.5cm, bottom: 1.8cm, left: 1.5cm, right: 1.5cm),
      footer-descent: 0.25in,  // Page number sits 0.25" from bottom edge
      footer: context [
        #set text(
          font: font-body,
          size: 11pt,
          fill: color-black
        )
        #align(if calc.odd(here().page()) { right } else { left })[
          #counter(page).display("i")
        ]
      ]
    )
    counter(page).update(1)

    // TOC title styling
    show outline: it => {
      v(2em)
      text(
        font: font-title,
        size: 16pt,
        weight: "bold",
        fill: color-black
      )[#if toc_title != none { toc_title } else { toc-titles.at(safe-lang, default: "Contents") }]
      v(1.5em)
      it
    }

    // Level 1 entries - bold
    show outline.entry.where(level: 1): it => {
      set text(
        font: font-title,
        weight: "semibold",
        fill: color-black
      )
      it
    }

    // Level 2+ entries - regular
    show outline.entry: it => {
      set text(
        font: font-body,
        size: 10pt,
        fill: color-black
      )
      it
    }

    outline(title: none, depth: toc_depth, indent: 1.2em)

    pagebreak(weak: true, to: "odd")
  }

  // 6. MAIN BODY
  set page(
    numbering: "1",
    fill: color-white,
    // KDP requires 0.25" (6.35mm) minimum from edge EXCLUDING page numbers
    margin: (top: 1.5cm, bottom: 1.8cm, left: 1.5cm, right: 1.5cm),
    footer-descent: 0.25in,  // Page number sits 0.25" from bottom edge
    footer: context [
      #set text(
        font: font-body,
        size: 11pt,
        fill: color-black
      )
      #align(if calc.odd(here().page()) { right } else { left })[
        #counter(page).display()
      ]
    ]
  )
  counter(page).update(1)

  // Render the body content
  doc
}

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
)

#show: doc => worldbuilders(
  title: "Lonelog: Solo Wargaming Add-on",
  subtitle: "Notation for Units, Battles, and Campaigns",
  version: "1.1.0",
  authors: ("Roberto Bisceglie", ),
  date: none,
  abstract: none,
  cols: 1,
  lang: "en",
  region: "US",
  section-numbering: none,
  toc: true,
  toc_title: "Table of contents",
  toc_depth: 2,
  logo-image: "assets/logo.png",
  license-image: "assets/by-sa.png",
  doc,
)

= Solo Wargaming Add-on
<solo-wargaming-add-on>
== Overview
<overview>
Core Lonelog handles personal-scale play well. The Combat Add-on pushes that further into tactical encounters --- individual combatants, initiative rounds, hit points. But its FAQ is explicit: mass battles, vehicle combat, and army-scale action are beyond its scope.

Wargaming sessions break that scope on almost every front. Instead of tracking one character's 12 hit points, you are tracking a unit of twelve soldiers whose morale is cracking under fire. Instead of initiative rounds lasting six seconds, you are logging turns that represent minutes of maneuvering. Instead of a single encounter, you may play out a scenario with objectives, deployment zones, a turn limit, and a campaign consequence riding on the result.

This add-on provides the notation layer that bridges those gaps. It introduces unit-level tags, battle structure blocks, a turn marker distinct from the Combat Add-on's rounds, and a campaign state block for tracking warbands and forces between sessions. The same system works at skirmish scale --- ten models in a ruined city quarter --- and at lance scale, where a BattleMech's armor grid is the thing being tracked.

#strong[When core notation is enough:] A single fight that resolves in a few rolls does not need this add-on. Core Lonelog plus the Combat Add-on handles that. Reach for this add-on when you need turn-by-turn unit activation, scenario structure, casualty tracking at the unit level, or campaign progression for warbands and forces.

#strong[When not to use:] If your wargame session is essentially one tactical encounter between individual named characters, the Combat Add-on alone is sufficient. This add-on is for sessions where the unit --- not the individual --- is the mechanical atom of play.

#pagebreak()
=== What This Add-on Adds
<what-this-add-on-adds>
- `[Unit:Name|×N|stats|status:state]` --- Track a military unit's state through a battle. Example: `[Unit:Ironclad Rifles|×12|Morale 8|status:Fresh]`
- `[Force:Name|leader:name|units N|goal:objective]` --- Optional: record overall force composition and goal. Example: `[Force:Reiklanders|leader:Captain Streng|units 3|goal:Raid]`
- `[BATTLE]` / `[/BATTLE]` --- Delimit a wargame battle within a session. Example: `[BATTLE] ... [/BATTLE]`
- `Tn#` turn markers --- Separate unit-scale game turns within a battle. Example: `Tn1`, `Tn2`, `Tn3`
- Location armor fields --- Track mech/vehicle armor by hit location. Example: `[Unit:Atlas|Armor CT22/RT18/LT18]`
- `[CAMPAIGN]` / `[/CAMPAIGN]` --- Record warband or force state between sessions. Example: `[CAMPAIGN] ... [/CAMPAIGN]`

#strong[No new core symbols.] Unit activations use `@(Unit Name)` --- the established actor attribution convention. This add-on introduces no additions to `@`, `?`, `d:`, `->`, or `=>`.

#pagebreak()
=== Design Principles
<design-principles>
#strong[Units, not individuals.] A unit tag tracks aggregate state --- model count, morale, status --- not individual wounds. When a unit of twelve soldiers takes casualties, update the count. Individuals matter only when they have names and mechanical distinctions: a named hero, a mech pilot, a warband captain.

#strong[Scale to complexity.] A two-unit skirmish needs less notation than a six-turn battle with eight units per side. Use only as much structure as the scenario demands. The `[BATTLE]` block is optional for quick engagements; the `[CAMPAIGN]` block is optional if you are playing a one-off.

#strong[Campaigns as persistent state.] A wargame campaign is a series of battles connected by consequence. The `[CAMPAIGN]` block at the start and end of each session captures what has changed --- casualties replaced, heroes advanced, treasure spent --- so the next session begins with accurate state, not reconstructed state.

#strong[Activation follows action.] Unit activations are actions. They use `@(Unit Name)` exactly as the Combat Add-on uses it for enemy actors in personal-scale fights. There is no new activation symbol; the question of #emph[who acts] is the prefix, and the question of #emph[what happens] follows from `d:`, `->`, and `=>` as normal.

#pagebreak()
== Part I: Practical Reference
<part-i-practical-reference>
=== How a wargame session fits into a log
<how-a-wargame-session-fits-into-a-log>
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

#pagebreak()
=== The building blocks at a glance
<the-building-blocks-at-a-glance>
#strong[Activating a unit --- player's force:]

```
@ Advance the Rifles to the hedgerow
=> [Unit:Rifles|×12|pos:at hedgerow|status:Fresh]
```

#strong[Activating a unit --- opponent's force:]

```
@(Raider Cavalry) Charge the Rifles' left flank
d: Charge 2d6+2=11 vs TN 9 -> Hit
=> [Unit:Rifles|×10|status:wavering] [Unit:Raider Cavalry|×5|status:Engaged]
```

#strong[Morale test:]

```
d: Morale Rifles 2d6=8 vs Morale 8 -> Steady
```

#strong[Casualty update:]

```
=> [Unit:Rifles|×10|status:wavering]
```

#strong[Turn with phase annotations:]

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

#pagebreak()
== 1. Battle Structure
<battle-structure>
=== The `[BATTLE]` block
<the-battle-block>
The `[BATTLE]` block delimits a wargame engagement within a scene. It signals a shift into denser notation: unit tags, turn markers, activation logs. It is optional for quick fights but recommended whenever a battle runs more than two turns or involves more than two units per side.

#strong[Format:]

```
[BATTLE]
[contents]
[/BATTLE]
```

#strong[What goes inside a `[BATTLE]` block:]

- Scenario line (objectives, turn limit, special rules)
- Force snapshots: `[Force:]` tags if tracking overall forces
- Unit opening states: all units with their entering status
- Turn sequences: `Tn#` markers, activations, rolls, consequences, tag updates
- Mid-battle state snapshots where useful

#strong[Opening snapshot --- minimal:]

```
[BATTLE]
[Scenario:Raid|goal:Grab the loot|turns 5]
[Unit:Warband|×8|Morale 6|status:Fresh]
[Unit:Defenders|×6|Morale 7|status:Fresh]
```

#strong[Opening snapshot --- expanded:]

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

#strong[When to close a block:] At the end of the engagement, when the scenario has resolved (objectives met, one side routed, turn limit reached). Close before writing the post-battle consequence.

#strong[Analog format:]

```
--- BATTLE ---
[contents]
--- END BATTLE ---
```

=== `Tn#` turn markers
<tn-turn-markers>
`Tn#` marks army-scale game turns within a battle. It is explicitly distinct from the Combat Add-on's `Rd#` initiative rounds.

#strong[`Rd#` vs `Tn#`:]

#table(
  columns: (25%, 25%, 21.88%, 28.12%),
  align: (auto,auto,auto,auto,),
  table.header([Marker], [Add-on], [Scale], [Duration],),
  table.hline(),
  [`Rd#`], [Combat], [Personal (individual initiative)], [\~6 seconds game-time],
  [`Tn#`], [Wargaming], [Unit (activation turn)], [Minutes to an hour game-time],
)
Both can appear in the same log if a wargame session includes a personal-scale duel (see Cross-Add-on Interactions).

#strong[Phase annotations (optional):]

Many wargame systems divide turns into phases. Annotate with a suffix when the system makes phase order meaningful:

```
Tn2 Move:
Tn2 Shoot:
Tn2 Combat:
Tn2 Morale:
```

Leave phases unannotated when activation is free-form or the system does not separate phases.

#strong[Turn counter example:]

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

#pagebreak()
== 2. Unit Tracking
<unit-tracking>
The `[Unit:]` tag is the core of this add-on. It records the mechanical state of a military unit --- not a named individual, but a group acting as a single mechanical entity.

#strong[Format:]

```
[Unit:Name|×N|stats|pos:position|status:state]
```

#strong[Fields] --- in any order. Each one says what it is, so you can skip any of them:

- `Name` --- unit identifier (regiment name, unit type, or custom label)
- `×N` --- model count. For an abstract size, use the `size:` category: `size:full`, `size:half`, `size:depleted`
- stats --- labelled numbers: `Morale 7`, `WS3`, `Move 6`
- `pos:` --- optional terrain reference: `pos:at hedge`, `pos:road>ridge`, `pos:C4`
- `status:` --- current state (see status vocabulary below)

`size:`, `pos:` and `status:` are categories, so writing a new one replaces the old (core §4.1). A count, likewise, is replaced by a new count. Other values, such as skills, accumulate.

#strong[Examples:]

```
[Unit:Ironclad Rifles|×12|Morale 8|status:Fresh]
[Unit:Skeleton Warriors|×8|Morale 4|status:Fresh|pos:at bridge]
[Unit:Cavalry Screen|×6|Morale 7|pos:at ridge|status:Engaged]
[Unit:Artillery Battery|×4|Morale 6|pos:rear|status:Pinned]
```

=== Status vocabulary
<status-vocabulary>
#table(
  columns: (47.06%, 52.94%),
  align: (auto,auto,),
  table.header([Status], [Meaning],),
  table.hline(),
  [`Fresh`], [At full effectiveness, no stress],
  [`Steady`], [Tested and holding; no mechanical penalty unless system specifies],
  [`Wavering`], [Morale threatened; one failed test from breaking],
  [`Broken`], [Failed morale; withdrawing or fleeing],
  [`Routed`], [Fully fled the field; removed from play],
  [`Rallied`], [Recovered from Broken; back in play but may have reduced stats],
  [`Pinned`], [Cannot advance; may still shoot],
  [`Engaged`], [In melee contact with enemy unit],
  [`Exhausted`], [Moved and fought; no further actions this turn],
)
These are defaults, written as `status:Fresh`, `status:Wavering` and so on. Your system may use different terms --- substitute freely. Conditions that can stack, like `fleeing` or `stunned`, stay plain values.

=== Tracking casualties
<tracking-casualties>
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

#strong[Abstract size] (when counting individual models is not the point):

```
[Unit:Orc Mob|size:full|Morale 5|status:Fresh]
=> [Unit:Orc Mob|size:half|status:wavering]
=> [Unit:Orc Mob|size:depleted|status:broken]
```

=== Formation states
<formation-states>
Systems that track unit formation use a `formation:` category, so a new formation replaces the old one:

```
[Unit:Pikes|×16|Morale 7|formation:Line|status:Fresh]
[Unit:Muskets|×12|Morale 6|formation:Column|status:Marching]

@ Form square against cavalry
=> [Unit:Muskets|×12|Morale 6|formation:Square|status:Fresh]
```

Common formation labels: `Line`, `Column`, `Square`, `Skirmish`, `Wedge`, `Dispersed`.

=== The `[Force:]` tag
<the-force-tag>
`[Force:]` is optional. Use it when you want to record the overall composition and objective of a named force --- especially in campaigns where force identity persists across sessions.

#strong[Format:]

```
[Force:Name|leader:name|units N|goal:objective]
```

#strong[Fields] --- in any order, all optional except the name:

- `Name` --- force or army name
- `leader:` --- named leader, if any
- strength --- a labelled number (`units 3`, `mechs 4`, `figures 6`), or a state such as `status:reduced`
- `goal:` --- what this force is trying to accomplish in this battle

#strong[Examples:]

```
[Force:Ironclad Company|leader:Colonel Vane|units 3|goal:Hold the bridge]
[Force:Jade Falcon Scout Lance|leader:Mechwarrior Roshak|mechs 4|goal:Intercept]
```

Leave `[Force:]` out entirely for one-off scenarios with no campaign context.

#pagebreak()
== 3. Scenario Setup
<scenario-setup>
Scenarios give battles their stakes and structure: objectives, turn limits, deployment conditions, and special rules. Record these at the opening of the `[BATTLE]` block.

#strong[Format:]

```
[Scenario:Name|goal:objective|turns N|rule:special rules]
```

#strong[Fields:]

- `Name` --- scenario title or identifier
- `goal:` --- victory condition
- `turns N` --- turn limit, if applicable
- `rule:` --- weather, night, terrain effects, or other modifiers (optional; one `rule:` per modifier)

Fields can come in any order.

#strong[Examples --- minimal:]

```
[Scenario:Breakthrough|goal:Exit 2+ units south|turns 10]
[Scenario:Wyrdstone Hunt|goal:Collect 3 shards|turns 6]
[Scenario:Last Stand|goal:Survive 5 turns|turns 5]
```

#strong[Examples --- expanded:]

```
[Scenario:Raid on the Mill
  | goal: Destroy the mill (requires 1 turn adjacent) OR steal 2+ supply crates
  | turns 7
  | rule: Night fight, shooting -1 TN beyond 12"
  | rule: Reinforcements, defender rolls d6 each turn, arrive on 6+
]
```

#strong[Recording victory and defeat:]

The scenario outcome goes in the `=>` line after `[/BATTLE]`:

```
[/BATTLE]
=> Victory: 2 shards collected, warband withdrew intact.
=> [Thread:Campaign for the Merchant Quarter|Advantage: Reiklanders]
```

#pagebreak()
== 4. Campaign Tracking
<campaign-tracking>
A wargame campaign is the story that connects battles. Between sessions, warbands grow (or shrink), heroes advance (or suffer lasting injuries), and forces repair, reinforce, or consolidate. The `[CAMPAIGN]` block captures this state.

=== The `[CAMPAIGN]` block
<the-campaign-block>
Use `[CAMPAIGN]` blocks at session boundaries --- once at the start of a session to establish entering state, and once at the end to record what changed.

#strong[Format:]

```
[CAMPAIGN]
[contents]
[/CAMPAIGN]
```

#strong[What goes inside:]

- `[Force:]` tags for named forces
- `[Unit:]` tags for units with experience or persistent state
- `[N:]` or `[PC:]` tags for named heroes, leaders, or pilots
- `[Wealth:]` for treasury, named after the force: `[Wealth:Reiklanders|Gold 50gc]` (delegates to Resource Tracking Add-on)
- Post-battle rolls and their results (injury tables, experience gains, reinforcement rolls)

#strong[Analog format:]

```
--- CAMPAIGN ---
[contents]
--- END CAMPAIGN ---
```

=== Warband progression (skirmish scale)
<warband-progression-skirmish-scale>
For games like Mordheim, Frostgrave, or Rangers of Shadow Deep, the warband is the persistent entity. Named heroes are `[N:]` or `[PC:]` tags; unnamed units are `[Unit:]` tags.

#strong[Entering state at session start:]

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

#strong[Post-battle update:]

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

#strong[Permanent injuries] use the `[N:]` tag's free fields:

```
[N:Captain Streng|Old Battle Wound|-1 WS|8 XP]
[N:Sergeant Voss|Lost Eye|Shooting -1|2 XP]
```

#strong[Hired swords and specialists] use `[Unit:]` with a count of `×1`:

```
[Unit:Dwarf Troll Slayer|×1|Exp 3|Fearless|status:Fresh]
```

=== Force progression (larger scale)
<force-progression-larger-scale>
For campaign wargames at company scale or above, units accumulate experience, take losses, and require reinforcement or repair.

#strong[Opening state:]

```
[CAMPAIGN]
[Force:Wolf's Dragoons Alpha Lance|leader:Major Natasha|mechs 4|status:Full strength]
[Unit:Atlas AS7-D|Pilot: Natasha|Armor CT30/RT25/LT25|Heat 0|status:Fresh]
[Unit:Marauder MAD-3R|Pilot: Kell|Armor CT22/RT18/LT18|Heat 0|status:Fresh]
[Unit:Wolverine WVR-6R|Pilot: Torres|Armor CT16/RT14/LT14|Heat 0|status:Fresh]
[Unit:Jenner JR7-D|Pilot: Minh|Armor CT10/RT8/LT8|Heat 0|status:Fresh]
[/CAMPAIGN]
```

#strong[Post-battle repair and status:]

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

#pagebreak()
== 5. Vehicles and Mechs
<vehicles-and-mechs>
Vehicle and mech systems track armor, damage, and in many systems heat --- none of which map cleanly to a hit point count. This section adapts the `[Unit:]` tag for that purpose.

=== Location-based armor
<location-based-armor>
For systems that track armor by hit location (Battletech, many historical naval games), use the `[Unit:]` tag with a dedicated `Armor` field listing locations in order:

#strong[Battletech location abbreviations:]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Code], [Location],),
  table.hline(),
  [`CT`], [Center Torso],
  [`RT`], [Right Torso],
  [`LT`], [Left Torso],
  [`RA`], [Right Arm],
  [`LA`], [Left Arm],
  [`RL`], [Right Leg],
  [`LL`], [Left Leg],
  [`HD`], [Head],
)
#strong[Format:]

```
[Unit:Name|Armor CT#/RT#/LT#/RA#/LA#/RL#/LL#|Heat 0|status:state]
```

#strong[Examples:]

```
[Unit:Atlas AS7-D|Armor CT30/RT25/LT25/RA20/LA20/RL28/LL28|Heat 0|status:Fresh]
[Unit:Summoner Prime|Armor CT22/RT18/LT18/RA16/LA16/RL20/LL20|Heat 0|status:Fresh]
[Unit:Jenner JR7-D|Armor CT10/RT8/LT8/RA4/LA4/RL10/LL10|Heat 0|status:Fresh]
```

You do not need to list all locations if your session only tracks a subset. List what matters for your system. (The armor values in this add-on's examples are illustrative, not taken from record sheets.)

=== Damage notation
<damage-notation>
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

=== Heat tracking
<heat-tracking>
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

#strong[Heat effects] come from your system's heat scale; look them up there rather than in the log. Record the effect that applies as a status:

```
=> [Unit:Summoner|Heat 18|status:shutdown risk]
d: Shutdown avoid 2d6=5 vs 6 -> Fail
=> [Unit:Summoner|status:shutdown]
```

=== Simplified vehicle tracking
<simplified-vehicle-tracking>
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

#pagebreak()
== Cross-Add-on Interactions
<cross-add-on-interactions>
This add-on is standalone, but it works naturally alongside three other add-ons.

=== With the Combat Add-on
<with-the-combat-add-on>
Some wargames include personal-scale duels within a unit-scale battle --- Mordheim heroes breaking away from their warbands to fight a named opponent, or a Battletech pilot ejecting and continuing the fight on foot. In those cases, use both add-ons in the same session.

#strong[Key distinction:] `Tn#` markers for unit-scale turns, `Rd#` markers for personal-scale rounds. Both can appear in the same log.

#table(
  columns: (68.75%, 31.25%),
  align: (auto,auto,),
  table.header([Situation], [Use],),
  table.hline(),
  [Unit activation, morale, casualties], [Wargaming Add-on (`Tn#`, `[Unit:]`)],
  [Named hero's personal duel], [Combat Add-on (`Rd#`, `[F:]`)],
)
#strong[Combined example --- Mordheim duel within a battle:]

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

=== With the Resource Tracking Add-on
<with-the-resource-tracking-add-on>
Use the Resource Tracking Add-on for treasury, supplies, and ammunition --- anything that flows in and out across sessions.

- Warband treasury --- `[Wealth:Warband|Gold 45gc]`
- Campaign supplies --- `[Inv:Rations — 8]`
- Ammo for special weapons --- `[Inv:Blackpowder — 3]`
- Repair parts (Battletech) --- `[Inv:CT Armor Pack — 2]`

=== With the Dungeon Crawling Add-on
<with-the-dungeon-crawling-add-on>
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

#pagebreak()
== System Adaptations
<system-adaptations>
=== Mordheim
<mordheim>
Mordheim uses a small warband (\~10--15 models) in skirmish scenarios through a ruined city. Heroes are individually tracked; units are small groups (2--5 identical warriors). The campaign is the main draw: every battle's outcome affects the warband through the serious injury table, experience advances, and exploration.

#strong[Key mappings:]

- Hero --- `[N:Name|WS|BS|S|T|W|I|A|Ld|skills|XP]`
- Henchman group --- `[Unit:Name|×N|Exp N|status:state]`
- Warband --- `[Force:Name|leader:name|units N|status:state]`
- Scenario --- `[Scenario:Name|goal:objective|turns N|rule:special rules]`
- Serious injury --- `tbl: Serious Injury d66=…`, result in the `[N:]` tag
- Exploration --- `tbl: Exploration Nd6=…` (one die per surviving hero), shards sold into `[Wealth:]`
- Advance --- `tbl: Advance 2d6=…`, result in the `[N:]` or `[Unit:]` tag
- Shooting, combat --- `d: Hit d6=… vs 4+`, then `d: Wound d6=… vs 4+`, then `d: Injury d6=…`

#strong[Example --- full Mordheim session:]

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

#pagebreak()
=== Battletech
<battletech>
Battletech tracks individual mechs, each with location-based armor, internal structure, heat, and a pilot. Battles are typically at lance scale (4 mechs), with turns divided into Movement, Weapons, and Heat phases.

#strong[Key mappings:]

- Mech --- `[Unit:Name|Armor CT#/.../LL#|Heat 0|status:state]`
- Pilot --- `[N:Name|Piloting #|Gunnery #|status:state]`
- Lance --- `[Force:Name|leader:name|mechs 4|goal:mission]`
- Initiative --- `d: Initiative 2d6=N vs 2d6=N -> winner`
- Weapon attack --- `d: Gunnery 2d6=N vs TN N -> Hit`, then `tbl: Location 2d6=N -> location`
- Piloting skill roll --- `d: Piloting 2d6=N vs TN N -> Success`
- Heat phase --- Update `Heat N` field after each turn

#strong[Example --- lance engagement:]

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

#pagebreak()
=== Frostgrave
<frostgrave>
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

#pagebreak()
== Best Practices
<best-practices>
#strong[Do: Use `[BATTLE]` for any multi-turn engagement]

```
✔ [BATTLE]
  [Scenario:Raid|goal:Escape with the chest|turns 5]
  [Unit:Warband|×8|Morale 6|status:Fresh]
  Tn1 ...
  [/BATTLE]
```

#strong[Don't: Open a battle block for a single-roll resolution]

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

#pagebreak()
#strong[Do: Update unit tags inline as state changes]

```
✔ d: Shooting 2d6=8 vs TN 7 -> Hit
  => [Unit:Raiders|×10|status:wavering]
  d: Morale 2d6=9 vs Morale 6 -> Broken
  => [Unit:Raiders|×10|status:broken|fleeing]
```

#strong[Don't: Track individual model hit points in a unit tag]

```
✗ [Unit:Raiders|Model1:HP3,Model2:HP2,Model3:HP1,Model4:HP3...]
```

```
✔ [Unit:Raiders|×4|size:half strength|status:Steady]
```

#pagebreak()
#strong[Do: Use the Combat Add-on for personal-scale duels within a battle]

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

#strong[Don't: Use `Rd#` for unit-scale turns]

```
✗ Rd1
  @(Infantry) Advance to ford
```

```
✔ Tn1
  @(Infantry) Advance to ford
```

#pagebreak()
#strong[Do: Delegate financial tracking to the Resource Tracking Add-on]

```
✔ [Wealth:Warband|Gold 50gc]
  tbl: Income 2d6=9 -> 9gc
  [Wealth:Warband|Gold+9gc]
```

#strong[Don't: Invent a new wealth tag when one already exists]

```
✗ [Treasury:50gc]
```

#pagebreak()
#strong[Do: Use `[CAMPAIGN]` blocks at session boundaries]

```
✔ [CAMPAIGN]
  [Force:Warband|state before battle]
  [/CAMPAIGN]

  [BATTLE] ... [/BATTLE]

  [CAMPAIGN]
  [Force:Warband|state after battle]
  [/CAMPAIGN]
```

#strong[Don't: Skip campaign state tracking and reconstruct it from memory next session]

#pagebreak()
== Quick Reference
<quick-reference>
=== New Tags
<new-tags>
- `[Unit:Name|×N|stats|status:state]` --- Military unit state. Example: `[Unit:Rifles|×12|Morale 8|status:Fresh]`
- `[#Unit:Name]` --- Reference to established unit. Example: `[#Unit:Rifles]`
- `[Force:Name|leader:name|units N|goal:objective]` --- Overall force summary (optional). Example: `[Force:Alpha Lance|leader:Natasha|mechs 4|goal:Breakthrough]`

=== `[Unit:]` Fields
<unit-fields>
#table(
  columns: 3,
  align: (auto,auto,auto,),
  table.header([Field], [Format], [Example],),
  table.hline(),
  [Size (count)], [`×N`], [`×12`],
  [Size (abstract)], [`full` / `half` / `depleted`], [`half`],
  [Morale], [`Morale N`], [`Morale 7`],
  [Armor (single)], [`Armor N`], [`Armor 14`],
  [Armor (locations)], [`Armor CT#/RT#/LT#/...`], [`Armor CT22/RT18/LT18`],
  [Heat (Battletech)], [`Heat N`], [`Heat 5`],
  [Experience], [`Exp N`], [`Exp 3`],
  [Position], [Named terrain or grid], [`at hedge` / `C4`],
  [Formation], [Label], [`Line` / `Square` / `Column`],
  [Status], [See vocabulary], [`Fresh` / `Broken`],
)
=== Unit Status Vocabulary
<unit-status-vocabulary>
#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Status], [Meaning],),
  table.hline(),
  [`Fresh`], [Full effectiveness],
  [`Steady`], [Tested and holding],
  [`Wavering`], [One failed test from breaking],
  [`Broken`], [Failed morale, withdrawing],
  [`Routed`], [Fled the field],
  [`Rallied`], [Recovered from broken],
  [`Pinned`], [Cannot advance],
  [`Engaged`], [In melee contact],
  [`Exhausted`], [No further actions this turn],
)
=== Structural Blocks
<structural-blocks>
#table(
  columns: 3,
  align: (auto,auto,auto,),
  table.header([Block], [Opens when], [Closes when],),
  table.hline(),
  [`[BATTLE]`], [Battle begins], [Scenario resolves],
  [`[CAMPAIGN]`], [At session start or end], [After state is recorded],
)
#strong[Analog equivalents:] `--- BATTLE ---` / `--- END BATTLE ---`, `--- CAMPAIGN ---` / `--- END CAMPAIGN ---`

=== Turn Markers
<turn-markers>
#table(
  columns: 3,
  align: (auto,auto,auto,),
  table.header([Marker], [Add-on], [Scale],),
  table.hline(),
  [`Tn#`], [Wargaming], [Unit-scale game turns],
  [`Rd#`], [Combat], [Personal-scale initiative rounds],
)
=== Battletech Location Codes
<battletech-location-codes>
`CT` `RT` `LT` `RA` `LA` `RL` `LL` `HD`

=== Complete Example
<complete-example>
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

#pagebreak()
== FAQ
<faq>
#strong[Q: When should I use this add-on instead of the Combat Add-on?] \
A: Use the Combat Add-on for personal-scale fights --- one character vs.~one or a few named opponents, tracked hit point by hit point, initiative round by round. Use this add-on when the unit is the mechanical atom: when you track model counts rather than individual HP, when turns represent minutes rather than seconds, when scenario objectives drive the action. For games that mix both (Mordheim, warcrawl RPGs), use both add-ons in the same session.

#strong[Q: Can I use `Rd#` for my wargame turns instead of `Tn#`?] \
A: You can, but it creates confusion if you ever mix wargaming notation with the Combat Add-on in the same log. `Rd#` has a specific meaning (personal-scale initiative round) in the established Lonelog ecosystem. `Tn#` reserves a distinct identity for unit-scale game turns.

#strong[Q: My system doesn't have morale --- do I need status vocabulary?] \
A: No.~Status fields are optional. If your system doesn't track morale or unit condition, simply omit those fields from `[Unit:]` tags. `[Unit:Rifles|×12|status:Fresh]` is perfectly valid notation.

#strong[Q: How do I handle random scenario events --- traps triggering, weather changing, reinforcements arriving?] \
A: Use `d:` for a roll that decides whether something happens, `tbl:` for a roll that decides what arrives, and `=>` for the consequence. For events that simply occur without a roll, write them in prose or as a meta note: `(note: Skaven Rat Ogre arrives turn 3)`. If you play with a GM or an umpire, Partylog's `!` symbol records GM and world events: `! Reinforcements arrive on the east road`.

#strong[Q: How do I track a large battle with 20+ units per side?] \
A: Focus your log on the units that matter most --- the ones that have consequential moments, pass or fail critical morale tests, or carry the objective. Units that do nothing interesting in a turn don't need an entry. The log is a record of the meaningful, not a transcript of every activation.

#strong[Q: How does this work in an analog notebook?] \
A: Use `--- BATTLE ---` / `--- END BATTLE ---` and `--- CAMPAIGN ---` / `--- END CAMPAIGN ---` instead of the bracket blocks. Tag syntax is identical. Turn markers (`Tn1`, `Tn2`) work as headings or margin notes. For mech armor, a small grid in the margin is faster than writing out all location values.

#strong[Q: Can I use this add-on without any campaign tracking?] \
A: Yes. For a one-off scenario with no campaign consequence, skip `[CAMPAIGN]` blocks entirely and use just `[BATTLE]`, unit tags, and turn markers. The campaign elements are completely optional.

#strong[Q: Do I need `[Force:]` tags?] \
A: Only if force identity is meaningful to you --- usually in campaigns where force composition persists or you want to record who commanded what. For single-session battles, just list the units directly without a force wrapper.

#pagebreak()
== Credits & License
<credits-license>
© 2026 Roberto Bisceglie

This add-on extends #link("https://zeruhur.itch.io/lonelog")[Lonelog] by Roberto Bisceglie.

The Solo Wargaming Add-on was prompted by community requests to support Battletech and Mordheim session logging. The Combat Add-on's explicit note that "mass battles, vehicle combat, and chase scenes may warrant their own add-ons" provided the design mandate.

#strong[Version History:]

- v1.1.0: Corrected the BattleTech, Mordheim and Frostgrave examples (weapon damage and heat, d66 injuries, 2d6 advances, exploration, d20 rolls); armor values marked illustrative; the heat table replaced by a pointer to your system's heat scale. Aligned with Lonelog v1.7: campaign and hit-location rolls that give content use `tbl:`; tag changes use `old>new`; unit sizes are `×N` values, never part of the name; treasury changes are written as changes (`Gold+7gc`). World events: Partylog's `!` for GM-run games.
- v1.0.0: Initial release

This work is licensed under the #strong[Creative Commons Attribution-ShareAlike 4.0 International License];.

You are free to share and adapt this material, provided you give appropriate credit and distribute adaptations under the same license. Session logs and play records created using this add-on's notation are your own work and are not subject to this license.
