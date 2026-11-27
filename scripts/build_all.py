"""Builds every zig package in mods with a plain `zig build`, on the wraith and tuft each one pins.

No forks, so this is how they build for anyone else. Paths are relative to this script.
`node scripts/ci.mjs --all` builds the other kinds too.

    python scripts/build_all.py                 # build everything, stop at the first failure
    python scripts/build_all.py --keep-going    # build the rest after a failure
    python scripts/build_all.py -- -Doptimize=ReleaseSafe   # anything after -- goes to every zig build
"""

import argparse
import os
import shutil
import subprocess
import sys
import time

MODS = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Not packages of ours, just build output and fetched dependencies
SKIP_DIRS = {"zig-pkg", ".zig-cache", "zig-out", "node_modules", ".git", "scripts", "release", "dist"}


def packages():
    found = []
    for dirpath, dirnames, filenames in os.walk(MODS):
        dirnames[:] = sorted(d for d in dirnames if d not in SKIP_DIRS and not d.startswith("."))
        if "build.zig.zon" in filenames and "build.zig" in filenames:
            found.append(dirpath)
    return found


def run(path, args):
    print(f"\n==> {os.path.relpath(path, MODS)}: {' '.join(args)}", flush=True)
    result = subprocess.run(args, cwd=path, capture_output=True, text=True)
    sys.stdout.write(result.stdout)
    sys.stderr.write(result.stderr)
    return result


def build(path, extra):
    args = ["zig", "build", *extra]
    result = run(path, args)
    # A fetch that got cut off leaves zig-pkg missing files, so fetch it again
    if result.returncode != 0 and "FileNotFound" in result.stderr and "zig-pkg" in result.stderr:
        print("   zig-pkg looks half fetched. Removing it and building again", flush=True)
        shutil.rmtree(os.path.join(path, "zig-pkg"), ignore_errors=True)
        result = run(path, args)
    if result.returncode != 0 and "AccessDenied" in result.stderr:
        print("   Something has its output open, like a game with Wraith in it. Close it and build again", flush=True)
    return result.returncode == 0


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--keep-going", action="store_true", help="build the rest after a failure")
    parser.add_argument("extra", nargs="*", help="passed to every zig build, after --")
    options = parser.parse_args()

    found = packages()
    if not found:
        sys.exit("No packages found in mods")

    failed = []
    started = time.monotonic()
    for path in found:
        if build(path, options.extra):
            continue
        failed.append(os.path.relpath(path, MODS))
        if not options.keep_going:
            break

    took = time.monotonic() - started
    print()
    if failed:
        print(f"Failed after {took:.0f}s: {', '.join(failed)}")
        sys.exit(1)
    print(f"Built {len(found)} in {took:.0f}s")


if __name__ == "__main__":
    main()
