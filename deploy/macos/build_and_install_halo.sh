#!/bin/sh
# Build the native Apple-silicon Halo.app bundle, then install it in
# /Applications. Run this from any checkout of this repository.

set -eu

script_folder=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repository=$(CDPATH= cd -- "$script_folder/../.." && pwd)

if ! command -v ninja >/dev/null 2>&1; then
	echo "ninja is required; see port/macos/README.md." >&2
	exit 1
fi

cd "$repository"
python3 configure.py
ninja macos_app
exec "$script_folder/install_halo_app.sh" "$repository/build/macos/Halo.app"
