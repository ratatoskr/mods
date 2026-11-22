"""Points every package in mods at a newer Wraith, with `zig fetch --save=wraith`.

Each package that depends on wraith in its build.zig.zon gets it pinned to the commit the ref is at
now. Paths are relative to this script.

    python scripts/update_wraith.py                 # wraith's main branch as it is now
    python scripts/update_wraith.py --ref v0.4.0    # a tag, branch or commit
    python scripts/update_wraith.py --keep-going    # carry on past a package that fails
"""

import argparse
import os
import re
import subprocess
import sys

MODS = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WRAITH_URL = "git+https://github.com/ratatoskr/wraith"

# Not packages of ours, just build output and fetched dependencies
SKIP_DIRS = {"zig-pkg", ".zig-cache", "zig-out", "node_modules", ".git", "scripts", "release", "dist"}


def packages():
    """Folders with a build.zig.zon that depends on wraith."""
    found = []
    for dirpath, dirnames, filenames in os.walk(MODS):
        dirnames[:] = sorted(d for d in dirnames if d not in SKIP_DIRS and not d.startswith("."))
        if "build.zig.zon" not in filenames:
            continue
        with open(os.path.join(dirpath, "build.zig.zon"), encoding="utf-8") as f:
            if re.search(r"^\s*\.wraith\s*=", f.read(), re.MULTILINE):
                found.append(dirpath)
    return found


def pinned(path):
    """What it has wraith at, for saying what changed."""
    with open(os.path.join(path, "build.zig.zon"), encoding="utf-8") as f:
        m = re.search(r"\.wraith\s*=\s*\.\{[^}]*?\.url\s*=\s*\"[^\"#]*#?([^\"]*)\"", f.read(), re.DOTALL)
    return m.group(1) if m else "?"


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--ref", help="a tag, branch or commit of wraith. Its main branch if left out")
    parser.add_argument("--keep-going", action="store_true", help="carry on past a package that fails")
    options = parser.parse_args()

    url = f"{WRAITH_URL}#{options.ref}" if options.ref else WRAITH_URL
    found = packages()
    if not found:
        sys.exit("No packages in mods depend on wraith")

    failed = []
    for path in found:
        name = os.path.relpath(path, MODS)
        before = pinned(path)
        print(f"\n==> {name}: zig fetch --save=wraith {url}", flush=True)
        result = subprocess.run(["zig", "fetch", "--save=wraith", url], cwd=path)
        if result.returncode != 0:
            failed.append(name)
            if not options.keep_going:
                break
            continue
        after = pinned(path)
        print(f"   {before[:12]} -> {after[:12]}" if before != after else "   Already there", flush=True)

    if failed:
        sys.exit(f"\nFailed: {', '.join(failed)}")
    print(f"\nUpdated {len(found)} package(s). Run build_all.py to check they still build.")


if __name__ == "__main__":
    main()
