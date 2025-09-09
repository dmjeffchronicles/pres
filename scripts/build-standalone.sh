#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <input.(md|json)> <output.html> [template.html]" >&2
  exit 2
fi

IN="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
OUT="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
TPL="${3:-}"
if [ -z "$TPL" ]; then
  TPL="$(cd "$(dirname "$0")"/.. && pwd)/index.html"
else
  TPL="$(cd "$(dirname "$TPL")" && pwd)/$(basename "$TPL")"
fi

ROOT="$(cd "$(dirname "$0")"/.. && pwd)"
PICO="$ROOT/vendor/pico.min.css"
MERMAID="$ROOT/vendor/mermaid.min.js"
MARKED="$ROOT/vendor/marked.min.js"

ext="${IN##*.}"
lower_ext="$(printf '%s' "$ext" | tr 'A-Z' 'a-z')"

if [ "$lower_ext" = "md" ]; then
  PAYLOAD_TMP="$(mktemp)"
  # Escape </script> within the markdown payload to avoid premature tag termination
  # Wrap in <!-- --> to match viewer's getEmbeddedMarkdown() contract
  {
    printf '<script type="text/markdown" id="presentation-md"><!--\n'
    # Replace literal </script> with <\/script>
    sed 's#</script>#<\\/script>#g' "$IN"
    printf '\n--></script>\n'
  } > "$PAYLOAD_TMP"
elif [ "$lower_ext" = "json" ]; then
  PAYLOAD_TMP="$(mktemp)"
  {
    printf '<script type="application/json" id="presentation-json">\n'
    # Escape literal </script> inside JSON strings just in case
    sed 's#</script>#<\\/script>#g' "$IN"
    printf '\n</script>\n'
  } > "$PAYLOAD_TMP"
else
  echo "Input must be .md or .json" >&2
  exit 2
fi

# AWK program:
# - Inline pico css, mermaid js, marked js
# - Inject payload right before </body>
# - Remove any existing embedded script blocks and export button lines
awk -v pico="$PICO" -v mermaid="$MERMAID" -v marked="$MARKED" -v payload="$PAYLOAD_TMP" '
  function slurp(path,   s, line) { s=""; while ((getline line < path) > 0) s = s line "\n"; close(path); return s; }
  BEGIN {
    pc = slurp(pico);
    mj = slurp(mermaid);
    mk = slurp(marked);
    pl = slurp(payload);
    in_embedded_md = 0;
    in_embedded_json = 0;
  }
  {
    line = $0

    # Skip export button lines (best-effort)
    if (line ~ /id=["'\''"]export-html["'\''"]/ ) next

    # Handle embedded script blocks - remove existing ones
    if (line ~ /<script[^>]*type="text\/markdown"[^>]*id="presentation-md"/) {
      in_embedded_md = 1;
      next;
    }
    if (in_embedded_md) {
      if (line ~ /<\/script>/) {
        in_embedded_md = 0;
      }
      next;
    }

    if (line ~ /<script[^>]*type="application\/json"[^>]*id="presentation-json"/) {
      in_embedded_json = 1;
      next;
    }
    if (in_embedded_json) {
      if (line ~ /<\/script>/) {
        in_embedded_json = 0;
      }
      next;
    }

    # Inline vendor css/js by replacing their tags
    if (line ~ /href=["'\''"]vendor\/pico\.min\.css["'\''"]/ ) {
      print "<style>\n/* inlined pico.min.css */\n" pc "</style>";
      next
    }
    if (line ~ /src=["'\''"]vendor\/mermaid\.min\.js["'\''"]/ ) {
      print "<script>\n/* inlined mermaid.min.js */\n" mj "</script>";
      next
    }
    if (line ~ /src=["'\''"]vendor\/marked\.min\.js["'\''"]/ ) {
      print "<script>\n/* inlined marked.min.js */\n" mk "</script>";
      next
    }
    # Inject payload before </body>
    if (line ~ /<\/body>/) {
      print pl
      print line
      next
    }
    print line
  }
' "$TPL" > "$OUT"

rm -f "$PAYLOAD_TMP"

echo "Built: $OUT"
