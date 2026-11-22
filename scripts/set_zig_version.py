"""Sets the Zig version every package in mods needs, and the one CI uses.

Changes `.minimum_zig_version` in each build.zig.zon, and `ZIG_VERSION` in the CI workflow. Paths
are relative to this script.

    python scripts/set_zig_version.py 0.18.0-dev.1300+abcdef012
    python scripts/set_zig_version.py 0.18.0-dev.1300+abcdef012 --dry-run   # just say what'd change
"""

import argparse
import os
import re
import sys

MODS = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WORKFLOW = os.path.join(MODS, ".github", "workflows", "main_ci.yml")

# Not packages of ours, just build output and fetched dependencies
SKIP_DIRS = {"zig-pkg", ".zig-cache", "zig-out", "node_modules", ".git", "scripts", "release", "dist"}

# Like 0.15.1 or 0.18.0-dev.1260+833623422
VERSION = re.compile(r"^\d+\.\d+\.\d+(-[0-9A-Za-z.]+)?(\+[0-9A-Za-z.]+)?$")

ZON = re.compile(r'(\.minimum_zig_version\s*=\s*")([^"]*)(")')
CI = re.compile(r"^(\s*ZIG_VERSION:\s*)(\S+)(.*)$", re.MULTILINE)


def zons():
    for dirpath, dirnames, filenames in os.walk(MODS):
        dirnames[:] = sorted(d for d in dirnames if d not in SKIP_DIRS and not d.startswith("."))
        if "build.zig.zon" in filenames:
            yield os.path.join(dirpath, "build.zig.zon")


def update(path, pattern, version, dry_run):
    """True if it changed, or would have. Keeps the file's line endings."""
    with open(path, encoding="utf-8", newline="") as f:
        text = f.read()
    found = pattern.search(text)
    if not found:
        return False
    if found.group(2) == version:
        return False
    print(f"  {os.path.relpath(path, MODS)}: {found.group(2)} -> {version}")
    if not dry_run:
        with open(path, "w", encoding="utf-8", newline="") as f:
            f.write(pattern.sub(lambda m: m.group(1) + version + m.group(3), text))
    return True


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("version", help="like 0.18.0-dev.1260+833623422")
    parser.add_argument("--dry-run", action="store_true", help="just say what'd change")
    options = parser.parse_args()
    if not VERSION.match(options.version):
        sys.exit(f"{options.version} doesn't look like a Zig version, like 0.18.0-dev.1260+833623422")

    changed = sum(update(p, ZON, options.version, options.dry_run) for p in zons())
    if os.path.exists(WORKFLOW):
        changed += update(WORKFLOW, CI, options.version, options.dry_run)

    if changed == 0:
        print(f"Everything's on {options.version} already")
    elif options.dry_run:
        print(f"{changed} file(s) would change")
    else:
        print(f"Changed {changed} file(s)")


if __name__ == "__main__":
    main()
