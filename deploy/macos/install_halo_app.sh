#!/bin/sh
# Install a Halo.app bundle from a release on this Mac.  The current app is
# kept as Halo.app.previous so a player can put it back if the new one fails.

set -eu

script_folder=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
app_source=${1:-"$script_folder/Halo.app"}
applications=/Applications
app_destination="$applications/Halo.app"
previous="$applications/Halo.app.previous"
staging="$applications/Halo.app.installing"

if [ ! -x "$app_source/Contents/MacOS/halo" ]; then
	echo "Halo.app was not found at $app_source" >&2
	echo "Pass the path to an extracted Halo.app bundle." >&2
	exit 1
fi
if [ -e "$previous" ]; then
	echo "$previous already exists; inspect or remove it before installing again." >&2
	exit 1
fi

sudo rm -rf "$staging"
sudo ditto "$app_source" "$staging"
if [ -e "$app_destination" ]; then
	sudo mv "$app_destination" "$previous"
fi
sudo mv "$staging" "$app_destination"
echo "Installed $app_destination"
if [ -e "$previous" ]; then
	echo "The previous app is at $previous"
fi
