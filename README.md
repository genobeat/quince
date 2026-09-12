# Los XV de Ashley

An interactive quinceañera invitation for **Ashley Camila Valdez**, Friday
30 October 2026 at LUXOR Wedding & Event.

Guests land on a sealed envelope and click the wax seal to open it — the seal
breaks, the flap lifts, and the letter rises out before the invitation itself
takes over. Behind that gate is a single page with a countdown, the
itinerary, the court of honor, venue and dress-code details, a gift registry,
and RSVP with a live wishes wall. Fully bilingual (Spanish / English) with a
language toggle that remembers the guest's choice.

The design is a committed single visual world — midnight navy and foil gold,
Pinyon Script for the name, Cinzel for engraved headings, Cormorant Garamond
for body copy — so it reads the same on any device or host theme.

## Files

| Path | What it is |
| --- | --- |
| `src/page.html` | **The source of truth.** Edit this file. |
| `index.html` | Generated. A complete HTML5 document for static hosting. |
| `scripts/build.sh` | Wraps `src/page.html` into `index.html`. |

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
  `mass: null` (with `massTime: null`) hides the church section everywhere —
  that is the current setting, since only the one venue is confirmed. Give both
  a value to switch the Mass back on.
- `parents`, `godparents` — leave either empty and its line is omitted
- `dress` — separate `es` / `en` strings
- `registry` — an array of `{ label, url }`; leave it empty to show only the
  lluvia de sobres
- `court.damas`, `court.chambelanes` — plain strings, or
  `{ name: "...", honor: true }` to mark the dama/chambelán de honor. While both
  lists are empty the section shows a "to be announced" note instead, which is
  the current state
- `itinerary` — each entry has `time`, `es`, `en`, and optional `noteEs`/`noteEn`
- `whatsapp`, `email` — used by the fallback RSVP mode below
- `hashtag`

Two things outside `CONFIG` are worth updating too:

- the `<title>` on line 1 (it names the page in the browser tab and gallery)
- the invitation verse and other prose, in the `T` translation table — the
  Spanish and English copy sit side by side there

## Still to fill in

The page renders cleanly with these blank, but they are the open items:

- **Times.** The reception is set to 6:00 pm and the rest of the itinerary
  follows from it. Every time in `CONFIG.itinerary` is a placeholder.
- **Venue address.** `party.address` is empty, so the map links search on the
  venue name alone. Adding the street address makes them exact.
- **The court.** `court.damas` and `court.chambelanes`.
- **Hosts.** `parents` and `godparents`.
- **Registry.** `registry` is empty, so only the lluvia de sobres shows.
- **RSVP contact.** `whatsapp` and `email` are still the sample values, and the
  WhatsApp fallback needs a real number.

## How RSVP works

The page picks its RSVP mode at load time and tells the guest which one is
active:

**Saved mode** — when the page runs as a Claude Artifact, it stores replies
itself. Each guest's reply is written to the `rsvps` collection; the page shows
a running count of confirmed guests and a wishes wall built from the messages
guests leave. A guest who already replied on that device sees their answer
filled in and can edit it.

**WhatsApp mode** — anywhere else (GitHub Pages, a local file, any static
host), there is no storage available, so submitting composes a ready-to-send
WhatsApp message to `CONFIG.whatsapp`, falling back to a `mailto:` to
`CONFIG.email` if no number is set. The wishes wall stays empty.

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
