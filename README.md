# Los XV de Ashley

An interactive quinceañera invitation for **Ashley Camila Valdez**, Friday
30 October 2026 at LUXOR Wedding & Event.

Guests land on a sealed envelope and click the wax seal to open it — the seal
breaks, the flap lifts, and the letter rises out before the invitation itself
takes over. Behind that gate is a single page with a countdown, the
itinerary, the court of honor, venue and dress-code details, a gift registry,
and RSVP with a live wishes wall. Fully bilingual (Spanish / English) with a
language toggle that remembers the guest's choice.

The design is a committed single visual world — deep navy and brushed
silver, Pinyon Script for the name, Cinzel for engraved headings, Cormorant
Garamond for body copy — so it reads the same on any device or host theme.

### Colour

Two groups of tokens at the top of the stylesheet carry the whole design.

**The metal** is `--metal`, `--metal-2` and `--foil`. Named for the role rather
than the colour, so changing the page to gold or rose gold is an edit to those
three values (plus the seal's own gradient in `.seal-btn`).

**The ground** is `--midnight`, `--midnight-2`, `--surface` and `--plum`, plus
eight translucent derivatives (`--veil`, `--field`, `--panel-top`,
`--panel-bot`, `--panel-flat`, `--bloom`, `--bloom-soft`, `--bloom-cool`). No
dark value is written anywhere else: form fields, the RSVP card, countdown
cells, the language switch, the music button, wish cards and the whole envelope
all resolve through these, so changing the background means editing this block
and nothing else.

`:root` also declares `color-scheme: dark`, without which native controls —
radio dots, number spinners, scrollbars — render as pale chrome on the dark
page.

## Files

| Path | What it is |
| --- | --- |
| `src/page.html` | **The source of truth.** Edit this file. |
| `index.html` | Generated. A complete HTML5 document for static hosting. |
| `scripts/build.sh` | Wraps `src/page.html` into `index.html`. |
| `audio/` | Drop `song.mp3` here to give the page background music. |

After editing `src/page.html`, run:

```bash
./scripts/build.sh
```

## Making it yours

Everything about the event lives in one `CONFIG` object near the top of the
`<script>` block in `src/page.html`. Nothing else needs editing:

- `firstName`, `lastName`, `initials` — the initials appear on the envelope's
  wax seal and in the monogram at the top of the invitation
- `massTime`, `partyTime`, `rsvpBy` — local time, `YYYY-MM-DDTHH:MM:SS`
- `parents`, `godparents`
- `mass`, `party` — name and address; map links are generated from these.
  `mass: null` (with `massTime: null`) hides the church section everywhere.
  There is no Mass for this celebration, so it stays off; giving both a value
  switches it back on if that ever changes.
- `parents`, `godparents` — lists of names, joined with "y" or "and" to match
  the language. An empty list drops that line entirely.
- `dress` — `es`/`en` for the headline rule, plus `avoid` (a list of colors
  rendered as crossed-out swatches), `court` (a plain swatch showing what the
  court wears), and an optional `note` line under them
- `registry` — an array of `{ label, url }`; leave it empty to show only the
  lluvia de sobres
- `court.damas`, `court.chambelanes` — plain strings, or
  `{ name: "...", honor: true }` to mark the dama/chambelán de honor. While both
  lists are empty the section shows a "to be announced" note instead. When only
  one of the two lists has names, the group headings are dropped — the section
  title already names the group — and the count subtitle is omitted
- `itinerary` — each entry has `time`, `es`, `en`, and optional `noteEs`/`noteEn`
- `whatsapp`, `email` — used by the fallback RSVP mode below
- `hashtag`
- `music` — `src` points at the song (`audio/song.mp3`); `""` removes the
  player. `title` is an optional label, `volume` is 0–1. See `audio/README.md`.

Two things outside `CONFIG` are worth updating too:

- the `<title>` on line 1 (it names the page in the browser tab and gallery)
- the invitation verse and other prose, in the `T` translation table — the
  Spanish and English copy sit side by side there

## Still to fill in

The page renders cleanly with these blank, but they are the open items:

- **Times.** The reception is set to 6:00 pm and the rest of the itinerary
  follows from it. Every time in `CONFIG.itinerary` is a placeholder.
- **Registry.** `registry` is empty, so only the lluvia de sobres shows.
- **The song.** `audio/song.mp3` does not exist yet, so no player appears.

## Music

A browser will not play sound until the visitor interacts with the page, so the
song starts on the click that opens the envelope — the one gesture every guest
makes. It loops at half volume and fades in over about a second.

A control sits in the bottom-right corner to pause and resume. If a guest
pauses it, that choice is remembered on their device and the song does not
start itself again on a later visit.

The player hides itself when `music.src` is empty or the file is missing or
unplayable, so a missing song never breaks the page.

## How RSVP works

The page picks its RSVP mode at load time and tells the guest which one is
active:

**Saved mode** — when the page runs as a Claude Artifact, it stores replies
itself. Each guest's reply is written to the `rsvps` collection; the page shows
a running count of confirmed guests and a wishes wall built from the messages
guests leave. A guest who already replied on that device sees their answer
filled in and can edit it.

**Send mode** — anywhere else (GitHub Pages, a local file, any static host),
there is no storage available. Submitting composes the guest's reply into one
message and then asks how they want to send it, because not every guest uses
WhatsApp:

| Option | Goes to | Works on |
| --- | --- | --- |
| WhatsApp | `wa.me` link | phones and desktop with WhatsApp |
| Text message | `sms:` link, prefilled | any phone |
| Email | `mailto:` link | anywhere, if `email` is set |
| Copy message | clipboard | anywhere, paste into any app |

The host's number is also shown as a `tel:` link for guests who would rather
call. Nothing is sent until the guest picks one, and the panel says so. The
wishes wall stays empty in this mode.

No code change is needed to switch between them; the same file does both.

## Hosting it

**GitHub Pages** — in repository Settings → Pages, serve from the branch root.
`index.html` is committed and ready. This is the right choice for a real guest
list: anyone with the link can open it, and RSVP runs in WhatsApp mode.

**Claude Artifact** — publish `src/page.html` with the `db` capability to get
saved RSVPs and the live wishes wall. Note that an artifact using storage is
organization-internal: only signed-in members of your organization can open it,
so it suits a private preview or an internal guest list rather than a public
invitation link.

To read the guest list back from a published artifact, query the `rsvps`
collection. Each document holds `name`, `attending` (`"si"` / `"no"`), `guests`,
`song`, `message`, `lang`, and `createdAt`.

## Notes

- Fonts load from Google Fonts. If a guest is offline the page falls back to
  Georgia and Palatino stacks and still reads correctly.
- Map embeds are not used — an embedded map iframe is blocked in the artifact
  sandbox — so the venue sections link out to Google Maps, Apple Maps and Waze.
- The gold-dust background, the rotating monogram and the envelope-opening
  sequence all respect `prefers-reduced-motion` — with it on, the envelope
  opens instantly rather than animating.
- The envelope's layers are stacked with `translateZ` rather than `z-index`:
  inside a `transform-style: preserve-3d` context the browser sorts by real
  depth, and `z-index` alone lets the letter and the envelope front intersect.
