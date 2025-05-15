#!/usr/bin/env bash


FILE="$1"
COMMENT_BLOCK_START="$2"
COMMENT_BLOCK_END="END $2"
UNCOMMENT_BLOCK_START="$3"
UNCOMMENT_BLOCK_END="END $3"
COMMENT_CHAR="${4:-#}"

if [[ ! -f "$FILE" ]]; then
  echo "File not found: $FILE"
  exit 1
fi

echo "Working on $FILE..."

awk -v c_start="$COMMENT_BLOCK_START" -v c_end="$COMMENT_BLOCK_END" \
    -v u_start="$UNCOMMENT_BLOCK_START" -v u_end="$UNCOMMENT_BLOCK_END" \
    -v comment_char="$COMMENT_CHAR" '
  BEGIN {
    in_comment_block = 0
    in_uncomment_block = 0
  }

  {
    if ($0 ~ c_end) {
      in_comment_block = 0
      print
      next
    } else if ($0 ~ c_start) {
      in_comment_block = 1
      in_uncomment_block = 0
      print
      next
    }

    if ($0 ~ u_end) {
      in_uncomment_block = 0
      print
      next
    } else if ($0 ~ u_start) {
      in_uncomment_block = 1
      in_comment_block = 0
      print
      next
    }

    if (in_comment_block) {
      # Comment if not already commented
      if ($0 ~ "^\\s*" comment_char) print
      else print comment_char " " $0
    } else if (in_uncomment_block) {
      # Uncomment if already commented
      sub("^\\s*" comment_char "\\s?", "")
      print
    } else {
      print
    }
  }
' "$FILE" > "$FILE.tmp" && mv "$FILE.tmp" "$FILE"

echo "✔ Switched $UNCOMMENT_BLOCK_START to $COMMENT_BLOCK_START"
