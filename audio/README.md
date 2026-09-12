# Music

Put the song here as `song.mp3` and it plays automatically.

The page looks for `audio/song.mp3` — the path set in `CONFIG.music.src` in
`src/page.html`. Until that file exists the player hides itself, so the page
is never broken by a missing song.

- **Format:** `.mp3` is the safe choice; every browser plays it. `.m4a` and
  `.ogg` also work but not everywhere.
- **Size:** keep it under about 5 MB. Guests on phone data wait for this file,
  so a trimmed 60–90 second clip beats a full track.
- **Different filename?** Update `CONFIG.music.src` in `src/page.html` and run
  `./scripts/build.sh`.
- **Turn music off entirely:** set `CONFIG.music.src` to `""`.

`CONFIG.music.title` is optional; when set it appears beside the button on wide
screens and as the button's tooltip.
