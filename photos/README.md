# Portrait

The photo that sits between the countdown and the invitation.

Drop the image here, then point `CONFIG.photo.src` in `src/page.html` at it —
for example `photos/ashley.jpg` — and run `./scripts/build.sh`.

- **Shape:** the frame is 4:5 portrait. Any image works; the middle is filled
  and the overflow cropped, so a portrait-orientation photo loses the least.
- **Size:** around 1200px on the long edge is plenty. Keep it under about 1 MB
  so guests on phone data are not waiting on it.
- **Format:** `.jpg` for photographs, `.webp` if you have it.

Leave `src` as `""` and the frame shows a placeholder instead, so the layout is
still visible. A file that is missing or unreadable falls back to the same
placeholder rather than a broken image.
