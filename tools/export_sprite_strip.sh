#!/usr/bin/env bash
#
# Converts a video clip into a single PNG sprite strip (frames tiled left-to-right,
# top-to-bottom) suitable for GameMaker's Sprite Editor "import as strip" feature.
#
# Requires: ffmpeg, ffprobe
#
# Usage:
#   tools/export_sprite_strip.sh -i INPUT.mp4 -o OUTPUT.png [options]
#
# Options:
#   -i, --input FILE     input video (required)
#   -o, --output FILE    output PNG path (required)
#   -f, --fps N          sample rate in frames per second (default: 12)
#   -c, --crop WxH+X+Y   crop before tiling, e.g. 400x400+100+50 (optional)
#   -s, --scale WxH      scale each frame before tiling, e.g. 128x128 (optional)
#   --cols N             force column count (default: auto, near-square grid)
#
# Example:
#   tools/export_sprite_strip.sh -i raw/ult_strike.mov -o sprites_src/ult_strike_strip.png \
#       -f 15 -c 480x480+220+0 -s 128x128
#
# The printed frame count and grid size are what you enter into GameMaker's
# "Image is a strip" import dialog (Columns x Rows, and total image count).

set -euo pipefail

FPS=12
CROP=""
SCALE=""
COLS_OVERRIDE=""
INPUT=""
OUTPUT=""

usage() {
	sed -n '2,25p' "$0"
	exit 1
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		-i|--input) INPUT="$2"; shift 2 ;;
		-o|--output) OUTPUT="$2"; shift 2 ;;
		-f|--fps) FPS="$2"; shift 2 ;;
		-c|--crop) CROP="$2"; shift 2 ;;
		-s|--scale) SCALE="$2"; shift 2 ;;
		--cols) COLS_OVERRIDE="$2"; shift 2 ;;
		-h|--help) usage ;;
		*) echo "Unknown argument: $1" >&2; usage ;;
	esac
done

if [[ -z "$INPUT" || -z "$OUTPUT" ]]; then
	echo "Error: --input and --output are required" >&2
	usage
fi

if ! command -v ffmpeg >/dev/null || ! command -v ffprobe >/dev/null; then
	echo "Error: ffmpeg and ffprobe must both be on PATH" >&2
	exit 1
fi

if [[ ! -f "$INPUT" ]]; then
	echo "Error: input file not found: $INPUT" >&2
	exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"

# --- figure out how many sampled frames we'll actually get -------------------
DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$INPUT")
FRAME_COUNT=$(awk -v d="$DURATION" -v f="$FPS" 'BEGIN { printf "%d", (d * f) + 0.999 }')

if [[ "$FRAME_COUNT" -lt 1 ]]; then
	echo "Error: computed 0 frames -- check --fps and the input file" >&2
	exit 1
fi

# --- pick a grid that comfortably fits FRAME_COUNT ---------------------------
if [[ -n "$COLS_OVERRIDE" ]]; then
	COLS="$COLS_OVERRIDE"
else
	COLS=$(awk -v n="$FRAME_COUNT" 'BEGIN { printf "%d", sqrt(n) + 0.999 }')
fi
ROWS=$(awk -v n="$FRAME_COUNT" -v c="$COLS" 'BEGIN { printf "%d", (n / c) + 0.999 }')
GRID_CAPACITY=$((COLS * ROWS))
PAD_FRAMES=$((GRID_CAPACITY - FRAME_COUNT))

# --- build the filter chain ---------------------------------------------------
FILTERS="fps=${FPS}"
if [[ -n "$CROP" ]]; then
	# WxH+X+Y -> ffmpeg's crop=W:H:X:Y
	IFS='x+' read -r CW CH CX CY <<< "$CROP"
	FILTERS="${FILTERS},crop=${CW}:${CH}:${CX}:${CY}"
fi
if [[ -n "$SCALE" ]]; then
	IFS='x' read -r SW SH <<< "$SCALE"
	FILTERS="${FILTERS},scale=${SW}:${SH}"
fi
if [[ "$PAD_FRAMES" -gt 0 ]]; then
	# grid has more cells than sampled frames -- clone the last frame to fill it
	# so the tile filter gets exactly COLS*ROWS input frames
	FILTERS="${FILTERS},tpad=stop_mode=clone:stop=${PAD_FRAMES}"
fi
FILTERS="${FILTERS},tile=${COLS}x${ROWS}"

echo "Input duration: ${DURATION}s @ requested ${FPS}fps"
echo "Sampled frames: ${FRAME_COUNT}  ->  grid: ${COLS}x${ROWS} (${GRID_CAPACITY} cells, ${PAD_FRAMES} padded)"

# -frames:v 1 stops ffmpeg as soon as the tile filter emits its first full grid --
# this both avoids writing extra pages if the source has more frames than we need,
# and makes ffmpeg exit early instead of decoding the rest of a long source video
ffmpeg -y -i "$INPUT" -vf "$FILTERS" -frames:v 1 "$OUTPUT" -loglevel error

echo "Wrote $OUTPUT"
echo "GameMaker strip import: columns=${COLS}, rows=${ROWS}, image count=${FRAME_COUNT} (ignore the ${PAD_FRAMES} padded/duplicate trailing cell(s))"
