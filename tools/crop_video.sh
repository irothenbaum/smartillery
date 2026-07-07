#!/usr/bin/env bash
#
# Crops a rectangle (in the SOURCE recording's native pixel coordinates) out of a
# video, optionally resizing the result. Meant to run against the full-resolution
# original recording every time -- re-run with different X/Y/W/H (and --resize) as
# the select-ultimate render target changes, without ever re-recording footage.
#
# Requires: ffmpeg
#
# Usage:
#   tools/crop_video.sh INPUT X Y WIDTH HEIGHT OUTPUT [--resize WxH]
#
# Args:
#   INPUT        source video (the full-resolution original recording)
#   X Y          top-left corner of the crop rectangle, in source pixel coordinates
#   WIDTH HEIGHT size of the crop rectangle, in source pixel coordinates
#   OUTPUT       cropped (and optionally resized) output video
#   --resize WxH optional: scale the cropped rectangle down/up to WxH afterward
#
# Note: many video codecs require even width/height -- if ffmpeg complains about odd
# dimensions, nudge WIDTH/HEIGHT (or --resize's WxH) to the nearest even number.
#
# Examples:
#   tools/crop_video.sh origin_file.mp4 800 400 236 294 cropped_file.mp4
#   tools/crop_video.sh origin_file.mp4 800 400 472 588 cropped_file.mp4 --resize 236x294

set -euo pipefail

if [[ $# -lt 6 ]]; then
	sed -n '2,20p' "$0"
	exit 1
fi

INPUT="$1"
X="$2"
Y="$3"
WIDTH="$4"
HEIGHT="$5"
OUTPUT="$6"
shift 6

RESIZE=""
while [[ $# -gt 0 ]]; do
	case "$1" in
		--resize) RESIZE="$2"; shift 2 ;;
		-h|--help) sed -n '2,20p' "$0"; exit 0 ;;
		*) echo "Unknown argument: $1" >&2; exit 1 ;;
	esac
done

if ! command -v ffmpeg >/dev/null; then
	echo "Error: ffmpeg must be on PATH" >&2
	exit 1
fi

if [[ ! -f "$INPUT" ]]; then
	echo "Error: input file not found: $INPUT" >&2
	exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"

FILTERS="crop=${WIDTH}:${HEIGHT}:${X}:${Y}"
if [[ -n "$RESIZE" ]]; then
	IFS='x' read -r RESIZE_W RESIZE_H <<< "$RESIZE"
	FILTERS="${FILTERS},scale=${RESIZE_W}:${RESIZE_H}"
fi

echo "Cropping ${WIDTH}x${HEIGHT}+${X}+${Y} from $INPUT${RESIZE:+, resizing to $RESIZE}"
ffmpeg -y -i "$INPUT" -vf "$FILTERS" -c:a copy "$OUTPUT" -loglevel error

echo "Wrote $OUTPUT"
