import { spawnSync } from "node:child_process";
import { existsSync, readFileSync, readdirSync, statSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { crc32, deflateRawSync } from "node:zlib";

export const root = join(dirname(fileURLToPath(import.meta.url)), "..");
export const github = !!process.env.GITHUB_ACTIONS;
export const versionPattern = /^\d+\.\d+\.\d+$/;

export const manifestName = "wraith.json";
/** Where the Hub's public files are, like each package's published versions. */
export const dist = (process.env.HUB_DIST_URL ?? "https://dist.wraith.io/hub").replace(/\/+$/, "");

/** Never packages or groups of them. */
const skipped = new Set(["scripts", "release", "node_modules", "zig-out", "zig-pkg", "dist"]);
/** How deep groups go, like `games/<game>/<mod>`. */
const maxDepth = 4;

export function findPackages() {
    const packages = new Map();
    const ids = new Map();
    const walk = (rel, depth) => {
        const path = rel ? join(root, rel) : root;
        if (rel && existsSync(join(path, manifestName))) {
            const dir = rel.replaceAll("\\", "/");
            const manifestFile = `${dir}/${manifestName}`;
            const manifest = readManifest(readFileSync(join(path, manifestName), "utf8"), manifestFile);
            if (!manifest.id) throw new Error(`${manifestFile} needs an "id"`);
            if (ids.has(manifest.id)) throw new Error(`${dir} and ${ids.get(manifest.id)} both have the id "${manifest.id}"`);
            ids.set(manifest.id, dir);
            const builder = existsSync(join(path, "build.zig")) ? "zig" : existsSync(join(path, "package.json")) ? "js" : "files";
            packages.set(dir, { dir, path, name: manifest.id, kind: manifest.kind ?? "plugin", manifestFile, builder, version: manifest.version, depends: manifest.depends ?? [] });
            return;
        }
        if (depth === maxDepth) return;
        for (const name of readdirSync(path).sort()) {
            if (name.startsWith(".") || skipped.has(name) || !statSync(join(path, name)).isDirectory()) continue;
            walk(rel ? join(rel, name) : name, depth + 1);
        }
    };
    walk("", 0);
    return packages;
}

export function packageOf(packages, file) {
    for (const dir of packages.keys()) if (file.startsWith(`${dir}/`)) return dir;
    return null;
}

export async function publishedVersions(id) {
    try {
        const response = await fetch(`${dist}/v1/packages/${id}.json`);
        if (!response.ok) return [];
        const index = await response.json();
        return (index.versions ?? []).map((v) => v.version);
    } catch {
        return [];
    }
}

export function readManifest(text, file = manifestName) {
    try {
        return JSON.parse(text.replace(/^\uFEFF/, ""));
    } catch (e) {
        throw new Error(`${file} isn't valid JSON: ${e.message}`);
    }
}

/**
 * wraith.json as it goes in a package: without devDepends, which the Hub won't take, and with
 * descriptionFile's text as description. `dir` is wraith.json's folder.
 */
export function packagedManifest(text, dir) {
    const m = readManifest(text);
    if (m.devDepends === undefined && m.descriptionFile === undefined) return text;
    delete m.devDepends;
    if (m.descriptionFile !== undefined) {
        if (m.description !== undefined) throw new Error(`${manifestName} has description and descriptionFile. Keep one`);
        m.description = readFileSync(join(dir, m.descriptionFile), "utf8").replace(/^\uFEFF/, "").trim();
        delete m.descriptionFile;
    }
    return JSON.stringify(m, null, 2) + "\n";
}

/** Whether `version` is at least `min`, which can be short like `1.2`. */
export function atLeast(version, min) {
    const pad = (v) => [...v.split("."), "0", "0"].slice(0, 3).join(".");
    return compareVersions(pad(version), pad(min)) >= 0;
}

export function compareVersions(a, b) {
    const pa = a.split(".").map(Number);
    const pb = b.split(".").map(Number);
    for (let i = 0; i < 3; i++) if (pa[i] !== pb[i]) return pa[i] - pb[i];
    return 0;
}

export function git(...args) {
    const r = spawnSync("git", args, { cwd: root, encoding: "utf8" });
    return r.status === 0 ? r.stdout : null;
}

export function run(cwd, command, args) {
    const line = `${command} ${args.join(" ")}`;
    console.log(`> ${line}`);

    const r = spawnSync(command, args, { cwd, stdio: "inherit", shell: process.platform === "win32" && command === "npm" });
    if (r.error) throw new Error(`${line}: ${r.error.message}`);
    if (r.status !== 0) throw new Error(`${line} exited with ${r.status}`);
}

export function checkZigDependencies(plugin) {
    const zon = readFileSync(join(plugin.path, "build.zig.zon"), "utf8");
    const local = [...zon.matchAll(/\.(\w+) = \.\{\s*\.path = "([^"]*)"/g)].map((m) => `${m[1]} (${m[2]})`);
    if (local.length) throw new Error(`build.zig.zon takes ${local.join(", ")} from a folder. For a package in this repo, name it in wraith.json's devDepends instead`);
}

export function hasZigTests(pkg) {
    return /b\.step\(\s*"test"/.test(readFileSync(join(pkg.path, "build.zig"), "utf8"));
}

const zonVersion = /^(\s*\.version\s*=\s*")([^"]*)(")/m;

export function syncVersions(pkg) {
    const changed = [];
    const zon = join(pkg.path, "build.zig.zon");
    if (existsSync(zon)) {
        // Not JSON, so just its .version line
        const text = readFileSync(zon, "utf8");
        const old = zonVersion.exec(text)?.[2];
        if (old === undefined) throw new Error("build.zig.zon has no .version");
        if (old !== pkg.version) {
            writeFileSync(zon, text.replace(zonVersion, (_, before, _old, after) => `${before}${pkg.version}${after}`));
            changed.push("build.zig.zon");
        }
    }
    const npm = join(pkg.path, "package.json");
    const old = existsSync(npm) ? JSON.parse(readFileSync(npm, "utf8")).version : undefined;
    if (old !== undefined && old !== pkg.version) {
        run(pkg.path, "npm", ["version", pkg.version, "--no-git-tag-version", "--allow-same-version"]);
        changed.push("package.json");
        if (existsSync(join(pkg.path, "package-lock.json"))) changed.push("package-lock.json");
    }
    return changed;
}

export function npmScripts(pkg) {
    return JSON.parse(readFileSync(join(pkg.path, "package.json"), "utf8")).scripts ?? {};
}

const devOnly = new Set([".git", ".gitignore", ".wraith", ".luarc.json", ".vscode", "node_modules", "zig-out", ".zig-cache", "zig-pkg"]);

export function packageFiles(dir, under = "") {
    return readdirSync(join(dir, under))
        .sort()
        .flatMap((name) => {
            if (devOnly.has(name) || name.endsWith(".zip")) return [];
            const rel = under ? `${under}/${name}` : name;
            return statSync(join(dir, rel)).isDirectory() ? packageFiles(dir, rel) : [rel];
        });
}

export async function group(title, body) {
    if (github) console.log(`::group::${title}`);
    try {
        return await body();
    } finally {
        if (github) console.log("::endgroup::");
    }
}

export function error(title, message) {
    console.error(github ? `::error title=${title}::${message}` : `${title}: ${message}`);
}

export function warning(title, message) {
    console.log(github ? `::warning title=${title}::${message}` : `warning: ${title}: ${message}`);
}

export function zip(entries) {
    const locals = [];
    const centrals = [];
    let offset = 0;
    for (const { name, data } of entries) {
        const path = Buffer.from(name, "utf8");
        const deflated = deflateRawSync(data, { level: 9 });
        const method = deflated.length < data.length ? 8 : 0;
        const body = method === 8 ? deflated : data;
        const crc = crc32(data) >>> 0;
        const header = (size, signature) => {
            const h = Buffer.alloc(size);
            h.writeUInt32LE(signature, 0);
            return h;
        };
        const local = header(30, 0x04034b50);
        local.writeUInt16LE(20, 4);
        local.writeUInt16LE(0x0800, 6); // UTF-8 names
        local.writeUInt16LE(method, 8);
        local.writeUInt16LE(0x0021, 12); // 1980-01-01
        local.writeUInt32LE(crc, 14);
        local.writeUInt32LE(body.length, 18);
        local.writeUInt32LE(data.length, 22);
        local.writeUInt16LE(path.length, 26);
        locals.push(local, path, body);

        const central = header(46, 0x02014b50);
        central.writeUInt16LE(20, 4);
        central.writeUInt16LE(20, 6);
        central.writeUInt16LE(0x0800, 8);
        central.writeUInt16LE(method, 10);
        central.writeUInt16LE(0x0021, 14);
        central.writeUInt32LE(crc, 16);
        central.writeUInt32LE(body.length, 20);
        central.writeUInt32LE(data.length, 24);
        central.writeUInt16LE(path.length, 28);
        central.writeUInt32LE(offset, 42);
        centrals.push(central, path);
        offset += local.length + path.length + body.length;
    }
    const directory = Buffer.concat(centrals);
    const end = Buffer.alloc(22);
    end.writeUInt32LE(0x06054b50, 0);
    end.writeUInt16LE(entries.length, 8);
    end.writeUInt16LE(entries.length, 10);
    end.writeUInt32LE(directory.length, 12);
    end.writeUInt32LE(offset, 16);
    return Buffer.concat([...locals, directory, end]);
}
