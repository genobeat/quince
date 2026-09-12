#!/usr/bin/env bash
# Wraps src/page.html (the single source of truth) into a standalone
# index.html for static hosting such as GitHub Pages.
#
#   src/page.html  -> published as-is by the Artifact tool (it supplies
#                     its own <!doctype>/<head>/<body> skeleton)
#   index.html     -> generated here, a complete HTML5 document
#
# Run after every edit to src/page.html:  ./scripts/build.sh
set -euo pipefail

cd "$(dirname "$0")/.."

SRC="src/page.html"
OUT="index.html"

TITLE_LINE="$(grep -m1 '<title>' "$SRC")"
DESCRIPTION="Invitación interactiva de XV años — itinerario, corte de honor, ubicación y confirmación de asistencia."

{
  cat <<HEAD
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="color-scheme" content="dark">
<meta name="theme-color" content="#080B18">
<meta name="description" content="${DESCRIPTION}">
<meta property="og:type" content="website">
<meta property="og:description" content="${DESCRIPTION}">
${TITLE_LINE}
<meta property="og:title" content="$(printf '%s' "$TITLE_LINE" | sed -e 's|<title>||' -e 's|</title>||')">
</head>
<body>
HEAD

  # Everything from the source except its <title> line, which moved to <head>.
  sed '0,\|<title>|{\|<title>|d}' "$SRC"

  cat <<'FOOT'
</body>
</html>
FOOT
} > "$OUT"

echo "built $OUT ($(wc -l < "$OUT") lines) from $SRC"
