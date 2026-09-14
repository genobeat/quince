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
THEME="$(grep -m1 -oE -- '--midnight: *#[0-9A-Fa-f]{6}' "$SRC" | grep -oE '#[0-9A-Fa-f]{6}')"
DESCRIPTION="Invitación interactiva de XV años — itinerario, corte de honor, ubicación y confirmación de asistencia."

{
  cat <<HEAD
<!doctype html>
<!--
  ============================================================
  GENERATED FILE - DO NOT EDIT.

  This file is built from src/page.html by scripts/build.sh, and any
  edit made here is overwritten on the next build. Change the event
  details in the CONFIG block of src/page.html instead, then run:

      ./scripts/build.sh

  ============================================================
-->
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="color-scheme" content="dark">
<meta name="theme-color" content="${THEME}">
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
