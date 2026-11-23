#!/usr/bin/env node
// Builds and tests the packages that changed, and checks their versions. A package is a folder
// with a wraith.json, in groups like `games/<game>/` or `util/`, see findPackages.
//
//   node scripts/ci.mjs [--base <git ref>] [--all] [--dry-run]
//
// Without --base, or if the ref isn't there, everything builds. So does a change outside the
// packages, like to these scripts.

import { checkZigDependencies, compareVersions, error, findPackages, git, group, hasZigTests, manifestName, npmScripts, packageFiles, packageOf, publishedVersions, run, versionPattern, warning } from "./lib.mjs";
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

function parseArgs(argv) {
    const options = { base: null, all: false, dryRun: false };
    for (let i = 0; i < argv.length; i++) {
        const a = argv[i];
        if (a === "--base") options.base = argv[++i] || null;
        else if (a === "--all") options.all = true;
        else if (a === "--dry-run") options.dryRun = true;
        else throw new Error(`Unknown argument ${a}`);
    }
    return options;
}

/** Null if there's nothing to diff against. */
function usableBase(base) {
    // A new branch's push has no before
    if (!base || /^0+$/.test(base)) return null;
    if (git("rev-parse", "--verify", "--quiet", `${base}^{commit}`) === null) {
        console.log(`Can't find ${base}, so building everything`);
        return null;
    }
    return base;
}

/** Changed package folders, or null for all of them. */
function changedPackages(base, packages) {
    const diff = git("diff", "--name-only", `${base}...HEAD`);
    if (diff === null) return null;
    const changed = new Set();
    for (const file of diff.split("\n").filter(Boolean)) {
        const dir = packageOf(packages, file);
        if (dir) changed.add(dir);
        // Shared files like these scripts or the workflows can break any of them
        else if (file.startsWith("scripts/") || file.startsWith(".github/")) return null;
    }
    return changed;
}

/** Problems that stop a release. Warns about changes that won't ship. */
async function checkVersion(plugin, base, changed) {
    if (!plugin.version || !versionPattern.test(plugin.version)) {
        throw new Error(`${plugin.manifestFile} needs a "version" like "1.2.3"`);
    }
    const before = base && git("show", `${base}:${plugin.manifestFile}`);
    let old;
    try {
        // Only its version, so one from before a schema change still compares
        old = before ? JSON.parse(before.replace(/^\uFEFF/, "")).version : undefined;
    } catch {
        // Broken at the base, so nothing to compare with
    }
    if (old && versionPattern.test(old) && compareVersions(plugin.version, old) < 0) {
        throw new Error(`its version went back from ${old} to ${plugin.version}`);
    }
    if (changed && (await publishedVersions(plugin.name)).includes(plugin.version)) {
        warning(plugin.dir, `changed, but ${plugin.version} is released already. Bump its "version" to ship it`);
    }
}

const builders = {
    zig(plugin) {
        checkZigDependencies(plugin);
        run(plugin.path, "zig", ["fmt", "--check", "."]);
        run(plugin.path, "zig", ["build", "--summary", "all"]);
        if (hasZigTests(plugin)) run(plugin.path, "zig", ["build", "test", "--summary", "all"]);
    },
    js(plugin) {
        run(plugin.path, "npm", [existsSync(join(plugin.path, "package-lock.json")) ? "ci" : "install"]);
        run(plugin.path, "npm", ["run", "build"]);
        if (npmScripts(plugin).test) run(plugin.path, "npm", ["test"]);
    },
    /** Nothing to build, but it has to have something to run. */
    files(plugin) {
        const files = packageFiles(plugin.path);
        if (!files.includes(manifestName)) throw new Error(`no ${manifestName}`);
        if (plugin.kind === "plugin" && !files.some((f) => f === "main.lua" || f === "main.js")) throw new Error("a plugin with nothing to build needs a main.lua or main.js");
    },
};

async function main(argv) {
    const options = parseArgs(argv);
    const packages = findPackages();
    const base = usableBase(options.base);
    const changed = options.all || !base ? null : changedPackages(base, packages);
    const picked = [...packages.values()].filter((p) => !changed || changed.has(p.dir));
    if (picked.length === 0) {
        console.log("No packages changed");
        return 0;
    }
    console.log(`Building ${picked.map((p) => `${p.dir} (${p.builder})`).join(", ")}`);

    const failed = [];
    for (const pkg of picked) {
        await group(`${pkg.dir} (${pkg.builder})`, async () => {
            try {
                await checkVersion(pkg, base, changed !== null);
                if (!options.dryRun) builders[pkg.builder](pkg);
            } catch (e) {
                failed.push(pkg.dir);
                error(pkg.dir, e.message);
            }
        });
    }
    if (failed.length) {
        console.error(`Failed: ${failed.join(", ")}`);
        return 1;
    }
    console.log(`All ${picked.length} built`);
    return 0;
}

try {
    process.exitCode = await main(process.argv.slice(2));
} catch (e) {
    console.error(e.message);
    process.exitCode = 1;
}
