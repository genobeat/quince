# Portraits

Three photos spaced down the page: after the opening divider, before the court
of honor, and before the RSVP.

Drop them here as `photo.jpg`, `photo2.jpg` and `photo3.jpg` — the paths
`CONFIG.photos` already points at — and run `./scripts/build.sh`. To use other
filenames, edit that array instead.

- **Shape:** the frame is 4:5 portrait. Any image works; the middle is filled
  and the overflow cropped, so a portrait-orientation photo loses the least.
- **Size:** around 1200px on the long edge is plenty. Keep it under about 1 MB
  so guests on phone data are not waiting on it.
- **Format:** `.jpg` for photographs, `.webp` if you have it.

A slot whose file is missing or unreadable shows a placeholder frame instead of
a broken image, so the layout reads before the photos exist. Set an entry to
`null` to remove that slot from the page altogether.
