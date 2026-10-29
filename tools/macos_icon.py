#!/usr/bin/env python3
"""Make the macOS application bundle's icon (Halo.app/Contents/Resources/
halo.icns) from the shared OpenCE icon, with the system's sips.

Usage: macos_icon.py output.icns
"""

import subprocess
import sys
from pathlib import Path

SOURCE = Path("port/assets/icon/opence-icon.png")


def main():
    output = Path(sys.argv[1])
    subprocess.run(["sips", "-s", "format", "icns", str(SOURCE), "--out", str(output)], check=True,
                   stdout=subprocess.DEVNULL)


if __name__ == "__main__":
    main()
