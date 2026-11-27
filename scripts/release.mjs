#!/usr/bin/env node

import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readFileSync, readdirSync, rmSync, statSync, writeFileSync } from "node:fs";
import { join, relative } from "node:path";
import { atLeast, buildNative, checkZigDependencies, error, findPackages, git, group, hasZigTests, manifestName, npmScripts, packageFiles, packagedManifest, publishedVersions, root, run, syncVersions, versionPattern, zip } from "./lib.mjs";

const out = join(root, "release");
const unreleased = "0.0.0";
const listFile = join(out, "releases.json");
const publishedFile = join(out, "published.json");
const hub = (process.env.HUB_URL ?? "https://hub.wraith.io").replace(/\/+$/, "");

const packers = {
    zig(plugin) {
        checkZigDependencies(plugin);
        if (hasZigTests(plugin)) run(plugin.path, "zig", ["build", "test", "--summary", "all"]);
        const stage = join(out, "stage", plugin.name);
        rmSync(stage, { recursive: true, force: true });
        run(plugin.path, "zig", ["build", "-Doptimize=ReleaseFast", "--prefix", stage, "--summary", "all"]);
        return zipStage(plugin, stage);
    },

    async rust(plugin) {
        run(plugin.path, "cargo", ["test", "--release"]);
        return zipNative(plugin);
    },
    cmake: zipNative,
    cs: zipNative,

    js(plugin) {
        run(plugin.path, "npm", [existsSync(join(plugin.path, "package-lock.json")) ? "ci" : "install"]);
        if (npmScripts(plugin).test) run(plugin.path, "npm", ["test"]);
        run(plugin.path, "npm", ["run", "pack"]);
        return readFileSync(join(plugin.path, `${plugin.name}-${plugin.version}.zip`));
    },

    files(pkg) {
        return zip(
            packageFiles(pkg.path).map((f) => {
                const data = readFileSync(join(pkg.path, f));
                return { name: `${pkg.name}/${f}`, data: f === manifestName ? Buffer.from(packagedManifest(data.toString("utf8"), pkg.path)) : data };
            }),
        );
    },
};

/** A release build of a Rust, CMake or C# package, zipped. */
async function zipNative(plugin) {
    const stage = join(out, "stage", plugin.name);
    await buildNative(plugin, { release: true, out: stage });
    return zipStage(plugin, stage);
}

/** What's in `stage`, under the plugin's name, with its wraith.json as it goes on the Hub. */
function zipStage(plugin, stage) {
    // The Hub takes the id and version from here
    const staged = join(stage, manifestName);
    writeFileSync(staged, packagedManifest(readFileSync(existsSync(staged) ? staged : join(plugin.path, manifestName), "utf8"), plugin.path));
    const entries = files(stage)
        .filter((f) => !f.endsWith(".pdb"))
        .map((f) => ({ name: `${plugin.name}/${relative(stage, f).replaceAll("\\", "/")}`, data: readFileSync(f) }));
    return zip(entries);
}

function files(dir) {
    return readdirSync(dir)
        .sort()
        .flatMap((name) => {
            const path = join(dir, name);
            return statSync(path).isDirectory() ? files(path) : [path];
        });
}

const sha256 = (bytes) => createHash("sha256").update(bytes).digest("hex");

/** The ones they depend on first, so they're published first too. */
function dependenciesFirst(plugins) {
    const byName = new Map(plugins.map((p) => [p.name, p]));
    const ordered = [];
    const seen = new Set();
    const visit = (p) => {
        if (seen.has(p.name)) return;
        seen.add(p.name);
        for (const d of p.depends) {
            const dep = byName.get(d.split("@")[0]);
            if (dep) visit(dep);
        }
        ordered.push(p);
    };
    plugins.forEach(visit);
    return ordered;
}

/** Why it can't go out yet: something it depends on that isn't on the Hub or going with it. */
async function missingDependency(plugin, releasing) {
    for (const d of plugin.depends) {
        const [name, min] = d.split("@");
        const versions = [...(await publishedVersions(name)), ...releasing.filter((r) => r.name === name).map((r) => r.version)];
        if (!versions.some((v) => !min || atLeast(v, min))) {
            return `it depends on ${d}, which isn't on the Hub. Release ${name} first`;
        }
    }
    return null;
}

async function build(args) {
    const only = args.only?.replaceAll("\\", "/");
    const plugins = dependenciesFirst([...findPackages().values()].filter((p) => !only || p.dir === only));
    if (only && plugins.length === 0) throw new Error(`No package in ${only}`);
    mkdirSync(out, { recursive: true });
    const releases = [];
    const failed = [];
    for (const plugin of plugins) {
        if (!plugin.version || !versionPattern.test(plugin.version)) {
            failed.push(plugin.dir);
            error(plugin.dir, `${plugin.manifestFile} needs a "version" like "1.2.3"`);
            continue;
        }
        if (plugin.version === unreleased) {
            console.log(`${plugin.dir} is ${unreleased}, so it isn't released`);
            continue;
        }
        if ((await publishedVersions(plugin.name)).includes(plugin.version)) continue;
        const missing = await missingDependency(plugin, releases);
        if (missing) {
            failed.push(plugin.dir);
            error(plugin.dir, `${plugin.name} ${plugin.version} can't go out: ${missing}`);
            continue;
        }
        await group(`${plugin.dir} ${plugin.version} (${plugin.builder})`, async () => {
            try {
                const synced = syncVersions(plugin);
                if (synced.length) console.log(`Set ${synced.join(", ")} to ${plugin.version}`);
                const bytes = await packers[plugin.builder](plugin);
                const file = join(out, `${plugin.name}-${plugin.version}.zip`);
                writeFileSync(file, bytes);
                releases.push({ name: plugin.name, version: plugin.version, file, sha256: sha256(bytes), synced: synced.map((f) => `${plugin.dir}/${f}`) });
                console.log(`${plugin.name} ${plugin.version}: ${bytes.length} bytes`);
            } catch (e) {
                failed.push(plugin.dir);
                error(plugin.dir, e.message);
            }
        });
    }
    rmSync(join(out, "stage"), { recursive: true, force: true });
    writeFileSync(listFile, JSON.stringify(releases, null, 2) + "\n");
    console.log(releases.length ? `To release: ${releases.map((r) => `${r.name} ${r.version}`).join(", ")}` : "Nothing to release");

    return failed.length ? 1 : 0;
}

async function hubError(response) {
    const text = await response.text();
    try {
        const body = JSON.parse(text);
        const problems = Array.isArray(body.problems) && body.problems.length ? `: ${body.problems.map((p) => (typeof p === "string" ? p : JSON.stringify(p))).join("; ")}` : "";
        return `${response.status} ${body.error ?? text}${problems}`;
    } catch {
        return `${response.status} ${text || response.statusText}`;
    }
}

async function publish() {
    const releases = JSON.parse(readFileSync(listFile, "utf8"));
    const token = process.env.HUB_TOKEN;
    if (!token) throw new Error("HUB_TOKEN isn't set");
    const published = [];
    const failed = [];
    for (const r of releases) {
        try {
            const response = await fetch(`${hub}/api/v1/upload?publish=1`, {
                method: "POST",
                headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/zip" },
                body: readFileSync(r.file),
            });
            if (response.status === 409) {
                console.log(`${r.name} ${r.version} is published already, keeping it`);
            } else if (!response.ok) {
                throw new Error(`the Hub said ${await hubError(response)}`);
            } else {
                const body = await response.json();
                if ((body.id && body.id !== r.name) || (body.version && body.version !== r.version)) {
                    throw new Error(`the Hub took it as ${body.id} ${body.version}`);
                }
                console.log(`Published ${body.id} ${body.version} (${body.state})`);
            }
            published.push(r);
        } catch (e) {
            failed.push(r.name);
            error(r.name, e.message);
        }
    }
    writeFileSync(publishedFile, JSON.stringify(published, null, 2) + "\n");
    console.log(published.length ? `On the Hub: ${published.map((r) => `${r.name} ${r.version}`).join(", ")}` : "Nothing published");
    return failed.length ? 1 : 0;
}

async function tag() {
    if (!existsSync(publishedFile)) return 0;
    const published = JSON.parse(readFileSync(publishedFile, "utf8"));
    const tags = published.map((r) => `${r.name}@${r.version}`);

    const remote = new Set((git("ls-remote", "--tags", "origin") ?? "").split("\n").map((line) => line.split("\t")[1]));
    const fresh = tags.filter((t) => !remote.has(`refs/tags/${t}`));
    if (fresh.length === 0) {
        console.log("Nothing to tag");
        return 0;
    }

    const synced = published.flatMap((r) => r.synced ?? []);
    if (synced.length) {
        run(root, "git", ["add", "--", ...synced]);
        const bot = ["-c", "user.name=github-actions[bot]", "-c", "user.email=41898282+github-actions[bot]@users.noreply.github.com", "-c", "commit.gpgSign=false"];
        run(root, "git", [...bot, "commit", "--quiet", "-m", `Release ${fresh.join(", ")}`]);
    }

    for (const t of fresh) run(root, "git", ["-c", "tag.gpgSign=false", "tag", t]);
    run(root, "git", ["push", "origin", ...fresh.map((t) => `refs/tags/${t}`)]);
    return 0;
}

function parseArgs(argv) {
    const args = {};
    for (let i = 0; i < argv.length; i++) {
        if (!argv[i].startsWith("--")) throw new Error(`Unexpected ${argv[i]}`);
        args[argv[i].slice(2)] = argv[++i];
    }
    return args;
}

const commands = { build, publish, tag };
try {
    const [name, ...rest] = process.argv.slice(2);
    const command = commands[name];
    if (!command) throw new Error(`Usage: node scripts/release.mjs ${Object.keys(commands).join("|")} [options]`);
    process.exitCode = await command(parseArgs(rest));
} catch (e) {
    console.error(e.message);
    process.exitCode = 1;
}
