# itch.io project pages

The text of the itch.io project pages on the [lonelog account](https://lonelog.itch.io), one file per project. butler (`.github/workflows/release.yml`) pushes only the downloads. Page text has no API, so it's kept here and pasted into itch.io by hand.

| File | Project |
|---|---|
| `lonelog.md` | [lonelog.itch.io/lonelog](https://lonelog.itch.io/lonelog) |
| `partylog.md` | [lonelog.itch.io/partylog](https://lonelog.itch.io/partylog) |
| `lonelog-combat-addon.md` | [lonelog.itch.io/lonelog-combat-addon](https://lonelog.itch.io/lonelog-combat-addon) |
| `lonelog-dungeon-crawling-addon.md` | [lonelog.itch.io/lonelog-dungeon-crawling-addon](https://lonelog.itch.io/lonelog-dungeon-crawling-addon) |
| `lonelog-resource-tracking-addon.md` | [lonelog.itch.io/lonelog-resource-tracking-addon](https://lonelog.itch.io/lonelog-resource-tracking-addon) |
| `lonelog-dice-notation-addon.md` | [lonelog.itch.io/lonelog-dice-notation-addon](https://lonelog.itch.io/lonelog-dice-notation-addon) |
| `lonelog-cards-addon.md` | [lonelog.itch.io/lonelog-cards-addon](https://lonelog.itch.io/lonelog-cards-addon) |
| `lonelog-wargaming-addon.md` | [lonelog.itch.io/lonelog-wargaming-addon](https://lonelog.itch.io/lonelog-wargaming-addon) |

## Updating a page

1. Edit the file here and commit it.
2. Open the file on GitHub, so it shows rendered, and copy the body (everything below the front matter table).
3. On itch.io, open the project's **Edit** page, paste it into **Description**, and put `tagline` in **Short description or tagline**. Save.

Copying the rendered view keeps bold, lists, links and headings. Don't paste the raw Markdown: the itch.io editor doesn't convert it.

## Front matter

- `title`: the project title on itch.io
- `tagline`: the short description shown in listings and link previews
- `url`: the project page

These files are not part of the website: `_quarto.yml` doesn't render `itch/`.
